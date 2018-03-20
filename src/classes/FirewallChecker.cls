/****************************************************************************************************************************************** 
* Class Name   : FirewallChecker
* Description  : Class for the Firewall check on studies
* Created By   : Deloitte Consulting
* 
*****************************************************************************************************************************************/

public without sharing class FirewallChecker {
project__c oProject;
Public string sFireWallMessage {get;private set;}
Public Set<Id> lUsers;
    
    //Loading the Constructor
    public FirewallChecker(ApexPages.StandardController controller) {
        //Add all fields on controller
        oProject = (project__c)controller.getrecord();
        lUsers = new Set < id > ();
        for (Project__Share oShare: [Select ParentId, AccessLevel, UserOrGroupId from Project__Share where ParentId = : (Id) controller.getId()]) {
            lUsers.add(oShare.UserOrGroupId);
        }
        
    }
    
 /* 
* @Method Name                    :  onload
* @Description                    :  this method is executed on page load. it checks if a study has a firewall molecule or not.
* @Return Type                    :  pagereference 
* @Parameters                     :  None
*/    
    Public pagereference onload(){
        boolean bIsFirewall =false;
        for(DRDP_Study_Molecule__c oMolecule : [Select id,Molecule__c,Molecule__r.Firewall_Message__c,Molecule__r.Firewalled__c from DRDP_Study_Molecule__c where Project__c = :oProject.Id]){
            if(oMolecule.Molecule__r.Firewalled__c && (!lUsers.contains(UserInfo.getUserId()))){
                bIsFirewall = true;
                sFireWallMessage = oMolecule.Molecule__r.Firewall_Message__c;
                break;
            }
        }
        
        If(bIsFirewall){
            return null;
        }
        else{
            PageReference pRedirectObjectPageReference = new PageReference('/'+oProject.Id);
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
        PageReference pRedirectObjectPageReference = new PageReference('/'+oProject.Id);
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
            PageReference pRedirectObjectPageReference = new PageReference('/apex/StudyList');
            Map<String, String> mPageParameters = pRedirectObjectPageReference.getParameters();
            mPageParameters.put('nooverride', '1'); 
            return pRedirectObjectPageReference;
        }
        else{
            Schema.DescribeSObjectResult result = Project__c.SObjectType.getDescribe();
            PageReference pRedirectObjectPageReference = new PageReference('/' + result.getKeyPrefix()); 
            Map<String, String> mPageParameters = pRedirectObjectPageReference.getParameters();
            mPageParameters.put('nooverride', '1'); 
            return pRedirectObjectPageReference;  
        }
    }


}