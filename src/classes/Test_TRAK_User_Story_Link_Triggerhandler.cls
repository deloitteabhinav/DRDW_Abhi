@isTest
public class Test_TRAK_User_Story_Link_Triggerhandler {

static testmethod void testUserStoryLink() {

List<TRAK_User_Story__c> lUserStory = TRAK_Test_Utility.createUserStory(7);
insert lUserStory;

TRAK_User_Story_Link__c relatedUS = new TRAK_User_Story_Link__c();
relatedUS.User_Story_Related__c = lUserStory[0].Id;
relatedUS.User_Story__c = lUserStory[1].Id;
insert relatedUS;
TRAK_User_Story_Link_Trigger_handler.isHandlerRun = false;
relatedUS.User_Story_Related__c = lUserStory[2].Id;
update relatedUS; 
TRAK_User_Story_Link_Trigger_handler.isHandlerRun = false;
delete relatedUS;

}

}