/****************************************************************************************************************************************** 
* Class Name   : HomePage
* Description  : Class for the HomePage on the UI
* Created By   : Deloitte Consulting
* 
*****************************************************************************************************************************************/
global with sharing class HomePage{   
    Public List<SelectOption> lExperience {get;set;}
    Public String sSelectedExperience{get;set;}
    Public DRDP_Feedback__c oFeedback{get;set;}
    Public String searchWord {get;set;}
    Public String searchWordMobile{get;set;}
    Public Boolean IsMobile{get;set;}
   
    
    //Loading the Constructor
    global HomePage() {
        IsMobile = isSF1();
        lExperience = new List<SelectOption>();
        oFeedback = new DRDP_Feedback__c();
        for (Schema.Picklistentry oPicklistValues : DRDP_Feedback__c.Experience__c.getDescribe().getPicklistValues()) {
            lExperience.add(new SelectOption(oPicklistValues.Label,oPicklistValues.Label));
        }
        System.debug('***'+ApexPages.currentPage().getHeaders().get('USER-AGENT'));
         
    }
    
    global void SaveFeedback(){
    oFeedback.Experience__c = sSelectedExperience;
    Insert oFeedback;
    oFeedback = new DRDP_Feedback__c();
    }
    
    global static Boolean isSF1(){
        if((String.isNotBlank(ApexPages.currentPage().getParameters().get('sfdcIFrameHost')) ||
            String.isNotBlank(ApexPages.currentPage().getParameters().get('sfdcIFrameOrigin')) ||
            ApexPages.currentPage().getParameters().get('isdtp') == 'p1' ||
            (ApexPages.currentPage().getParameters().get('retURL') != null && ApexPages.currentPage().getParameters().get('retURL').contains('projectone'))) && !ApexPages.currentPage().getHeaders().get('USER-AGENT').contains('iPad')
        ){
            return true;
        }else{
            return false;
        }
    }
    
    global PageReference populateGlobalURL() {
        If(searchWordMobile !='' && searchWordMobile !=null){
            searchWord = searchWordMobile;
        }
        if (searchWord != NULL && searchWord != '') {
            string reference;
            string encodedString;
            searchWord = EncodingUtil.urlEncode(searchWord, 'UTF-8');
            reference = '/apex/Global_Search?searchWord=' + searchWord ;
            PageReference pageRef = new PageReference(reference);
            pageRef.setRedirect(true);
            return pageRef;
        } else {
            return NULL;
        }
    }
    

}