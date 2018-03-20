/****************************************************************************************************************************************** 
* Class Name   : Test_TRAK_sprintPlanning
* Description  : Test class for TRAK_sprintPlanning
* Created By   : Deloitte Consulting
* 
*****************************************************************************************************************************************/
@isTest
private class Test_TRAK_sprintPlanning{
    static testMethod void TestSprintPlanning(){
        List<User> U = TRAK_Test_Utility.createUser('System Administrator',1,'AB');
        List<TRAK_Sprint__c> LstSprint = TRAK_Test_Utility.createSprint(1);
        insert LstSprint;
        system.runAs(U[0]){
          test.startTest();
          apexpages.currentpage().getParameters().put('sprintID',LstSprint[0].id);
          TRAK_sprintPlanning cons = new TRAK_sprintPlanning();
          Boolean b = cons.getCurrentSprintInPlanning();
          List<selectOption> op = cons.getSprint();
          test.stopTest();
        }
    }
    
    static testMethod void TestInPlanningSprint(){
        List<User> U = TRAK_Test_Utility.createUser('System Administrator',1,'AB');
        List<TRAK_Sprint__c> LstSprint = TRAK_Test_Utility.createSprint(1);
        LstSprint[0].Status__c = 'In Planning';
        insert LstSprint;
        system.runAs(U[0]){
          test.startTest();
          apexpages.currentpage().getParameters().put('sprintID',LstSprint[0].id);
          TRAK_sprintPlanning cons = new TRAK_sprintPlanning();
          Boolean b = cons.getCurrentSprintInPlanning();
          List<selectOption> op = cons.getSprint();
          test.stopTest();
        }
    }

    static testMethod void TestUserStoryMethod(){
        List<User> U = TRAK_Test_Utility.createUser('System Administrator',1,'AB');
        List<TRAK_Sprint__c> LstSprint = TRAK_Test_Utility.createSprint(1);
        insert LstSprint;
        List<TRAK_User_Story__c> LstUS = TRAK_Test_Utility.createUserStory(1);
        insert LstUS;
        system.runAs(U[0]){
          test.startTest();
          apexpages.currentpage().getParameters().put('sprintID',LstSprint[0].id);
          TRAK_sprintPlanning cons = new TRAK_sprintPlanning();
          Boolean b = cons.getCurrentSprintInPlanning();
          List<selectOption> op = cons.getSprint();
          list<TRAK_User_Story__c> lst1 = cons.getAllocatedUserStory();
          list<TRAK_User_Story__c> lst2 = cons.getNotAllocatedUserStory();
          integer sfdcPlanned = cons.getsfdcPlanned();
          integer sfdcRemain = cons.getsfdcRemain();
          integer OtherPlanned = cons.getOtherPlanned();
          PageReference pageref = cons.syncUserStory();
          cons.autoPlan();
          cons.updateUserStoriesSprint();
          cons.addChatterComment();
          test.stopTest();
        }
    }
}