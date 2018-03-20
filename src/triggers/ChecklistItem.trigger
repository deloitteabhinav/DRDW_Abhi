/*****************************************************************************************
    Name           : ChecklistItem  
    Description    : This trigger is to Trim the Checklist Text to 255 Characters and Copy in another field.
    Modification Log : 
---------------------------------------------------------------------------
 Developer              Date            Description     
---------------------------------------------------------------------------
  Aryakaran Gupta        26/05/2015          Created
---------------------------------------------------------------------------
History Log:

******************************************************************************************/
trigger ChecklistItem on Checklist_Item__c(before insert,before update) {
 if (Trigger.isBefore) {
        If((Trigger.isInsert) || (Trigger.isUpdate)) {
            //Calling the trigger method
            ChecklistItem_TriggerHandler.CopyChecklist(Trigger.New);
        }
    }
}