/******************************************************************************************************************************************
* Trigger Name   : TRAK_Tester_TriggerHandler
* Description  : Creates Tests for Tester based on template
* Created By   : Deloitte Consulting
*
*****************************************************************************************************************************************/
trigger TRAK_Tester_TriggerHandler on TRAK_Tester__c(after insert) {
    TRAK_createTestsForTester.afterInsert(trigger.new);
}