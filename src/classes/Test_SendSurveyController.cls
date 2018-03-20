/* Class Name  : Test_SendSurveyController
* Description  : Test Class for SendSurveyController
* Created By   : Deloitte
* Created Date : 7th December 2015
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
*/

@isTest(SeeAllData = false)
public with sharing class Test_SendSurveyController
{
    private static Account oSupplierAccount;
    private static User oSMIAdmin;
    private static User oSupplierAssessor;
    private static User oFeedbackProvider1;
    private static User oFeedbackProvider2;
    private static User oFeedbackProvider3;
    private static User oFeedbackProvider4;
    private static User oFeedbackProvider5;
    
     /* 
    * @Method Name                    :  createTestData
    * @Description                    :  Method to create Test Users-Admin, Assessor & Feedback providers and Test Questions
    * @Return Type                    :  void
    * @Parameters                     :  None
    */    
    public static void createTestData()
    {
        
        //create Users
        oSMIAdmin=DataFactory.getTestingUser();
        system.assertNotEquals(oSMIAdmin.Id,null);
        oSupplierAssessor=DataFactory.getTestingUser();
        system.assertNotEquals(oSupplierAssessor.Id,null);
        oFeedbackProvider1=DataFactory.getTestingUser();
        system.assertNotEquals(oFeedbackProvider1.Id,null);
        oFeedbackProvider2=DataFactory.getTestingUser();
        system.assertNotEquals(oFeedbackProvider2.Id,null);
        oFeedbackProvider3=DataFactory.getTestingUser();
        system.assertNotEquals(oFeedbackProvider3.Id,null);
        oFeedbackProvider4=DataFactory.getTestingUser();
        system.assertNotEquals(oFeedbackProvider4.Id,null);
        oFeedbackProvider5=DataFactory.getTestingUser();
        system.assertNotEquals(oFeedbackProvider5.Id,null);
        
        //assign permission
        DataFactory.givePermissions(oSMIAdmin.Id,Constants.sSMINAdminPermissionAPI);
        DataFactory.givePermissions(oSupplierAssessor.Id,Constants.sSupplierAssessorPermissionAPI);
        DataFactory.givePermissions(oFeedbackProvider1.Id,Constants.sFeedbackProviderPermissionAPI);
        DataFactory.givePermissions(oFeedbackProvider2.Id,Constants.sFeedbackProviderPermissionAPI);
        DataFactory.givePermissions(oFeedbackProvider3.Id,Constants.sFeedbackProviderPermissionAPI);
        DataFactory.givePermissions(oFeedbackProvider4.Id,Constants.sFeedbackProviderPermissionAPI);
        DataFactory.givePermissions(oFeedbackProvider5.Id,Constants.sFeedbackProviderPermissionAPI);
        
        //assign users to Groups
        DataFactory.assignToPublicGroup(oSMIAdmin.Id,Constants.sSMINAdminPermissionAPI);
        DataFactory.assignToPublicGroup(oSupplierAssessor.Id,Constants.sSupplierAssessorPermissionAPI);
        DataFactory.assignToPublicGroup(oFeedbackProvider1.Id,Constants.sFeedbackProviderPermissionAPI);
        DataFactory.assignToPublicGroup(oFeedbackProvider2.Id,Constants.sFeedbackProviderPermissionAPI);
        DataFactory.assignToPublicGroup(oFeedbackProvider3.Id,Constants.sFeedbackProviderPermissionAPI);
        DataFactory.assignToPublicGroup(oFeedbackProvider4.Id,Constants.sFeedbackProviderPermissionAPI);
        DataFactory.assignToPublicGroup(oFeedbackProvider5.Id,Constants.sFeedbackProviderPermissionAPI);
    }
    
    
    /* 
    * @Method Name                    :  testInitiateFeedbackWithContacts
    * @Description                    :  Method to Initiate feedback wizard where Account has contacts.
    * @Return Type                    :  void
    * @Parameters                     :  None
    */ 
    public static testMethod void testInitiateFeedbackWithContacts()
    {
        createTestData();
        test.StartTest();
        System.runAs(oSMIAdmin)
        {
            //as an SMI Admin create test questions
            List<Question__c> lQuestion=DataFactory.createQuestion(4,2);
            system.assertNotEquals(lQuestion.size(),0);
            insert lQuestion;
        }
        
        System.runAs(oSupplierAssessor)
        {
            //insert supplier account
            oSupplierAccount=DataFactory.returnSupplierAccounts(1)[0];
            oSupplierAccount.Relationship_Owner__c= oFeedbackProvider4.Id;
            oSupplierAccount.Executive_Sponsor__c = oFeedbackProvider1.Id;
            oSupplierAccount.SMO_Representative__c = oFeedbackProvider2.Id;
            insert oSupplierAccount;
            system.assertNotEquals(oSupplierAccount.Id,null);
            //insert contacts under the Account
            List<Contact> lContact=DataFactory.returnSupplierContacts(new List<Account>{oSupplierAccount},3);
            system.assertNotEquals(lContact.size(),0);
            insert lContact;
            
            //initiate feedback for the supplier
            ApexPages.StandardController sc = new ApexPages.StandardController(oSupplierAccount);
            SendSurveyController surveyCtrl = new SendSurveyController(sc);
            system.assert(surveyCtrl.mUserContactCheckboxWrapper.get('User').size()>0);
            system.assert(surveyCtrl.mUserContactCheckboxWrapper.get('SupplierUser').size()>0);
            system.assertEquals(surveyCtrl.mUserContactCheckboxWrapper.get('Contact').size(),lContact.size());
            System.assertEquals(surveyCtrl.nWizardStepCount,1);
            
            //select first 2 contacts
            surveyCtrl.mUserContactCheckboxWrapper.get('Contact')[0].bIsChecked=true;
            surveyCtrl.mUserContactCheckboxWrapper.get('Contact')[1].bIsChecked=true;
            
            //proceed to the next step to select users
            surveyCtrl.selectUsersStep();
            System.assertEquals(surveyCtrl.nWizardStepCount,2);
            
            //select Feedback providers
            surveyCtrl.mUserContactCheckboxWrapper.get('User')[0].bIsChecked=true;
            surveyCtrl.mUserContactCheckboxWrapper.get('SupplierUser')[0].bIsChecked=true;
            
            //proceed to the next step to submit
            surveyCtrl.confirmationStep();
            System.assertEquals(surveyCtrl.nWizardStepCount,3);
            System.assertNotEquals([select id, Supplier_Account__c from Feedback__c where Supplier_Account__c=:oSupplierAccount.Id].size(),0);
            //close the initiate survey wizard
            surveyCtrl.closeFeedback();
            
        }
        test.stopTest();
    }
    
    /* 
    * @Method Name                    :  testInitiateFeedbackWithOutContacts
    * @Description                    :  Method to Initiate feedback wizard where Account does not have contacts.
    * @Return Type                    :  void
    * @Parameters                     :  None
    */ 
    public static testMethod void testInitiateFeedbackWithOutContacts()
    {
        createTestData();
        test.StartTest();
        System.runAs(oSMIAdmin)
        {
            //as an SMI Admin create test questions
            List<Question__c> lQuestion=DataFactory.createQuestion(4,2);
            system.assertNotEquals(lQuestion.size(),0);
            insert lQuestion;
        }
        
        System.runAs(oSupplierAssessor)
        {
            //insert supplier account
            oSupplierAccount=DataFactory.returnSupplierAccounts(1)[0];
            oSupplierAccount.Relationship_Owner__c= oSMIAdmin.Id;
            oSupplierAccount.Executive_Sponsor__c = oFeedbackProvider1.Id;
            oSupplierAccount.SMO_Representative__c = oFeedbackProvider2.Id;
            insert oSupplierAccount;
            system.assertNotEquals(oSupplierAccount.Id,null);
            //initiate feedback for the supplier
            ApexPages.StandardController sc = new ApexPages.StandardController(oSupplierAccount);
            SendSurveyController surveyCtrl = new SendSurveyController(sc);
            system.assert(surveyCtrl.mUserContactCheckboxWrapper.get('User').size()>0);
            system.assert(surveyCtrl.mUserContactCheckboxWrapper.get('SupplierUser').size()>0);
            //since no contacts are added the below list should not have any contacts
            system.assertEquals(surveyCtrl.mUserContactCheckboxWrapper.get('Contact').size(),0);
            System.assertEquals(surveyCtrl.nWizardStepCount,1);
            
            //proceed to the next step but do not select any user to get error message
            surveyCtrl.selectUsersStep();
            System.assertEquals(surveyCtrl.nWizardStepCount,2);
            //proceed to the next step to submit
            surveyCtrl.confirmationStep();
            //assert to check if you have proceeded to the next step or not
            System.assertEquals(surveyCtrl.nWizardStepCount,2);

            //go back to contacts step
            surveyCtrl.selectContactsStep();
            //select Feedback providers
            surveyCtrl.mUserContactCheckboxWrapper.get('User')[0].bIsChecked=true;
            surveyCtrl.mUserContactCheckboxWrapper.get('SupplierUser')[0].bIsChecked=true;
            
            //proceed to the next step to submit
            surveyCtrl.confirmationStep();
            //check if feedback got inserted
            System.assertNotEquals([select id, Supplier_Account__c from Feedback__c where Supplier_Account__c=:oSupplierAccount.Id].size(),0);
            
        }
        test.stopTest();
    }
    
    /* 
    * @Method Name                    :  testInitiateFeedbackErrorCondition
    * @Description                    :  Method to Initiate feedback wizard when exception occurs
    * @Return Type                    :  void
    * @Parameters                     :  None
    */ 
    public static testMethod void testInitiateFeedbackErrorCondition()
    {
        createTestData();
        test.StartTest();
        System.runAs(oSMIAdmin)
        {
            //as an SMI Admin create test questions
            List<Question__c> lQuestion=DataFactory.createQuestion(4,2);
            system.assertNotEquals(lQuestion.size(),0);
            insert lQuestion;
        }
        
        System.runAs(oSupplierAssessor)
        {
            //insert supplier account
            oSupplierAccount=DataFactory.returnSupplierAccounts(1)[0];
            insert oSupplierAccount;
            system.assertNotEquals(oSupplierAccount.Id,null);
            //initiate feedback for the supplier
            ApexPages.StandardController sc = new ApexPages.StandardController(oSupplierAccount);
            SendSurveyController surveyCtrl = new SendSurveyController(sc);
            
            //select Feedback providers
            surveyCtrl.mUserContactCheckboxWrapper.get('User')[0].bIsChecked=true;
            
            //proceed to the next step to submit
            surveyCtrl.oSupplierAccount.Id=null;
            surveyCtrl.insertFeedBack('');
            //Feedback should not be created
            System.assertEquals([select id, Supplier_Account__c from Feedback__c where Supplier_Account__c=:oSupplierAccount.Id].size(),0);
            
        }
        test.stopTest();
    }
}