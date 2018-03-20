/************************************************************************
 **  Developer  :  Deloitte
 **  Date       :  8-Jan-2017
 **  Purpose    :  For unit testing of TRAK_Test_Script_StepTriggerClass 
 ************************************************************************/
@isTest(seeAllData = false)

public class Test_TRAK_Test_Script_StepTriggerClass {


        /*****************************************************************************************************************
         **  @Method Name     :   Test_theEntireClass
         **  @Purpose         :   This method is to create test data and test various in TRAK_Test_Script_StepTriggerClass 
         ****************************************************************************************************************/
         
    static testMethod void Test_theEntireClass() {

        List < User > u = TRAK_Test_Utility.createUser('Senior System Administrator', 3, 'test');
        System.assertNotEquals(u[0].id, null);
        System.assertNotEquals(u[1].id, null);
        System.assertNotEquals(u[2].id, null);
        System.runAs(u[0]) {

            TRAK_User_Story__c userstory = new TRAK_User_Story__c(
                I_Want_To__c = 'Test-Description-User-Stroy',
                Acceptance_Criteria__c = 'Test-Acceptance-Criteria',
                Story_Points__c = '13',
                Story_Points_Other__c = '13',
                Development_Stage__c = 'Backlog',
                Priority__c = 0,
                System_Owner__c = u[1].Id,
                System_Custodian__c = u[0].Id);
            insert userstory;
            System.assertNotEquals(userstory, null);

            //insert approver
            User approver = new User(
                Alias = 'aprvr1',
                Email = 'approver@TRAK-testscript.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'User',
                FirstName = 'Approver',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                ProfileId = Userinfo.getProfileId(),
                TimeZoneSidKey = 'America/Chicago',
                Username = 'stakeholder@TRAK-test' + Math.round(Math.random() * 10000) + '.com',
                UserRoleId = null,
                Country = 'United States');
            insert approver;
            System.assertNotEquals(approver, null);

            List < TRAK_Test_Templates__c > ltestScripts = new List < TRAK_Test_Templates__c > ();
            TRAK_Test_Templates__c testScript = new TRAK_Test_Templates__c(
                User_Story__c = userstory.Id,
                Title__c = 'My test template title',
                Introduction__c = 'My test template introduction',
                Approver__c = approver.Id,
                Approval_Status__c = 'Open');
            ltestScripts.add(testScript);

            TRAK_Test_Templates__c testScript1 = new TRAK_Test_Templates__c(
                User_Story__c = userstory.Id,
                Title__c = 'My test template title',
                Introduction__c = 'My test template introduction',
                Approver__c = approver.Id,
                Approval_Status__c = 'Open');
            ltestScripts.add(testScript1);
            insert ltestScripts;
            System.assert(ltestScripts.size() == 2);

            TRAK_Test_Template_Steps__c testScriptStep1 = new TRAK_Test_Template_Steps__c(
                Test_Script__c = ltestScripts[0].Id,
                Action__c = 'Test 1',
                Expected_Result__c = 'Test 1',
                Tips__c = 'Test 1');

            TRAK_Test_Template_Steps__c testScriptStep2 = new TRAK_Test_Template_Steps__c(
                Test_Script__c = ltestScripts[0].Id,
                Action__c = 'Test 2',
                Expected_Result__c = 'Test 2',
                Tips__c = 'Test 2');

            Test.StartTest();
            List < TRAK_Test_Template_Steps__c > ltestScriptSteps = new List < TRAK_Test_Template_Steps__c > ();
            //Test the updateSequenceNumberOnInsert method.

            ltestScriptSteps.add(testScriptStep1);
            ltestScriptSteps.add(testScriptStep2);
            insert ltestScriptSteps;
            System.assert(ltestScriptSteps.size() == 2);
            TRAK_Test_Script_StepTriggerClass.updateSequenceNumberOnInsert(null);
            //Test the updateSequenceNumberOnDelete method.
            delete testScriptStep1;
            delete testScriptStep2;
            TRAK_Test_Script_StepTriggerClass.updateSequenceNumberOnDelete(null);
            Test.StopTest();
        }
    }
}