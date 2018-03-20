trigger TPTO_afterInsert_Update on TPTO_PTO_Request__c (before update, after insert) {
    
        TPTO_afterTrigger_Processing.intersectingPTO(trigger.new);
   
}