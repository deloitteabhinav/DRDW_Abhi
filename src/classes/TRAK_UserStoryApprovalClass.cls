/***********************************************************************\
    @ Author        : Nitish Kumar
    @ Date          : 31-July-2014
    @ Test Class    : 
    @ Description   : This class is used in the visualforce page TRAK_UserStoryApproval for approval
                      or rejection of User Story
***************************************************************************/
public with sharing class TRAK_UserStoryApprovalClass {

    //variable declaration
    private final TRAK_User_Story__c userStory;
    public String approvalPageURL{
    get{return redirectToApprovalPage();}
        set;
    }
    public string redirectUrl {
     get;
    set;     
    }

    public String comments {
        get;
        set;
    }
    public Boolean redirect {
        get;
        set;
    }

    public datetime currentTime {
        get;
        set;
    }

    /*********************************************************************************************************************
        Method : TRAK_UserStoryApprovalClass
        Input Parameters : N/A as it is a constructor
        Description : Constructor of the class usses to get the User Story record.    
       ********************************************************************************************************************/

    public TRAK_UserStoryApprovalClass(ApexPages.StandardController controller) {

        if (!Test.isRunningTest()) {
            //Adding these fields to avoid additional SOQL query.
            controller.addFields(new List < String > {
                'GXP__c', 'Critical__c', 'System_Owner__c', 'System_Custodian__c', 'TRAK_System_Custodian_Approved__c','TRAK_Business_Quality_Approved__c',
                'Compliance_Owner__c', 'Computer_Systems_Quality__c', 'Approval_Status__c', 'TRAK_System_Owner_Approved__c','TRAK_Computer_Systems_Quality_Approved__c'
            });
        }

        redirect = false;
        currentTime = datetime.now();
        this.userStory = (TRAK_User_Story__c) controller.getRecord();
    }

    /*********************************************************************************************************************
     Method : getcheckApproveRejectButton
     Input Parameters : N/A
     Description : Returns the boolean variable which determines if the Approve/Reject button should appear on 
                   User Story detail page.    
    ********************************************************************************************************************/

    public boolean getcheckApproveRejectButton() { 

        //This set will conatin the user id of all the users who need to approve/reject the User Story
        set < Id > approverSet = new set < Id > ();

        
        //Only ever show the button if the User Story is Pending Approval
        if (userStory.Approval_Status__c != 'Pending Approval') {
            return false;
        } else {
             Id targetObjectId = getLatestApprovalSnapshot().Id;
             if(targetObjectId != null){
                 List<ProcessInstance> approvalProcesses = [ SELECT Id, (SELECT Id,Actorid 
                                                                          FROM StepsAndWorkitems
                                                                          WHERE StepStatus != 'Reassigned' 
                                                                          ORDER BY StepStatus DESC, SystemModStamp DESC)
                                                                FROM ProcessInstance 
                                                                WHERE TargetObjectID  = :targetObjectId and Status = 'Pending'
                                                                ORDER BY SystemModStamp DESC
                                                                LIMIT 1];
            
                system.debug('approvalProcesses ' + approvalProcesses);
                if(approvalProcesses != null && approvalProcesses.size()>0){
                    for(ProcessInstanceHistory step : approvalProcesses[0].StepsAndWorkitems){
                        approverSet.add(step.Actorid);
                    }
                }
                system.debug('approverSet ' + approverSet);
                //Checking if the logged in User is one of the approvers
                if (approverSet.size() > 0) {
                    return approverSet.contains(UserInfo.getUserId());
                }
                else{
                     return false;   
                }
             }
             else {
                return false;
            }
        }
    }
    
     /**
     * Gets the latest snapshot record for this user story 
     */
    private TRAK_User_Story_Approval_History__c getLatestApprovalSnapshot () {
        
        List<TRAK_User_Story_Approval_History__c> snapshots = [SELECT Id 
                                                               FROM TRAK_User_Story_Approval_History__c 
                                                               WHERE User_Story__c = :this.userStory.Id 
                                                               ORDER BY CreatedDate DESC 
                                                               LIMIT 1];
        
        if (snapshots.isEmpty()) {
            return new TRAK_User_Story_Approval_History__c();
        }
        else {
            return snapshots[0];
        }
    }

    /*********************************************************************************************************************
     Method : redirectToApprovalPage
     Input Parameters : N/A
     Description : PageReference method which redirects the user to Approval Page.    
    ********************************************************************************************************************/

    public String redirectToApprovalPage() {
    
        Id USER_ID=UserInfo.getUserId();
        List<TRAK_User_Story_Approval_History__c> lstUserStoryApprovalHistory = [Select Id FROM TRAK_User_Story_Approval_History__c 
                                                                            WHERE User_Story__c=:userStory.id AND 
                                                                                Approval_Status__c='Pending Approval' order by LastModifiedDate Desc];
        if(lstUserStoryApprovalHistory.size()>0){
            Id USER_STORY_APPROVAL_ID=lstUserStoryApprovalHistory[0].id;
            System.debug(USER_STORY_APPROVAL_ID+''+USER_ID);
            List<ProcessInstanceWorkitem> lstProcessInstWorkItem = [SELECT Id FROM ProcessInstanceWorkitem 
                                                                        WHERE ProcessInstance.TargetObjectId = :USER_STORY_APPROVAL_ID AND 
                                                                            ActorId = : USER_ID AND
                                                                            ProcessInstance.Status='Pending'];
            if(lstProcessInstWorkItem.size()>0){
                Id APPROVAL_ID=lstProcessInstWorkItem[0].id;
                redirectUrl = '/p/process/ProcessInstanceWorkitemWizardStageManager?id='+APPROVAL_ID ;
                redirect = true;
                return redirectUrl;
            }
        }
        return null;
    }                                                                            
    

    /*********************************************************************************************************************
      Method : rejectUserStory
      Input Parameters : N/A
      Description : PageReference method which is called when the user clicks the Reject button. The Overall Approvad
                    Status of the User Story is changed to Rejected.
     ********************************************************************************************************************/

    public pageReference rejectUserStory() {

        //Checking the role of logged in User
        TRAK_User_Story_Approval_History__c userStoryHistoryObj = [select Business_Quality_Comments__c,Approval_Status__c,Computer_Systems_Quality_Approved__c,Business_Quality_Approved__c,System_Custodian_Approved__c,System_Owner_Approved__c, Computer_Systems_Quality_Comments__c, System_Custodian_Comments__c, System_Owner_Comments__c, User_Story__c From TRAK_User_Story_Approval_History__c WHERE User_Story__c = : userStory.Id ORDER By LastModifiedDate DESC LIMIT 1];
        if (userStory.System_Owner__c == UserInfo.getUserId()) {
            userStoryHistoryObj.System_Owner_Comments__c = comments;
            userStoryHistoryObj.System_Owner_Approved__c = false ;
        }
        if (userStory.System_Custodian__c == UserInfo.getUserId()) {
            userStoryHistoryObj.System_Custodian_Comments__c = comments;
            userStoryHistoryObj.System_Custodian_Approved__c = false ;
        }
        if (userStory.Compliance_Owner__c == UserInfo.getUserId()) {
            userStoryHistoryObj.Business_Quality_Comments__c = comments;
            userStoryHistoryObj.Business_Quality_Approved__c = false ;
        }
        if (userStory.Computer_Systems_Quality__c == UserInfo.getUserId()) {
            userStoryHistoryObj.Computer_Systems_Quality_Comments__c = comments;
            userStoryHistoryObj.Computer_Systems_Quality_Approved__c = false ;
        }

        //Updating the Overall Approval Status of the User Story
        userStory.Approval_Status__c = 'Rejected';
        userStory.TRAK_System_Owner_Approved__c = false;
        userStory.TRAK_System_Custodian_Approved__c = false;
        userStory.TRAK_Business_Quality_Approved__c = false;
        userStory.TRAK_Computer_Systems_Quality_Approved__c = false;
        userStory.TRAK_System_Owner_Approval_Date__c = null;
        userStory.TRAK_System_Custodian_Approval_Date__c = null;
        userStory.TRAK_Business_Quality_Approval_Date__c = null;
        userStory.TRAK_Computer_System_Qty_Approval_Date__c = null;
        
        userStoryHistoryObj.Approval_Status__c = 'Rejected';

        // 

        try {
            update userStory;
            update userStoryHistoryObj;
        }
        Catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }

        //Redirecting the User to the User Story Record
        PageReference uSPage = new PageReference('/' + userStory.Id);
        uSPage.setRedirect(true);
        return uSPage;
    }

    /*********************************************************************************************************************
     Method : approveUserStory
     Input Parameters : N/A
     Description : PageReference method which is called when the user clicks the Approve button. The Overall Approvad
                   Status of the User Story is changed to Approved if all the approvers have approved the user story
    ********************************************************************************************************************/

    public pageReference approveUserStory() {

        //Checking the role of the logged in User and updating the approval flag and date field
        TRAK_User_Story_Approval_History__c userStoryHistoryObj = [select Business_Quality_Comments__c,Approval_Status__c,Business_Quality_Approved__c,Computer_Systems_Quality_Approved__c,System_Custodian_Approved__c,System_Owner_Approved__c, Computer_Systems_Quality_Comments__c, System_Custodian_Comments__c, System_Owner_Comments__c, Business_Quality_Approval_Date__c, Computer_Systems_Qty_Approval_Date__c, System_Custodian_Approval_Date__c, System_Owner_Approval_Date__c, User_Story__c From TRAK_User_Story_Approval_History__c WHERE User_Story__c = : userStory.Id ORDER By LastModifiedDate DESC LIMIT 1];

        if (userStory.System_Owner__c == UserInfo.getUserId()) {
            userStory.TRAK_System_Owner_Approved__c = true;
            userStory.TRAK_System_Owner_Approval_Date__c = currentTime;
            userStoryHistoryObj.System_Owner_Approved__c = true ;
            userStoryHistoryObj.System_Owner_Comments__c = comments;
            userStoryHistoryObj.System_Owner_Approval_Date__c = currentTime;
        }
        if (userStory.System_Custodian__c == UserInfo.getUserId()) {
            userStory.TRAK_System_Custodian_Approved__c = true;
            userStory.TRAK_System_Custodian_Approval_Date__c = currentTime;
            userStoryHistoryObj.System_Custodian_Approved__c = true ;
            userStoryHistoryObj.System_Custodian_Comments__c = comments;
            userStoryHistoryObj.System_Custodian_Approval_Date__c = currentTime;
        }
        if (userStory.Compliance_Owner__c == UserInfo.getUserId()) {
            userStory.TRAK_Business_Quality_Approved__c = true;
            userStory.TRAK_Business_Quality_Approval_Date__c = currentTime;
            userStoryHistoryObj.Business_Quality_Approved__c = true ;
            userStoryHistoryObj.Business_Quality_Comments__c = comments;
            userStoryHistoryObj.Business_Quality_Approval_Date__c = currentTime;
        }
        if (userStory.Computer_Systems_Quality__c == UserInfo.getUserId()) {
            userStory.TRAK_Computer_Systems_Quality_Approved__c = true;
            userStory.TRAK_Computer_System_Qty_Approval_Date__c = currentTime;
            userStoryHistoryObj.Computer_Systems_Quality_Approved__c = true ;
            userStoryHistoryObj.Computer_Systems_Quality_Comments__c = comments;
            userStoryHistoryObj.Computer_Systems_Qty_Approval_Date__c = currentTime;
        }

        //Change the status of the User Story to Approved if System Custodian and System Owner have approved
        // the user story and GXP is No and User Story is not Critical
        if (userStory.GXP__c == 'No' && userStory.Critical__c == 'No') {
            if (userStory.TRAK_System_Owner_Approved__c == true && userStory.TRAK_System_Custodian_Approved__c == true) {
                userStory.Approval_Status__c = 'Approved';
                userStoryHistoryObj.Approval_Status__c = 'Approved';
            }
        }
       
        //Change the status of the User Story to Approved if all the approvers have approved the user story
        else if (userStory.GXP__c != 'No' || userStory.Critical__c != 'No') {
           System.debug('$$$$$$$$$$$$' + userStory);
            if (userStory.TRAK_System_Owner_Approved__c == true && userStory.TRAK_System_Custodian_Approved__c == true && userStory.TRAK_Business_Quality_Approved__c == true && userStory.TRAK_Computer_Systems_Quality_Approved__c == true) {
                userStory.Approval_Status__c = 'Approved';
                userStoryHistoryObj.Approval_Status__c = 'Approved';
            }
        }
       

        try {
            update userStoryHistoryObj;
            update userStory;
           }
        Catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }

        //Redirecting the User to the User Story Record
        PageReference uSPage = new PageReference('/' + userStory.Id);
        uSPage.setRedirect(true);
        return uSPage;
    }


}