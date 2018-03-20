/**
* FullCalendar_controller 
* This class is used to display all the submitted   
* and approved leaves on a calendar
* Author(s):  Deloitte ( Nisha C O )
*/
public class TPTO_FullCalendar {

    public Document doc{get;set;}
    public String userName{get;set;}
    public List<TPTO_PTO_Request__c> ptoList{get;set;}
    public Boolean urlcheck {get;set;}
    
    /***************************************************************
     * Constructor Method
     ****************************************************************/
    public TPTO_fullCalendar() {
    }
    
     /***************************************************************
     * Method Name : pageLoad
     * Parameters  : None
     * Purpose     : To fetch all the PTO's to display on the calendar. 
     *               Only submitted and approved leaves are displayed.
     * Return      : null
     ****************************************************************/
    public PageReference pageLoad() {
        String queryString;
        
       // doc = [select name from document where Name= 'Lilly Logo'];
        
        if(userName != '' && userName != null && userName != '--None--'){
            queryString = 'Select Id, Name, End_Date__c, Start_Date__c, Status__c, Type_of_absence__c, Owner.Name, Absence_comments__c from TPTO_PTO_Request__c where Owner.Name =: userName AND Status__c != \'Needs discussion\' AND Status__c != \'Draft\'';
        } else if(userName == null || userName == '--None--') {
            queryString = 'Select Id, Name, End_Date__c, Start_Date__c, Status__c, Type_of_absence__c, Owner.Name, Absence_comments__c from TPTO_PTO_Request__c where Status__c != \'Needs discussion\' AND Status__c != \'Draft\'';
        }
        
        ptoList =  Database.query(queryString);
   
        return null;
    }
    
    /***************************************************************
     * Method Name : getItems
     * Parameters  : None
     * Purpose     : To display all the employees names
     * Return      : List<SelectOption>
     ****************************************************************/
     
    public List<SelectOption> getItems() {
        
        List<PermissionSetAssignment> trackerAdminPS = new List<PermissionSetAssignment>(); 
        List<SelectOption> options = new List<SelectOption>();
        Set<String> userSet = new Set<String>();
        
        trackerAdminPS = [SELECT Id, AssigneeId, Assignee.Name, PermissionSet.IsOwnedByProfile FROM PermissionSetAssignment WHERE PermissionSet.Name = 'TRAK_Tracker_Admin' AND Assignee.IsActive = true];
        
        for(PermissionSetAssignment psa:trackerAdminPS  ){
            userSet.add(psa.Assignee.Name);
        }
        
        options.add(new SelectOption('--None--','--None--'));
        for(String assignee: userSet){
            if(assignee != 'CI Integration User API login only'){
                options.add(new SelectOption(assignee,assignee));
            }
        }
        return options;
    }
}