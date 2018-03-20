/* Class Name  : Test_Constants
* Description  : Test Class for Constants
* Created By   : Deloitte
* Created Date : 15th December 2015
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
*/

@isTest(SeeAllData = false)
public with sharing class Test_Constants
{
    /* 
    * @Method Name                    :  checkConstantValues
    * @Description                    :  Method to test the values of Constants defined to be used in other classes
    * @Return Type                    :  void
    * @Parameters                     :  None
    */  
    
    public static testMethod void checkConstantValues()
    {
        Constants oConst=new Constants();
        system.assertEquals(Constants.sFeedbackStatusSent,'Sent');
        system.assertEquals(Constants.sFeedbackStatusSaved,'Saved');
        system.assertEquals(Constants.sFeedbackStatusSubmitted,'Submitted');
        system.assertEquals(Constants.sFeedbackProviderPermissionAPI,'Supplier_Feedback_Provider');
        system.assertEquals(Constants.sEmailTemplateAPI,'Feedback_Form');
    }
}