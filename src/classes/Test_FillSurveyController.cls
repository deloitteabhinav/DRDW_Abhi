/* Class Name  : Test_FillSurveyController
* Description  : Test Class for FillSurveyController
* Created By   : Deloitte
* Created Date : 9th December 2015
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
*/

@isTest(SeeAllData = false)

public with sharing class Test_FillSurveyController
{
    private static Account oSupplierAccount;
    private static Feedback__c oFeedback;
    private static integer nReviewsPerFeedback;
    private static User oSMIAdmin;
    private static User oSupplierAssessor;
    private static User oFeedbackProvider1;
    private static User oFeedbackProvider2;
    
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
        
        //assign permission
        DataFactory.givePermissions(oSMIAdmin.Id,Constants.sSMINAdminPermissionAPI);
        DataFactory.givePermissions(oSupplierAssessor.Id,Constants.sSupplierAssessorPermissionAPI);
        DataFactory.givePermissions(oFeedbackProvider1.Id,Constants.sFeedbackProviderPermissionAPI);
        DataFactory.givePermissions(oFeedbackProvider2.Id,Constants.sFeedbackProviderPermissionAPI);
        
        //assign users to Groups
        DataFactory.assignToPublicGroup(oSMIAdmin.Id,Constants.sSMINAdminPermissionAPI);
        DataFactory.assignToPublicGroup(oSupplierAssessor.Id,Constants.sSupplierAssessorPermissionAPI);
        DataFactory.assignToPublicGroup(oFeedbackProvider1.Id,Constants.sFeedbackProviderPermissionAPI);
        DataFactory.assignToPublicGroup(oFeedbackProvider2.Id,Constants.sFeedbackProviderPermissionAPI);
        
        //initiate like nReviewsPerFeedback to 0
        nReviewsPerFeedback=0;
        
        System.runAs(oSMIAdmin)
        {
            //as an SMI Admin create test questions
            List<Question__c> lQuestion=DataFactory.createQuestion(4,2);
            system.assertNotEquals(lQuestion.size(),0);
            insert lQuestion;
            //number of questions
            nReviewsPerFeedback=lQuestion.size();
        }
        
        System.runAs(oSupplierAssessor)
        {
            //insert supplier account
            oSupplierAccount=DataFactory.returnSupplierAccounts(1)[0];
            oSupplierAccount.Relationship_Owner__c= null;
            oSupplierAccount.Executive_Sponsor__c = oFeedbackProvider1.Id;
            oSupplierAccount.SMO_Representative__c = null;
            insert oSupplierAccount;
            system.assertNotEquals(oSupplierAccount.Id,null);
            //insert contacts under the Account
            List<Contact> lContact=DataFactory.returnSupplierContacts(new List<Account>{oSupplierAccount},3);
            system.assertNotEquals(lContact.size(),0);
            insert lContact;
            
            //initiate feedback for the supplier
            ApexPages.StandardController sc = new ApexPages.StandardController(oSupplierAccount);
            SendSurveyController surveyCtrl = new SendSurveyController(sc);
            
            //select first 2 contacts
            surveyCtrl.mUserContactCheckboxWrapper.get('Contact')[0].bIsChecked=true;
            surveyCtrl.mUserContactCheckboxWrapper.get('Contact')[1].bIsChecked=true;
            
            //proceed to the next step to select users
            surveyCtrl.selectUsersStep();
            
            //select Feedback providers
            surveyCtrl.mUserContactCheckboxWrapper.get('SupplierUser')[0].bIsChecked=true;
            
            //proceed to the next step to submit
            surveyCtrl.confirmationStep();
            //add nReviewsPerFeedback with number of selected contacts
            nReviewsPerFeedback+=surveyCtrl.lSelectedSupplierContacts.size();
            //check if feedback is created
            oFeedback=[select id, Supplier_Account__c,Supplier_Account__r.Name from Feedback__c where Supplier_Account__c=:oSupplierAccount.Id][0];
            System.assertNotEquals(oFeedback.Id,null);
            //close the initiate survey wizard
            surveyCtrl.closeFeedback();
            
        }
    }
    
    /* 
    * @Method Name                    :  testFeedbackSave
    * @Description                    :  Method to save a feedback 
    * @Return Type                    :  void
    * @Parameters                     :  None
    */ 
    public static testMethod void testFeedbackSave()
    {
        createTestData();
        test.StartTest();
        //run as oFeedbackProvider1
        System.runAs(oFeedbackProvider1){
            //invoke fill feedback class
            ApexPages.StandardController sc = new ApexPages.StandardController(oFeedback);
            FillSurveyController fbCtrl = new FillSurveyController(sc);
            //supplier name and Id on the feedback record should match
            System.assertEquals(fbCtrl.sSupplierName,oFeedback.Supplier_Account__r.Name);
            System.assertEquals(fbCtrl.sSupplierId,oFeedback.Supplier_Account__c);
            //List of reviews size should be Number of questions inserted + number of contacts selected.
            System.assertEquals(fbCtrl.lReviews.size(),nReviewsPerFeedback);
            //save the feedback with blank reviews
            fbCtrl.saveSurvey();
            //check if status of the feedback provider has changed to saved
            system.assertEquals([select id,Status__c,Feedback_Id__c,Feedback_Provider__c from Feedback_Providers__c  where Feedback_Id__c=:oFeedback.Id
                                AND Feedback_Provider__c=:UserInfo.getUserId() LIMIT 1][0].Status__c,Constants.sFeedbackStatusSaved);
            //save the survey with answers
            for(Review__c oRev:fbCtrl.lReviews){
                oRev.Answer__c='test';
            }
            fbCtrl.saveSurvey();
            //check if status of the feedback provider is still saved
            system.assertEquals([select id,Status__c,Feedback_Id__c,Feedback_Provider__c from Feedback_Providers__c  where Feedback_Id__c=:oFeedback.Id
                                AND Feedback_Provider__c=:UserInfo.getUserId() LIMIT 1][0].Status__c,Constants.sFeedbackStatusSaved);
            
        }
        test.StopTest();
    }
    
    /* 
    * @Method Name                    :  testFeedbackSubmit
    * @Description                    :  Method to Submit a feedback 
    * @Return Type                    :  void
    * @Parameters                     :  None
    */ 
    public static testMethod void testFeedbackSubmit()
    {
        createTestData();
        test.StartTest();
        //run as oFeedbackProvider1
        System.runAs(oFeedbackProvider1){
            //invoke fill feedback class
            ApexPages.StandardController sc = new ApexPages.StandardController(oFeedback);
            FillSurveyController fbCtrl = new FillSurveyController(sc);
            //supplier name and Id on the feedback record should match
            System.assertEquals(fbCtrl.sSupplierName,oFeedback.Supplier_Account__r.Name);
            System.assertEquals(fbCtrl.sSupplierId,oFeedback.Supplier_Account__c);
            //List of reviews size should be Number of questions inserted + number of contacts selected.
            System.assertEquals(fbCtrl.lReviews.size(),nReviewsPerFeedback);
            //save the feedback with blank reviews
            fbCtrl.saveSurvey();
            //check if status of the feedback provider has changed to saved
            system.assertEquals([select id,Status__c,Feedback_Id__c,Feedback_Provider__c from Feedback_Providers__c  where Feedback_Id__c=:oFeedback.Id
                                AND Feedback_Provider__c=:UserInfo.getUserId() LIMIT 1][0].Status__c,Constants.sFeedbackStatusSaved);
            //try to submit a blank survey, it should return null without setting the status to submitted
            PageReference pg=fbCtrl.submitSurvey();
            system.assertNotEquals([select id,Status__c,Feedback_Id__c,Feedback_Provider__c from Feedback_Providers__c  where Feedback_Id__c=:oFeedback.Id
                                AND Feedback_Provider__c=:UserInfo.getUserId() LIMIT 1][0].Status__c,Constants.sFeedbackStatusSubmitted);
            //submit the survey with answers
            for(Review__c oRev:fbCtrl.lReviews){
                oRev.Answer__c='test';
            }
            fbCtrl.submitSurvey();
            //check if status of the feedback provider has changed to submitted
            system.assertEquals([select id,Status__c,Feedback_Id__c,Feedback_Provider__c from Feedback_Providers__c  where Feedback_Id__c=:oFeedback.Id
                                AND Feedback_Provider__c=:UserInfo.getUserId() LIMIT 1][0].Status__c,Constants.sFeedbackStatusSubmitted);
            //access a submitted survey
            sc = new ApexPages.StandardController(oFeedback);
            fbCtrl = new FillSurveyController(sc);
            //INFO page message should be displayed
            System.assert(Apexpages.getMessages().size()>0);
            System.assert(ApexPages.hasMessages(ApexPages.Severity.INFO));
            
        }
        test.StopTest();
    }
    
    /* 
    * @Method Name                    :  testFeedbackErrorConditions
    * @Description                    :  Method to check error conditions
                                         1. a non feedback provider should not be allowed to access the feedback survey
                                         2. catch blocks
    * @Return Type                    :  void
    * @Parameters                     :  None
    */ 
    public static testMethod void testFeedbackErrorConditions()
    {
        createTestData();
        test.StartTest();
        //run as SMI admin, who has access to reviews, but will not be allowed to view/submit the feedback
        System.runAs(oSMIAdmin){
            //invoke fill feedback class
            ApexPages.StandardController sc = new ApexPages.StandardController(oFeedback);
            FillSurveyController fbCtrl = new FillSurveyController(sc);
            //supplier Id on the feedback record will not be fetched
            System.assertNotEquals(fbCtrl.sSupplierId,oFeedback.Supplier_Account__c);
            //Reviews will not be fetched
            System.assertEquals(fbCtrl.lReviews,null);
            //page messages boolean will be set to true
            System.assert(fbCtrl.bIsShowMessage);
            //page should have a page message of type error
            System.assert(Apexpages.getMessages().size()>0);
            System.assert(ApexPages.hasMessages(ApexPages.Severity.Error));
        }
        //run as oFeedbackProvider1
        System.runAs(oFeedbackProvider1){
            //invoke fill feedback class
            ApexPages.StandardController sc = new ApexPages.StandardController(oFeedback);
            FillSurveyController fbCtrl = new FillSurveyController(sc);
            
            //try to submit the record with answers but manipulate the Feedback provider
            fbCtrl.oFeedbackProvider.Feedback_Provider__c=oSupplierAccount.Id;
            //save the feedback with blank reviews
            fbCtrl.saveSurvey();
            //submit the survey with answers
            for(Review__c oRev:fbCtrl.lReviews){
                oRev.Answer__c='test';
            }
            fbCtrl.submitSurvey();
        }
        //ensure that feedback provider 2 does not have any sharing enabled
        system.assertEquals([select id,UserOrGroupId, ParentId from Feedback__Share where UserOrGroupId =:oFeedbackProvider2.Id AND ParentId=:oFeedback.Id].size(),0);
        test.StopTest();
    }
}