/*************************************************************************\
@ Author        : Deloitte Digital
@ Date          : 1-Apr-2016
@ Test Class    : 
@ Description   : This class is used as for controlling the record locking based on Approvals on Release object.
****************************************************************************/
public with sharing class TRAK_Release_Trigger_Handler    {
    public static Boolean isFirstTime = false;
    public static final string GSO3_RECORDTYPE = 'GSO 3 Self Service';
    public static final string GSO1_RECORDTYPE = 'GSO 1 Self Service';
    public static final string GSO2_RECORDTYPE = 'GSO 2 Self Service';
    public static final string SYSTEM_ADMIN_PROFILE = 'System Administrator';
    public static final string TRAK_ADMIN = 'TRAK_Admin';
    public static final string gso1gso2ErrorMessage = 'You are not allowed to edit this record as the Production Approval is complete';
    public static final string gso3ErrorMessage = 'You are not allowed to edit these fields as the Pre-Production Approval is complete';
    public static final string gso3RejectErrorMessage = 'You are not allowed to edit these fields as the Release is rejected';
    public static final string gso3ProdApprovalErrorMessage = 'You are not allowed to edit these fields as the Production Approval is complete';
    
    /** 
* Method to update the status of user stories when release is approved for production
* 
* US-44057
* @Param Map<ID,TRAK_Release__c>, Map<ID,TRAK_Release__c>
* @return void
* @throws NA
*/
    public static void updateUserStoriesandDefects(Map<ID,TRAK_Release__c>oldReleaseMap,Map<ID,TRAK_Release__c>newReleaseMap)
    {
        Set <Id> ReleaseIds = new set<Id>();
        List<TRAK_User_Story__c> lst_UsrStoriesToUpdate = new list<TRAK_User_Story__c>();
        List<TRAK_Bug__c> lst_Bugs = new list<TRAK_Bug__c>();
        for(TRAK_Release__c release:oldReleaseMap.values())
        {
            if(!(release.Approval_Status__c == 'Production - Released') && newReleaseMap.get(release.id).Approval_Status__c == 'Production - Released')
            { 
                ReleaseIds.add(release.id);     
            }
        }
        List<TRAK_User_Story__c> lstUsrStories = [Select id,Development_Stage__c,Close_Date__c from TRAK_User_Story__c where Cirrus_Release__c in :ReleaseIds ];
        List<TRAK_Bug__c> lstDefects = [Select id,Status__c from TRAK_Bug__c where Production_Release__c in :ReleaseIds];
        for(TRAK_User_Story__c usrStory : lstUsrStories)
        {
            usrStory.Development_Stage__c  = Label.TRAK_UserStory_ProductionReleased;
            usrStory.Close_Date__c = date.today();
            lst_UsrStoriesToUpdate.add(usrStory);
        }
        for(TRAK_Bug__c bug:lstDefects)
        {
            bug.Status__c = Label.TRAK_UserStory_ProductionReleased;
            lst_Bugs.add(bug); 
        }
        try{
            update lst_UsrStoriesToUpdate;
            update lst_Bugs;
        }
        catch(Exception ex){
            TRAK_ErrorHandler.createApplicationException('TRAK_Release_Trigger_Handler', 'updateUserStories',ex.getStackTraceString(), ex.getTypeName());
        }
    }
    
    /** 
* Method to update the status of user stories when release is approved for production
* 
* US-44057
* @Param List<TRAK_Release__c>
* @return void
* @throws NA
*/
    public static void setReleaseName(List<TRAK_Release__c> lRelease) {
        Set<String> sWeeklyRelease = new Set<String>();
        Set<String> sHotfixRelease = new Set<String>();
        String latestMonthlyReleaseName = 'R10';
        Integer latestMonthlyReleaseNumber = 10;
        List<TRAK_Release__c> latestMonthlyRelease = [Select Id,Name from TRAK_Release__c where Release_Type__c = 'Monthly' and Override_Release_Name__c = false order by Release_Number__c desc Limit 1];
        if(latestMonthlyRelease.size() > 0) {
            latestMonthlyReleaseName = latestMonthlyRelease[0].Name;
            latestMonthlyReleaseNumber = Integer.valueOf(latestMonthlyReleaseName.substring(1));
        }
        List<TRAK_Release__c> lReleases = [Select Id,Name from TRAK_Release__c where Release_Type__c IN ('Weekly','Hotfix') and 
                                           Name like :latestMonthlyReleaseName+'%' and Override_Release_Name__c = false order by Release_Date__c desc Limit 1000];
        Integer monthlyReleaseCount = 0;
        Integer weeklyReleaseCount = 0;
        Integer hotfixReleaseCount = 0;
        if(lReleases.size() > 0) {
            for(TRAK_Release__c oRelease : lReleases) {
                if(oRelease.Name.contains('H')) {
                    sHotfixRelease.add(oRelease.Name);
                }
                if(!oRelease.Name.contains('H')) {
                    sWeeklyRelease.add(oRelease.Name);
                }
            }
        }
        
        for(TRAK_Release__c oRelease : lRelease) {
            if(oRelease.Override_Release_Name__c == false) {
                if(oRelease.Release_Type__c == 'Weekly') {
                    if(lRelease.size() > 0) {
                        oRelease.Name = 'R'+String.valueOf(latestMonthlyReleaseNumber)+'.'+Integer.valueOf(sWeeklyRelease.size()+weeklyReleaseCount+1);
                        weeklyReleaseCount = weeklyReleaseCount + 1;    
                    }
                } else if(oRelease.Release_Type__c == 'Monthly') {
                    oRelease.Name = 'R'+String.valueOf((latestMonthlyReleaseNumber+latestMonthlyRelease.size()+monthlyReleaseCount));
                    monthlyReleaseCount = monthlyReleaseCount + 1;
                } else if(oRelease.Release_Type__c == 'Hotfix') { 
                    oRelease.Name = 'R'+String.valueOf(latestMonthlyReleaseNumber)+'-H'+Integer.valueOf(sHotfixRelease.size()+hotfixReleaseCount+1);
                    hotfixReleaseCount = hotfixReleaseCount + 1;     
                }
            }  
        }
        
    }
    
        public static void createRefreshTasks(List<TRAK_Release__c> lRelease, Map<ID,TRAK_Release__c> oldReleaseMap) {
            
            List < Task > lSandboxTaskList = new List < Task > ();
        try {
            for (TRAK_Sandbox_Task_List__c tasklistObj: [Select Id, Name, Instructions__c from TRAK_Sandbox_Task_List__c 
            where Task_Type__c = 'Release' Limit 2000]) {
                for(TRAK_Release__c oRelease: lRelease) {
                    if((oldReleaseMap.get(oRelease.Id).Approval_Status__c != 'Pre - Production Deployed') && 
                    (oRelease.Approval_Status__c == 'Pre - Production Deployed')) {
                    Task taskObj = new Task();
                    taskObj.OwnerId = Userinfo.getUserId();
                    taskObj.Type = 'Other';
                    taskObj.WhatId = oRelease.Id;
                    taskObj.ActivityDate = Date.today();
                    taskObj.Subject = taskListObj.Instructions__c;
                    lSandboxTaskList.add(taskObj);
                    }
                }
            }

            if (lSandboxTaskList.size() > 0) {
                if (isFirstTime == false) {
                    isFirstTime = true;
                    insert lSandboxTaskList;
                }
            }
        } catch (Exception ex) {
            TF_ErrorLogUtility.createErrorLog(ex,
                new TF_ErrorLogWrapper('TRAK_Sandbox_Refresh_Log_TriggerHandler',
                    'createTasks', 'Error in the class TRAK_Sandbox_Refresh_Log_TriggerHandler', '1'));
        }

        }
    
}