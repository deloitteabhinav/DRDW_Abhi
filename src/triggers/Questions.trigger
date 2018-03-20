/*****************************************************************************************
    Name           : Questions
    Description    : This trigger is to Trim the Question Text to 255 Characters and Copy in another field 
                     This trigger fetches the API name of the Study field according to the value entered in Default Study Label Field
    Modification Log : 
---------------------------------------------------------------------------
 Developer              Date            Description     
---------------------------------------------------------------------------
  Aryakaran Gupta        22/05/2015          Created
---------------------------------------------------------------------------
History Log:

******************************************************************************************/
trigger Questions on Questions__c (before insert,before update,after insert) {
 if (Trigger.isBefore) {
        If((Trigger.isInsert) || (Trigger.isUpdate)) {
            //Calling the trigger method
            Questions_TriggerHandler.ConvertQuestion(Trigger.New);
            Questions_TriggerHandler.CopyStudyAPI(Trigger.New);
        }
    }
 If(Trigger.isAfter) {
     If((Trigger.isInsert)) {
        Questions_TriggerHandler.retPicklist(Trigger.New);
     }
   } 
}