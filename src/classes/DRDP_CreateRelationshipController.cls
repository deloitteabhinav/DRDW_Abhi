/******************************************************************************************************************************************
 * Class Name   : DRDP_CreateRelationshipController
 * Description  : controller class for DRDP_CreateRelationship page
 * Created By   : Deloitte Consulting
 *
 *****************************************************************************************************************************************/
Public with sharing class DRDP_CreateRelationshipController {
    public Account oAccount {get; set;}
    public id currentRecordID;
    public string pagename;
    public string currentAccountType {get; set;}

    //Loading the Constructor
    public DRDP_CreateRelationshipController(ApexPages.StandardController controller) {
        currentAccountType = ApexPages.currentPage().getParameters().get('recTypeName');
        currentRecordID = ApexPages.currentPage().getParameters().get('id');
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
         

        if (currentRecordID != Null) {

            String SobjectApiName = 'Account';
            Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
            Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();

            String commaSeparatedFields = '';
            for (String fieldName : fieldMap.keyset()) {
                if (commaSeparatedFields == null || commaSeparatedFields == '') {
                    commaSeparatedFields = fieldName;
                } else {
                    commaSeparatedFields = commaSeparatedFields + ', ' + fieldName;
                }
            }
            commaSeparatedFields = commaSeparatedFields + ', ' + 'RecordType.Name';
            
            string query = 'select ' + commaSeparatedFields + ' from ' + SobjectApiName + ' where id =\'' + currentRecordID + '\' limit 1';
            oAccount = Database.query(query);
            if (oAccount.RecordType.Name == 'Partners') {
                currentAccountType = 'Partner';
                pagename = 'DRDP_CreatePartnerRelationship';
            } else if (oAccount.RecordType.Name == 'Research Institutes') {
                currentAccountType = 'ResearchInstitutes';
                pagename = 'DRDP_CreateScientificLeadersRelationship';
            } else {
                currentAccountType = 'Vendor';
                pagename = 'DRDP_CreateVendorRelationship';
            }

        }

        else {
            oAccount = new Account();
            if (currentAccountType == 'Partner') {
                oAccount.RecordTypeId = AccountRecordTypeInfo .get('Partners').getRecordTypeId();
                pagename = 'DRDP_CreatePartnerRelationship';
            } else if (currentAccountType == 'ResearchInstitutes') {
                oAccount.RecordTypeId = AccountRecordTypeInfo .get('Research Institutes').getRecordTypeId();
                pagename = 'DRDP_CreateScientificLeadersRelationship';
            } else {
                oAccount.RecordTypeId = AccountRecordTypeInfo .get('Vendor / Service Providers').getRecordTypeId();
                pagename = 'DRDP_CreateVendorRelationship';
            }
        }
    }

    /*
     * @Method Name                    :  save
     * @Description                    :  Method to Save the Organisation record
     * @Return Type                    :  PageReference
     * @Parameters                     :  None
     */
    public PageReference save() {

                
        pagereference pageref;
        try {
            upsert oAccount oAccount.id;

            pageref = new pagereference('/apex/'+pagename+'?id=' + oAccount.id + '&recTypeName=' + currentAccountType + '&isEdit=false');

            pageref.setredirect(true);
        } catch (exception e) {
            String error = e.getdmlMessage(0);
            addError(error);
            return null;
        }
        return pageref;
    }

    /*
     * @Method Name                    :  addError
     * @Description                    :  Method for adding apex error
     * @Return Type                    :  void
     * @Parameters                     :  string
     */
    public void addError(string s) {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, s);
        ApexPages.addMessage(myMsg);
    }


    public PageReference EditRecord() {
        pagereference pageref = new pagereference('/apex/'+pagename+'?id=' + currentRecordID + '&recTypeName=' + currentAccountType + '&isEdit=true');
        pageref.setredirect(true);
        return pageref;
    }
    
    public PageReference CancelRecord() {
        pagereference pageref;
        If(currentRecordID == NULL){
            pageref = new pagereference('/apex/DRDP_SelectRelationship');
        }
        Else{
            pageref = new pagereference('/apex/'+pagename+'?id=' + currentRecordID + '&recTypeName=' + currentAccountType + '&isEdit=false');
        }
        pageref.setredirect(true);
        return pageref;
    }

    }