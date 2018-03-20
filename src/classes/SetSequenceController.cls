/****************************************************************************************************************************************** 
 * Class Name   : SetSequenceController 
 * Description  : Controller for
 * Created By   : Deloitte Consulting
 * 
 *****************************************************************************************************************************************/
Public with Sharing Class SetSequenceController {

    Public List < Checklist_Versionaire__c > lChecklistVersion {
        get;
        set;
    }
    Public Boolean IsError {
        get;
        set;
    }
    Public Id CheckListId;
    Public Map < String, String > mErrors {
        set;
        get;
    }
    Public String SelectedProcess {
        get;
        set;
    }
    Public List < SelectOption > Items {
        get;
        set;
    }
    Public List < Checklist_Versionaire__c > lVersion;
    
    //Constructor
    Public SetSequenceController(ApexPages.StandardController controller) {
        CheckListId = ApexPages.CurrentPage().getParameters().get('id');
        lChecklistVersion = new List<Checklist_Versionaire__c>();
        Items = new List < SelectOption > ();
        mErrors = new Map < String, String > ();
        Items.add(new SelectOption('None', '--None--'));
        Schema.DescribeFieldResult fieldResult = Checklist_Item__c.Process__c.getDescribe();
        List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: ple) {
            Items.add(new SelectOption(p.getValue(), p.getValue()));
        }
    }
    
     /* 
     * @Method Name                    :  SetSequence
     * @Description                    :  Method Queries the Master based on Selected Process
     * @Return Type                    :  PageReference
     * @Parameters                     :  None
     */
    Public PageReference SetSequence() {
        IsError = False;
        lChecklistVersion = [Select Name, Checklist_Item_Id__c, Sequence__c, Checklist_Item_Id__r.Process__c, Checklist_Item_Id__r.Milestone__c, Checklist_Item_Id__r.Instructions__c, Checklist_Item_Id__r.Version_Comments__c from Checklist_Versionaire__c where Checklist_Version_Id__c = : CheckListId AND Checklist_Item_Id__r.Process__c = : SelectedProcess order by Checklist_Item_Id__r.Process__c, Sequence__c];
        return null;
    }

     /* 
     * @Method Name                    :  Save
     * @Description                    :  Method to Save Sequence Values
     * @Return Type                    :  PageReference
     * @Parameters                     :  None
     */
    Public PageReference Save() {
        If(lChecklistVersion.size() == 0 || SelectedProcess == NULL || SelectedProcess == '--None--') {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'No Records were Updated'));
        }
        Try {
            for (Checklist_Versionaire__c oChecklistVersion: lChecklistVersion) {
                mErrors.put(oChecklistVersion.Id, '');
            }
            If(lChecklistVersion.size() != 0) {
                Update lChecklistVersion;
                IsError = FALSE;
                lChecklistVersion = [Select Name, Checklist_Item_Id__c, Sequence__c, Checklist_Item_Id__r.Process__c, Checklist_Item_Id__r.Milestone__c, Checklist_Item_Id__r.Instructions__c, Checklist_Item_Id__r.Version_Comments__c from Checklist_Versionaire__c where Checklist_Version_Id__c = : CheckListId AND Checklist_Item_Id__r.Process__c = : SelectedProcess order by Checklist_Item_Id__r.Process__c, Sequence__c];
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm, 'Sequence Updated'));
            }
        }

        Catch(System.DMLException e) {
            For(Integer i = 0; i < e.getNumdml(); i++) {
                mErrors.put(e.GetDMLId(i), e.GetDMLMessage(i));
            }
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Save Failed.Please Review the Errors'));
            IsError = TRUE;
        }
        return null;
    }
    
     /* 
     * @Method Name                    :  Save
     * @Description                    :  Method to Return To Checklist Master Record
     * @Return Type                    :  PageReference
     * @Parameters                     :  None
     */
    Public PageReference ReturnMaster() {
        PageReference Master = new PageReference('/' + CheckListId);
        return Master;
    }
}