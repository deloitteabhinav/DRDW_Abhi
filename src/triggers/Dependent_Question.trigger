/*****************************************************************************************
    Name           : Dependent_Question 
    Description    : This is the trigger on Dependent_Question__c object to update "Has Dependent?" field on Question record 
    Modification Log : 
---------------------------------------------------------------------------
Developer                     Date                Description     
---------------------------------------------------------------------------
Deloitte Consulting       13th July 2014          Created
---------------------------------------------------------------------------
History Log:

******************************************************************************************/
trigger Dependent_Question on Dependent_Question__c (after insert,after delete,after update) {

    if(Trigger.isAfter){
        If(Trigger.isInsert){       
            Dependent_Question_TriggerHandler.updateQuestionRecord(trigger.new);          
        }
        If(Trigger.isDelete){           
            Dependent_Question_TriggerHandler.updateQuestionRecord(trigger.old);              
        } 
        If(Trigger.isUpdate){           
            Dependent_Question_TriggerHandler.updateQuestionRecord(trigger.new);              
        }        
    }
}