/*
*@ Class Name                                                    : Test_TRAK_PlanningPokerFromSprint
*@ Description                                                   : Test class for TRAK_PlanningPokerFromSprint
*@ CreatedBy                                                     : Deloitte Consulting
*@ CreatedOn                                                     : 12-08-2016

*/

@isTest(seeAllData = false)
public with sharing class Test_TRAK_PlanningPokerFromSprint {
    /* 
* @Method Name                    :  insertPlanningPokerSession
* @Description                    :  Test Method 
* @Return Type                    :  void
* @Param                          :  

*/

    public static testmethod void insertPlanningPokerSession(){
        
        List<User> u = TRAK_Test_Utility.createUser('Senior System Administrator',3,'test');
        System.assertNotEquals(u[0].id,null);
        System.assertNotEquals(u[1].id,null);
        System.assertNotEquals(u[2].id,null);
        
        System.runAs(u[0]){
        //Create sprint
            TRAK_Sprint__c sprint = new TRAK_Sprint__c();
            sprint.Name = 'tracker sprint 1';
            //sprint.Project__c = project.Id;
            //sprint.Planned_Completion_Date__c = System.today();
            insert sprint;
            System.assertNotEquals(sprint.Id, null);
        
        //Create user story
            TRAK_User_Story__c story = new TRAK_User_Story__c();
            //story.Project__c = project.Id;
            //story.App__c = app.Id;
            story.Story_Points__c = '0';
            story.Story_Points_Other__c = '0';
            story.Proposed_Sprint__c = sprint.Id;
            story.Development_Stage__c = 'Backlog ';
            story.System_Owner__c = u[1].Id;
            story.System_Custodian__c = u[0].Id;
            insert story;
            System.assertNotEquals(story.Id, null);
            Test.startTest();
            String sprintID = sprint.Id;
            ApexPages.currentPage().getParameters().put('id',sprint.Id);
            TRAK_PlanningPokerFromSprint poker = new TRAK_PlanningPokerFromSprint();
            poker.insertPlanningPokerSession();
            Test.stopTest();
    } 
    }
    public static testmethod void insertPlanningPokerSessionCatchBlock(){
        List<User> u = TRAK_Test_Utility.createUser('Senior System Administrator',1,'test');
        System.assertNotEquals(u[0].id,null);
        System.runAs(u[0]){
        TRAK_PlanningPokerFromSprint poker = new TRAK_PlanningPokerFromSprint();
        
        poker.insertPlanningPokerSession();
        }
    }
}