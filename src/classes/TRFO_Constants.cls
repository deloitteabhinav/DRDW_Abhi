/*
*@ Class Name                                                    : TRFO_Constants
*@ Description                                                   : Constants class that has constants which can be referred in various classes and test classes
*@ CreatedBy                                                     : Karthik Kannan
*@ CreatedOn                                                     : 26/01/2016

*/
public with sharing class TRFO_Constants {

    public static final List < String > APPROVALHISTORY_STATUS = new List < String > {
        'Pending',
        'Approved',
        'Rejected'
    };
    public static final List < String > FORM_TYPE_VIEW_RESPONSES = new List < String > {
        'Feasibility',
        'Feasibility 1',
        'Feasibility 2',
        'Feasibility 3',
        'Site Evaluation',
        'Addendum'
    };
    public static final String SELECTED = 'Selected';
    public static final String NOT_SELECTED = 'Not Selected';
    public static final String BACKUP = 'Backup';
    public static final String APPROVED = 'Approved';
    public static final String NOT_APPROVED = 'Not Approved';
    public static final String ID = 'id';
    public static final String NON_SEC_PROCESS = 'Non-SEC Process';
    public static final String NON_SEC_PROCESS_DEVELOPERNAME = 'Non_SEC_Process';
    public static final String QUERY_LIKE_COM = '%COM%';
    public static final String QUERY_LIKE_CDL = '%CDC%';
    public static final String QUERY_LIKE_CDC = '%CDC%';
    public static final String QUERY_LIKE_FEASIBILITY = '%Feasibility%';
    public static final String SITE_EVALUATION = 'Site Evaluation';
    public static final String SITE_SELECTION = 'Site Selection';
    public static final String Tab1 = 'Tab1';
    public static final String Tab2 = 'Tab2';
    public static final String COM = 'COM';
    public static final String COPM = 'COPM';
    public static final String SelectState = '—-Select State—-';
    public static final String Location = 'Location';
    public static final String PI = 'Principal Investigator';
    public static final String CRD = 'Contact Role Details';
    public static final String SelectCountry = '—-Select Country—-';
    public static final String currentTab_URLParam = 'currenttab';
    public static final String crd_urlParam = 'contactroledetails';
    public static final String shippinglocation_urlParam = 'shippinglocation';
    public static final String add_urlParam = 'Add';
    public static final String None_picklistValue = '--None--';
    public static final String SiteAPIName = 'Site__c';
    public static final String CRD_TabName = 'name1';
    public static final String SL_TabName = 'name2';
    public static final String emptyString = '';
    public static final String contact = 'Contact';
    public static final String semiColon = ';';
    public static final String forwardslash = '/';
    public static final String SPACE = ' ';
    public static final String hyphen = '-';
    public static final String percent_String = '%';
    public static final String commaString = ', ';
    public static final String COMMA = ',';
    public static final String DNUApproved = 'DNU Approved';
    public static final String DNUReevaluation = 'DNU ReEvaluation Approved';
    public static final String Contact_Role_Error_Msg_1 = 'You have already assign role:';
    public static final String Contact_Role_Error_Msg_2 = ' to ';
    public static final String Contact_Role_Error_Msg_3 = '!';
    public static final String active_picklistValue = 'Active';
    public static final String LOCATION_CHANGE = 'Location Change';
    public static final String PI_CHANGE = 'PI Change';
    public static final String ADDENDUM = 'Addendum';
    public static final String SITE_EVALUATION_REJECTED = 'Site Evaluation Rejected';
    public static final String SITE_EVALUATION_APPROVED = 'Site Evaluation Approved';
    public static final String NA = 'NA';
    public static final String EU = 'EU';
    public static final String LA = 'LA';
    public static final String AP = 'AP';
    public static final String AT = 'AT';
    public static final String FORMID_urlParam = 'formId';
    public static final String TRIALSITEID_urlParam = 'trialSiteId';
    public static final String BY_COM = ' by COM';
    public static final String BY_COPM = ' by COPM';
    public static final String SUPPLEMENTAL = 'Supplemental';
    public static final String QUERY_LIKE_MAOPS = '%MAOPS%';
    public static final String NONE = 'None';
    public static final String SUBMITTED = 'Submitted';
    public static final String DRAFT_SAVED = 'Draft Saved';
    public static final String NOT_APPROVED_BY_COM = 'Not Approved by COM';
    public static final String PENDING_SELECTION_BY_COPM = 'Pending Selection by COPM';
    public static final String PENDING_APPROVAL_BY_COPM = 'Pending Approval by COPM';
    public static final String PENDING_APPROVAL_BY_COM = 'Pending Approval by COM';
    public static final String SUPPLEMENTAL_FORM_SUBMITTED = 'Supplemental Form Submitted';
    public static final String TESTDATA = 'testData';
    public static final String PDF_EXTENSION = '.pdf';
    public static final String SPF_PDFTITLE = 'Site Profile Form ';
    public static final String SUPPLEMENTAL_APPROVED = 'Supplemental Approved';
    public static final String SUPPLEMENTAL_REJECTED = 'Supplemental Rejected';
    public static final String SEC_SUBFORM_APPROVED = 'SEC Subform Approved';
    public static final String SEC_SUBFORM_SUBMITTED = 'SEC Subform Submitted';
    public static final String FEASIBILITY_APPROVED = 'Feasibility Approved';
    public static final String FEASIBILITY = 'Feasibility';
    public static final String SEC_SUBFORM_REVISION_REQUESTED = 'SEC Subform Revision Requested';
    public static final String FEASIBILITY_REJECTED = 'Feasibility Rejected';
    public static final String PATTERN_MATCH = '[a-zA-Z0-9\\.\\!\\#\\$\\%\\&\\*\\/\\=\\?\\^\\_\\+\\-\\`\\{\\|\\}\\~\'._%+-]+@[a-zA-Z0-9\\-.-]+\\.[a-zA-Z]+';
    public static final String RETURN_URL = 'retURL';
    public static final List < String > oldDataTypes = new List < String > {
        'Seperator',
        'Signature Block',
        'Spacer',
        'Sub-Section Break',
        'Sub-Section Question'
    };
    public static final String HIDEMSG_urlParam = 'hideMessage';
    public static final String LIVE_VISIT = 'Live Visit';
    public static final String ISEC = 'ISEC';
    public static final String COMPLETED = 'Completed';
    public static final String TELEPHONE = 'Telephone';
    public static final String DATE_PICKLISTVALUE = 'Date';
    public static final String COMMENTS = 'Comments';
    public static final String SHORT_TEXT = 'Short Text';
    public static final String TEXT_BLOCK = 'Text Block';
    public static final String RADIO = 'Radio';
    public static final String PICKLIST = 'Picklist';
    public static final String CHECKBOX = 'Checkbox';
    public static final String ALL = 'All';
    public static final String CEO = 'CEO';
    public static final String INDIA = 'India';
    public static final String SEPARATOR = 'seperator';
    public static final String SIGNATURE_BLOCK = 'signature block';
    public static final String SPACER = 'spacer';
    public static final String SUB_SECTION_BREAK = 'sub-section break';
    public static final String SUB_SECTION_QUESTION = 'sub-section question';
    public static final String SUBMITTED_BY_SENIOR_SYSTEM_ADMINISTRATOR = 'Submitted by Senior System Administrator';
    public static final String SUBMITTED_BY_CDL = 'Submitted by CDC';
    public static final String PENDING = 'Pending';
    public static final String APPROVED_BY_COM = 'Approved by COM';
    public static final String SELECTED_BY_COPM = 'Selected by COPM';
    public static final String SENIOR_SYSTEM_ADMINISTRATOR = 'Senior System Administrator';
    public static final String formIds = 'formIds';
    public static final Set < String > SEC_EMAIL_TEMPLATES = new Set < String > {
        'Mail_sent_when_the_form_is_submitted_for_Approval',
        'Mail_sent_when_the_SE_form_is_Selected',
        'Mail_sent_when_the_form_is_Approved_Rejected',
        'Mail_sent_when_the_SE_form_is_Approved_Rejected',
        'Mail_sent_when_the_SE_form_is_Approved_by_COM',
        'Mail_sent_to_COM_when_the_form_is_Reassigned',
        'Mail_sent_to_COPM_when_the_form_is_Reassigned',
        'Mail_sent_when_the_SE_form_is_Pending_Selection'
    };
    public static final List < String > FORMUTILS_ROLES = new List < String > {
        'Principal Investigator',
        'Sub-Investigator',
        'Primary Study Coordinator',
        'Regulatory',
        'Pharmacist',
        'Budgets',
        'Contracts',
        'Other Key Staff',
        'Ship Lab Supplies to',
        'Ship CRFs to',
        'Ship investigational product (IP) to',
        'Send Contract (LOA) to'
    };

    public TRFO_Constants() {}

}