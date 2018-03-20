/******************************************************************************************************************************************
 * Class Name   : PublicationsAndDeliverables
 * Description  : Class to display Publications And Deliverables on a Study Record
 * Created By   : Deloitte Consulting
 *
 *****************************************************************************************************************************************/
public with sharing class PublicationsAndDeliverables {

    private final Project__c oProject;
    Public boolean mEmpty {get; set;}
    String sStudyQuery = '';
    Public Map < String, List < String >> sMap {
        get;
        set;
    }

    /*
     * @Method Name                    :  GetStudyFieldsUsingDescribe
     * @Description                    :  this method returns a list of study fields
     * @Return Type                    :  List<String>
     * @Parameters                     :  None
     */

    Public List < String > GetStudyFieldsUsingDescribe() {
        List < String > sStudyAttribute = new List < String > ();
        for (String fieldName : Schema.SObjectType.project__c.fields.getMap().keySet()) {

            sStudyAttribute.add(fieldName);
            sStudyQuery = sStudyQuery + ',' + fieldName;

        }
        sStudyQuery = sStudyQuery.removestart(',');
        return sStudyAttribute;
    }

    public PublicationsAndDeliverables(ApexPages.StandardController controller) {

        //Add all fields on controller
        if (!test.isRunningTest()) {
            controller.addfields(GetStudyFieldsUsingDescribe());
        }
        this.oProject = (Project__c) controller.getRecord();
        sMap = new map < String, list < String >> ();
        mEmpty = FALSE;

        //Checking if the fields have the links assigned to them.

        isNull(oProject.Final_Protocol__c, 'Final_Protocol__c');
        isNull(oProject.Statistical_Analysis_Plan_URL__c, 'Statistical_Analysis_Plan_URL__c');
        isNull(oProject.Scientific_Disclosures_URL__c, 'Scientific_Disclosures_URL__c');
        isNull(oProject.Study_Report_URL__c, 'Study_Report_URL__c');
        isNull(oProject.FDAMA_piece_URL__c, 'FDAMA_piece_URL__c');
        isNull(oProject.AMCP_Formulary_Submission_URL__c, 'AMCP_Formulary_Submission_URL__c');
        isNull(oProject.Medical_Value_Summary_URL__c, 'Medical_Value_Summary_URL__c');
        isNull(oProject.Response_to_Regulatory_URL__c, 'Response_to_Regulatory_URL__c');
        isNull(oProject.Response_to_Non_Regulatory_URL__c, 'Response_to_Non_Regulatory_URL__c');
        isNull(oProject.Non_Serious_Adverse_Events_List_URL__c, 'Non_Serious_Adverse_Events_List_URL__c');
        isNull(oProject.Model_URL__c, 'Model_URL__c');
        isNull(oProject.Research_Topic_Report_URL__c, 'Research_Topic_Report_URL__c');
        isNull(oProject.Data_Collection_Form_URL__c, 'Data_Collection_Form_URL__c');
        isNull(oProject.Other_URL__c, 'Other_URL__c');

        if (sMap.isEmpty()) {
            mEmpty = TRUE;
        }
    }

    /*
    * @Method Name                    :  isNull
    * @Description                    :  Null check for fields
    * @Return Type                    :  Null
    * @Parameters                     :  String, String
    */


    public void isNull(String fieldName, String fieldLabel) {
        If(fieldName <> NULL) {
            fieldName = fieldName.replaceAll('\\s+','');
            sMap.put(Schema.getGlobalDescribe().get('Project__c').getDescribe().fields.getMap().get(fieldLabel).getDescribe().getLabel(), new list < String > (
                         fieldName.split(',')));
        }
    }

}