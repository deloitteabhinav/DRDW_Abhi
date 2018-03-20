/****************************************************************************************************************************************** 
* Class Name   : sprintPlanning
* Description  : Functionality to drap stories in and out of sprint
* Created By   : Deloitte Consulting
* 
*****************************************************************************************************************************************/


public with sharing class TRAK_sprintPlanning{
    
    public static String INPLANNING = 'In Planning'; //status of an in planning sprint
    
    //get set for current sprint drop down/picklist
    public  String currentSprint {get;set;}
    
    //get set for current project drop down/picklist
    public  String currentProject {get;set;}
    
    public TRAK_Sprint__c spr {get; private set;}
    public list <TRAK_User_Story__c> req {get; private set;}
    public list <TRAK_User_Story__c> notAllocatedUS {get; private set;}
    public integer TotalCountAllocatedUSie{get; private set;}
    public integer TotalCountNonAllocatedUSie{get; private set;}
   
    //constructor to allow passing in selected sprint as a query string
    public TRAK_sprintPlanning(){
         String sprintID = ApexPages.currentPage().getParameters().get('sprintID');
         if (sprintID != null)
         {
             TRAK_sprint__c sprtObj = [select id /*,project__c */ from TRAK_sprint__c where id=:sprintID ];
                 if(sprtObj!=null){
                     // currentProject = sprtObj.project__c;
                     currentSprint = sprtObj.Id;
                } 
         }
         if(sprintID != null && sprintID != ''){
            //this.currentSprint = sprintID;
            getSelectedSprint();
         }
    }
    
    public Boolean getCurrentSprintInPlanning(){
        if(spr!=null)
            return spr.Status__c == INPLANNING;
        else
            return false;
    }
     
     /*
    public List<SelectOption> getProject(){
        list<SelectOption> options = new List<SelectOption>();
        Set<id> projectid = new Set<id>();
        options.add(new SelectOption('0','Select Project'));
        list<TRAK_Sprint__c> sprintname = [select Name,Project__c from TRAK_Sprint__c where Status__c ='In Planning' order by Name asc];
        for(TRAK_Sprint__c spr : sprintname)
             projectid.add(spr.Project__c);
        list<TRAK_Project__c> projectname = [select Name from TRAK_Project__c where id =:projectid  order by Name asc];
        for(TRAK_Project__c pro: projectname){
            options.add(new SelectOption(pro.Id,pro.Name));
        }
        return options;
    } */
    
    public List<SelectOption> getSprint(){
        list<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('0','Select Sprint'));
        list<TRAK_Sprint__c> sprintname = [select Id,Name from TRAK_Sprint__c where (Status__c ='In Planning')  order by Name asc];
         for(TRAK_Sprint__c sp: sprintname ){
            options.add(new SelectOption(sp.Id,sp.Name));
        }
    //    system.debug('OOOOO'+options);
        return options;
    }
    
    public TRAK_Sprint__c getSelectedSprint(){
       try{
            if(this.spr == null){
                 TRAK_Sprint__c sprintname = [select Name,Tech1_Story_Points__c,Tech2_Story_Points__c, Status__c from TRAK_Sprint__c where id =: currentSprint  order by Name asc];

                 this.spr = sprintname;
            }
             return this.spr;
        }Catch(System.QueryException e){
            return null;}
        }
    
    public list<TRAK_User_Story__c> getAllocatedUserStory() {
        if(currentSprint != null){
            list <TRAK_User_Story__c> require = [select Id,Name ,
                                                    Acceptance_Criteria__c,
                                                    Story_points__c, 
                                                    Story_Points_Other__c,
                                                    Development_Stage__c,
                                                    Priority__c,
                                                    Allocated_Sprint__c ,
                                                    Master_Priority__c,
                                                    As_A_Text__c,
                                                    I_Want_To__c,
                                                    So_that__c
                                                    From 
                                                    TRAK_User_Story__c
                                                    Where 
                                                    Allocated_Sprint__c =:currentSprint 
                                                    order by Master_Priority__c asc];
                
            this.req = require;
            this.TotalCountAllocatedUSie = require.size();
            return require;}
            else
            return null;
      }
    
    public list<TRAK_User_Story__c> getNotAllocatedUserStory(){
          if(currentSprint != null){
            list <TRAK_User_Story__c> req = [select Id,Name,
                                                Acceptance_Criteria__c,
                                                Development_Stage__c,
                                                Story_points__c,
                                                Story_Points_Other__c,
                                                Allocated_Sprint__c ,
                                                Priority__c,
                                                Master_Priority__c,
                                                As_A_Text__c,
                                                I_Want_To__c,
                                                So_that__c
                                                from 
                                                TRAK_User_Story__c
                                                where (
                                                Proposed_Sprint__c      = : currentSprint 
                                                AND (Allocated_Sprint__c = null OR Allocated_Sprint__c = '') 
                                                and Development_Stage__c != 'Closed - Invalid' 
                                                ) 
                                                order by Master_Priority__c asc ];
                                                
            this.notAllocatedUS = req;
            this.TotalCountNonAllocatedUSie =  req.size();               
            return req;
        }   else
            return null;
    }
    
    
    
   
     public integer getsfdcPlanned(){
      integer total = 0;
      if(req != null){
      for(TRAK_User_Story__c r : req){
          if (r.Story_Points__c != null && r.Story_Points__c != '0')
         total = total + integer.valueof(r.Story_Points__c);
         }
        return total;
        }
        else
           return total;
      }
      
     public integer getsfdcRemain(){
        if(spr!= null && spr.Tech1_Story_Points__c != null && spr.Tech1_Story_Points__c != 0){
          return integer.valueof(spr.Tech1_Story_Points__c) - getsfdcPlanned();
           }
        else {
          return 0- getsfdcPlanned();}
          
       }
       
     
      public integer getOtherPlanned(){   
      integer total = 0;
      if(req != null){
      for(TRAK_User_Story__c r : req){
          if (r.Story_Points_Other__c != null && r.Story_Points_Other__c != '0')
         total = total + integer.valueof(r.Story_Points_Other__c);
         }
        return total;
        }
        else
           return total;
      }
      
   public integer getOtherRemain(){
        if(spr != null && spr.Tech2_Story_Points__c != null)
            return  integer.valueof(spr.Tech2_Story_Points__c) -  getOtherPlanned();
        else
            return 0 - getOtherPlanned();
    }          
    public PageReference syncUserStory() {
        return null;
    }
    public void autoPlan(){ 
      
      list<TRAK_User_Story__c> allocatedlist = new list<TRAK_User_Story__c>();
      integer sfdcrem = getsfdcRemain();
      integer otherrem  = getOtherRemain();
      Savepoint sp = Database.setSavepoint();
      
      try{
        for (TRAK_User_Story__c nonall : notAllocatedUS){
         if ((sfdcrem >= integer.valueof((nonall.Story_Points__c)!=null? nonall.Story_Points__c : '0')) 
                   ){
             nonall.Allocated_Sprint__c = currentSprint;
             allocatedlist.add(nonall);
             
             otherrem = otherrem - integer.valueof((nonall.Story_points__c)!=null? nonall.Story_points__c : '0');
             
          }
        }
        update allocatedlist;
      }catch (System.Dmlexception e){
            System.debug(e);
            Database.rollback(sp);
      }
      
        
    }
    public void updateUserStoriesSprint(){
        
        Savepoint sp = Database.setSavepoint();
        try {
            String  UpdateSwing     = Apexpages.currentPage().getParameters().get('UpdateSwing');
            String  userStroyID     = Apexpages.currentPage().getParameters().get('UserStoryID');
            list <TRAK_User_Story__c> listdraggedUserStory = [select Id from TRAK_User_Story__c where Id =:userStroyID];  
            
            if(listdraggedUserStory.size()>0){
       //     system.debug(currentsprint);
                if(UpdateSwing == 'AllocateUSies' && currentSprint != null && currentSprint != '0'){
                   listdraggedUserStory[0].Allocated_Sprint__c = currentSprint;
                   update listdraggedUserStory;                    
                } 
               
               if(UpdateSwing == 'NonAllocateUSies' && currentSprint != null && currentSprint != '0'){
                    
                    listdraggedUserStory[0].Allocated_Sprint__c = null;
                    listdraggedUserStory[0].Proposed_Sprint__c  = currentSprint ;
                    update listdraggedUserStory;
                }   
            }
        }catch (System.Dmlexception e){
            System.debug(e);
            Database.rollback(sp);
        }
    }
    
    // Function to add chatter feeditem to the User Story Record.
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