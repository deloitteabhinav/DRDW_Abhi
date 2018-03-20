/****************************************************************************************************************************************** 
* Class Name   : FirewallChecker_Request 
* Description  : Class for the Firewall check on requests
* Created By   : Deloitte Consulting
* 
*****************************************************************************************************************************************/

public without sharing class FirewallChecker_Request {

request__c oRequest;
Public string sFireWallMessage {get;private set;}
Public Boolean IsRestrict;

    //Loading the contructor
    public FirewallChecker_Request(ApexPages.StandardController controller) {
        oRequest = (request__c)controller.getrecord();
        IsRestrict = False;
        For(UserRecordAccess oAccess : [Select RecordId, HasReadAccess, HasEditAccess, HasDeleteAccess FROM  UserRecordAccess WHERE UserId=:UserInfo.getUserId() AND RecordId =: (id) controller.getId()]){
            If( oAccess.HasReadAccess == TRUE && oAccess.HasEditAccess == FALSE && oAccess.HasDeleteAccess == FALSE) {
                IsRestrict = True;
            }
        }
    }
    
/* 
* @Method Name                    :  onload
* @Description                    :  this method is executed on page load. it checks if a request has a firewall molecule or not.
* @Return Type                    :  pagereference 
* @Parameters                     :  None
*/    
    Public pagereference onload(){
        boolean bIsFirewall =false;
        for(DRDP_Request_Molecule__c oMolecule : [Select id,Molecule__c,Molecule__r.Firewall_Message__c,Molecule__r.Firewalled__c from DRDP_Request_Molecule__c where Request__c = :oRequest.Id]){
            if(oMolecule.Molecule__r.Firewalled__c && IsRestrict == True){
                bIsFirewall = true;
                sFireWallMessage = oMolecule.Molecule__r.Firewall_Message__c;
                break;
            }
        }
        
        If(bIsFirewall){
            return null;
        }
        else{
            PageReference pRedirectObjectPageReference = new PageReference('/'+oRequest.Id);
            Map<String, String> mPageParameters = pRedirectObjectPageReference.getParameters();
            mPageParameters.put('nooverride', '1');     
            mPageParameters.putall(ApexPages.currentPage().getParameters());
            return pRedirectObjectPageReference;
        }   
        
    }
    
    
 /* 
* @Method Name                    :  acknowledge
* @Description                    :  this method is executed when a user click on "I acknowledge" button on the warning page.
* @Return Type                    :  pagereference 
* @Parameters                     :  None
*/ 
    Public pagereference acknowledge(){
        PageReference pRedirectObjectPageReference = new PageReference('/'+oRequest.Id);
        Map<String, String> mPageParameters = pRedirectObjectPageReference.getParameters();
        mPageParameters.put('nooverride', '1');     
        mPageParameters.putall(ApexPages.currentPage().getParameters());
        return pRedirectObjectPageReference;
    }
    
    
/* 
* @Method Name                    :  back
* @Description                    :  this method is executed when a user click on "cancel" button on the warning page.
* @Return Type                    :  pagereference 
* @Parameters                     :  None
*/  
    
    Public pagereference back(){
        If( ApexPages.currentPage().getParameters().get('IsFromUI') == 'TRUE'){
            PageReference pRedirectObjectPageReference = new PageReference('/apex/RequestList');
            Map<String, String> mPageParameters = pRedirectObjectPageReference.getParameters();
            mPageParameters.put('nooverride', '1'); 
            return pRedirectObjectPageReference;
        }
        else{
            Schema.DescribeSObjectResult result = Request__c.SObjectType.getDescribe();
            PageReference pRedirectObjectPageReference = new PageReference('/' + result.getKeyPrefix()); 
            Map<String, String> mPageParameters = pRedirectObjectPageReference.getParameters();
            mPageParameters.put('nooverride', '1'); 
            return pRedirectObjectPageReference;  
        }
    }

}