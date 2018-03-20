/****************************************************************************************************************************************** 
* Class Name   : KanbanBoardCntrl
* Description  : This is a class that will show the correct records in the digital Kanban board + make updates    
* Created By   : Deloitte Consulting
* 
*****************************************************************************************************************************************/

public with sharing class TRAK_KanbanBoardCntrl {

    public TRAK_Sprint__c spr {get; set;}
    public list <TRAK_User_Story__c> Columns1List{get; set;}
    public list <TRAK_User_Story__c> BacklogList{get; set;}
    public list <TRAK_User_Story__c> ReadyforDev{get; set;}
    public list <TRAK_User_Story__c> InDev{get; set;}
    public list <TRAK_User_Story__c> ReadyforTestRel{get; set;}
    public list <TRAK_User_Story__c> ReadyforTest{get; set;}
    public list <TRAK_User_Story__c> InTest{get; set;}
    public list <TRAK_User_Story__c> Passed{get; set;}  
    public list <TRAK_User_Story__c> StoryDef{get; set;} 
    
    Public List <TRAK_User_Story__c> completeUSList;
    Map<String,List<TRAK_User_Story__c>> AllocatedSprintUSList ;
    Public string selvalue {get;set;}
    Public string funcSelValue {get;set;}
    public string SprintName;
    public Set <String> sprintNames = new Set<String>();
    public Set <Id> sprintIds = new Set<Id>();
    public List<TRAK_Sprint__c> sprintList = new List<TRAK_Sprint__c>();
    
    public String errorString {get; set;}
       
    public TRAK_KanbanBoardCntrl(ApexPages.StandardController controller) {
        errorString = 'START';
        ApexPages.Message tempMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'initial message');
        ApexPages.addMessage(tempMsg);
        spr = new TRAK_Sprint__c();
        spr = [select Name, id from TRAK_Sprint__c where id =: apexpages.currentpage().getparameters().get('Id')];  
        sprintList = [select Name from TRAK_Sprint__c where Status__c = 'In Progress'];    
        for (TRAK_Sprint__c sprint : sprintList)
        {
            if (!sprintIds.contains(sprint.Id)){
                sprintNames.add(sprint.Name);
                sprintIds.add(sprint.Id);
            }
        }
        system.debug(sprintNames.size()); 
        SprintName = spr.Name;
        selvalue = SprintName;
        DispUserStories(null);
    }    
    
    public List<SelectOption> getsprintval(){
        List<SelectOption> tempSOPList = new List<SelectOption>();
        tempSOPList.add(new selectOption('All','All'));

        for(String str : sprintNames){
                tempSOPList.add(new SelectOption(str,str));
        }
        return tempSOPList;
    }
    
    // Compose Functional Areas Dropdown
    
    public List<SelectOption> getFuncval(){
        List<SelectOption> tempSOPList = new List<SelectOption>();
        tempSOPList.add(new selectOption('All','All'));
        tempSOPList.add(new selectOption('Customer Services','Customer Services'));        
        tempSOPList.add(new selectOption('Event / Medical','Event / Medical'));       
        tempSOPList.add(new selectOption('Market Access','Market Access'));        
        tempSOPList.add(new selectOption('Marketing / Multichannel','Marketing / Multichannel'));      
        tempSOPList.add(new selectOption('SFA','SFA'));     
        tempSOPList.add(new selectOption('Analytics / Insights','Analytics / Insights'));
        return tempSOPList;
    }
    
  // Display all user stories taking into account filters  
  Public void DispUserStories(string selvalx){
     if(selvalue ==null)
        selvalue ='All';
    if(funcSelValue ==null)
        funcSelValue ='All';
    
    // Find all requirements linked to the available sprint
    List<TRAK_User_Story__c> AllocatedSprintUSList  = [Select id, Name, Allocated_Sprint__c , Development_Stage__c, Functional_Area__c, As_A_text__c, I_Want_To__c, So_that__c, Allocated_Sprint__r.Name from TRAK_User_Story__c where Allocated_Sprint__c in: sprintids];
    List<TRAK_User_Story__c> TempList = new List<TRAK_User_Story__c>();
    List<TRAK_User_Story__c> TempList2 = new List<TRAK_User_Story__c>();
    
    // Create a subset of user stories based on filters
    if (selvalue == 'All'){
        TempList.addAll (AllocatedSprintUSList);
    }
    else{
        for (TRAK_User_Story__c req : AllocatedSprintUSList){
            if (selvalue != null && selvalue != 'All'){
                if (req.Allocated_Sprint__r.Name == selvalue){
                    TempList.add(req);
                }
            }
        }
    }
    
    
    if (funcSelValue == 'All'){
        TempList2 = Templist;
    }
    else{
        for (TRAK_User_Story__c req : TempList){
            if (funcSelValue != null && funcSelValue != 'All'){
                if (req.Functional_Area__c == funcSelValue){
                    TempList2.add(req);
                }
            }
        }
   }
    
    
    
    BacklogList = new list <TRAK_User_Story__c>();
    ReadyforDev = new list <TRAK_User_Story__c>();
    InDev = new list <TRAK_User_Story__c>();
    ReadyforTestRel = new list <TRAK_User_Story__c>();
    ReadyforTest = new list <TRAK_User_Story__c>();
    InTest = new list <TRAK_User_Story__c>();
    Passed = new list <TRAK_User_Story__c>();
    StoryDef = new list <TRAK_User_Story__c>();
    
    // Compose a list per status
    for(TRAK_User_Story__c req : TempList2){
        if(req.Development_Stage__c.contains('Backlog'))
            BacklogList.add(req);
        else if(req.Development_Stage__c.contains('Ready for Development'))
            ReadyforDev.add(req);
        else if(req.Development_Stage__c.contains('In Dev'))
            InDev.add(req);
        else if(req.Development_Stage__c.contains('Ready for Test Release'))
            ReadyforTestRel.add(req);
        else if(req.Development_Stage__c.contains('Ready for Test'))
            ReadyforTest.add(req);
        else if(req.Development_Stage__c.contains('In Test'))
            InTest.add(req);
        else if(req.Development_Stage__c.contains('Passed (Complete)'))
            Passed.add(req);
        else if(req.Development_Stage__c.contains('Story Definition'))
            StoryDef.add(req);
    }
  }
  
  // Method to change user story selection after changing dropdown values
  Public void filteredVal(){
    
    if(selvalue != null && selValue != 'All')
        DispUserStories(selvalue);
        
     else if(selvalue == null || selValue == 'All')
         DispUserStories(null);
    
    }  
 
     public Pagereference updateUserStoriesSprint(){
         try {
             String  UpdateSwing     = Apexpages.currentPage().getParameters().get('UpdateSwing');
             String  userStroyID     = Apexpages.currentPage().getParameters().get('UserStoryID');
             TRAK_User_Story__c req = new TRAK_User_Story__c(id=userStroyID);
             
             if(UpdateSwing == 'ReadyforDevUS')
                 req.Development_Stage__c = 'Ready for Development';
             else if(UpdateSwing == 'InDevUS')
                 req.Development_Stage__c = 'In Development';
             else if(UpdateSwing == 'BacklogUS')
                 req.Development_Stage__c = 'Backlog';
             else if(UpdateSwing == 'ReadyforTestRelUS')
                 req.Development_Stage__c = 'Ready for Test Release';
             else if(UpdateSwing == 'ReadyforTestUS')
                 req.Development_Stage__c = 'Ready for Test';
             else if(UpdateSwing == 'InTestUS')
                 req.Development_Stage__c = 'In Test';
             else if(UpdateSwing == 'PassedUS')
                 req.Development_Stage__c = 'Passed (Complete)';
                  else if(UpdateSwing == 'StoryDefUS')
                 req.Development_Stage__c = 'Story Definition';
             update req;
             errorString = 'OK';
             return null;
         }
         catch(Exception e){
             System.debug('SUNNY');
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'If other is selected please enter a description');
             ApexPages.addMessage(myMsg);
             //return Apexpages.currentPage();
             errorString = 'NOT ALLOWED';
             PageReference nextPg = Page.TRAK_AccessDenied;
             //currentPg.setRedirect(true);
             return nextPg;

         }
     }
     
     public void addChatterComment(){
        String  chatterComment  = Apexpages.currentPage().getParameters().get('ChatterComment');
        String  userStroyID     = Apexpages.currentPage().getParameters().get('UserStoryID');
        
        if( chatterComment != '' &  userStroyID != ''){
            try{
                FeedItem post = new FeedItem();
                post.ParentId = userStroyID; //user stroy id.
                post.Body = chatterComment;  //chatter comment.
                insert post;
            }catch (System.Dmlexception e){
                System.debug(e);                
            }   
            
        }
        
    } 
}