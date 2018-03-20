/*************************************************************************\
    @ Author        : Nitish Kumar
    @ Date          : 22-Aug-2014
    @ Test Class    : 
    @ Description   : This trigger on Attachment will be used to stop the deletion of Attachment 
                      if the Test Script has been appproved.
****************************************************************************/
trigger TRAK_AttachmentTrigger on Attachment(before delete, after insert, after update, after undelete) {
    
    if(Trigger.isBefore && Trigger.isDelete) {
   TRAK_AttachmentTriggerUtility.onBeforeDelete(trigger.Old);
   }
   
   if((Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) && (Trigger.isAfter)) {
       TRAK_AttachmentTriggerUtility.duplicateNameCheck(trigger.new);
   }
}