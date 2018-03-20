/*
*@ Class Name                                                    : Test_TRAK_TestScriptCloneController
*@ Description                                                   : Test class for SSSC_SafeStart_Story Trigger
*@ CreatedBy                                                     : Deloitte Consulting
*@ CreatedOn                                                     : 24/7/2015
*@ Modification Log                                              : Neha Kumari[19-Dec-2016]

*/

@isTest
public class Test_TRAK_TestScriptCloneController{

static testMethod void Test_TRAK_TestScriptClone(){
    List<User> usr = TRAK_Test_Utility.createUser('Senior System Administrator',1,'xyz');
    system.runAs(usr[0]){
        //Insert Test Template
        List<TRAK_Test_Templates__c> lTestTmplts = TRAK_Test_Utility.createTestScript(1);
        insert lTestTmplts;
        system.assertnotequals(lTestTmplts[0].id,null);
        
        //Insert Test Template Step
        TRAK_Test_Template_Steps__c oTestTemplateSteps = new TRAK_Test_Template_Steps__c();
        oTestTemplateSteps.Action__c = 'Test';
        oTestTemplateSteps.Expected_Result__c = 'Test';
        oTestTemplateSteps.Test_Script__c = lTestTmplts[0].Id;
        oTestTemplateSteps.Test_Script_Step_Number__c = integer.valueof('3');
        insert oTestTemplateSteps;
        system.assertnotequals(oTestTemplateSteps.id,null);
        
        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(lTestTmplts[0]); 
        TRAK_TestScriptCloneController controller = new TRAK_TestScriptCloneController(sc);
       //added assert to satisfy the salesforce best practices-4/1/2017 Deloitte Consulting.
        PageReference pr = controller.cloneWithItems();
		System.assertnotequals(lTestTmplts[0].Id, pr.getUrl());
        
        TRAK_Test_Templates__c oStoryTestTemplate2 = new TRAK_Test_Templates__c();
        ApexPages.StandardController sc2 = new ApexPages.StandardController(oStoryTestTemplate2);   
        TRAK_TestScriptCloneController controller2 = new TRAK_TestScriptCloneController(sc2);
        controller2.cloneWithItems();    
        Test.stopTest();
        }
    }
}