/*****************************************************************************************
    Name           : AccountTrigger
    Description    : trigger for Account
    Modification Log : 
---------------------------------------------------------------------------
 Developer              Date            Description     
---------------------------------------------------------------------------
  Aryakaran Gupta        3/30/2017          Created
---------------------------------------------------------------------------
History Log:

******************************************************************************************/
trigger AccountTrigger on Account(after update) {
 if (Trigger.isAfter) {
        If(Trigger.isUpdate){
            //Calling the trigger method
            AccountTriggerHandler.AssignTasks(Trigger.new); 
        }
  }
  
}