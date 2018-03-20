Public with Sharing Class ExecutiveDashboardTest{

    @RemoteAction
    Public static List<wDashboardJSON> GenerateJSON(String sTA){
        List<wDashboardJSON> lwDashboardJSON = new List<wDashboardJSON>();
        Map<String,wDashboardJSON> mPVA = new Map<String,wDashboardJSON>();
        
        String sDynamicQuery = 'Select COUNT (ID) CT , Primary_Value_Area__c PV , Project_Status__c PS from Project__c WHERE Therapeutic_Area_Primary__c != NULL AND (Anticipated_Start_Date__c = THIS_YEAR OR Anticipated_Start_Date__c = NEXT_YEAR) AND (Project_Status__c = '+ '\'Active\'' +' OR Project_Status__c = '+ '\'Approved\'' +' OR Project_Status__c = '+ '\'Completed\''+ ' OR Project_Status__c = '+ '\'Closed\'' +')  GROUP BY Primary_Value_Area__c , Project_Status__c';
        
        If(sTA != NULL && sTA != '' && sTA != 'All Therapeutic Areas'){
            sDynamicQuery  = 'Select COUNT (ID) CT , Primary_Value_Area__c PV , Project_Status__c PS from Project__c WHERE Therapeutic_Area_Primary__c =: sTA AND (Anticipated_Start_Date__c = THIS_YEAR OR Anticipated_Start_Date__c = NEXT_YEAR) AND(Project_Status__c = '+ '\'Active\'' +' OR Project_Status__c = '+ '\'Approved\'' +' OR Project_Status__c = '+ '\'Completed\''+ ' OR Project_Status__c = '+ '\'Closed\'' +')  GROUP BY Primary_Value_Area__c , Project_Status__c';
        }
        
        For(AggregateResult ar: DataBase.Query(sDynamicQuery)){
             If(String.valueOf(ar.get('PV')) != NULL && String.valueOf(ar.get('PV')) != '' ) {
                 wDashboardJSON oJSON;
                 If(mPVA.containsKey(String.valueOf(ar.get('PV')))){
                     oJSON = mPVA.get(String.valueOf(ar.get('PV')));
                     oJSON.value = oJSON.value + Integer.valueOf(ar.get('CT'));
                 }
                 Else{
                     oJSON = new wDashboardJSON(); 
                     oJSON.value = Integer.valueOf(ar.get('CT'));
                 }
                 
                 oJSON.label = String.valueOf(ar.get('PV'));

                 If(String.valueOf(ar.get('PV')) == 'Access & Reimbursement'){
                     oJSON.color = '#4c6a8d';
                 }
                 If(String.valueOf(ar.get('PV')) == 'Drug/Clinical Development'){
                     oJSON.color = '#099da9';
                 }
                 If(String.valueOf(ar.get('PV')) == 'Safety & Risk Management'){
                     oJSON.color = '#f8555e';
                 }
                 If(String.valueOf(ar.get('PV')) == 'Commercial/Marketing'){
                     oJSON.color = '#2db982';
                 }
                 If(String.valueOf(ar.get('PV')) == 'Medical Customer Support'){
                     oJSON.color = '#fbc38d';
                 }
                 
                 If(String.valueOf(ar.get('PS')) == 'Active'){
                     oJSON.active = Integer.valueOf(ar.get('CT'));
                 }
                 If(String.valueOf(ar.get('PS')) == 'Approved'){
                     oJSON.approved = Integer.valueOf(ar.get('CT'));
                 }
                 If(String.valueOf(ar.get('PS')) == 'Completed'){
                     oJSON.completed = Integer.valueOf(ar.get('CT'));
                 }
                 If(String.valueOf(ar.get('PS')) == 'Closed'){
                    oJSON.closed = Integer.valueOf(ar.get('CT'));
                 }
                 
                 mPVA.put(String.valueOf(ar.get('PV')),oJSON);
             }
        }
        
        For(String s : mPVA.keySet()){
            wDashboardJSON oJSON = new wDashboardJSON();
            oJSON = mPVA.get(s);
            If(oJSON.active == NULL){
              oJSON.active = 0;  
            }
            If(oJSON.approved == NULL){
              oJSON.approved = 0;  
            }
            If(oJSON.completed == NULL){
              oJSON.completed = 0;  
            }
            If(oJSON.closed == NULL){
              oJSON.closed = 0;  
            }
            oJSON.completed = oJSON.completed + oJSON.closed;
            lwDashboardJSON.add(oJSON);
        }
        
        return lwDashboardJSON;
    }
    
    Public class wDashboardJSON{
      Public String label;
      Public Integer value;
      Public String color;
      Public Integer active;
      Public Integer completed;
      Public Integer approved;
      Public Integer closed;
    }

}