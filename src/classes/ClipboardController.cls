/******************************************************************************************************************************************
 * Class Name      : ClipboardController
 * Description     : Class to display the List of Studies, Requests and Partnerships grouped in different status
 * Created By      : Deloitte Consulting
 *
 *****************************************************************************************************************************************/
Public with sharing class ClipboardController {

    Public transient Map < String, List < wMoleculeWrapper >> mStudyRecordsPerStatus {get; set;}
    Public transient Map < String, List < wMoleculeWrapper >> mRequestRecordsPerStatus {get; set;}
    Public transient Map < String, List < Request__c >> mPartnershipRecordsPerStatus {get; set;}

    Public  Map < String, Integer > mStudyCategoryCount {get; set;}
    Public  Map < String, Integer > mReqCategoryCount {get; set;}
    Public  Map < String, Integer > mPartnershipCategoryCount {get; set;}
    Public Map < String, Boolean > mCheckStudyQuestionnaire{get;set;}

    Public Map < Project__c, list < DRDP_Study_Molecule__c >> mStudyMolecules;
    Public Map < Request__c, list < DRDP_Request_Molecule__c >> mRequestMolecules;

    Public Boolean IsStudy {get; set;}
    Public Boolean IsRequest {get; set;}
    Public Boolean IsPartnership {get; set;}

    Public List < Project__c > lStudies;
    Public List < Request__c > lRequests;
    Public List < Request__c > lPartnerships;

    Public set < id > setStudies;
    Public set < id > setRequests;
    Public set < id > setPartnerships;

    Public String sField {get; set;}
    Public String previousSField;
    Public String sOrder {get; set;}
    Public String sFinalSort;
    Public String sTypeofObject {get; set;}
    Public String StudyComment {get; set;}
    Public Boolean isApprove {get; set;}
    Public String StudyId {get; set;}
    Public Boolean IsApprover{get;set;}
    Public Boolean IsTopics{get;set;}

    //Loading the constructor & Calling Activate Studies in last to show it latest
    Public ClipboardController() {
        sField = 'Name';
        previousSField = 'Name';
        sOrder = 'ASC NULLS FIRST';
        sTypeofObject = 'Study';
        isApprove = FALSE;
        IsApprover = FALSE;
        IsTopics = FALSE;
        sFinalSort = string.escapeSingleQuotes(sField) + ' ' + string.escapeSingleQuotes(sOrder);
        ActivatePartnership();
        ActivateRequest();
        ActivateStudy();
        
        mCheckStudyQuestionnaire = new Map<String,Boolean>();
        For (Schema.Picklistentry oPicklistValues : Questionaire__c.Study_Type__c.getDescribe().getPicklistValues()) {
            mCheckStudyQuestionnaire.put(oPicklistValues.Label,False);
        }
        mCheckStudyQuestionnaire.put('',False);
        mCheckStudyQuestionnaire.put(null,False);
        For(Questionaire__c oQuestionnaire : [Select Id,Study_Type__c from Questionaire__c where Active__c = TRUE]){
            mCheckStudyQuestionnaire.put(oQuestionnaire.Study_Type__c,TRUE);
        }
    }

    /*
         * @Method Name                    :  checkObject
         * @Description                    :  This method makes the current Object & its flag active for rendering purposes.
         * @Return Type                    :  void
         * @Parameters                     :  string

    */

    public void checkObject(string obj) {

        if (obj == 'Study') {
            IsStudy = TRUE;
            IsPartnership = FALSE;
            IsRequest = FALSE;
        } else if (obj == 'Request') {
            IsStudy = FALSE;
            IsPartnership = FALSE;
            IsRequest = TRUE;
        } else {
            IsStudy = FALSE;
            IsRequest = FALSE;
            IsPartnership = TRUE;
        }

    }


    /*
     * @Method Name                    :  HoldValues
     * @Description                    :  This method is called when a Approve/Reject button is clicked.
     * @Return Type                    :  PageReference
     * @Parameters                     :  None

    */

    Public PageReference HoldValues() {
        return null;
    }


    /*
         * @Method Name                    :  ActivateStudy
         * @Description                    :  This method fetches & displays the relevant Studies with their Molecules.
         * @Return Type                    :  void
         * @Parameters                     :  none

    */
    Public void ActivateStudy() {

        checkObject('Study');
        setStudies = New set < id > ();
        lStudies = new List<Project__c>();
        mStudyCategoryCount = new Map < String, Integer > ();
        mStudyRecordsPerStatus = new Map < String, List < wMoleculeWrapper >> ();
        mStudyMolecules = new Map < Project__c, list < DRDP_Study_Molecule__c >> ();

        //Looping through all picklist values of Project status and adding them to map
        for (Schema.Picklistentry oPicklistValues : Project__c.Project_Status__c.getDescribe().getPicklistValues()) {
            mStudyCategoryCount.put(oPicklistValues.Label, 0);
        }

        //Fetching Relevant viewable studies only
        for (Project__Share oShare : [Select ParentId, AccessLevel, UserOrGroupId from Project__Share where (AccessLevel = 'Edit' OR AccessLevel = 'All') AND UserOrGroupId = : UserInfo.getUserId()]) {
            setStudies.add(oShare.ParentId);
        }
        
        If(!IsTopics){
            For(GroupMember oMember : [Select Group.Name,UserorGroupId from GroupMember where Group.Type = 'Queue' AND Group.Name = 'DRDP Study Approval Queue' AND UserOrGroupId =: UserInfo.getUserId()]){
                IsApprover = TRUE;
            }
            
            If(IsApprover){
                For(Project__c oProject : [Select Id from Project__c where Project_Status__c = 'Pending Approval']){
                    setStudies.add(oProject.Id);
                }
            }
        }


        if (sField != 'Study_Project_ID__c' &&  sField != 'LastModifiedDate' &&  sField != 'Study_Stage__c'
                &&  sField != 'Classification__c' &&  sField != 'Owner.Name')
        {sFinalSort =  'Name ' + string.escapeSingleQuotes(sOrder);}

        //Querying Study Records
        QueryMaker('Project__c', 'isStudy');
        
        //Adding Molecules per Study to the mStudyMolecules map
        for (Project__c oProject : lStudies) {
            mStudyMolecules.put(oProject, oProject.RWE_Study_Molecule__r);
        }

        //Adding Studies per status
        for (Project__c oProject : lStudies) {
            string sMoleculeStirng = getStudyMolecules(oProject);
            List < wMoleculeWrapper > ltempList = new List < wMoleculeWrapper > ();
            If(IsTopics){
                If(oProject.Research_Type__c == 'Research Topic'){
                if (mStudyRecordsPerStatus.keySet().contains(oProject.Project_Status__c)) {
                    ltempList = mStudyRecordsPerStatus.get(oProject.Project_Status__c);
                }
                ltempList.add(new wMoleculeWrapper(oProject, sMoleculeStirng));
                mStudyRecordsPerStatus.put(oProject.Project_Status__c, ltempList);
                }
            }
            If(!IsTopics){ 
                If(oProject.Research_Type__c == 'Research Study'){
                    if (mStudyRecordsPerStatus.keySet().contains(oProject.Project_Status__c)) {
                        ltempList = mStudyRecordsPerStatus.get(oProject.Project_Status__c);
                    }
                    ltempList.add(new wMoleculeWrapper(oProject, sMoleculeStirng));
                    mStudyRecordsPerStatus.put(oProject.Project_Status__c, ltempList);
                }
            }
        }

        //Study Record count per status
        for (string s : mStudyRecordsPerStatus.keyset()) {
            list < wMoleculeWrapper > lProjs = mStudyRecordsPerStatus.get(s);
            mStudyCategoryCount.put(s, lProjs.size());
        }

    }


    /*
         * @Method Name                    :  ActivatePartnership
         * @Description                    :  This method fetches & displays the relevant Partnership requests.
         * @Return Type                    :  void
         * @Parameters                     :  none

    */
    Public void ActivatePartnership() {

        checkObject('Partnership');
        setPartnerships = New set < id > ();
        lPartnerships = new List<Request__c>();
        mPartnershipCategoryCount = new Map < String, Integer > ();
        mPartnershipRecordsPerStatus = new Map < String, List<Request__c >> ();


        //Looping through all picklist values of Partnership status and adding them to map
        for (Schema.Picklistentry oPicklistValues : Request__c.Partnership_Status__c.getDescribe().getPicklistValues()) {
            mPartnershipCategoryCount.put(oPicklistValues.Label, 0);
        }

        //Logic for Group and Queue Members
        Set<Id> queueSet = new Set<Id>();
        Set<Id> groupSet = new Set<Id>();
        for (GroupMember omemberList : [Select GroupId from GroupMember where UserOrGroupId = :UserInfo.getUserId()]) {
            groupSet.add(omemberList.GroupId);
        }

        for (GroupMember omemberList : [Select Id, GroupId from GroupMember where UserOrGroupId = :UserInfo.getUserId() or UserOrGroupId in :groupSet]) {
            queueSet.add(omemberList.GroupId);
        }

        //Fetching Relevant viewable Partnerships records only
        for (Request__c oTempReq : [Select id, Ownerid, Requestor__c from Request__c where (Requestor__c = : UserInfo.getUserId() OR Ownerid = : UserInfo.getUserId() OR OwnerId IN :queueSet)]) {
            setPartnerships.add(oTempReq.id);
        }

        if (sField != 'Partnership_Sponsor__c' &&  sField != 'Primary_Contact__r.Name' &&  sField != 'Request_Status__c'
                &&  sField != 'Reason_Partnership_Not_Pursued__c' &&  sField != 'Owner.Name')
        {sFinalSort =  'Name ' + string.escapeSingleQuotes(sOrder);}

        //Querying the specific Partnerships
        QueryMaker('Request__c', 'isPartnership');
        //Adding Partnerships per status
        for (Request__c oPrtnrRequest : lPartnerships) {
            if (!mPartnershipRecordsPerStatus.containsKey(oPrtnrRequest.Partnership_Status__c)) {
                mPartnershipRecordsPerStatus.put(oPrtnrRequest.Partnership_Status__c, new List<Request__c >());
            }
            mPartnershipRecordsPerStatus.get(oPrtnrRequest.Partnership_Status__c).add(oPrtnrRequest);
        }

        //Partnerships Record count per status
        for (string s : mPartnershipRecordsPerStatus.keyset()) {
            mPartnershipCategoryCount.put(s, mPartnershipRecordsPerStatus.get(s).size());
        }

    }


    /*
         * @Method Name                    :  ActivateRequest
         * @Description                    :  This method fetches & displays the relevant Requests with their Molecules.
         * @Return Type                    :  void
         * @Parameters                     :  none

    */

    Public void ActivateRequest() {
        checkObject('Request');
        setRequests = New set < id > ();
        lRequests = new List<Request__c>();
        mReqCategoryCount = new Map < String, Integer > ();
        mRequestRecordsPerStatus = new Map < String, List < wMoleculeWrapper >> ();
        mRequestMolecules = new Map < Request__c, list < DRDP_Request_Molecule__c >> ();


        //Looping through all picklist values of Request status and adding them to map
        for (Schema.Picklistentry oPicklistValues : Request__c.Request_Status__c.getDescribe().getPicklistValues()) {
            mReqCategoryCount.put(oPicklistValues.Label, 0);
        }

        //Logic for Group and Queue Members
        Set<Id> queueSet = new Set<Id>();
        Set<Id> groupSet = new Set<Id>();
        for (GroupMember omemberList : [Select GroupId from GroupMember where UserOrGroupId = :UserInfo.getUserId()]) {
            groupSet.add(omemberList.GroupId);
        }

        for (GroupMember omemberList : [Select Id, GroupId from GroupMember where UserOrGroupId = :UserInfo.getUserId() or UserOrGroupId in :groupSet]) {
            queueSet.add(omemberList.GroupId);
        }

        //Fetching Relevant viewable Requests only
        for (Request__c oTempReq : [Select id, Ownerid, Requestor__c from Request__c where (Requestor__c = : UserInfo.getUserId() OR Ownerid = : UserInfo.getUserId() OR OwnerId IN :queueSet)]) {
            setRequests.add(oTempReq.id);
        }

        if (sField != 'RecordType.Name' &&  sField != 'Request_Sub_Status__c' &&  sField != 'Therapeutic_Area_Primary__c'
                &&  sField != 'Owner.Name' && sField != 'Proposed_Due_Date__c' &&  sField != 'Date_Completed__c' &&  sField != 'Outcome_TF__c' &&  sField != 'Cancellation_Reason__c')
        {sFinalSort =  'Name ' + string.escapeSingleQuotes(sOrder);}

        //Querying Requests
        QueryMaker('Request__c', 'isRequest');

        //Adding Molecules per Request to the mRequestMolecules map
        for (Request__c oRequest : lRequests) {
            mRequestMolecules.put(oRequest, oRequest.RWE_Request_Molecule__r);
        }

        //Adding Requests per status
        for (Request__c oRequest : lRequests) {
            string sMoleculeString = getRequestMolecules(oRequest);
            List < wMoleculeWrapper > ltempList = new List < wMoleculeWrapper > ();
            if (mRequestRecordsPerStatus.keySet().contains(oRequest.Request_Status__c)) {
                ltempList = mRequestRecordsPerStatus.get(oRequest.Request_Status__c);
            }
            ltempList.add(new wMoleculeWrapper(oRequest, sMoleculeString));
            mRequestRecordsPerStatus.put(oRequest.Request_Status__c, ltempList);
        }

        //Request Record count per status
        for (string s : mRequestRecordsPerStatus.keyset()) {
            list < wMoleculeWrapper > lReqs = mRequestRecordsPerStatus.get(s);
            mReqCategoryCount.put(s, lReqs.size());
        }
    }
    
    Public void StudyApprovalProcess() {

        // Setting for Approval now
        Approval.ProcessWorkitemRequest StudytoApprove = new Approval.ProcessWorkitemRequest();
        List<ProcessInstanceWorkitem> PIworkItemID = [Select p.Id from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId = : StudyId Limit 1];
        if(PIworkItemID.size() > 0) {
        StudytoApprove.setWorkitemId(PIworkItemID[0].id);
        StudytoApprove.setComments(StudyComment);

        if (isApprove == TRUE) {
            StudytoApprove.setAction('Approve');
        } else if (isApprove == FALSE) {
            StudytoApprove.setAction('Reject');
        }
        Approval.ProcessResult result =  Approval.process(StudytoApprove);
        }
        ActivateStudy();
        isApprove = FALSE;
    }



    /*
     * @Method Name                    :  QueryMaker
     * @Description                    :  This method queries the Studies or Requests with their Molecules.
     * @Return Type                    :  void
     * @Parameters                     :  String, Boolean
     */

    Public void QueryMaker(String aObject, string isObject) {
        If(aObject == 'Project__c' && isObject == 'isStudy') {
            String sQuery;
            sQuery = 'SELECT id,Study_Description__c ,Research_Type__c, Classification__c, Anticipated_Start_Date__c, LastModifiedDate, Name, OwnerId, Owner.Name, Study_Stage__c,Study_Project_ID__c, Project_Status__c,' +
                     '(SELECT id, Project__c, Molecule__c, Molecule__r.name, Molecule__r.Firewalled__c FROM RWE_Study_Molecule__r)' +
                     'FROM ' + aObject + ' WHERE ID in : setStudies ORDER BY ' + sFinalSort;
            lStudies = Database.Query(sQuery);
        }


        If(aObject == 'Request__c' && isObject == 'isRequest') {
            String sQuery;
            sQuery = 'SELECT id, RecordType.DeveloperName, RecordType.Name, Name, Request_Status__c, Requestor__r.Name ,Request_Sub_Status__c, Proposed_Due_Date__c, Date_Completed__c, Therapeutic_Area_Primary__c, Ownerid, Owner.Name, Final_Outcome__c, Outcome_TF__c , Cancellation_Reason__c,' +
                     '(SELECT id, Request__c, Molecule__c, Molecule__r.name, Molecule__r.Firewalled__c FROM RWE_Request_Molecule__r)' +
                     'FROM ' + aObject + ' WHERE ID in : setRequests ORDER BY ' + sFinalSort;

            lRequests = Database.Query(sQuery);
        }

        else if (aObject == 'Request__c' && isObject == 'isPartnership') {
            string sRecTypeName = 'Partnership Exploration Request';
            string sQuery = 'SELECT id, RecordType.DeveloperName, RecordType.Name, Name, Partnership_Status__c, Partnership_Sponsor__c, Type_of_Partner__c, Primary_Contact__r.Name, Reason_Partnership_Not_Pursued__c, Request_Status__c, Request_Sub_Status__c, Ownerid,' +
                            ' Owner.Name FROM Request__c WHERE (ID in : setPartnerships AND RecordType.Name = \'' + String.escapeSingleQuotes(sRecTypeName) + '\') ORDER BY ' + sFinalSort;
            lPartnerships = Database.Query(sQuery);
        }
    }


    /*
    * @Method Name                    :  getStudyMolecules
    * @Description                    :  This method returns a string of comma seperated related STUDY molucule names to use in Wrapper
    * @Return Type                    :  string
    * @Parameters                     :  Project__c
    */

    public string getStudyMolecules(Project__c oProj) {
        string sMolecules = '';
        list < DRDP_Study_Molecule__c > lMolecules = mStudyMolecules.get(oProj);
        If(lMolecules != NULL && lMolecules.size() > 0) {
            for (DRDP_Study_Molecule__c oMol : lMolecules) {
                sMolecules += oMol.Molecule__r.name + ', ';
            }
            sMolecules = sMolecules.removeEnd(', ');
            return sMolecules;
        } else {
            return sMolecules;
        }


    }

    /*
    * @Method Name                    :  getRequestMolecules
    * @Description                    :  This method returns a string of comma seperated related REQUEST molucules  to use in Wrapper
    * @Return Type                    :  string
    * @Parameters                     :  Request__c
    */

    public string getRequestMolecules(Request__c oReq) {
        string sMolecules = '';
        list < DRDP_Request_Molecule__c > lMolecules = mRequestMolecules.get(oReq);
        If(lMolecules != NULL && lMolecules.size() > 0) {
            for (DRDP_Request_Molecule__c oMol : lMolecules) {
                 sMolecules += oMol.Molecule__r.name + ', ';
            }
            sMolecules = sMolecules.removeEnd(', ');
            return sMolecules;
        } else {
            return sMolecules;
        }


    }

    /*
    * @Method Name                    :  sort
    * @Description                    :  This method Sorts by Record Type Name or Request Name ascending or descending
    * @Return Type                    :  Void
    * @Parameters                     :  None
    */

    Public void sort() {

        if (sField == previousSField) {
            if (sOrder.contains('ASC')) {
                sOrder = sOrder.replace('ASC', 'DESC');
                sOrder = sOrder.replace('FIRST', 'LAST');
            } else {
                sorder = sorder.replace('DESC', 'ASC');
                sOrder = sOrder.replace('LAST', 'FIRST');
            }
        } else {
            sOrder = 'ASC NULLS FIRST';
            previoussField = sField;
        }
        sFinalSort = string.escapeSingleQuotes(sField) + ' ' + string.escapeSingleQuotes(sOrder);
        if (sTypeofObject == 'Study') {ActivateStudy();}
        else if (sTypeofObject == 'Request') {ActivateRequest();}
        else if (sTypeofObject == 'Partnership') {ActivatePartnership();}
    }


    /*****************************************************************************************
    * Class Name      : wMoleculeWrapper
    * Description     : Wrapper class to hold Study or Request and their list of molecules as a string
    * Created By      : Deloitte Consulting
    *
    *****************************************************************************************/

    Public class wMoleculeWrapper {

        Public Project__c oProject {
            get;
            set;
        }

        Public Request__c oRequest {
            get;
            set;
        }
        Public string sMolecules {
            get;
            set;
        }
        public wMoleculeWrapper(Project__c oProj, String s) {
            oProject = oProj;
            sMolecules = s;
        }

        public wMoleculeWrapper(Request__c oReq, String s) {
            oRequest = oReq;
            sMolecules = s;
        }
    }

}