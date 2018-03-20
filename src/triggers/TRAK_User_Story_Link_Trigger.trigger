trigger TRAK_User_Story_Link_Trigger on TRAK_User_Story_Link__c (after insert, after update, after delete) {
   
   if(trigger.isInsert){
       TRAK_User_Story_Link_Trigger_handler.createMirror(trigger.new);
   }
   
   if(trigger.isDelete){
       TRAK_User_Story_Link_Trigger_handler.deleteMirror(trigger.old);
   }
   
   if(trigger.isUpdate){
       TRAK_User_Story_Link_Trigger_handler.updateMirror(trigger.new , trigger.oldMap);
   } 
}