/*****************************************************************************************
    Name           : EventTrigger
    Description    : Trigger for creating an SMIN Meeting record when an event is created. The trigger is also fired for deleting the associated Meeting record when an event is deleted.
    Modification Log : 
---------------------------------------------------------------------------
 Developer              Date            Description     
---------------------------------------------------------------------------
  Aryakaran Gupta        11/26/2015          Created
---------------------------------------------------------------------------
History Log:

******************************************************************************************/
trigger EventTrigger on Event (after insert, before delete) {
if (Trigger.isAfter) {
        If(Trigger.isInsert) {
            //Calling the trigger method
            Event_TriggerHandler.CreateMeeting(Trigger.New);
        }
    }
if (Trigger.isBefore) {
        If(Trigger.isDelete){
            //Calling the trigger method
            Event_TriggerHandler.RemoveMeeting(Trigger.Old);
        }
    }
}