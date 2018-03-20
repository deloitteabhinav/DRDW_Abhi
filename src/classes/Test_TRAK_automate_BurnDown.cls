@isTest(seeAllData = false)
public class Test_TRAK_automate_BurnDown {
    static TRAK_User_Story__c story;
    //static TRAK_App__c app;
    static TRAK_Sprint__c sprint;
    static List<TRAK_BurnDown2__c> lstBurnD;
    public static void createStory()
    {
        // user
        User stakeholderUser = new User(Alias = 'stkhldr', Email = 'stakeholderUser@mico-test.com', EmailEncodingKey = 'UTF-8', LastName = 'User', FirstName = 'Stakeholder', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = [select Id from Profile where Name = 'System Administrator'
            limit 1
        ].Id, TimeZoneSidKey = 'America/Chicago', Username = 'stakeholder@mico-test' + Math.round(Math.random() * 10000) + '.com', UserRoleId = null, Country = 'Germany');
        insert stakeholderUser;
        system.assertNotEquals(stakeholderUser.id, null);
        List<User> user = TRAK_Test_Utility.createUser('Senior System Administrator', 2, 'abc');
        System.runAs(user[0]){
        //sprint
        sprint=new TRAK_Sprint__c();
        sprint.Name='test sprint';
        sprint.Start_Date__c = System.Today()-1;
        sprint.End_Date__c =System.Today()+50;
        sprint.Status__c='In Progress';
        //sprint.Project__c = project.Id;
        insert sprint;
        System.assert(sprint.id != null);
        
        //story
        story = new TRAK_User_Story__c();
        //List <TRAK_User_Story__c> story = TRAK_Test_Utility.createUserStory(1);
        story.Allocated_Sprint__c=sprint.id;
        story.Development_Stage__c='Backlog';
        story.Story_Points__c='8';
        story.Story_Points_Other__c='5';
        story.System_Custodian__c = user[0].id;
        story.System_Owner__c= user[1].id;
        insert story;
        System.assert(story.id != null);
        lstBurnD=new List<TRAK_BurnDown2__c>();
        //burn Down
        for(integer i=0;i<5;i++){
            TRAK_BurnDown2__c burnD=new TRAK_BurnDown2__c();
            burnD.name ='Test Burndown'+i;
            burnD.Date__c=System.Today()+i;
            burnD.Sprint__c=sprint.id;
            lstBurnD.add(burnD);
        }
        insert lstBurnD;
        System.assertnotequals(lstBurnD.size(),0);
        TRAK_Bug__c defect = new TRAK_Bug__c();
        defect.BusinessImpact__c = '1 - Low';
        defect.Status__c = 'Raised';
        defect.Technology__c = 'SFDC';
        defect.Problem__c = 'Test Problem Statement';
        defect.Sprint2__c = sprint.Id;
        defect.Allocated_Sprint__c = sprint.Id;
        defect.Story_Points_SFDC__c = '2';
        insert defect; 
        system.assertNotEquals(defect.id, null);
        }
   }
    
    public static testMethod void testgenerateSprintBurndown(){
        List<User> lUser = TRAK_Test_Utility.createUser('Senior System Administrator',1,'test');
        System.assertNotEquals(lUser[0].id, null);
        System.runAs(lUser[0]){
        test.startTest();
        createStory();
        TRAK_automate_BurnDown.generateSprintBurndown(sprint.id);
        sprint.Start_Date__c = System.Today()-1;
        sprint.End_Date__c =System.Today()-1;
        update sprint;
        test.stopTest();    
        }
    }
    public static testMethod void testupdateSprintBurndown(){
         List<User> lUser = TRAK_Test_Utility.createUser('Senior System Administrator',1,'test');
        System.assertNotEquals(lUser[0].id, null);
        System.runAs(lUser[0]){
        test.startTest();
        List<TRAK_Design__c> lDesign = TRAK_Test_Utility.createDesign(1);
        lDesign[0].Approval_Status__c = 'Approved';
        insert lDesign;
        List<TRAK_UserStory2Design__c> lUserStoryDesign = new List<TRAK_UserStory2Design__c>();
        createStory();
        TRAK_UserStory2Design__c oUserStoryDesign = new TRAK_UserStory2Design__c();
        oUserStoryDesign.User_Story__c = story.Id;
        oUserStoryDesign.Design__c = lDesign[0].Id;
        lUserStoryDesign.add(oUserStoryDesign);
        insert lUserStoryDesign;
        story.Development_Stage__c='Ready for Test Release';
        story.Approval_Status__c = 'Approved';
        update story;
        sprint.Start_Date__c = System.Today()-1;
        sprint.End_Date__c =System.Today()+50;
        update sprint;
        TRAK_automate_BurnDown.updateSprintBurndown(sprint.id);
        test.stopTest();
        }
    }  
    public static testMethod void testgenerateUpdateTestScriptBurndown(){
        List<User> lUser = TRAK_Test_Utility.createUser('Senior System Administrator',1,'test');
        System.runAs(lUser[0]){
        test.startTest();
        createStory();
        //test template
        TRAK_Test_Templates__c tstemp = new TRAK_Test_Templates__c();
        tstemp.User_Story__c=story.id;
        tstemp.Introduction__c='test test test';
        tstemp.Title__c='test title';
        insert tstemp;
        System.assert(tstemp.id != null);
        //test script burn down stat
        TRAK_Test_Script_Burndown_Stat__c tstBD=new TRAK_Test_Script_Burndown_Stat__c();
        tstBD.name='test burn down script';
        tstBD.Date__c=System.today(); 
        tstBD.Sprint__c=sprint.id;
        insert tstBD;
        System.assert(tstBD.id != null);
        //story.Allocated_Sprint__c=sprint.id;
        //update story;
        tstemp.Approval_Status__c='Approved';
        update tstemp;
        TRAK_automate_BurnDown.generateTestScriptBurndown(sprint.id);
        TRAK_automate_BurnDown.updateTestScriptSprintBurndown(sprint.id);
        sprint.Start_Date__c = System.Today()+1;
        sprint.End_Date__c =System.Today()+3;
        update sprint;
        TRAK_automate_BurnDown.generateTestScriptBurndown(sprint.id);
        TRAK_automate_BurnDown.updateTestScriptSprintBurndown(sprint.id);
        test.stopTest();
        }
    }  
}