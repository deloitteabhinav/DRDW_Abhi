/****************************************************************************************************************************************** 
 * Class Name   : Event_TriggerHandler
 * Description  : Trigger Handler Class for Event Object
 * Created By   : Deloitte Consulting
 * 
 *****************************************************************************************************************************************/
Public with sharing class Event_TriggerHandler{

    
    /* 
     * @Method Name                    :  CreateMeeting
     * @Description                    :  Method to Create a Meeting record and associate to current Event.
     * @Return Type                    :  void
     * @Parameters                     :  lEvent
     */

    Public Static void CreateMeeting(List < Event > lEvent) {
    
        Boolean bIsAccess;
        
        //Checking for User Type
        List < PermissionSetAssignment > lPermissionsetCheck = [SELECT Id, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = : userinfo.getuserID() and(PermissionSet.name = 'Admin' OR PermissionSet.name = 'Supplier_Assessor' OR PermissionSet.name = 'Supplier_Feedback_Provider' )];
        if (lPermissionsetCheck.size() > 0) {
            bIsAccess = TRUE;
        }
    
        //Querying the Record Type for SMIN App
        RecordType oRecordType = [Select Id,DeveloperName from RecordType where DeveloperName =  'Events' LIMIT 1];
        
        Map<Event,Meeting__c> mEventMeeting = new Map<Event,Meeting__c>();
        
        //Constructing Map for Insertion of Meeting Record
        For(Event oEVent : lEvent){
            If(oEvent.RecordTypeId == oRecordType.Id && bIsAccess == TRUE && oEvent.AccountId != NULL && oEvent.Meeting_ID__c == NULL && oEvent.WhatId != NULL && oEvent.AccountId == oEvent.WhatId){
                Meeting__c oMeeting = new  Meeting__c();
                mEventMeeting.put(oEvent, oMeeting);
            }     
        }
        
        If(!mEventMeeting.IsEmpty()){
            Insert mEventMeeting.values();
        }
        
        List<Event> lUpdateEvent = new List<Event>();
        
        
        //Associating the Newly Inserted Meeting to the Current Event
        If(!mEventMeeting.IsEmpty()){
            For(Event oEvent : mEventMeeting.Keyset()){
                Event oEventUpdate = new Event();
                oEventUpdate.Id = oEvent.Id;
                oEventUpdate.Meeting_ID__c = mEventMeeting.get(oEvent).Id;
                lUpdateEvent.add(oEventUpdate);
            }
        }
    
        If(!lUpdateEvent.IsEmpty()){
            Update lUpdateEvent;
        }
    }

    /* 
     * @Method Name                    :  RemoveMeeting
     * @Description                    :  Method to delete associated Meeting record when an event is deleted.
     * @Return Type                    :  void
     * @Parameters                     :  lEvent
     */

    Public Static void RemoveMeeting(List < Event > lEvent) {
    
        List<Meeting__c> lMeetingDelete = new List<Meeting__c>();
        Set<Id> sMeetingIds = new Set<Id>();
        //Querying the Record Type for SMIN App
        RecordType oRecordType = [Select Id,DeveloperName from RecordType where DeveloperName =  'Events' LIMIT 1];    
        
        //Getting the Meeting Ids in the Set to be deleted.
        For(Event oEvent : lEvent){
            If(oEvent.Meeting_ID__c != NULL && oEvent.RecordTypeId == oRecordType.Id){
                sMeetingIds.add(oEvent.Meeting_ID__c);
            }    
        }
        
        //Final List of Meetings to be deleted.
        lMeetingDelete = [Select Id from Meeting__c where Id IN: sMeetingIds];
        
        Delete lMeetingDelete;
        
    }
}