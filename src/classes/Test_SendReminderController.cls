/* Class Name  : Test_SendReminderController
* Description  : Test Class for SendReminderController
* Created By   : Deloitte
* Created Date : 9th December 2015
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
*/

@isTest(SeeAllData = false)

public with sharing class Test_SendReminderController
{
    private static Account oSupplierAccount;
    private static Feedback__c oFeedback;
    private static integer nReviewsPerFeedback;
    private static User oSMIAdmin;
    private static User oSupplierAssessor;
    private static User oFeedbackProvider1;
    
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
        
        //assign permission
        DataFactory.givePermissions(oSMIAdmin.Id,Constants.sSMINAdminPermissionAPI);
        DataFactory.givePermissions(oSupplierAssessor.Id,Constants.sSupplierAssessorPermissionAPI);
        DataFactory.givePermissions(oFeedbackProvider1.Id,Constants.sFeedbackProviderPermissionAPI);
        
        //assign users to Groups
        DataFactory.assignToPublicGroup(oSMIAdmin.Id,Constants.sSMINAdminPermissionAPI);
        DataFactory.assignToPublicGroup(oSupplierAssessor.Id,Constants.sSupplierAssessorPermissionAPI);
        DataFactory.assignToPublicGroup(oFeedbackProvider1.Id,Constants.sFeedbackProviderPermissionAPI);
        
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
    * @Method Name                    :  testReminder
    * @Description                    :  Method to test sending reminders to Feedback providers
    * @Return Type                    :  void
    * @Parameters                     :  None
    */      
    static testMethod void testReminder() 
    {
        createTestData();
        ApexPages.StandardController sc;
        SendReminderController rmndCtrl;
        FillSurveyController fbCtrl;
        test.StartTest();
        
        System.runAs(oSupplierAssessor){
            //send reminder to the feedback provider who has not filled the feedback
            sc = new ApexPages.StandardController(oFeedback);
            rmndCtrl = new SendReminderController(sc);
            rmndCtrl.sendReminder();
            //INFO page message should be displayed
            System.assert(Apexpages.getMessages().size()>0);
            System.assert(ApexPages.hasMessages(ApexPages.Severity.INFO));
            //the list of feedback prividers should not be empty
            System.assertNotEquals(rmndCtrl.lFeedbackProviders.size(),0);
         }
         
         //Run as feed back provider and save survey
         System.runAs(oFeedbackProvider1){
            //invoke fill feedback class 
            sc = new ApexPages.StandardController(oFeedback);
            fbCtrl = new FillSurveyController(sc);
            //fill the feedback and save it
            for(Review__c oRev:fbCtrl.lReviews){
                oRev.Answer__c='test';
            }
            fbCtrl.saveSurvey();
            system.assertEquals([select id,Status__c,Feedback_Id__c,Feedback_Provider__c from Feedback_Providers__c  where Feedback_Id__c=:oFeedback.Id
                                AND Feedback_Provider__c=:UserInfo.getUserId() LIMIT 1][0].Status__c,Constants.sFeedbackStatusSaved);
         }
         
         //run as supplier assessor and send reminder again, it should be sent since status is Saved   
         System.runAs(oSupplierAssessor){
            sc = new ApexPages.StandardController(oFeedback);
            rmndCtrl = new SendReminderController(sc);
            rmndCtrl.sendReminder();
            //INFO page message should be displayed
            System.assert(Apexpages.getMessages().size()>0);
            System.assert(ApexPages.hasMessages(ApexPages.Severity.INFO));
            //the list of feedback prividers should not be empty
            System.assertNotEquals(rmndCtrl.lFeedbackProviders.size(),0);
         }
         
         //Run as feed back provider and submit survey
         System.runAs(oFeedbackProvider1){
            //submit the survey
            sc = new ApexPages.StandardController(oFeedback);
            fbCtrl = new FillSurveyController(sc);
            fbCtrl.submitSurvey();
            //check if status of the feedback provider has changed to submitted
            system.assertEquals([select id,Status__c,Feedback_Id__c,Feedback_Provider__c from Feedback_Providers__c  where Feedback_Id__c=:oFeedback.Id
                                AND Feedback_Provider__c=:UserInfo.getUserId() LIMIT 1][0].Status__c,Constants.sFeedbackStatusSubmitted);
        }
        //Run as supplier assessor and try to send a reminder to the feedback provider who submitted his feedback
        System.runAs(oSupplierAssessor){
            //reminder should not be sent, and a page message should be displayed
            sc = new ApexPages.StandardController(oFeedback);
            rmndCtrl = new SendReminderController(sc);
            rmndCtrl.sendReminder();
            //INFO page message should be displayed
            System.assert(Apexpages.getMessages().size()>0);
            System.assert(ApexPages.hasMessages(ApexPages.Severity.INFO));
            //the list of feedback prividers should not be empty
            System.assertEquals(rmndCtrl.lFeedbackProviders.size(),0);
        }    
        test.StopTest();
    }
    /* 
    * @Method Name                    :  testReminderForSentSaved
    * @Description                    :  Method to test sending reminders to Feedback providers whose status is sent/saved
    * @Return Type                    :  void
    * @Parameters                     :  None
    */      
    static testMethod void testReminderForSentSaved() 
    {
        createTestData();
        test.StartTest();
        System.runAs(oSupplierAssessor){
            //send reminder to the feedback provider who has not filled the feedback
            ApexPages.StandardController sc = new ApexPages.StandardController(oFeedback);
            SendReminderController rmndCtrl = new SendReminderController(sc);
            
            //manipulate the feedback provider list to create error
            rmndCtrl.lFeedbackProviders[0].Feedback_Provider__c=oSupplierAccount.Id;
            rmndCtrl.sendReminder();
        }
    }
}