/******************************************************************************************************************************************
* Class Name   : TRAK_Test_SubmitForApproval 
* Description  : Test class for the Submit for Approval Page. 
* Created By   : Deloitte Consulting
*****************************************************************************************************************************************/
@istest
public class TRAK_Test_SubmitForApproval {
    public static User sysOwner;
    public static User sysCustodian;
    public static TRAK_User_Story_Approval_History__c usApproval;
    public static TRAK_User_Story__c story;
      public Boolean NoStatusUpdated {get;set;}
    /*
* @Method Name                    :  setupTestData
* @Description                    :  Used to set up the test data of Creating 2 users of System Owner and System Custodian. 
* @Return Type                    :  void
*/
    public static testMethod void setupTestData() {
        //Creating the test user for Approver
        sysCustodian = new User();
        sysCustodian.username = 'sysCustodian@Test.com.env';
        sysCustodian.Email = 'sysCustodian@Test.com';
        sysCustodian.profileid = UserInfo.getProfileId();
        sysCustodian.lastname = 'Owner';
        sysCustodian.firstname = 'System';
        sysCustodian.Alias = 'syo';
        sysCustodian.TimeZoneSidKey = 'America/Los_Angeles';
        sysCustodian.LocaleSidKey = 'en_US';
        sysCustodian.EmailEncodingKey = 'UTF-8';
        sysCustodian.LanguageLocaleKey = 'en_US';
        insert sysCustodian;
        sysOwner = new User();
        sysOwner.username = 'sysOwner@Test.com.env';
        sysOwner.Email = 'sysOwner@Test.com';
        sysOwner.profileid = UserInfo.getProfileId();
        sysOwner.lastname = 'Owner';
        sysOwner.firstname = 'System';
        sysOwner.Alias = 'syo';
        sysOwner.TimeZoneSidKey = 'America/Los_Angeles';
        sysOwner.LocaleSidKey = 'en_US';
        sysOwner.EmailEncodingKey = 'UTF-8';
        sysOwner.LanguageLocaleKey = 'en_US';
        sysOwner.ManagerId = sysCustodian.Id;
        insert sysOwner;
        System.runAs(sysOwner) {
            story = new TRAK_User_Story__c();
            story.System_Custodian__c = UserInfo.getUserId();
            story.User__c = null;
            story.System_Owner__c = sysCustodian.Id;
            story.approval_status__c = 'Open';
            story.Development_Stage__c = 'Backlog';
            insert story;
            TRAK_Release_Tracker__c rtObj = new TRAK_Release_Tracker__c();
            rtObj.Disable_Approval_Validation__c = false;
            insert rtObj;
            usApproval = new TRAK_User_Story_Approval_History__c();
            usApproval.User_Story__c = story.Id;
            usApproval.System_Owner__c = story.System_Owner__c;
            usApproval.System_Custodian__c = story.System_Custodian__c;
            insert usApproval;
            
            System.assert(usApproval.Id != null);
            List<ProcessInstanceWorkitem> lRecordUnderApproval = [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: usApproval.Id];
            System.assert(lRecordUnderApproval.size() > 0);
        }
    }
    /*
* @Method Name                    :  testSendEmail
* @Description                    :  Used to test the functionality of recall approval request method. 
* @Return Type                    :  void
*/    
    public static testMethod void testSendEmail() {
        setupTestData();
        TRAK_SubmitForApproval.SendEmailMethod(story.id);
        TRAK_SubmitForApproval.recallApprovalRequest(usApproval.Id);
        
        List<ProcessInstanceWorkitem> lRecordUnderApproval = [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: usApproval.Id];
            System.assert(lRecordUnderApproval.size() == 0);
        
    }
    
        /*
* @Method Name                    :  testRecallApprovalNegativeScenario
* @Description                    :  Used to test the functionality of recall approval request method. 
* @Return Type                    :  void
*/    
    public static testMethod void testRecallApprovalNegativeScenario() {
        setupTestData();
        try {
        TRAK_SubmitForApproval.recallApprovalRequest(story.Id);
        } catch(Exception excep) {
        System.assertEquals(excep.getMessage(), 'ad');
        }
        
        List<ProcessInstanceWorkitem> lRecordUnderApproval = [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: usApproval.Id];
            System.assert(lRecordUnderApproval.size() > 0);
        
    }
}