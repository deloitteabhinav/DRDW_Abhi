/****************************************************************************************************************************************** 
 * Class Name   : SimulationReport 
 * Description  : Class for Generating Reports for Simulation Record
 * Created By   : Deloitte Consulting
 * 
 *****************************************************************************************************************************************/
Public with sharing class SimulationReport {

    Public String RecordID;

    //Loading the Constructor
    Public SimulationReport(ApexPages.StandardController controller) {
        Simulation__c oSimulation = (Simulation__c) controller.getRecord();
        RecordID = oSimulation.Id;
        RecordID = RecordID.substring(0, 15); 
    }

     /* 
     * @Method Name                    :  ReportRedirect
     * @Description                    :  Method to Redirect the Page to the Report
     * @Return Type                    :  PageReference
     * @Parameters                     :  None
     */

    Public PageReference ReportRedirect() {
    
        //Querying the Report
        List<Report> lReport = new List<Report>();
        lReport = [SELECT DeveloperName,Id from Report where DeveloperName = 'Simulation_with_Simulation_Note' limit 1];
        Id ReportID;
        If(lReport.size() > 0){
        ReportID = lReport[0].id;
        }
        PageReference ReportURL = new PageReference('/' + ReportID  + '?pv0=' + RecordID);
        return ReportURL ;
    }

}