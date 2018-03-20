trigger TRAK_Release_Trigger on TRAK_Release__c (before Update, before insert) {
    If(trigger.isBefore && trigger.IsUpdate){
        // TRAK_Release_Trigger_Handler.LockReleaseRecord(trigger.oldmap,trigger.newmap);    
         TRAK_Release_Trigger_Handler.updateUserStoriesandDefects(trigger.oldmap,trigger.newmap);  
         TRAK_Release_Trigger_Handler.createRefreshTasks(trigger.new,trigger.oldmap);  
    }
    
    If(trigger.isBefore && trigger.IsInsert){
     TRAK_Release_Trigger_Handler.setReleaseName(trigger.new);
    }
}