/******************************************************************************************************************************************
* Trigger Name   : TRAK_Sandbox_Refresh_Log_Trigger
* Description  : Create Tasks under 'Sandbox Refresh Log' object, on creation
*                Ensure all tasks are complete before completing the 'Sandbox Refresh Log'. 
* Created By   : Deloitte Consulting
*
*****************************************************************************************************************************************/
trigger TRAK_Sandbox_Refresh_Log_Trigger on TRAK_Sandbox_Refresh_Log__c ( after insert, after update) {

if(Trigger.isInsert && Trigger.isAfter) {
    TRAK_Sandbox_Refresh_Log_TriggerHandler.createTasks(trigger.new);
}

if(Trigger.isAfter && Trigger.isUpdate) {
        TRAK_Sandbox_Refresh_Log_TriggerHandler.completeSandboxRefreshLog(trigger.new, trigger.oldMap);
}

}