/****************************************************************************************************************************************** 
* Class Name   : Communities
* Description  : Class for Communities
* Created By   : Deloitte Consulting
* 
*****************************************************************************************************************************************/
public with sharing class Communities{    
    public Account a {get; set;}
    //Loading the Contructor
    public Communities(ApexPages.StandardController stdController) {
        User u = [SELECT AccountID from USER where id=:userinfo.getuserID()];
        a = [SELECT Name,Logo_URL__c, Organization_Welcome_Description__c, Logo__c
             FROM Account 
             WHERE id=:u.AccountID ];    
    }

}