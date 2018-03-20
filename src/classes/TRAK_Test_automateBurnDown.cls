@isTest (seeAllData=false)

Global class TRAK_Test_automateBurnDown{
 
 public static testmethod void testupdateSprintBurndown(){
     List<TRAK_Sprint__c> lstSpr = TRAK_Test_Utility.createSprint(1);
     lstSpr[0].Status__c='In Progress';
     insert lstSpr;
     System.assertNotEquals( lstSpr[0].Id, null );
     //TRAK_App__c app = new  TRAK_App__c();
     //app.Name='tracker'; 
     //insert app;
     
     //TRAK_Project__c proj = new TRAK_Project__c();
     //proj.Name='new';
     //i//nsert proj;
     
     List<TRAK_User_Story__c> US = TRAK_Test_Utility.createUserStory(2);
     US[0].Allocated_Sprint__c= lstSpr[0].id;
     insert US;
     System.assertNotEquals( US[0].Id, null );
     System.assertNotEquals( US[1].Id, null );
      
     List<TRAK_BurnDown2__c> lstBD = TRAK_Test_Utility.createBurndown(1);
     lstBD[0].Sprint__c = lstSpr[0].id;
     lstBD[0].Date__c = system.today();
     insert lstBD;
     System.assertNotEquals( lstBD[0].Id, null );
     
     List<TRAK_Bug__c> LstBG = TRAK_Test_Utility.createDefect(1);
     LstBG[0].Allocated_Sprint__c = lstSpr[0].id;
     LstBG[0].Sprint2__c = lstSpr[0].id;
     insert LstBG;
     System.assertNotEquals( LstBG[0].Id, null );
     
     TRAK_automateBurnDown.updateSprintBurndown(lstSpr);
     //TRAK_BurnDown2__c burn1 = new TRAK_BurnDown2__c();
     //burn1 = [SELECT Id, Name, Sprint__c, Points_Complete__c FROM TRAK_BurnDown2__c WHERE Id =: burndown.Id ];
     //System.AssertEquals(3,burn1.Points_Complete__c );
     /*defect.User_Story__c = UserStory2.Id;
     update defect;
     TRAK_automateBurnDown.updateSprintBurndown( aclist); */
 }

}