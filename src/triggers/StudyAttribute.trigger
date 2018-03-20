/*****************************************************************************************
    Name           : StudyAttribute
    Description    : This trigger fetches the API name of the Study field according to the value entered in Study Label Field
    Modification Log : 
---------------------------------------------------------------------------
 Developer              Date            Description     
---------------------------------------------------------------------------
  Aryakaran Gupta        25/05/2015          Created
---------------------------------------------------------------------------
History Log:

******************************************************************************************/
trigger StudyAttribute on Study_Attribute__c(before insert,before update) {
 if (Trigger.isBefore) {
        If((Trigger.isInsert) || (Trigger.isUpdate)) {
            //Calling the trigger method
            StudyAttribute_TriggerHandler.CopyStudyAPI(Trigger.New);
        }
    }
}