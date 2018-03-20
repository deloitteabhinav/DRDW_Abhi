/*
*@ Class Name                                                    : Constants
*@ Description                                                   : Constants class that has constants which can be referred in various classes and test classes
*@ CreatedBy                                                     : Naomi Thammadi
*@ CreatedOn                                                     : 07/12/2015

*/
public with sharing class Constants{
    //final constants
    public static final string sFeedbackStatusSent='Sent';
    public static final string sFeedbackStatusSaved='Saved';
    public static final string sFeedbackStatusSubmitted='Submitted';
    public static final string sFeedbackProviderPermissionAPI='Supplier_Feedback_Provider';
    public static final string sSMINAdminPermissionAPI='Admin';
    public static final string sSupplierAssessorPermissionAPI='Supplier_Assessor';
    public static final string sEmailTemplateAPI='Feedback_Form';
    
    public Constants(){
    }
}