/******************************************************************************************************************************************
* Class Name   : Request_TriggerHandler
* Description  : Copying the study molecules from study record and adding them to request record if therapeutic area is same.
* Created By   : Deloitte Consulting
*
*****************************************************************************************************************************************/
Public with sharing class Request_TriggerHandler {


    /*
    * @Method Name                    :  insertRequestMoleculesFromStudy
    * @Description                    :  Method to Insert Request Molecules from Study
    * @Return Type                    :  void
    * @Parameters                     :  lRequests
    */
    Public static void insertRequestMoleculesFromStudy(list < Request__c > lRequests) {

        //Adding all study IDs to a set
        set < id > sStudyIDs = New set < id > ();

        for (Request__c oReq : lRequests) {
            if (oReq.Related_Project__c != NULL) {
                sStudyIDs.add(oReq.Related_Project__c);
            }
        }

        //Declaring a map of Study to its associated Molecules
        Map < id, list < DRDP_Study_Molecule__c >> lMapOfStudyAndItsMolecules = new Map < id, list < DRDP_Study_Molecule__c >> ();

        //Adding all the molecules associated to studies to a list
        List < DRDP_Study_Molecule__c > lMolecules = [SELECT Molecule__c, Project__c from DRDP_Study_Molecule__c Where Project__c in : sStudyIDs];
        //Constructing the Map of Study to its associated Molecules
        If(lMolecules.size() > 0) {
            for (DRDP_Study_Molecule__c oMol : lMolecules) {
                List < DRDP_Study_Molecule__c > tempMolList = new List < DRDP_Study_Molecule__c > ();
                if (lMapOfStudyAndItsMolecules.get(oMol.Project__c) != NULL) {
                    tempMolList = lMapOfStudyAndItsMolecules.get(oMol.Project__c);
                    tempMolList.add(oMol);
                } else {
                    tempMolList.add(oMol);
                }
                lMapOfStudyAndItsMolecules.put(oMol.Project__c, tempMolList);
            }
        }

        //Declaring a list of request molecules to be inserted
        list < DRDP_Request_Molecule__c > lRequestMolecules = new list < DRDP_Request_Molecule__c > ();

        //looping over requests that are inserted and adding request molecules
        for (Request__c oReq : [SELECT id, Related_Project__c from Request__C where id in: lRequests AND RecordType.DeveloperName NOT IN ('Partnership_Exploration')]) {
            if (oReq.Related_Project__c != NULL && lMapOfStudyAndItsMolecules.containskey(oReq.Related_Project__c) && lMapOfStudyAndItsMolecules.get(oReq.Related_Project__c) != null) {
                list < DRDP_Study_Molecule__c > lMolOnStudy = new list < DRDP_Study_Molecule__c > ();
                lMolOnStudy = lMapOfStudyAndItsMolecules.get(oReq.Related_Project__c);
                If(lMolOnStudy.size() > 0) {
                    for (DRDP_Study_Molecule__c oMolecule : lMolOnStudy) {
                        DRDP_Request_Molecule__c oReqMol = new DRDP_Request_Molecule__c();
                        oReqMol.Molecule__c = oMolecule.Molecule__c;
                        oReqMol.Request__c = oReq.id;
                        lRequestMolecules.add(oReqMol);
                    }
                }
            }
        }
        try {
            //Inserting the request molecules
            If(lRequestMolecules.size() > 0) {
                insert lRequestMolecules;
            }
        } catch (exception e) {
            GLBL_Error_Log__c errLog = new GLBL_Error_Log__c(   Error_Datetime__c = DateTime.Now(), Error_Message__c = e.getMessage(), Running_User__c = UserInfo.getUserId() , Stack_Trace__c = e.getStackTraceString() );  insert errlog;
        }
    }

    /*
    * @Method Name                    :  UpdateOutcome
    * @Description                    :  Method to Update Techincal Outcome field varying by record type.
    * @Return Type                    :  void
    * @Parameters                     :  lRequests
    */
    Public static void UpdateOutcome(list < Request__c > lRequests) {
        map<string, Id> recordTypeMap = new map<string, Id>();
        list<RecordType> recTypes = [Select Id, DeveloperName From RecordType Where sObjectType = 'Request__c'];
        for (RecordType rt : recTypes) {
            recordTypeMap.put(rt.DeveloperName, rt.Id);
        }

        for (Request__c oRequest : lRequests) {
            If(oRequest.RecordTypeId == recordTypeMap.get('Partnership_Exploration')) {
                oRequest.Outcome_TF__c = oRequest.Partnership_Status__c;
            }
            Else If(oRequest.Final_Outcome__c != NULL) {
                If(String.ValueOf(oRequest.Final_Outcome__c).Length() > 80) {
                    oRequest.Outcome_TF__c = String.ValueOf(oRequest.Final_Outcome__c).substring(0, 80) + '...';
                }
                Else {
                    oRequest.Outcome_TF__c = oRequest.Final_Outcome__c;
                }
            }
            Else {
                oRequest.Outcome_TF__c = oRequest.Final_Outcome__c;
            }

        }
    }

    /*
     * @Method Name                    :  UpdateRequestTimeline
     * @Description                    :  Method to set the Timeline Dates for the Requests' Status & Stage
     * @Return Type                    :  void
     * @Parameters                     :  lRequests
     */

    public static void UpdateRequestTimeline(List < Request__c > lRequests) {
        map<string, Id> recordTypeMap = new map<string, Id>();
        list<RecordType> recTypes = [Select Id, DeveloperName From RecordType Where sObjectType = 'Request__c'];
        for (RecordType rt : recTypes) {
            recordTypeMap.put(rt.DeveloperName, rt.Id);
        }

        for (Request__c oReq : lRequests) {
            //Setting Dates for the Request STATUS
            If((oReq.Request_Status__c == 'New' || oReq.Request_Sub_Status__c == 'Submitted' ) && oReq.Date_Submitted__c == null) {
                oReq.Date_Submitted__c = system.today();
            }
            if (oReq.Request_Status__c == 'Accepted' && oReq.Date_Accepted__c == null) {
                oReq.Date_Accepted__c = system.today();
            }
            if (oReq.Request_Status__c == 'In Progress' && oReq.Date_In_Progress__c == null) {
                oReq.Date_In_Progress__c = system.today();
            }
            if (oReq.Request_Status__c == 'Completed' && oReq.Date_Completed__c == null) {
                oReq.Date_Completed__c = system.today();
            }
            if (oReq.Request_Status__c == 'Archived' && oReq.Date_Closed__c == null) {
                oReq.Date_Closed__c = system.today();
            }
            if (oReq.Request_Status__c == 'Cancelled' && oReq.Date_Cancelled__c == null) {
                oReq.Date_Cancelled__c = system.today();
            }

            if (oReq.Request_Sub_Status__c == 'Pending Action' && oReq.Request_Status__c == 'Accepted' && oReq.Pending_Inc_Action_Date__c == null) {
                oReq.Pending_Inc_Action_Date__c= system.today();
            }

        }
    }

}