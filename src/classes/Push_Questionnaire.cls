/****************************************************************************************************************************************** 
* Class Name   : Push_Questionnaire
* Description  : Class to Push Questionnaire 
* Created By   : Deloitte Consulting
* 
*****************************************************************************************************************************************/

Public with sharing class Push_Questionnaire {
    public transient List < Project__c > lProjects;
    public ApexPages.StandardSetController stdController;
    Map < Id, Study_Questionnaire__c > mStudyQuestionaire = new Map < Id, Study_Questionnaire__c > ();
    Id iQuestionnaire;
    List < Study_Questionnaire__c > lStudyQuestionaire = new List < Study_Questionnaire__c > ();
    
     /* 
    * @Method Name                    :  GetStudyFieldsUsingDescribe
    * @Description                    :  Getting the List Study Fields 
    * @Return Type                    :  List
    * @Parameters                     :  None
    */     
    Public List < String > GetStudyFieldsUsingDescribe() {
        List < String > sStudyAttribute = new List < String > ();
        for (String fieldName: Schema.SObjectType.project__c.fields.getMap().keySet()) {
            sStudyAttribute.add(fieldName);
        }
        return sStudyAttribute;
    }

    
    //Constructor
    public Push_Questionnaire(ApexPages.StandardSetController controller) {
    stdController = controller;
        if (!Test.isRunningTest()) {
            controller.addFields(GetStudyFieldsUsingDescribe());
            controller.setpagesize(1000);
        }
        lProjects = (List < Project__c > ) controller.getrecords();
        iQuestionnaire = ApexPages.currentPage().getParameters().get('qid');

        for (Project__c oStudyQuestionaire: [Select id, (Select id, Questionnaire__c from QFOR_Study_Questionnaires__r order by createddate desc limit 1) from Project__c where Id in : lProjects]) {
            if (oStudyQuestionaire.QFOR_Study_Questionnaires__r.size() > 0)
                mStudyQuestionaire.put(oStudyQuestionaire.Id, oStudyQuestionaire.QFOR_Study_Questionnaires__r[0]);
        }
    }
    
     /* 
    * @Method Name                    :  PushQuestionnaire
    * @Description                    :  Pushing the Questionnaire on studies
    * @Return Type                    :  pagereference
    * @Parameters                     :  None
    */  
    public pagereference PushQuestionnaire() {
            lProjects = (List < Project__c > ) stdcontroller.getrecords();
        for (Project__c oStudy: lProjects) {
            if (oStudy.Project_Status__c != 'Completed') {
                if (!mStudyQuestionaire.containskey(oStudy.Id) || (mStudyQuestionaire.containskey(oStudy.Id) && mStudyQuestionaire.get(oStudy.Id).Questionnaire__c != iQuestionnaire)) {
                    Study_Questionnaire__c oQuestionaire = new Study_Questionnaire__c();
                    oQuestionaire.Study__c = oStudy.Id;
                    oQuestionaire.Questionnaire__c = iQuestionnaire;
                    lStudyQuestionaire.add(oQuestionaire);
                    oStudy.Study_Stage__c = 'Questionnaire Needs Review';
                    oStudy.Close_Out__c = false;
                }
            }
        }
        Update lProjects;
        Insert lStudyQuestionaire;
        return new pagereference('/' + iQuestionnaire);
    }

}