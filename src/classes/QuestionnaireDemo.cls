/****************************************************************************************************************************************** 
 * Class Name   : Questionnaire 
 * Description  : Class for the Questionnaire Page. A checklist is generated based on Questionnaire response
 * Created By   : Deloitte Consulting
 * 
 *****************************************************************************************************************************************/
Public with sharing class QuestionnaireDemo {

    Public List < wQuestions > lwQuestions {
        get;
        set;
    }

    public Map < Id, List < wcheckBoxes >> mCheckBoxes {
        get;
        set;
    }

    List < Study_Questionnaire__c > lInsertStudyQuestionaire;
    Public String sQuestionId {
        get;
        set;
    } // Carries the QuestionId that has been selected 
    Public Boolean IsPageEnabled {
        get;
        set;
    }
    Public Project__c oProject {
        get;
        Set;
    }
    Study_Questionnaire__c oCurrentStudyQuestionaire;
    String sStudyQuery = '';


    //Method to Populate team members
    public Map < Id, String > mStudyTeamMembers {
        get {
            if (mStudyTeamMembers == null) {
                Map < Id, String > mStudyTeamMembersLocal = new Map < Id, String > ();
                for (Project__Share oShare: [Select ParentId, AccessLevel, UserOrGroupId from Project__Share where ParentId =: oProject.Id AND AccessLevel = 'Edit']) {
                    mStudyTeamMembersLocal.put(oShare.UserOrGroupId, null);
                }
                for (User oUser: [SELECT id, Name from USER where id IN: mStudyTeamMembersLocal.keyset()]) {
                    mStudyTeamMembersLocal.put(oUser.Id, oUser.Name);
                }

                If(mStudyTeamMembersLocal.keyset().contains(UserInfo.getUserId()) || oProject.OwnerId == UserInfo.getUserId()) {
                    IsPageEnabled = True;
                } else {
                    IsPageEnabled = False;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning, 'You must be a Part of the Study Team in Order to Access this Page.'));
                }
                this.mStudyTeamMembers = mStudyTeamMembersLocal;
            }
            return mStudyTeamMembers;
        }
        private set;
    }


    /* 
     * @Method Name                    :  GetStudyFieldsUsingDescribe
     * @Description                    :  this method returns a list of study fields
     * @Return Type                    :  List<String>
     * @Parameters                     :  None
     */
    Public List < String > GetStudyFieldsUsingDescribe() {
        List < String > sStudyAttribute = new List < String > ();
        for (String fieldName: Schema.SObjectType.project__c.fields.getMap().keySet()) {

            sStudyAttribute.add(fieldName);
            sStudyQuery = sStudyQuery + ',' + fieldName;

        }
        sStudyQuery = sStudyQuery.removestart(',');
        return sStudyAttribute;
    }

    //Loading the constructor
    public QuestionnaireDemo(ApexPages.StandardController stdContrller) {

        List < Questionnaire_Question__c > lQuestionaireQuestions = new List < Questionnaire_Question__c > ();
        Map < Id, List < SelectOption >> mQuestions = new Map < Id, List < SelectOption >> ();
        Map < Id, List < wQuestions >> mDependentQuestions = new Map < Id, List < wQuestions >> ();
        Set < Id > sQuestionIds = new Set < Id > ();
        mCheckBoxes = new Map < Id, List < wcheckBoxes > > ();
        lInsertStudyQuestionaire = new List < Study_Questionnaire__c > ();
        List < Study_Questionnaire__c > lStudyQuestionaire = new List < Study_Questionnaire__c > ();
        Questionaire__c oQuestionaire;
        lwQuestions = new List < wQuestions > (); //List that gets displayed on VF page

        //Add all fields on controller
        if (!test.isRunningTest()) {
            stdContrller.addfields(GetStudyFieldsUsingDescribe());
        }
        List < Study_Questionnaire__c > lStudyCorrectQuestionnaire = new List < Study_Questionnaire__c > ();
        lStudyCorrectQuestionnaire = [Select id, Questionnaire__c, Questionnaire__r.Study_Type__c from Study_Questionnaire__c where Questionnaire__c != null and Study__c =: stdContrller.getId() and Questionnaire__r.Study_Type__c =: ((Project__c) stdContrller.getrecord()).Study_Description__c];
        if (((Project__c) stdContrller.getrecord()).QFOR_Study_Questionnaires__r.size() == 0 || lStudyCorrectQuestionnaire.size() == 0) {

            Questionaire__c oActiveQuestionnaire = [select id from Questionaire__c where active__c =: true AND Study_Type__c =: ((Project__c) stdContrller.getrecord()).Study_Description__c];

            Study_Questionnaire__c oStudyQuestion = new Study_Questionnaire__c();
            oStudyQuestion.Study__c = stdContrller.getId();
            oStudyQuestion.Questionnaire__c = oActiveQuestionnaire.Id;
            oQuestionaire = oActiveQuestionnaire;
            lInsertStudyQuestionaire.add(oStudyQuestion);
        } else {
            for (Study_Questionnaire__c oStudyQuestionnaire: [Select id, Questionnaire__c from Study_Questionnaire__c where Questionnaire__c != null and Study__c =: stdContrller.getId() and Questionnaire__r.Study_Type__c =: ((Project__c) stdContrller.getrecord()).Study_Description__c order by createddate desc]) {
                oQuestionaire = new Questionaire__c(id = oStudyQuestionnaire.Questionnaire__c);
                oCurrentStudyQuestionaire = oStudyQuestionnaire;
                break;
            }
        }

        // Query all the questions in questionaire        
        for (Questionnaire_Question__c oQuestionaireQuestions: [select id, Question__c, Question__r.Default_Study_Field__c, 
        Question__r.Id, Question__r.Help_Text__c, Question__r.Response_Type__c, Question__r.Question_Text__c 
        from Questionnaire_Question__c where Questionnaire__c =: oQuestionaire.Id order by Sequence__c]) {
            lQuestionaireQuestions.add(oQuestionaireQuestions);
            sQuestionIds.add(oQuestionaireQuestions.Question__c);
            if ((oQuestionaireQuestions.Question__r.Response_Type__c == 'Comments') || 
            (oQuestionaireQuestions.Question__r.Response_Type__c == 'Date')) {
                mQuestions.put(oQuestionaireQuestions.Question__c, new List < SelectOption > ());
            }
            if (oQuestionaireQuestions.Question__r.Response_Type__c == 'Checkbox') {
                mQuestions.put(oQuestionaireQuestions.Question__c, new List < SelectOption > ());
                mCheckboxes.put(oQuestionaireQuestions.Question__c, new List < wCheckboxes > ());
            }
        }

        // Make a map of all Questions to options, this map doesnt include the questions with no response options     
        for (Question_Option__c oQuestionOptions: [Select id, name, Question__c , Question__r.Response_Type__c from Question_Option__c
                where Question__c IN: sQuestionIds or Question__r.Dependent_Question__c =: true order by Id
            ]) {
            if (!mQuestions.containskey(oQuestionOptions.Question__c)) {
                mQuestions.put(oQuestionOptions.Question__c, new List < Selectoption > {
                    new SelectOption(oQuestionOptions.Id, oQuestionOptions.Name)
                });
            } else {
                mQuestions.get(oQuestionOptions.Question__c).add(new SelectOption(oQuestionOptions.Id, oQuestionOptions.Name));
            }

        }

        if (mCheckboxes.size() > 0) {
            for(ID questionID : mCheckboxes.keySet()) {
                if(mQuestions.get(questionID) != null) {
                    List<System.SelectOption> optList = mQuestions.get(questionID);
                    for(SelectOption option : optList) {
                    mCheckBoxes.get(questionId).add(new wCheckboxes(option.getLabel(), false));
                    }
                }
            }
        }

        //Add the questions to map which doesnt have responses too - This is a nice to have a feature when there is no response
        for (Questions__c oQuestions: [Select id from Questions__c where Dependent_Question__c =: true]) {
            if (!mQuestions.containskey(oQuestions.Id))
                mQuestions.put(oQuestions.Id, new List < Selectoption > ());
        }


        Map < Id, Study_Questionnaire_Response__c > mCurrentStudyQuestionnaireResponse = new Map < Id, Study_Questionnaire_Response__c > ();
        if (oCurrentStudyQuestionaire != null) {
            for (Study_Questionnaire_Response__c oQuestionReponse: [Select id, Question__c, Response__c, Comments_Response__c,Date_Response__c,  Study_Questionnaire_ID__c from Study_Questionnaire_Response__c where Study_Questionnaire_ID__c =: oCurrentStudyQuestionaire.Id]) {
                mCurrentStudyQuestionnaireResponse.put(oQuestionReponse.Question__c, oQuestionReponse);
                if(mCheckboxes.containsKey(oQuestionReponse.Question__c)) {
                    for(wCheckboxes wCheckbox : mCheckboxes.get(oQuestionReponse.Question__c)) {
                    if(oQuestionReponse.Comments_Response__c != null) {
                    System.debug('** line 171*'+wCheckbox);
                    System.debug('** line 172*'+oQuestionReponse);
                            if(oQuestionReponse.Comments_Response__c.containsIgnoreCase(wCheckbox.label)) {
                                wCheckbox.isSelected = true;                            
                            }
                        }
                    }
                }
            }
        }

        // Create a map of dependent questions with a set of child questions and thier options        
        for (Dependent_Question__c oDependent: [Select id, Question__c, Question__r.Default_Study_Field__c, Question__r.Help_Text__c, Question__r.name, option__r.Question__c, Question__r.Question_Text__c, Question__r.Response_Type__c from Dependent_Question__c where Question__c != null and option__r.Question__c != null]) {
            Questions__c oQuestion = new Questions__c(id = oDependent.Question__c, Default_Study_Field__c = oDependent.Question__r.Default_Study_Field__c, Help_Text__c = oDependent.Question__r.Help_Text__c, Question_Text__c = oDependent.Question__r.Question_Text__c, Response_Type__c = oDependent.Question__r.Response_Type__c);
            Id iReponseId;
            Boolean IsAnswered;

            if (oDependent.Question__r.Default_Study_Field__c != null && mQuestions.containskey(oDependent.Question__r.Id)) {
                for (Selectoption oSelectOption: mQuestions.get(oDependent.Question__r.Id)) {
                    if (oSelectOption.getlabel() == (stdContrller.getrecord()).get(oDependent.Question__r.Default_Study_Field__c)) {
                        iReponseId = oSelectOption.getvalue();
                        If(iReponseId != NULL) {
                            IsAnswered = TRUE;
                        }
                    }
                }
            } else if (mCurrentStudyQuestionnaireResponse.containskey(oDependent.Question__c))
                iReponseId = mCurrentStudyQuestionnaireResponse.get(oDependent.Question__c).Response__c;
            If(iReponseId != NULL) {
                IsAnswered = TRUE;
            }
            if (!mDependentQuestions.containskey(oDependent.option__r.Question__c) && mQuestions.get(oDependent.Question__c) != null) {
                mDependentQuestions.put(oDependent.option__r.Question__c, new List < wQuestions > {
                    new wQuestions(oQuestion, mQuestions.get(oDependent.Question__c), iReponseId, null, oDependent.option__c, FALSE)
                });
            } else if (mQuestions.get(oDependent.Question__c) != null) {
                mDependentQuestions.get(oDependent.option__r.Question__c).add(new wQuestions(oQuestion, mQuestions.get(oDependent.Question__c), iReponseId, null, oDependent.option__c, FALSE));
            }
        }


        // Final List that gets added to list with all related data that is captured.
        for (Questionnaire_Question__c oQuestionaireQuestions: lQuestionaireQuestions) {
            Questions__c oQuestion = new Questions__c(id = oQuestionaireQuestions.Question__c, Default_Study_Field__c = oQuestionaireQuestions.Question__r.Default_Study_Field__c, Question_Text__c = oQuestionaireQuestions.Question__r.Question_Text__c, Help_Text__c = oQuestionaireQuestions.Question__r.Help_Text__c, Response_Type__c = oQuestionaireQuestions.Question__r.Response_Type__c);
            Id iReponseId;
            String commentsResponse = '';
            if (oQuestionaireQuestions.Question__r.Default_Study_Field__c != null && mQuestions.containskey(oQuestionaireQuestions.Question__r.Id)) {
                for (Selectoption oSelectOption: mQuestions.get(oQuestionaireQuestions.Question__r.Id)) {
                    if (oSelectOption.getlabel() == (stdContrller.getrecord()).get(oQuestionaireQuestions.Question__r.Default_Study_Field__c)) {
                        iReponseId = oSelectOption.getvalue();
                    }
                }
            } else if (mCurrentStudyQuestionnaireResponse.containskey(oQuestionaireQuestions.Question__c)) {
                iReponseId = mCurrentStudyQuestionnaireResponse.get(oQuestionaireQuestions.Question__c).Response__c;
                commentsResponse = mCurrentStudyQuestionnaireResponse.get(oQuestionaireQuestions.Question__c).Comments_Response__c;
            }
            if (oQuestionaireQuestions.Question__r.Id != null && mQuestions.get(oQuestionaireQuestions.Question__r.Id) != null && mDependentQuestions.get(oQuestionaireQuestions.Question__r.Id) != null) {
                wQuestions QuesObj = new wQuestions(oQuestion, mQuestions.get(oQuestionaireQuestions.Question__r.Id),
                    iReponseId, mDependentQuestions.get(oQuestionaireQuestions.Question__r.Id), null, FALSE);
                Quesobj.commentsResponse = commentsResponse;
                Quesobj.checkboxResponse = new List < String > ();
                lwQuestions.add(QuesObj);

            } else if (mQuestions.get(oQuestionaireQuestions.Question__r.Id) != null) {
                wQuestions QuesObj = new wQuestions(oQuestion, mQuestions.get(oQuestionaireQuestions.Question__r.Id), 
                iReponseId, new List < wQuestions > (), null, FALSE);
                if(mCurrentStudyQuestionnaireResponse.get(oQuestionaireQuestions.Question__c) != null) {
                QuesObj.response = new Study_Questionnaire_Response__c(Date_Response__c = mCurrentStudyQuestionnaireResponse.get(oQuestionaireQuestions.Question__c).Date_Response__c);
                }
                Quesobj.commentsResponse = commentsResponse;
                Quesobj.checkboxResponse = new List < String > ();
                lwQuestions.add(QuesObj);
            }

        }
        oProject = (Project__c) stdContrller.getrecord();
        getiAnsweredQuestionsCount();
    }


    /* 
     * @Method Name                    :  onLoadCheckNInsertQuestionaire
     * @Description                    :  This method inserts study questionnaire and its responses
     * @Return Type                    :  void
     * @Parameters                     :  none
     */
    Public void onLoadCheckNInsertQuestionaire() {

        if (oProject.study_stage__c == null) {
            oProject.study_stage__c = 'Questionnaire';
            Update oProject;
        }
        //Insert Questionnaire
        If(lInsertStudyQuestionaire.size() > 0) {

            Insert lInsertStudyQuestionaire;
            List < Study_Questionnaire_Response__c > lStudyResponse = new List < Study_Questionnaire_Response__c > ();
            for (wQuestions owQuestions: lwQuestions) {
                if (owQuestions.iQuestionResponse != null) {
                    Study_Questionnaire_Response__c oStudyReponse = new Study_Questionnaire_Response__c();
                    oStudyReponse.Question__c = owQuestions.oQuestions.Id;
                    oStudyReponse.Response__c = owQuestions.iQuestionResponse;
                    oStudyReponse.Study_Questionnaire_ID__c = lInsertStudyQuestionaire[0].id;
                    lStudyResponse.add(oStudyReponse);
                }
            }

            if (lStudyResponse.size() > 0)
                Insert lStudyResponse;
            oCurrentStudyQuestionaire = lInsertStudyQuestionaire[0];

        }
    }


    /* 
     * @Method Name                    :  save
     * @Description                    :  This method is executed when a user selects a response for a questions
     * @Return Type                    :  void
     * @Parameters                     :  none
     */
    Public void save() {
        Map < Id, Study_Questionnaire_Response__c > mPreviousQuestionnaireResponse = new Map < Id, Study_Questionnaire_Response__c > ();
        Map < Id, wQuestions > mCurrentQuestionnaireResponseValues = new Map < Id, wQuestions > ();
        Set < Study_Questionnaire_Response__c > sDependentRecordsDeletion = new Set < Study_Questionnaire_Response__c > ();

        for (Study_Questionnaire_Response__c oQuestionReponse: [Select id, Question__c, Question__r.dependent_Question__c,Question__r.Response_Type__c, 
                Response__c, Comments_Response__c,Date_Response__c,  Study_Questionnaire_ID__c from Study_Questionnaire_Response__c where Study_Questionnaire_ID__c =: oCurrentStudyQuestionaire.Id
            ]) {
            mPreviousQuestionnaireResponse.put(oQuestionReponse.Question__c, oQuestionReponse);
        }

        for (wQuestions oQuestionReps: lwQuestions) {
            mCurrentQuestionnaireResponseValues.put(oQuestionReps.oQuestions.id, oQuestionReps);
            if (oQuestionReps.lDependentQuestions.size() > 0) {
                for (wQuestions oDependentQuestionReps: oQuestionReps.lDependentQuestions) {
                    if (oDependentQuestionReps.iParentDependentResponse == oQuestionReps.iQuestionResponse)
                        mCurrentQuestionnaireResponseValues.put(oDependentQuestionReps.oQuestions.id, oDependentQuestionReps);
                    else if (mPreviousQuestionnaireResponse.containskey(oDependentQuestionReps.oQuestions.Id)) {
                        sDependentRecordsDeletion.add(mPreviousQuestionnaireResponse.get(oDependentQuestionReps.oQuestions.Id));
                        oDependentQuestionReps.iQuestionResponse = null;
                    }
                }
            }
        }
        
        if (mPreviousQuestionnaireResponse.containskey(sQuestionId) && mCurrentQuestionnaireResponseValues.containskey(sQuestionId) &&
            mPreviousQuestionnaireResponse.get(sQuestionId).Response__c != 
            mCurrentQuestionnaireResponseValues.get(sQuestionId).iQuestionResponse) {
            Study_Questionnaire_Response__c oPangQuestionaire = mPreviousQuestionnaireResponse.get(sQuestionId);
            oPangQuestionaire.response__c = mCurrentQuestionnaireResponseValues.get(sQuestionId).iQuestionResponse;
            if (oPangQuestionaire.response__c <> NULL) {
                update oPangQuestionaire;
            }
        } else if (!mPreviousQuestionnaireResponse.containskey(sQuestionId) &&
            mCurrentQuestionnaireResponseValues.containskey(sQuestionId)) {
            Study_Questionnaire_Response__c oResponse = new Study_Questionnaire_Response__c();
            oResponse.Response__c = mCurrentQuestionnaireResponseValues.get(sQuestionId).iQuestionResponse;
            oResponse.Question__c = sQuestionId;
            oResponse.Study_Questionnaire_ID__c = oCurrentStudyQuestionaire.id;
            if (oResponse <> NULL) {
                insert oResponse;
            }
        }

        // adding a condition for Comments type question. 

        if ((mPreviousQuestionnaireResponse.containskey(sQuestionId) && mCurrentQuestionnaireResponseValues.containskey(sQuestionId) &&
            mPreviousQuestionnaireResponse.get(sQuestionId).Comments_Response__c != 
            mCurrentQuestionnaireResponseValues.get(sQuestionId).commentsResponse)  || 
            (mCurrentQuestionnaireResponseValues.get(sQuestionId).oQuestions.Response_Type__c == 'Checkbox') || 
            (mCurrentQuestionnaireResponseValues.get(sQuestionId).oQuestions.Response_Type__c == 'Date') ) {
            System.debug('*****'+sQuestionId);
            System.debug('***line 340**'+mPreviousQuestionnaireResponse.get(sQuestionId));
            Study_Questionnaire_Response__c oPangQuestionaire = new Study_Questionnaire_Response__c();
            if(mPreviousQuestionnaireResponse.get(sQuestionId) != null) {
            oPangQuestionaire = mPreviousQuestionnaireResponse.get(sQuestionId);
            } else {
            
            }
            if(mCurrentQuestionnaireResponseValues.get(sQuestionId) != null) {
            oPangQuestionaire.Comments_response__c = mCurrentQuestionnaireResponseValues.get(sQuestionId).commentsResponse;
            }
            if (oPangQuestionaire.Question__r.Response_Type__c == 'Checkbox') {
                oPangQuestionaire.Comments_Response__c = chosenOptions(mCheckboxes.get(sQuestionId));
                mCurrentQuestionnaireResponseValues.get(sQuestionId).commentsResponse = chosenOptions(mCheckboxes.get(sQuestionId));
            }
            if (oPangQuestionaire.Question__r.Response_Type__c == 'Date') {
            System.debug(mCurrentQuestionnaireResponseValues.get(sQuestionId).dateResponse+'*********');
                oPangQuestionaire.Date_Response__c = mCurrentQuestionnaireResponseValues.get(sQuestionId).response.Date_Response__c;
            }
            if ((oPangQuestionaire.Comments_response__c <> NULL) || 
            (oPangQuestionaire.Question__r.Response_Type__c == 'Date') ) {
            if(oPangQuestionaire.Id != null) {
                update oPangQuestionaire;
                }
            }
            
        } else if (!mPreviousQuestionnaireResponse.containskey(sQuestionId) &&
            mCurrentQuestionnaireResponseValues.containskey(sQuestionId)) {
            Study_Questionnaire_Response__c oResponse = new Study_Questionnaire_Response__c();
            oResponse.Comments_response__c = mCurrentQuestionnaireResponseValues.get(sQuestionId).commentsResponse;
            if (oResponse.Question__r.Response_Type__c == 'Checkbox') {
                oResponse.Comments_Response__c = chosenOptions(mCheckboxes.get(sQuestionId));
            }
            if (oResponse.Question__r.Response_Type__c == 'Date') {
                oResponse.Date_Response__c = mCurrentQuestionnaireResponseValues.get(sQuestionId).response.Date_Response__c;
            }
            oResponse.Question__c = sQuestionId;
            oResponse.Study_Questionnaire_ID__c = oCurrentStudyQuestionaire.id;
            if (oResponse <> NULL) {
                insert oResponse;
            }
        }

        // adding a condition for Comments type question. 

        sQuestionId = null;
        if (sDependentRecordsDeletion.size() > 0) {
            List < Study_Questionnaire_Response__c > lDependentRecordsDeletion = new List < Study_Questionnaire_Response__c > ();
            lDependentRecordsDeletion.addall(sDependentRecordsDeletion);
            delete lDependentRecordsDeletion;

        }

        getiAnsweredQuestionsCount();


    }


    Public Integer getiAnsweredQuestionsCount() {
        try {
            integer i = 0;
            Map < Id, List < Id >> mParentDependentResponse = new Map < Id, List < Id >> ();
            Set < Id > sParentDependentResponse = new Set < Id > ();
            for (wQuestions oQuestionReps: lwQuestions) {
                mParentDependentResponse.put(oQuestionReps.oQuestions.Id, new List < Id > ());
                for (wQuestions oDepQuestionReps: oQuestionReps.lDependentQuestions) {
                    sParentDependentResponse.add(oDepQuestionReps.iParentDependentResponse);
                    if (oDepQuestionReps.iParentDependentResponse == oQuestionReps.iQuestionResponse) {
                        If(mParentDependentResponse.containsKey(oQuestionReps.oQuestions.Id)) {
                            mParentDependentResponse.get(oQuestionReps.oQuestions.Id).add(oDepQuestionReps.iParentDependentResponse);
                        }
                        Else If(oDepQuestionReps.iParentDependentResponse != NULL && !mParentDependentResponse.containsKey(oQuestionReps.oQuestions.Id)) {
                            mParentDependentResponse.put(oQuestionReps.oQuestions.Id, new List < Id > {
                                oDepQuestionReps.iParentDependentResponse
                            });
                        }
                    }
                }
            }
            for (wQuestions oQuestionReps: lwQuestions) {
                integer j = 0;
                if (oQuestionReps.iQuestionResponse != null && oQuestionReps.lDependentQuestions.size() == 0 && 
                oQuestionReps.oQuestions.Response_Type__c != 'Comments' && 
                oQuestionReps.oQuestions.Response_Type__c != 'Date') {
                    oQuestionReps.IsAnswered = TRUE;
                    i++;
                } else if (oQuestionReps.commentsResponse != null && oQuestionReps.lDependentQuestions.size() == 0 && 
                (oQuestionReps.oQuestions.Response_Type__c == 'Comments' || oQuestionReps.oQuestions.Response_Type__c == 'Checkbox')) {
                    oQuestionReps.IsAnswered = TRUE;
                    i++;
                }  else if (oQuestionReps.response.Date_Response__c != null && oQuestionReps.lDependentQuestions.size() == 0 && 
                (oQuestionReps.oQuestions.Response_Type__c == 'Date')) {
                    oQuestionReps.IsAnswered = TRUE;
                    i++;
                } else if (oQuestionReps.iQuestionResponse != null && oQuestionReps.lDependentQuestions.size() != 0 &&
                    sParentDependentResponse.contains(oQuestionReps.iQuestionResponse)) {
                    for (wQuestions oDepQuestionReps: oQuestionReps.lDependentQuestions) {
                        if (oDepQuestionReps.iQuestionResponse != null && oDepQuestionReps.iParentDependentResponse == oQuestionReps.iQuestionResponse) {
                            j++;
                        } else {
                            oQuestionReps.IsAnswered = FALSE;
                        }
                    }

                    If(mParentDependentResponse.get(oQuestionReps.oQuestions.Id).size() == j && j != 0) {
                        oQuestionReps.IsAnswered = TRUE;
                        i++;
                    }
                } else if (oQuestionReps.lDependentQuestions.size() != 0 && oQuestionReps.iQuestionResponse != null && !sParentDependentResponse.contains(oQuestionReps.iQuestionResponse)) {
                    oQuestionReps.IsAnswered = TRUE;
                    i++;
                } else {
                    oQuestionReps.IsAnswered = FALSE;
                }
            }

            return i;
        } catch (exception e) {
            return 0;
        }
    }

    Public class wQuestions {
        Public Questions__c oQuestions {
            get;
            set;
        }
        public Study_Questionnaire_Response__c response {set;get;}
        Public List < SelectOption > lQuestionResponses {
            get;
            set;
        }
        Public Id iQuestionResponse {
            get;
            set;
        }
        Public Date dateResponse {
            get;
            set;
        }
        public String commentsResponse {
            set;
            get;
        }
        public String[] checkboxResponse {
            set;
            get;
        }

        Public List < wQuestions > lDependentQuestions {
            get;
            set;
        }
        Public Id iParentDependentResponse {
            get;
            set;
        }
        Public Boolean IsAnswered {
            get;
            set;
        }

        Public wQuestions(Questions__c oQuestions, List < SelectOption > lQuestionResponses,
            Id iQuestionResponse, List < wQuestions > lDependentQuestions, Id iParentDependentResponse,
            Boolean IsAnswered) {
            this.oQuestions = oQuestions;
            this.lQuestionResponses = lQuestionResponses;
            this.iQuestionResponse = iQuestionResponse;
            this.lDependentQuestions = lDependentQuestions;
            this.iParentDependentResponse = iParentDependentResponse;
            this.IsAnswered = IsAnswered;
        }

    }

    /******************************************************************************************************************************************
     * Class Name   : wCheckBoxes
     * Description  : wrapper class to store the options values , if the question type is a picklist.
     * Created By   : Deloitte Consulting
     *****************************************************************************************************************************************/
    public class wCheckBoxes {
        public Boolean isSelected {
            get;
            set;
        }
        public string label {
            get;
            set;
        }
        public wCheckBoxes(String label, Boolean isSelected) {
            this.label = label;
            this.isSelected = isSelected;
        }
    }

    /* 
     * @Method Name                    :  goToChecklist
     * @Description                    :  This method is executed when a user submits a questionnaire. A Checklist is generated.
     * @Return Type                    :  pagereference 
     * @Parameters                     :  none
     */
    public pagereference goToChecklist() {
        CheckNLoadDefaultQuestion();
        GenerateCheckList();
        return new pagereference('/apex/checklist?id=' + oProject.id);
    }

    /* 
     * @Method Name                    :  CheckNLoadDefaultQuestion
     * @Description                    :  This method is to make sure all defaulted responses are inserted properly since those values are never set since it is defaulted to study attribute value
     * @Return Type                    :  void
     * @Parameters                     :  none
     */
    Public void CheckNLoadDefaultQuestion() {
        Map < Id, Id > mCurrentResponseValues = new Map < Id, Id > ();
        List < Study_Questionnaire_Response__c > lStudyResponse = new List < Study_Questionnaire_Response__c > ();

        for (Study_Questionnaire_Response__c oQuestionReponse: [Select id, Question__c, Question__r.dependent_Question__c, Response__c, Study_Questionnaire_ID__c from Study_Questionnaire_Response__c where Study_Questionnaire_ID__c =: oCurrentStudyQuestionaire.Id]) {
            mCurrentResponseValues.put(oQuestionReponse.Question__c, oQuestionReponse.Response__c);
        }


        for (wQuestions oQuestionReps: lwQuestions) {
            if (oQuestionReps.iQuestionResponse != null && !mCurrentResponseValues.containskey(oQuestionReps.oQuestions.Id)) {
                Study_Questionnaire_Response__c oStudyReponse = new Study_Questionnaire_Response__c();
                oStudyReponse.Question__c = oQuestionReps.oQuestions.Id;
                oStudyReponse.Response__c = oQuestionReps.iQuestionResponse;
                oStudyReponse.Study_Questionnaire_ID__c = oCurrentStudyQuestionaire.Id;
                lStudyResponse.add(oStudyReponse);
            }
            for (wQuestions oDependentQuestionReps: oQuestionReps.lDependentQuestions) {
                If(oDependentQuestionReps.iQuestionResponse != null && !mCurrentResponseValues.containskey(oDependentQuestionReps.oQuestions.Id) && oDependentQuestionReps.iParentDependentResponse == oQuestionReps.iQuestionResponse) {
                    Study_Questionnaire_Response__c oStudyDepReponse = new Study_Questionnaire_Response__c();
                    oStudyDepReponse.Question__c = oDependentQuestionReps.oQuestions.Id;
                    oStudyDepReponse.Response__c = oDependentQuestionReps.iQuestionResponse;
                    oStudyDepReponse.Study_Questionnaire_ID__c = oCurrentStudyQuestionaire.Id;
                    lStudyResponse.add(oStudyDepReponse);
                }
            }
        }

        if (lStudyResponse.size() > 0)
            Insert lStudyResponse;


    }


    /* 
     * @Method Name                    :  GenerateCheckList
     * @Description                    :  This method generates checklist based on questionnaire response
     * @Return Type                    :  void
     * @Parameters                     :  none
     */
    Public void GenerateCheckList() {
        String sProjectId = oProject.Id;
        oProject = database.Query('Select ' + sStudyQuery + ' from Project__c where id = : sProjectId');
        Map < Id, List < Checklist_Response__c >> mCheckListResponse = new Map < Id, List < Checklist_Response__c >> ();
        Map < Id, List < Study_Attribute__c >> mStudyAttribute = new Map < Id, List < Study_Attribute__c >> ();
        Set < Id > sFinalChecklistItems = new Set < Id > ();
        Map < Id, Checklist_Versionaire__c > mCheckListVersionaire = new Map < Id, Checklist_Versionaire__c > ();
        Map < Id, Study_Checklist__c > mStudyCheckListItem = new Map < Id, Study_Checklist__c > ();
        Map < Id, Checklist_item__c > mCheckListItem = new Map < Id, Checklist_item__c > ();
        Set < Id > sMatchingStudyAttributes = new Set < Id > ();
        Set < Id > sActualResponseIds = new Set < Id > ();
        Checklist_Version__c oActiveChecklistVersion = [select id from Checklist_Version__c where active__c =: true AND Study_Type__c =: oProject.Study_Description__c];

        List < Study_Checklist_Version__c > lCurrentStudyChecklistVersions = [Select id, Checklist_Version_ID__c, Study__c, Study_Questionnaire_ID__c, (Select id from Study_Checklists__r) from Study_Checklist_Version__c where Study__c =: oProject.Id order by createddate Desc limit 1];

        if (lCurrentStudyChecklistVersions.size() > 0) {
            for (Study_Checklist_Version__c oStudyVersions: [Select id, Checklist_Version_ID__c, Study__c, Study_Questionnaire_ID__c, (Select id, Checklist_Item__r.Id, Completed__c, role__c, comment__c from Study_Checklists__r) from Study_Checklist_Version__c where Study__c =: oProject.Id order by createddate Desc limit 1]) {
                for (Study_Checklist__c oStudyChecklistItem: oStudyVersions.Study_Checklists__r) {
                    mStudyCheckListItem.put(oStudyChecklistItem.Checklist_Item__r.Id, oStudyChecklistItem);
                }
            }
        }

        Study_Checklist_Version__c oStudyChecklistVersion = new Study_Checklist_Version__c();
        oStudyChecklistVersion.Study__c = oProject.Id;
        oStudyChecklistVersion.Study_Questionnaire_ID__c = oCurrentStudyQuestionaire.Id;
        oStudyChecklistVersion.Checklist_Version_ID__c = oActiveChecklistVersion.Id;
        Insert oStudyChecklistVersion;

        for (Checklist_Versionaire__c oVersionaire: [Select id, Checklist_Item_Id__c, sequence__c from Checklist_Versionaire__c where Checklist_Version_Id__c =: oStudyChecklistVersion.Checklist_Version_ID__c]) {
            mCheckListVersionaire.put(oVersionaire.Checklist_Item_Id__c, oVersionaire);
        }

        for (Checklist_Item__c oChecklistMaster: [Select Id, Mandatory__c, Default_role__c, Default_role__r.active__c, (Select id, Study_Field__c, Study_Attribute__c from Checklist_Driver__r), (Select id, Response__c from QFOR_Checklist_Responses__r) from Checklist_Item__c where id in: mCheckListVersionaire.keyset()]) {
            mCheckListItem.put(oChecklistMaster.Id, oChecklistMaster);
            if (oChecklistMaster.Mandatory__c) {
                sFinalChecklistItems.add(oChecklistMaster.Id);
            } else {
                if (oChecklistMaster.Checklist_Driver__r.size() > 0)
                    mStudyAttribute.put(oChecklistMaster.Id, oChecklistMaster.Checklist_Driver__r);
                if (oChecklistMaster.QFOR_Checklist_Responses__r.size() > 0)
                    mCheckListResponse.put(oChecklistMaster.Id, oChecklistMaster.QFOR_Checklist_Responses__r);
            }
        }

        sMatchingStudyAttributes.addall(mStudyAttribute.keyset());

        for (Id oCheckListMaster: mStudyAttribute.keyset()) {
            for (Study_Attribute__c oStudyAttribute: mStudyAttribute.get(oCheckListMaster)) {
                if (oStudyAttribute.Study_Field__c != NULL & oStudyAttribute.Study_Attribute__c != NULL) {
                    String sStudyField = (String.Valueof(oProject.get(oStudyAttribute.Study_Field__c)));
                    String sStudyAttribute = oStudyAttribute.Study_Attribute__c;
                    Schema.DisplayType fType = Schema.SObjectType.Project__c.fields.getMap().get(oStudyAttribute.Study_Field__c).getDescribe().getType();
                    If(sStudyAttribute == 'TRUE' || sStudyAttribute == 'FALSE' || sStudyAttribute == 'False' || sStudyAttribute == 'True') {
                        sStudyAttribute = sStudyAttribute.toLowerCase();
                    }
                    If(String.valueof(fType) == 'MULTIPICKLIST') {
                        if (oStudyAttribute.Study_Field__c == null || oStudyAttribute.Study_Attribute__c == null || oProject.get(oStudyAttribute.Study_Field__c) == null || ((!sStudyAttribute.contains(sStudyField)) && (!sStudyField.contains(sStudyAttribute)))) {
                            sMatchingStudyAttributes.remove(oCheckListMaster);
                            break;
                        }
                    }
                    If(String.valueof(fType) <> 'MULTIPICKLIST') {
                        if (oStudyAttribute.Study_Field__c == null || oStudyAttribute.Study_Attribute__c == null || oProject.get(oStudyAttribute.Study_Field__c) == null || (!sStudyAttribute.equals(sStudyField))) {
                            sMatchingStudyAttributes.remove(oCheckListMaster);
                            break;
                        }
                    }

                }
            }
        }

        sFinalChecklistItems.addall(sMatchingStudyAttributes);

        for (wQuestions oQuestionReps: lwQuestions) {
            if (oQuestionReps.iQuestionResponse != null)
                sActualResponseIds.add(oQuestionReps.iQuestionResponse);
            if (oQuestionReps.lDependentQuestions.size() > 0) {
                for (wQuestions oQuestion: oQuestionReps.lDependentQuestions)
                    if (oQuestion.iQuestionResponse != null)
                        sActualResponseIds.add(oQuestion.iQuestionResponse);
            }
        }

        for (Id oCheckListResponse: mCheckListResponse.keyset()) {
            Set < Id > sCheckListResponseIds = new Set < Id > ();
            for (Checklist_Response__c oCheckListResponses: mCheckListResponse.get(oCheckListResponse)) {
                sCheckListResponseIds.add(oCheckListResponses.Response__c);
            }
            if (sActualResponseIds.containsall(sCheckListResponseIds) && (!mStudyAttribute.containskey(oCheckListResponse) || (mStudyAttribute.containskey(oCheckListResponse) && sFinalChecklistItems.contains(oCheckListResponse)))) {
                sFinalChecklistItems.add(oCheckListResponse);
            } else if (!sActualResponseIds.containsall(sCheckListResponseIds)) {
                sFinalChecklistItems.remove(oCheckListResponse);
            }

        }

        List < Study_Checklist__c > lStudyChecklist = new List < Study_Checklist__c > ();
        for (ID oChecklistMaster: sFinalChecklistItems) {
            Study_Checklist__c oStudyChecklist = new Study_Checklist__c();
            oStudyChecklist.Checklist_Item__c = oChecklistMaster;
            oStudyChecklist.Study_Checklist_Version_Id__c = oStudyChecklistVersion.Id;
            // When you create the study for the first time dont show exclamation 
            if (lCurrentStudyChecklistVersions.size() > 0 && mStudyCheckListItem.size() > 0) {
                oStudyChecklist.Newly_Added__c = true;
            }
            if (mCheckListVersionaire.containskey(oChecklistMaster))
                oStudyChecklist.sequence__c = mCheckListVersionaire.get(oChecklistMaster).sequence__c;
            if (mCheckListItem.containskey(oChecklistMaster) && mCheckListItem.get(oChecklistMaster).Default_role__r.active__c == true) {
                oStudyChecklist.Role__c = mCheckListItem.get(oChecklistMaster).Default_role__c;
            }

            //Below code brings the old values of the studychecklist
            if (mStudyCheckListItem.containskey(oStudyChecklist.Checklist_Item__c)) {
                oStudyChecklist.Completed__c = mStudyCheckListItem.get(oStudyChecklist.Checklist_Item__c).Completed__c;
                if (mStudyCheckListItem.get(oStudyChecklist.Checklist_Item__c).Role__c != null)
                    oStudyChecklist.Role__c = mStudyCheckListItem.get(oStudyChecklist.Checklist_Item__c).Role__c;
                oStudyChecklist.Newly_Added__c = false;
                oStudyChecklist.comment__c = mStudyCheckListItem.get(oStudyChecklist.Checklist_Item__c).comment__c;
            }
            lStudyChecklist.add(oStudyChecklist);
        }
        Insert lStudyChecklist;

        if (oProject.study_stage__c == null || oProject.study_stage__c == 'Questionnaire' || oProject.study_stage__c == 'Questionnaire Needs Review') {
            oProject.study_stage__c = 'Ideation';
            if (oProject.Close_out__c) {
                oProject.Close_out__c = false;
            }
            Update oProject;
        }


    }
    
     public string chosenOptions(List < wCheckboxes > lWrapperForProcessing) {
        String sClause = TRFO_Constants.emptyString;
        for (wCheckboxes oWrapper: lWrapperForProcessing) {
            if (oWrapper.isSelected) {
                sClause += oWrapper.label + TRFO_Constants.COMMA;
            }
        }
        if (sClause != TRFO_Constants.emptyString) {
            sClause = sClause.removeend(TRFO_Constants.COMMA);
        }
        return sClause;
    }

}