/*************************************************************************\
    @ Author        : Nitish Kumar
    @ Date          : 22-Aug-2014
    @ Test Class    : 
    @ Description   : The helper class for TRAK_AttachmentTrigger.
****************************************************************************/
public with sharing class TRAK_AttachmentTriggerUtility {

    /*********************************************************************************************************************
          Method : checkAttachmentonTSStep
          Input Parameters : Set of Id of Test Script Step and map containing the parent id and attachment
          Description : This method will be used to stop the deletion of attachment if the test script has been approved    
         ********************************************************************************************************************/

    public static void checkAttachmentonTSStep(Set < Id > setTestScriptStep, map < Id, Attachment > mapTestScriptStep) {

        //getting the Test Script Step records
        list < TRAK_Test_Template_Steps__c > lstTestScriptStep = [Select id, Test_Script__r.Approval_Status__c from TRAK_Test_Template_Steps__c where Id IN: setTestScriptStep];

        for (TRAK_Test_Template_Steps__c testScriptStep: lstTestScriptStep) {
            if ((testScriptStep.Test_Script__r.Approval_Status__c == 'Approved' || testScriptStep.Test_Script__r.Approval_Status__c == 'Pending Approval') && mapTestScriptStep.containsKey(testScriptStep.id)) {
                //adding the error message if the Test Script has been approved
                mapTestScriptStep.get(testScriptStep.id).addError(Label.TRAK_Error_On_Test_Script);
            }
        }
    }

    /*********************************************************************************************************************
          Method : checkAttachmentonTExecution
          Input Parameters : Set of Id of Test Execution and map containing the parent id and attachment
          Description : This method will be used to stop the deletion of attachment if the test script has been approved    
        ********************************************************************************************************************/

    public static void checkAttachmentonTExecution(Set < Id > setTestExecution, map < Id, Attachment > mapTestExecution) {

        //getting the Test Execution records
        list < TRAK_Test__c > lstTestExecution = [Select id, Approval_Status__c from TRAK_Test__c where Id IN: setTestExecution];

        for (TRAK_Test__c testExecution: lstTestExecution) {
            if ((testExecution.Approval_Status__c == 'Approved' || testExecution.Approval_Status__c == 'Pending Approval' ) && mapTestExecution.containsKey(testExecution.id)) {
                //adding the error message if the Test Script has been approved
                mapTestExecution.get(testExecution.id).addError(Label.TRAK_Error_On_Test_Execution);
            }
        }
    }

    /*********************************************************************************************************************
       Method : checkAttachmentonTExecutionStep
       Input Parameters : Set of Id of Test Execution Step and map containing the parent id and attachment
       Description : This method will be used to stop the deletion of attachment if the test script has been approved    
     ********************************************************************************************************************/

    public static void checkAttachmentonTExecutionStep(Set < Id > setTestExecutionStep, map < Id, Attachment > mapTestExecutionStep) {

        //getting the Test Execution Step records
        list < TRAK_Test_Steps__c > lstTestExecutionStep = [Select id, Test__r.Approval_Status__c from TRAK_Test_Steps__c where Id IN: setTestExecutionStep];

        for (TRAK_Test_Steps__c testExecutionStep: lstTestExecutionStep) {
            if ((testExecutionStep.Test__r.Approval_Status__c == 'Approved' || testExecutionStep.Test__r.Approval_Status__c == 'Pending Approval')  && mapTestExecutionStep.containsKey(testExecutionStep.id)) {
                //adding the error message if the Test Script has been approved
                mapTestExecutionStep.get(testExecutionStep.id).addError(Label.TRAK_Error_On_Test_Execution_Step);
            }
        }

    }
    
    public static void onBeforeDelete(List<Attachment> lAttachment) {
         //local variables
    set < Id > setTestScriptStep = new set < Id > ();
    map < Id, Attachment > mapTestScriptStep = new map < Id, Attachment > ();

    set < Id > setTestExecution = new set < Id > ();
    map < Id, Attachment > mapTestExecution = new map < Id, Attachment > ();

    set < Id > setTestExecutionStep = new set < Id > ();
    map < Id, Attachment > mapTestExecutionStep = new map < Id, Attachment > ();

    for (Attachment att: lAttachment) {
        //Check if uploaded attachment is related to Test Script Step Attachment  
        if (att.ParentId.getSobjectType() == TRAK_Test_Template_Steps__c.SobjectType) {
            setTestScriptStep.add(att.ParentId);
            mapTestScriptStep.put(att.ParentId, att);
        }

        //Check if uploaded attachment is related to Test Execution Attachment  
        if (att.ParentId.getSobjectType() == TRAK_Test__c.SobjectType) {
            setTestExecution.add(att.ParentId);
            mapTestExecution.put(att.ParentId, att);
        }

        //Check if uploaded attachment is related to Test Execution Step Attachment  
        if (att.ParentId.getSobjectType() == TRAK_Test_Steps__c.SobjectType) {
            setTestExecutionStep.add(att.ParentId);
            mapTestExecutionStep.put(att.ParentId, att);
        }
    }

    if (Trigger.isBefore) {
        if (Trigger.isDelete) {
            // Call the utility function

            //checking the set size
            if (setTestScriptStep.size() > 0)
                TRAK_AttachmentTriggerUtility.checkAttachmentonTSStep(setTestScriptStep, mapTestScriptStep);

            //checking the set size
            if (setTestExecution.size() > 0)
                TRAK_AttachmentTriggerUtility.checkAttachmentonTExecution(setTestExecution, mapTestExecution);

            //checking the set size
            if (setTestExecutionStep.size() > 0)
                TRAK_AttachmentTriggerUtility.checkAttachmentonTExecutionStep(setTestExecutionStep, mapTestExecutionStep);

        }
    }
    }

public static final String DUPLICATE_NOTE = 'You cannot attach the same Attachment multiple times to the same Record. Please update the Name of the Attachment. ';

    public static void duplicateNameCheck(List<Attachment> lNote) {
       Set<Id> parentIDs = new Set<ID>();
       Map<String,List<Attachment>> mNoteTitleParentIdtoId = new Map<String,List<Attachment>>();
       for(Attachment oNote : lNote) {
           if(String.valueOf(oNote.ParentId.getSObjectType()).startswithIgnoreCase('TRAK_')) {
               parentIDs.add(oNote.ParentId);
               if(mNoteTitleParentIdtoId.containsKey(oNote.Name+','+oNote.ParentId)) {
               List<Attachment> lNoteID = mNoteTitleParentIdtoId.get(oNote.Name+','+oNote.ParentId);
               lNoteID.add(oNote);
               mNoteTitleParentIdtoId.put(oNote.Name+','+oNote.ParentId,lNoteID);
               } else {
               List<Attachment> lNoteID = new List<Attachment>();
               lNoteID.add(oNote);
               mNoteTitleParentIdtoId.put(oNote.Name+','+oNote.ParentId,lNoteID);
               }
           }
       }
        
       if(parentIds.size() > 0) { 
           List<AggregateResult> lDuplicateNotes = [SELECT Count(id) recCount, Name title, ParentId parentId FROM Attachment where ParentID IN :parentIds group by ParentId, Name having count(id) > 1 limit 2000];
           //lNote[0].addError('**'+parentIds);
           if(lDuplicateNotes.size() > 0) {
                 for(AggregateResult ar : lDuplicateNotes) {
                     if(mNoteTitleParentIdtoId.containsKey(ar.get('title')+','+ar.get('parentId'))) {
                     for(Attachment oNote : mNoteTitleParentIdtoId.get(ar.get('title')+','+ar.get('parentId'))) {
                         oNote.Name.addError(DUPLICATE_NOTE);
                     }
                 }    
                 }            
           }
       }
           
    }

}