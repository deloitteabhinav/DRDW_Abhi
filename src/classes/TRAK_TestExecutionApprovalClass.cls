/*************************************************************************\
    @ Author        : Neelam Dalwani
    @ Date          : 14-August-2014
    @ Test Class    : 
    @ Description   : This class is used in the visualforce page TRAK_TestExecutionApprovalClass for approval
                      or rejection of Test Execution
****************************************************************************/
public with sharing class TRAK_TestExecutionApprovalClass  {
 
 
    //variable declaration
    private final TRAK_Test__c templateObj;
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
        Method : TRAK_TestExecutionApprovalClass
        Input Parameters : N/A as it is a constructor
        Description : Constructor of the class usses to get the Test Execution record.    
       ********************************************************************************************************************/

    public TRAK_TestExecutionApprovalClass(ApexPages.StandardController controller) {

        if (!Test.isRunningTest()) {
            //Adding these fields to avoid additional SOQL query.
            controller.addFields(new List < String > {
                'Approval_Status__c','Approver__c','Approval_Date__c'
            });
        }

        redirect = false;
        currentTime = datetime.now();
        this.templateObj = (TRAK_Test__c) controller.getRecord();
        System.debug('tempalte'+templateObj);
    }

    public boolean getcheckRecallButton() {
    
        if (templateObj.Approval_Status__c != 'Pending Approval') 
            return false;
            
           else 
               return true;    
    }
    /*********************************************************************************************************************
     Method : getcheckApproveRejectButton
     Input Parameters : N/A
     Description : Returns the boolean variable which determines if the Approve/Reject button should appear on 
                   Test Execution detail page.    
    ********************************************************************************************************************/

    public boolean getcheckApproveRejectButton() {

        //This set will conatin the user id of all the users who need to approve/reject the User Story
        set < Id > approverSet = new set < Id > ();
        system.debug('temp'+templateObj);
        if (templateObj.Approval_Status__c != 'Pending Approval') {
            return false;
        } else {
            
                if(templateObj.Approver__c!=null)
                    approverSet.add(templateObj.Approver__c);
            }

            //Checking if the logged in User is one of the approvers
            if (approverSet.size() > 0) {
                return approverSet.contains(UserInfo.getUserId());
            }

            // If the Approver information is not updated return false
            else {
                return false;
            }
        }
    

    /*********************************************************************************************************************
     Method : redirectToApprovalPage
     Input Parameters : N/A
     Description : PageReference method which redirects the user to Approval Page.    
    ********************************************************************************************************************/

    public pageReference redirectToApprovalPage() {
        redirectUrl = '/apex/TRAK_TestExecutionApproval?Id=' + templateObj.Id;
        redirect = true;
        return null;
    }
    
    public pageReference recallApprovalRequest() {
    
       
        templateObj.Approval_Status__c='Open';
        try {
            update templateObj;
            
        }
        Catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
        
        //Redirecting the User to the Test Script Record
      /*  String recordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/'+templateObj.Id;
        PageReference uSPage = new PageReference(recordURL);
        System.debug('pageurl'+uSPage);
        return uSPage;*/
        redirectUrl = '/' + templateObj.Id;
        redirect = true;
        return null;
    }

    /*********************************************************************************************************************
      Method : rejectUserStory
      Input Parameters : N/A
      Description : PageReference method which is called when the user clicks the Reject button. 
     ********************************************************************************************************************/

    public pageReference rejectUserStory() {
        
        TRAK_Test_Execution_History__c testTemplateHistory=[select Approval_Comments__c from TRAK_Test_Execution_History__c WHERE Test_Execution__c=:templateObj.Id ORDER By LastModifiedDate DESC LIMIT 1];
        
        testTemplateHistory.Approval_Comments__c=comments;
        
     
        templateObj.Approval_Status__c = 'Rejected';
        //templateObj.Approval_Date__c=System.now();
       

        try {
            update templateObj;
            update testTemplateHistory;
        }
        Catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }

        //Redirecting the User to the Test Execution Record
        PageReference uSPage = new PageReference('/' + templateObj.Id);
        uSPage.setRedirect(true);
        return uSPage;
    }

    /*********************************************************************************************************************
     Method : approveUserStory
     Input Parameters : N/A
     Description : PageReference method which is called when the user clicks the Approve button. 
    ********************************************************************************************************************/

    public pageReference approveUserStory() {

    
        TRAK_Test_Execution_History__c testTemplateHistory=[select Approval_Comments__c from TRAK_Test_Execution_History__c WHERE Test_Execution__c=:templateObj.Id ORDER By LastModifiedDate DESC LIMIT 1];
        
        testTemplateHistory.Approval_Comments__c=comments;
        
                templateObj.Approval_Status__c = 'Approved';
                templateObj.Approval_Date__c=System.now();
            

        try {
            update testTemplateHistory;
            update templateObj;
           }
        Catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }

        //Redirecting the User to the User Story Record
        PageReference uSPage = new PageReference('/' + templateObj.Id);
        uSPage.setRedirect(true);
        return uSPage;
    }


}