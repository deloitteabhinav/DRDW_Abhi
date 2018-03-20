/*
*@ Class Name                                                    : FillSurveyController
*@ Description                                                   : Controller class for saving the survey after it is entered 
*@ CreatedBy                                                     : Naomi Thammadi
*@ CreatedOn                                                     : 11/17/2015

*/

public without sharing class FillSurveyController{
    //class variables
    private Feedback__c oFeedback;
    public Feedback_Providers__c oFeedbackProvider;
    //String to show supplier name and id for link
    public String sSupplierName{get;set;}
    public String sSupplierId{get;set;}
    //List of Reviews
    public List<Review__c> lReviews{get;set;}
    //Page messages toggle
    public boolean bIsShowMessage{get;set;}
    public boolean bIsSubmitted{get;set;}
    
    //constructor that gets page parameters and sets the Feedback Provider
    public FillSurveyController(ApexPages.StandardController stdController){
        bIsShowMessage=false;
        bIsSubmitted=false;
        oFeedback=[select id,Supplier_Account__c, 
                  (select id,Name,Feedback_Id__c,Feedback_Provider__c,Status__c,Supplier_Name__c from SMI_Feedback_Providers__r)
                  from Feedback__c
                  where id=:stdController.getRecord().Id LIMIT 1];
        //get the intended feedback provider
        for(Feedback_Providers__c oFBP:oFeedback.SMI_Feedback_Providers__r){
            if(oFBP.Feedback_Provider__c==UserInfo.getUserId())
            oFeedbackProvider=oFBP;
        }
        //if query returns null then the user does not have access to the survey
        if(oFeedbackProvider==null){
            bIsShowMessage=true;
            bIsSubmitted=true;//this has been made to true only for rendering purposes
            Apexpages.addmessage(new Apexpages.Message(ApexPages.Severity.Error,'You do not have the permission to access this Feedback'));
            return;
        }
        sSupplierName=oFeedbackProvider.Supplier_Name__c ;
        sSupplierId=oFeedback.Supplier_Account__c;
        
        //get the reviews
        lReviews=[select id,Answer__c,Contact__c,Contact__r.Name,Question_Text__c,Feedback_Provider__c from Review__c
                        where Feedback_Provider__c=:oFeedbackProvider.Id 
                        ORDER BY Contact__c ASC];
            
        //check if the status of the form is submitted
        if(oFeedbackProvider.Status__c==Constants.sFeedbackStatusSubmitted){
            bIsShowMessage=true;
            bIsSubmitted=true;
            Apexpages.addmessage(new Apexpages.Message(ApexPages.Severity.INFO,'You have already submitted this Feedback. Below are your responses. Thank you!'));
            return;
        }
        else{
            bIsShowMessage=false;
        }
    }
    
    /* 
    * @Method Name                    :  submitSurvey
    * @Description                    :  Method that submits the survey and saves the answers
    * @Return Type                    :  page reference
    * @Param                          :  
    */
    public pageReference submitSurvey(){
        if(lReviews!=null && lReviews.size()>0){
            try{
                //CHECK IF ANY OF THE RESPONSES ARE BLANK, THEN THROW AN ERROR - This scenario is covered in any non UI scenario  
                for(Review__c oRev:lReviews){
                    if(oRev.Answer__c==NULL || oRev.Answer__c==''){
                        //return control back to page
                        return null;
                    }
                }
                //update survey responses and status of the feedback provider
                update lReviews;
                oFeedbackProvider.Status__c=Constants.sFeedbackStatusSubmitted;
                update oFeedbackProvider;
                bIsShowMessage=true;
                bIsSubmitted=true;
                Apexpages.addmessage(new Apexpages.Message(ApexPages.Severity.INFO,'Feedback Submitted successfully'));
            }
            catch(Exception e){
                ErrorLogger(e);
                bIsShowMessage=true;
                Apexpages.addmessage(new Apexpages.Message(ApexPages.Severity.Error,'There was a problem while submitting your Feedback. Please contact your Administrator.'));
            }
        }
        return null;
    }
    /* 
    * @Method Name                    :  saveSurvey
    * @Description                    :  Method that saves the survey for the feedback provider to login later to submit it
    * @Return Type                    :  page reference
    * @Param                          :  
    */
    public pageReference saveSurvey(){
        if(lReviews!=null && lReviews.size()>0){
            try{
                //update responses and status of feedback provider
                update lReviews;
                oFeedbackProvider.Status__c=Constants.sFeedbackStatusSaved;
                update oFeedbackProvider;
                bIsShowMessage=true;
                Apexpages.addmessage(new Apexpages.Message(ApexPages.Severity.INFO,'Feedback Saved. You can click on the Feedback link later to Submit it.'));
            }
            catch(Exception e){
                ErrorLogger(e);
                bIsShowMessage=true;
                Apexpages.addmessage(new Apexpages.Message(ApexPages.Severity.Error,'There was a problem while saving your Feedback. Please contact your Administrator.'));
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