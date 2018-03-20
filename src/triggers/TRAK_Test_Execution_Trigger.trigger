trigger TRAK_Test_Execution_Trigger on TRAK_Test__c (after update, before insert, before update) {
    
    if (trigger.isAfter && trigger.isUpdate){
      
        //Create/Update custom Test Execution History records
        Map<Id,TRAK_Test__c> mapTestExecution = new Map<Id,TRAK_Test__c>();
        Map<Id,TRAK_Test__c> mapApproval = new Map<Id,TRAK_Test__c>();
        Map<Id,TRAK_Test__c> mapComplete = new Map<Id,TRAK_Test__c>();
        Set<Id> sprintIDs = new Set<Id>();
        
        for (TRAK_Test__c thisTestExec : trigger.new){
            //check for Test Execution records that have been submitted for approval
             if ((trigger.oldMap.get(thisTestExec.id).Approval_Status__c != 'Pending Approval' && thisTestExec.Approval_Status__c == 'Pending Approval')) {
                    mapTestExecution.put(thisTestExec.id , trigger.newMap.get(thisTestExec.id));
            }
          
            // check for Test Execution records that have been Approved
            if(((thisTestExec.Approval_Status__c == 'Approved') || (thisTestExec.Approval_Status__c == 'Rejected') || (thisTestExec.Approval_Status__c == 'Open' ))
                &&(trigger.oldMap.get(thisTestExec.id).Approval_Status__c == 'Pending Approval')){
                    mapApproval.put(thisTestExec.id , thisTestExec);
            }
            
            // check for Test Execution records that have been Completed
            if((thisTestExec.Sprint__c != null)
             &&(  ((thisTestExec.Status__c == 'Complete') && (trigger.oldMap.get(thisTestExec.id).Status__c != 'Complete'))
                ||((thisTestExec.Status__c != 'Complete') && (trigger.oldMap.get(thisTestExec.id).Status__c == 'Complete')))
            ){
                    mapComplete.put(thisTestExec.id , thisTestExec);
                    sprintIDs.add(thisTestExec.Sprint__c);
            }
        } 
        
        TRAK_Test_ExecutionTriggerClass.createNewTestExecutionHistoryRecord(mapTestExecution);
        TRAK_Test_ExecutionTriggerClass.updateApprovalDate(mapApproval);
        TRAK_Test_ExecutionTriggerClass.updateCompletedExecutionCountOnSprint(mapComplete,sprintIDs);
    }
    else if(trigger.isUpdate && trigger.isBefore){
    TRAK_Test_ExecutionTriggerClass.updateSubmitterInfo(trigger.oldMap,trigger.newMap);
}

}