/****************************************************************************************************************************************** 
 * Class Name   : StudyAttribute_TriggerHandler 
 * Description  : Class to Copy API Names according to Label
 * Created By   : Deloitte Consulting
 * 
 *****************************************************************************************************************************************/
Public with sharing class StudyAttribute_TriggerHandler {

    /* 
     * @Method Name                    :  CopyStudyAPI
     * @Description                    :  Method to get api name of Study Field
     * @Return Type                    :  void
     * @Parameters                     :  lAttribute
     */

    Public Static void CopyStudyAPI(List < Study_Attribute__c > lAttribute) {

        Map < String, String > labelToAPIName = new Map < String, String > ();
        
        for (Schema.SObjectField field: Schema.SObjectType.Project__c.fields.getMap().values()) {
            labelToAPIName.put(field.getDescribe().getLabel(), field.getDescribe().getName());
            }

        for (Study_Attribute__c oAttribute: lAttribute) {
          if(oAttribute.Study_Field_Label__c != NULL){
                if(labelToAPIName.get(oAttribute.Study_Field_Label__c) <> NULL){
                    oAttribute.Study_Field__c=labelToAPIName.get(oAttribute.Study_Field_Label__c);
                }Else if(oAttribute.Study_Field_Label__c == 'Countries the Study is being conducted in' && oAttribute.Study_Attribute__c != NULL ){
                	 break;
                }Else{
                    oAttribute.addError('Invalid Study Label - Please Enter the Correct Study Label. Study Labels are Case Sensitive.');
                }
            }

        }
    }
}