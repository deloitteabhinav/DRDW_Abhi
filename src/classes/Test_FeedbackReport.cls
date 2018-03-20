/* Class Name  : Test_FeedbackReport
* Description  : Test Class for FeedbackReport
* Created By   : Deloitte
* Created Date : 14th December 2015
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
*/

@isTest(SeeAllData = false)

public with sharing class Test_FeedbackReport
{


    private static Account oSupplierAccount;
    private static Feedback__c oFeedback;
    private static integer nQuestionsPerFeedback;
    private static User oSMIAdmin;
    private static User oSupplierAssessor;
    private static User oSupplierAssessor2;
    private static User oFeedbackProvider1;
    private static User oFeedbackProvider2;
    private static User oFeedbackProvider3;
    
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
        oSupplierAssessor2=DataFactory.getTestingUser();
        system.assertNotEquals(oSupplierAssessor2.Id,null);
        oFeedbackProvider1=DataFactory.getTestingUser();
        system.assertNotEquals(oFeedbackProvider1.Id,null);
        oFeedbackProvider2=DataFactory.getTestingUser();
        system.assertNotEquals(oFeedbackProvider2.Id,null);
        oFeedbackProvider3=DataFactory.getTestingUser();
        system.assertNotEquals(oFeedbackProvider3.Id,null);
        
        //assign permission
        DataFactory.givePermissions(oSMIAdmin.Id,Constants.sSMINAdminPermissionAPI);
        DataFactory.givePermissions(oSupplierAssessor.Id,Constants.sSupplierAssessorPermissionAPI);
        DataFactory.givePermissions(oSupplierAssessor2.Id,Constants.sSupplierAssessorPermissionAPI);
        DataFactory.givePermissions(oFeedbackProvider1.Id,Constants.sFeedbackProviderPermissionAPI);
        DataFactory.givePermissions(oFeedbackProvider2.Id,Constants.sFeedbackProviderPermissionAPI);
        DataFactory.givePermissions(oFeedbackProvider3.Id,Constants.sFeedbackProviderPermissionAPI);
        
        //assign users to Groups
        DataFactory.assignToPublicGroup(oSMIAdmin.Id,Constants.sSMINAdminPermissionAPI);
        DataFactory.assignToPublicGroup(oSupplierAssessor.Id,Constants.sSupplierAssessorPermissionAPI);
        DataFactory.assignToPublicGroup(oSupplierAssessor2.Id,Constants.sSupplierAssessorPermissionAPI);
        DataFactory.assignToPublicGroup(oFeedbackProvider1.Id,Constants.sFeedbackProviderPermissionAPI);
        DataFactory.assignToPublicGroup(oFeedbackProvider2.Id,Constants.sFeedbackProviderPermissionAPI);
        DataFactory.assignToPublicGroup(oFeedbackProvider3.Id,Constants.sFeedbackProviderPermissionAPI);
        
        //initiate like nQuestionsPerFeedback to 0
        nQuestionsPerFeedback=0;
        
        System.runAs(oSMIAdmin)
        {
            //as an SMI Admin create test questions
            List<Question__c> lQuestion=DataFactory.createQuestion(4,2);
            system.assertNotEquals(lQuestion.size(),0);
            insert lQuestion;
            //number of questions
            nQuestionsPerFeedback=lQuestion.size();
        }
        
        //INITIATE FEEDBACK to the three FeedbackProviders
        System.runAs(oSupplierAssessor)
        {
            //insert supplier account
            oSupplierAccount=DataFactory.returnSupplierAccounts(1)[0];
            oSupplierAccount.Relationship_Owner__c= null;
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
            
            //select first 2 contacts
            surveyCtrl.mUserContactCheckboxWrapper.get('Contact')[0].bIsChecked=true;
            surveyCtrl.mUserContactCheckboxWrapper.get('Contact')[1].bIsChecked=true;
            
            //proceed to the next step to select users
            surveyCtrl.selectUsersStep();
            
            //select Feedback providers
            surveyCtrl.mUserContactCheckboxWrapper.get('SupplierUser')[0].bIsChecked=true;
            surveyCtrl.mUserContactCheckboxWrapper.get('SupplierUser')[1].bIsChecked=true;
            surveyCtrl.mUserContactCheckboxWrapper.get('SupplierUser')[2].bIsChecked=true;
            
            //proceed to the next step to submit
            surveyCtrl.confirmationStep();
            //add nQuestionsPerFeedback with number of selected contacts
            nQuestionsPerFeedback+=surveyCtrl.lSelectedSupplierContacts.size();
            //check if feedback is created
            oFeedback=[select id, Name, Supplier_Account__c,Supplier_Account__r.Name from Feedback__c where Supplier_Account__c=:oSupplierAccount.Id][0];
            System.assertNotEquals(oFeedback.Id,null);
            //close the initiate survey wizard
            surveyCtrl.closeFeedback();
            
        }

        
        // SUBMITTED Feedback
        System.runAs(oFeedbackProvider1)
        {
             //invoke fill feedback class
            ApexPages.StandardController sc = new ApexPages.StandardController(oFeedback);
            FillSurveyController fbCtrl = new FillSurveyController(sc);
            //supplier name and Id on the feedback record should match
            System.assertEquals(fbCtrl.sSupplierName,oFeedback.Supplier_Account__r.Name);
            System.assertEquals(fbCtrl.sSupplierId,oFeedback.Supplier_Account__c);
            //List of reviews size should be Number of questions inserted + number of contacts selected.
            System.assertEquals(fbCtrl.lReviews.size(),nQuestionsPerFeedback);
            
            //submit the survey with answers
            for(Review__c oRev:fbCtrl.lReviews){
                oRev.Answer__c='test';
            }
            fbCtrl.submitSurvey();
            //check if status of the feedback provider has changed to submitted
            system.assertEquals([select id,Status__c,Feedback_Id__c,Feedback_Provider__c from Feedback_Providers__c  where Feedback_Id__c=:oFeedback.Id
                                AND Feedback_Provider__c=:UserInfo.getUserId() LIMIT 1][0].Status__c,Constants.sFeedbackStatusSubmitted);           

        }


        // SAVED Feedback
        System.runAs(oFeedbackProvider2)
        {
             //invoke fill feedback class
            ApexPages.StandardController sc = new ApexPages.StandardController(oFeedback);
            FillSurveyController fbCtrl = new FillSurveyController(sc);
            //supplier name and Id on the feedback record should match
            System.assertEquals(fbCtrl.sSupplierName,oFeedback.Supplier_Account__r.Name);
            System.assertEquals(fbCtrl.sSupplierId,oFeedback.Supplier_Account__c);
            //List of reviews size should be Number of questions inserted + number of contacts selected.
            System.assertEquals(fbCtrl.lReviews.size(),nQuestionsPerFeedback);
            //save the survey with answers
            for(Review__c oRev:fbCtrl.lReviews){
                oRev.Answer__c='test';
            }
            fbCtrl.saveSurvey();
            //check if status of the feedback provider is still saved
            system.assertEquals([select id,Status__c,Feedback_Id__c,Feedback_Provider__c from Feedback_Providers__c  where Feedback_Id__c=:oFeedback.Id
                                AND Feedback_Provider__c=:UserInfo.getUserId() LIMIT 1][0].Status__c,Constants.sFeedbackStatusSaved);

        }

    }
    


    /* 
    * @Method Name                    :  testFeedback
    * @Description                    :  Method to test FeedbackReport page by creating Survey Data to the responders.
    * @Return Type                    :  void
    * @Parameters                     :  None
    */      
    static testMethod void testFeedback() 
    {
        createTestData();
        Test.startTest();
        System.runAs(oSupplierAssessor) 
        {
            ApexPages.StandardController sc = new ApexPages.StandardController(oFeedback);
            FeedbackReport FBReportController = new FeedbackReport(sc);
            FBReportController.RedirectChecker();
            system.assertEquals(FBReportController.FBID, oFeedback.id);
            system.assertEquals(FBReportController.FBname,oFeedback.Name);
            system.assertEquals(FBReportController.mResponders.get(Constants.sFeedbackStatusSaved).size(),1);
            system.assertEquals(FBReportController.mResponders.get(Constants.sFeedbackStatusSubmitted).size(),1);
            system.assertEquals(FBReportController.mResponders.get(Constants.sFeedbackStatusSent).size(),1);
            system.assertEquals(FBReportController.mOuter.size(),nQuestionsPerFeedback);
            system.assertEquals(FBReportController.mInner.size(),nQuestionsPerFeedback);
            system.assertEquals(FBReportController.bIsError,false);
            system.assertEquals(FBReportController.SendReminder(),null);
        }
        
        System.runAs(oSupplierAssessor2) 
        {
            ApexPages.StandardController sc2 = new ApexPages.StandardController(oFeedback);
            FeedbackReport FBReportController2 = new FeedbackReport(sc2);
            FBReportController2.RedirectChecker();
            system.assertEquals(FBReportController2.bIsError,true);
            oFeedback= new Feedback__c();
            sc2 = new ApexPages.StandardController(oFeedback);
            FBReportController2 = new FeedbackReport(sc2);
            FBReportController2.RedirectChecker();
            system.assertEquals(FBReportController2.bIsError,true);
        
        }
        Test.stopTest();
    }

}