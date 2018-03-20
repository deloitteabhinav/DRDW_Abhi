/****************************************************************************************************************************************** 
* Class Name   : CloneChecklistMasterController 
* Description  : Class to Clone Checklist Master
* Created By   : Deloitte Consulting
* 
*****************************************************************************************************************************************/

Public with Sharing Class CloneChecklistMasterController {
    Public Checklist_Version__c oCheckListMaster {
        get;
        set;
    }
    
    Public Checklist_Item__c CheckListItem{
    	get;set;
    }
    
    //Loading the Constructor
    Public CloneChecklistMasterController(ApexPages.StandardController controller) {
    	String pageName = ApexPages.currentPage().getUrl();
    	if(pageName.contains('ChecklistMaster')){
    		oCheckListMaster = (Checklist_Version__c) controller.getrecord();
    	}
    	
    	if(pageName.contains('ChecklistItem')){
    		List<String> ChecklistItemFields = new List<String>();
    		Map < String, Schema.SObjectField > schemaFieldMap = Schema.SObjectType.Checklist_Item__c.fields.getMap();               
            for (String fieldName: schemaFieldMap.keySet()) 
            {
                ChecklistItemFields.add(fieldName);
            }
            if(!test.isRunningTest())
            { 
                controller.addfields(ChecklistItemFields);
            }
    		
    		CheckListItem = (Checklist_Item__c)controller.getrecord();
    	}
        
    }

/* 
* @Method Name                    :  CloneRec
* @Description                    :  Clones the parent and child records
* @Return Type                    :  pagereference
* @Parameters                     :  None
*/ 
    Public PageReference CloneRec() {
        List < Checklist_Versionaire__c > lNewItems = new List < Checklist_Versionaire__c > ();
        
        //Cloning the Existing Checklist
        Checklist_Version__c oCheckListMasterCopy = oCheckListMaster.clone(false, true);
        Insert oCheckListMasterCopy;
        
        //Inserting Related List
        List < Checklist_Versionaire__c > lItems = [SELECT Id, Checklist_Version_Id__c, Sequence__c, Checklist_Item_Id__c FROM Checklist_Versionaire__c WHERE Checklist_Version_Id__c = : oCheckListMaster.Id];
        for (Checklist_Versionaire__c oChecklist: lItems) {
            Checklist_Versionaire__c ItemCopy = oChecklist.clone(false, true);
            ItemCopy.Checklist_Version_Id__c = oCheckListMasterCopy.Id;
            lNewItems.add(ItemCopy);
        }
        insert lNewItems;
        PageReference Master = new PageReference('/' + oCheckListMasterCopy.Id);
        Master.setRedirect(true);
        Return Master;
    }
    
    
    /* 
* @Method Name                    :  CloneCheckListItemRec
* @Description                    :  Clones the parent and child records for CheckListItem object
* @Return Type                    :  pagereference
* @Parameters                     :  None
*/ 
    
    Public PageReference CloneCheckListItemRec(){
    	List<Study_Attribute__c> CloneStudyItems = new List<Study_Attribute__c>();
    	List<Checklist_Response__c> CloneResponseItems = new List<Checklist_Response__c>();
    	Checklist_Item__c CloneCheckListItem = CheckListItem.clone(false,false,false,false);
    	insert CloneCheckListItem;
    	
    	List<Study_Attribute__c> CheckListStudyItems = new List<Study_Attribute__c>([Select Checklist__c,Study_Attribute__c,Study_Field__c,Study_Field_Label__c from Study_Attribute__c where Checklist__c =:CheckListItem.Id]);
    	List<Checklist_Response__c> CheckListResponseItems = new List<Checklist_Response__c>([Select Checklist__c,Response__c from Checklist_Response__c where Checklist__c =: CheckListItem.Id]);
    	
    	for(Study_Attribute__c StudyItems:CheckListStudyItems){
    		Study_Attribute__c NewCloneStudy = StudyItems.clone(false,true);
    		NewCloneStudy.Checklist__c = CloneCheckListItem.id;
    		CloneStudyItems.add(NewCloneStudy);
    	}
    	
    	for(Checklist_Response__c ResponceItems:CheckListResponseItems){
    		Checklist_Response__c NewCloneResponse = ResponceItems.clone(false,true);
    		NewCloneResponse.Checklist__c = CloneCheckListItem.id;
    		CloneResponseItems.add(NewCloneResponse);
    	}
    	if(!CloneStudyItems.isEmpty()){
    		insert CloneStudyItems;
    	}
    	if(!CloneResponseItems.isEmpty()){
    		insert CloneResponseItems;
    	}
    	    	
    	PageReference ClonedCheckListItem = new PageReference('/' + CloneCheckListItem.Id);
    	ClonedCheckListItem.setRedirect(true);
    	return ClonedCheckListItem;
    }
    
}