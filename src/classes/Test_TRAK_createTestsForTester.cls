/******************************************************************************************************************************************
 * Class Name   : Test_TRAK_createTestsForTester
 * Description  : Test Class for TRAK_createTestsForTester
 * Created By   : Deloitte Consulting
 *
 *****************************************************************************************************************************************/
@isTest
private class Test_TRAK_createTestsForTester {
    public static testMethod void testTriggerFn() {
        List < User > lstUser = TRAK_Test_Utility.createUser('System Administrator', 1, 'Ab');
        system.runAs(lstUser[0]) {
        Test.startTest();
            List < TRAK_Test_Templates__c > TT = TRAK_Test_Utility.createTestScript(1);
            TT[0].Approval_Status__c = 'Approved';
            insert TT;
            TRAK_Test_Template_Steps__c TTStep = new TRAK_Test_Template_Steps__c();
            TTStep.Test_Script__c = TT[0].id;
            insert TTStep;
            TT[0].Approval_Status__c = 'Approved';
            update TT;
            TRAK_Tester__c tester = new TRAK_Tester__c();
            tester.Test_Phase__c = 'Sprint Test';
            tester.User__c = lstUser[0].id;
            tester.Test_Template__c = TT[0].id;
            insert tester;
            Test.stopTest();
            
            List<TRAK_Test__c> lTest = [Select Id  from TRAK_Test__c where Template__c = :TT[0].Id];
            system.assert(lTest.size() > 0);
            List<TRAK_Test_Steps__c> lTestSteps = [Select Id from TRAK_Test_Steps__c where Template_Step__c = :TTStep.Id];
            system.assert(lTestSteps.size() > 0);
            
        }
    }
    
    public static testMethod void testNegativeScenario() {
        List < User > lstUser = TRAK_Test_Utility.createUser('System Administrator', 1, 'Ab');
        system.runAs(lstUser[0]) {
        Test.startTest();
            List < TRAK_Test_Templates__c > TT = TRAK_Test_Utility.createTestScript(1);
            TT[0].Approval_Status__c = 'Approved';
            insert TT;
            TRAK_Test_Template_Steps__c TTStep = new TRAK_Test_Template_Steps__c();
            TTStep.Test_Script__c = TT[0].id;
            insert TTStep;
            TRAK_Tester__c tester = new TRAK_Tester__c();
            tester.Test_Phase__c = 'Sprint Test';
            tester.User__c = lstUser[0].id;
            tester.Test_Template__c = TT[0].id;
            try {
            insert tester;
            } catch(Exception e) {
            System.assert(e.getMessage().contains('You cannot create a Tester record until the related Test Script'));
            }
            Test.stopTest();
            
            List<TRAK_Test__c> lTest = [Select Id  from TRAK_Test__c where Template__c = :TT[0].Id];
            system.assert(lTest.size() == 0);
            List<TRAK_Test_Steps__c> lTestSteps = [Select Id from TRAK_Test_Steps__c where Template_Step__c = :TTStep.Id];
            system.assert(lTestSteps.size() == 0);
            
        }
    }
    
}