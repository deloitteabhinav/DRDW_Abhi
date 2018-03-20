/******************************************************************************************************************************************
 * Class Name   : RelationshipList
 * Description  : List page with filters for Relationship records
 * Created By   : Deloitte Consulting
 *
 *****************************************************************************************************************************************/
Public with sharing class RelationshipList {

    Public ApexPages.StandardSetController cRelationshipListCntlr {
        get;
        set;
    }
    Public string sField {
        get;
        set;
    }
    Public string sSearchWord {
        get;
        set;
    }
    Public string sOrder {
        get;
        set;
    }
    Public Map < String, Integer > mCategoyCount {
        get;
        set;
    }
    Public List < Integer > lPageNumbers {
        get;
        private set;
    }
    Public Integer iPageNumber {
        get;
        set;
    }
    Public Map < String, List < wFilterWrapper >> mRelationshipObjectStructure {
        get;
        set;
    }
    public Integer pNoLimit {
        get;
        set;
    }
    public Decimal dPageCount {
        get;
        set;
    }
    public string previousSField {
        get;
        set;
    }
    public boolean bShowMoreFlag 
    {
        get;
        set;
    }
    Public String sStatus{
        get;
        set;
    }
    Public List < SelectOption > lStatusOptions {get;set;}

    //Loading the constructor the page
    Public RelationshipList() {
        pNoLimit = 20;
        // Initialisation
        sField = 'Name';
        previousSField = 'Name';
        bShowMoreFlag= true;
        sOrder = 'ASC NULLS FIRST';
        mRelationshipObjectStructure = new Map < String, List < wFilterWrapper >> ();

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
     * @Method Name                    :  getRelationships
     * @Description                    :  Initialize cRelationshipListCntlr and return a list of records
     * @Return Type                    :  List of Relationships
     * @Parameters                     :  None
     */

    Public List < Contact > getRelationships() {
        return (List < Contact > ) cRelationshipListCntlr.getRecords();
    }

    /*
     * @Method Name                    :  DescribeObjectWithDetails
     * @Description                    :  Method to get and populate therapeutic area, Relationship type, status and region picklist filters on UI
     * @Return Type                    :  void
     * @Parameters                     :  None
     */

    Public Void DescribeObjectWithDetails() {
        List < wFilterWrapper > lPicklist = new List < wFilterWrapper > ();
        mCategoyCount = new Map < String, Integer > ();

        lPicklist = new List < wFilterWrapper > ();
        for (Schema.Picklistentry oPicklistValues : Contact.Role__c.getDescribe().getPicklistValues()) {
            lPicklist.add(new wFilterWrapper(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mRelationshipObjectStructure.put('Role__c', lPicklist);
        
        lPicklist = new List < wFilterWrapper > ();
        for (Schema.Picklistentry oPicklistValues : Contact.Source__c.getDescribe().getPicklistValues()) {
            lPicklist.add(new wFilterWrapper(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mRelationshipObjectStructure.put('Source__c', lPicklist);
        
        lPicklist = new List < wFilterWrapper > ();
        for (Schema.Picklistentry oPicklistValues : Contact.Preferred_Communication_Method__c.getDescribe().getPicklistValues()) {
            lPicklist.add(new wFilterWrapper(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mRelationshipObjectStructure.put('Preferred_Communication_Method__c', lPicklist);
        
        lPicklist = new List < wFilterWrapper > ();
        lPicklist.add(new wFilterWrapper('Partners', false));
        lPicklist.add(new wFilterWrapper('Vendor / Service Providers', false));
        lPicklist.add(new wFilterWrapper('Research Institutes', false));
        
        mRelationshipObjectStructure.put('Account.RecordType.Name', lPicklist);
        
        lPicklist = new List < wFilterWrapper > ();
        for (Schema.Picklistentry oPicklistValues : Contact.Speciality__c.getDescribe().getPicklistValues()) {
            lPicklist.add(new wFilterWrapper(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mRelationshipObjectStructure.put('Speciality__c', lPicklist);
        
        lStatusOptions = new List < SelectOption > ();
        lStatusOptions.add(new SelectOption('', 'All Status'));
        for (Schema.Picklistentry oPicklistValues : Contact.Status__c.getDescribe().getPicklistValues()) {
            lStatusOptions.add(new SelectOption(oPicklistValues.Value, oPicklistValues.Value));
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
        for (wFilterWrapper oWrapper : lWrapperForProcessing) {
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
        for (String sClause : sClauses) {
            if (sClause != null && sClause != '')
                sCombineClause.add(sClause);
        }
        if (sCombineClause.size() > 0)
            return ' ' + sPrefix + ' ' + string.join(sCombineClause, ' AND ');
        return ' ';
    }

    /*
     * @Method Name                    :  Query
     * @Description                    :  This method queries the data base and fetches the results
     * @Return Type                    :  void
     * @Parameters                     :  string
     */

    Public void Query(String sOrder) {
        String sRoleClause = '';
        String sSourceClause = '';
        String sAccountClause = '';
        String sSearchClause = '';
        String sSpecialityClause = '';
        String sStatusClause = '';
        String sCommClause = '';
        List < Contact > lSearchWordProjects = new List < Contact > ();

        sRoleClause = FrameClause(mRelationshipObjectStructure.get('Role__c'));
        if (sRoleClause != '') {
            sRoleClause = ' Role__c IN ' + sRoleClause;
        }
        
        
        sSourceClause = FrameClause(mRelationshipObjectStructure.get('Source__c'));
        if (sSourceClause != '') {
            sSourceClause = ' Source__c IN ' + sSourceClause;
        }
        
        sAccountClause = FrameClause(mRelationshipObjectStructure.get('Account.RecordType.Name'));
        if (sAccountClause != '') {
            sAccountClause = ' Account.RecordType.Name IN ' + sAccountClause;
        }
        
        sSpecialityClause = FrameClause(mRelationshipObjectStructure.get('Speciality__c'));
        if (sSpecialityClause != '') {
            sSpecialityClause = ' Speciality__c IN ' + sSpecialityClause;
        }
        
        sCommClause = FrameClause(mRelationshipObjectStructure.get('Preferred_Communication_Method__c'));
        if (sCommClause != '') {
            sCommClause = ' Preferred_Communication_Method__c IN ' + sCommClause;
        }
        
        If(sStatus != null && sStatus != '') {
            sStatusClause = 'Status__c IN(\'' + string.escapeSingleQuotes(sStatus) +'\')';
        }

        if ((sSearchWord != null && sSearchWord.length()>1) && sSearchWord.trim() != '') {
            sSearchClause = ' Id IN : lSearchWordProjects';
        }

        if ((sSearchWord != null && sSearchWord.length()>1) && sSearchWord.trim() != '') {
            List < List < sObject >> lDynamicSearchResult = search.query('FIND \'' + string.escapeSingleQuotes(sSearchWord) + '\' IN ALL FIELDS RETURNING Contact  (id,Name,Account.RecordType.Name,Source__c,Account.Name,Role__c,Speciality__c,MailingAddress,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Contact_Function__c ' + CombineQuery('WHERE', new List < String > {
                sRoleClause,sSourceClause,sAccountClause,sSpecialityClause,sCommClause,sStatusClause
            }) + ' ORDER BY ' + sOrder +')');
            lSearchWordProjects = lDynamicSearchResult[0];
            cRelationshipListCntlr = new ApexPages.StandardSetController(lDynamicSearchResult[0]);
        } else {
            cRelationshipListCntlr = new ApexPages.StandardSetController(Database.getQueryLocator(
            'SELECT id,Name,Account.RecordType.Name,Account.Name,Source__c,Role__c,Speciality__c,MailingAddress,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Contact_Function__c FROM Contact ' + CombineQuery('WHERE  ', new List < String > {
                sRoleClause,sSourceClause,sAccountClause,sSpecialityClause,sCommClause,sStatusClause
            }) + ' ORDER BY ' + sOrder));
        }

        cRelationshipListCntlr.setPageSize(50);
        lPageNumbers = new List < Integer > ();
        dPageCount = 0;
        dPageCount = (decimal.valueof(cRelationshipListCntlr.getResultSize()) / decimal.valueof(cRelationshipListCntlr.getPageSize()));
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
        for (AggregateResult ar : database.query('SELECT count(Id),Role__c FROM Contact where Role__c !=null ' + CombineQuery('AND', new List < String > {
        sRoleClause,sSourceClause,sAccountClause,sSpecialityClause,sCommClause,sStatusClause,sSearchClause 
    }) + ' Group BY Role__c ')) {
            mCategoyCount.put((String) ar.get('Role__c'), (Integer) ar.get('expr0'));
        }

        for (AggregateResult ar : database.query('SELECT count(Id),Source__c FROM Contact where Source__c!=null ' + CombineQuery('AND', new List < String > {
        sRoleClause,sSourceClause,sAccountClause,sSpecialityClause,sStatusClause,sSearchClause 
    }) + ' Group BY Source__c')) {
            mCategoyCount.put((String) ar.get('Source__c'), (Integer) ar.get('expr0'));
        }
        
        
        for (AggregateResult ar : database.query('SELECT count(Id),Account.RecordType.Name acname FROM Contact where Account.RecordType.Name !=null ' + CombineQuery('AND', new List < String > {
        sRoleClause,sSourceClause,sAccountClause,sSpecialityClause,sCommClause,sStatusClause,sSearchClause 
    }) + ' Group BY Account.RecordType.Name')) {
           mCategoyCount.put((String) ar.get('acname'), (Integer) ar.get('expr0'));
        }

        for (AggregateResult ar : database.query('SELECT count(Id),Preferred_Communication_Method__c source FROM Contact where Preferred_Communication_Method__c !=NULL ' + CombineQuery('AND', new List < String > {
        sRoleClause,sSourceClause,sAccountClause,sSpecialityClause,sCommClause,sStatusClause,sSearchClause
    }) + ' Group BY Preferred_Communication_Method__c')) {
            mCategoyCount.put((String) ar.get('source'), (Integer) ar.get('expr0'));

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
        cRelationshipListCntlr.setPagenumber(iPageNumber);
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
     * @Description                    :  This is a wrapper class which holds the picklist value name and checkbox to filter out results on RelationshipList Page
     */

    Public class wFilterWrapper {
        Public Boolean isSelected {
            get;
            set;
        }
        Public string label {
            get;
            set;
        }
        public wFilterWrapper(String l, Boolean isC) {
            label = l;
            isSelected = isC;
        }
    }

}