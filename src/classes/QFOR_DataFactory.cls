/****************************************************************************************************************************************** 
 * Class Name   : QFOR_DataFactory
 * Description  : Utility Class for Creating Test Data for QFOR Project
 * Created By   : Deloitte Consulting
 * 
 *****************************************************************************************************************************************/
@
isTest
public with sharing class QFOR_DataFactory {

    /* 
     * @Method Name                    :  getTestingUser
     * @Description                    :  Creates a Test User
     * @Return Type                    :  User
     * @Parameters                     :  None
     */
    public static User getTestingUser() 
{
        String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
        Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
        String uniqueName = dateString + randomInt;

        User u;
        String pId = [select Id from Profile where Name = 'GSO Basic User_Platform'].Id;
        String rId = [select id from UserRole where Name = 'Lilly Employee'].Id;
        u = new User(profileId = pId, userRoleId = rId, email = uniqueName + '@test' + uniqueName + '.org',
            Username = uniqueName + '@test' + uniqueName + '.org',
            alias = 'utusr', lastname = 'lastname', emailencodingkey = 'UTF-8', localesidkey = 'en_US',
            languagelocalekey = 'en_US', timezonesidkey = 'GMT');

        insert u;
        system.assertNotEquals(NULL, u);
        return u;

    }

    /* 
     * @Method Name                    :  givePermissions
     * @Description                    :  Assigning Permission Set to a User
     * @Return Type                    :  void
     * @Parameters                     :  UserID,PSetName
     */
    public static void givePermissions(id UserID, string PSetName) {
        PermissionSet ps = [Select id From PermissionSet WHERE Name = : PSetName];
        PermissionSetAssignment psAssignments = new PermissionSetAssignment(AssigneeId = UserID, PermissionSetId = ps.id);
        insert psAssignments;
        system.assertNotEquals(NULL, psAssignments);
    }

    /* 
     * @Method Name                    :  returnStudies
     * @Description                    :  returns a list of Studies
     * @Return Type                    :  List of studies
     * @Parameters                     :  count
     */
    public static list < Project__c > returnStudies(integer count) {
        list < Project__c > lStudies = new list < Project__c > ();
        for (integer i = 0; i < count; i++) {

            Project__c oStudy = new Project__c();

            oStudy.Name='test study '+i;
            //oStudy.Study_Title_Short__c = 'test study '+i;
            oStudy.Description__c='random text';            
            oStudy.Therapeutic_Area_Primary__c ='Alzheimer’s & NDD';
            oStudy.Study_Description__c='Observational Study';
            oStudy.OwnerId=userinfo.getUserID();
            oStudy.Project_Manager__c=userinfo.getUserID();
            oStudy.Anticipated_Start_Date__c= System.today();
            oStudy.Anticipated_End_Date__c= System.today()+10; 
            oStudy.Actual_Start_Date__c = System.today();
            oStudy.Execution_Function__c='GPORWE';
            oStudy.Project_Status__c='Active';
            oStudy.Business_Unit_Primary__c='Diabetes (DBU)';
            oStudy.Secondary_Study_Type__c='Primary Data Collection';
            lStudies.add(oStudy);
        }
        system.assertNotEquals(NULL, lStudies);
        return lStudies;
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

            oMol.Name = 'test molecule' + i;
            
            oMol.Therapeutic_Area_Primary__c= 'Diabetes';
            
            lMolecules.add(oMol);
        }
        system.assertNotEquals(NULL, lMolecules);
        return lMolecules;
    }

    /* 
     * @Method Name                    :  returnStudyMolecules
     * @Description                    :  returns a list of RWE Molecules
     * @Return Type                    :  List of RWE Molecules
     * @Parameters                     :  count
     */
    public static list < DRDP_Study_Molecule__c > returnStudyMolecules(list < Project__c > lStudies, list < Molecule__c > lMolecules) {
        list < DRDP_Study_Molecule__c > lStudyMolecules = new list < DRDP_Study_Molecule__c > ();
        for (Project__c oStudy: lStudies) {
            for (Molecule__c oMol: lMolecules) {
                DRDP_Study_Molecule__c oStudyMol = new DRDP_Study_Molecule__c();
                oStudyMol.Molecule__c = oMol.id;
                oStudyMol.Project__c = oStudy.id;
                lStudyMolecules.add(oStudyMol);
            }
        }
        system.assertNotEquals(NULL, lStudyMolecules);
        return lStudyMolecules;
    }
    
    /* 
     * @Method Name                    :  returnQuestionnaire
     * @Description                    :  returns a list of Questionnaire
     * @Return Type                    :  List of Questionnaire
     * @Parameters                     :  count
     */
    public static list < Questionaire__c> returnQuestionnaire(integer count) {
        list < Questionaire__c> lQuestionnaires = new list < Questionaire__c> ();
        for (integer i = 0; i < count; i++) {
            Questionaire__c oQuestionnaire = new Questionaire__c();
            lQuestionnaires.add(oQuestionnaire );
        }
        system.assertNotEquals(NULL, lQuestionnaires);
        return lQuestionnaires;
    }
    
    /* 
     * @Method Name                    :  returnQuestions
     * @Description                    :  returns a list of Questions
     * @Return Type                    :  List of Questions
     * @Parameters                     :  count
     */
    public static list < Questions__c> returnQuestions(integer count) {
        list < Questions__c> lQuestions = new list < Questions__c> ();
        for (integer i = 0; i < count; i++) {
            Questions__c oQuestion= new Questions__c();
            oQuestion.Question_Text__c = 'test'+i;
            oQuestion.Response_Type__c='Radio';
            oQuestion.Study_Dependent__c = 'Design Method';
            lQuestions.add(oQuestion);
        }
        system.assertNotEquals(NULL, lQuestions);
        return lQuestions;
    }
    
    /* 
     * @Method Name                    :  returnStudyQuestionnaire
     * @Description                    :  returns a list of Study Questionnaire
     * @Return Type                    :  List of Study Questionnaires
     * @Parameters                     :  count
     */
    public static list < Study_Questionnaire__c> returnStudyQuestionnaire(list < Questionaire__c> lquestionnaire, list<Project__c > lStudies) {
        list < Study_Questionnaire__c> lStudyQuestionaire = new list < Study_Questionnaire__c> ();
        for (Project__c oStudy : lStudies) {
            for (Questionaire__c oQuestionaire : lquestionnaire) {
                 Study_Questionnaire__c oStudyQuestionnaire = new Study_Questionnaire__c();
                 oStudyQuestionnaire.Questionnaire__c=oQuestionaire.id;
                 oStudyQuestionnaire.Study__c=oStudy .id;
                 lStudyQuestionaire.add(oStudyQuestionnaire);
            }   
        }
        system.assertNotEquals(NULL, lStudyQuestionaire);
        return lStudyQuestionaire;
    }
    
     /* 
     * @Method Name                    :  returnQuestionnaireQuestions
     * @Description                    :  returns a list of Questionnaire questions
     * @Return Type                    :  List of Questionnaire questions
     * @Parameters                     :  count
     */
    public static list < Questionnaire_Question__c> returnQuestionnaireQuestions(list < Questionaire__c> lquestionnaire, list<Questions__c> lQuestions) {
        list < Questionnaire_Question__c> lQuestionaireQuestions = new list < Questionnaire_Question__c> ();
        for (Questionaire__c oQuestionaire : lquestionnaire) {
            for (Questions__c oQuestion : lQuestions) {
                 Questionnaire_Question__c oQuestionnaireQuestion = new Questionnaire_Question__c();
                 oQuestionnaireQuestion.Question__c=oQuestion.id;
                 oQuestionnaireQuestion.Questionnaire__c=oQuestionaire.id;
                 lQuestionaireQuestions.add(oQuestionnaireQuestion);
            }   
        }
        system.assertNotEquals(NULL, lQuestionaireQuestions);
        return lQuestionaireQuestions ;
    }
    
    /* 
     * @Method Name                    :  returnQuestionOptions
     * @Description                    :  returns a list of Question Options
     * @Return Type                    :  List of Question Options
     * @Parameters                     :  count
     */
    public static list < Question_Option__c> returnQuestionOptions(list<Questions__c> lQuestions) {
        list < Question_Option__c> lQuestionOptions = new list < Question_Option__c> ();
        for (Questions__c oQuestion : lQuestions) {
           Question_Option__c oYesOption = new Question_Option__c();
           oYesOption.Question__c = oQuestion.Id;
           oYesOption.Name = 'Yes'; 
           lQuestionOptions.add(oYesOption);
        }
        system.assertNotEquals(NULL, lQuestionOptions);
        return lQuestionOptions;
    }
    
    /* 
     * @Method Name                    :  returnDependentQuestions
     * @Description                    :  returns a list of Dependent Question
     * @Return Type                    :  List of Dependent Question
     * @Parameters                     :  count
     */
    public static list < Dependent_Question__c> returnDependentQuestions(list<Questions__c> lQuestions,list < Question_Option__c> lOptions) {
        list < Dependent_Question__c> lDependentQuestions = new list < Dependent_Question__c> ();
        for (Questions__c oQuestion : lQuestions) {
            for (Question_Option__c oOption : lOptions) {
               Dependent_Question__c oDepQn = new Dependent_Question__c();
               oDepQn.Option__c = oOption.Id;
               oDepQn.Question__c= oQuestion.id; 
               lDependentQuestions.add(oDepQn);
            }
        }
        system.assertNotEquals(NULL, lDependentQuestions);
        return lDependentQuestions;
    }
    
    /* 
     * @Method Name                    :  returnChecklistItems
     * @Description                    :  returns a list of Checklist items
     * @Return Type                    :  List of Checklist items
     * @Parameters                     :  count
     */
    public static list < Checklist_Item__c> returnChecklistItems(integer count,string process) {
        list < Checklist_Item__c> lChecklistItems = new list < Checklist_Item__c> ();
        for (integer i = 0; i < count; i++) {
           Checklist_Item__c oChecklistItem = new Checklist_Item__c();
           oChecklistItem.Help_Text__c='test'+i;
           oChecklistItem.Instructions__c='<img src="www.google.com"/>\r\n<p>returns a list of Questionnaire questionsreturns a list of Questionnaire questionsreturns a list of Questionnaire questionsreturns a list of Questionnaire questionsreturns a list of Questionnaire questions list of Questionnaire questionsreturns a list of Questionnaire questions list of Questionnaire questionsreturns a list of Questionnaire questions list of Questionnaire questionsreturns a list of Questionnaire questions list of Questionnaire questionsreturns a list of Questionnaire questions<p>'+i;
           oChecklistItem.Mandatory__c=true;
           oChecklistItem.Milestone__c=true;
           oChecklistItem.Process__c=process;           
           lChecklistItems.add(oChecklistItem);
        }
        system.assertNotEquals(NULL, lChecklistItems);
        return lChecklistItems;
    }
    /* 
     * @Method Name                    :  returnNonMilestoneChecklistItems
     * @Description                    :  returns a list of Non Milestone Checklist items
     * @Return Type                    :  List of Non Milestone Checklist items
     * @Parameters                     :  count
     */
    public static list < Checklist_Item__c> returnNonMilestoneChecklistItems(integer count,string process) {
        list < Checklist_Item__c> lChecklistItems = new list < Checklist_Item__c> ();
        for (integer i = 0; i < count; i++) {
           Checklist_Item__c oChecklistItem = new Checklist_Item__c();
           oChecklistItem.Help_Text__c='test'+i;
           oChecklistItem.Instructions__c='<img src="www.google.com"/>\r\n<p>returns a list of Questionnaire questionsreturns a list of Questionnaire questionsreturns a list of Questionnaire questionsreturns a list of Questionnaire questionsreturns a list of Questionnaire questions list of Questionnaire questionsreturns a list of Questionnaire questions list of Questionnaire questionsreturns a list of Questionnaire questions list of Questionnaire questionsreturns a list of Questionnaire questions list of Questionnaire questionsreturns a list of Questionnaire questions<p>'+i;
           oChecklistItem.Mandatory__c=true;
           oChecklistItem.Milestone__c=false;
           oChecklistItem.Process__c=process;           
           lChecklistItems.add(oChecklistItem);
        }
        system.assertNotEquals(NULL, lChecklistItems);
        return lChecklistItems;
    }

    /* 
     * @Method Name                    :  returnChecklistMasters
     * @Description                    :  returns a list of Checklist Masters
     * @Return Type                    :  List of Checklist Masters
     * @Parameters                     :  count
     */
    public static list < Checklist_Version__c> returnChecklistMasters(integer count) {
        list < Checklist_Version__c> lChecklistMasters = new list < Checklist_Version__c> ();
        for (integer i = 0; i < count; i++) {
           
           Checklist_Version__c oChecklistMaster = new Checklist_Version__c();
           
           oChecklistMaster.Version_Comments__c='test'+i;
           oChecklistMaster.Study_Type__c = 'Observational Study';
                     
           lChecklistMasters.add(oChecklistMaster);
        }
        system.assertNotEquals(NULL, lChecklistMasters);
        return lChecklistMasters;
    }
    
    /* 
     * @Method Name                    :  returnChecklistVersionnaire
     * @Description                    :  returns a list of Checklist Versionnaire
     * @Return Type                    :  List of Checklist Versionnaire
     * @Parameters                     :  count
     */
    public static list < Checklist_Versionaire__c> returnChecklistVersionnaire(list < Checklist_Version__c> lChecklistMasters,list < Checklist_Item__c> lChecklistItems) {
        list < Checklist_Versionaire__c> lChecklistVersionnaire = new list < Checklist_Versionaire__c> ();
        for ( Checklist_Version__c oVersion : lChecklistMasters) {
            for (Checklist_Item__c oItem : lChecklistItems) {
               
               Checklist_Versionaire__c oChecklistVersionnaire= new Checklist_Versionaire__c();
               
               oChecklistVersionnaire.Checklist_Item_Id__c =oItem.id;
               oChecklistVersionnaire.Checklist_Version_Id__c=oVersion.id;
                         
               lChecklistVersionnaire.add(oChecklistVersionnaire);
            }
        }
        system.assertNotEquals(NULL, lChecklistVersionnaire);
        return lChecklistVersionnaire ;
    }
    
    /* 
     * @Method Name                    :  returnStudyQuestionnaireResponse
     * @Description                    :  returns a list of Study Questionnaire Responses
     * @Return Type                    :  List of Study Questionnaire Responses
     * @Parameters                     :  count
     */
    public static list < Study_Questionnaire_Response__c> returnStudyQuestionnaireResponse(list < Questions__c> lQuestions ,list < Question_Option__c> lQuestionOptions,Study_Questionnaire__c oStudyQuestionnaire) {
        list < Study_Questionnaire_Response__c> lStudyQuestionnaireResponse = new list < Study_Questionnaire_Response__c> ();
        for ( Questions__c oQuestion : lQuestions) {
            for (Question_Option__c oOption : lQuestionOptions) {
               
               Study_Questionnaire_Response__c oStudyQuestionnaireResponse = new Study_Questionnaire_Response__c();
               
               oStudyQuestionnaireResponse.Study_Questionnaire_ID__c = oStudyQuestionnaire.id;
               oStudyQuestionnaireResponse.Response__c=oOption.id;
               oStudyQuestionnaireResponse.Question__c=oQuestion.id ;
                         
               lStudyQuestionnaireResponse.add(oStudyQuestionnaireResponse);
            }
        }
        system.assertNotEquals(NULL, lStudyQuestionnaireResponse);
        return lStudyQuestionnaireResponse;
    }
    
    /* 
     * @Method Name                    :  returnStudyChecklistVersions
     * @Description                    :  returns a list of Study Checklist Versions
     * @Return Type                    :  List of Study Checklist Versions
     * @Parameters                     :  count
     */
    public static list < Study_Checklist_Version__c> returnStudyChecklistVersions(Project__c oStudy, list<Checklist_Version__c> lChecklistVersions) {
        list < Study_Checklist_Version__c> lStudyChecklistVersions= new list < Study_Checklist_Version__c> ();
        for (Checklist_Version__c oVersion : lChecklistVersions) {
           
           Study_Checklist_Version__c oStudyChecklistVersion = new Study_Checklist_Version__c();
           
           oStudyChecklistVersion.Checklist_Version_ID__c =oVersion.id;
           oStudyChecklistVersion.Study__c=oStudy.id;
             
           lStudyChecklistVersions.add(oStudyChecklistVersion );
        }
        system.assertNotEquals(NULL, lStudyChecklistVersions);
        return lStudyChecklistVersions;
    }
    
    /* 
     * @Method Name                    :  returnCountries
     * @Description                    :  returns a list of Countries
     * @Return Type                    :  List of Countries
     * @Parameters                     :  count
     */
    public static list < Country__c> returnCountries(integer count) {
        list < Country__c> lCountries = new list < Country__c> ();
        for (integer i=0;i<count;i++) {
           
           Country__c oCountry= new Country__c();
           
           oCountry.Name='test'+i;
             
           lCountries.add(oCountry);
        }
        system.assertNotEquals(NULL, lCountries);
        return lCountries;
    }
    
    /* 
     * @Method Name                    :  returnStudyConductingCountries
     * @Description                    :  returns a list of Study Counducting Countries
     * @Return Type                    :  List of Study Counducting Countries
     * @Parameters                     :  count
     */
    public static list < Study_Country__c> returnStudyConductingCountries(list<Project__c> lStudies,List<Country__c> lCountries) {
        list < Study_Country__c> lStudyCountries = new list < Study_Country__c> ();
        for (Project__c  oStudy: lStudies) {
            for (Country__c oCountry: lCountries) {
               
               Study_Country__c oStudyCountry= new Study_Country__c();
               
               oStudyCountry.Country__c=oCountry.id;
               oStudyCountry.Study__c=oStudy.id;
                 
               lStudyCountries.add(oStudyCountry);
            }
        }
        system.assertNotEquals(NULL, lStudyCountries);
        return lStudyCountries;        
    }
    
    /* 
     * @Method Name                    :  returnStudyBenifitingCountries
     * @Description                    :  returns a list of Study Benefitting Country
     * @Return Type                    :  List of Study Benefitting  Country
     * @Parameters                     :  count
     */
    public static list < Related_Country__c> returnStudyBenifitingCountries(list<Project__c> lStudies,List<Country__c> lCountries) {
        list < Related_Country__c> lStudyCountries = new list < Related_Country__c> ();
        for (Project__c  oStudy: lStudies) {
            for (Country__c oCountry: lCountries) {
               
               Related_Country__c oStudyCountry= new Related_Country__c();
               
               oStudyCountry.Country__c=oCountry.id;
               oStudyCountry.Project__c=oStudy.id;
                 
               lStudyCountries.add(oStudyCountry);
            }
        }
        system.assertNotEquals(NULL, lStudyCountries);
        return lStudyCountries;
    }
    
    /* 
     * @Method Name                    :  returnLOVs
     * @Description                    :  returns a list of LOVs
     * @Return Type                    :  List of LOVs
     * @Parameters                     :  count
     */
    public static list < LOV__c> returnLOVs(integer count) {
       
        list < LOV__c> lLOVs = new list < LOV__c> ();
        RecordType oRecType = [SELECT id, developername FROM RecordType WHERE SobjectType = 'LOV__c' AND name='ROLE' limit 1];
        
        for (integer i=0;i<count;i++) {
           
           LOV__c oLOV = new LOV__c();
           
           oLOV.Name ='test'+i;
           oLOV.recordtypeid=oRecType.id;
           oLOV.active__c=true;
             
           lLOVs.add(oLOV);
        }
        system.assertNotEquals(NULL, lLOVs);
        return lLOVs;
    }
     
     /* 
     * @Method Name                    :  returnStudyChecklists
     * @Description                    :  returns a list of Study Checklists
     * @Return Type                    :  List of Study Checklists
     * @Parameters                     :  count
     */
    public static list < Study_Checklist__c> returnStudyChecklists( list<Study_Checklist_Version__c> lStudyChecklistVersions,list < Checklist_Item__c> lChecklistItems) {
       
        list < Study_Checklist__c> lStudyChecklists = new list <Study_Checklist__c> ();
        
        for (Study_Checklist_Version__c oVersion : lStudyChecklistVersions) {
            for (Checklist_Item__c oQuestion : lChecklistItems) {
               
               Study_Checklist__c oStudyChecklist= new Study_Checklist__c();
               
               oStudyChecklist.Checklist_Item__c =oQuestion.id;
               oStudyChecklist.Study_Checklist_Version_Id__c=oVersion.id;
                 
               lStudyChecklists.add(oStudyChecklist);
            }
        }
        system.assertNotEquals(NULL, lStudyChecklists);
        return lStudyChecklists ;
    }  
    
    /* 
     * @Method Name                    :  returnStudyAttributes
     * @Description                    :  returns a list of Study Attributes
     * @Return Type                    :  List of Study Attributes
     * @Parameters                     :  count
     */
    public static list < Study_Attribute__c> returnStudyAttributes(list < Checklist_Item__c> lChecklistItems) {
       
        list < Study_Attribute__c> lStudyAttributes = new list <Study_Attribute__c> ();
        
        for (Checklist_Item__c oItem: lChecklistItems) {
            
               Study_Attribute__c oStudyAttribute= new Study_Attribute__c();
               
               oStudyAttribute.Checklist__c =oItem.id;
                 
               lStudyAttributes.add(oStudyAttribute);
            
        }
        system.assertNotEquals(NULL, lStudyAttributes);
        return lStudyAttributes ;
    }   
    
    /* 
     * @Method Name                    :  returnChecklistResponses
     * @Description                    :  returns a list of checklist responses
     * @Return Type                    :  List of checklist responses
     * @Parameters                     :  count
     */
    public static list < Checklist_Response__c> returnChecklistResponses(list<Checklist_Item__c> lChecklistItems,List<Question_Option__c> lOptions) {
        list < Checklist_Response__c> lChecklistResponses= new list < Checklist_Response__c> ();
        for (Checklist_Item__c oItem: lChecklistItems) {
            for (Question_Option__c oOption: lOptions) {
               
               Checklist_Response__c oResp= new Checklist_Response__c();
               
               oResp.Checklist__c=oItem.id;
               oResp.Response__c=oOption.id;
                 
               lChecklistResponses.add(oResp);
            }
        }
        system.assertNotEquals(NULL, lChecklistResponses);
        return lChecklistResponses;
    }
    
      /* 
     * @Method Name                    :  GetStudyFieldsUsingDescribe
     * @Description                    :  returns list of study fields
     * @Return Type                    :  List of Study fields
     * @Parameters                     :  none
     */
     
     Public List<String> GetStudyFieldsUsingDescribe(){
        List<String> sStudyAttribute = new List <String> ();
        for (String fieldName: Schema.SObjectType.project__c.fields.getMap().keySet()) {
            sStudyAttribute.add(fieldName);
        }
        system.assertNotEquals(NULL, sStudyAttribute);
        return sStudyAttribute;
    }
    
    

}