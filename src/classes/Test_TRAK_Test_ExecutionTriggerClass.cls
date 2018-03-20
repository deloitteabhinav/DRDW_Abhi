/*
*@ Class Name                                                    : Test_ TRAK_Test_ExecutionTriggerClass
*@ Description                                                   : Test class for TRAK_Test_ExecutionTriggerClass
*@ CreatedBy                                                     : Deloitte Consulting
*@ CreatedOn                                                     : 12/8/2016

*/

@isTest( seeAllData = false )
public class Test_TRAK_Test_ExecutionTriggerClass{

static testMethod void Test_TRAK_TestScriptClone(){
    List <User> u = Test_Utility.createUser('Senior System Administrator',1, 'ab');
        System.runAs(u[0]){
            test.startTest();
            Map<id,TRAK_Test__c> oldMapTest = new Map<id,TRAK_Test__c>();
            Map<id,TRAK_Test__c> newMapTest = new Map<id,TRAK_Test__c>();
            Set<Id> SprintIds = new Set<Id>();
            
            //Create Sprint
            List<TRAK_Sprint__c> lSprints = Trak_Test_Utility.createSprint(1);
            insert lSprints;
            system.assertEquals(lSprints.size(),1);
            SprintIds.add(lSprints[0].id);
            
            //Create User Story
            List<TRAK_User_Story__c> lUsrStory = TRAK_Test_Utility.createUserStory(1);
            insert lUsrStory;
            system.assertEquals(lUsrStory.size(),1);
            
            //Insert Test
            TRAK_Test__c oTest = new TRAK_Test__c();
            oTest.Status__c = 'Not Started';
            oTest.User_Story__c = lUsrStory[0].id;
            insert oTest;
            system.assertnotEquals(oTest.id,null);
            oldMapTest.put(oTest.id, oTest);
            
            //Insert Test Execution History
            TRAK_Test_Execution_History__c newTestExecHistoryRecord = new TRAK_Test_Execution_History__c();
            newTestExecHistoryRecord.Test_Execution__c = oTest.Id;
            newTestExecHistoryRecord.Approver__c = Userinfo.getUserID();
            newTestExecHistoryRecord.Approval_Date__c = System.today();
            newTestExecHistoryRecord.Approval_Status__c = 'Open';
            newTestExecHistoryRecord.Overall_Test_Comments__c = 'testcom';
            newTestExecHistoryRecord.Test_Outcome__c = 'outcomes';
            insert newTestExecHistoryRecord;
            system.assertnotEquals(newTestExecHistoryRecord.id,null);
            
            oTest.Status__c = 'Pending Approval';
            update oTest;
            newMapTest.put(oTest.id, oTest);
            TRAK_Test_ExecutionTriggerClass.createNewTestExecutionHistoryRecord(newMapTest);
            TRAK_Test_ExecutionTriggerClass.updateApprovalDate(newMapTest);
            TRAK_Test_ExecutionTriggerClass.updateCompletedExecutionCountOnSprint(newMapTest, sprintIds);
            TRAK_Test_ExecutionTriggerClass.updateTestExecutionDate(oTest.id);
            
            //Added to cover TRAK_Test_Execution_Trigger
            oTest.Approval_Status__c = 'Approved';
            update oTest;
            oldMapTest.put(oTest.id, oTest);
            
            oTest.Approval_Status__c = 'Pending Approval';
            oTest.Status__c = 'Pending Approval';
            update oTest;
            newMapTest.put(oTest.id, oTest);
            
            //Added to cover TRAK_Test_Execution_Trigger
            oTest.Approval_Status__c = 'Rejected';
            oTest.Sprint__c = lSprints[0].id;
            oTest.Status__c = 'Complete';
            update oTest;
            newMapTest.put(oTest.id, oTest);
        }
    }
}