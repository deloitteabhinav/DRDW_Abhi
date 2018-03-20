/****************************************************************************************************************************************** 
 * Class Name   : Test_SimulationReport
 * Description  : Test Class for SimulationReport Class
 * Created By   : Deloitte Consulting
 * 
 *****************************************************************************************************************************************/
@
isTest (SeeAllData = false)
public with sharing class TEST_SimulationReport {

    /* 
     * @Method Name                    :  TestSimulationReport
     * @Description                    :  Method to Test Generation of report for Simulations Records
     * @Return Type                    :  void
     * @Parameters                     :  None
     */
    static testMethod void TestSimulationReport() {

        User u = DataFactory1.getTestingUser();
        DataFactory1.givePermissions(u.id, 'User');

        System.runAs(u) {

            //Inserting Simulation
            List < Simulation__c > lSimulations = DataFactory1.returnSimulations(1);
            insert lSimulations;
            System.assertNotEquals(lSimulations.size(), 0);

            //Inserting Boards
            List < Boards__c > lBoards = DataFactory1.returnBoards(1,lSimulations);
            insert lBoards;
            System.assertNotEquals(lBoards.size(), 0);
            
            //Inserting Simulation Notes
            List < Simulation_Note__c > lNotes = DataFactory1.returnSimulationNotes(5,lBoards);
            insert lNotes;
            System.assertNotEquals(lNotes.size(), 0);

            Test.startTest();
            
            PageReference pageRef = Page.SimulationReport;
            Test.setCurrentPage(pageRef);

            ApexPages.StandardController controller = new ApexPages.StandardController(lSimulations[0]);
            SimulationReport  oController = New SimulationReport(controller);
            oController.ReportRedirect();

            Test.stopTest();

        }
    }

}