/****************************************************************************************************************************************** 
* Class Name   : Test_TRAK_Controller_PlanningPoker
* Description  : Test class for TRAK_Controller_PlanningPoker 
* Created By   : Neha Kumari
* 
*****************************************************************************************************************************************/

@isTest
private class Test_TRAK_Controller_PlanningPoker{
  static testmethod void TestPlanningPokerFn(){
      List<User> U = TRAK_Test_Utility.createUser('Senior System Administrator',2,'AB');
      
      List<TRAK_Sprint__c> Lspr = TRAK_Test_Utility.createSprint(3);
      insert Lspr;
      
      List<TRAK_User_Story__c> US = TRAK_Test_Utility.createUserStory(1);
      insert US;
      
      List<TRAK_Planning_Poker_Session__c> Lpps = TRAK_Test_Utility.createPPSession(1);
      Lpps[0].Leader__c = U[1].id;
      Lpps[0].Sprint__c = Lspr[0].id;
      insert Lpps;
      
      List<TRAK_Planning_Poker_Session_Content__c> Lpp = TRAK_Test_Utility.createPPSessionContent(1,US[0].id);
      Lpp[0].Planning_Poker_Session__c = Lpps[0].Id;
      insert Lpp;
      
      List<TRAK_Planning_Poker_Session_User__c> Lppuser = TRAK_Test_Utility.createPPSessionUser(1,Lpps[0].id);
      insert Lppuser;
      
      List<TRAK_Planning_Poker_Votes__c> Lppvote = TRAK_Test_Utility.createPPVotes(1, Lpp[0].id);
      insert LppVote;
      
     
      
      system.runAs(U[0]){
          Test.startTest();
            ApexPages.currentPage().getParameters().put('id',Lpps[0].id);
            ApexPages.currentPage().getParameters().put('generateSession',US[0].id);
            TRAK_Controller_PlanningPoker cons = new TRAK_Controller_PlanningPoker();
            TRAK_Controller_PlanningPoker.setScore(Lpps[0].id,'40','SFDC','Salesforce');
            //TRAK_Controller_PlanningPokerData Poker = cons.getData(1, Lpps[0].id);
            TRAK_Controller_PlanningPoker.PlanningPokerData oData = TRAK_Controller_PlanningPoker.getData(Lpps[0].Id);
            TRAK_Controller_PlanningPoker.reEstimate(Lpps[0].id);
            cons.enterSession();
            PageReference pg = cons.generateSession();
           // TRAK_Controller_PlanningPoker.setStory(US[0].id);
         // TRAK_Controller_PlanningPoker.getData(Lpp[0].id);
            TRAK_Controller_PlanningPoker.kickUser('test',Lpps[0].id);
            TRAK_Controller_PlanningPoker.vote('2',Lpps[0].id);
            
          Test.stopTest();
      }
  }
}