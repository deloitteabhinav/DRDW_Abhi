/****************************************************************************************************************************************** 
* Class Name   : RequestTrackingRedirect 
* Description  : Class to Autopopulate 2 fields from Request Object
* Created By   : Deloitte Consulting
* 
*****************************************************************************************************************************************/
public with sharing class RequestTrackingRedirect {

public Request_Tracking__c oReqTracking;
public Request__c oReq;
ApexPages.StandardController sController; 

    public RequestTrackingRedirect (ApexPages.StandardController controller) {
     sController = controller;
     oReqTracking =  (Request_Tracking__c )controller.getrecord();
     oReq = [select Request_Status__c,Request_Sub_Status__c from Request__c where ID = :oReqTracking.RWE_Request__c];
    }

    public pagereference Redirect() {
            schema.sobjecttype oDynamicObjectype = oReqTracking.getsObjectType();
            PageReference p = new PageReference('/' + oDynamicObjectype.getDescribe().getKeyPrefix()+ '/e');            
            Request_FieldId_Settings__c oCustSetting = Request_FieldId_Settings__c.getOrgDefaults();

            p.getParameters().putall(ApexPages.currentPage().getParameters());
            p.getParameters().put('nooverride', '1');
            //Auto-populating Request Status & Request Stage values
            p.getParameters().put(oCustSetting.Request_Status__c,oReq.Request_Status__c);
            p.getParameters().put(oCustSetting.Request_Stage__c,oReq.Request_Sub_Status__c);
            if(p.getParameters().containskey('save_new')){
                p.getParameters().remove('save_new');
            }
            return p;

    }
}