/****************************************************************************************************************************************** 
* Class Name   : TPOList 
* Description  : Class to get the List of TPO Location records
* Created By   : Deloitte Consulting
* 
*****************************************************************************************************************************************/
 Public with sharing class TPOList 
{

    Public ApexPages.StandardSetController cLocationListCntlr 
    {
        get;
        set;
    }
    Public string sField 
    {
        get;
        set;
    }
    Public string sSearchWord 
    {
        get;
        set;
    }
    Public string sOrder 
    {
        get;
        set;
    }
    Public Map < String, Integer > mCategoyCount 
    {
        get;
        set;
    }
    Public List < Integer > lPageNumbers 
    {
        get;
        private set;
    }
    Public Integer iPageNumber 
    {
        get;
        set;
    }
    Public Map < String, List < wLocationObject >> mLocationObjectStructure 
    {
        get;
        set;
    }
    public Integer pNoLimit 
    {
        get;
        set;
    }
    public Decimal dPageCount 
    {
        get;
        set;
    }
    public string previousSField 
    {
        get;
        set;
    }
   /* 
     * @Method Name                    :  getLocations
     * @Description                    :  Initialize cLocationListCntlr and return a list of records
     * @Return Type                    :  list of Location records
     * @Parameters                     :  None
     */
    Public List < TPO_Location__c > getLocations() {
        return (List < TPO_Location__c > ) cLocationListCntlr.getRecords();
    }

    //Loading the Constructor for the Location List page     
    Public TPOList() 
    {
            pNoLimit = 20;
            // Initialisation 
            sField = 'Name';
            previousSField = 'Name';
            sOrder = 'ASC NULLS FIRST';
            mLocationObjectStructure = new Map < String, List < wLocationObject >> ();

            // Methods for call
            DescribeObjectWithDetails();
            Query(string.escapeSingleQuotes(sField) + ' ' + string.escapeSingleQuotes(sOrder));

      }
    /* 
    * @Method Name                    :  DescribeObjectWithDetails
    * @Description                    :  This method populates the filtering fields on the UI page 
    * @Return Type                    :  void
    * @Parameters                     :  None
    */ 
    Public Void DescribeObjectWithDetails() 
    {
        List < wLocationObject > lPicklist = new List < wLocationObject > ();
              
        mCategoyCount = new Map < String, Integer > ();

        // Not using global describe which is taking longer time, hence hardcoding the field for describe 
        
        lPicklist = new List < wLocationObject > ();
        List<wLocationObject> lPickList2 = new List<wLocationObject>();
        Integer countCapabiliities = 0;
        for (Schema.Picklistentry oPicklistValues: TPO_Location__c.Capabiliities__c.getDescribe().getPicklistValues()) 
        {
            if(countCapabiliities ==0)
            {
            lPicklist.add(new wLocationObject(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
            countCapabiliities =1;
            }else if(countCapabiliities ==1)
            {
            lPicklist2.add(new wLocationObject(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
            countCapabiliities =0;
            }
        }
        mLocationObjectStructure.put('Capabiliities__c', lPicklist);
        mLocationObjectStructure.put('Capabiliities__c2', lPicklist2);
        
        lPicklist = new List < wLocationObject > ();
        for (Schema.Picklistentry oPicklistValues: TPO_Location__c.Status__c.getDescribe().getPicklistValues()) 
        {
            lPicklist.add(new wLocationObject(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mLocationObjectStructure.put('Status__c', lPicklist);
        
        lPicklist = new List < wLocationObject > ();
        for (Schema.Picklistentry oPicklistValues: TPO_Location__c.TPO_Classification__c.getDescribe().getPicklistValues()) 
        {
            lPicklist.add(new wLocationObject(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mLocationObjectStructure.put('TPO_Classification__c', lPicklist);
        
    }

    /* 
    * @Method Name                    :  FrameClause
    * @Description                    :  This method constructs the query clause if check boxes are checked on UI 
    * @Return Type                    :  string
    * @Parameters                     :  List of wLocationObject
    */
    Public string FrameClause(List < wLocationObject > lWrapperForProcessing) 
    {
        String sClause = '';

        for (wLocationObject oWrapper: lWrapperForProcessing)
         {
            if (oWrapper.isSelected) 
            {
                sClause += '\'' + oWrapper.label + '\',';
            }
         }
        if (sClause != '') 
        {
            sClause = '(' + sClause.removeend(',') + ')';
        }
        return sClause;
    }
    
    /* 
    * @Method Name                    :  CombineQuery
    * @Description                    :  This method combines all query clauses generated in FrameClause() method 
    * @Return Type                    :  string
    * @Parameters                     :  string and list of strings
    */

   public String CombineQuery(String sPrefix, List < String > sClauses)
    {
        List < String > sCombineClause = new List < String > ();
        for (String sClause: sClauses) 
        {
            if (sClause != null && sClause != '')
                sCombineClause.add(sClause);
        }
        if (sCombineClause.size() > 0)
            return ' ' + sPrefix + ' ' + string.join(sCombineClause, ' AND ');
        return '';
    }

    /* 
    * @Method Name                    :  Query
    * @Description                    :  This method queries the data base and displays the results on UI 
    * @Return Type                    :  void
    * @Parameters                     :  String sOrder
    */
    Public void Query(String sOrder) 
    {
        String sCapabiliitiesClause = '';
        String sCapabiliitiesClause2= '';
        String sStatusClause = '';
        String sClassificationClause = '';
        String sSearchClause = '';
        
        List < TPO_Location__c > lSearchWordProjects = new List < TPO_Location__c > ();
        
        
        sCapabiliitiesClause = FrameClause(mLocationObjectStructure.get('Capabiliities__c'));
        if(sCapabiliitiesClause!='')
        {
            sCapabiliitiesClause = 'Capabiliities__c includes ' + sCapabiliitiesClause;
        }
       
        sCapabiliitiesClause2 = FrameClause(mLocationObjectStructure.get('Capabiliities__c2')); 
        if(sCapabiliitiesClause2!='')
        {
            sCapabiliitiesClause2  = 'Capabiliities__c includes' + sCapabiliitiesClause2; 
        }
     
        sStatusClause = FrameClause(mLocationObjectStructure.get('Status__c'));
        if (sStatusClause != '') 
        {
            sStatusClause = ' Status__c IN  ' + sStatusClause ;
        }
      
        sClassificationClause = FrameClause(mLocationObjectStructure.get('TPO_Classification__c'));
        if (sClassificationClause != '') 
        {
            sClassificationClause = ' TPO_Classification__c IN  ' + sClassificationClause ;
        }
        

        if (sSearchWord != null && sSearchWord.trim() != '') 
        {
            sSearchClause = ' Id IN : lSearchWordProjects';
        }

        if (sSearchWord != null && sSearchWord.trim() != '') 
        {                
            List < List < sObject >> lDynamicSearchResult = search.query('FIND \'' + string.escapeSingleQuotes(sSearchWord) + '\' IN ALL FIELDS RETURNING TPO_Location__c (Id,Name,TPO_Approval_Type__c, Overall_Rating_Experience_Stars_Number__c ,Capabiliities__c, Status__c, Country__r.Name' + CombineQuery('WHERE', new List < String > {
                sCapabiliitiesClause,sCapabiliitiesClause2,sClassificationClause,sStatusClause 
              }) + ' ORDER BY ' + sOrder +')');
            lSearchWordProjects = lDynamicSearchResult[0];
            cLocationListCntlr = new ApexPages.StandardSetController(lDynamicSearchResult[0]);
        } 
        else 
        {
            cLocationListCntlr = new ApexPages.StandardSetController(Database.getQueryLocator(
                'SELECT Name,TPO_ID__c,Country__r.Name,Capabiliities__c,TPO_Approval_Type__c , Overall_Rating_Experience_Stars_Number__c  ,Status__c,Location__c FROM TPO_Location__c ' + CombineQuery('WHERE', new List < String > {
                    sCapabiliitiesClause,sCapabiliitiesClause2,sSearchClause,sClassificationClause,sStatusClause 
                }) + ' ORDER BY ' + sOrder));
                
                
        }

        cLocationListCntlr.setPageSize(50);
        lPageNumbers = new List < Integer > ();
        dPageCount = 0;
        dPageCount = (decimal.valueof(cLocationListCntlr.getResultSize()) / decimal.valueof(cLocationListCntlr.getPageSize()));
        dPageCount = dPageCount.round(System.RoundingMode.UP);

        for (Integer i = 1; i <= dPageCount; i++) 
        {
            lPageNumbers.add(i);
            if (lPageNumbers.size() == pNoLimit)
                break;
        }

        for (String mCount: mCategoyCount.keyset()) 
        {
            mCategoyCount.put(mCount, 0);
        }
            
         for (AggregateResult ar: database.query('SELECT count(Id),Status__c FROM TPO_Location__c where Status__c!=null ' + CombineQuery('AND', new List < String > 
            {
                sSearchClause,sClassificationClause,sCapabiliitiesClause,sCapabiliitiesClause2 
            }) + ' Group BY Status__c')) 
            {
            mCategoyCount.put((String) ar.get('Status__c'), (Integer) ar.get('expr0'));
            }
            
         for (AggregateResult ar: database.query('SELECT count(Id),TPO_Classification__c FROM TPO_Location__c where TPO_Classification__c!=null ' + CombineQuery('AND', new List < String > 
            {
                sSearchClause,sStatusClause,sCapabiliitiesClause,sCapabiliitiesClause2 
            }) + ' Group BY TPO_Classification__c')) 
            {
            mCategoyCount.put((String) ar.get('TPO_Classification__c'), (Integer) ar.get('expr0'));
            }
            
            // For multi Select value 
            List<String> Capabiliities = new List<String>();
            Set<String> CapabilitySet = New Set<String>();
            integer count = 1 ;
            for (TPO_Location__c p : database.query('SELECT Capabiliities__c FROM TPO_Location__c where Capabiliities__c!=null' + CombineQuery('AND', new List < String > 
            {
               sSearchClause,sClassificationClause,sStatusClause 
            }))){
                String s = (String)p.Capabiliities__c;
                Capabiliities.addAll(s.split(';'));
            }
            
            for(String s : Capabiliities){
                CapabilitySet.add(s);
            }
            for(String s : CapabilitySet){
                for(String s1 : Capabiliities){
                    if(s == s1){
                         mCategoyCount.put(s,count++);
                    }
                }
                count = 1; 
            }
            
    }  
    /*
     * Method name  : sort
     * Description  : Sorting of the results displayed by clicking on the column link
     * Return Type  : void
     * @Parameters  : None
     */

    Public void sort() 
    {

        if (sField == previousSField) 
        {
            if (sOrder.contains('ASC')) 
            {
                sOrder = sOrder.replace('ASC', 'DESC');
                sOrder = sOrder.replace('FIRST', 'LAST');
            } 
            else 
            {
                sorder = sorder.replace('DESC', 'ASC');
                sOrder = sOrder.replace('LAST', 'FIRST');
            }
        } 
        else 
        {
            sOrder = 'ASC NULLS FIRST';
            previoussField = sField;
        }

        Query(string.escapeSingleQuotes(sField) + ' ' + string.escapeSingleQuotes(sOrder));
    }

    /* 
    * @Method Name                    :  FetchDataForCriteria
    * @Description                    :  This method is called upon anny action on UI to query the data base
    * @Return Type                    :  void
    * @Parameters                     :  None
    */
    public void FetchDataForCriteria() 
    {
        Query(string.escapeSingleQuotes(sField) + ' ' + string.escapeSingleQuotes(sOrder));
    }


    /*
     * Method name  : GoToPageNumber
     * Description  : This method takes the user to results of that particular page on upon clicking any number on pagination panel on UI
     * Return Type  : void
     * @Parameters  : None
     */
    Public void GoToPageNumber() 
    {
        cLocationListCntlr.setPagenumber(iPageNumber);
    }

    /* 
    * @Method Name                    :  NextPageSeries
    * @Description                    :  This method takes the user to next set of pages on pagination panel on UI
    * @Return Type                    :  void
    * @Parameters                     :  None
    */
        Public void NextPageSeries() 
    {
        Integer currentLimit = lPageNumbers[lPageNumbers.size() - 1];
        lPageNumbers = new List < Integer > ();
        for (Integer i = 1; i <= pNoLimit; i++) 
        {
            if (currentLimit + i <= dPageCount) 
            {
                lPageNumbers.add(currentLimit + i);
            }
        }
    }

    /* 
    * @Method Name                    :  PreviousPageSeries
    * @Description                    :  This method takes the user to previous set of pages on pagination panel on UI
    * @Return Type                    :  void
    * @Parameters                     :  None
    */
    Public void PreviousPageSeries() 
    {
        Integer currentLimit = lPageNumbers[0] - pNoLimit - 1;

        lPageNumbers = new List < Integer > ();
        for (Integer i = 1; i <= pNoLimit; i++) 
        {
            lPageNumbers.add(currentLimit + i);
        }
    }

    /*
     * Class name   : wLocationObject
     * Description  : This is a wrapper class which holds the picklist value name and checkbox to filter out results on LocationList Page
     */

    Public class wLocationObject 
    {
        Public Boolean isSelected 
        {
            get;
            set;
        }
        Public string label 
        {
            get;
            set;
        }
        public wLocationObject(String l, Boolean isC) 
        {
            label = l;
            isSelected = isC;
        }
    }
}