Public with sharing class TRAK_PlanningPokerFromSprint{

    Public String sprintID {get;set;}
    TRAK_Planning_Poker_Session__c planningPoker;
    boolean readyToInsert;
    List<TRAK_Sprint__c> lstSprint;
    List<TRAK_Planning_Poker_Session_Content__c> lstmppsc = new List<TRAK_Planning_Poker_Session_Content__c>();
    
    public TRAK_PlanningPokerFromSprint(){
        readyToInsert = false;
        planningPoker = new TRAK_Planning_Poker_Session__c();
        sprintID = ApexPages.currentPage().getParameters().get('id');
        lstSprint = [select id, name from TRAK_Sprint__c where id =: sprintID];
        if(lstSprint != null && lstSprint.size() > 0){            
            planningPoker.Leader__c = UserInfo.getUserId();
            planningPoker.Sprint__c = lstSprint[0].id;
            planningPoker.Title__c = 'Planning Poker for '+ lstSprint[0].name;  
            readyToInsert = true;
        }
    }
    
    public PageReference insertPlanningPokerSession(){
        try{
            if(readyToInsert){
                insert planningPoker;
                List<TRAK_User_Story__c> lstUS = [select id, Development_Stage__c, Story_Points_Total__c from TRAK_User_Story__c where Proposed_Sprint__c =: lstSprint[0].Id];
                for(TRAK_User_Story__c us : lstUS){
                    if(us.Development_Stage__c != 'Cancelled' && us.Story_Points_Total__c == 0){
                        TRAK_Planning_Poker_Session_Content__c mppsc = new TRAK_Planning_Poker_Session_Content__c();
                        mppsc.Planning_Poker_Session__c = planningPoker.Id;
                        mppsc.User_Story__c = us.Id;
                        lstmppsc.add(mppsc);
                    }
                }
                if(lstmppsc != null && lstmppsc.size()>0)
                    insert lstmppsc;
                
                PageReference pageRef = new PageReference('/apex/TRAK_PlanningPoker?id='+planningPoker.Id);
                return pageRef;
                
            }
        }catch(Exception e){
            GLBL_Error_Log__c errLog = new GLBL_Error_Log__c(Error_Datetime__c= DateTime.Now(),Error_Message__c= e.getMessage(),Running_User__c = UserInfo.getUserId(),Stack_Trace__c = e.getStackTraceString()); 
            insert errlog;              
        }
        return null;
    }
}