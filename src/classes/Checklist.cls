/****************************************************************************************************************************************** 
* Class Name   : Checklist
* Description  : Class handlers checklist items and its responses
* Created By   : Deloitte Consulting
* 
*****************************************************************************************************************************************/

public with sharing class Checklist{
public Project__c oProject;
Public Map<String,wObject> mChecklistToBeDisplayed{get;set;}
Public String sProcess{get;set;}
Public Id iSelectedCheckListItem{get;set;}
Map<Id,String> mCheckListItemsComments = new Map<Id,String>();
Public wQuestionsCount owQuestionsCount{get;set;}


Public List<String> StudyStages{
    get{
        if(StudyStages==null){
           List<String> options = new List<String>();
           for( Schema.PicklistEntry f : Project__c.Study_Stage__c.getDescribe().getPicklistValues()){
              options.add(f.getLabel());
           }       
            this.StudyStages =   options; 
        }
        return StudyStages;
    }
    private set;
}

Public list<selectoption> roleLovOptions{
    get{
        if(roleLovOptions==null){
            List<selectOption> statusOptions = new List<selectOption>();
            for(LOV__c oLOV : [SELECT id,name FROM LOV__c Where Active__c =: true]){
                statusOptions.add(new SelectOption(oLOV.Id, oLOV.Name));    
            }
            this.roleLovOptions =   statusOptions;  
        }
        return roleLovOptions;
    }
    private set;
}

    //Loading the constructor 
    public Checklist(ApexPages.StandardController controller) {
        mChecklistToBeDisplayed = new Map<String,wObject>();
        oProject = (Project__c)controller.getrecord();
        Study_Checklist_Version__c oStudyChecklistVersion  = [Select id,(select id,Checklist_Item__r.Process__c,newly_added__c,Role__c,comment__c,comment_date__c,Checklist_Item__r.Instructions__c,completed__c,sequence__c,milestone__c from Study_Checklists__r order by  Checklist_Item__r.Process__c,sequence__c,milestone__c) from Study_Checklist_Version__c where Study__c = : oProject.Id order by createddate desc Limit 1]; 
        Map<String,Map<Study_Checklist__c,List<Study_Checklist__c>>> mAssortedChecklistCollection = new Map<String,Map<Study_Checklist__c,List<Study_Checklist__c>>>();
        Study_Checklist__c oMilestone = new Study_Checklist__c();
        if(oProject.Study_stage__c == 'Questionnaire')
            sProcess = 'Ideation';
        else    
            sProcess = oProject.Study_stage__c;
        for( Schema.PicklistEntry f : Project__c.Study_Stage__c.getDescribe().getPicklistValues())
            mChecklistToBeDisplayed.put(f.getLabel(),new wObject(new List<wMilestoneChecklistItems>()));
        
        List<Study_Questionnaire__c> lStudyQuestionnaire = [select id,Study__c,Questionnaire__r.Questions__c,(select id,Response__c,Question__r.Dependent_Question__c from Study_Questionnaire_Responses__r where Question__r.Dependent_Question__c=:false) from Study_Questionnaire__c where Study__c =: oProject.Id order by createddate desc limit 1];
        Integer resp=0;
        for(Study_Questionnaire_Response__c oResponse : lStudyQuestionnaire[0].Study_Questionnaire_Responses__r){
            if(oResponse.Response__c!=null){
                resp++;
            }
        }

        owQuestionsCount = new wQuestionsCount(integer.valueof(lStudyQuestionnaire[0].Questionnaire__r.Questions__c),resp);
        for(Study_Checklist__c oStudyCheckList : oStudyChecklistVersion.Study_Checklists__r){
            mCheckListItemsComments.put(oStudyCheckList.Id,oStudyCheckList.comment__c);
            if(!mAssortedChecklistCollection.containskey(oStudyCheckList.Checklist_Item__r.Process__c)){
                mAssortedChecklistCollection.put(oStudyCheckList.Checklist_Item__r.Process__c,new Map<Study_Checklist__c,List<Study_Checklist__c>>());
            }
                   
            if(oStudyCheckList.milestone__c){
                mAssortedChecklistCollection.get(oStudyCheckList.Checklist_Item__r.Process__c).put(oStudyCheckList,new list<Study_Checklist__c>());
                oMilestone = oStudyCheckList;
            }
            else{
                if(mAssortedChecklistCollection.get(oStudyCheckList.Checklist_Item__r.Process__c).containskey(oMilestone))
                    mAssortedChecklistCollection.get(oStudyCheckList.Checklist_Item__r.Process__c).get(oMilestone).add(oStudyCheckList);
                else{
                    if(!mAssortedChecklistCollection.get(oStudyCheckList.Checklist_Item__r.Process__c).containskey(null))
                        mAssortedChecklistCollection.get(oStudyCheckList.Checklist_Item__r.Process__c).put(null,new list<Study_Checklist__c>{oStudyCheckList});    
                    else
                        mAssortedChecklistCollection.get(oStudyCheckList.Checklist_Item__r.Process__c).get(null).add(oStudyCheckList);  
                }   
            }
                
        }
        
        for(String oTest : mAssortedChecklistCollection.keyset()){
            mChecklistToBeDisplayed.put(oTest,new wObject(new List<wMilestoneChecklistItems>()));
            if(mAssortedChecklistCollection.get(oTest).containskey(null)){
                List<wSupportActionsList> lwSupportActionsList = new List<wSupportActionsList>();
                for(Study_Checklist__c oStudyChecklist: mAssortedChecklistCollection.get(oTest).get(null)){
                    lwSupportActionsList.add(new wSupportActionsList(oStudyChecklist));
                }
                mChecklistToBeDisplayed.get(oTest).lCheckListItems.add(new wMilestoneChecklistItems(null,null,lwSupportActionsList));
            }       
        }
        
        for(Study_Checklist__c oStudyCheckList : oStudyChecklistVersion.Study_Checklists__r){
            if(mAssortedChecklistCollection.get(oStudyCheckList.Checklist_Item__r.Process__c).containskey(oStudyCheckList)){
                integer iMileCount;
                if(mAssortedChecklistCollection.get(oStudyCheckList.Checklist_Item__r.Process__c).containskey(null)) 
                    iMileCount= mChecklistToBeDisplayed.get(oStudyCheckList.Checklist_Item__r.Process__c).lCheckListItems.size();
                else
                    iMileCount= mChecklistToBeDisplayed.get(oStudyCheckList.Checklist_Item__r.Process__c).lCheckListItems.size()+1; 
                List<wSupportActionsList> lwSupportActionsList = new List<wSupportActionsList>();
                for(Study_Checklist__c oStudyCheckitems : mAssortedChecklistCollection.get(oStudyCheckList.Checklist_Item__r.Process__c).get(oStudyCheckList)){
                    lwSupportActionsList.add(new wSupportActionsList(oStudyCheckitems));
                }   
                mChecklistToBeDisplayed.get(oStudyCheckList.Checklist_Item__r.Process__c).lCheckListItems.add(new wMilestoneChecklistItems(iMileCount,oStudyCheckList,lwSupportActionsList));
            }
        }
        
        for(wObject  owObejct: mChecklistToBeDisplayed.values()){
            owObejct.iTotalMileStones =0;
            owObejct.sProcessCount = 0;
            for(wMilestoneChecklistItems owMilestoneChecklistItems : owObejct.lCheckListItems){
                if(owMilestoneChecklistItems.oMilestone!=null && owMilestoneChecklistItems.oMilestone.Id !=null){
                    owObejct.iTotalMileStones++;
                }
                
                if(owMilestoneChecklistItems.oMilestone!=null && owMilestoneChecklistItems.oMilestone.completed__c){
                    owObejct.sProcessCount++;
                }
                if(owMilestoneChecklistItems.oMilestone.newly_added__c){
                    owObejct.bNewlyAdded = true;
                }
                
            }
            
        }
        
    }
    
 /* 
* @Method Name                    :  cancel
* @Description                    :  this method is used for "add notes" section on the checklist page. This method is invoked when the user removes the notes
* @Return Type                    :  void
* @Parameters                     :  None
*/      
Public void cancel(){
    for(wMilestoneChecklistItems oChecklist : mChecklistToBeDisplayed.get(sProcess).lCheckListItems){
        if(oChecklist.oMilestone!=null && iSelectedCheckListItem ==  oChecklist.oMilestone.Id){
            oChecklist.oMilestone.comment__c = mCheckListItemsComments.get(oChecklist.oMilestone.Id);
            if(oChecklist.oMilestone.comment__c!=null && oChecklist.oMilestone.comment__c!='')
                oChecklist.sNoteFlag = 'READ';
            else
                oChecklist.sNoteFlag = 'NEW';
            break;
        }
        for(wSupportActionsList oSupportChecklist : oChecklist.lCheckListItems){
            if(iSelectedCheckListItem ==  oSupportChecklist.oSupportActions.Id){
                oSupportChecklist.oSupportActions.comment__c = mCheckListItemsComments.get(oSupportChecklist.oSupportActions.Id);
                if(oSupportChecklist.oSupportActions.comment__c!=null && oSupportChecklist.oSupportActions.comment__c!='')
                    oSupportChecklist.sNoteFlag = 'READ';
                else
                    oSupportChecklist.sNoteFlag = 'NEW';
                break;
            }
        }
        
    }
} 

 /* 
* @Method Name                    :  makeEdit
* @Description                    :  this method is used for "add notes" section on the checklist page. This method is invoked when the user edits the notes
* @Return Type                    :  void
* @Parameters                     :  None
*/       

Public void makeEdit(){
    for(wMilestoneChecklistItems oChecklist : mChecklistToBeDisplayed.get(sProcess).lCheckListItems){
        if(oChecklist.oMilestone!=null && iSelectedCheckListItem ==  oChecklist.oMilestone.Id){
            oChecklist.sNoteFlag = 'EDIT';
            break;
        }
        for(wSupportActionsList oSupportChecklist : oChecklist.lCheckListItems){
            if(iSelectedCheckListItem ==  oSupportChecklist.oSupportActions.Id){
                oSupportChecklist.sNoteFlag = 'EDIT';
                break;
            }
        }
        
    }
}

 /* 
* @Method Name                    :  save
* @Description                    :  this method is invoked when a user selects a checklist response and adds notes
* @Return Type                    :  void
* @Parameters                     :  None
*/       


Public void save(){
    Study_Checklist__c oStudyCheckList;
    mChecklistToBeDisplayed.get(sProcess).sProcessCount =0;
    for(wMilestoneChecklistItems oChecklist : mChecklistToBeDisplayed.get(sProcess).lCheckListItems){
        if(oChecklist.oMilestone!=null && iSelectedCheckListItem ==  oChecklist.oMilestone.Id){
            oStudyCheckList = oChecklist.oMilestone;
            if(oChecklist.oMilestone.comment__c!=null && oChecklist.oMilestone.comment__c!=''){
                oChecklist.sNoteFlag = 'READ';
                mCheckListItemsComments.put(oChecklist.oMilestone.Id,oChecklist.oMilestone.comment__c);
            }   
            else
                oChecklist.sNoteFlag = 'NEW';
                
            if(oChecklist.oMilestone.completed__c && oChecklist.oMilestone.newly_added__c == true){
                oChecklist.oMilestone.newly_added__c = false;   
                mChecklistToBeDisplayed.get(sProcess).bNewlyAdded = false;
                update oProject;
            }
        }
        if(oChecklist.oMilestone!=null && oChecklist.oMilestone.completed__c ==true)
                mChecklistToBeDisplayed.get(sProcess).sProcessCount++;
    
        oChecklist.iCompleted = 0;
        
        for(wSupportActionsList oSupportChecklist : oChecklist.lCheckListItems){
            if(iSelectedCheckListItem ==  oSupportChecklist.oSupportActions.Id){
                oStudyCheckList = oSupportChecklist.oSupportActions;
                if(oSupportChecklist.oSupportActions.comment__c!=null && oSupportChecklist.oSupportActions.comment__c!=''){
                    oSupportChecklist.sNoteFlag = 'READ';
                    mCheckListItemsComments.put(oSupportChecklist.oSupportActions.Id,oSupportChecklist.oSupportActions.comment__c);
                }   
                else{
                    oSupportChecklist.sNoteFlag = 'NEW';
                }
                if(oSupportChecklist.oSupportActions.completed__c)
                    oSupportChecklist.oSupportActions.newly_added__c = false;
            }
            if(oSupportChecklist.oSupportActions.completed__c ==true)
                oChecklist.iCompleted++;
        }
    }
    
    update oStudyCheckList;
}

/* 
* @Method Name                    :  Submit
* @Description                    :  this method is invoked when a user submits a checklist for a particular process
* @Return Type                    :  void
* @Parameters                     :  None
*/    

Public void Submit(){
    boolean isNext=false;
    if(oProject.Study_Stage__c==null || oProject.Study_Stage__c == 'Questionnaire'){
        oProject.Study_Stage__c = 'Ideation';   
    }
    else if(oProject.Study_Stage__c=='Close Out'){
        oProject.Close_out__c = true;
        
    }
    else{
     for( Schema.PicklistEntry f : Project__c.Study_Stage__c.getDescribe().getPicklistValues()){
              if(oProject.Study_Stage__c == f.getvalue()){
                isNext = true;
                continue;   
              }
              if(isNext){
                oProject.Study_Stage__c = f.getvalue();
                break;
              }
     } 
    } 
     sProcess = oProject.Study_Stage__c;
     Update oProject;
     
    
}

Public class wQuestionsCount {
    Public Integer iTotalNumberOfQuestions{get;set;}
    Public Integer iRespondedQuestions{get;set;}
        Public wQuestionsCount(Integer iTotalNumberOfQuestions,Integer iRespondedQuestions){
            this.iTotalNumberOfQuestions = iTotalNumberOfQuestions;
            this.iRespondedQuestions = iRespondedQuestions;
        }
}

public pagereference redirectToStudyHome(){
     Pagereference p = new pagereference('/apex/CreateStudy?id='+oProject.id+'&isEdit=false');
     p.setRedirect(true);
     return p;
}


Public Class wObject{
    Public integer iTotalMileStones{get;set;}
    Public integer sProcessCount{get;set;}
    Public boolean bNewlyAdded {get;set;}
    Public List<wMilestoneChecklistItems> lCheckListItems{get;set;}
    Public wObject(List<wMilestoneChecklistItems> lCheckListItems ){
        this.lCheckListItems = lCheckListItems;
        this.sProcessCount = sProcessCount;
        this.iTotalMileStones = iTotalMileStones;
        this.bNewlyAdded = bNewlyAdded;
    }
}

Public class wSupportActionsList{
    Public Study_Checklist__c oSupportActions{get;set;}
    Public string sNoteFlag{get;set;}
        
    Public wSupportActionsList(Study_Checklist__c oSupportActions){
        this.oSupportActions = oSupportActions;
        if(oSupportActions.comment__c!=null)
            this.sNoteFlag='READ';
        else if(oSupportActions.comment__c==null)
            this.sNoteFlag='NEW';   
    }
}

Public class wMilestoneChecklistItems{
    Public Study_Checklist__c oMilestone {get;set;}
    Public String sMileCount {get;set;}
    Public List<wSupportActionsList> lCheckListItems {get;set;}
    Public integer iCompleted {get;set;}
    Public string sNoteFlag{get;set;}
    
    Public wMilestoneChecklistItems(Integer sMileCount,Study_Checklist__c oMilestone,List<wSupportActionsList> lCheckListItems){
        if(sMileCount==null)
            sMileCount = 0;
        this.sMileCount = 'Key Action '+sMileCount;
        this.oMilestone = oMilestone;
        this.lCheckListItems = lCheckListItems;
        integer i =0;
        for(wSupportActionsList oChecklist : lCheckListItems){
            if(oChecklist.oSupportActions.completed__c)
                i++;
        }
        this.iCompleted = i;
        if(oMilestone!=null && oMilestone.comment__c!=null)
            this.sNoteFlag='READ';
        else if(oMilestone!=null && oMilestone.comment__c==null)
            this.sNoteFlag='NEW';   
    }

}

}