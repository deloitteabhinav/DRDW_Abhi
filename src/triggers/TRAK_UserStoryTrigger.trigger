trigger TRAK_UserStoryTrigger on TRAK_User_Story__c(before insert, before update, after update, after insert, after delete, after undelete) {
    Boolean Flag;
    if (trigger.isBefore && trigger.isInsert) {
        Flag=true;
      //  TRAK_UserStoryTriggerClass.populateAppStakeholders(trigger.new);
        TRAK_UserStoryTriggerClass.populateManualStep(Flag,trigger.new,trigger.newMap,trigger.oldMap);
    }
    if(trigger.isBefore && trigger.isUpdate) {
        TRAK_UserStoryTriggerClass.addDesignBeforePassingUS(trigger.new, trigger.oldMap);
        TRAK_UserStoryTriggerClass.validateRegressionDefectsBeforePassingUS(trigger.new, trigger.oldMap);        
    }
    if (trigger.isAfter && trigger.isUpdate) {
        //custom AC history

        Map < Id, String > mapStoryAC = new Map < Id, String > ();
        Map < Id, String > mapStoryCC = new Map < Id, String > ();
        Map < Id, TRAK_User_Story__c > mapStoryInsertFields = new Map < Id, TRAK_User_Story__c > ();
        Map < Id, TRAK_User_Story__c > mapStoryUpdateFields = new Map < Id, TRAK_User_Story__c > ();
        Map < Id, TRAK_User_Story__c > mapTimeStampFields = new Map < Id, TRAK_User_Story__c > ();
        for (TRAK_User_Story__c thisUS: trigger.new) {
            if (thisUS.Acceptance_Criteria__c != trigger.oldMap.get(thisUS.id).Acceptance_Criteria__c) {
                mapStoryAC.put(thisUS.id, trigger.oldMap.get(thisUS.id).Acceptance_Criteria__c);
            }
            if (thisUS.Compliance_Criteria__c != trigger.oldMap.get(thisUS.id).Compliance_Criteria__c) {
                mapStoryCC.put(thisUS.id, trigger.oldMap.get(thisUS.id).Compliance_Criteria__c);
            }
            if ((trigger.oldMap.get(thisUS.id).Approval_Status__c != 'Pending Approval' && thisUS.Approval_Status__c == 'Pending Approval')) {
                mapStoryInsertFields.put(thisUS.id, thisUS);
            }
            if ((thisUS.Approval_Status__c != trigger.oldMap.get(thisUS.id).Approval_Status__c && trigger.oldMap.get(thisUS.id).Approval_Status__c == 'Pending Approval' && (thisUS.Approval_Status__c == 'Approved' || thisUS.Approval_Status__c == 'Rejected'))) {
                mapStoryUpdateFields.put(thisUS.id, thisUS);
            }
        }
        if (!mapStoryInsertFields.isEmpty()) {
            TRAK_UserStoryTriggerClass.createNewApprovalHistoryRecord(mapStoryInsertFields);
        }
        TRAK_UserStoryTriggerClass.createNewACHistoryRecord(mapStoryAC, mapStoryCC);
        //autoburndown        
        Set < Id > affectedSprints = new Set < Id > ();
        for (TRAK_User_Story__c us: trigger.new) {
            affectedSprints.add(us.Allocated_Sprint__c);
        }
        for (Id sprint: affectedSprints) {
            TRAK_automate_BurnDown.updateSprintBurndown(sprint);
        }        
        
    }
    if (trigger.isBefore && trigger.isUpdate) {
    Flag=false;
    TRAK_UserStoryTriggerClass.populateManualStep(Flag,trigger.new,trigger.newMap,trigger.oldMap);
    TRAK_UserStoryTriggerClass.setApprovalStatusToOpen(trigger.new, trigger.oldMap);
    }
    
    if(trigger.isAfter && trigger.isUpdate) {
    TRAK_UserStoryTriggerClass.populateNumberOfUserStories(trigger.new,trigger.old);
    }
    if(trigger.isAfter && (trigger.isInsert || trigger.isUndelete)) {
    TRAK_UserStoryTriggerClass.populateNumberOfUserStories(trigger.new,new List<TRAK_User_Story__c>());    
    }
    if(trigger.isAfter && trigger.isDelete) {
    TRAK_UserStoryTriggerClass.populateNumberOfUserStories(new List<TRAK_User_Story__c>(),trigger.old);
    }
}