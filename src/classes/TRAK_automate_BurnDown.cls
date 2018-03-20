/****************************************************************************************************************************************** 
* Class Name   : automateBoornDown
* Description  : This is a class that will both create the initial burndown records + updated them when user stories are closed    
* Created By   : Deloitte Consulting
* 
*****************************************************************************************************************************************/

Global class TRAK_automate_BurnDown {
    
    //calculate optimal burndown for a given day in a given sprint
    private static decimal optimalBurndown(TRAK_Sprint__c sprint, Decimal totalPoints, Integer daysIntoSprint){
         Decimal optimalPointsPerDay = totalPoints/(sprint.Number_Working_Days_in_Sprint__c);
         Decimal burndown = totalPoints - (optimalPointsPerDay * daysIntoSprint);
         
         if(burndown < 0)
            burndown = 0;   
         
         return burndown;
    }          
          
    /**
     * @description :- populates the burndown object with a row for each date within the sprint 
                    that is a working day (ie exclude weekends) with sprint name, date, 
                    and project fields populated and fields for actual burndown, 
                    optimum burndown, current velocity and projected burndown left blank
     * @param :- Sprint Id
     */       
     WebService static void generateSprintBurndown(String sprintId){
           // Query the Sprint object 
            TRAK_Sprint__c currentsprint = [select Name,Start_Date__c, End_Date__c,Number_Working_Days_in_Sprint__c /* ,Project__c ,  Project__r.Name */ from TRAK_Sprint__c where id =: sprintId];

           list<date> datelist = new list<date>();
           
              
              // Local Variables 
              date startDate = currentsprint.Start_Date__c;
              date endDate   = currentsprint.End_Date__c;
              integer numberDaysBet = startDate.daysBetween(endDate);
              TRAK_BurnDown2__c burndown;
              Map<Date,TRAK_BurnDown2__c> mapburnDown = new map<Date,TRAK_BurnDown2__c>();
              
              list<TRAK_User_Story__c> userStoryList = [select Allocated_Sprint__c,Allocated_Sprint__r.Start_Date__c,
                                                           Allocated_Sprint__r.End_Date__c,Development_Stage__c, Story_Points_Total__c 
                                                           From TRAK_User_Story__c where Allocated_Sprint__c =: sprintId];
              //US#41727                                            
              list<TRAK_Bug__c> defectList = [select Allocated_Sprint__c,Allocated_Sprint__r.Start_Date__c,
                                                           Allocated_Sprint__r.End_Date__c,Status__c, Story_Points_Total__c 
                                                           From TRAK_Bug__c where Allocated_Sprint__c =: sprintId];                                                          
              
              Decimal totalpoints = 0;
              
              for (TRAK_User_Story__c userStory : userStoryList ){
                   totalpoints = totalpoints + userStory.Story_Points_Total__c; 
              } 
              
              //US#41727
              for (TRAK_Bug__c defect : defectList ){
                   totalpoints = totalpoints + defect.Story_Points_Total__c; 
              }
                                                          
          
              // Query all the BurnDown records for the selected Sprint
              list<TRAK_BurnDown2__c> presentburnDown = [select Name, Date__c,Sprint__c from TRAK_BurnDown2__c where Sprint__c =: currentsprint.Id];
              
              // Putting the Date of Burndown object as key and BurnDown object as value
              for(TRAK_BurnDown2__c bDown : presentburnDown){
                  mapburnDown.put(bDown.Date__c , bDown);
              }
            
            //Lists of objects to insert and update
            list<TRAK_BurnDown2__c> burnDownlist = new list<TRAK_BurnDown2__c>();
            list<TRAK_BurnDown2__c> burndownsToUpdate = new list<TRAK_BurnDown2__c>();
            
               
              // Filtering the weekdays and creating BurnDown Objects only for Weekdays
              Integer j = 0; //days through sprint
              for (Integer i= 0 ; i <= numberDaysBet; i++ ){
                   Date tempstart = startdate.addDays(i);
                   Time myTime = Time.newInstance(0, 0, 0, 0);
                   DateTime dt = DateTime.newInstance(tempstart, myTime);
                   //DateTime dt = DateTime.newInstance(2015,01,01,01,01,01);
                   String day = dt.format('E');
                   //date weekStart = tempstart.toStartofWeek();
                   //integer dayOfWeek = weekStart.daysBetween(tempstart);
                   
                   // If selcted day is not Saturday and Sunday
                   if (day != 'Sat' && day != 'Sun'){
                        j = j + 1;
                        if(!(mapburnDown.containsKey(tempstart) && mapburnDown.get(tempstart).Sprint__c == currentsprint.id)){
                            //Create the new BurnDown Object with following Values
                            burndown = new TRAK_BurnDown2__c();
                            if(TRAK_BurnDown2__c.Name.getDescribe().isCreateable())
                                burndown.Name = currentsprint.Name +' Burndown';
                            if(TRAK_BurnDown2__c.Date__c.getDescribe().isCreateable())
                                burndown.Date__c = tempstart;
                          /*  if(TRAK_BurnDown2__c.Project__c.getDescribe().isCreateable())
                                burndown.Project__c = currentsprint.Project__r.Name; */
                            if(TRAK_BurnDown2__c.Sprint__c.getDescribe().isCreateable())
                                burndown.Sprint__c  = currentsprint.Id;
                            if(TRAK_BurnDown2__c.Sprint__c.getDescribe().isCreateable())    
                                burndown.Optimum_burndown__c = optimalBurndown(currentsprint, totalpoints, j);
                            // Add to the list
                            burnDownlist.add(burndown);
                        }else{
                            //Burndown object already exists
                            burndown = mapburnDown.get(tempstart);
                            if(TRAK_BurnDown2__c.Optimum_burndown__c.getDescribe().isUpdateable())
                                burndown.Optimum_burndown__c = optimalBurndown(currentsprint, totalpoints, j);
                            burndownsToUpdate.add(burndown);
                        }
                    } 
               }
               // Insert the list
               try{
                 if(TRAK_BurnDown2__c.SObjectType.getDescribe().isCreateable() && !burnDownlist.isEmpty())
                    insert burnDownlist;
                 if(TRAK_BurnDown2__c.SObjectType.getDescribe().isUpdateable() && !burndownsToUpdate.isEmpty())
                    update burndownsToUpdate;
               }
               catch(DMLException e) {
               } 
        }
                 
    /**
     * @description :- populates the burndown object with a row for each date within the sprint 
                       that is a working day (ie exclude weekends) with Optimum_burndown__c ,Current_velocity__c
                       ,Projected_burndown__c and Actual_burndown__c fields
     * @param :- Sprint Id
     **/  
       
    WebService static void updateSprintBurndown(String sprintId){ 
            list<TRAK_BurnDown2__c> updateburndown2List = new list<TRAK_BurnDown2__c>();   // Empty list to be updated later
            // Query All the User Story in the current Sprint
            list<TRAK_User_Story__c> userStoryList = [select Allocated_Sprint__c,Allocated_Sprint__r.Start_Date__c,Allocated_Sprint__r.Number_Working_Days_in_Sprint__c,
                                                           Allocated_Sprint__r.End_Date__c,Development_Stage__c, Story_Points_Total__c
                                                           From TRAK_User_Story__c where Allocated_Sprint__c =: sprintId and Allocated_Sprint__r.Status__c = 'In Progress'];
            
            //Query All the BurnDown Records in the Sprint selected
            list<TRAK_BurnDown2__c> burndown2List = [Select Actual_burndown__c,Current_velocity__c, 
                                                              Date__c,Optimum_burndown__c,/* Project__c,*/
                                                              Projected_burndown__c,Sprint__c ,Sprint__r.Working_Days_Through_Sprint__c,
                                                              Sprint__r.Number_Working_Days_in_Sprint__c,Sprint__r.End_Date__c 
                                                              From TRAK_BurnDown2__c where Sprint__c =: sprintId  and Sprint__r.Status__c = 'In Progress' Order by Date__c asc];
            
            map<Date, Integer> datemap = new map<Date, Integer>();
            Integer i = 0;
               
            // Adding the working days passed with the Date as the key to the map 
            for(TRAK_BurnDown2__c burndown : burndown2List){
                datemap.put(burndown.Date__c,i);
                i = i+1;
            }
              
            //Calculate totals
            Decimal totalcompletepoints = 0;
            Decimal totalpoints = 0;    
            for(TRAK_User_Story__c userStory : userStoryList ){
                // Calculate total complete points
                if (userStory.Development_Stage__c == System.Label.TRAK_User_Story_Burn_Status){
                    totalcompletepoints = totalcompletepoints + userStory.Story_Points_Total__c;
                }
                // Calculate TotalPoints
                totalpoints = totalpoints + userStory.Story_Points_Total__c ;
            }
            Decimal velocity = 0;
            Decimal actualburn = 0;
            Integer dayOfSprint = 0;
            Integer actualDayOfSprint = 0;         
            for(TRAK_BurnDown2__c burndown2 : burndown2List){ //looping in order of date ASC
                dayOfSprint++;
                if(date.today() == burndown2.Date__c){ //update actual burndown for today
                    actualburn = totalpoints - totalcompletepoints;
                    if(TRAK_BurnDown2__c.Actual_burndown__c.getDescribe().isUpdateable())
                        burndown2.Actual_burndown__c = actualburn;
                    if(TRAK_BurnDown2__c.Points_Complete__c.getDescribe().isUpdateable())
                        burndown2.Points_Complete__c = totalcompletepoints;
                    //work-around for graphing limits:
                    //We need to differentiate between ZERO and NULL. 
                    //When creating the summary graph, the sum of the nulls is incorrectly calculated as ZERO
                    //Step A: filter out the zeros from the graph
                    //Step B (here): fudge data so that zero is reported at 0.01, causing it to be graphed and showing the complete sprint
                    if(actualburn==0 && TRAK_BurnDown2__c.Actual_burndown__c.getDescribe().isUpdateable()){
                        burndown2.Actual_burndown__c = 0.01;
                    } 
                    
                    velocity = totalcompletepoints / dayOfSprint;
                    if(TRAK_BurnDown2__c.Current_velocity__c.getDescribe().isUpdateable())
                        burndown2.Current_velocity__c = (burndown2.Sprint__r.Working_Days_Through_Sprint__c != 0 ?(totalcompletepoints/(burndown2.Sprint__r.Working_Days_Through_Sprint__c)):0);
                    actualDayOfSprint = dayOfSprint;
                }
                    
                // Add the BurnDown record to the list
                updateburndown2List.add(burndown2);
            } 
                 
            // Update the list
            try{
                if(TRAK_BurnDown2__c.SObjectType.getDescribe().isUpdateable() && !updateburndown2List.isEmpty())
                    update  updateburndown2List;
            }catch(DMLException e) {
            }
        }
        
     /**
     * @description :- populates the test script burndown object with a row for each date within the sprint 
                       that is a working day (ie exclude weekends) with sprint name, date, 
                       and Total Test Scripts and Total Test Scripts approved.
     * @param :- Sprint Id
        */
     WebService static void generateTestScriptBurndown(String sprintId){
        
          // Query the Sprint object 
            TRAK_Sprint__c currentsprint = [select Name,Start_Date__c, End_Date__c,Number_Working_Days_in_Sprint__c /* ,Project__c ,
             Project__r.Name */ from TRAK_Sprint__c where id =: sprintId];

           list<date> datelist = new list<date>();
           
              
              // Local Variables 
              date startDate = currentsprint.Start_Date__c;
              date endDate   = currentsprint.End_Date__c;
              integer numberDaysBet = startDate.daysBetween(endDate);
              integer totalTestScripts = 0 ;
              integer totalTestScriptsApproved = 0 ;
              
              TRAK_Test_Script_Burndown_Stat__c testScriptburndown;
              Map<Date,TRAK_Test_Script_Burndown_Stat__c> maptestScriptburndown = new map<Date,TRAK_Test_Script_Burndown_Stat__c>();
              
              list<TRAk_Test_Templates__c> testScriptList = [select User_Story__r.Allocated_Sprint__c,User_Story__r.Allocated_Sprint__r.Start_Date__c,
                                                               User_Story__r.Allocated_Sprint__r.End_Date__c,Approval_Status__c
                                                               From TRAk_Test_Templates__c where User_Story__r.Allocated_Sprint__c =: sprintId];
                                                           
             // Query all the BurnDown records for the selected Sprint
              list<TRAK_Test_Script_Burndown_Stat__c> presentTestScriptburnDown = [select Name, Date__c,Sprint__c from TRAK_Test_Script_Burndown_Stat__c where Sprint__c =: currentsprint.Id];
              
               for (TRAk_Test_Templates__c testScript : testScriptList ){
                   if(testScript.Approval_Status__c == 'Approved'){
                    totalTestScriptsApproved = totalTestScriptsApproved + 1 ;
                   }
                   totalTestScripts = totalTestScripts + 1; 
              }    
              
              
              // Putting the Date of Burndown object as key and BurnDown object as value
              for(TRAK_Test_Script_Burndown_Stat__c bDown : presentTestScriptburnDown){
                  maptestScriptburndown.put(bDown.Date__c , bDown);
              } 
              
            //Lists of objects to insert and update
            list<TRAK_Test_Script_Burndown_Stat__c> testScriptburnDownlist = new list<TRAK_Test_Script_Burndown_Stat__c>();
            list<TRAK_Test_Script_Burndown_Stat__c> testScriptburndownsToUpdate = new list<TRAK_Test_Script_Burndown_Stat__c>(); 
            
             // Filtering the weekdays and creating BurnDown Objects only for Weekdays
              Integer j = 0; //days through sprint
              for (Integer i= 0 ; i <= numberDaysBet; i++ ){
                   Date tempstart = startdate.addDays(i);
                   date weekStart = tempstart.toStartofWeek();
                   integer dayOfWeek = weekStart.daysBetween(tempstart);
                   
                   // If selcted day is not Saturday and Sunday
                   if (dayOfWeek != 5 && dayOfWeek != 6){
                        j = j + 1;
                        if(!(maptestScriptburndown.containsKey(tempstart) && maptestScriptburndown.get(tempstart).Sprint__c == currentsprint.id)){
                            //Create the new BurnDown Object with following Values
                            testScriptburndown = new TRAK_Test_Script_Burndown_Stat__c();
                            if(TRAK_Test_Script_Burndown_Stat__c.Name.getDescribe().isUpdateable())
                                testScriptburndown.Name = currentsprint.Name +'Test Script Burndown';
                            if(TRAK_Test_Script_Burndown_Stat__c.Date__c.getDescribe().isUpdateable())
                                testScriptburndown.Date__c = tempstart;
                            if(TRAK_Test_Script_Burndown_Stat__c.Sprint__c.getDescribe().isUpdateable())
                                testScriptburndown.Sprint__c  = currentsprint.Id;
                            if(TRAK_Test_Script_Burndown_Stat__c.Total_Test_Scripts__c.getDescribe().isUpdateable())
                                testScriptburndown.Total_Test_Scripts__c = totalTestScripts;
                            // Add to the list
                            testScriptburnDownlist.add(testScriptburndown);
                        }else{
                            //Burndown object already exists
                            testScriptburndown = maptestScriptburndown.get(tempstart);
                            if(TRAK_Test_Script_Burndown_Stat__c.Total_Test_Scripts__c.getDescribe().isUpdateable())
                                testScriptburndown.Total_Test_Scripts__c = totalTestScripts;
                            testScriptburndownsToUpdate.add(testScriptburndown);
                        }
                    } 
               }
               // Insert the list
               try{
                if(TRAK_BurnDown2__c.SObjectType.getDescribe().isCreateable() && !testScriptburnDownlist.isEmpty())
                    insert testScriptburnDownlist;
                 if(TRAK_BurnDown2__c.SObjectType.getDescribe().isUpdateable() && !testScriptburndownsToUpdate.isEmpty())
                    update testScriptburndownsToUpdate;
                 
               }
               catch(DMLException e) {
               }
               
               try{
                updateTestScriptSprintBurndown(sprintId);
               } 
               catch(DMLException e) {
               } 
                                                       
         }
         
       /**
         * @description :- populates the burndown object with a row for each date within the sprint 
                           that is a working day (ie exclude weekends) with Total Test Scripts and 
                           Total Test Scripts approved fields
         * @param :- Sprint Id
         */ 
       WebService static void updateTestScriptSprintBurndown(String sprintId){ 
        
         list<TRAK_Test_Script_Burndown_Stat__c> updateTestScriptburndownList = new list<TRAK_Test_Script_Burndown_Stat__c>();   // Empty list to be updated later
         
         //Query The Test Script Object
         list<TRAk_Test_Templates__c> testScriptList = [select User_Story__r.Allocated_Sprint__c,User_Story__r.Allocated_Sprint__r.Start_Date__c,
                                                               User_Story__r.Allocated_Sprint__r.End_Date__c,Approval_Status__c
                                                               From TRAk_Test_Templates__c where User_Story__r.Allocated_Sprint__c =: sprintId and User_Story__r.Allocated_Sprint__r.Status__c = 'In Progress'];
                                                               
        //Query All the BurnDown Records in the Sprint selected
         list<TRAK_Test_Script_Burndown_Stat__c> presentTestScriptburnDown = [select Name, Date__c,Sprint__c,Total_Test_Script_Approved__c,Total_Test_Scripts__c from TRAK_Test_Script_Burndown_Stat__c where Sprint__c =: sprintId Order by Date__c asc];                                                       
         
         map<Date, Integer> datemap = new map<Date, Integer>();
            Integer i = 0;
               
            // Adding the working days passed with the Date as the key to the map 
            for(TRAK_Test_Script_Burndown_Stat__c burndown : presentTestScriptburnDown){
                datemap.put(burndown.Date__c,i);
                i = i+1;
            }
            
            //Calculate totals
           integer totalTestScripts = 0 ;
           integer totalTestScriptsApproved = 0 ;
           
            for (TRAk_Test_Templates__c testScript : testScriptList ){
                   if(testScript.Approval_Status__c == 'Approved'){
                    totalTestScriptsApproved = totalTestScriptsApproved + 1 ;
                   }
                   totalTestScripts = totalTestScripts + 1; 
              }
           
             
           for(TRAK_Test_Script_Burndown_Stat__c burndown : presentTestScriptburnDown){ //looping in order of date ASC
                if(date.today() == burndown.Date__c){ //update actual burndown for today
                    if(TRAK_Test_Script_Burndown_Stat__c.Total_Test_Scripts__c.getDescribe().isUpdateable())
                        burndown.Total_Test_Scripts__c = totalTestScripts;
                    if(TRAK_Test_Script_Burndown_Stat__c.Total_Test_Script_Approved__c.getDescribe().isUpdateable())
                        burndown.Total_Test_Script_Approved__c = totalTestScriptsApproved;
                }
                updateTestScriptburndownList.add(burndown);
           }
           
           try{
             if(TRAK_BurnDown2__c.SObjectType.getDescribe().isUpdateable() && !updateTestScriptburndownList.isEmpty())
                update  updateTestScriptburndownList;
            }catch(DMLException e) {
            }
               
              
       } 
     
   }