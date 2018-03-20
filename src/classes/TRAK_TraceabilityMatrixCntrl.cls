/* Class Name   : TRAK_TraceabilityMatrixCntrl
 * Description  : This is the controller for the TRAK_TraceabilityMatrix Page.
 *
 * Created By   : Deloitte Consulting
 * Created On   : 29th March 2016
 
*/

public with sharing class TRAK_TraceabilityMatrixCntrl {

    
    //Variable Declaration
  
  Public TRAK_Sprint__c Sprint{get;set;}
  Public List<TRAK_User_Story__c> UserList { get; set; }
  Public TRAK_Sprint__c Sprintname{ get; set; }
  
    
    public TRAK_TraceabilityMatrixCntrl(ApexPages.StandardController controller) {
    
    this.Sprint=(TRAK_Sprint__c)controller.getrecord();
    Sprintname=[Select id,name from TRAK_Sprint__c where id=:Sprint.id];
    UserList = [SELECT id, Name,Approval_Status__c ,(SELECT LastModifieddate FROM User_Story_Approval_History__r order by LastModifieddate desc limit 1),(SELECT Name,id,Approval_Status__c,Approval_Date__c,Template__c FROM TRAK_Tests__r where Template__c !=null Order by lastmodifieddate desc limit 1),(SELECT Name,id,Approval_Status__c,Approval_Date__c FROM TRAK_Test_Templates__r Order by lastmodifieddate desc limit 1)FROM TRAK_User_Story__c  where Allocated_Sprint__c =:Sprint.id order by LastmodifiedDate desc];


    }
    
   //Method to print records to excel 
   Public Pagereference redirect(){

   Pagereference p=new Pagereference('/apex/TRAK_TraceabilityMatrixExcel');
   p.setredirect(false);
   return p;
   
    
    }

}