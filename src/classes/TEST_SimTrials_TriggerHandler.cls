/****************************************************************************************************************************************** 
 * Class Name   : Test_SimTrials_TriggerHandler
 * Description  : Test Class to Test Trigger Handler on Simulation Trials Object
 * Created By   : Deloitte Consulting
 * 
 *****************************************************************************************************************************************/
@
isTest (SeeAllData = false)
public with sharing class TEST_SimTrials_TriggerHandler {

    /* 
     * @Method Name                    :  TestSimuTrialsTriggerHandler
     * @Description                    :  Method to Test Trigger Handler on Simulation Trials Object
     * @Return Type                    :  void
     * @Parameters                     :  None
     */
    static testMethod void TestSimuTrialsTriggerHandler() {
/*
        User u = DataFactory1.getTestingUser();
        DataFactory1.givePermissions(u.id, 'User');

        System.runAs(u) {

            //Inserting Simulation
            List < Simulation__c > lSimulations = DataFactory1.returnSimulations(1);
            insert lSimulations;
            System.assertNotEquals(lSimulations.size(), 0);

            //Inserting Trials
            List < Trial__c > lTrials = DataFactory1.returnTrials(3);
            insert lTrials;
            System.assertNotEquals(lTrials.size(), 0);

            Test.startTest();

            //Inserting Simulation Trials
            List < Simulation_Trial__c > lSimTrials = DataFactory1.returnSimulationTrials(lSimulations, lTrials);
            insert lSimTrials;
            System.assertNotEquals(lSimTrials.size(), 0);

            List < Simulation_Trial__c > lSimTrialstoDelete = [Select Id, Simulation__c, Trial__c from Simulation_Trial__c];
            Delete lSimTrialstoDelete[0];

            Test.stopTest();

        } */
    }

}