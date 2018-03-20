public class TRAK_DesignTriggerClass { 
  
    /*
     * Creates custom Design history, as we can't do history tracking on rich text fields.
     */
    public static void createNewDesignHistoryRecord(Map<Id,TRAK_Design__c> mapDesign) {
    
        List<TRAK_Design_History__c> lstDesignHistoryRecords = new List<TRAK_Design_History__c>();
        TRAK_Design_History__c newDesignHistoryRecord = new TRAK_Design_History__c();
        for (Id DesignId : mapDesign.keySet()) {
          newDesignHistoryRecord.Design__c = mapDesign.get(DesignId).Id;
          newDesignHistoryRecord.Design_Overview__c = mapDesign.get(DesignId).Overview__c;
          newDesignHistoryRecord.Fields__c = mapDesign.get(DesignId).Fields__c;
          newDesignHistoryRecord.Data_Model__c = mapDesign.get(DesignId).Data_Model__c;
          newDesignHistoryRecord.Objects__c = mapDesign.get(DesignId).Objects__c;
          newDesignHistoryRecord.Apex_Classes__c = mapDesign.get(DesignId).Apex_Classes__c;
          newDesignHistoryRecord.Apex_Trigger__c = mapDesign.get(DesignId).Apex_Trigger__c;
          newDesignHistoryRecord.Approver__c = mapDesign.get(DesignId).TRAK_Approver__c;
          newDesignHistoryRecord.Approval_Date__c = mapDesign.get(DesignId).TRAK_Approval_Date__c;
          newDesignHistoryRecord.Other_Components__c = mapDesign.get(DesignId).Other_Components__c;
          lstDesignHistoryRecords.add(newDesignHistoryRecord);
        }   
    
        if (!lstDesignHistoryRecords.isEmpty()) {
          insert lstDesignHistoryRecords;
        }
    }
  
    /*
     * Stamps the approval date on the Design history records
     */
    public static void updateApprovalDate(Map<Id,TRAK_Design__c> mapApproval, DateTime approvalDate) {
     
        //get the latest Design History records to stamp the approval date    
        //Assign Approval date from approved design record to the design history record
         
        // get all related history records
        List<TRAK_Design_History__c> lstDesignHistoryApprovalRecords = [SELECT Id, Approval_Date__c, CreatedDate, Design__c
                                                                        FROM TRAK_Design_History__c 
                                                                        WHERE Design__c IN :mapApproval.keySet() 
                                                                        ORDER BY Design__c, CreatedDate ASC];
        
        // get the latest history for each design
        Map<Id, TRAK_Design_History__c> latestDesignHistories = new Map<Id, TRAK_Design_History__c>();
        for (TRAK_Design_History__c historyRecord : lstDesignHistoryApprovalRecords) {
            latestDesignHistories.put(historyRecord.Design__c, historyRecord);
        }
        
        // set the new datestamp
        for (TRAK_Design_History__c historyRecord : latestDesignHistories.values()) {
            historyRecord.Approval_Date__c = approvalDate;
        }
    
        update latestDesignHistories.values();
    }
    
    public static void setApprovalStatusToOpen(List < TRAK_Design__c> lDesign, Map < Id, TRAK_Design__c> mDesignOld) {
        for (TRAK_Design__c oDesign : lDesign) { // I_Want_To__c, So_that__c
            if (((oDesign.Apex_Classes__c != mDesignOld.get(oDesign.Id).Apex_Classes__c) ||
                (oDesign.Apex_Trigger__c != mDesignOld.get(oDesign.Id).Apex_Trigger__c)  ||
                (oDesign.TRAK_Approver__c!= mDesignOld.get(oDesign.Id).TRAK_Approver__c) ||
                (oDesign.Complexity__c!= mDesignOld.get(oDesign.Id).Complexity__c) ||
                (oDesign.Data_Model__c!= mDesignOld.get(oDesign.Id).Data_Model__c) ||
                (oDesign.Fields__c!= mDesignOld.get(oDesign.Id).Fields__c) ||
                (oDesign.Objects__c!= mDesignOld.get(oDesign.Id).Objects__c) ||
                (oDesign.Other_Components__c!= mDesignOld.get(oDesign.Id).Other_Components__c) ||
                (oDesign.Overview__c!= mDesignOld.get(oDesign.Id).Overview__c) ||
                (oDesign.Page_Layouts__c!= mDesignOld.get(oDesign.Id).Page_Layouts__c)  ||
                (oDesign.TRAK_Rejection_Reason__c!= mDesignOld.get(oDesign.Id).TRAK_Rejection_Reason__c) ||
                (oDesign.Status__c!= mDesignOld.get(oDesign.Id).Status__c) ||
                (oDesign.Visualforce_Pages__c!= mDesignOld.get(oDesign.Id).Visualforce_Pages__c)) && (oDesign.Approval_Status__c == 'Approved')) {
                oDesign.Approval_Status__c = 'Open';
                oDesign.TRAK_Approval_Date__c = null;
                try {
                    
                } catch (Exception excep) {
                    TF_ErrorLogUtility.createErrorLog(excep, new TF_ErrorLogWrapper('TRAK_DesignTriggerClass', 'setApprovalStatusToOpen', 'TRAK_DesignTriggerClass - setApprovalStatusToOpen', '1'));
                }
            }
        }
    }
  
}