trigger TRAK_DefectTrigger on TRAK_Bug__c (before insert, before update, after update, after insert, after delete, after undelete) {
Boolean Flag;

    if (trigger.isBefore && trigger.isInsert) {
        Flag=true;
        TRAK_DefectTriggerClass.populateManualStep(Flag,trigger.new,trigger.newMap,trigger.oldMap);
        
        }
        
      if (trigger.isBefore && trigger.isUpdate) {
    Flag=false;
    TRAK_DefectTriggerClass.populateManualStep(Flag,trigger.new,trigger.newMap,trigger.oldMap);
    TRAK_DefectTriggerClass.validateAllRegressionDefectsPassed(trigger.new, trigger.oldMap);
    } 
    
     if (trigger.isBefore && trigger.isUpdate) {
    Flag=false;
    TRAK_DefectTriggerClass.populateManualStep(Flag,trigger.new,trigger.newMap,trigger.oldMap);
    }
    
    if(trigger.isAfter && trigger.isUpdate) {
    TRAK_DefectTriggerClass.populateNumberOfDefects(trigger.new,trigger.old);
    }
    if(trigger.isAfter && (trigger.isInsert || trigger.isUndelete)) {
    TRAK_DefectTriggerClass.populateNumberOfDefects(trigger.new,new List<TRAK_Bug__c>());    
    }
    if(trigger.isAfter && trigger.isDelete) {
    TRAK_DefectTriggerClass.populateNumberOfDefects(new List<TRAK_Bug__c>(),trigger.old);
    }
    
}