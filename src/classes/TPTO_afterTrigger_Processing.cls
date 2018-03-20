/**
* TPTO_afterTrigger_Processing 
* This class is used to create task, to automate submit for approval 
* and to throw a validation if a user creates a pto with intersecting  
* Author(s):  Deloitte ( Nisha C O )
*/
public with sharing class TPTO_afterTrigger_Processing {
    
    public static void intersectingPTO(List<TPTO_PTO_Request__c> triggerNew){
         
         Set<Id> sPTORequestorIds = new Set<Id>();
         Map<Id,List<TPTO_PTO_Request__c>> mOtherPTORequests = new Map<Id,List<TPTO_PTO_Request__c>>();
         
        try{
             for(TPTO_PTO_Request__c pto: triggerNew){
                 sPTORequestorIds.add(pto.createdbyid);
             }   
    
             
             
            for(TPTO_PTO_Request__c oRequest :  [Select Owner.Name, Id, Name, Start_Date__c, End_Date__c, createdbyid from TPTO_PTO_Request__c where createdbyid IN : sPTORequestorIds AND (Status__c = 'Submitted' OR Status__c = 'Approved') and ID not in : trigger.new]){
              
              if(mOtherPTORequests.containsKey(oRequest.createdbyid)){
                mOtherPTORequests.get(oRequest.createdbyid).add(oRequest);
              }
              else{
                mOtherPTORequests.put(oRequest.createdbyid, new List<TPTO_PTO_Request__c>{oRequest});
              }
            
            }

            UserRole ur = [select PortalType from UserRole where id =: userinfo.getUserroleid()];

            //Perform Check
            for(TPTO_PTO_Request__c newPTO: triggerNew){
              
              if(mOtherPTORequests.containsKey(newPTO.createdbyid)){

                for(TPTO_PTO_Request__c oldPTO : mOtherPTORequests.get(newPTO.createdbyid)){
                  
                  if(newPTO.Start_Date__c <= oldPTO.End_Date__c && newPTO.Start_Date__c >= oldPTO.Start_Date__c){
                    
                      if(ur.PortalType == 'Partner'){      
                          newPTO.addError('You already have conflicting PTO Requests on this date - <a href="'+system.URL.getSalesforceBaseUrl().toExternalForm() +'/releasetracker/'+ oldPTO.id+'" target="_blank">Click Here</a>', false);
                      }
                    else {
                        newPTO.addError('You already have conflicting PTO Requests on this date - <a href="'+system.URL.getSalesforceBaseUrl().toExternalForm() +'/'+ oldPTO.id+'" target="_blank">Click Here</a>', false);
                    }
                  }
                
                }

              }            

            }
            
       } catch (Exception e){
            system.debug('---exception message--' + e.getMessage() + e.getLineNumber());
       } 
       
    } 
    
}