/****************************************************************************************************************************************** 
 * Class Name   : Dependent_Question_TriggerHandler 
 * Description  : Class to update "Has Dependent?" field on Question record
 * Created By   : Deloitte Consulting
 * 
 *****************************************************************************************************************************************/
Public with sharing class Dependent_Question_TriggerHandler {


    /* 
     * @Method Name                    :  updateQuestionRecord
     * @Description                    :  Method to update "Has Dependent?" field on Question record
     * @Return Type                    :  void
     * @Parameters                     :  list of Dependent_Question__c records
     */

    public static void updateQuestionRecord(List < Dependent_Question__c> lDependentQuestions) {
        
        set<id> sQuestionIDs = new set<id>();
        for(Dependent_Question__c oDepQn : [SELECT Option__r.Question__c from Dependent_Question__c  where id in : lDependentQuestions ALL ROWS]){
            sQuestionIDs.add(oDepQn.Option__r.Question__c);
        }
        list<Questions__c> lQuestions = new list<Questions__c>();
        list<AggregateResult> aggr  = new list<AggregateResult>();
        set<id> sDepQns = new set<id>();
        aggr = [SELECT count(id),Option__r.Question__c Qnid FROM Dependent_Question__c where id in:lDependentQuestions GROUP BY Option__r.Question__c];
        if(aggr.size()>0){
            for (AggregateResult ar : aggr)  {
                Questions__c oQuestion = new Questions__c();
                oQuestion.id = string.valueof(ar.get('Qnid'));
                if((integer)ar.get('expr0')>0){
                    oQuestion.Has_Dependent__c=true;
                    lQuestions.add(oQuestion);    
                    sDepQns.add(string.valueof(ar.get('Qnid')));
                }
            }
        }
        boolean b = sQuestionIDs.removeAll(sDepQns);
        for(id oID : sQuestionIDs){
            lQuestions.add(new Questions__c(id=oID,Has_Dependent__c=false) );
        }
        try{
            update lQuestions;
        }catch(exception e){
            GLBL_Error_Log__c errLog = new GLBL_Error_Log__c(   Error_Datetime__c= DateTime.Now(),Error_Message__c= e.getMessage(),Running_User__c = UserInfo.getUserId() ,Stack_Trace__c = e.getStackTraceString());  
            insert errlog;   
        }
    }
}