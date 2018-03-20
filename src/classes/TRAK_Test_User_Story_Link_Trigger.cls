@isTest(seeAllData = false)
global class TRAK_Test_User_Story_Link_Trigger {
/*
    static TRAK_User_Story_Link__c mirrorRec = new TRAK_User_Story_Link__c();
    static TRAK_User_Story__c userStoryLink1 = new TRAK_User_Story__c();
    static TRAK_User_Story__c userStoryLink = new TRAK_User_Story__c();
    static TRAK_User_Story__c userStoryLink3 = new TRAK_User_Story__c();
    //static TRAK_App__c app = new TRAK_App__c();


    /*
     * @Method Name                    :  createUser
     * @Description                    :  method to create User for inserting data                                  
     * @Return Type                    :  User
     * @Param                          :      
     */
     
    public static User createUser() {
        Profile pfl = [select id from profile where name = 'Senior System Administrator'];
        //Declaring the User
        User runAsUser = new User(alias = 'BasicIHS', email = 'appBasicIhs@testorg.com',
            emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US',
            localesidkey = 'en_US', profileid = pfl.Id, country = 'United States', CommunityNickname = 'u1' + Math.random() * 100,
            timezonesidkey = 'America/Los_Angeles', username = 'appBasicIhs@gso_org.com' + Math.random() * 100);

        Insert runAsUser;

        System.runAs(new User(Id = Userinfo.getUserId())) {
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'TRAK_Tracker_Admin'];
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.AssigneeId = runAsUser.Id;
            psa.PermissionSetId = ps.Id;
            insert psa;
        }
        Return runAsUser;
    }
 /*
    public static void createTestData() {


        TRAK_Project__c proj = new TRAK_Project__c();

        //app.Name = 'Test';
        //insert app;

        proj.Name = 'Test';
        insert proj;

        //userStoryLink.App__c = app.id;
        userStoryLink.Project__c = proj.id;
        userStoryLink.As_A_text__c = 'test';
        userStoryLink.So_that__c = 'test';
        userStoryLink.I_Want_To__c = 'test';
        userStoryLink.Acceptance_Criteria__c = 'test';

        insert userStoryLink;

        //userStoryLink3.App__c = app.id;
        userStoryLink3.Project__c = proj.id;
        userStoryLink3.As_A_text__c = 'test';
        userStoryLink3.So_that__c = 'test';
        userStoryLink3.I_Want_To__c = 'test';
        userStoryLink3.Acceptance_Criteria__c = 'test';

        insert userStoryLink3;

        //userStoryLink1.App__c = app.id;
        userStoryLink1.Project__c = proj.id;
        userStoryLink1.As_A_text__c = 'test1';
        userStoryLink1.So_that__c = 'test1';
        userStoryLink1.I_Want_To__c = 'test1';
        userStoryLink1.Acceptance_Criteria__c = 'test1';

        insert userStoryLink1;

        mirrorRec.User_Story__c = userStoryLink1.id;
        mirrorRec.User_Story_Related__c = userStoryLink.id;
        mirrorRec.User_Story_Link_Type__c = 'Test';

        insert mirrorRec;


        TRAK_User_Story_Link_Trigger_handler.isHandlerRun = false;
        mirrorRec.User_Story_Related__c = userStoryLink3.id;
        update mirrorRec;

    }


    static testMethod void Test_createTestData() {

        // Insertion of Test Data
        User runAsUserDataLoad = createUser();
        System.runas(runAsUserDataLoad) {
            createTestData();
            System.assertNotEquals(mirrorRec, null);
            List<TRAK_User_Story_Link__c> mirrorRec1 = [SELECT User_Story__c FROM TRAK_User_Story_Link__c WHERE User_Story__c = : userStoryLink.id];
            System.assertEquals(mirrorRec1.isEmpty(), true);

        }

    }

*/

}