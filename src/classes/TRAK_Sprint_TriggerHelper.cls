public class TRAK_Sprint_TriggerHelper {
       
    public static boolean sprintDateUpdated = false;
    /**
     * Sums the points for all stories allocated to a sprint, and stamps on the sprint record
     */
     
    public static void updateAllocatedStoryPoints (Set<Id> sprintIds) {
        
        if (sprintIds.size() > 0) {
            
            // get the sprints, and put them in a map
            Map<Id, TRAK_Sprint__c> sprints = new Map<Id, TRAK_Sprint__c>([SELECT Id, Story_Points__c FROM TRAK_Sprint__c WHERE Id in :sprintIds]);
            
            // query for the total sum
            AggregateResult[] sums = [
                                    SELECT SUM(Story_Points_Total__c) sum, Allocated_Sprint__c
                                    FROM TRAK_User_Story__c 
                                    WHERE Allocated_Sprint__c in :sprintIds
                                    AND Story_Points_Total__c != null
                                    GROUP BY Allocated_Sprint__c
                                    ];

            AggregateResult[] sums_def = [
                                    SELECT SUM(Story_Points_Total__c) sum, Allocated_Sprint__c
                                    FROM TRAK_Bug__c 
                                    WHERE Allocated_Sprint__c in :sprintIds
                                    AND Story_Points_Total__c != null
                                    GROUP BY Allocated_Sprint__c
                                    ];                                    
            
            // update the sprint records
            for (AggregateResult result : sums) {
                System.debug('Total pts allocated to sprint ' + result.get('Allocated_Sprint__c') + ' are:' + result.get('sum'));
                sprints.get((Id)result.get('Allocated_Sprint__c')).Story_Points__c = Integer.valueOf(result.get('sum'));
            }
            //US-41727
            //Aggregate Result for Defects
            for (AggregateResult result : sums_def) {
                System.debug('Total pts completed in sprint ' + result.get('Allocated_Sprint__c') + ' are:' + result.get('sum'));
                sprints.get((Id)result.get('Allocated_Sprint__c')).Story_Points__c = sprints.get((Id)result.get('Allocated_Sprint__c')).Story_Points__c + Integer.valueOf(result.get('sum'));
            }             
            
            // if we couldn't find anything set the value to zero. This is just there so we have a zero instead of a null for reporting
            for (TRAK_Sprint__c sprint : sprints.values()) {
                if (sprint.Story_Points__c == null) {
                    sprint.Story_Points__c = 0;
                }
            }
            
            update sprints.values();
        }

        
    }
    
    /**
     * Sums the points for all stories completed in a sprint, and stamps on the sprint record
     */
    public static void updateCompletedStoryPoints (Set<Id> sprintIds) {
        
        if (sprintIds.size() > 0) {
            
            // get the sprints, and put them in a map
            Map<Id, TRAK_Sprint__c> sprints = new Map<Id, TRAK_Sprint__c>([SELECT Id, Completed_story_points__c FROM TRAK_Sprint__c WHERE Id in :sprintIds]);
            
            // query for the total sum
            AggregateResult[] sums = [
                                    SELECT SUM(Story_Points_Total__c) sum, Allocated_Sprint__c
                                    FROM TRAK_User_Story__c 
                                    WHERE Allocated_Sprint__c in :sprintIds
                                    AND Development_Stage__c = :System.Label.TRAK_User_Story_Burn_Status
                                    AND Story_Points_Total__c != null
                                    GROUP BY Allocated_Sprint__c
                                    ];
            //US-41727                        
            List<String> DefectClosedStatuses = System.Label.TRAK_Defects_Status_Closed_Complete.split(',');
            AggregateResult[] sums_def = [
                                    SELECT SUM(Story_Points_Total__c) sum, Allocated_Sprint__c
                                    FROM TRAK_Bug__c 
                                    WHERE Allocated_Sprint__c in :sprintIds
                                    AND Status__c IN :DefectClosedStatuses
                                    AND Story_Points_Total__c != null
                                    GROUP BY Allocated_Sprint__c
                                    ];                                    

            
            // update the sprint records
            for (AggregateResult result : sums) {
                System.debug('Total pts completed in sprint ' + result.get('Allocated_Sprint__c') + ' are:' + result.get('sum'));
                sprints.get((Id)result.get('Allocated_Sprint__c')).Completed_story_points__c = Integer.valueOf(result.get('sum'));
            }
            //US-41727
            //Aggregate Result for defects
            for (AggregateResult result : sums_def) {
                System.debug('Total pts completed in sprint ' + result.get('Allocated_Sprint__c') + ' are:' + result.get('sum'));
                sprints.get((Id)result.get('Allocated_Sprint__c')).Completed_story_points__c = sprints.get((Id)result.get('Allocated_Sprint__c')).Completed_story_points__c + Integer.valueOf(result.get('sum'));
            }            
            
            // if we couldn't find anything set the value to zero. This is just there so we have a zero instead of a null for reporting
            for (TRAK_Sprint__c sprint : sprints.values()) {
                if (sprint.Completed_story_points__c == null) {
                    sprint.Completed_story_points__c = 0;
                }
            }
            
            update sprints.values();
        }
    }
    /** 
    * Method to create and remove the time entry record upon change in Sprint dates
    * 
    * US-42622
    * @Param Map<Id,TRAK_Sprint__c>,Map<Id,TRAK_Sprint__c>
    * @return void
    * @throws NA
    */
    
    /*public static void populateTimeEntryRecords(Map<ID,TRAK_Sprint__c> oldSprintMap, Map<ID,TRAK_Sprint__c> newSprintMap){
        
        Set<ID> sprintIds = new Set<ID>();
        Set<ID> roleIds = new Set<ID>();
        Set<String> oldTimeEntryIDs = new Set<String>();
        Set<String> deleteExtIds = new Set<String>();
        Set<String> upsertIDs = new Set<String>();
        List<TRAK_Delivery_Team__c> roles = new List<TRAK_Delivery_Team__c>();
        //List<TRAK_Resource_Time_Entry__c> lstUpsertTimeEntry = new List<TRAK_Resource_Time_Entry__c>();
        //List<TRAK_Resource_Time_Entry__c> lstOldTimeEntry = new List<TRAK_Resource_Time_Entry__c>();
        //List<TRAK_Resource_Time_Entry__c> lstdeleteTimeEntry = new List<TRAK_Resource_Time_Entry__c>();
        For(TRAK_Sprint__c sprint : oldSprintMap.values())  {
            System.debug('Status__c :::::'+sprint.Status__c);
            If((sprint.Start_Date__c != newSprintMap.get(sprint.ID).Start_Date__c) ||(sprint.End_Date__c != newSprintMap.get(sprint.ID).End_Date__c))
            {
                sprintIds.add(sprint.ID);
            }
        }
        If(!sprintIds.IsEmpty())    {
            roles = [SELECT Id, User__c,Role__c,Sprint__c,Sprint__r.Start_Date__c,Sprint__r.End_Date__c FROM TRAK_Delivery_Team__c WHERE Sprint__c in :sprintIds];
            lstOldTimeEntry = [SELECT Id, Name, Actual_Hours__c, Estimated_Hours__c, Resource__c, Sprint__c, Resource_Name__c, Associated_Sprint__c, Sprint_Week__c, Weekly_Billing__c, Week_From__c, Week_To__c,Week_Identifier__c FROM TRAK_Resource_Time_Entry__c where Sprint__c in :sprintIds];
        }
        If(!roles.IsEmpty())    {
            For(TRAK_Delivery_Team__c role : roles) {
                roleIds.add(role.ID);
            }
        }
        If(!roleIds.IsEmpty())  {
            lstUpsertTimeEntry = CreateTimeEntrys(roleIds);
        }
        If(!lstUpsertTimeEntry.IsEmpty())   {
            //For(TRAK_Resource_Time_Entry__c upentry : lstUpsertTimeEntry)   {
              //  upsertIDs.add(upentry.Week_Identifier__c);
            //}
        }
        If(!lstOldTimeEntry.IsEMpty())  {
            /*For(TRAK_Resource_Time_Entry__c oldentry : lstOldTimeEntry)   {
                oldTimeEntryIDs.add(oldentry.Week_Identifier__c);
            }
        }
        If(!oldTimeEntryIDs.IsEMpty())  {
            If(!upsertIDs.IsEmpty())    {
                For(String id : oldTimeEntryIDs)    {
                    if(!upsertIDs.contains(id)){
                        deleteExtIds.add(id);
                    }
                }
            }
        }
        /*If(!deleteExtIds.IsEmpty()) {
            lstdeleteTimeEntry = [Select ID from TRAK_Resource_Time_Entry__c where Week_Identifier__c in :deleteExtIds];
        }
        If(!lstdeleteTimeEntry.IsEmpty())   {
            try {
                delete lstdeleteTimeEntry ;
            }
            Catch(Exception ex) {
                System.debug('Exception is : '+ ex.getMessage());
            }
        }
        If(!lstUpsertTimeEntry.IsEmpty()) {
            try {                
                sprintDateUpdated = true;
                upsert lstUpsertTimeEntry Week_Identifier__c ;
            }
            Catch(Exception ex) {
                //upsert lstUpsertTimeEntry Week_Identifier__c ;
                System.debug('Exception is : '+ ex.getMessage());
            }
        }
    }
    /** 
    * Method to create the time entry record based on Sprint date changes
    * 
    * US-42622
    * @Param Map<Set<ID>>
    * @return void
    * @throws NA
    */
    /*Public Static List<TRAK_Resource_Time_Entry__c> CreateTimeEntrys(Set<Id> roleIds){
        List<TRAK_Delivery_Team__c> Roles = new List<TRAK_Delivery_Team__c>([SELECT Id, User__c,Role__c,Location__c,Sprint__c,Sprint__r.Start_Date__c,Sprint__r.End_Date__c FROM TRAK_Delivery_Team__c WHERE Id in :roleIds])  ;
        System.debug('**Roles'+Roles.size());
        List<TRAK_Resource_Time_Entry__c> TimeEntryRecords = new List<TRAK_Resource_Time_Entry__c>();
        List<TRAK_Resource_Billing_Matrix__c> BillingHoursList = new List<TRAK_Resource_Billing_Matrix__c>(); 
        List<TRAK_Resource_Billing_Matrix__c> BillingRatesList = new List<TRAK_Resource_Billing_Matrix__c>();        
        BillingHoursList = [SELECT Id, Name, RecordTypeId, Location__c, Role__c,Hours_Per_Day__c, Billable_Hours__c, Billing_Rate__c FROM TRAK_Resource_Billing_Matrix__c WHERE RecordTypeId in (SELECT Id FROM RecordType WHERE RecordType.DeveloperName = 'Resource_Billable_Hours') ];
        BillingRatesList = [SELECT Id, Name, RecordTypeId, Location__c, Role__c,Hours_Per_Day__c, Billable_Hours__c, Billing_Rate__c FROM TRAK_Resource_Billing_Matrix__c WHERE RecordTypeId in (SELECT Id FROM RecordType WHERE RecordType.DeveloperName = 'Resource_Billing_Rate')  ];
                System.debug('**BillingHoursList'+BillingHoursList.size());
        if(Roles.size()>0){
                For(TRAK_Delivery_Team__c Role : Roles){
                    System.debug('Role**'+Role);
                    if((Role.Sprint__r.Start_Date__c != NULL) && (Role.Sprint__r.End_Date__c != NULL) ){
                        Date StartDate, EndDate,dt;
                        StartDate = Role.Sprint__r.Start_Date__c;  
                        EndDate = Role.Sprint__r.End_Date__c;
                        Integer noOfWeeks = 0;
                        Integer nooddaysinweek = 0;
                        dt = StartDate;
                        do{
                            DateTime dttime = DateTime.newInstance(dt, Time.newInstance(0, 0, 0, 0));
                            String dayOfWeek = dttime.format('EEEE');
                            System.debug('dayOfWeek  '+dayOfWeek);
                            If(dayOfWeek != 'Saturday' && dayOfWeek != 'Sunday')    {
                                nooddaysinweek = nooddaysinweek + 1;
                            }
                            If(dayOfWeek == 'Saturday' || dt== EndDate ) {
                                noOfWeeks = noOfWeeks + 1;
                                Integer workdays = nooddaysinweek;
                                System.debug('workdays --'+workdays);
                                System.debug('nooddaysinweek **'+nooddaysinweek );
                                TRAK_Resource_Time_Entry__c TimeEntry = new TRAK_Resource_Time_Entry__c();
                                TimeEntry.Sprint__c = Role.Sprint__c;
                                TimeEntry.Resource__c = Role.Id;
                                for(TRAK_Resource_Billing_Matrix__c BillingHours : BillingHoursList){
                                    System.debug('Billinghours** '+BillingHours );
                                    if(BillingHours.Role__c == Role.Role__c){
                                        System.debug('** nooddaysinweek **'+nooddaysinweek );
                                        System.debug('BillingHours.Hours_Per_Day__c ----'+BillingHours.Hours_Per_Day__c);
                                        TimeEntry.Estimated_Hours__c = workdays * BillingHours.Hours_Per_Day__c;
                                        break;
                                    }   
                                }
                                If((TimeEntry.Estimated_Hours__c != 0) && ( TimeEntry.Estimated_Hours__c != null))   { 
                                    System.debug('**************');
                                    for(TRAK_Resource_Billing_Matrix__c BillingHours : BillingRatesList){       
                                        System.debug('loc1 '+BillingHours.Location__c);
                                        System.debug('loc2 '+Role.Location__c);
                                        if(BillingHours.Location__c == Role.Location__c){
                                            System.debug('** Role.Location__c **'+Role.Location__c);
                                            System.debug('TimeEntry.Estimated_Hours__c ----'+TimeEntry.Estimated_Hours__c);
                                            TimeEntry.Estimated_Weekly_Billing__c = TimeEntry.Estimated_Hours__c * BillingHours.Billing_Rate__c;                                            
                                            System.debug('TimeEntry.Estimated_Weekly_Billing__c  ----'+TimeEntry.Estimated_Weekly_Billing__c );
                                            break;
                                        }
                                    }
                                }
                                nooddaysinweek = 0;
                                If(noOfWeeks == 1)  {
                                    TimeEntry.Week_From__c = StartDate.toStartOfWeek();
                                    TimeEntry.Week_To__c = StartDate.toStartOfWeek().adddays(6);
                                }
                                else    {
                                    TimeEntry.Week_From__c = dt.toStartOfWeek();
                                    TimeEntry.Week_To__c = dt.toStartOfWeek().adddays(6);
                                }       
                                TimeEntry.Week_Number__c = noOfWeeks;                           
                                TimeEntry.Sprint_Week__c = 'Week ' + noOfWeeks +' ('+TimeEntry.Week_From__c.format() +' to '+ TimeEntry.Week_To__c.format() +')';
                                TimeEntry.Week_Identifier__c = role.id+' - '+TimeEntry.Week_From__c.format()+' - '+TimeEntry.Week_To__c.format();
                                TimeEntry.DevOpsResource__c = role.User__c;
                                // TimeEntry.CurrencyISOCode = 'USD';
                                If(TimeEntry.Estimated_Hours__c != 0)    {
                                    TimeEntryRecords.add(TimeEntry);
                                }
                            }       
                            dt = dt.adddays(1);
                        }while(dt<= EndDate);
                    }  
             }
        }
             return TimeEntryRecords;
    }
     /*Method to update Currency of the sprint to 'USD'.
     
    public static void updateSprintCurrency(List<TRAK_Sprint__c> newSprintList){
        for(TRAK_Sprint__c newSprint : newSprintList){
            // newSprint.CurrencyISOCode = System.Label.TRAK_Currency_USD;
        }   
    }*/
}