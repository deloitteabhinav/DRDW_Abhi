global class TRAK_Test_ExecutionTriggerClass {
    
    /*
     * Creates custom Test Execution history records, as we can't do history tracking on Rich Text
     * and Long Text Area fields.
     */
    public static void createNewTestExecutionHistoryRecord(Map<Id,TRAK_Test__c> mapTestExecution) {
        List<TRAK_Test_Execution_History__c> lstTestExecHistoryRecords = new List<TRAK_Test_Execution_History__c>();
        try{
            for (TRAK_Test__c tempTestExec : mapTestExecution.values()) {
                TRAK_Test_Execution_History__c newTestExecHistoryRecord = new TRAK_Test_Execution_History__c();
                newTestExecHistoryRecord.Test_Execution__c = tempTestExec.Id;
                newTestExecHistoryRecord.Approver__c = tempTestExec.Approver__c;
                newTestExecHistoryRecord.Approval_Date__c = tempTestExec.Approval_Date__c;
                newTestExecHistoryRecord.Approval_Status__c = tempTestExec.Approval_Status__c;
                newTestExecHistoryRecord.Overall_Test_Comments__c = tempTestExec.Overall_Test_Comments__c;
                newTestExecHistoryRecord.Test_Outcome__c = tempTestExec.Test_Outcome__c;
                lstTestExecHistoryRecords.add(newTestExecHistoryRecord);
            }
            
            if (!lstTestExecHistoryRecords.isEmpty()) {
              insert lstTestExecHistoryRecords;
            }
        }catch(DMLException ex){System.Debug('>>> Error in createNewTestExecutionHistoryRecord method of TRAK_Test_ExecutionTriggerClass class.' + '>>> Error is :: ' + ex.getmessage());}
    }
    
    
    /*
     * Stamps the approval date on the Test Execution History records
     */
    public static void updateApprovalDate(Map<Id,TRAK_Test__c> mapApproval) {
        try{
            System.Debug('>>> Inside the method');
            //Get the latest Test Execution History records to stamp the approval date    
            //Assign Approval date from approved Test Execution record to the Test Execution History record
             
            //get all related history records
            List<TRAK_Test_Execution_History__c> lstTestExecHistoryApprovalRecords = [SELECT Id, Approval_Date__c, CreatedDate, Test_Execution__c
                                                                            FROM TRAK_Test_Execution_History__c 
                                                                            WHERE Test_Execution__c IN :mapApproval.keySet() 
                                                                            ORDER BY Test_Execution__c, CreatedDate ASC];
            
            System.Debug('>>> Query executed');
            //get the latest history for each Test Execution Record
            Map<Id, TRAK_Test_Execution_History__c> latestTestExecHistories = new Map<Id, TRAK_Test_Execution_History__c>();
            for (TRAK_Test_Execution_History__c historyRecord : lstTestExecHistoryApprovalRecords) {
                latestTestExecHistories.put(historyRecord.Test_Execution__c, historyRecord);
            }
            
            //set the new datestamp
            for (TRAK_Test_Execution_History__c historyRecord : latestTestExecHistories.values()) {
                if(mapApproval.get(historyRecord.Test_Execution__c) != null && mapApproval.get(historyRecord.Test_Execution__c).Approval_Status__c == 'Approved'){
                    historyRecord.Approval_Date__c = System.Now();
                    historyRecord.Approval_Status__c = 'Approved';
                }
                else if(mapApproval.get(historyRecord.Test_Execution__c) != null && ((mapApproval.get(historyRecord.Test_Execution__c).Approval_Status__c == 'Rejected') || (mapApproval.get(historyRecord.Test_Execution__c).Approval_Status__c == 'Open'))){
                    historyRecord.Approval_Date__c = null;
                    historyRecord.Approval_Status__c = mapApproval.values().Approval_Status__c;
                }
            }
            if (!latestTestExecHistories.isEmpty()) {
                update latestTestExecHistories.values();
            }
        }catch(DMLException ex){System.Debug('>>> Error in updateApprovalDate method of TRAK_Test_ExecutionTriggerClass class.' + '>>> Error is :: ' + ex.getmessage());}
         
    }
    
    
    /*
     * Updates the number of Completed Test Executions on the related Sprint record
     */
    public static void updateCompletedExecutionCountOnSprint(Map<Id,TRAK_Test__c> mapTestExecution, Set<Id> sprintIDs) {
        List<TRAK_Sprint__c> sprintRecordsToBeUpdated = new List<TRAK_Sprint__c>();
        try{
            for(TRAK_Sprint__c tempSprint : [SELECT Id, Complete_Test_Executions__c, (SELECT Id, Status__c FROM TRAK_Test_Executions__r) FROM TRAK_Sprint__c WHERE Id IN :sprintIDs]) {
                Integer countOfCompleteExecutions = 0;
                for(TRAK_Test__c tempExec : tempSprint.TRAK_Test_Executions__r){
                    if(tempExec.Status__c == 'Complete'){
                        countOfCompleteExecutions += 1;
                    }
                }
                tempSprint.Complete_Test_Executions__c = countOfCompleteExecutions;
                sprintRecordsToBeUpdated.add(tempSprint);
            }
            
            if (!sprintRecordsToBeUpdated.isEmpty()) {
              update sprintRecordsToBeUpdated;
            }
        }catch(DMLException ex){System.Debug('>>> Error in updateCompletedExecutionCountOnSprint method of TRAK_Test_ExecutionTriggerClass class.' + '>>> Error is :: ' + ex.getmessage());}
    }
    
    
    /*
     * Stamps the current date/time on the Test Execution record
     */
    webservice static string updateTestExecutionDate(Id testID){
        try{
            TRAK_Test__c testExec = [SELECT Id, Test_Execution_Date__c FROM TRAK_Test__c WHERE Id = :testID LIMIT 1];
            testExec.Test_Execution_Date__c = System.Now();
            UPDATE testExec;
            return 'success';
        }
        catch(Exception ex){
            System.Debug('>>> Error in updateTestExecutionDate method of TRAK_Test_ExecutionTriggerClass class.');
            System.Debug('>>> Error is :: ' + ex.getMessage());
            return 'failure';
        }    
    }
       public static void updateSubmitterInfo(Map<Id,TRAK_Test__c> TriggerOldMap, Map<Id,TRAK_Test__c> TriggerNewMap){
            for(Id testExecutionId : TriggerNewMap.keySet()){
          if ((triggerOldMap.get(testExecutionId).Approval_Status__c != 'Pending Approval' && triggerNewMap.get(testExecutionId).Approval_Status__c == 'Pending Approval')) {
              triggerNewMap.get(testExecutionId).Submitter__c = UserInfo.getUserId();
          }
          }
      

}

}