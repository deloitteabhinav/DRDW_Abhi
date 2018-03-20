@isTest(seeallData = false)
    /*
     *@ Class Name            : Test_ApprovalController
     *@ CreatedB              : Deloitte Consulting
     *@ CreatedOn             : 29-12-2015
     *@ Modification Log      : Added System.assertstatements  
     *@ Modified on/by        : 19-12-2016/Karthik Kannan
     */
public class Test_TRAK_Sandbox_Refresh_Log_Trigger {

     /*
* @Method Name                    :  test_Test_TRAK_Sandbox_Refresh_Log_TriggerHandler
* @Description                    :  Testing the createTasks method 
* @Return Type                    :  void
*/
    Static testMethod void test_Test_TRAK_Sandbox_Refresh_Log_TriggerHandler() {
        List < User > lUsr = Test_utility.createUser('Senior System Administrator', 1, 'ab');
        update lUsr[0];
        System.runas(lUsr[0]) {
            Test.startTest();
            List < TRAK_Release__c > lTRelease = TRAK_Test_Utility.createRelease(1, 'Monthly');
            lTRelease[0].Name = 'R10';
            lTRelease[0].Tag__c = 'TAG_1';
            lTRelease[0].CR_Number__c = 'test';
            lTRelease[0].Code_Review_Completed__c = true;
            lTRelease[0].Approved_for_Pre_Production__c = true;
            lTRelease[0].Branch_Name__c = 'develop_dummy';
            lTRelease[0].Commit_ID__c = 'wu3nd3dm';
            lTRelease[0].release_Type__c = 'Monthly';
            lTRelease[0].Override_Release_Name__c = true;
            lTRelease[0].Repository_Name__c = 'Trialforce';
            lTRelease[0].Approval_Status__c = 'Draft';
            insert lTRelease;

            TRAK_Release_Tracker__c relTrakObj = new TRAK_Release_Tracker__c();
            relTrakObj.Name = 'Test';
            relTrakObj.Sandbox_Refresh_Approver__c = Userinfo.getUserId();
            insert relTrakObj;

            TRAK_Environment__c env = new TRAK_Environment__c();
            insert env;

            TRAK_Environment_Release__c environmentReleaseObj = new TRAK_Environment_Release__c();
            environmentReleaseObj.Release__c = lTRelease[0].id;
            insert environmentReleaseObj;
            System.assert(environmentReleaseObj.id != null);

            TRAK_Sandbox_Task_List__c sandboxTaskListObj = new TRAK_Sandbox_Task_List__c();
            sandboxTaskListObj.Instructions__c = 'Test Data';
            sandboxTaskListObj.Task_Type__c = 'Sandbox Refresh';
            insert sandboxTaskListObj;

            TRAK_Sandbox_Refresh_Log__c sandboxRefreshObj = new TRAK_Sandbox_Refresh_Log__c();
            sandboxRefreshObj.Environment__c = env.Id;
            sandboxRefreshObj.Completed__c = false;
            insert sandboxRefreshObj;
            Map < Id, TRAK_Sandbox_Refresh_log__c > mOldSandboxRefresh = new Map < Id, TRAK_Sandbox_Refresh_log__c > ([Select Id, Name from TRAK_Sandbox_Refresh_log__c where Id =: sandboxRefreshObj.Id]);
            sandboxRefreshObj.Completed__c = true;
            update sandboxRefreshObj;
            TRAK_Sandbox_Refresh_Log_TriggerHandler.createTasks(new List < TRAK_Sandbox_Refresh_Log__c > {
                sandboxRefreshObj});
            TRAK_Sandbox_Refresh_Log_TriggerHandler.completeSandboxRefreshLog(new List < TRAK_Sandbox_Refresh_Log__c > {
                sandboxRefreshObj}, mOldSandboxRefresh);    
            Test.stopTest();
            List<Task> lTask = [Select Id,Subject,Status from Task where WhatId = :sandboxRefreshObj.id];
            lTask[0].Status = 'Completed';
            update ltask;
            TRAK_Sandbox_Refresh_Log_TriggerHandler.completeSandboxRefreshLog(new List < TRAK_Sandbox_Refresh_Log__c > {
                sandboxRefreshObj}, mOldSandboxRefresh);   
            System.assertNotEquals(lTask.size() , 0);
            System.assertEquals(lTask.size() , 1);
            
        }
    }
}