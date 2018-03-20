/*****************************************************************************************
    Name           : Study
    Description    : trigger for Studies
    Modification Log :
---------------------------------------------------------------------------
 Developer              Date            Description
---------------------------------------------------------------------------
  Aryakaran Gupta        10/08/2015          Created
---------------------------------------------------------------------------
History Log:

******************************************************************************************/
trigger Study on Project__c(after insert,before insert, after update, before update) {
    if (Trigger.isAfter) {
        If(Trigger.IsUpdate) {
            //Calling the trigger method
            Study_TriggerHandler.CopyPMClass cCopyPMClass = new Study_TriggerHandler.CopyPMClass();
            cCopyPMClass.CopyPM(Trigger.new);
        }
        If(Trigger.IsInsert){
            Study_TriggerHandler.CopyPMClass cCopyPMClass = new Study_TriggerHandler.CopyPMClass();
            cCopyPMClass.CopyPM(Trigger.new);
        }
    }
    
    if (Trigger.isBefore) {
        If(Trigger.isUpdate) {
            //Calling the trigger method
            Study_TriggerHandler.ClearTPOLocation(Trigger.New);
            Study_TriggerHandler.QuestionnaireNeedsReview(Trigger.New, Trigger.OldMap);
            Study_TriggerHandler.RemovePMClass cRemovePMClass = new Study_TriggerHandler.RemovePMClass();
            cRemovePMClass.RemovePM(Trigger.new,Trigger.oldMap);  
        }
        

    }
}