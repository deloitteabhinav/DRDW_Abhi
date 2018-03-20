trigger TRAK_Test_Script_Step_Trigger on TRAK_Test_Template_Steps__c (before insert,after delete) {
    if(trigger.isBefore && trigger.isInsert){
        TRAK_Test_Script_StepTriggerClass.updateSequenceNumberOnInsert(trigger.new);
    }
    
    if(trigger.isAfter && trigger.isDelete){
        TRAK_Test_Script_StepTriggerClass.updateSequenceNumberOnDelete(trigger.old);
    }
}