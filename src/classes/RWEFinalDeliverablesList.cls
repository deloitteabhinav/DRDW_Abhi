/****************************************************************************************************************************************** 
* Class Name   : RWEFinalDeliverablesList 
* Description  : Class to get the List of Contents associated to a Request Record
* Created By   : Deloitte Consulting
* 
*****************************************************************************************************************************************/
public with sharing class RWEFinalDeliverablesList {
    private List<ContentVersion> cdRequest;
    private List<ContentVersion> cdStudy;
    private List<ContentVersion> cdAsset;
    Public Map<Id,String> mLibraryNameStoredInMap {get;set;}
    private Id recId;
    public RWEFinalDeliverablesList(ApexPages.StandardController controller) {
        this.recId= (Id)controller.getId();
    }
    /* 
    * @Method Name                    :  getcdRequest
    * @Description                    :  Getting the List of Contents for a Request Record 
    * @Return Type                    :  List
    * @Parameters                     :  None
    */     
    public List<ContentVersion> getcdRequest()
    {   
        
        if (recId== null)
        return null;
        mLibraryNameStoredInMap = new Map<Id,String>();
        
        Integer rowsLimits = Limits.getLimitQueryRows() - Limits.getQueryRows();
        //Querying the ContentVersion Object to get the Content Details of a Request Record
        cdRequest = [Select Id, Title, CreatedDate, ContentModifiedDate, ContentDocumentId ,Document_Type__c,FirstPublishLocation.Name, Owner.Name from ContentVersion where Request__c = :recId AND IsLatest = TRUE ORDER BY FirstPublishLocation.Name,Document_Type__c LIMIT :rowsLimits];
        for(ContentVersion oContent : cdRequest){
            mLibraryNameStoredInMap.put(oContent.ContentDocumentId,null);
        }
        
        for(ContentWorkspaceDoc  oWorkSpaceDoc : [SELECT ContentDocument.Id, ContentWorkspace.name FROM ContentWorkspaceDoc where ContentDocument.Id In : mLibraryNameStoredInMap.keyset() ])
            mLibraryNameStoredInMap.put(oWorkSpaceDoc.ContentDocument.Id,oWorkSpaceDoc.ContentWorkspace.name);
        return cdRequest;
    }
    
    /* 
    * @Method Name                    :  getcdStudy
    * @Description                    :  Getting the List of Contents for a Study Record 
    * @Return Type                    :  List
    * @Parameters                     :  None
    */     
    public List<ContentVersion> getcdStudy()
    {   
        
        if (recId== null)
        return null;
        mLibraryNameStoredInMap = new Map<Id,String>();
        Integer rowsLimits = Limits.getLimitQueryRows() - Limits.getQueryRows();
        //Querying the ContentVersion Object to get the Content Details of a Study Record
        cdStudy = [Select Id, Title, CreatedDate, ContentModifiedDate, ContentDocumentId,Document_Type__c,FirstPublishLocation.Name, Owner.Name from ContentVersion where Project__c = :recId AND IsLatest = TRUE ORDER BY FirstPublishLocation.Name,Document_Type__c LIMIT :rowsLimits];
        for(ContentVersion oContent : cdStudy){
            mLibraryNameStoredInMap.put(oContent.ContentDocumentId,null);
        }
        
        for(ContentWorkspaceDoc  oWorkSpaceDoc : [SELECT ContentDocument.Id, ContentWorkspace.name FROM ContentWorkspaceDoc where ContentDocument.Id In : mLibraryNameStoredInMap.keyset() ])
            mLibraryNameStoredInMap.put(oWorkSpaceDoc.ContentDocument.Id,oWorkSpaceDoc.ContentWorkspace.name);
        
        return cdStudy;
    }
    
    /* 
    * @Method Name                    :  getcdAsset
    * @Description                    :  Getting the List of Contents for a Asset Record 
    * @Return Type                    :  List
    * @Parameters                     :  None
    */   
    
    public List<ContentVersion> getcdAsset()
    {   
        
        if (recId== null)
        return null;
        mLibraryNameStoredInMap = new Map<Id,String>();
        Integer rowsLimits = Limits.getLimitQueryRows() - Limits.getQueryRows();
        //Querying the ContentVersion Object to get the Content Details of a Asset Record
        cdAsset = [Select Id, Title, CreatedDate, ContentModifiedDate, ContentDocumentId,Document_Type__c,FirstPublishLocation.Name, Owner.Name from ContentVersion where  Data_Asset__c = :recId AND IsLatest = TRUE ORDER BY FirstPublishLocation.Name,Document_Type__c LIMIT :rowsLimits];
        for(ContentVersion oContent : cdAsset){
            mLibraryNameStoredInMap.put(oContent.ContentDocumentId,null);
        }
        
        for(ContentWorkspaceDoc  oWorkSpaceDoc : [SELECT ContentDocument.Id, ContentWorkspace.name FROM ContentWorkspaceDoc where ContentDocument.Id In : mLibraryNameStoredInMap.keyset() ])
            mLibraryNameStoredInMap.put(oWorkSpaceDoc.ContentDocument.Id,oWorkSpaceDoc.ContentWorkspace.name);
        
        
        return cdAsset;
    }
    
     /* 
    * @Method Name                    :  RequestPage
    * @Description                    :  Calls the get cdrequest method
    * @Return Type                    :  pageReference 
    * @Parameters                     :  None
    */   
    public pageReference RequestPage()
    {
        getcdRequest();
        return null;
    } 

     /* 
    * @Method Name                    :  StudyPage
    * @Description                    :  Calls the get cdstudy method
    * @Return Type                    :  pageReference 
    * @Parameters                     :  None
    */   
    public pageReference StudyPage()
    {
        getcdStudy();
        return null;
    }
    
         /* 
    * @Method Name                    :  AssetPage
    * @Description                    :  Calls the get cdasset method
    * @Return Type                    :  pageReference 
    * @Parameters                     :  None
    */ 
    public pageReference AssetPage()
    {
        getcdAsset();
        return null;
    }   
}