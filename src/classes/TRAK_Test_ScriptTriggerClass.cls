public class TRAK_Test_ScriptTriggerClass {
 /*
     * Creates custom Test Execution history records, as we can't do history tracking 
     */
    public static void createNewTestScriptHistoryRecord(Map<Id,TRAK_Test_Templates__c> mapTestScript) {
        
        List<TRAK_Test_Template_History__c> lstTestScriptHistoryRecords = new List<TRAK_Test_Template_History__c>();
        
        try{
            
            for (TRAK_Test_Templates__c tempTestScript : mapTestScript.values()) {
            
                TRAK_Test_Template_History__c newTestScriptHistoryRecord = new TRAK_Test_Template_History__c();
                newTestScriptHistoryRecord.Test_Script__c = tempTestScript.Id;
                newTestScriptHistoryRecord.Approver__c = tempTestScript.Approver__c;
                newTestScriptHistoryRecord.Approval_Date__c = tempTestScript.Approval_Date__c;
                newTestScriptHistoryRecord.Approval_Status__c = tempTestScript.Approval_Status__c;
                newTestScriptHistoryRecord.Expected_Result__c = tempTestScript.Expected_Result__c;
                lstTestScriptHistoryRecords.add(newTestScriptHistoryRecord);
            }
            
            if (!lstTestScriptHistoryRecords.isEmpty()) {
              insert lstTestScriptHistoryRecords;
            }
        }catch(DMLException ex){System.Debug('>>> Error in createNewTestScriptHistoryRecord method of TRAK_Test_ScriptTriggerClass class.' + '>>> Error is :: ' + ex.getmessage());}
    }
    
    
    /*
     * Stamps the approval date and approved status on the Test Script History records
     */
    public static void updateApprovalDate(Map<Id,TRAK_Test_Templates__c> mapApproval, DateTime approvalDate) {
        try{
            System.Debug('>>> Inside the method');
            //Get the latest Test Script History records to stamp the approval date    
            //Assign Approval date from approved Test Script record to the Test Script History record
             
            //get all related history records
            List<TRAK_Test_Template_History__c> lstTestScriptHistoryRecords = [SELECT Id, Approval_Date__c, CreatedDate, Test_Script__c
                                                                            FROM TRAK_Test_Template_History__c 
                                                                            WHERE Test_Script__c IN :mapApproval.keySet() 
                                                                            ORDER BY Test_Script__c, CreatedDate ASC];
            
            System.Debug('>>> Query executed');
            //get the latest history for each Test Execution Record
            Map<Id, TRAK_Test_Template_History__c> latestTestScriptHistories = new Map<Id, TRAK_Test_Template_History__c>();
            for (TRAK_Test_Template_History__c historyRecord : lstTestScriptHistoryRecords) {
                latestTestScriptHistories.put(historyRecord.Test_Script__c, historyRecord);
            }
            
            //set the new datestamp
            for (TRAK_Test_Template_History__c historyRecord : latestTestScriptHistories.values()) {
                historyRecord.Approval_Date__c = approvalDate;
                historyRecord.Approval_Status__c = 'Approved';
            }
            if (!latestTestScriptHistories.isEmpty()) {
                update latestTestScriptHistories.values();
            }
        }catch(DMLException ex){System.Debug('>>> Error in updateApprovalDate method of TRAK_Test_ScriptTriggerClass class.' + '>>> Error is :: ' + ex.getmessage());}
        
    }
        
    /*Update Rejection status on History record*/
    public static void updateRejectionStatus(Map<Id,TRAK_Test_Templates__c> mapRejection) {
        try{
            System.Debug('>>> Inside the method');
            //Get the latest Test Script History records to stamp the rejection Status    
            //Assign Rejected status from rejected Test Script record to the Test Script History record
             
            //get all related history records
            List<TRAK_Test_Template_History__c> lstTestScriptHistoryRecords = [SELECT Id, CreatedDate, Test_Script__c
                                                                            FROM TRAK_Test_Template_History__c 
                                                                            WHERE Test_Script__c IN :mapRejection.keySet() 
                                                                            ORDER BY Test_Script__c, CreatedDate ASC];
            
            System.Debug('>>> Query executed');
            //get the latest history for each Test Execution Record
            Map<Id, TRAK_Test_Template_History__c> latestTestScriptHistories = new Map<Id, TRAK_Test_Template_History__c>();
            for (TRAK_Test_Template_History__c historyRecord : lstTestScriptHistoryRecords) {
                latestTestScriptHistories.put(historyRecord.Test_Script__c, historyRecord);
            }
            
            //set the new status
            for (TRAK_Test_Template_History__c historyRecord : latestTestScriptHistories.values()) {
                historyRecord.Approval_Status__c = mapRejection.values().Approval_status__c;
            }
            if (!latestTestScriptHistories.isEmpty()) {
                update latestTestScriptHistories.values();
            }
        }catch(DMLException ex){System.Debug('>>> Error in updateRejectionStatus method of TRAK_Test_ScriptTriggerClass class.' + '>>> Error is :: ' + ex.getmessage());}
    }
    


    public static void updateSubmitterInfo(Map<Id,TRAK_Test_Templates__c> TriggerOldMap, Map<Id,TRAK_Test_Templates__c> TriggerNewMap){
    for(Id testScriptId : TriggerNewMap.keySet()){
          if ((triggerOldMap.get(testScriptId).Approval_Status__c != 'Pending Approval' && triggerNewMap.get(testScriptId).Approval_Status__c == 'Pending Approval')) {
              triggerNewMap.get(testScriptId).Submitter__c = UserInfo.getUserId();
          }
          }
      

}

}