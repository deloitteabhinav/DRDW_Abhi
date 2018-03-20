/*****************************************************************************************
    Name           : Requests
    Description    : This trigger is to copy Molecules from Study and insert them as Request Molecules
    Modification Log :
---------------------------------------------------------------------------
 Developer              Date            Description
---------------------------------------------------------------------------
  Goutham         18/03/2015          Created
---------------------------------------------------------------------------
History Log:

******************************************************************************************/
trigger Requests on Request__c(after insert, before Insert, before update) {

    if (Trigger.isAfter) {
        If(Trigger.isInsert) {
            //Calling the trigger method for  after insert  of Requests record to copy Molecules from parent Study and insert them as Request Molecules
            Request_TriggerHandler.insertRequestMoleculesFromStudy(Trigger.New);
        }
    }

    if (Trigger.isBefore) {
        If(Trigger.isUpdate) {
            //Trigger method to Update tehe Timeline Dates for Duration calculation
            Request_TriggerHandler.UpdateRequestTimeline(Trigger.new);
        }

        If(Trigger.isInsert || Trigger.isUpdate) {
            //Calling the trigger method for  after insert  of Requests record to copy Molecules from parent Study and insert them as Request Molecules
            Request_TriggerHandler.UpdateOutcome(Trigger.New);
        }
    }
}