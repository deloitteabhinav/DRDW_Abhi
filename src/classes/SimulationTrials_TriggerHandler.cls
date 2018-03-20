/****************************************************************************************************************************************** 
 * Class Name   : SimulationTrials_TriggerHandler 
 * Description  : Trigger Handler Class for Simulation Trials Object
 * Created By   : Deloitte Consulting
 * 
 *****************************************************************************************************************************************/
Public with sharing class SimulationTrials_TriggerHandler {

    /* 
     * @Method Name                    :  CopyTrials
     * @Description                    :  Method to get trial records and populate them by comma seperated values in trail alias field on Simulation record. Works on Insert/Update
     * @Return Type                    :  void
     * @Parameters                     :  lSimTrials
     */

/*    Public Static void CopyTrials(List < Simulation_Trial__c > lSimTrials) {

        Set < Id > sSimulations = new Set < Id > ();
        List < Simulation__c > lSimulationsToUpdate = new List < Simulation__c > ();

        for (Simulation_Trial__c oSimTrial: lSimTrials) {
            sSimulations.add(oSimTrial.Simulation__c);
        }

        //Querying Junction Object
        List < Simulation_Trial__c > lSimTrialsforSimulation = new List < Simulation_Trial__c > ();
        lSimTrialsforSimulation = [Select Id, Trial__r.Name, Trial__r.Compound__c, Simulation__c from Simulation_Trial__c where Simulation__c IN: sSimulations];

        //Inserting values on Simulation by Comma Seperated values
        for (Simulation__c oSimulation: [Select Id, Name, Trial_Alias__c from Simulation__c where ID IN: sSimulations]) {
            string sTrialAlias = '';
            string sCompound = '';
            for (Simulation_Trial__c oSimTrial: lSimTrialsforSimulation) {
                If(oSimulation.Id == oSimTrial.Simulation__c) {
                    sTrialAlias += oSimTrial.Trial__r.Name + ', ';
                    If(!sCompound.contains(oSimTrial.Trial__r.Compound__c + ', ') && oSimTrial.Trial__r.Compound__c != NULL) {
                        sCompound += oSimTrial.Trial__r.Compound__c + ', ';
                    }
                }
            }
            sTrialAlias = sTrialAlias.trim().removeEnd(',');
            sCompound = sCompound.trim().removeEnd(',');
            oSimulation.Trial_Alias__c = sTrialAlias;
            oSimulation.Compound__c = sCompound;
            lSimulationsToUpdate.add(oSimulation);
        }

        Update lSimulationsToUpdate;

    } */


    /* 
     * @Method Name                    :  RemoveTrials
     * @Description                    :  Method to get trial records and populate them by comma seperated values in trail alias field on Simulation record. Works on Delete.
     * @Return Type                    :  void
     * @Parameters                     :  lSimTrials
     */

/*
    Public Static void RemoveTrials(List < Simulation_Trial__c > lSimTrials) {

        Set < Id > sSimulations = new Set < Id > ();
        Set < Id > sExcludedSimulationTrial = new Set < Id > ();
        List < Simulation__c > lSimulationsToUpdate = new List < Simulation__c > ();

        for (Simulation_Trial__c oSimTrial: lSimTrials) {
            sSimulations.add(oSimTrial.Simulation__c);
            sExcludedSimulationTrial.add(oSimTrial.id);
        }

        //Querying Junction Object
        List < Simulation_Trial__c > lSimTrialsforSimulation = new List < Simulation_Trial__c > ();
        lSimTrialsforSimulation = [Select Id, Trial__r.Name, Trial__r.Compound__c, Simulation__c from Simulation_Trial__c where Simulation__c IN: sSimulations AND Id NOT IN: sExcludedSimulationTrial];

        //Inserting values on Simulation by Comma Seperated values
        for (Simulation__c oSimulation: [Select Id, Name, Trial_Alias__c from Simulation__c where ID IN: sSimulations]) {
            string sTrialAlias = '';
            string sCompound = '';
            for (Simulation_Trial__c oSimTrial: lSimTrialsforSimulation) {
                If(oSimulation.Id == oSimTrial.Simulation__c) {
                    sTrialAlias += oSimTrial.Trial__r.Name + ', ';
                    If(!sCompound.contains(oSimTrial.Trial__r.Compound__c + ', ') && oSimTrial.Trial__r.Compound__c != NULL) {
                        sCompound += oSimTrial.Trial__r.Compound__c + ', ';
                    }
                }
            }
            sTrialAlias = sTrialAlias.trim().removeEnd(',');
            sCompound = sCompound.trim().removeEnd(',');
            oSimulation.Trial_Alias__c = sTrialAlias;
            oSimulation.Compound__c = sCompound;
            lSimulationsToUpdate.add(oSimulation);
        }

        Update lSimulationsToUpdate;

    } */
}