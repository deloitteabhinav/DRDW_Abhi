/****************************************************************************************************************************************** 
* Class Name   : Index_Controller
* Description  : Class for Index Component
* Created By   : Deloitte Consulting
* 
*****************************************************************************************************************************************/
Public with sharing class Index_Controller {


    Public String searchWord {
        get;
        set;
    }
    Public boolean iSync{get;private set;}


    //Constructor for Index component
    Public Index_Controller() {
        Set<id> sProjectIds = new Set<id>();
        for (Project__Share oShare: [Select ParentId, AccessLevel, UserOrGroupId from Project__Share where UserOrGroupId = : userinfo.getuserid() AND (AccessLevel = 'Edit' OR AccessLevel = 'All') ]) {
            sProjectIds.add(oShare.ParentId);
        }
        
        AggregateResult[] groupedResults = [SELECT Count(Id)aver FROM Project__c where Id in: sProjectIds and Study_Stage__c = :'Questionnaire Needs Review'];
        if((Integer)groupedResults[0].get('aver')>0){
            iSync = true;
        }

    }
    
     /* 
    * @Method Name                    :  populateGlobalURL
    * @Description                    :  Method for Referencing tabs on the Page
    * @Return Type                    :  PageReference 
    * @Parameters                     :  None
    */   
    public PageReference populateGlobalURL() {
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