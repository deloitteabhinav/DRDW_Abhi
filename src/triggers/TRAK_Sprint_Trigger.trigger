trigger TRAK_Sprint_Trigger on TRAK_Sprint__c (after update, before insert) {
    
    if (trigger.isAfter && trigger.isUpdate) {
        
        // list of IDs
        Set<Id> sprintIds = trigger.newMap.keySet();
        
        // lists to auto-populate allocated and completed points per sprint
        Set<Id> startedSprints = new Set<Id>();
        Set<Id> finishedSprints = new Set<Id>();
        Set<Id> RoleSprintIds = new Set<Id>();
      	Set<Id> RoleIds = new Set<Id>();
        
        
        
        //compare old vs. new trigger statuses
        for (Id sprintId : sprintIds) {
            
            // if the sprint has been moved to 'In Progress', add to startedSprints
            if ((trigger.newMap.get(sprintId).Status__c == 'In Progress') && (trigger.oldMap.get(sprintId).Status__c != 'In Progress')) {
                startedSprints.add(sprintId);
            }
            
            // if the sprint has been completed, add to finishedSprints
            if ((trigger.newMap.get(sprintId).Populate_Story_Points_Completed__c == true) && (trigger.oldMap.get(sprintId).Populate_Story_Points_Completed__c == false)) {
                finishedSprints.add(sprintId);
            }
            //sprints whose start/end dates have been modified
            if((trigger.newMap.get(sprintId).Start_Date__c != trigger.OldMap.get(sprintId).Start_Date__c) || (trigger.newMap.get(sprintId).End_Date__c != trigger.OldMap.get(sprintId).End_Date__c) ){
                RoleSprintIds.add(sprintId);            
            }
            
        }
        // auto-populate the points on the sprint record
        TRAK_Sprint_TriggerHelper.updateAllocatedStoryPoints(startedSprints);
        TRAK_Sprint_TriggerHelper.updateCompletedStoryPoints(finishedSprints);
    }
    if (trigger.isBefore && trigger.isInsert) {
         List<TRAK_Sprint__c> newSprintList = trigger.new;
      } 

}