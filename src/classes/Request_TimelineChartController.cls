/******************************************************************************************************************************************
* Class Name   : Request_TimelineChartController
* Description  : Controller to pass Data to create Custom Charts on Request Duration fields.
* Created By   : Deloitte Consulting
*
*****************************************************************************************************************************************/

public with sharing class Request_TimelineChartController {


    public Request__c oReq {get; set;}
    public list<AggregateResult> lAggr;

    //Loading the Standard Controller
    Public Request_TimelineChartController(ApexPages.StandardController sc) {
        oReq = [Select RecordType.Name, Status_Accepted_to_In_Progress__c , Status_In_Progress_to_Complete__c , Status_New_to_Accepted__c ,
                Status_Contracting_to_Launch__c , Status_Exploration_to_Governance__c , Status_Governance_to_Contracting__c
                FROM Request__c where Id = :sc.getId()];

        lAggr = [select AVG(Status_Accepted_to_In_Progress__c) AccInProgAvg , AVG(Status_In_Progress_to_Complete__c) InProgCompAvg ,
                 AVG(Status_New_to_Accepted__c) NewAccAvg , AVG(Status_Contracting_to_Launch__c) ContLaunAvg ,
                 AVG(Status_Exploration_to_Governance__c) ExpGovAvg , AVG(Status_Governance_to_Contracting__c) GovContAvg
                 FROM Request__c WHERE Request_Status__c NOT IN ('Archived', 'Cancelled', 'Deleted') AND CreatedDate > LAST_YEAR
                 AND RecordType.Name = :oReq.RecordType.Name ];
    }

    /*
    * @Method Name                    :  getStatusChartData
    * @Description                    :  Method to Obtain Status Chart's Data
    * @Return Type                    :  list<StatusDurationWrapper>
    * @Parameters                     :  None
    */
    public list<StatusDurationWrapper> getStatusChartData() {
        list<StatusDurationWrapper> lData = new list<StatusDurationWrapper>();
        lData.add( new StatusDurationWrapper(checkValue(oReq.Status_New_to_Accepted__c), 'New', checkValue((decimal)lAggr[0].get('NewAccAvg'))) );
        lData.add( new StatusDurationWrapper(checkValue(oReq.Status_Accepted_to_In_Progress__c), 'Accepted', checkValue((decimal)lAggr[0].get('AccInProgAvg'))) );
        lData.add( new StatusDurationWrapper(checkValue(oReq.Status_In_Progress_to_Complete__c), 'In Progress', checkValue((decimal)lAggr[0].get('InProgCompAvg'))) );
        return lData;
    }

    /*
    * @Method Name                    :  getPartnershipStageChartData
    * @Description                    :  Method to Obtain RWE Partnership Exploration Stages Chart's Data
    * @Return Type                    :  list<StatusDurationWrapper>
    * @Parameters                     :  None
    */
    public list<StatusDurationWrapper> getPartnershipStageChartData() {
        list<StatusDurationWrapper> lStageData = new list<StatusDurationWrapper>();
        lStageData.add( new StatusDurationWrapper(checkValue(oReq.Status_Exploration_to_Governance__c), 'Exploration', checkValue((decimal)lAggr[0].get('ExpGovAvg'))) );
        lStageData.add( new StatusDurationWrapper(checkValue(oReq.Status_Governance_to_Contracting__c), 'Governance', checkValue((decimal)lAggr[0].get('GovContAvg'))) );
        lStageData.add( new StatusDurationWrapper(checkValue(oReq.Status_Contracting_to_Launch__c), 'Contracting', checkValue((decimal)lAggr[0].get('ContLaunAvg'))) );
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
    *********************************************/
    public class StatusDurationWrapper {
        public String StatusValue {get; set;}
        public Decimal Duration {get; set;}
        public Decimal AvgValue {get; set;}

        StatusDurationWrapper(Decimal Duration , String StatusValue, Decimal AvgValue) {
            this.Duration = Duration;
            this.StatusValue = StatusValue;
            this.AvgValue = AvgValue;
        }
    }
}