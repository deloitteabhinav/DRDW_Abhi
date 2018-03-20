/******************************************************************************************************************************************
* Class Name   : TestFactory
* Description  : Utility Class for Creating Test Data for PANG
* Created By   : Deloitte Consulting
*
*****************************************************************************************************************************************/
@isTest
public with sharing class TestFactory {
    public static void insertPANGCustomSettings() {
        List<Settings__c> settings = new List<Settings__c>();
        settings.add(new Settings__c(Name = 'Training Material Library', Setting_Value__c = 'Pangaea Training Material'));
        settings.add(new Settings__c(Name = 'Default Chatter Group', Setting_Value__c = 'RWE Community at Lilly'));
        insert settings;
        system.assertNotEquals(NULL, settings);
    }

    /*
    * @Method Name                    :  givePermissions
    * @Description                    :  Assigning Permission Set to a User
    * @Return Type                    :  void
    * @Parameters                     :  UserID,PSetName
    */
    public static void givePermissions(id UserID, string PSetName) {
        PermissionSet ps = [Select id From PermissionSet WHERE Name = :PSetName];
        PermissionSetAssignment psAssignments = new PermissionSetAssignment(AssigneeId = UserID, PermissionSetId = ps.id);
        insert psAssignments;

        system.assertNotEquals(NULL, psAssignments);
    }

    /*
    * @Method Name                    :  assignGroup
    * @Description                    :  Assigning Public Group to a User
    * @Return Type                    :  void
    * @Parameters                     :  UserID,gname
    */
    public static void assignGroup(id UserID, string gname) {
        //Get the groups that the user should be added to
        Group g = [select Id from Group Where DeveloperName = :gname];

        List<User> users = [Select Id, Name from user Where Id = :UserID];

        List<GroupMember>listGroupMember = new List<GroupMember>();
        // loop the users that have been created
        for (User user : users) {
            GroupMember gm = new GroupMember();
            gm.GroupId = g.id;
            gm.UserOrGroupId = user.id;
            listGroupMember.add(gm);
        }
        insert listGroupMember;

        system.assertNotEquals(NULL, listGroupMember);
    }

    /*
    * @Method Name                    :  insertChatterGroups
    * @Description                    :  Inserting Chatter Groups
    * @Return Type                    :  void
    * @Parameters                     :  None
    */
    public static void insertChatterGroups() {

        CollaborationGroup cg = new CollaborationGroup(Name = 'RWE Community at Lilly', CollaborationType = 'Public');
        database.insert(cg, false);
         system.assertNotEquals(NULL, cg);
    }

    /*
    * @Method Name                    :  getTestingUser
    * @Description                    :  Creates a Test User
    * @Return Type                    :  User
    * @Parameters                     :  None
    */
    public static User getTestingUser() {

        String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
        Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
        String uniqueName = dateString + randomInt;

        User u;
        String pId = [select Id from Profile where Name = 'GSO Basic User_Platform'].Id;
        String rId = [select id from UserRole where Name = 'Lilly Employee'].Id;
        u = new User(profileId = pId, userRoleId = rId,  email = uniqueName + '@test' + uniqueName + '.org',
                     Username = uniqueName + '@test' + uniqueName + '.org',
                     alias = 'utusr', lastname = 'lastname', emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                     languagelocalekey = 'en_US', timezonesidkey = 'GMT');

        insert u;
        system.assertNotEquals(NULL, u);
        return u;


    }

    /*
    * @Method Name                    :  returnStudies
    * @Description                    :  returns a list of Studies
    * @Return Type                    :  List of Studies
    * @Parameters                     :  count
    */
    public static list<Project__c> returnStudies(integer count) {
        list<Project__c> lStudies = new list<Project__c>();
        for (integer i = 0; i < count; i++) {
            Project__c oStudy = new Project__c();
            oStudy.Name = 'test study ' + i;
           // oStudy.Study_Title_Short__c = 'test study '+i;
            oStudy.Description__c = 'random text';
            oStudy.Therapeutic_Area_Primary__c = 'Alzheimer’s & NDD';
            oStudy.Study_Description__c = 'Observational Study';
            oStudy.OwnerId = userinfo.getUserID();
            oStudy.Project_Manager__c = userinfo.getUserID();
            oStudy.Anticipated_Start_Date__c = System.today();
            oStudy.Anticipated_End_Date__c = System.today() + 10;
            oStudy.Actual_Start_Date__c = System.today() + 2;
            oStudy.Execution_Function__c = 'GPORWE';
            oStudy.Project_Status__c = 'Active';
//            oStudy.Study_Status_Reason__c = 'random text';
            oStudy.Business_Unit_Primary__c = 'Diabetes (DBU)';
            oStudy.Secondary_Study_Type__c = 'Primary Data Collection';
            lStudies.add(oStudy);
        }

        system.assertNotEquals(NULL, lStudies);
        return lStudies;
    }

    /*
    * @Method Name                    :  returnDataAssets
    * @Description                    :  returns a list of Data Assets
    * @Return Type                    :  List of Data Assets
    * @Parameters                     :  count
    */
    public static list<Data_Asset__c> returnDataAssets(integer count) {
        list<Data_Asset__c> lDataAssets = new list<Data_Asset__c>();
        for (integer i = 0; i < count; i++) {
            Data_Asset__c oDataAsset = new Data_Asset__c();
            oDataAsset.name = 'test data asset' + i;
            oDataAsset.Asset_Status__c = 'Assessed by RWD';
            oDataAsset.Access_Method__c = 'Internal';
            oDataAsset.Access_Details__c = 'Data Mart - RWE Multi-use Contract';
            oDataAsset.Documentation_Link__c = 'www.google.com';
            oDataAsset.Relationship_Type__c = 'Vendor';
            oDataAsset.Relevant_Therapeutic_Area__c= 'Alzheimer’s & NDD';
            oDataAsset.Type_of_Database__c = 'Claims';
            oDataAsset.Region__c = 'US';
            lDataAssets.add(oDataAsset);
        }

        system.assertNotEquals(NULL, lDataAssets);
        return lDataAssets;
    }

    /*
    * @Method Name                    :  returnRequests
    * @Description                    :  returns a list of Requests
    * @Return Type                    :  List of Requests
    * @Parameters                     :  partnershipCount,DataMartcount
    */
    public static list<Request__c> returnRequests(integer partnershipCount, integer DataMartcount) {
        map<string, id> mRecordTypes = new map<string, id>();
        list<Request__c> lRequests = new list<Request__c>();
        for (RecordType oRecType : [SELECT id, developername FROM RecordType WHERE SobjectType = 'Request__c']) {
            mRecordTypes.put(oRecType.developername, oRecType.id);
        }
        for (integer i = 0; i < partnershipCount; i++) {
            Request__c oReq = new Request__c();
            oReq.name = 'test partnership' + i;
            oReq.Requestor__c = userinfo.getUserID();
            oReq.Requestor_Functional_Area__c = 'MEDICAL';
            oReq.RecordtypeId = mRecordTypes.get('RWE_Partnership_Exploration');
            oReq.Business_Unit_Primary__c = 'EMBU';
            oReq.Region__c = 'US';
            oReq.Final_Outcome__c = 'testing to prevent Validation errors';
            oReq.Therapeutic_Area_Primary__c = 'Cardiovascular';
            oReq.Proposed_Due_Date__c = system.today() + 10;
            oReq.Partnership_Sponsor__c = 'GPORWE';
            oReq.Partnership_Status__c = 'Exploring';
            oReq.Type_of_Partner__c = 'Payer;Non-profit';
            lRequests.add(oReq);
        }
        for (integer i = 0; i < DataMartcount; i++) {
            Request__c oReq = new Request__c();
            oReq.name = 'test request' + i;
            oReq.Requestor__c = userinfo.getUserID();
            oReq.Requestor_Functional_Area__c = 'MEDICAL';
            oReq.RecordtypeId = mRecordTypes.get('Internal_Real_World_Data_Analysis');
            oReq.Business_Unit_Primary__c = 'EMBU';
            oReq.Region__c = 'US';
            oReq.Final_Outcome__c = 'testing to prevent Validation errors';
            oReq.Proposed_Due_Date__c = system.today() + 10;
            oReq.Therapeutic_Area_Primary__c= 'Cardiovascular';
            lRequests.add(oReq);
        }

        system.assertNotEquals(NULL, lRequests);
        return lRequests;
    }

    /*
    * @Method Name                    :  returnMolecules
    * @Description                    :  returns a list of RWE Molecules
    * @Return Type                    :  List of RWE Molecules
    * @Parameters                     :  count
    */
    public static list < Molecule__c > returnMolecules(integer count) {
        list < Molecule__c> lMolecules = new list < Molecule__c > ();
        for (integer i = 0; i < count; i++) {

            Molecule__c oMol = new Molecule__c();

            oMol.Name = 'test ' + i;

            oMol.Therapeutic_Area_Primary__c= 'Diabetes';

            lMolecules.add(oMol);
        }

        system.assertNotEquals(NULL, lMolecules);
        return lMolecules;
    }


    /*
     * @Method Name                    :  returnIndications
     * @Description                    :  returns a list of RWE Indications associated to RWE Molecules
     * @Return Type                    :  List of RWE Indications
     * @Parameters                     :  count, List of Molecules
     */
    public static list < DRDP_Indication__c> returnIndications(integer count, list < Molecule__c > lMolecules) {
        list < DRDP_Indication__c> lIndications = new list < DRDP_Indication__c> ();
        for (Molecule__c oMolecule : lMolecules) {
            for (integer i = 0; i < count; i++) {
                DRDP_Indication__c oIndi = new DRDP_Indication__c();
                oIndi.Name = 'test ' + i;
                oIndi.Molecule__c = oMolecule.id;
                lIndications.add(oIndi);
            }
        }

        system.assertNotEquals(NULL, lIndications);
        return lIndications;
    }

    /*
    * @Method Name                    :  returnrequestMolecules
    * @Description                    :  returns a list of RWE Molecules
    * @Return Type                    :  List of RWE Molecules
    * @Parameters                     :  count, list of Molecules
    */
    public static list < DRDP_Request_Molecule__c> returnRequestMolecules(list < Request__c > lRequests, list < Molecule__c > lMolecules) {
        list < DRDP_Request_Molecule__c> lRequestMolecules = new list < DRDP_Request_Molecule__c> ();
        for (Request__c oRequest : lRequests) {
            for (Molecule__c oMol : lMolecules) {
                DRDP_Request_Molecule__c oReqMol = new DRDP_Request_Molecule__c();
                oReqMol.Molecule__c = oMol.id;
                oReqMol.Request__c = oRequest.id;
                lRequestMolecules.add(oReqMol);
            }
        }
        system.assertNotEquals(NULL, lRequestMolecules);
        return lRequestMolecules;
    }


    /*
    * @Method Name                    :  returnRequestAssets
    * @Description                    :  returns a list of RWE Request Data Assets
    * @Return Type                    :  List of RWE Request Data Assets
    * @Parameters                     :  list of Requests, List of Data Assets
    */
    public static list < Request_Data_Asset__c> returnRequestAssets(list < Request__c > lRequests, list < Data_Asset__c > lAssets) {
        list < Request_Data_Asset__c> lRequestAssets = new list < Request_Data_Asset__c> ();
        for (Request__c oRequest : lRequests) {
            for (Data_Asset__c oAsset : lAssets) {
                Request_Data_Asset__c oReqAssets = new Request_Data_Asset__c();
                oReqAssets.Data_Asset__c = oAsset.id;
                oReqAssets.Request__c = oRequest.id;
                lRequestAssets.add(oReqAssets);
            }
        }
        system.assertNotEquals(NULL, lRequestAssets);
        return lRequestAssets;
    }

    /*
    * @Method Name                    :  returnStudyAssets
    * @Description                    :  returns a list of RWE Study Data Assets
    * @Return Type                    :  List of RWE Study Data Assets
    * @Parameters                     :  list of Studies, list of Data Assets
    */
    public static list < Related_Data_Asset__c > returnStudyAssets(list < Project__c > lStudies, list < Data_Asset__c > lAssets) {
        list < Related_Data_Asset__c> lStudyAssets = new list < Related_Data_Asset__c> ();
        for (Project__c oStudy : lStudies) {
            for (Data_Asset__c oAsset : lAssets) {
                Related_Data_Asset__c oStudyAssets = new Related_Data_Asset__c();
                oStudyAssets.Data_Asset__c = oAsset.id;
                oStudyAssets.Project__c = oStudy.id;
                lStudyAssets.add(oStudyAssets);
            }
        }
        system.assertNotEquals(NULL, lStudyAssets);
        return lStudyAssets;
    }


    /*
    * @Method Name                    :  returnRequestResource
    * @Description                    :  returns a list of Request Resource
    * @Return Type                    :  List of Request Resource
    * @Parameters                     :  List of Requests, UserId
    */
  /*  public static list <Request_Resource__c> returnRequestResource(list < Request__c > lRequests, Id uId) {
        List<Request_Resource__c> lResource = new List <Request_Resource__c>();
        if (!lRequests.isempty()) {
            for (Request__c oRequest : lRequests) {
                Request_Resource__c oResource = new Request_Resource__c();
                oResource.RecordTypeId = Schema.SObjectType.Request_Resource__c.getRecordTypeInfosByName().get('General Resource').getRecordTypeId();
                oResource.Request__c = oRequest.Id;
                oResource.Resource__c = uId;
                lResource.add(oResource);
            }
        }
        system.assertNotEquals(NULL, lResource);
        return lResource ;
    } */


    /*
    * @Method Name                    :  returnConsoleRecords
    * @Description                    :  returns a list of Console Records
    * @Return Type                    :  List
    * @Parameters                     :  none
    */
    public static list < Console__c > returnConsoleRecords() {
        list < Console__c > lConsole = new list < Console__c > ();
        Console__c  oCon1 = new Console__c();
        oCon1.Name = 'RWD Inventory';
        oCon1.RecordTypeId = Schema.SObjectType.Console__c.getRecordTypeInfosByName().get('Generic Console Setting').getRecordTypeId();
        lConsole.add(oCon1);
        Console__c  oCon2 = new Console__c();
        oCon2.Name = 'RWE Partnerships';
        oCon2.RecordTypeId = Schema.SObjectType.Console__c.getRecordTypeInfosByName().get('Generic Console Setting').getRecordTypeId();
        lConsole.add(oCon2);
        Console__c  oCon3 = new Console__c();
        oCon2.Name = 'Leadership Dashboards';
        oCon3.RecordTypeId = Schema.SObjectType.Console__c.getRecordTypeInfosByName().get('Generic Console Setting').getRecordTypeId();
        lConsole.add(oCon3);

        system.assertNotEquals(NULL, lConsole);
        return lConsole ;
    }


    /*
    * @Method Name                    :  returnNotes
    * @Description                    :  returns a list of Notes of Console Records
    * @Return Type                    :  List of Notes
    * @Parameters                     :  none
    */
    public static list < Note > returnNotes(List <Console__c > lConsole) {
        list < Note > lNotes = new list < Note > ();
        for (Console__c oConsole : lConsole) {
            If(oConsole.Name == 'RWD Inventory') {
                Note oNote = new Note();
                oNote.Title = 'Information';
                oNote.Body = 'Data Asset Name,Asset Status ,Lilly Internal Contact , Asset Sub-Status,Data Steward,Owner Type , Company Name,Access Method,Vendor Contact,Available for in-house analysis?,Website,Data can be shared w TPO for analysis?,Information Comments,Contractual Obligations';
                oNote.ParentID = oConsole.Id;
                lNotes.add(oNote);
            }
            else if(oConsole.Name == 'RWE Partnerships'){
                Note oNote = new Note();
                oNote.Title = 'Information';
                oNote.Body = 'Request Name, RWE Partnership Status, RWE Partnership Sponsor,Type of Partner,What Makes It Unique,Reason Partnership Not Pursued,Description';
                oNote.ParentID = oConsole.Id;
                lNotes.add(oNote);
            }
            else{
                Note oNote = new Note();
                oNote.Title = 'Dashboard 1';
                oNote.Body = System.URL.getSalesforceBaseUrl().toExternalForm();
                oNote.ParentID = oConsole.Id;
                lNotes.add(oNote);  
            }
        }

        system.assertNotEquals(NULL, lNotes);
        return lNotes;
    }


    /*
     * @Method Name                    :  returnApprover
     * @Description                    :  returns one Approver record for BP association
     * @Return Type                    :  List of RWE Approver
     * @Parameters                     :  none
     */
    public static list < Approver__c> returnApprover() {

        List<Approver__c> lApprover = new list < Approver__c>();
        Approver__c oApprover = new Approver__c ();
        oApprover.Approver__c = userinfo.getUserID();
        oApprover.Locked__c = FALSE;
        lApprover.add(oApprover);
        system.assertNotEquals(NULL, lApprover);
        return lApprover;

    }


     /*
    * @Method Name                    :  returnTPOs
    * @Description                    :  returns a list of TPO Records.
    * @Return Type                    :  List of RWE TPO
    * @Parameters                     :  count
    */
    public static list < TPO__c > returnTPOs(integer count) {

        list < TPO__c> lTPOs = new list < TPO__c > ();
        for (integer i = 0; i < count; i++) {
            TPO__c oTPO = new TPO__c();
            oTPO.Name = 'Test TPO' + i;
            oTPO.CDA_Active__c = 'yes';
            lTPOs.add(oTPO);
        }
        system.assertNotEquals(NULL, lTPOs);
        return lTPOs;
    }
    /*
    * @Method Name                    :  returnTPOLocations
    * @Description                    :  returns a list of TPOLocation Records.
    * @Return Type                    :  List of RWE TPOLocation
    * @Parameters                     :  count, parent TPO
    */
      public static list < TPO_Location__c > returnTPOLocations(integer count,  List < TPO__c > Parent_TPO) {
        integer i;
        list < TPO_Location__c > lTPOLocations = new list < TPO_Location__c > ();
        // List<Schema.PicklistEntry> lCapabilities = TPO_Location__c.Status__c.getDescribe().getPicklistValues();
        if (count < 10) {
            for (i = 0; i < count; i++) {
                TPO_Location__c oTPOLocation = new TPO_Location__c();
                oTPOLocation.Name = 'Test TPOLocation' + i;
                oTPOLocation.Status__c = 'Approved';
                oTPOLocation.Capabiliities__c = 'Advisory Board - HTA;Advisory Board - Virtuall;AMCP Formulary Submission Dossier;Analytical Tools';
                oTPOLocation.Location__C = 'Hyderabad.';
                oTPOLocation.Link_to_Parent_TPO__c = Parent_TPO[0].id;
                lTPOLocations.add(oTPOLocation);
            }
        }
        if (count >= 10) {
            for (i = 0; i < count / 3; i++) {
                TPO_Location__c oTPOLocation = new TPO_Location__c();
                oTPOLocation.Name = 'Test TPOLocation_Approved' + i;
                oTPOLocation.Status__c = 'Approved';
                oTPOLocation.Capabiliities__c = 'Advisory Board - HTA;Advisory Board - Virtuall;AMCP Formulary Submission Dossier;Analytical Tools';
                oTPOLocation.Location__C = 'Hyderabad.';
                oTPOLocation.Link_to_Parent_TPO__c = Parent_TPO[0].id;
                lTPOLocations.add(oTPOLocation);
            }
            for (i = 0; i < count / 3; i++) {
                TPO_Location__c oTPOLocation = new TPO_Location__c();
                oTPOLocation.Name = 'Test TPOLocation_Proposed' + i;
                oTPOLocation.Status__c = 'Proposed';
                oTPOLocation.Capabiliities__c = 'Advisory Board - HTA;Advisory Board - Virtuall;AMCP Formulary Submission Dossier;Analytical Tools';
                oTPOLocation.Location__C = 'Hyderabad.';
                oTPOLocation.Link_to_Parent_TPO__c = Parent_TPO[0].id;
                lTPOLocations.add(oTPOLocation);
            }
            count = count - (2*(count / 3));
            for (i = 0; i < count; i++) {
                TPO_Location__c oTPOLocation = new TPO_Location__c();
                oTPOLocation.Name = 'Test TPOLocation_Terminated' + i;
                oTPOLocation.Status__c = 'Terminated';
                oTPOLocation.Capabiliities__c = 'Advisory Board - HTA;Advisory Board - Virtuall;AMCP Formulary Submission Dossier;Analytical Tools';
                oTPOLocation.Location__C = 'Hyderabad.';
                oTPOLocation.Link_to_Parent_TPO__c = Parent_TPO[0].id;
                lTPOLocations.add(oTPOLocation);
            }
        }
        system.assertNotEquals(NULL, lTPOLocations);
        return lTPOLocations;
    }

    /*
    * @Method Name                    :  returnRequestCountry
    * @Description                    :  returns a list of Request Country
    * @Return Type                    :  List of Request and  Country
    * @Parameters                     :  list of Requests, list of Countries
    */
    public static list < Related_Country__c> returnRequestCountry(list<Request__c> lRequests, List<Country__c> lCountries) {
        list < Related_Country__c> lRequestCountry  = new list < Related_Country__c> ();
        for (Request__c  oRequest : lRequests) {
            for (Country__c oCountry : lCountries) {

                Related_Country__c oRequestCountry = new Related_Country__c();

                oRequestCountry.Country__c = oCountry.id;
                oRequestCountry.Request__c = oRequest.id;

                lRequestCountry.add(oRequestCountry);
            }
        }
        system.assertNotEquals(NULL, lRequestCountry);
        return lRequestCountry;
    }

    /*
    * @Method Name                    :  returnAssetCountry
    * @Description                    :  returns a list of Asset Country
    * @Return Type                    :  List of Asset and  Country
    * @Parameters                     :  list of Data Assets, list of Countries
    */
    public static list < Data_Asset_Country__c> returnAssetCountry(list<Data_Asset__c> lAssets, List<Country__c> lCountries) {
        list < Data_Asset_Country__c> lAssetCountry  = new list < Data_Asset_Country__c> ();
        for (Data_Asset__c  oAsset : lAssets) {
            for (Country__c oCountry : lCountries) {

                Data_Asset_Country__c oAssetCountry = new Data_Asset_Country__c();

                oAssetCountry.Country__c = oCountry.id;
                oAssetCountry.Data_Asset__c = oAsset.id;

                lAssetCountry.add(oAssetCountry);
            }
        }
        system.assertNotEquals(NULL, lAssetCountry);
        return lAssetCountry;
    }

    /*
    * @Method Name                    :  returnExperts
    * @Description                    :  returns a list of Expert Members
    * @Return Type                    :  List
    * @Parameters                     :  count, User ID
    */
    /*
    public static list<EXPERT_Member__c> returnExperts(integer count, id Uid) {
        list<EXPERT_Member__c> lExperts = new list<EXPERT_Member__c>();
        for (integer i = 0; i < count; i++) {
            EXPERT_Member__c oExpert = new EXPERT_Member__c();
            oExpert.Name = 'DO NOT ENTER';
            oExpert.Salesforce_User__c = Uid;
            lExperts.add(oExpert);
        }
        system.assertNotEquals(NULL, lExperts);
        return lExperts;
    } */

    /*
     * @Method Name                    :  returnRequestExpert
     * @Description                    :  returns a list of Request Resource
     * @Return Type                    :  List of Request Resource
     * @Parameters                     :  List of Requests, Expert Members
     */
   /* public static list <Request_Resource__c> returnRequestExpert(list < Request__c > lRequests, List <EXPERT_Member__c> lExpertMembers) {
        List<Request_Resource__c> lResource = new List <Request_Resource__c>();
        if (!lRequests.isempty()) {
            for (Request__c oRequest : lRequests) {
                for (EXPERT_Member__c oMember : lExpertMembers) {
                    Request_Resource__c oResource = new Request_Resource__c();
                    oResource.RecordTypeId = Schema.SObjectType.Request_Resource__c.getRecordTypeInfosByName().get('EXPERT Member').getRecordTypeId();
                    oResource.Request__c = oRequest.Id;
                    oResource.EXPERT_Member__c = oMember.Id;
                    lResource.add(oResource);
                }
            }
        }
        system.assertNotEquals(NULL, lResource);
        return lResource ;
    } */
    
    /*
     * @Method Name                    :  returnEDConsole
     * @Description                    :  returns a list of RWE Console Records for Executive Dashboard
     * @Return Type                    :  List of RWE Console
     * @Parameters                     :  None
     */
    public static list <Console__c> returnEDConsole() {
        List<Console__c> lConsole = new List <Console__c>();
        id EDRecType = Schema.SObjectType.Console__c.getRecordTypeInfosByName().get('Executive Dashboard Setting').getRecordTypeId();
        Console__c oCon = new Console__c();
        oCon.Picklist_Field_Name__c = 'Access Method';
        oCon.Name = 'Internal';
        oCon.RecordTypeId = EDRecType;
        oCon.Display_Name__c = 'InTERNAL!';
        oCon.Active__c = TRUE;
        lConsole.add(oCon);
        oCon = new Console__c();
        oCon.Picklist_Field_Name__c = 'Access Method';
        oCon.Name = 'External';
        oCon.RecordTypeId = EDRecType;
        oCon.Active__c = TRUE;
        lConsole.add(oCon);
        oCon = new Console__c();
        oCon.Picklist_Field_Name__c = 'Therapeutic Area';
        oCon.Name = 'Bone, Muscle, Joint';
        oCon.RecordTypeId = EDRecType;
        oCon.Active__c = TRUE;
        lConsole.add(oCon);
        oCon = new Console__c();
        oCon.Picklist_Field_Name__c = 'Therapeutic Area';
        oCon.Name = 'Diabetes';
        oCon.RecordTypeId = EDRecType;
        oCon.Display_Name__c = 'Diabetes';
        oCon.Active__c = TRUE;
        lConsole.add(oCon);
        oCon = new Console__c();
        oCon.Picklist_Field_Name__c = 'Therapeutic Area';
        oCon.Name = 'Oncology';
        oCon.RecordTypeId = EDRecType;
        oCon.Display_Name__c = 'Oncology';
        oCon.Active__c = TRUE;
        lConsole.add(oCon);
        oCon = new Console__c();
        oCon.Picklist_Field_Name__c = 'Region';
        oCon.Name = 'US';
        oCon.RecordTypeId = EDRecType;
        oCon.Active__c = TRUE;
        lConsole.add(oCon);
        oCon = new Console__c();
        oCon.Picklist_Field_Name__c = 'Region';
        oCon.Name = 'Global (Multiple Regions)';
        oCon.RecordTypeId = EDRecType;
        oCon.Display_Name__c = 'Global';
        oCon.Active__c = TRUE;
        lConsole.add(oCon);
        oCon = new Console__c();
        oCon.Picklist_Field_Name__c = 'RWE Partnership Sponsor';
        oCon.Name = 'PROactive (USHO)';
        oCon.RecordTypeId = EDRecType;
        oCon.Display_Name__c = 'PROactive';
        oCon.Active__c = TRUE;
        lConsole.add(oCon);
        oCon = new Console__c();
        oCon.Picklist_Field_Name__c = 'RWE Partnership Sponsor';
        oCon.Name = 'GPORWE';
        oCon.RecordTypeId = EDRecType;
        oCon.Active__c = TRUE;
        lConsole.add(oCon);
        oCon = new Console__c();
        oCon.Picklist_Field_Name__c = 'Type of Database';
        oCon.Name = 'Claims';
        oCon.RecordTypeId = EDRecType;
        oCon.Display_Name__c = 'Claims!';
        oCon.Active__c = TRUE;
        lConsole.add(oCon);
        oCon = new Console__c();
        oCon.Picklist_Field_Name__c = 'Type of Database';
        oCon.Name = 'Survey';
        oCon.RecordTypeId = EDRecType;
        oCon.Active__c = TRUE;
        lConsole.add(oCon);
        oCon = new Console__c();
        oCon.Picklist_Field_Name__c = 'Primary Value Area';
        oCon.Name = 'Access & Reimbursement';
        oCon.RecordTypeId = EDRecType;
        oCon.Display_Name__c = 'Access';
        oCon.Active__c = TRUE;
        lConsole.add(oCon);
        oCon = new Console__c();
        oCon.Picklist_Field_Name__c = 'Primary Value Area';
        oCon.Name = 'Safety & Risk Management';
        oCon.RecordTypeId = EDRecType;
        oCon.Active__c = TRUE;
        lConsole.add(oCon);
        
        system.assertNotEquals(NULL, lConsole);
        return lConsole ;
    }
}