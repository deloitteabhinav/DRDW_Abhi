/****************************************************************************************************************************************** 
 * Class Name   : ChecklistItem_TriggerHandler 
 * Description  : Class to trim and Copy the Checklist Data Length to 255
 * Created By   : Deloitte Consulting
 * 
 *****************************************************************************************************************************************/
Public with sharing class ChecklistItem_TriggerHandler {


    /* 
     * @Method Name                    :  CopyChecklist
     * @Description                    :  Method to Trim the Checklist to 255 Characters
     * @Return Type                    :  void
     * @Parameters                     :  lChecklists
     */

    public static void CopyChecklist(List < Checklist_Item__c> lChecklists) {
        for (Checklist_Item__c oChecklists: lChecklists) {
            String sChecklistInstruction = oChecklists.Instructions__c;
            String sChecklistText;
            if(sChecklistInstruction <> null) {
            sChecklistText = sChecklistInstruction.stripHtmlTags();
            }
            if (sChecklistText <> null && sChecklistText.length() > 255) {
                sChecklistText = sChecklistText.substring(0, 255 - 3);
                sChecklistText  = sChecklistText + '...';
            }
            oChecklists.Instructions_TF__c = sChecklistText;
            oChecklists.Process_TF__c = oChecklists.Process__c;
            
        }
    }
}