/****************************************************************************************************************************************** 
* Class Name   : automateBoornDown
* Description  : This is a class that will both create the initial burndown records + updated them when user stories are closed    
* Created By   : Deloitte Consulting
* 
*****************************************************************************************************************************************/

Global class TRAK_automateBurnDown {    
             
          
    /**
     * @description :- populates the burndown object with a row for each date within the sprint 
                       that is a working day (ie exclude weekends) with Optimum_burndown__c ,Current_velocity__c
                       ,Projected_burndown__c and Actual_burndown__c fields
     * @param :- Sprint Id
     **/  
       
    public static void updateSprintBurndown(list<TRAK_Sprint__c> activeSprints){   
        //    system.debug('entered sprint burndown = '+activeSprints.size());
        //    system.debug(activeSprints);
            Map<id,List<TRAK_User_Story__c>> currentSprintUS = new Map<id,List<TRAK_User_Story__c>>();
            Map<id,List<TRAK_BurnDown2__c>> currentSprintBD = new Map<id,List<TRAK_BurnDown2__c>>();
            
            //US#41727 
            Map<id,List<TRAK_Bug__c>> currentSprintDefects = new Map<id,List<TRAK_Bug__c>>();

            list<TRAK_BurnDown2__c> updateburndown2List = new list<TRAK_BurnDown2__c>();   // Empty list to be updated later
            
            // Query All the User Story in the current Sprint
            list<TRAK_User_Story__c> lstUserStory = [select Allocated_Sprint__c,Allocated_Sprint__r.Start_Date__c,Allocated_Sprint__r.Number_Working_Days_in_Sprint__c,
                                                           Allocated_Sprint__r.End_Date__c,Development_Stage__c, Story_Points_Total__c
                                                           From TRAK_User_Story__c where Allocated_Sprint__c =: activeSprints and Allocated_Sprint__r.Status__c = 'In Progress'];
            
          //  System.debug('!!!!!!! US LENGTH = '+lstUserStory.size());
            for(TRAK_User_Story__c us : lstUserStory){
                if(!currentSprintUS.containsKey(us.Allocated_Sprint__c)){
                    currentSprintUS.put(us.Allocated_Sprint__c, new List<TRAK_User_Story__c>() );
                }
                currentSprintUS.get(us.Allocated_Sprint__c).add(us);               
            }
          //  System.debug('!!!!!!! US MAP LENGTH = '+currentSprintUS.size());

            //Query All the BurnDown Records in the Sprint selected
            list<TRAK_BurnDown2__c> lstBurndown = [Select Actual_burndown__c,Current_velocity__c, 
                                                              Date__c,Optimum_burndown__c,Project__c,
                                                              Projected_burndown__c,Sprint__c ,Sprint__r.Working_Days_Through_Sprint__c,
                                                              Sprint__r.Number_Working_Days_in_Sprint__c,Sprint__r.End_Date__c 
                                                              From TRAK_BurnDown2__c where Sprint__c =: activeSprints and Sprint__r.Status__c = 'In Progress' Order by Date__c asc];
            
         //   System.debug('!!!!!!! BURNDOWN LENGTH = '+lstBurndown.size());
                        
            for(TRAK_BurnDown2__c bd : lstBurndown){
                if(!currentSprintBD.containsKey(bd.Sprint__c)){
                    currentSprintBD.put(bd.Sprint__c, new List<TRAK_BurnDown2__c>() );
                }
                currentSprintBD.get(bd.Sprint__c).add(bd);                
            }
        //    System.debug('!!!!!!! BD MAP LENGTH = '+currentSprintBD.size());

            //US#41727 
            //Query All the Defects Records in the Sprint selected
            list<TRAK_Bug__c> lstDefects = [select Allocated_Sprint__c,Allocated_Sprint__r.Start_Date__c,Allocated_Sprint__r.Number_Working_Days_in_Sprint__c,
                                                           Allocated_Sprint__r.End_Date__c,Sprint__c,Status__c, Story_Points_Total__c
                                                           From TRAK_Bug__c where Allocated_Sprint__c =: activeSprints and Allocated_Sprint__r.Status__c = 'In Progress'];

        //    System.debug('!!!!!!! DEFECT LENGTH = '+lstDefects.size());

            for(TRAK_Bug__c defect : lstDefects){
                if(!currentSprintDefects.containsKey(defect.Allocated_Sprint__c)){
                    currentSprintDefects.put(defect.Allocated_Sprint__c, new List<TRAK_Bug__c>() );
                }
                currentSprintDefects.get(defect.Allocated_Sprint__c).add(defect);                
            }
        //    System.debug('!!!!!!! DEFECT MAP LENGTH = '+currentSprintDefects.size());
             list<TRAK_BurnDown2__c> burndown2List;
             list<TRAK_User_Story__c> userStoryList;
             list<TRAK_Bug__c> defectsList;
            for(TRAK_Sprint__c sprint : activeSprints){
              //  System.debug('!!!!!!! burndown2List  = '+currentSprintBD.get(sprint.id));                           
                burndown2List = (currentSprintBD.get(sprint.id)!=null?currentSprintBD.get(sprint.id):new list<TRAK_BurnDown2__c>());
             //   System.debug('!!!!!!! burndown2List  = '+burndown2List.size());
                userStoryList = (currentSprintUS.get(sprint.id)!=null?currentSprintUS.get(sprint.id):new list<TRAK_User_Story__c>());
                
                //US#41727 
                defectsList = (currentSprintDefects.get(sprint.id)!=null?currentSprintDefects.get(sprint.id):new list<TRAK_Bug__c>());

                if(burndown2List.size() > 0 && userStoryList.size() > 0){
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


                    //US#41727 
                    Set<String> DefectClosedStatuses = new Set<String>();
                    DefectClosedStatuses.addAll(System.Label.TRAK_Defects_Status_Closed_Complete.split(','));
                    for (TRAK_Bug__c defect : defectsList){
                        // Calculate total complete points
                        if (DefectClosedStatuses.contains(defect.Status__c)){
                            totalcompletepoints = totalcompletepoints + defect.Story_Points_Total__c;
                        }
                        // Calculate TotalPoints
                        totalpoints = totalpoints + defect.Story_Points_Total__c ;
                    }
            //        system.debug('++!'+DefectClosedStatuses.size());
                    Decimal velocity = 0;
                    Decimal actualburn = 0;
                    Integer dayOfSprint = 0;
                    Integer actualDayOfSprint = 0;         
                    for(TRAK_BurnDown2__c burndown2 : burndown2List){ //looping in order of date ASC
                        dayOfSprint++;
                        if(date.today() == burndown2.Date__c){ //update actual burndown for today
                            actualburn = totalpoints - totalcompletepoints;
                            burndown2.Actual_burndown__c = actualburn;
                            burndown2.Points_Complete__c = totalcompletepoints;
                            //work-around for graphing limits:
                            //We need to differentiate between ZERO and NULL. 
                            //When creating the summary graph, the sum of the nulls is incorrectly calculated as ZERO
                            //Step A: filter out the zeros from the graph
                            //Step B (here): fudge data so that zero is reported at 0.01, causing it to be graphed and showing the complete sprint
                            if(actualburn==0){
                                burndown2.Actual_burndown__c = 0.01;
                            } 
                            if(dayOfSprint <> 0)
                                velocity = totalcompletepoints / dayOfSprint;
                            if(burndown2.Sprint__r.Working_Days_Through_Sprint__c <> null && burndown2.Sprint__r.Working_Days_Through_Sprint__c <> 0)
                                burndown2.Current_velocity__c = totalcompletepoints/(burndown2.Sprint__r.Working_Days_Through_Sprint__c);
                            actualDayOfSprint = dayOfSprint;
                        }
                            
                        // Add the BurnDown record to the list
                        updateburndown2List.add(burndown2);
                    } 
                }
            }
                 
            // Update the list
            try{
                update  updateburndown2List;
               // system.debug('updating burndown2 list... = '+updateburndown2List.size());
            }catch(DMLException e) {
                system.debug('error in updating burndown2 list...  '+e);
            }
        }
        
         
       
     
   }