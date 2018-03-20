/******************************************************************************************************************************************
* Class Name   : TRAK_SubmitForApproval
* Description  : This global class is called from the custom 'Recall Approval Request' button on Test Script and Test Execution pages. 
* Created By   : Deloitte Consulting
*****************************************************************************************************************************************/
global without sharing class TRAK_SubmitForApproval {
       /*
* @Method Name                    :  SendEmailMethod
* @Description                    :  Used to update the User Story status to 'Pending Approval'. 
* @Return Type                    :  void
*/
    webservice static void SendEmailMethod(Id localId) {
        TRAK_User_Story__c TRAKUserStoryObj = [select Submitter__c, approval_status__c from TRAK_User_Story__c where id = : localid];
        TRAKUserStoryObj.approval_status__c = 'Pending Approval';
        TRAKUserStoryObj.Submitter__c = UserInfo.getUserId();
        try {
            update TRAKUserStoryObj;
        } catch (Exception excep) { TF_ErrorLogUtility.createErrorLog(excep, new TF_ErrorLogWrapper('TRAK_SubmitForApproval', 'sendEmailMethod','TRAK_SubmitForApproval - sendEmailMethod','1')); }
        System.debug('Submitter' + TRAKUserStoryObj.Submitter__c);
    }
 /*   webservice static void SendEmailMethodTestScript(Id localId)
    {
        TRAK_Test_Templates__c TRAKTestTemplateObj=[Select Submitter__c,Approval_Status__c from TRAK_Test_Templates__c Where id=:localId];
        TRAKTestTemplateObj.Approval_Status__c='Pending Approval';
        TRAKTestTemplateObj.Submitter__c=UserInfo.getUserId();
        try{
            update TRAKTestTemplateObj;
        }
        catch(Exception e){
             System.debug('Exception ' + e);
        }
    }*/
   /* webservice static void SendEmailMethodTestExcecution(Id localId)
    {
        /*
        TRAK_Test__c TRAKTestTemplateObj=[Select Approval_Status__c from TRAK_Test__c Where id=:localId];
        TRAKTestTemplateObj.Approval_Status__c='Pending Approval';
        TRAKTestTemplateObj.Submitter__c=UserInfo.getUserId();
        try{
            update TRAKTestTemplateObj;
        }
        catch(Exception e){
             System.debug('Exception ' + e);
        }*/
        // ;create the new approval request to submit
     /*   Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setObjectId(localId);
        // submit the approval request for processing
        Approval.ProcessResult result = Approval.process(req);
    }
    */
         /*
* @Method Name                    :  recallApprovalRequest
* @Description                    :  Used to recall an approval request
* @Return Type                    :  record ID
*/
    webservice static void recallApprovalRequest(Id approvalRecordId) {
        List<ProcessInstanceWorkitem> piwi = [SELECT Id, ProcessInstanceId, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: approvalRecordId];
        if(piwi .size() > 0){
            Approval.ProcessWorkitemRequest PWR = new Approval.ProcessWorkitemRequest();
            PWR.setComments('Submitter Recalling');
            PWR.setAction('Removed');
            PWR.setWorkitemId(piwi[0].Id);
            try {
            Approval.ProcessResult result =  Approval.process(PWR);
                } catch (Exception excep) { TF_ErrorLogUtility.createErrorLog(excep, new TF_ErrorLogWrapper('TRAK_SubmitForApproval', 'recallApprovalRequest','TRAK_SubmitForApproval - recallApprovalRequest','1')); }
        }
    }
}