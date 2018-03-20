/******************************************************************************************************************************************
* Class Name   : Study_TimelineChartController
* Description  : Controller to pass Data to create Custom Charts on Study Duration fields.
* Created By   : Deloitte Consulting
*
*****************************************************************************************************************************************/

public with sharing class Study_TimelineChartController {


    public Project__c oStudy {get; set;}
    public list<AggregateResult> lAggr;

    //Loading the Standard Controller
    Public Study_TimelineChartController(ApexPages.StandardController sc) {
        oStudy = [Select Classification__c, Study_Description__c, Secondary_Study_Type__c, Approved_Duration__c, Active_Duration__c, Completed_Duration__c, Data_Analysis_and_Reporting_Duration__c, Finalize_Store_StudyDeliverable_Duration__c, Ideation_Duration__c,
                  Oversee_Execution_of_Research_Duration__c, Questionnaire_Duration__c, Review_Approve_StudyDeliverable_Duration__c, Secure_Resources_Duration__c,
                  Study_Deliverable_s_Results_Duration__c, Study_Development_Duration__c, Study_Execution_Duration__c from Project__c where Id = :sc.getId()];

        if (oStudy.Classification__c == 'Research Project') {
            lAggr = [select AVG(Approved_Duration__c)AppAvg, AVG(Active_Duration__c)ActAvg, AVG(Completed_Duration__c )CompAvg, AVG(Data_Analysis_and_Reporting_Duration__c) DataAvg,
                     AVG(Finalize_Store_StudyDeliverable_Duration__c) FinalAvg, AVG(Ideation_Duration__c) IdeaAvg, AVG(Oversee_Execution_of_Research_Duration__c) OverAvg,
                     AVG(Questionnaire_Duration__c) QuesAvg, AVG(Review_Approve_StudyDeliverable_Duration__c) RevAvg, AVG(Secure_Resources_Duration__c) SecAvg,
                     AVG(Study_Deliverable_s_Results_Duration__c) StuDelAvg, AVG(Study_Development_Duration__c) StuDevAvg, Avg(Study_Execution_Duration__c) StuExeAvg
                     FROM Project__c WHERE Project_Status__c NOT IN ('On Hold', 'Cancelled')
                     AND Classification__c = :oStudy.Classification__c];
        } else {
            lAggr = [select AVG(Approved_Duration__c)AppAvg, AVG(Active_Duration__c)ActAvg, AVG(Completed_Duration__c )CompAvg, AVG(Data_Analysis_and_Reporting_Duration__c) DataAvg,
                     AVG(Finalize_Store_StudyDeliverable_Duration__c) FinalAvg, AVG(Ideation_Duration__c) IdeaAvg, AVG(Oversee_Execution_of_Research_Duration__c) OverAvg,
                     AVG(Questionnaire_Duration__c) QuesAvg, AVG(Review_Approve_StudyDeliverable_Duration__c) RevAvg, AVG(Secure_Resources_Duration__c) SecAvg,
                     AVG(Study_Deliverable_s_Results_Duration__c) StuDelAvg, AVG(Study_Development_Duration__c) StuDevAvg, Avg(Study_Execution_Duration__c) StuExeAvg
                     FROM Project__c WHERE Project_Status__c NOT IN ('On Hold', 'Cancelled')
                     AND Classification__c = :oStudy.Classification__c AND Study_Description__c = :oStudy.Study_Description__c AND Secondary_Study_Type__c = :oStudy.Secondary_Study_Type__c];
        }
    }

    /*
    * @Method Name                    :  getStatusChartData
    * @Description                    :  Method to Obtain Status Chart's Data
    * @Return Type                    :  list<StatusDurationWrapper>
    * @Parameters                     :  None
    */

    public list<StatusDurationWrapper> getStatusChartData() {
        list<StatusDurationWrapper> lData = new list<StatusDurationWrapper>();

        lData.add( new StatusDurationWrapper(checkValue(oStudy.Approved_Duration__c), 'Approved', checkValue((decimal)lAggr[0].get('AppAvg'))) );
        lData.add( new StatusDurationWrapper(checkValue(oStudy.Active_Duration__c), 'Active', checkValue((decimal)lAggr[0].get('ActAvg'))) );
        lData.add( new StatusDurationWrapper(checkValue(oStudy.Completed_Duration__c) , 'Completed', checkValue((decimal)lAggr[0].get('CompAvg'))) );

        return lData;
    }


    /*
    * @Method Name                    :  getStageChartData
    * @Description                    :  Method to Obtain Stage Chart's Data
    * @Return Type                    :  list<StatusDurationWrapper>
    * @Parameters                     :  None
    */

    public list<StatusDurationWrapper> getStageChartData() {
        list<StatusDurationWrapper> lStageData = new list<StatusDurationWrapper>();

        lStageData.add( new StatusDurationWrapper(checkValue(oStudy.Questionnaire_Duration__c), 'Questionnaire', checkValue((decimal)lAggr[0].get('QuesAvg'))) );
        lStageData.add( new StatusDurationWrapper(checkValue(oStudy.Ideation_Duration__c), 'Ideation', checkValue((decimal)lAggr[0].get('IdeaAvg'))) );
        lStageData.add( new StatusDurationWrapper(checkValue(oStudy.Secure_Resources_Duration__c), 'Secure Resources', checkValue((decimal)lAggr[0].get('SecAvg'))) );
        lStageData.add( new StatusDurationWrapper(checkValue(oStudy.Study_Development_Duration__c), 'Study Development', checkValue((decimal)lAggr[0].get('StuDevAvg'))) );
        lStageData.add( new StatusDurationWrapper(checkValue(oStudy.Study_Execution_Duration__c), 'Study Execution', checkValue((decimal)lAggr[0].get('StuExeAvg'))) );
        lStageData.add( new StatusDurationWrapper(checkValue(oStudy.Oversee_Execution_of_Research_Duration__c), 'Oversee Execution of Research', checkValue((decimal)lAggr[0].get('OverAvg'))) );
        lStageData.add( new StatusDurationWrapper(checkValue(oStudy.Data_Analysis_and_Reporting_Duration__c), 'Data Analysis and Reporting', checkValue((decimal)lAggr[0].get('DataAvg'))) );
        lStageData.add( new StatusDurationWrapper(checkValue(oStudy.Study_Deliverable_s_Results_Duration__c), 'Study Deliverable(s) and Results', checkValue((decimal)lAggr[0].get('StuDelAvg'))) );
        lStageData.add( new StatusDurationWrapper(checkValue(oStudy.Review_Approve_StudyDeliverable_Duration__c), 'Review/ Approve Study Deliverable', checkValue((decimal)lAggr[0].get('RevAvg'))) );
        lStageData.add( new StatusDurationWrapper(checkValue(oStudy.Finalize_Store_StudyDeliverable_Duration__c), 'Finalize, Store Study Deliverables', checkValue((decimal)lAggr[0].get('FinalAvg'))) );

        return lStageData;
    }


    /*
    * @Method Name                    :  checkValue
    * @Description                    :  Method to check and process the Duration before Charting
    * @Return Type                    :  list<StatusDurationWrapper>
    * @Parameters                     :  decimal
    */

    public decimal checkValue(decimal NumbertoScale) {
        if (NumbertoScale == null)
            return 0;
        else
            return NumbertoScale.setScale(2);
    }


    /*********************************************
    * Class Name   : StatusDurationWrapper
    * Description  : Wrapper Class to Store a particular Status/Stage Name, its Duration & its Average Duration.
    * Created By   : Deloitte Consulting
    *
    ********************************************/
    public class StatusDurationWrapper {
        public String StatusValue {get; set;}
        public Decimal Duration {get; set;}
        public Decimal AvgValue {get; set;}

        StatusDurationWrapper(Decimal Duration, String StatusValue, Decimal AvgValue) {
            this.StatusValue = StatusValue;
            this.Duration = Duration;
            this.AvgValue = AvgValue;
        }
    }
}