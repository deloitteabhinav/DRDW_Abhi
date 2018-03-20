/******************************************************************************************************************************************
 * Class Name   : DRDP_CreateRelationshipContactController
 * Description  : controller class for DRDP_CreateRelationshipContact page
 * Created By   : Deloitte Consulting
 *
 *****************************************************************************************************************************************/
Public with sharing class DRDP_CreateRelationshipContactController {
    public Contact oContact {get; set;}
    public id currentRecordID;
    public string currentContactType {get; set;}
    public string sExactRecordtypeName{get;set;}

    //Loading the Constructor
    public DRDP_CreateRelationshipContactController(ApexPages.StandardController controller) {
        currentContactType = ApexPages.currentPage().getParameters().get('recTypeName');
        currentRecordID = ApexPages.currentPage().getParameters().get('id');
        if (currentContactType == 'Partner') {
            sExactRecordtypeName = 'Partners';
        } else if (currentContactType == 'ResearchInstitutes') {
            sExactRecordtypeName = 'Research Institutes';
        } else {
            sExactRecordtypeName = 'Vendor / Service Providers';
        }
        if (currentRecordID != Null) {

            String SobjectApiName = 'Contact';
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
            commaSeparatedFields = commaSeparatedFields + ', ' + 'Account.RecordType.Name, ' +'Account.Name' ;
            
            string query = 'select ' + commaSeparatedFields + ' from ' + SobjectApiName + ' where id =\'' + currentRecordID + '\' limit 1';
            oContact = Database.query(query);

        }

        else {
            oContact = new Contact();
        }
    }

    /*
     * @Method Name                    :  save
     * @Description                    :  Method to Save the Contact record
     * @Return Type                    :  PageReference
     * @Parameters                     :  None
     */
    public PageReference save() {

                
        pagereference pageref;
        try {
        
            Account oAccount = new Account();
            oAccount = [Select RecordType.Name,Name from Account where Id =: oContact.AccountId LIMIT 1];
        
            If(oAccount.RecordType.Name == sExactRecordtypeName){
                upsert oContact oContact.Id;
                pageref = new pagereference('/apex/DRDP_CreateRelationshipContact?id=' + oContact.id + '&recTypeName=' + currentContactType + '&isEdit=false');
                pageref.setredirect(true);
                return pageref;
            }
            Else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, oAccount.Name + ' is not a valid '+ sExactRecordtypeName +' Organisation.' +' Please select a correct Organisation Type.');
                ApexPages.addMessage(myMsg);
                return null;
            }

        } catch (exception e) {
            String error = e.getdmlMessage(0);
            addError(error);
            return null;
        }
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
        pagereference pageref = new pagereference('/apex/DRDP_CreateRelationshipContact?id=' + currentRecordID + '&recTypeName=' + currentContactType + '&isEdit=true');
        pageref.setredirect(true);
        return pageref;
    }

    }