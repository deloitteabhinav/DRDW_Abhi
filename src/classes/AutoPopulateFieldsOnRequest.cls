/****************************************************************************************************************************************** 
* Class Name   : AutoPopulateFieldsOnRequest 
* Description  : Class to Autopopulate fields from Study Object
* Created By   : Deloitte Consulting
* 
*****************************************************************************************************************************************/
Public with sharing class AutoPopulateFieldsOnRequest {
   
    Public Project__c oProject;
    Public Request__c oRequest;
    Public User uname;
    Public Boolean isFromStudy;
    public String PickValues;
    
    //Loading the constructor the page
    public AutoPopulateFieldsOnRequest(ApexPages.StandardController controller) {
        
        uname = [select Id, Name from User where Id = : UserInfo.getUserId() LIMIT 1];
        
        If((Request__c) controller.getRecord() != NULL) {
            
            oRequest = (Request__c) controller.getRecord();
            
            If(oRequest.Related_Project__c != NULL && String.valueOf(oRequest.Related_Project__c) != '') {
                
                oProject = [SELECT id, Business_Unit_Primary__c, Therapeutic_Area_Primary__c , Study_Region__c,Study_Project_ID__c                            
                            FROM Project__c WHERE id = : oRequest.Related_Project__c];
                
                isFromStudy = True;
                
            } else if (oRequest.Related_Project__c != NULL) {
                isFromStudy = False;
            }
        }
    }
    
    /* 
* @Method Name                    :  autoPopulateFieldsOnRequest
* @Description                    :  This method populates fields on request coming from study
* @Return Type                    :  pagereference
* @Parameters                     :  None
*/  
    public pagereference autoPopulateFieldsOnRequest() {
        
        Request_FieldId_Settings__c oCustSetting = Request_FieldId_Settings__c.getOrgDefaults();
        
        String sRecordTypeDeveloperName;
        
        String keyPrefix = Request__c.sObjectType.getDescribe().getKeyPrefix();
        
        Pagereference p = new pagereference('/' + keyPrefix + '/e?');
        p.getparameters().putall(ApexPages.currentPage().getparameters());
        p.getparameters().put('nooverride', '1');
        p.getparameters().remove('sfdc.override');
        p.getparameters().remove('save_new');
        If(oRequest.Related_Project__c != NULL & isFromStudy==true) {
            p.getparameters().put('saveURL', oRequest.Related_Project__c);
        } 
        
        if (oRequest.recordtypeid != null) {
            sRecordTypeDeveloperName = [Select developername from RecordType where id = : oRequest.recordtypeid].developername;
            p.getparameters().put('CF' + oCustSetting.Requestor__c + '_lkid', Uname.id);
            p.getparameters().put('CF' + oCustSetting.Requestor__c, Uname.Name);
        }
        if ((sRecordTypeDeveloperName == 'Study_Consultation' || sRecordTypeDeveloperName == 'Scientific_Technology') && isFromStudy == TRUE) {
            p.getparameters().put(oCustSetting.Business_Unit_Primary__c, oProject.Business_Unit_Primary__c);
            p.getparameters().put(oCustSetting.Primary_Therapeutic_Area__c, oProject.Therapeutic_Area_Primary__c);
            p.getparameters().put(oCustSetting.Region__c, oProject.Study_Region__c);
        }
        p.setRedirect(true);
        return p;
    }
}