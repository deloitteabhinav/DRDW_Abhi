/****************************************************************************************************************************************** 
* Class Name   : KanbanBoardCntrl
* Description  : This is a test class for TRAK_KanbanBoardCntrl
* Created By   : Deloitte Consulting
* 
*****************************************************************************************************************************************/

@isTest
public class Test_TRAK_KanbanBoardCntrl{
  static testmethod void TestKanbanFn(){
    List<TRAK_Sprint__c> lstSpr = TRAK_Test_Utility.createSprint(1);
    lstSpr[0].Status__c = 'In Progress';
    insert lstSpr;
    List<TRAK_User_Story__c> lstUS = TRAK_Test_Utility.createUserStory(1);
    insert lstUS;
    test.startTest();
    ApexPages.currentPage().getParameters().put('id',lstSpr[0].id);
    ApexPages.currentPage().getParameters().put('ChatterComment','Chatter');
    ApexPages.currentPage().getParameters().put('UserStoryID',lstUS[0].id);
    ApexPages.standardController sc = new ApexPages.standardController(lstSpr[0]);
    TRAK_KanbanBoardCntrl cons = new TRAK_KanbanBoardCntrl(sc);
    List<SelectOption> op1 = cons.getsprintval();
    List<SelectOption> op2 = cons.getFuncval();
    //cons.DispUserStories();
    cons.filteredVal();
    cons.addChatterComment();
    test.stopTest();
  }
  
  static testmethod void TestupdateUserStoriesSprintFn(){
    List<TRAK_Sprint__c> lstSpr = TRAK_Test_Utility.createSprint(1);
    lstSpr[0].Status__c = 'In Progress';
    insert lstSpr;
    List<TRAK_User_Story__c> lstUS = TRAK_Test_Utility.createUserStory(9);
    lstUS[0].Allocated_Sprint__c = lstSpr[0].id;
    lstUS[1].Allocated_Sprint__c = lstSpr[0].id;
    lstUS[2].Allocated_Sprint__c = lstSpr[0].id;
    lstUS[3].Allocated_Sprint__c = lstSpr[0].id;
    lstUS[4].Allocated_Sprint__c = lstSpr[0].id;
    lstUS[5].Allocated_Sprint__c = lstSpr[0].id;
    lstUS[6].Allocated_Sprint__c = lstSpr[0].id;
    lstUS[7].Allocated_Sprint__c = lstSpr[0].id;
    lstUS[8].Allocated_Sprint__c = lstSpr[0].id;
    insert lstUS;
    
    test.startTest();
    ApexPages.currentPage().getParameters().put('id',lstSpr[0].id);
    ApexPages.currentPage().getParameters().put('UpdateSwing','ReadyforDevUS');
    ApexPages.currentPage().getParameters().put('UserStoryID',lstUS[0].id);
    ApexPages.standardController sc0 = new ApexPages.standardController(lstSpr[0]);
    TRAK_KanbanBoardCntrl cons0 = new TRAK_KanbanBoardCntrl(sc0);
    PageReference ref0 = cons0.updateUserStoriesSprint();
    cons0.DispUserStories(lstUS[0].Name);
    
    ApexPages.currentPage().getParameters().put('UpdateSwing','InDevUS');
    ApexPages.currentPage().getParameters().put('UserStoryID',lstUS[1].id);
    ApexPages.standardController sc1 = new ApexPages.standardController(lstSpr[0]);
    TRAK_KanbanBoardCntrl cons1 = new TRAK_KanbanBoardCntrl(sc1);
    PageReference ref1 = cons1.updateUserStoriesSprint();
    cons1.DispUserStories(lstUS[1].Name);
    
    ApexPages.currentPage().getParameters().put('UpdateSwing','BacklogUS');
    ApexPages.currentPage().getParameters().put('UserStoryID',lstUS[2].id);
    ApexPages.standardController sc2 = new ApexPages.standardController(lstSpr[0]);
    TRAK_KanbanBoardCntrl cons2 = new TRAK_KanbanBoardCntrl(sc2);
    PageReference ref2 = cons2.updateUserStoriesSprint();
    cons2.DispUserStories(lstUS[2].Name);
    
    ApexPages.currentPage().getParameters().put('UpdateSwing','ReadyforTestRelUS');
    ApexPages.currentPage().getParameters().put('UserStoryID',lstUS[3].id);
    ApexPages.standardController sc3 = new ApexPages.standardController(lstSpr[0]);
    TRAK_KanbanBoardCntrl cons3 = new TRAK_KanbanBoardCntrl(sc3);
    PageReference ref3 = cons3.updateUserStoriesSprint();
    cons3.DispUserStories(lstUS[3].Name);
    
    ApexPages.currentPage().getParameters().put('UpdateSwing','ReadyforTestUS');
    ApexPages.currentPage().getParameters().put('UserStoryID',lstUS[4].id);
    ApexPages.standardController sc4 = new ApexPages.standardController(lstSpr[0]);
    TRAK_KanbanBoardCntrl cons4 = new TRAK_KanbanBoardCntrl(sc4);
    PageReference ref4 = cons4.updateUserStoriesSprint();
    cons4.DispUserStories(lstUS[4].Name);
    
    ApexPages.currentPage().getParameters().put('UpdateSwing','InTestUS');
    ApexPages.currentPage().getParameters().put('UserStoryID',lstUS[5].id);
    ApexPages.standardController sc5 = new ApexPages.standardController(lstSpr[0]);
    TRAK_KanbanBoardCntrl cons5 = new TRAK_KanbanBoardCntrl(sc5);
    PageReference ref5 = cons5.updateUserStoriesSprint();
    cons5.DispUserStories(lstUS[5].Name);
    
    ApexPages.currentPage().getParameters().put('UpdateSwing','PassedUS');
    ApexPages.currentPage().getParameters().put('UserStoryID',lstUS[6].id);
    ApexPages.standardController sc6 = new ApexPages.standardController(lstSpr[0]);
    TRAK_KanbanBoardCntrl cons6 = new TRAK_KanbanBoardCntrl(sc6);
    PageReference ref6 = cons6.updateUserStoriesSprint();
    cons6.DispUserStories(lstUS[6].Name);
    
    ApexPages.currentPage().getParameters().put('UpdateSwing','StoryDefUS');
    ApexPages.currentPage().getParameters().put('UserStoryID',lstUS[7].id);
    ApexPages.standardController sc7 = new ApexPages.standardController(lstSpr[0]);
    TRAK_KanbanBoardCntrl cons7 = new TRAK_KanbanBoardCntrl(sc7);
    PageReference ref7 = cons7.updateUserStoriesSprint();
    cons7.DispUserStories(lstUS[7].Name);
    
    ApexPages.currentPage().getParameters().put('UpdateSwing','Random');
    ApexPages.currentPage().getParameters().put('UserStoryID',lstUS[8].id);
    ApexPages.standardController sc8 = new ApexPages.standardController(lstSpr[0]);
    TRAK_KanbanBoardCntrl cons8 = new TRAK_KanbanBoardCntrl(sc8);
    PageReference ref8 = cons8.updateUserStoriesSprint();
    cons8.DispUserStories(lstUS[8].Name);
  }
  
}