/*
*@ Class Name                                                    : SendReminderController
*@ Description                                                   : Controller class for sending reminder email to selected feedback providers
*@ CreatedBy                                                     : Naomi Thammadi
*@ CreatedOn                                                     : 07/12/2015

*/

public with sharing class SendReminderController{
    private Feedback__c oFeedback;
    private String sFBID;
    public List<Feedback_Providers__c> lFeedbackProviders;
     //controller that takes standard page controller as parameter
    public SendReminderController(ApexPages.StandardController stdController){
        lFeedbackProviders=new List<Feedback_Providers__c>();
        //retrieve all feedback providers for a particular feedback that do not have the status as "Submitted" and show them on the VF Page
        sFBID=stdController.getRecord().Id;
         if(sFBID!=null && sFBID!=''){
            oFeedback=[select id, (select id,Status__c,Send_Reminder__c from SMI_Feedback_Providers__r) from Feedback__c where id=:sFBID LIMIT 1];
            for(Feedback_Providers__c oFeedProvider:oFeedback.SMI_Feedback_Providers__r){
                if(oFeedProvider.Status__c!=Constants.sFeedbackStatusSubmitted){
                    oFeedProvider.Send_Reminder__c=true;
                    lFeedbackProviders.add(oFeedProvider);
                }
            }
        }  
    }
    
    
    /* 
    * @Method Name                    :  sendReminder
    * @Description                    :  Method to updates the Reminder Sent field on feedback provider that triggers the email alert
    * @Return Type                    :  Page reference
    * @Param                          :  
    */
    public PageReference sendReminder(){
        //if all feedback providers have submitted their response, show a message on the page
        if(([Select OwnerId from Feedback__c where id=:sFBID AND OwnerId =: UserInfo.getUserId() LIMIT 1].size() == 0) && ([SELECT AssigneeId FROM PermissionSetAssignment 
                     WHERE PermissionSet.Name =: Constants.sSMINAdminPermissionAPI AND AssigneeId=:UserInfo.getUserId()].size()==0))
        {
         Apexpages.addmessage(new Apexpages.Message(ApexPages.Severity.Error,'You do not have the privileges to Send Reminders for this Feedback.'));
        }
        else if(!(lFeedbackProviders.size()>0)){
         Apexpages.addmessage(new Apexpages.Message(ApexPages.Severity.INFO,'All Feedback Providers have submitted their feedbacks.'));
        }
        else{
            try{
                update lFeedbackProviders;
                Apexpages.addmessage(new Apexpages.Message(ApexPages.Severity.INFO,'Reminder Sent to Feedback Providers who have not submitted their feedbacks'));
            }
            catch(Exception e){
                ErrorLogger(e);
            }
        }
        return null;
    }
    
    
    /* 
     * @Method Name                    :  ErrorLogger
     * @Description                    :  This methods covers error logging
     * @Return Type                    :  void
     * @Parameters                     :  None 
     */

    Public static void ErrorLogger(Exception e) {
        GLBL_Error_Log__c errLog = new GLBL_Error_Log__c(Error_Datetime__c = DateTime.Now(), Error_Message__c = e.getMessage(), Running_User__c = UserInfo.getUserId(), Stack_Trace__c = e.getStackTraceString());
        insert errlog;
    }
   
}