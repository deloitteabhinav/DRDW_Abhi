/****************************************************************************************************************************************** 
* Class Name   : Push_Checklist
* Description  : Class to Push Checklist 
* Created By   : Deloitte Consulting
* 
*****************************************************************************************************************************************/

Public with sharing class Push_Checklist {
    
    Private Final Checklist_Version__c oMaster;
    Public List<Project__c> lProjects;
    Public Map<Id,Project__c> mProjects;
    Public List<wStudy> lwStudy{get;set;}
    
    //Constructor
    Public Push_Checklist(ApexPages.StandardController controller) {
        if (!Test.isRunningTest()) {
            controller.addFields(new List<String>{'Active__c','Study_Type__c'});
        }
        oMaster = (Checklist_Version__c)controller.getRecord();
        lProjects = new List<Project__c>();
        lwStudy = new List < wStudy > ();
        If(oMaster.Active__c == false){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Only Active Checklists can be Pushed to Studies.'));
        }
        Else{
            ShowProjects();
        }
    }
    
    Public void ShowProjects(){
        mProjects = new Map<Id, Project__c>([Select Name,Study_Project_ID__c,Owner.Name,Project_Status__c,Study_Stage__c,Study_Description__c from Project__c where Study_Description__c =: oMaster.Study_Type__c AND Study_Stage__c != '' AND Study_Stage__c != NULL AND Study_Stage__c !=  'Questionnaire' AND Study_Stage__c != 'Questionnaire Needs Review' AND (Project_Status__c = 'Active' OR Project_Status__c = 'Approved' OR Project_Status__c = 'On Hold')]);
        If(!mProjects.IsEmpty()){
            For(Id i : mProjects.keyset()){
                lwStudy.add(new wStudy(mProjects.get(i), '',FALSE));  
            }
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Are you sure you want to push the Checklist changes to the following Studies? The status of all the Studies would be changed to "Questionnaire Needs Review".'));
        }
    }
    
    Public PageReference UpdateStudies(){
        For(Id i : mProjects.keyset()){
            mProjects.get(i).Study_Stage__c = 'Questionnaire Needs Review';
            lProjects.add(mProjects.get(i));
        }
        Database.SaveResult[] srList = Database.Update(lProjects, false);
        lwStudy = new List < wStudy > ();
        mProjects = new Map<Id, Project__c>([Select Name,Study_Project_ID__c,Owner.Name,Project_Status__c,Study_Stage__c,Study_Description__c from Project__c where Study_Description__c =: oMaster.Study_Type__c]);
        for(Integer i=0; i<srList.size(); i++){
            If(srList.get(i).isSuccess()){
                lwStudy.add(new wStudy(mProjects.get(srList.get(i).getId()), 'Record Successfully Updated',FALSE));  
            }
            Else {
                lwStudy.add(new wStudy(mProjects.get(lProjects.get(i).Id), srList.get(i).getErrors().get(0).getMessage(),TRUE));  
            }
        }
        return null;
    }
    
    Public PageReference ReturnToMaster(){
        PageReference Redirect = new PageReference('/'+ oMaster.Id);
        return Redirect;  
    }
    
    
    Public Class wStudy{
        Public Project__c oStudy {
            get;
            set;
        }
        Public String sMsg {
            get;
            set;
        }
        Public Boolean IsError{
            get;
            set;
        }
        Public wStudy(Project__c s, String M, Boolean b) {
            oStudy = s;
            sMsg = M;
            IsError = b;
        }
    }

}