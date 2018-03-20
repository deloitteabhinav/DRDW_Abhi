/****************************************************************************************************************************************** 
 * Class Name   : MeetingController
 * Description  : Class Meeting Page
 * Created By   : Deloitte Consulting
 * 
 *****************************************************************************************************************************************/
Public with sharing class MeetingController {

    Public Event oEvent {
        get;
        set;
    }

    Public Meeting__c oMeeting {
        get;
        set;
    }

    Public List < Contact > lContacts {
        get;
        set;
    }


    Public List < Task > lTasks {
        get;
        set;
    }

    Public Task oTask {
        get;
        set;
    }

    Public Account oAccount {
        get;
        set;
    }

    Public Map < String, String > mAccountFields;

    Public List < wFieldSelected > lwFieldList {
        get;
        set;
    }

    Public List < wAgenda > lwAgendaWrap {
        get;
        set;
    }

    Public Boolean IsAgenda {
        get;
        set;
    }

    Public Boolean IsTask {
        get;
        set;
    }

    Public Agenda__c oAgenda {
        get;
        set;
    }

    Public String UserName {
        get;
        set;
    }
    Public Boolean IsAccess {
        get;
        set;
    }
    Public Boolean IsEdit {
        get;
        set;
    }
    Public Id currentRecordID;

    //Loading the Constructor
    Public MeetingController(ApexPages.StandardController controller) {
        oEvent = new Event();
        currentRecordID = ApexPages.currentPage().getParameters().get('id');
        UserName = UserInfo.getName();
        IsAgenda = FALSE;
        IsTask = FALSE;
        IsAccess = FALSE;
        oAgenda = new Agenda__c();
        oTask = new Task();

        oEvent = [Select Id, Meeting_ID__c, Subject, ActivityDate, Location, Description, AccountId, OwnerId from Event where Id = : currentRecordID LIMIT 1];
        
        If(UserInfo.getUserId() == oEvent.OwnerId){
           IsAccess = TRUE;
           IsEdit = TRUE;
        }
        Else If(([Select AccountId, UserOrGroupId, AccountAccessLevel From AccountShare where AccountId =: oEvent.AccountId AND UserOrGroupId =: UserInfo.getUserId() AND (AccountAccessLevel = 'Edit' OR AccountAccessLevel = 'ALL')].size() > 0) || ([SELECT AssigneeId FROM PermissionSetAssignment 
                     WHERE PermissionSet.Name =: Constants.sSMINAdminPermissionAPI AND AssigneeId=:UserInfo.getUserId()].size()>0)){
           IsAccess = TRUE;
           IsEdit = FALSE;
        }
        Else{
          IsAccess = FALSE;
          IsEdit = FALSE;
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'You do not have the Permission to view this meeting. Please contact your Administrator.'));
        }
        
        oMeeting = new Meeting__c();
        oMeeting = [Select Id, Name, Meeting_Notes__c from Meeting__c where Id = : oEvent.Meeting_ID__c LIMIT 1];

        Set < Id > sAttendeesId = new Set < Id > ();

        For(EventRelation oEventRelation: [SELECT Id, EventId, RelationId FROM EventRelation Where EventId = : currentRecordID]) {
            sAttendeesId.add(oEventRelation.RelationId);
        }

        lContacts = new List < Contact > ();
        lContacts = [Select Name, Id, AccountId from Contact where Id IN: sAttendeesId];

        lTasks = new List < Task > ();
        lTasks = [Select Subject, WhatId, OwnerId, Owner.Name, Priority, ActivityDate from Task where WhatId = : oEvent.AccountId AND Meeting_ID__c = : oEvent.Meeting_ID__c ORDER BY ActivityDate ASC NULLS Last];

        FieldWrapperMaker();
        GenerateAgenda();

    }


    /* 
     * @Method Name                    :  GenerateAgenda
     * @Description                    :  Method to get latest Agenda records and sorts them based on their order.
     * @Return Type                    :  void
     * @Parameters                     :  None
     */

    Public Void GenerateAgenda() {
        lwAgendaWrap = new List < wAgenda > ();
        For(Agenda__c oAgenda: [Select Id, Name, Agenda_Topic_Details__c, Order__c, Meeting__c from Agenda__c where Meeting__c = : oMeeting.Id]) {
            lwAgendaWrap.add(new wAgenda(oAgenda));
        }
        lwAgendaWrap.sort();
    }


    /* 
     * @Method Name                    :  AddMeetingNotes
     * @Description                    :  This method Adds Notes to the Meeting.
     * @Return Type                    :  void
     * @Parameters                     :  None
     */

    Public Void AddMeetingNotes() {
        Try {
            oMeeting.Id = oEvent.Meeting_ID__c;
            Update oMeeting;
            oMeeting = [Select Id, Name, Meeting_Notes__c from Meeting__c where Id = : oEvent.Meeting_ID__c LIMIT 1];
            IsTask = TRUE;
            IsAgenda = FALSE;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm, 'Notes saved successfully.'));
        }
        Catch(Exception e) {
            IsTask = TRUE;
            IsAgenda = FALSE;
            ErrorLogger(e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'There was an error saving notes. Please contact your Administrator'));
        }
    }


    /* 
     * @Method Name                    :  AddTasks
     * @Description                    :  This method Adds Tasks to the Meeting.
     * @Return Type                    :  void
     * @Parameters                     :  None
     */

    Public Void AddTasks() {
        Try {
            oTask.WhatId = oEvent.AccountId;
            oTask.Meeting_ID__c = oEvent.Meeting_ID__c;
            oTask.Id = NULL;
            Insert oTask;
            lTasks = [Select Subject, WhatId, OwnerId, Owner.Name, Priority, ActivityDate from Task where WhatId = : oEvent.AccountId AND Meeting_ID__c = : oEvent.Meeting_ID__c ORDER BY ActivityDate ASC NULLS Last];
            oTask = new Task();
            IsTask = TRUE;
            IsAgenda = FALSE;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm, 'Task added successfully.'));
        }
        Catch(Exception e) {
            IsTask = TRUE;
            IsAgenda = FALSE;
            ErrorLogger(e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'There was an error adding task. Please contact your Administrator'));
        }
    }

    /* 
     * @Method Name                    :  UpdateTasks
     * @Description                    :  This method Updates Tasks to the Meeting.
     * @Return Type                    :  void
     * @Parameters                     :  None
     */

    Public Void UpdateTasks() {
        Try {
            oTask.WhatId = oEvent.AccountId;
            Update oTask;
            lTasks = [Select Subject, WhatId, OwnerId, Owner.Name, Priority, ActivityDate from Task where WhatId = : oEvent.AccountId AND Meeting_ID__c = : oEvent.Meeting_ID__c ORDER BY ActivityDate ASC NULLS Last];
            oTask = new Task();
            IsTask = TRUE;
            IsAgenda = FALSE;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm, 'Task updated successfully.'));
        }
        Catch(Exception e) {
            IsTask = TRUE;
            IsAgenda = FALSE;
            ErrorLogger(e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'There was an error updating task. Please contact your Administrator'));
        }
    }


    /* 
     * @Method Name                    :  FieldWrapperMaker
     * @Description                    :  This method is used to generate wrapper for Account Fields from Custom Settings.
     * @Return Type                    :  void
     * @Parameters                     :  None
     
      */

    Public void FieldWrapperMaker() {

        Set < String > sCustomSettingFields = new Set < String > ();

        For(AccountFields__c oCustomSetting: [Select Name, Field_API__c from AccountFields__c Order BY Name]) {
            sCustomSettingFields.add(oCustomSetting.Field_API__c);
        }

        oAccount = new Account();
        Id iAccountId = oEvent.AccountId;
        //Creating dynamic query with selected field  
        String myQuery = 'Select Id,Name';

        for (String field: sCustomSettingFields) {
            myQuery += ',' + field + ' ';
        }

        myQuery += ' from Account Where Id =: iAccountId LIMIT 1';

        //Executing the query and fetching results  
        oAccount = Database.query(myQuery);

        mAccountFields = new Map < String, String > ();

        For(String sFields: sCustomSettingFields) {
            mAccountFields.put(sFields, String.valueOf(Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get(sFields).getDescribe().getType()));
        }

        lwFieldList = new List < wFieldSelected > ();

        For(String sWrap: mAccountFields.keySet()) {
            Boolean IsRichText = FALSE;
            
            if (Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get(sWrap).getDescribe().isHtmlFormatted() && mAccountFields.get(sWrap) == 'TEXTAREA' ) {
                IsRichText = TRUE;
            }
            wFieldSelected wField = new wFieldSelected(False, Schema.SObjectType.Account.fields.getMap().get(sWrap).getDescribe().getLabel(), String.valueOf(oAccount.get(sWrap)), mAccountFields.get(sWrap), IsRichText);
            lwFieldList.add(wField);
        }

    }

    /* 
     * @Method Name                    :  AddNewAgenda
     * @Description                    :  This method creates new Agenda for a Meeting
     * @Return Type                    :  void
     * @Parameters                     :  None 
     */

    Public void AddNewAgenda() {
        Try {
            List < Agenda__c > lHighestAgenda = new List < Agenda__c > ();
            Decimal dHighestOrder = 0;
            lHighestAgenda = [Select Id, Name, Agenda_Topic_Details__c, Order__c, Meeting__c from Agenda__c where Meeting__c = : oMeeting.Id Order BY Order__c DESC LIMIT 1];
            If(!lHighestAgenda.IsEmpty() && lHighestAgenda[0].Order__c != NULL) {
                dHighestOrder = lHighestAgenda[0].Order__c;
            }
            List < Agenda__c > lNewAgenda = new List < Agenda__c > ();
            For(wFieldSelected wField: lwFieldList) {
                If(wField.fSelected == TRUE) {
                    Agenda__c oAgenda = new Agenda__c();
                    oAgenda.Name = wField.sName;
                    If(wField.bRichText == FALSE){
                        oAgenda.Agenda_Topic_Details__c = wField.sDescription;
                    }
                    Else{
                        oAgenda.Agenda_Topic_Details__c = '';
                    }
                    oAgenda.Meeting__c = oMeeting.Id;
                    oAgenda.Order__c = dHighestOrder + 1;
                    dHighestOrder++;
                    lNewAgenda.add(oAgenda);
                }
            }

            If(!lNewAgenda.IsEmpty()) {
                Insert lNewAgenda;
                GenerateAgenda();
                IsAgenda = TRUE;
                IsTask = FALSE;
                If(lNewAgenda.size() == 1) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm, 'Agenda added successfully.'));
                }
                If(lNewAgenda.size() > 1) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm, 'Agendas added successfully.'));
                }
                FieldWrapperMaker();
            }
            Else {
                IsAgenda = TRUE;
                IsTask = FALSE;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'No agenda selected.'));
            }
        }
        Catch(Exception e) {
            IsAgenda = TRUE;
            IsTask = FALSE;
            ErrorLogger(e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'There was an error adding agenda. Please contact your Administrator'));
        }
    }


    /* 
     * @Method Name                    :  SaveChanges
     * @Description                    :  This method Updates Agendas for a Meeting
     * @Return Type                    :  void
     * @Parameters                     :  None 
     */

    Public void SaveChanges() {
        Try {
            List < Agenda__c > lAgenda = new List < Agenda__c > ();
            If(!lwAgendaWrap.IsEmpty()) {
                lwAgendaWrap.sort();
                Decimal dHighestOrder = 0;
                For(wAgenda w: lwAgendaWrap) {
                    w.oAgenda.Order__c = dHighestOrder + 1;
                    dHighestOrder++;
                    lAgenda.add(w.oAgenda);
                }
                Update lAgenda;
                GenerateAgenda();
                IsAgenda = TRUE;
                IsTask = FALSE;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm, 'Changes saved.'));
            }
            Else {
                IsAgenda = TRUE;
                IsTask = FALSE;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'No agendas found.'));
            }
        }
        Catch(Exception e) {
            IsAgenda = TRUE;
            IsTask = FALSE;
            ErrorLogger(e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'There was an error saving your changes. Please contact your Administrator'));
        }
    }


    /* 
     * @Method Name                    :  AddCustomAgenda
     * @Description                    :  This methods Adds Custom Agenda
     * @Return Type                    :  void
     * @Parameters                     :  None 
     */

    Public void AddCustomAgenda() {
        Try {

            List < Agenda__c > lHighestAgenda = new List < Agenda__c > ();
            Decimal dHighestOrder = 0;
            lHighestAgenda = [Select Id, Name, Agenda_Topic_Details__c, Order__c, Meeting__c from Agenda__c where Meeting__c = : oMeeting.Id Order BY Order__c DESC LIMIT 1];
            If(!lHighestAgenda.IsEmpty() && lHighestAgenda[0].Order__c != NULL) {
                dHighestOrder = lHighestAgenda[0].Order__c;
            }
            If(oAgenda.Meeting__c == NULL) {
                oAgenda.Meeting__c = oMeeting.Id;
                oAgenda.Order__c = dHighestOrder + 1;
                Insert oAgenda;
            }
            GenerateAgenda();
            IsAgenda = TRUE;
            IsTask = FALSE;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm, 'Agenda successfully added.'));
            oAgenda = new Agenda__c();
        }
        Catch(Exception e) {
            IsAgenda = TRUE;
            IsTask = FALSE;
            ErrorLogger(e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'There was an error adding agenda. Please contact your Administrator'));
        }
    }

    /* 
     * @Method Name                    :  DeleteAgenda
     * @Description                    :  This methods Deletes the Selected Agenda
     * @Return Type                    :  void
     * @Parameters                     :  None 
     */

    Public void DeleteAgenda() {
        Try {
            Delete oAgenda;
            Database.emptyRecycleBin(oAgenda);
            GenerateAgenda();
            List < Agenda__c > lAgenda = new List < Agenda__c > ();
            If(!lwAgendaWrap.IsEmpty()) {
                lwAgendaWrap.sort();
                Decimal dHighestOrder = 0;
                For(wAgenda w: lwAgendaWrap) {
                    w.oAgenda.Order__c = dHighestOrder + 1;
                    dHighestOrder++;
                    lAgenda.add(w.oAgenda);
                }
                Update lAgenda;
            }
            IsAgenda = TRUE;
            IsTask = FALSE;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm, 'Agenda deleted successfully.'));
            oAgenda = new Agenda__c();
        }
        Catch(Exception e) {
            IsAgenda = TRUE;
            IsTask = FALSE;
            ErrorLogger(e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'There was an error deleting agenda. Please contact your Administrator'));

        }
    }

    /* 
     * @Method Name                    :  ErrorLogger
     * @Description                    :  This methods covers error logging
     * @Return Type                    :  void
     * @Parameters                     :  None 
     */

    Public void ErrorLogger(Exception e) {
        GLBL_Error_Log__c errLog = new GLBL_Error_Log__c(Error_Datetime__c = DateTime.Now(), Error_Message__c = e.getMessage(), Running_User__c = UserInfo.getUserId(), Stack_Trace__c = e.getStackTraceString());
        insert errlog;
    }


    /*
     * Class name   : wFieldSelected
     * Description  : This is a wrapper class which holds the custom setting field values and checkbox
     */

    Public class wFieldSelected {
        Public Boolean fSelected {
            get;
            set;
        }
        Public String sName {
            get;
            set;
        }
        Public String sDescription {
            get;
            set;
        }
        Public String sType {
            get;
            set;
        }
        Public Boolean bRichText {
            get;
            set;
        }
        public wFieldSelected(Boolean IsSelect, String n, String d, String t, Boolean b) {
            fSelected = IsSelect;
            sName = n;
            sDescription = d;
            sType = t;
            bRichText = b;
        }
    }

    /* 
     * @ClassName                    :  wAgenda 
     * @Description                  :  Class to hold Agenda records and sort them.
     */

    public class wAgenda Implements Comparable {
        public Agenda__c oAgenda {
            get;
            set;
        }
        public wAgenda(Agenda__c oAgenda) {
            this.oAgenda = oAgenda;
        }

        public integer CompareTo(Object ObjToCompare) {
            // Cast argument to wAgenda 
            wAgenda wAW = (wAgenda) ObjToCompare;

            // The return value of 0 indicates that both elements are equal.
            Integer returnValue = 0;

            if (oAgenda.Order__c > wAW.oAgenda.Order__c) {
                // Set return value to a positive value.
                returnValue = 1;
            } else if (oAgenda.Order__c < wAW.oAgenda.Order__c) {
                // Set return value to a negative value. 
                returnValue = -1;
            }

            return returnValue;
        }

    }
}