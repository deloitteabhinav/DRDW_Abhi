@isTest( seeAllData = false )
public class TRAK_Test_DefectTriggerClass { 
    //This method is used to unit test populateManualStep method in TRAK_DefectTrigger Class
    static testMethod void Test_TRAK_DefectTrigger(){
        List <User> u = Test_Utility.createUser('Senior System Administrator',1, 'ab');
        System.runAs(u[0]){
            test.startTest();
            //Insert User Story
            List<TRAK_User_Story__c> LstUS = TRAK_Test_Utility.createUserStory(1);
            insert LstUS;
            system.assert(LstUS.size()==1);
            
            TRAK_Bug__c bug = new TRAK_Bug__c();
            bug.User_Story__c = LstUS[0].id;
            bug.Status__c='Raised';
            bug.Technology__c='SFDC';
            bug.Problem__c='test test test';
            bug.Release_Comment__c='test';
            bug.Post_Deployment_Manual_steps__c='test';
            bug.Data_Steps__c='test';
            bug.Validation_steps__c='test';
            bug.BusinessImpact__c = '1 - Low';
            insert bug;
            TRAK_Bug__c resultBug = [select id,Has_Pre_Manual_Steps__c,Has_Post_Manual_Steps__c,Has_Data_Steps__c,Has_Validation_Steps__c from TRAK_Bug__c where ID =:bug.id];
            system.assertEquals(true,resultBug.Has_Pre_Manual_Steps__c);
            system.assertEquals(true,resultBug.Has_Post_Manual_Steps__c);
            system.assertEquals(true,resultBug.Has_Data_Steps__c);
            system.assertEquals(true,resultBug.Has_Validation_Steps__c);
            
            bug.Problem__c='test test test 2';
            bug.Release_Comment__c='test 2';
            bug.Post_Deployment_Manual_steps__c='test 2';
            bug.Data_Steps__c='test 2';
            bug.Validation_steps__c='test 2';
            bug.BusinessImpact__c = '1 - Low';
            update bug;
            
            TRAK_Bug__c bug2 = new TRAK_Bug__c();
            bug2.User_Story__c = LstUS[0].id;
            bug2.Status__c='Raised';
            bug2.Technology__c='SFDC';
            bug2.Problem__c='test test test';
            bug2.Release_Comment__c='';
            bug2.Post_Deployment_Manual_steps__c='';
            bug2.Data_Steps__c='';
            bug2.Validation_steps__c='';
            bug2.BusinessImpact__c = '1 - Low';
            insert bug2;
            
            bug2.Release_Comment__c='test 2';
            bug2.Post_Deployment_Manual_steps__c='test 2';
            bug2.Data_Steps__c='test 2';
            bug2.Validation_steps__c='test 2';
            update bug2;
            bug2.Release_Comment__c='';
            bug2.Post_Deployment_Manual_steps__c='';
            bug2.Data_Steps__c='';
            bug2.Validation_steps__c='';
            update bug2;
            
            system.assertEquals(bug2.Has_Pre_Manual_Steps__c,false);
            system.assertEquals(bug2.Has_Post_Manual_Steps__c,false);
            system.assertEquals(bug2.Has_Data_Steps__c,false);
            system.assertEquals(bug2.Has_Validation_Steps__c,false);
            test.stopTest();
        } 
    }
    static testMethod void Test_populateNumberOfDefects(){
        List <User> u = Test_Utility.createUser('Senior System Administrator',1, 'ab');
        System.runAs(u[0]){
            test.startTest();
            //Insert User Story
            List<TRAK_User_Story__c> LstUS = TRAK_Test_Utility.createUserStory(1);
            insert LstUS;
            system.assert(LstUS.size()==1);
            
            List<TRAK_Release__c> lRel = TRAK_Test_Utility.createRelease(1, 'Weekly');
            insert lRel;
            TRAK_Bug__c bug2 = new TRAK_Bug__c();
            bug2.User_Story__c = LstUS[0].id;
            bug2.Status__c='Raised';
            bug2.Technology__c='SFDC';
            bug2.Problem__c='test test test';
            bug2.Release_Comment__c='';
            bug2.Post_Deployment_Manual_steps__c='';
            bug2.Data_Steps__c='';
            bug2.Validation_steps__c='';
            bug2.Production_Release__c = lRel[0].id;
            bug2.BusinessImpact__c = '1 - Low';
            insert bug2;
            test.stopTest();
        }
    }
}