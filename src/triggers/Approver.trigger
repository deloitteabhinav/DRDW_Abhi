/*****************************************************************************************
    Name           : Approver
    Description    : This trigger locks/unlocks the BP & Study record based on Approver record.
    Modification Log : 
---------------------------------------------------------------------------
 Developer              Date            Description     
---------------------------------------------------------------------------
 Waseem Sabeel        29/09/2015          Created
---------------------------------------------------------------------------
*******************************************************************************************/

trigger Approver on Approver__c (before update) {
     // Approver_TriggerHandler.UpdateItemstoLocked(trigger.new);        
}