@isTest(seeAllData = false)
public class Test_TRAK_UserStoryTriggerClass {

static testmethod void TRAK_UserStoryTriggerClass() {
List<User> lUser = TRAK_Test_Utility.createUser('Senior System Administrator',1,'test');
System.runAs(lUser[0]){
List<TRAK_Release__c> lRelease = TRAK_Test_Utility.createRelease(2, 'Monthly');
insert lRelease;
System.assertNotEquals(lRelease[0].id,null);
Test.startTest();
List<TRAK_User_Story__c> lUserStory = TRAK_Test_Utility.createUSerStory(3);
insert lUserStory;
System.assertNotEquals(lUserStory[0].id , null);
Map<ID,TRAK_User_Story__c> mUserStory = new Map<ID,TRAK_User_Story__c>();

    for(TRAK_User_Story__c oUserStory : lUserStory) {
    mUserStory.put(oUserStory.id,oUserStory);
    }
    for(TRAK_User_Story__c oUSerStory : lUserStory) {
    oUSerStory.Cirrus_Release__c = lRelease[0].Id;
    oUserStory.Release_Steps_Manual__c = 'TRAK Test Data';
    oUserStory.Post_Deployment_Manual_steps__c = 'TRAK Test Data';
    oUserStory.Data_Steps__c = 'TRAK Test Data';
    oUserStory.Validation_steps__c= 'TRAK Test Data';
    }
    upsert lUserStory;
TRAK_UserStoryTriggerClass.populateManualStep(true, lUserStory, mUserStory, mUserStory);
    
    mUserStory = new Map<ID,TRAK_User_Story__c>();
    for(TRAK_User_Story__c oUserStory : lUserStory) {
    mUserStory.put(oUserStory.id,oUserStory);
    }
    
    lUserStory[0].Acceptance_Criteria__c = 'TRAK Test Data';
    lUserStory[0].Cirrus_Release__c = lRelease[1].Id;
    update lUserStory[0];
    lUserStory[0].Cirrus_Release__c = null;
    update lUserStory[0];
    
List<TRAK_Bug__c> lDefect = TRAK_Test_Utility.createDefect(3);
insert lDefect;
System.assertNotEquals(lDefect[0].id,null);
System.assertNotEquals(lDefect[1].id,null);
System.assertNotEquals(lDefect[2].id,null);
TRAK_UserStoryTriggerClass controller = new TRAK_UserStoryTriggerClass();
TRAK_UserStoryTriggerClass.createNewApprovalHistoryRecord(mUserStory);
Test.stopTest();
}

}

}