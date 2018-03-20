/****************************************************************************************************************************************** 
* Class Name   : runTestScriptExtension
* Description  : functionality for tests
* Created By   : Deloitte Consulting
* 
************** Modification Log****************************
 
 @Modified By : Nitish Kumar
 @Date :        July 2014
 Description :  US-35861 (Ensure all Test Executions are fully completed) 
 
 @Modified By : Himanshu Babaria
 @Date :        August 2014
 Description :  US-35860 (Provide a reference of latest attachment of Test Execution Step) 
*****************************************************************************************************************************************/

public with sharing class TRAK_runTestScriptExtension {

    public final Id Test = System.currentPageReference().getParameters().get('Id');

    private final TRAK_test__c tst;
    
    private list <TRAK_Test_Bug_Link__c> BugLink = new list <TRAK_Test_Bug_Link__c> ();
    
    public Boolean isnewBugs {
        get;
        set;
    }
    
    public Boolean stepsComplete {
        get;
        set;
    }

    Public list <TRAK_Bug__c> Bugs {
        get{
            if (Bugs == null) {
                Bugs = new list < TRAK_Bug__c > ();
            }
            return Bugs;

        }
        set;
    }
        
    private Map <string,id> stepName = new Map <string,id> ();
    private Set<Id> testScriptStepIds = new Set<Id>();
    private List<Attachment> tempAttachList = new List<Attachment>();
    public Map<Id,Boolean> testScriptAttachmentsMap {get;set;}
    public list < TRAK_test_steps__c > TestSp {
        get {
            if (testSp == null) {
                TestSp = [SELECT
                    Id,
                    Name,
                    TRAK_Action__c,
                    TRAK_Expected_Results__c,
                    TRAK_Tips__c,
                    Outcome__c,
                    Comments__c,
                    Template_Step__c,Test_Execution_Step_Number__c,createdDate
                    
                    FROM TRAK_test_steps__c
                    WHERE test__c = : Test ORDER BY Test_Execution_Step_Number__c,Name ASC
                ];
                
                testScriptAttachmentsMap = new Map<Id,Boolean>();
                for (TRAK_test_steps__c t: TestSp) {
                    stepName.put(t.name, t.id);
                    testScriptStepIds.add(t.Template_Step__c);
                    testScriptAttachmentsMap.put(t.Template_Step__c,FALSE);
                }
                
                if(testScriptStepIds != null && testScriptStepIds.size()>0){
                    tempAttachList = [SELECT Id, ParentId 
                                    FROM Attachment 
                                    WHERE ParentId IN :testScriptStepIds];
                                       
                    for (Attachment a: tempAttachList) {                        
                        testScriptAttachmentsMap.put(a.ParentId, TRUE);                            
                    }
                }
            }
            return TestSp;
        }
        set;
    }
    /*
    public Map<Id,Id> testStepToAttachmentMap {
        get {
                testStepToAttachmentMap = new Map<Id,Id>();
                tempAttachList = [SELECT Id, ParentId 
                                FROM Attachment 
                                WHERE ParentId IN 
                                (SELECT Id FROM TRAK_Test_Template_Steps__c WHERE Test_Script__c = : testScriptId)
                                ORDER BY LastModifiedDate
                ];
                
                for (Attachment a: tempAttachList) {
                    testStepToAttachmentMap.put(a.ParentId, a.Id);
                }
            
                return testStepToAttachmentMap;
        }
        set;
    }
    */
    
    /*** The Constructor of the class ***/
    public TRAK_runTestScriptExtension(ApexPages.StandardController stdController) {
        this.tst = (TRAK_test__c) stdController.getRecord();
    }
    
    public PageReference addBug() {
        id testId = System.currentPageReference().getParameters().get('Id');

        TRAK_Test__c test = [Select Id, User_Story__c, User_Story__r.Allocated_Sprint__c from TRAK_Test__c where Id = : testId][0];
        string testStepName = System.currentPageReference().getParameters().get('testName');
        isnewBugs = true;
        Bugs.add(new TRAK_Bug__c(script_number__c = testStepName, status__c = 'Raised', User_Story__c = test.User_Story__c, Test_Phase__c = tst.Test_Phase__c, Test_Execution__c = testId,
             sprint2__c = test.User_Story__r.Allocated_Sprint__c, Logged_By__c = UserInfo.getUserId(), Log_Time__c = system.now()));

        system.debug(Bugs);

        return null;
    }


    Public PageReference AttachFile() {

        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        System.debug('Base URL: ' + sfdcBaseURL );       
        string testStepName = System.currentPageReference().getParameters().get('testName');
        id testStepId = System.currentPageReference().getParameters().get('testId');
        id testId = System.currentPageReference().getParameters().get('Id');
        try {
            update TestSp;
        }

        //Error Handling
        Catch(Exception ex) {ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage())); }

        PageReference ref = new PageReference(sfdcBaseURL+'/p/attach/NoteAttach?pid=' + testStepId + '&parentname=' + testStepName + '&retURL='+sfdcBaseURL+'/apex/runTestScript?id=' + testId);
        ref.setRedirect(true);
        return ref;


    }

    Public PageReference Save() {

        // Boolean value to check if everything is populated or not    
        stepsComplete = true;
      
        try {
            update tst; 
            update TestSp;
        }
        //Error Handling
        Catch(Exception ex) {ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage())); }

        //Checking if all the steps have been completed if the test passed or passed with minor issues
        if ((tst.Test_Outcome__c == Label.TRAK_Passed || tst.Test_Outcome__c == Label.TRAK_Passed_Minor_Issues)){
           for (TRAK_Test_Steps__c micTestStep: TestSp) {
            if (micTestStep.Outcome__c == null) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.TRAK_Save_Test_Execution);
                ApexPages.addMessage(myMsg);
                stepsComplete = false;
                break ;
            }
           }
          //checking the test comment if the test has pased or passed with minor issues 
          if(tst.Overall_Test_Comments__c == null || tst.Overall_Test_Comments__c == ''){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.TRAK_Save_Test_Outcome);
            ApexPages.addMessage(myMsg);
            stepsComplete = false;
           }
          }
       
        if (!bugs.isEmpty()) {
            insert Bugs;
            id testst;
            for (TRAK_Bug__c b: Bugs) {
            testst = stepName.get(b.script_number__c);
                BugLink.add(new TRAK_Test_Bug_Link__c(Bug__c = b.id, Test_Script__c = tst.id, Test_Step_Result__c = testst));

            }
            insert BugLink;
        }

        //Allow the page reference if all the test steps have been completed
        if (stepsComplete) {

            PageReference savenclose = new PageReference('/' + Test);
            return savenclose;
        } else {
            return null;
        }

    }

    /**
     * @author :- Nitish Kumar
     * @date  :-  July -2014
     * @description :- Public Pagereference method which saves the individual test steps
     **/
    public pageReference SaveStep() {

        // Getting the id of the selected test step
        Id testId = System.currentPageReference().getParameters().get('testId');
        map < Id, TRAK_Test_Steps__c > mapTestSteps = new map < Id, TRAK_Test_Steps__c > ();

        // Storing the Test step object id as key and value as the object
        for (TRAK_Test_Steps__c micTestStep: TestSp) {
            mapTestSteps.put(micTestStep.Id, micTestStep);
        }

        //Dml update after checking if the map contains the key
        if (mapTestSteps.containsKey(testId)) {

            try {
                update mapTestSteps.get(testId);
            }

            //Error Handling
           Catch(Exception ex) {ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage())); }
        }
        return null;
    }
    
    /**
     * @author :- Himanshu Babaria
     * @date  :-  August -2014
     * @description :- Public Pagereference method which redirects user to latest Attachment of the current test step
     **/
    public pageReference viewAttachment() {
        id testStepId = System.currentPageReference().getParameters().get('testId1');
        if(testStepId != null){
            PageReference viewAttmt = new PageReference('/ui/content/ViewAllNotesPage?id=' + testStepId + '&retURL=%2F' + testStepId);
            return viewAttmt;
        }
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'There are no Attachments present on the associated Test Script Steps.');
            ApexPages.addMessage(myMsg);
            return null;
        }
    }

}