/*
*@ Class Name                                                    : TRAK_Test_UserStoryApprovalHistory  
*@ Description                                                   : Test class for TRAK_UserStoryApprovalHistory 
*@ CreatedBy                                                     : Deloitte Consulting
*@ CreatedOn                                                     : 29-06-2015
*@ Modification Log                                              : Neha Kumari [04-Jan-2017]
*/

@isTest(seeAllData = false)
global class TRAK_Test_UserStoryApprovalHistory {

    static TRAK_User_Story_Approval_History__c usHistObj = new TRAK_User_Story_Approval_History__c();
    static TRAK_User_Story__c userStoryObj = new TRAK_User_Story__c();

/*
* @Method Name                    :  createTestData
* @Description                    :  Method to create test data for TRAK_Test_UserStoryApprovalHistory
* @Return Type                    :  void
* @Param                          :  

*/

    public static void createTestData() {
        User userObj = TRAK_Test_User_Story_Link_Trigger.createUser();
        User userObj_Admin = TRAK_Test_User_Story_Link_Trigger.createUser();
        userStoryObj.As_A_text__c = 'test';
        userStoryObj.So_that__c = 'test';
        userStoryObj.I_Want_To__c = 'test';
        userStoryObj.Acceptance_Criteria__c = 'test';
        userStoryObj.GXP__c = 'No';
        userStoryObj.Critical__c = 'No';

        usHistObj.System_Custodian__c = userObj.id;

        usHistObj.Computer_Systems_Quality__c = userObj.id;
        usHistObj.Business_Quality__c = userObj.id;
        usHistObj.System_Owner__c = userObj.id;

        userStoryObj.Approval_Status__c = 'Pending Approval';
        userStoryObj.Development_stage__c = 'Backlog';
        userStoryObj.System_Custodian__c = userObj.id;
        userStoryObj.System_Owner__c = userObj_Admin.id;
        insert userStoryObj;
        usHistObj.User_Story__c = userStoryObj.id;
        usHistObj.Approval_Status__c = 'Pending Approval';
        insert usHistObj;
        System.assert(usHistObj!=null);


    }

/* 
* @Method Name                    :  Test_createTestData
* @Description                    :  Test Method
* @Return Type                    :  void
* @Param                          :  

*/

    static testMethod void Test_createTestData() {

        // Insertion of Test Data
        User runAsUserDataLoad = TRAK_Test_User_Story_Link_Trigger.createUser();
        PageReference pageRef = Page.TRAK_UserStoryApprovalSection;
        system.Test.setCurrentPage(pageRef);
        System.runas(runAsUserDataLoad) {
            createTestData();

            TRAK_UserStoryApprovalHistory objUS = new TRAK_UserStoryApprovalHistory(new ApexPages.StandardController(userStoryObj));


        }

    } 
    
/* 
* @Method Name                    :  Test_getLatestApprovalSnapshot 
* @Description                    :  Test Method to get the Approval Snapshot for a user story
* @Return Type                    :  void
* @Param                          :  void
*/

    static testMethod void Test_getLatestApprovalSnapshot(){
        
        //Insert new user story
        List<TRAK_User_Story__c> lUStory = TRAK_Test_Utility.createUserStory(1);
        insert lUStory;
        system.assert(lUStory.size()==1);
        
        //Create Senior System Admin User
        List<User> lusr = TRAK_Test_Utility.createUser('Senior System Administrator',1, 'xyz');
        
        system.runAs(lusr[0]){
            Test.startTest();
            //Calling the method with null User Story Approval History
            TRAK_UserStoryApprovalHistory contr1 =  new TRAK_UserStoryApprovalHistory(new ApexPages.StandardController(lUStory[0]));
            
            //Insert User Story Approval History Object
            TRAK_User_Story_Approval_History__c usHistObj1 = new TRAK_User_Story_Approval_History__c();
            usHistObj1.Computer_Systems_Quality__c = lusr[0].id;
            usHistObj1.Business_Quality__c = lusr[0].id;
            usHistObj1.System_Owner__c = lusr[0].id;
            usHistObj1.User_Story__c = lUStory[0].id;
            usHistObj1.Approval_Status__c = 'Pending Approval';
            insert usHistObj1;
            System.assert(usHistObj1!=null);
            
            //Calling the method after inserting User Story Approval History
            TRAK_UserStoryApprovalHistory contr2 =  new TRAK_UserStoryApprovalHistory(new ApexPages.StandardController(lUStory[0]));
            Test.stopTest();
        }
    }
    
}