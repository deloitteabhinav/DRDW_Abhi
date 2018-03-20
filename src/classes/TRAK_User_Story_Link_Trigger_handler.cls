public with sharing class TRAK_User_Story_Link_Trigger_handler{
    
    public static boolean isHandlerRun = false;
    
    public static void createMirror(List<TRAK_User_Story_Link__c> lstUserStoryLinks){
        if(!isHandlerRun){
            isHandlerRun = true;
            List<TRAK_User_Story_Link__c> lstMirrorRecords = new List<TRAK_User_Story_Link__c>();
            TRAK_User_Story_Link__c mirrorRec;
            for(TRAK_User_Story_Link__c userStoryLink : lstUserStoryLinks){
                mirrorRec = new TRAK_User_Story_Link__c();
                mirrorRec.User_Story__c = userStoryLink.User_Story_Related__c;
                mirrorRec.User_Story_Related__c = userStoryLink.User_Story__c;
                mirrorRec.User_Story_Link_Type__c = userStoryLink.User_Story_Link_Type__c;
                lstMirrorRecords.add(mirrorRec);
            }
            if(lstMirrorRecords.size()>0){
                Database.SaveResult[] srList = Database.insert(lstMirrorRecords, false);
                for(Integer i = 0; i<lstMirrorRecords.size(); i++){
                    if (!srList[i].isSuccess()){
                        lstUserStoryLinks[i].addError(Label.TRAK_generic_error_message);    
                    }
                }
            }
        }
    }
    
    public static void deleteMirror(List<TRAK_User_Story_Link__c> lstUserStoryLinks){
        if(!isHandlerRun){
            isHandlerRun = true;
            Set<Id> setMasterIds = new Set<Id>();  
            Set<Id> setLookupIds = new Set<Id>();         
            for(TRAK_User_Story_Link__c userStoryLink : lstUserStoryLinks){
                setMasterIds.add(userStoryLink.User_Story__c);
                setLookupIds.add(userStoryLink.User_Story_Related__c);
            }
            
            if(setMasterIds.size()>0 && setLookupIds.size()>0){
                List<TRAK_User_Story_Link__c> lstRecordsToDelete = [Select id from TRAK_User_Story_Link__c 
                                                                    where User_Story__c in : setLookupIds 
                                                                    and User_Story_Related__c in : setMasterIds];
                if(lstRecordsToDelete.size()>0){
                    Database.DeleteResult[] drList = Database.delete(lstRecordsToDelete, false);
                    for(Integer i = 0; i<lstRecordsToDelete.size(); i++){
                        if (!drList[i].isSuccess()){
                            lstRecordsToDelete[i].addError(Label.TRAK_generic_error_message);    
                        }
                    }
                }
            }
        }
    }
    
    public static void updateMirror(List<TRAK_User_Story_Link__c> lstUserStoryLinks , Map<Id,TRAK_User_Story_Link__c> oldMap){
        if(!isHandlerRun){
            List<TRAK_User_Story_Link__c> lstUserStoryLinksToInsert = new List<TRAK_User_Story_Link__c>();
            List<TRAK_User_Story_Link__c> lstUserStoryLinksToDelete = new List<TRAK_User_Story_Link__c>();
            for(TRAK_User_Story_Link__c userStoryLink : lstUserStoryLinks){
                if(userStoryLink.User_Story_Related__c != oldMap.get(userStoryLink.id).User_Story_Related__c){
                    lstUserStoryLinksToInsert.add(userStoryLink); 
                    lstUserStoryLinksToDelete.add(oldMap.get(userStoryLink.id));   
                }   
            }
            
            if(lstUserStoryLinksToDelete.size()>0){
                isHandlerRun = false;
                deleteMirror(lstUserStoryLinksToDelete);
            }
            if(lstUserStoryLinksToInsert.size()>0){
                isHandlerRun = false;
                createMirror(lstUserStoryLinksToInsert);
            }
            isHandlerRun = true;
        }
    }
}