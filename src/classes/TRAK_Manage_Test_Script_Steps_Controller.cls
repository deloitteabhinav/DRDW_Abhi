public with sharing class TRAK_Manage_Test_Script_Steps_Controller {
    public final Id testScriptId = System.currentPageReference().getParameters().get('testScriptId');
    
    public boolean displayMsg {get;set;}
    
    private Id testScriptIdLocal = testScriptId;
    
    public list <TRAK_Test_Template_Steps__c> testScriptSteps {
        get{
            if (testScriptSteps == null) {
                testScriptSteps = [SELECT
                                    Id,
                                    Name,
                                    Action__c,
                                    Expected_Result__c,
                                    Test_Script__c,
                                    Test_Script_Step_Number__c,
                                    Tips__c
                    
                                    FROM TRAK_Test_Template_Steps__c
                                    WHERE Test_Script__c = : testScriptId ORDER BY Test_Script_Step_Number__c,Name ASC];
            }
            return testScriptSteps;
        }
        set;
    }
    
    /*** public Constructor of the controller ***/
    public TRAK_Manage_Test_Script_Steps_Controller(ApexPages.StandardController stdController) {
        displayMsg = false;
    }
    
    public PageReference save() {
        try {
            //Reset the boolean flag everytime Save is clicked
            displayMsg = false;
            
            Integer maxNumber = testScriptSteps.size();
            for(TRAK_Test_Template_Steps__c testStep : testScriptSteps){
                if(testStep.Test_Script_Step_number__c == null || testStep.Test_Script_Step_number__c == 0){
                    displayMsg = true;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The \'Test Script Step Number\' cannot be blank or zero [0]');
                    ApexPages.addMessage(myMsg);
                    break;
                }
                else if(testStep.Test_Script_Step_number__c > maxNumber){
                    displayMsg = true;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The \'Test Script Step Number\' cannot be greater than: ' + maxNumber);
                    ApexPages.addMessage(myMsg);
                    break;
                }
                else if(testStep.Test_Script_Step_number__c < 0){
                    displayMsg = true;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The \'Test Script Step Number\' cannot be a negative number.');
                    ApexPages.addMessage(myMsg);
                    break;
                }
                else{
                    for(TRAK_Test_Template_Steps__c testStepCompare : testScriptSteps){
                        if(testStep.Id != testStepCompare.Id
                           && testStep.Test_Script_Step_number__c == testStepCompare.Test_Script_Step_number__c){
                            displayMsg = true;
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You cannot add a duplicate \'Test Script Step Number\'.');
                            ApexPages.addMessage(myMsg);
                            break;
                        }
                    }
                }
            }
            if(!displayMsg){
                update testScriptSteps;
                pagereference pr = new pagereference('/' + testScriptIdLocal);
                pr.setRedirect(true);
                return pr;
            }
            else{
                return null;
            }
        }catch(Exception ex){ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()); ApexPages.addMessage(myMsg); return null;}
    }
    
    public PageReference cancel() {
            pagereference pr = new pagereference('/' + testScriptId);
            return pr;
    }
}