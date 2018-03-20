/******************************************************************************************************************************************
* Class Name   : CreateRequestController
* Description  : Class for Creating Requests on UI
* Created By   : Deloitte Consulting
*
*****************************************************************************************************************************************/
public with sharing class CreateRequestController {

    public Request__c oRequest {
        get;
        set;
    }

    //Individually declaring 3 attachments rather than list because this will resolve the issue of uploading documents with name more than 80 characters
    public Transient Blob attachmentBody1 {
        get;
        set;
    }
    public String attachmentName1 {
        get;
        set;
    }
    public Transient Blob attachmentBody2 {
        get;
        set;
    }
    public String attachmentName2 {
        get;
        set;
    }
    public Transient Blob attachmentBody3 {
        get;
        set;
    }
    public String attachmentName3 {
        get;
        set;
    }
    public string studyID {get; set;}

    public id currentRecordID;

    Public Map < string, id > mRecordTypes = new Map < string, id > ();

    //Constructor of the Page
    public CreateRequestController(ApexPages.StandardController stdController) {
        currentRecordID = ApexPages.currentPage().getParameters().get('id');

        for (RecordType oRecType : [SELECT id, developername FROM RecordType WHERE SobjectType = 'Request__c']) {
            mRecordTypes.put(oRecType.developername, oRecType.id);
        }


        string recTypeDevName = ApexPages.currentPage().getParameters().get('recTypeName');
        studyID = ApexPages.currentPage().getParameters().get('studyID');

        If(stdController.getrecord().id != NULL) {

            String SobjectApiName = 'Request__c';
            Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
            Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();

            String commaSepratedFields = '';
            for (String fieldName : fieldMap.keyset()) {
                if (commaSepratedFields == null || commaSepratedFields == '') {
                    commaSepratedFields = fieldName;
                } else {
                    commaSepratedFields = commaSepratedFields + ', ' + fieldName;
                }
            }
            string query = 'select ' + commaSepratedFields +  ' from ' + SobjectApiName + ' where id =\'' + currentRecordID + '\' limit 1';
            oRequest = Database.query(query);

        } else {


            oRequest = new Request__c();

            oRequest.recordTypeid = mRecordTypes.get(recTypeDevName);
            oRequest.Requestor__c = userinfo.getuserid();
            if (studyID != NULL && studyID != '') {
                Project__c oStudy = new Project__c();
                oStudy = [SELECT id, Business_Unit_Primary__c, Therapeutic_Area_Primary__c, Study_Region__c, Study_Project_ID__c FROM Project__c WHERE id = : id.valueOf(studyID)];
                oRequest.Business_Unit_Primary__c = oStudy.Business_Unit_Primary__c;
                oRequest.Therapeutic_Area_Primary__c = oStudy.Therapeutic_Area_Primary__c;
                oRequest.Region__c = oStudy.Study_Region__c;
                oRequest.Related_Project__c = id.valueOf(studyID);
            }

            if(recTypeDevName != 'Study_Consultation'){
                oRequest.Proposed_Due_Date__c = addBussinessDays(system.today(), 4);
            }

        }

    }
    /*
    * @Method Name                    :  save
    * @Description                    :  Method to save the form
    * @Return Type                    :  pagereference
    * @Parameters                     :  None
    */
    public pagereference save() {
        try {
            insert oRequest;
            insertAttachments();
            updateRequest(oRequest);
            successMessage(true);
            if (studyID != NULL && studyID != '') {
                pagereference pageref = new pagereference('/apex/CreateStudy?id=' + id.valueof(studyID));
                pageref.setredirect(true);
                return pageref;
            } else {return NULL;}

        } catch (exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getmessage()));
            return NULL;
        }
    }


    /*
    * @Method Name                    :  updateRequest
    * @Description                    :  Method to update request upon sumission
    * @Return Type                    :  void
    * @Parameters                     :  oReq
    */
    public void updateRequest(Request__c oReq) {
        oReq.Submitted__c = true;
        oReq.Send_Notification__c = true;
        Update oReq;
    }

    /*
    * @Method Name                    :  successMessage
    * @Description                    :  Method to display page messages upon submitting request form
    * @Return Type                    :  void
    * @Parameters                     :  b
    */
    public void successMessage(Boolean b) {
        if (b) {
            String err = ' click <a href="/apex/DRDP_DFHomePage">here</a> to return to the Digital Foundry home page.';
            ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.CONFIRM, 'Your Request has been successfully submitted. Thank You. Please' + err);
            ApexPages.addmessage(msg);
        } else {
            ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Error, 'Please acknowledge access requirements');
            ApexPages.addmessage(msg);
        }
    }


    /*
    * @Method Name                    :  insertAttachments
    * @Description                    :  Method to insert attachments for various forms
    * @Return Type                    :  void
    * @Parameters                     :  None
    */
    public void insertAttachments() {
        list < Attachment > lAttachments = new list < Attachment > ();
        if (attachmentBody1 != null && attachmentName1 != NULL) {
            lAttachments.add(new attachment(name = attachmentName1, body = attachmentBody1, parentID = oRequest.id));
        }
        if (attachmentBody2 != null && attachmentName2 != NULL) {
            lAttachments.add(new attachment(name = attachmentName2, body = attachmentBody2, parentID = oRequest.id));
        }
        if (attachmentBody3 != null && attachmentName3 != NULL) {
            lAttachments.add(new attachment(name = attachmentName3, body = attachmentBody3, parentID = oRequest.id));
        }
        if (lAttachments.size() > 0) {
            database.insert(lAttachments, false);
        }

    }

    /*
    * @Method Name                    :  addBussinessDays
    * @Description                    :  Method to populate proposed due date field on forms excluding weekends
    * @Return Type                    :  Date
    * @Parameters                     :  startDate,iDays
    */
    public Date addBussinessDays(Date startDate, Integer iDays) {
        Date endDate = startDate.addDays(iDays);
        Datetime current = System.now();
        Time currTime = current.time();
        Datetime slocal = datetime.newinstance(startDate, currTime);
        Datetime elocal = datetime.newinstance(endDate, currTime);
        Integer iOffDays = daysOff(slocal, elocal);
        DateTime EndDateChecker = elocal.addDays(iOffDays);

        if (EndDateChecker.format('E') == 'Sat') {
            EndDateChecker = elocal.addDays(iOffDays) + 2;
        } else if (EndDateChecker.format('E') == 'Sun' && ioffDays == 2) {
            EndDateChecker = elocal.addDays(iOffDays) + 2;
        } else if (EndDateChecker.format('E') == 'Tue' && ioffDays == 3) {
            EndDateChecker = elocal.addDays(iOffDays) + 1;
        } else if (EndDateChecker.format('E') == 'Sun') {
            EndDateChecker = elocal.addDays(iOffDays) + 1;
        }
        DateTime DT = EndDateChecker;
        Date myDate = date.newinstance(DT.year(), DT.month(), DT.day());
        return myDate;
    }

    /*
    * @Method Name                    :  daysOff
    * @Description                    :  Takes the Start Date and Endate from addBusinessday and check if the dates have weekends.
    * @Return Type                    :  Integer
    * @Parameters                     :  sdate,edate
    */

    public Integer daysOff(Datetime sdate, Datetime edate) {
        Integer iCount = 0;
        while (sdate <= edate) {
            if (sdate.format('E') == 'Sat' | sdate.format('E') == 'Sun') {
                iCount = iCount + 1;
            }
            sdate = sdate.addDays(1);
        }
        return iCount;
    }

    //Wrapper class to hols check box and Datamart Asset for Data Mart Form
    Public class wDataAsset {
        Public Boolean isSelected {
            get;
            set;
        }
        Public Data_Asset__c oDataAsset {
            get;
            set;
        }
        public wDataAsset(Data_Asset__c Ast, Boolean isC) {
            this.oDataAsset = Ast;
            this.isSelected = isC;
        }
    }

}