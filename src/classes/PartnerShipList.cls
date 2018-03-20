/****************************************************************************************************************************************** 
 * Class Name   : PartnerShipList
 * Description  : Class to display the List of Partnership Exploration requests/records
 * Created By   : Deloitte Consulting
 * 
 *****************************************************************************************************************************************/
Public with sharing class PartnerShipList {
    Public ApexPages.StandardSetController cPartnershipListCntlr {get;set;}
    Public string sField {get;set;}
    Public string sSearchWord {get;set;}
    Public string sOrder {get;set;}
    Public Map < String, Integer > mCategoyCount {get;set;}
    Public List < SelectOption > oPartnershipTypeOptions {get;set;}
    Public string sPartnershipType {get;set;}
    Public List < Integer > lPageNumbers {get; private set;}
    Public Integer iPageNumber {get;set;}
    Public Map < String, List < wFilterWrapper >> mPartnershipStructure {get;set;}
    public Integer pNoLimit {get;set;}
    public Decimal dPageCount {get;set;}
    public string previousSField {get;set;}
    Public boolean bShowMoreFlag {get;set;}



    //Loading the constructor the page
    Public PartnerShipList() {
        pNoLimit = 20;
        // Initialisation 
        sField = 'Name';
        previousSField = 'Name';
        sOrder = 'ASC NULLS FIRST';
        bShowMoreFlag= true;
        mPartnershipStructure = new Map < String, List < wFilterWrapper >> ();


        // Methods for call
        DescribeObjectWithDetails();
        Query(string.escapeSingleQuotes(sField) + ' ' + string.escapeSingleQuotes(sOrder));

    }
    
    /* 
     * @Method Name                    :  toggleOff
     * @Description                    :  Show More filter is toggled OFF
     * @Return Type                    :  None
     * @Parameters                     :  None
     */
    Public void toggleOff() {
        bShowMoreFlag= false;
    }

    /* 
     * @Method Name                    :  getPartnerships
     * @Description                    :  Initialize cPartnershipListCntlr and return a list of records
     * @Return Type                    :  List of Requests 
     * @Parameters                     :  None
     */
    Public List < Request__c > getPartnerships() {
        return (List < Request__c > ) cPartnershipListCntlr.getRecords();
    }

    /* 
     * @Method Name                    :  DescribeObjectWithDetails
     * @Description                    :  Method to get and populate partnership Sponsor, partnership status, region picklist filters on UI
     * @Return Type                    :  void 
     * @Parameters                     :  None
     */
    Public Void DescribeObjectWithDetails() {
        List < wFilterWrapper > lPicklist = new List < wFilterWrapper > ();
        mCategoyCount = new Map < String, Integer > ();

        // Not using global describe which is taking longer time, hence hardcoding the field for describe
        for (Schema.Picklistentry oPicklistValues: Request__c.Type_of_Partner__c.getDescribe().getPicklistValues()) {
            lPicklist.add(new wFilterWrapper(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mPartnershipStructure.put('Type_of_Partner__c', lPicklist);

        lPicklist = new List < wFilterWrapper > ();
        for (Schema.Picklistentry oPicklistValues: Request__c.Partnership_Sponsor__c.getDescribe().getPicklistValues()) {
            lPicklist.add(new wFilterWrapper(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mPartnershipStructure.put('Partnership_Sponsor__c', lPicklist);


        lPicklist = new List < wFilterWrapper > ();
        for (Schema.Picklistentry oPicklistValues: Request__c.Region__c.getDescribe().getPicklistValues()) {
            lPicklist.add(new wFilterWrapper(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mPartnershipStructure.put('Region__c', lPicklist);
        
        //Initializing the dropdown of Dynamic Drop down of Partnership Type field
        oPartnershipTypeOptions = new List < SelectOption > ();
        oPartnershipTypeOptions.add(new SelectOption('', 'All Status'));
        for (Schema.Picklistentry oPicklistValues: Request__c.Priority__c.getDescribe().getPicklistValues()) {
            oPartnershipTypeOptions.add(new SelectOption(oPicklistValues.Label,oPicklistValues.Label));
        }
    }

    /* 
     * @Method Name                    :  FrameClause
     * @Description                    :  This method constructs the query clause if check boxes are checked for filtering on UI 
     * @Return Type                    :  string 
     * @Parameters                     :  list of wFilterWrapper 
     */
    Public string FrameClause(List < wFilterWrapper > lWrapperForProcessing) {
        String sClause = '';

        for (wFilterWrapper oWrapper: lWrapperForProcessing) {
            if (oWrapper.isSelected) {
                sClause += '\'' + oWrapper.label + '\',';
            }
        }
        if (sClause != '') {
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
    public String CombineQuery(String sPrefix, List < String > sClauses) {
        List < String > sCombineClause = new List < String > ();
        for (String sClause: sClauses) {
            if (sClause != null && sClause != '')
                sCombineClause.add(sClause);
        }
        if (sCombineClause.size() > 0) {
            return ' ' + sPrefix + ' ' + string.join(sCombineClause, ' AND ') + ' AND (recordtype.DeveloperName=\'Partnership_Exploration\')';
        } else {
            return ' ' + sPrefix + ' (recordtype.DeveloperName=\'Partnership_Exploration\')';
        }
    }

    /* 
     * @Method Name                    :  Query
     * @Description                    :  This method queries the data base and fetches the results
     * @Return Type                    :  void
     * @Parameters                     :  string
     */
    Public void Query(String sOrder) {
        String sRegionClause = '';
        String sSponsorClause = '';
        String sStatusClause = '';
        String sPartnershipTypeClause = '';
        String sSearchClause = '';
        List < Request__c > lSearchWordProjects = new List < Request__c > ();

        sRegionClause = FrameClause(mPartnershipStructure.get('Region__c'));
        if (sRegionClause != '') 
        {
            sRegionClause = ' Region__c IN ' + sRegionClause;
        }

        sSponsorClause = FrameClause(mPartnershipStructure.get('Partnership_Sponsor__c'));
        if (sSponsorClause != '') {
            sSponsorClause = ' Partnership_Sponsor__c IN ' + sSponsorClause;
        }

        sStatusClause = FrameClause(mPartnershipStructure.get('Type_of_Partner__c'));
        if (sStatusClause != '') {
            sStatusClause = ' Type_of_Partner__c IN ' + sStatusClause;
        }

        If(sPartnershipType != null && sPartnershipType != '' && sPartnershipType != 'All Status') {
            sPartnershipTypeClause = 'Priority__c IN (\'' + string.escapeSingleQuotes(sPartnershipType) +'\')';
        }

        if ((sSearchWord != null && sSearchWord.length()>1) && sSearchWord.trim() != '') {
            sSearchClause = ' Id IN : lSearchWordProjects';
        }

        if ((sSearchWord != null && sSearchWord.length()>1) && sSearchWord.trim() != '') {
            List < List < sObject >> lDynamicSearchResult = search.query('FIND \'' + string.escapeSingleQuotes(sSearchWord) + '\' IN ALL FIELDS RETURNING Request__c (Id,Name,Region__c,Partnership_Sponsor__c,Priority__c,Request_Selector__c,Business_Unit_Primary__c,Type_of_Partner__c  ' + CombineQuery('WHERE', new List < String > {
                sStatusClause,sSponsorClause,sPartnershipTypeClause,sRegionClause,sSearchClause
            }) + ' ORDER BY ' + sOrder + ')');
            lSearchWordProjects = lDynamicSearchResult[0];
            cPartnershipListCntlr = new ApexPages.StandardSetController(lDynamicSearchResult[0]);
        } else {
            cPartnershipListCntlr = new ApexPages.StandardSetController(Database.getQueryLocator(
                'SELECT Id,Name,Partnership_Sponsor__c,recordtype.developername,Request_Selector__c,Priority__c,Business_Unit_Primary__c,Type_of_Partner__c,Region__c FROM Request__c ' + CombineQuery('WHERE', new List < String > {
                    sStatusClause,sSponsorClause,sPartnershipTypeClause,sRegionClause,sSearchClause
                }) + ' ORDER BY ' + sOrder));

        }

        cPartnershipListCntlr.setPageSize(50);
        lPageNumbers = new List < Integer > ();
        dPageCount = 0;
        dPageCount = (decimal.valueof(cPartnershipListCntlr.getResultSize()) / decimal.valueof(cPartnershipListCntlr.getPageSize()));
        dPageCount = dPageCount.round(System.RoundingMode.UP);

        for (Integer i = 1; i <= dPageCount; i++) {
            lPageNumbers.add(i);
            if (lPageNumbers.size() == pNoLimit)
                break;
        }

        for (String mCount: mCategoyCount.keyset()) {
            mCategoyCount.put(mCount, 0);
        }

        for (AggregateResult ar: database.query('SELECT count(Id),Type_of_Partner__c FROM Request__c where Type_of_Partner__c!=null ' + CombineQuery('AND', new List < String > {
                sStatusClause,sSponsorClause,sPartnershipTypeClause,sRegionClause,sSearchClause
            }) + ' Group BY Type_of_Partner__c')) {
            mCategoyCount.put((String) ar.get('Type_of_Partner__c'), (Integer) ar.get('expr0'));
        }

        for (AggregateResult ar: database.query('SELECT count(Id),Partnership_Sponsor__c FROM Request__c where Partnership_Sponsor__c!=null ' + CombineQuery('AND', new List < String > {
                sStatusClause,sSponsorClause,sPartnershipTypeClause,sRegionClause,sSearchClause
            }) + ' Group BY Partnership_Sponsor__c')) {
            mCategoyCount.put((String) ar.get('Partnership_Sponsor__c'), (Integer) ar.get('expr0'));
        }

        for (AggregateResult ar: database.query('SELECT count(Id),Region__c FROM Request__c where Region__c !=null ' + CombineQuery('AND', new List < String > {
                sStatusClause,sSponsorClause,sPartnershipTypeClause,sRegionClause,sSearchClause
            }) + ' Group BY Region__c ')) {
            mCategoyCount.put((String) ar.get('Region__c'), (Integer) ar.get('expr0'));
        }

    }

    /* 
     * @Method Name                    :  sort
     * @Description                    :  This method sorts the results upon clicking sortable field names on results header on UI
     * @Return Type                    :  void
     * @Parameters                     :  None
     */

    Public void sort() {

        if (sField == previousSField) {
            if (sOrder.contains('ASC')) {
                sOrder = sOrder.replace('ASC', 'DESC');
                sOrder = sOrder.replace('FIRST', 'LAST');
            } else {
                sorder = sorder.replace('DESC', 'ASC');
                sOrder = sOrder.replace('LAST', 'FIRST');
            }
        } else {
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

    public void FetchDataForCriteria() {
        Query(string.escapeSingleQuotes(sField) + ' ' + string.escapeSingleQuotes(sOrder));
    }

    /* 
     * @Method Name                    :  GoToPageNumber
     * @Description                    :  This method will take user to the results on that page upon clicking any page number on pagination panel
     * @Return Type                    :  void
     * @Parameters                     :  None
     */

    Public void GoToPageNumber() {
        cPartnershipListCntlr.setPagenumber(iPageNumber);
    }

    /* 
     * @Method Name                    :  NextPageSeries
     * @Description                    :  This method takes the user to next set of pages on pagination panel on UI
     * @Return Type                    :  void
     * @Parameters                     :  None
     */
    Public void NextPageSeries() {

        Integer currentLimit = lPageNumbers[lPageNumbers.size() - 1];
        lPageNumbers = new List < Integer > ();
        for (Integer i = 1; i <= pNoLimit; i++) {
            if (currentLimit + i <= dPageCount) {
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
    Public void PreviousPageSeries() {

        Integer currentLimit = lPageNumbers[0] - pNoLimit - 1;

        lPageNumbers = new List < Integer > ();
        for (Integer i = 1; i <= pNoLimit; i++) {
            lPageNumbers.add(currentLimit + i);
        }
    }

    /* 
     * @Class Name                     :  wFilterWrapper 
     * @Description                    :  This is a wrapper class which holds the picklist value name and checkbox to filter out results on Requestlist Page
     */

    Public class wFilterWrapper {
        Public Boolean isSelected {get;set;}
        Public string label {get;set;}
        public wFilterWrapper(String l, Boolean isC) {
            label = l;
            isSelected = isC;
        }
    }

}