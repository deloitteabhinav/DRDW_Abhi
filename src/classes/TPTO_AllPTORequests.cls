public with sharing class TPTO_AllPTORequests {
    
    public TPTO_PTO_Request__c ptoReq;
    public List<TPTO_PTO_Request__c> allReq{get;set;}
    public Boolean displayPTO {get;set;}
     
    public TPTO_AllPTORequests(ApexPages.StandardController controller){ 
        displayPTO = false;
        try{
        
            List<String> fieldNames = new List<String>{'Start_Date__c','End_Date__c','Status__c','Type_of_absence__c'};
            if (!Test.isRunningTest()) {
                controller.addFields(fieldNames);
            } else {
                TPTO_PTO_Request__c pto = new TPTO_PTO_Request__c();
                pto.Start_Date__c = system.today() + 14;
                pto.End_Date__c = system.today() + 16;
                pto.Type_of_Absence__c = 'Vacation';
                pto.Lead__c = userinfo.getuserid();
                pto.BA__c = userinfo.getuserid();
                pto.Absence_Comments__c = 'Test';
                pto.Status__c = 'Draft';
            }
            ptoReq = (TPTO_PTO_Request__c)controller.getRecord();
            
            allReq = [Select Name,Start_Date__c,End_Date__c,Status__c,Type_of_absence__c,Owner.Name from TPTO_PTO_Request__c where  ((Start_Date__c >=: ptoReq.Start_Date__c and Start_Date__c <=: ptoReq.end_date__C) or  (end_date__c >=: ptoReq.Start_Date__c and end_date__c <=: ptoReq.end_date__C)) and id !=: ptoReq.id AND Status__c != 'Draft' order by Start_Date__c DESC ];
            
            if(allReq.size() > 0){
                displayPTO = true;
            } /*else {
                displayPTO = false;
            } */
            
        } catch (Exception e){
            system.debug('-----exception message--' + e.getMessage() + e.getLineNumber());
        }
    }
    
    
}