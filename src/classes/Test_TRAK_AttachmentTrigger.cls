/*************************************************************************\
    @ Author        : Nitish Kumar
    @ Date          : 03-Sept-2014
    @ Description   : Test Class for TRAK_AttachmentTrigger
    @ Modification log : Neha Kumari[19-Dec-2016]
****************************************************************************/
@isTest(seeAllData = false)

private class Test_TRAK_AttachmentTrigger {

    //public static TRAK_Project__c project;
    public static TRAK_User_Story__c testUserStory;
    public static TRAK_Test_Templates__c testScript;
    public static TRAK_Test_Template_Steps__c testScriptStep;
    public static TRAK_Test__c testExecution;
    public static TRAK_Test_Steps__c testExecutionStep;
    public static list < Attachment > insertAttachment;

    /**************************************************************************
     **  @Method Name     :   setupTestData
     **  @Purpose         :   This method is to create test data to test the class TRAK_AttachmentTriggerUtility
     ****************************************************************************/

    static testMethod void setupTestData() {


        List < User > sysCustodian = new List < User > ();
        sysCustodian = TRAK_Test_Utility.createUser('Global COPM', 2, 'sysC');
        List < PermissionSetAssignment > sysPerm = new List < PermissionSetAssignment > ();
        sysPerm = TRAK_Test_Utility.createPermissionSet(2, sysCustodian);

        //Insert User Story
        testUserStory = new TRAK_User_Story__c();
        testUserStory.Acceptance_Criteria__c = 'OldAcceptanceCriteria';
        testUserStory.Compliance_Criteria__c = 'OldCC';
        testUserStory.Approval_Status__c = 'Open';
        testUserStory.Development_Stage__c = 'Backlog';
        testUserStory.System_Custodian__c = sysCustodian[0].id;
        testUserStory.System_Owner__c = sysCustodian[1].id;
        insert testUserStory;
        system.assertnotequals(testUserStory.id, null);

        insertAttachment = new list < Attachment > ();

        //Insert Test Script
        testScript = new TRAK_Test_Templates__c();
        testScript.User_Story__c = testUserStory.Id;
        testScript.Introduction__c = 'Test';
        testScript.Title__c = 'Test';
        testScript.Approval_Status__c = 'Approved';
        insert testScript;
        system.assertnotequals(testScript.id, null);

        Attachment attachScript = new Attachment();
        attachScript.Name = 'Test Attachment';
        Blob bodyBlobScript = Blob.valueOf('Unit Test Attachment Body');
        attachScript.body = bodyBlobScript;
        attachScript.parentId = testScript.id;
        insertAttachment.add(attachScript);

        //Insert Test Script Step
        testScriptStep = new TRAK_Test_Template_Steps__c();
        testScriptStep.Test_Script__c = testScript.Id;
        insert testScriptStep;
        system.assertnotequals(testScriptStep.id, null);

        Attachment attachScriptStep = new Attachment();
        attachScriptStep.Name = 'Test Attachment';
        Blob bodyBlobScriptStep = Blob.valueOf('Unit Test Attachment Body');
        attachScriptStep.body = bodyBlobScriptStep;
        attachScriptStep.parentId = testScriptStep.id;
        insertAttachment.add(attachScriptStep);

        //Insert Test Execution
        testExecution = new TRAK_Test__c();
        testExecution.User_Story__c = testUserStory.Id;
        testExecution.Template__c = testScript.Id;
        testExecution.Approval_Status__c = 'Open';
        insert testExecution;
        system.assertnotequals(testExecution.id, null);

        Attachment attachExecution = new Attachment();
        attachExecution.Name = 'Test Attachment';
        Blob bodyBlobExecution = Blob.valueOf('Unit Test Attachment Body');
        attachExecution.body = bodyBlobExecution;
        attachExecution.parentId = testExecution.id;
        insertAttachment.add(attachExecution);

        //Insert Test Execution Step
        testExecutionStep = new TRAK_Test_Steps__c();
        testExecutionStep.Test__c = testExecution.Id;
        testExecutionStep.Template_Step__c = testScriptStep.Id;
        insert testExecutionStep;
        system.assertnotequals(testExecutionStep.id, null);

        Attachment attachExecutionStep = new Attachment();
        attachExecutionStep.Name = 'Test Attachment';
        Blob bodyBlobExecutionStep = Blob.valueOf('Unit Test Attachment Body');
        attachExecutionStep.body = bodyBlobExecutionStep;
        attachExecutionStep.parentId = testExecutionStep.id;
        insertAttachment.add(attachExecutionStep);
        insert insertAttachment;
        system.assert(insertAttachment.size() == 4);

        testExecution.Approval_Status__c = 'Approved';
        update testExecution;
        system.assertequals(testExecution.Approval_Status__c, 'Approved');
    }

    /**************************************************************************
     **  @Method Name     :   testAttachmentTrigger
     **  @Purpose         :   This method is to test the class TRAK_AttachmentTriggerUtility
     ****************************************************************************/

    static testMethod void testAttachmentTrigger() {
        setupTestData();
        List < User > usr = TRAK_Test_Utility.createUser('Senior System Administrator', 1, 'xyz');
        system.runAs(usr[0]) {
            Test.StartTest();
            try {
                delete insertAttachment;
                system.assertequals(insertAttachment.size(), 4);
            }
            Catch(Exception ex) {}

            testScript.Approval_Status__c = 'Open';
            update testScript;
            system.assertequals(testScript.Approval_Status__c, 'Open');

            testExecution.Approval_Status__c = 'Open';
            update testExecution;
            system.assertequals(testExecution.Approval_Status__c, 'Open');

            delete insertAttachment;
            Test.StopTest();
        }
    }

}