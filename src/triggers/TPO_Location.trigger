/*****************************************************************************************
    Name           : TPO_Location 
    Description    : trigger for TPO Location
    Modification Log : 
---------------------------------------------------------------------------
 Developer              Date            Description     
---------------------------------------------------------------------------
  Aryakaran Gupta        2/10/2016          Created
---------------------------------------------------------------------------
History Log:

******************************************************************************************/
trigger TPO_Location on TPO_Location__c (before update,before insert) {
  
  if (Trigger.isBefore) {
        If(Trigger.isInsert) {
            //Calling the trigger method
            TPOLocation_TriggerHandler.CopyCapabiliities(Trigger.New);
        }
        If(Trigger.IsUpdate) {
            //Calling the trigger method
            TPOLocation_TriggerHandler.CopyCapabiliities(Trigger.New);
        }
  }
}