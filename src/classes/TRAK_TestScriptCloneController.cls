public class TRAK_TestScriptCloneController {

 
    List<TRAK_Test_Template_Steps__c> stepList =new List<TRAK_Test_Template_Steps__c>();
    List<TRAK_Test_Template_Steps__c> stepClonedList =new List<TRAK_Test_Template_Steps__c>();
    //added an instance varaible for the standard controller
    private ApexPages.StandardController controller {get; set;}
     // add the instance for the variables being passed by id on the url
    private TRAK_Test_Templates__c testScriptObj {get;set;}
    // set the id of the record that is created -- ONLY USED BY THE TEST CLASS
    public ID newRecordId {get;set;}
    public String query,whereClause;
    // initialize the controller
    public TRAK_TestScriptCloneController(ApexPages.StandardController controller) {

        //initialize the stanrdard controller
        this.controller = controller;
        // load the current record
        testScriptObj = (TRAK_Test_Templates__c)controller.getRecord();

    }

    // method called from the VF's action attribute to clone the testScriptObj
    public PageReference cloneWithItems() {
         if(TRAK_Utils.checkEditAccess(UserInfo.getUserId(), testScriptObj.id)){
             // setup the save point for rollback
             Savepoint  sp = Database.setSavepoint();
             TRAK_Test_Templates__c newtestScriptObj;
             TRAK_Test_Template_Steps__c newQues;
             // GLBL_Form_Template_Answer_Option__c newAns;
             TRAK_Test_Template_Steps__c q;
             try {
    
                   
                  whereClause=' id =\''+String.escapeSingleQuotes(testScriptObj.id)+'\'';
                  query= TRAK_Utils.getCreatableFieldsSOQL('TRAK_Test_Templates__c', whereClause);
                 
                 
                 system.debug('***'+query);
                 testScriptObj=database.query(query);   
               
                 newtestScriptObj = testScriptObj.clone(false,true);
                 newtestScriptObj.Status__c='Not Started';
                 newtestScriptObj.Approval_Status__c='Open';
                 newtestScriptObj.Locked_For_editing__c = false;
                 insert newtestScriptObj;
                 
                 newRecordId=newtestScriptObj.id;
                 
                // ApexPages.currentPage().getParameters().put('newtestScriptObj',newtestScriptObj.id);
                 whereClause=' Test_Script__c =\''+String.escapeSingleQuotes(testScriptObj.id)+'\'';
                 query= TRAK_Utils.getCreatableFieldsSOQL('TRAK_Test_Template_Steps__c', whereClause);
                 
                 
                  
                 stepList=database.query(query); 
                 for(TRAK_Test_Template_Steps__c stepObj:stepList){
                     
                     newQues=stepObj.clone(true,false);
                   
                     newQues.id=null;
                     system.debug(newQues);
                     newQues.Test_Script__c=newtestScriptObj.id;
                    stepClonedList.add(newQues);
                     system.debug(newQues);
    
                 
                 }
                 insert stepClonedList;
              
             } catch (Exception e){
                 // roll everything back in case of error
                Database.rollback(sp);
                ApexPages.addMessages(e);
                return null;
             }
            
            return new PageReference('/'+newtestScriptObj.id);
         }
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.TRAK_TestScripClone_Error));
         return null;
    }

}