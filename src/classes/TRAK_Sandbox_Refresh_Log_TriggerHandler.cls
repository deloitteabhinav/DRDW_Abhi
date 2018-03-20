/*
     *@ Class Name            : TRAK_Sandbox_Refresh_Log_TriggerHandler
     *@ CreatedB              : Deloitte Consulting
     *@ CreatedOn             : 29-12-2015
     *@ Modification Log      : Added System.assertstatements  
     *@ Modified on/by        : 19-12-2016/Karthik Kannan
     */
public class TRAK_Sandbox_Refresh_Log_TriggerHandler {

    public static Boolean isFirstTime = false;
     /*
* @Method Name                    :  createTasks
* @Description                    :  Once a sandbox refresh log is created, tasks are inserted from sandbox task list object. 
* @Return Type                    :  void
*/
    public static void createTasks(List < TRAK_Sandbox_Refresh_Log__c > lSandboxRefresh) {

        List < Task > lSandboxTaskList = new List < Task > ();
        try {
            for (TRAK_Sandbox_Task_List__c tasklistObj: [Select Id, Name, Instructions__c from TRAK_Sandbox_Task_List__c Limit 2000]) {
                for (TRAK_Sandbox_Refresh_Log__c sandboxRefreshObj: lSandboxRefresh) {
                    Task taskObj = new Task();
                    taskObj.OwnerId = Userinfo.getUserId();
                    taskObj.Type = 'Other';
                    taskObj.WhatId = sandboxRefreshObj.Id;
                    taskObj.ActivityDate = Date.today();
                    taskObj.Subject = taskListObj.Instructions__c;
                    lSandboxTaskList.add(taskObj);
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
/*
* @Method Name                    :  completeSandboxRefreshLog
* @Description                    :  Ensure all the tasks are completed before Marking the sandbox refresh log as complete. 
* @Return Type                    :  void
*/
    public static void completeSandboxRefreshLog(List < TRAK_Sandbox_Refresh_Log__c > lSandboxRefresh, Map < Id, TRAK_Sandbox_Refresh_Log__c > mSandboxRefresh) {

        List < Task > lSandboxTaskList = new List < Task > ();
        try {
            Set < String > sSandboxSet = new Set < String > ();
            for (TRAK_Sandbox_Refresh_Log__c sandboxRefreshObj: lSandboxRefresh) {
                if (sandboxRefreshObj.Completed__c == true && mSandboxRefresh.get(sandboxRefreshObj.Id).Completed__c == false) {
                    sSandboxSet.add(sandboxRefreshObj.Id);
                }
            }
            if (sSandboxSet.size() > 0) {
                Map < Id, TRAK_Sandbox_Refresh_Log__c > lHasOpenActivities = new Map < Id, TRAK_Sandbox_Refresh_Log__c > ([Select Id, Name, (Select Id from OpenActivities) from TRAK_Sandbox_Refresh_Log__c where Id IN: sSandboxSet]);
                if (lHasOpenActivities.size() > 0) {
                    for (TRAK_Sandbox_Refresh_Log__c oSandbox: lSandboxRefresh) {
                        if (lHasOpenActivities.get(oSandbox.Id) != null && lHasOpenActivities.get(oSandbox.Id).OpenActivities != null && lHasOpenActivities.get(oSandbox.Id).OpenActivities.size() > 0) {
                            oSandbox.addError('Please complete all the Tasks before marking the sandbox refresh as completed. ');
                        }
                    }
                }
            }
        } catch (Exception ex) {
            TF_ErrorLogUtility.createErrorLog(ex,
                new TF_ErrorLogWrapper('TRAK_Sandbox_Refresh_Log_TriggerHandler',
                    'createTasks', 'Error in the class TRAK_Sandbox_Refresh_Log_TriggerHandler', '1'));
        }

    }



}