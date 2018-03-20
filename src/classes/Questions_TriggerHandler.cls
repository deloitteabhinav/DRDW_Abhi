/****************************************************************************************************************************************** 
 * Class Name   : Questions_TriggerHandler 
 * Description  : Class to trim the QuestionText Length to 255 / Copy Study API
 * Created By   : Deloitte Consulting
 * 
 *****************************************************************************************************************************************/
Public with sharing class Questions_TriggerHandler {


    /* 
     * @Method Name                    :  ConvertQuestion
     * @Description                    :  Method to Trim the Question to 255 Characters
     * @Return Type                    :  void
     * @Parameters                     :  lQuestions
     */

    public static void ConvertQuestion(List < Questions__c > lQuestions) {
        for (Questions__c oQuestions: lQuestions) {
            String sQuestionText;
            sQuestionText = oQuestions.Question_Text__c;
            if (sQuestionText <> null && sQuestionText.length() > 255) {
                sQuestionText = sQuestionText.substring(0, 255 - 3);
                sQuestionText = sQuestionText + '...';
            }
            oQuestions.Question_Text_TF__c = sQuestionText;
        }
    }


    /* 
     * @Method Name                    :  CopyStudyAPI
     * @Description                    :  Method to get api name of Study Field
     * @Return Type                    :  void
     * @Parameters                     :  lQuestions
     */

    Public static void copyStudyAPI(List < Questions__c > lQuestions) {

        Map < String, String > labelToAPIName = new Map < String, String > ();

        for (Schema.SObjectField field: Schema.SObjectType.Project__c.fields.getMap().values()) {
            labelToAPIName.put(field.getDescribe().getLabel(), field.getDescribe().getName());
        }

        for (Questions__c oQuestions: lQuestions) {
            if (oQuestions.Study_Dependent__c != NULL) {
                if (labelToAPIName.get(oQuestions.Study_Dependent__c) <> NULL) {
                    oQuestions.Default_Study_Field__c = labelToAPIName.get(oQuestions.Study_Dependent__c);
                }
                Else {
                    oQuestions.addError('Invalid Study Label - Please Enter the Correct Study Label. Study Labels are Case Sensitive.');
                }
            }

        }
    }

    
      /* 
     * @Method Name                    :  retPicklist
     * @Description                    :  Method which retrives the picklist values of the study field and inserts them as options in the related list.
     * @Return Type                    :  void
     * @Parameters                     :  lQuestions
     */

    
    Public static void retPicklist(List < Questions__c > lQuestions) {
        Map < String, Schema.SObjectField > mSchemaMap = Schema.SObjectType.Project__c.fields.getMap();
        List < Question_Option__c > lOption = new List < Question_Option__c > ();
        
        for (Questions__c oQuestions: lQuestions) {
            If(mSchemaMap.get(oQuestions.Default_Study_Field__c) <> NULL) {
                Schema.SObjectField field = mSchemaMap.get(oQuestions.Default_Study_Field__c);
                If(String.Valueof(field.getDescribe().getType()) == 'PICKLIST') {
                    Schema.DescribeFieldResult fieldResult = field.getDescribe();
                    List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();
                    for (Schema.PicklistEntry p: ple) {
                        lOption.add(new Question_Option__c(Name = p.getValue(), Question__c = oQuestions.Id));
                    }

                }
            }
        }
        If(lOption.size() > 0) {
            Insert lOption;
        }
    }
}