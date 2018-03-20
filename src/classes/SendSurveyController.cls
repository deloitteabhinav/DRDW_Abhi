/*
*@ Class Name                                                    : SendSurveyController
*@ Description                                                   : Controller class for sending out the survey
*@ CreatedBy                                                     : Naomi Thammadi
*@ CreatedOn                                                     : 11/12/2015

*/

public with sharing class SendSurveyController{
    //class variables to save account info
    public final Account oSupplierAccount{get;set;}
    
    //variables for contacts
    public List<Contact> lSelectedSupplierContacts{get;set;}
    
    //variables for users
    public List<User> lSelectedFeedbackProviders{get;set;}
    
    //map to store all check box values
    public map<String, List<wCheckBoxWrapper>> mUserContactCheckboxWrapper{get;set;}
    //3 Strings that will be keys to the map
    private final String sSupplierUser='SupplierUser';
    private final String sUser='User';
    private final String sContact='Contact';
    
    //map to hold page block toggles
    public map<String,boolean> mBoolToggle{get;set;}
    //Error toggle - Need to use this to integrate 3 pages into one page
    public boolean bIsShowMessage{get;set;}
    
    //step count
    public Integer nWizardStepCount{get;set;}
    
    Public Boolean IsAccess{get;set;}
   
    
    //constructor with standard account controller
    public SendSurveyController(ApexPages.StandardController stdController){
        lSelectedSupplierContacts=new List<Contact>();
        this.oSupplierAccount=[select id,Name,SMO_Representative__c,Relationship_Owner__c,
                              Executive_Sponsor__c, (select id,accountId,Name from Contacts) from Account 
                              where Id=:stdController.getRecord().Id LIMIT 1];
        bIsShowMessage=false;
        //put three categories in mUserContactCheckboxWrapper - one for User, one for Contacts and one for SupplierUsers
        //this will store the checkbox options
        mUserContactCheckboxWrapper=new map<String, List<wCheckBoxWrapper>>();
        mUserContactCheckboxWrapper.put(sUser,new List<wCheckBoxWrapper>());
        mUserContactCheckboxWrapper.put(sSupplierUser,new List<wCheckBoxWrapper>());
        mUserContactCheckboxWrapper.put(sContact,new List<wCheckBoxWrapper>());
        
        mBoolToggle=new map<String,boolean>();
        //initialise all toggles to false except step 1
        mBoolToggle.put('Step1',true);
        mBoolToggle.put('Step2',false);
        mBoolToggle.put('Step3',false);
        
        //give step count as 1
        nWizardStepCount=1;
        //Checking if the user has edit access on Accounts
         If([Select AccountId, AccountAccessLevel , UserOrGroupId from AccountShare where AccountId = : stdController.getRecord().Id AND (AccountAccessLevel = 'Edit' OR AccountAccessLevel = 'All') AND UserOrGroupId =: UserInfo.getUserId()].size() > 0 || [SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name =: Constants.sSMINAdminPermissionAPI AND AssigneeId=:UserInfo.getUserId()].size() > 0){
            bIsShowMessage= FALSE;
            IsAccess = TRUE;
            fetchSupplierContacts();
            fetchSupplierUsers(); 
         }
         Else{
            bIsShowMessage= TRUE;
            IsAccess = FALSE;
            Apexpages.addmessage(new Apexpages.Message(ApexPages.Severity.Error,'You need to be a part of Supplier Record to initiate a feedback. Please contact your Administrator.')); 
         }
        
    }
        
    /* 
    * @Method Name                    :  fetchSupplierUsers
    * @Description                    :  Method to fetch users on account and other users with feedback provider permission
    * @Return Type                    :  void
    * @Param                          :  
    */
    
    public void fetchSupplierUsers(){
        wCheckBoxWrapper oCheckboxwrap;
        //set to add only unique users under supplier management section
        Set<User> sUniqueSupplierUsers=new Set<User>();
        
        //get all users that have feedback provider permission set 
        //check if any of the user is present under supplier management details section
        //if yes include that user in mUserContactCheckboxWrapper under SupplierUser
        //otherwise include the user in mUserContactCheckboxWrapper under User
        for(User oUser: [select id,Name, FirstName,LastName,IsActive from User 
                        where Id IN (SELECT AssigneeId FROM PermissionSetAssignment 
                        WHERE PermissionSet.Name =: Constants.sFeedbackProviderPermissionAPI)]){
            if(oUser.Id!=oSupplierAccount.SMO_Representative__c && 
                oUser.Id!=oSupplierAccount.Relationship_Owner__c && 
                oUser.Id!=oSupplierAccount.Executive_Sponsor__c){
                mUserContactCheckboxWrapper.get(sUser).add(new wCheckBoxWrapper(oUser));
            }
            else{
                //check if the user already exists in the set, if yes, skip adding user to the list of feedback providers
                if(! ( sUniqueSupplierUsers.contains(oUser) ) ){
                    mUserContactCheckboxWrapper.get(sSupplierUser).add(new wCheckBoxWrapper(oUser));
                    sUniqueSupplierUsers.add(oUser);
                }
            }
            
        }
    }
    
    /* 
    * @Method Name                    :  fetchSupplierContacts
    * @Description                    :  Method to fetch contacts under the supplier account
    * @Return Type                    :  void
    * @Param                          :  
    */
    
    public void fetchSupplierContacts(){
        //If supplier has no contacts, show an info message
        if(!(oSupplierAccount.Contacts.size()>0)){
            Apexpages.addmessage(new Apexpages.Message(ApexPages.Severity.INFO,'No contacts present for this Supplier'));
            bIsShowMessage=true;
        }
        else{
            for(Contact oContact: oSupplierAccount.Contacts){
                mUserContactCheckboxWrapper.get(sContact).add(new wCheckBoxWrapper(oContact));
            }
        }
    }
    
    /* 
    * @Method Name                    :  closeFeedback
    * @Description                    :  returns to the account record
    * @Return Type                    :  pageReference
    * @Param                          :  
    */
    
    public pagereference closeFeedback(){
        return (new PageReference('/'+oSupplierAccount.Id));
    }
    
    /* 
    * @Method Name                    :  selectContactsStep
    * @Description                    :  Used in the 2nd step - select users - of the feedback wizard to navigate back to the first step - select contacts
    * @Return Type                    :  pageReference
    * @Param                          :  
    */
    
    public pagereference selectContactsStep(){
        mBoolToggle.put('Step1',true);
        mBoolToggle.put('Step2',false);
        mBoolToggle.put('Step3',false);
        nWizardStepCount=1;
        
        if(!(oSupplierAccount.Contacts.size()>0)){
            Apexpages.addmessage(new Apexpages.Message(ApexPages.Severity.INFO,'No contacts present for this Supplier'));
            bIsShowMessage=true;
        }   
        return null;
    }
    
    /* 
    * @Method Name                    :  selectUsersStep
    * @Description                    :  Used in the 1st step - select contacts - of the feedback wizard to navigate to the next step - select users
    * @Return Type                    :  pageReference
    * @Param                          :  
    */
    
    public pagereference selectUsersStep(){ 
        mBoolToggle.put('Step1',false);
        mBoolToggle.put('Step2',true);
        mBoolToggle.put('Step3',false);
        nWizardStepCount=2;
        
        lSelectedSupplierContacts=new List<Contact>();
        if(mUserContactCheckboxWrapper.containsKey(sContact)){
            for(wCheckBoxWrapper oCbw:mUserContactCheckboxWrapper.get(sContact)){
                if(oCbw.bIsChecked){
                    lSelectedSupplierContacts.add((Contact)oCbw.oSObject);
                }
            }
        }  
        
        return null;
    }
    
    /* 
    * @Method Name                    :  confirmationStep
    * @Description                    :  Used in the 2nd step - select users - of the feedback wizard to navigate to the final confirmation page
                                         Also saves the details into a Feedback object
    * @Return Type                    :  pageReference
    * @Param                          :  
    */
    
    public pagereference confirmationStep(){  
        
        lSelectedFeedbackProviders=new List<User>();
        string sSentTo='';
        
        for(wCheckBoxWrapper oCbw:mUserContactCheckboxWrapper.get(sSupplierUser)){
            if(oCbw.bIsChecked){
                lSelectedFeedbackProviders.add((User)oCbw.oSObject);
                sSentTo+=oCbw.oSObject.get('Name')+'; ';
            }
        }
        
        for(wCheckBoxWrapper oCbw:mUserContactCheckboxWrapper.get(sUser)){
            if(oCbw.bIsChecked){
                lSelectedFeedbackProviders.add((User)oCbw.oSObject);
                sSentTo+=oCbw.oSObject.get('Name')+'; ';
            }
        }
         
        
        //give an error message when no users are selected
        if(lSelectedFeedbackProviders==null || lSelectedFeedbackProviders.size()==0){
            Apexpages.addmessage(new Apexpages.Message(ApexPages.Severity.Error,'Please choose at least one Feedback Provider'));
            return null;
        }
        else{
            ApexPages.getMessages().clear();
            return insertFeedBack(sSentTo);
        }
    }
    
    /* 
    * @Method Name                    :  insertFeedBack
    * @Description                    :  Inserts one record of "Feedback", "Feedback provider" and child records of "Reviews"
    * @Return Type                    :  pageReference
    * @Param                          :  
    */
    
    public PageReference insertFeedBack(String sSentTo){ 
        //initialise required lists of questions, feedback providers and reviews
        List<Question__c> lQuestions=new List<Question__c>(); 
        List<Feedback_Providers__c> lFeedbackProviders=new List<Feedback_Providers__c>();
        List<Review__c> lReviews=new List<Review__c>();
        
        Feedback__c oFeedback;
        Feedback_Providers__c oFeedbackProvider;
        Review__c oReview;
        List<Database.SaveResult> lSaveResult=new List<Database.SaveResult>();

        //temporary string variable to store Feedback provider record Id
        String sFeedbackProviderId='';
        
        //fetch for all questions
        lQuestions=[select Id, Question__c, Is_Contact_Specific__c from Question__c ORDER BY Is_Contact_Specific__c ASC];
        system.debug('##########lQuestion'+lQuestions);
        //initiate a feedback for the selected Feedback providers
        //insert a feedback record
        oFeedback=new Feedback__c();
        oFeedback.Supplier_Account__c=oSupplierAccount.Id;
        oFeedback.Sent_to__c=sSentTo;
        try{
            insert oFeedback;
        }
        catch(Exception e){
            ErrorLogger(e);
            return null;
        }
        
        //if feedback is inserted successfully, add feedback providers to it
        if(oFeedback!=null && oFeedback.Id !=null){
            for(User oUser:lSelectedFeedbackProviders){
                oFeedbackProvider=new Feedback_Providers__c();
                oFeedbackProvider.Feedback_Id__c=oFeedback.Id;
                oFeedbackProvider.Feedback_Provider__c=oUser.Id;
                oFeedbackProvider.Status__c=Constants.sFeedbackStatusSent;
                lFeedbackProviders.add(oFeedbackProvider);
                
            }
        }
        //insert feedback providers
        lSaveResult=Database.insert(lFeedbackProviders,false);
        
        //iterate through the result to show which records failed to insert
        for(Integer nCount=0;nCount<lSaveResult.size();nCount++){
            if (!lSaveResult.get(nCount).isSuccess()){
                Apexpages.addmessage(new Apexpages.Message(ApexPages.Severity.Error,'Error Feedback Provider Insert Failed'+lSaveResult.get(nCount)));
            }
            else{
                sFeedbackProviderId=lSaveResult.get(nCount).getId();
                //lInsertedFeedbackProviders.add(sFeedbackProviderId);
                for(Question__c oQuestion:lQuestions){
                    //add contact specific questions
                    if(oQuestion.Is_Contact_Specific__c){
                        if(lSelectedSupplierContacts!=null && lSelectedSupplierContacts.size()>0){
                            for(Contact oContact:lSelectedSupplierContacts){
                                oReview=new Review__c();
                                oReview.Contact__c=oContact.Id;
                                oReview.Question__c=oQuestion.Id;
                                oReview.Feedback_Provider__c=sFeedbackProviderId;
                                lReviews.add(oReview);
                            }
                        }
                    }
                    else{
                        oReview=new Review__c();
                        oReview.Question__c=oQuestion.Id;
                        oReview.Feedback_Provider__c=sFeedbackProviderId;
                        lReviews.add(oReview);
                    }
                }
            }
        }
        //if errors exist, show them on Select Users page
        if(ApexPages.hasMessages(ApexPages.Severity.Error)){
            return null;
        }
        lSaveResult=Database.insert(lReviews,false);
        
        for(Integer nCount=0;nCount<lSaveResult.size();nCount++){
            if(!lSaveResult.get(nCount).isSuccess()){
                Apexpages.addmessage(new Apexpages.Message(ApexPages.Severity.Error,'Failed to insert Review record:'+lSaveResult.get(nCount)));
            }
        }
        //if error messages exist, show them on Select user step 
        if(ApexPages.hasMessages(ApexPages.Severity.Error)){
            nWizardStepCount=2;
            mBoolToggle.put('Step1',false);
            mBoolToggle.put('Step2',true);
            mBoolToggle.put('Step3',false);
        
            return null;
        }
        //else show the success message on confirmation step
        else{
            nWizardStepCount=3;
            Apexpages.addmessage(new Apexpages.Message(ApexPages.Severity.Info,'Feedback Request(s) sent Successfully'));
            mBoolToggle.put('Step1',false);
            mBoolToggle.put('Step2',false);
            mBoolToggle.put('Step3',true);
            return null;
        }
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

    //wrapper class that is used for checkboxes
    public class wCheckBoxWrapper{
        public boolean bIsChecked{get;set;}
        public sObject oSObject{get;set;}
        //constructor
        public wCheckBoxWrapper(sObject sObj){
        bIsChecked=false;
        this.oSObject=sObj;
        }
        
    }
}