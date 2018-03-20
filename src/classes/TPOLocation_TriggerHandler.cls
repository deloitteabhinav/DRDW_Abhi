/******************************************************************************************************************************************
 * Class Name   : TPOLocation_TriggerHandler
 * Description  : Handler Class for TPO Location Object
 * Created By   : Deloitte Consulting
 *
 *****************************************************************************************************************************************/
Public with sharing class TPOLocation_TriggerHandler {

    /*
    * @Method Name                    :  CopyCapabiliities
    * @Description                    :  Method to copy Capabiliities in technical field
    * @Return Type                    :  void
    * @Parameters                     :  List < TPO_Location__c >
    */

    public static void CopyCapabiliities(List < TPO_Location__c> lTpoLocation) {

        For(TPO_Location__c oLocation : lTpoLocation) {
            If(oLocation.Capabiliities__c != NULL && oLocation.Capabiliities__c != '') {
                String sAllcapabilities = oLocation.Capabiliities__c;
                List<string> lcap = new list< string >();
                lcap = sAllcapabilities.split(';');
                lcap.sort();
                string sSeparatedCap = string.join(lcap, '; ');
                oLocation.Capabiliities_TF__c = sSeparatedCap;
            }
            Else {
                oLocation.Capabiliities_TF__c = oLocation.Capabiliities__c;
            }
        }
    }
}