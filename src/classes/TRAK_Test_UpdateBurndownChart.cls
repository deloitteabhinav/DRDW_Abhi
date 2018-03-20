@isTest(seeAllData = false)

public class TRAK_Test_UpdateBurndownChart{

    public static testmethod void testBurndown(){
    
    
     list< TRAK_Sprint__c> aclist = new list< TRAK_Sprint__c>(); 
    
     TRAK_Sprint__c activeSprint = new TRAK_Sprint__c();
     activeSprint.Name = 'Test';
     
     //activeSprint.Gate_1__c= 'Approved';
     activeSprint.Start_Date__c = System.Today()-1;
     activeSprint.End_Date__c =System.Today()+50;
     activeSprint.Status__c='In Progress';
     aclist.add(activeSprint);
     insert acList;
     id batjobId = Database.executeBatch(new TRAK_UpdateBurndownChart(), 20);
     String sch = '0 0 23 * * ?';
     system.schedule('Test check', sch, new TRAK_UpdateBurndownChart()); 
    }
}