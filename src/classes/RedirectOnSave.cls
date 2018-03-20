/****************************************************************************************************************************************** 
* Class Name   : RedirectOnSave
* Description  : Class to Redirect a Record Creation from Child to Parent.
* Created By   : Deloitte Consulting
* 
*****************************************************************************************************************************************/
Public with sharing class RedirectOnSave{

Private sObject oThisRecord;
Private String objType;
Public String keyPrefix;

    //Loading the constructor the page
    public RedirectOnSave(ApexPages.StandardController controller) {
        this.oThisRecord= controller.getRecord();
        objType = string.Valueof(controller.getRecord().getSObjectType());
    }
       
    /* 
    * @Method Name                    :  onloadFromStudy
    * @Description                    :  This method redirect user to Study page if the user completed filling and related list object record 
    * @Return Type                    :  pagereference 
    * @Parameters                     :  None
    */     
    public pagereference onloadFromStudy(){
    
        keyPrefix = Schema.getGlobalDescribe().get(objType).getDescribe().getKeyPrefix();
        
        Pagereference p = new pagereference('/' + keyPrefix + '/e?');        
        p.getparameters().putall(ApexPages.currentPage().getparameters());
        p.getparameters().put('nooverride','1');
        If((String)oThisRecord.get('Request__c')!=NULL){
        p.getparameters().put('saveURL',(String)oThisRecord.get('Request__c'));
        }
        If((String)oThisRecord.get('Project__c')!=NULL){
        p.getparameters().put('saveURL',(String)oThisRecord.get('Project__c'));
        }
        p.getparameters().remove('sfdc.override');
        p.getparameters().remove('save_new');
        System.debug(p.getparameters());
        p.setRedirect(true);
        return p;    
    }
    
    /* 
    * @Method Name                    :  onloadFromRequestForResource
    * @Description                    :  This method redirect user to Request page if the user completed filling and related list object record
    * @Return Type                    :  pagereference 
    * @Parameters                     :  None
    */  
    public pagereference onloadFromRequestForResource(){
    
        keyPrefix = Schema.getGlobalDescribe().get(objType).getDescribe().getKeyPrefix();
        
        Pagereference p = new pagereference('/' + keyPrefix + '/e?');        
        p.getparameters().putall(ApexPages.currentPage().getparameters());
        p.getparameters().put('nooverride','1');
        p.getparameters().put('saveURL',(String)oThisRecord.get('Request__c'));        
        p.getparameters().remove('sfdc.override');
        p.getparameters().remove('save_new');
        System.debug(p.getparameters());
        p.setRedirect(true);
        return p;    
    }
    
    /* 
    * @Method Name                    :  onloadFromInventory
    * @Description                    :  This method redirect user to Data asset(Inventory record) page if the user completed filling and related list object record
    * @Return Type                    :  pagereference 
    * @Parameters                     :  None
    */          
    public pagereference onloadFromInventory(){
    
        keyPrefix = Schema.getGlobalDescribe().get(objType).getDescribe().getKeyPrefix();
        
        Pagereference p = new pagereference('/' + keyPrefix + '/e?');        
        p.getparameters().putall(ApexPages.currentPage().getparameters());
        p.getparameters().put('nooverride','1');
        p.getparameters().put('saveURL',(String)oThisRecord.get('Data_Asset__c'));
        p.getparameters().remove('sfdc.override');
        p.getparameters().remove('save_new');
        System.debug(p.getparameters());
        p.setRedirect(true);
        return p;    
    }
    
          
    /* 
    * @Method Name                    :  onloadFromRequest
    * @Description                    :  This method redirect user to Request page if the user completed filling and related list object record
    * @Return Type                    :  pagereference 
    * @Parameters                     :  None
    */  
    public pagereference onloadFromRequest(){
    
        keyPrefix = Schema.getGlobalDescribe().get(objType).getDescribe().getKeyPrefix();
        
        Pagereference p = new pagereference('/' + keyPrefix + '/e?');        
        p.getparameters().putall(ApexPages.currentPage().getparameters());
        p.getparameters().put('nooverride','1');
        If((String)oThisRecord.get('Request__c')!=NULL){
        p.getparameters().put('saveURL',(String)oThisRecord.get('Request__c'));
        }
        p.getparameters().remove('sfdc.override');
        p.getparameters().remove('save_new');
        System.debug(p.getparameters());
        p.setRedirect(true);
        return p;    
    }
    

}