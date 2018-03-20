/****************************************************************************************************************************************** 
 * Class Name   : DragNdrop
 * Description  : Class for Drag and Drop
 * Created By   : Deloitte Consulting
 * 
 *****************************************************************************************************************************************/
Public with Sharing Class DragNdrop {


    Public Transient String sAttachment {
        get;
        set;
    }
    Public Transient Blob sAttachmentIE {
        get;
        set;
    }
    Public String sFileType {
        get;
        set;
    }
    Public String sAttachmentName {
        get;
        set;
    }
    Public String ParentID {
        get;
        set;
    }
    Public Boolean IsIE {
        get;
        set;
    }
    Public Boolean bIsAdmin{
        get;
        set;
    }
    Public String sShowMsg{
        get;
        set;
    }

    String[] sContent = new String[] {};

    Public String sNameFile;
    Public List < List < String >> lData;
    Public String sUserAgent;

    public DragNdrop(ApexPages.StandardController controller) {
        sAttachment = '';
        sFileType = '';
        sAttachmentName = '';
        ParentID = ApexPages.currentPage().getParameters().get('id');
        sNameFile = '';
        sShowMsg = '';
        lData = new List < List < String > > ();

        //Checking for the Browser Type
        sUserAgent = ApexPages.currentPage().getHeaders().get('USER-AGENT');
        If(sUserAgent.contains('Trident')) {
            IsIE = True;
        }
        
        //Checking for User Type
        List < PermissionSetAssignment > lPermissionsetCheck = [SELECT Id, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = : userinfo.getuserID() and(PermissionSet.name like: '%LAB_Admi%')];
        if (lPermissionsetCheck.size() > 0) {
            bIsAdmin = true;
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info, 'Only Colab Administrators can access the Drop Area.'));
        }
    }


    /* 
     * @Method Name                    :  saveValues
     * @Description                    :  Method to Insert/Update Board Records along with Attachments and Simulation Notes
     * @Return Type                    :  void
     * @Parameters                     :  None
     */
   
    Public void saveValues() {

        Blob bAttachment;
        Try {
        
            if(sAttachmentIE == NULL && (sAttachment=='' || sAttachment==null)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.NoFileMSG));
            }
            else{
                If(sAttachmentIE != NULL) {
                    bAttachment = sAttachmentIE;
                    sShowMsg = 'TRUE';
                }
                Else {
                    bAttachment = EncodingUtil.base64Decode(sAttachment);
                }
                BoardGenerator(sAttachmentName, ParentID);
                AttachmentGenerator(sAttachmentName, bAttachment, sFileType, ParentID, sShowMsg);
                List < Simulation_Note__c > lSimulationNotes = new List < Simulation_Note__c > ();
                If(!lData.IsEmpty() && sFileType == 'text/plain') {
                    lSimulationNotes = FiletoObject(lData, sAttachmentName, ParentID);
                    Database.Upsert(lSimulationNotes, Simulation_Note__c.Fields.Note_TF__c, false);
                }
            }
        }

        Catch(Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, e.getMessage()));
        }
    }


    /* 
     * @Method Name                    :  BoardGenerator
     * @Description                    :  Method to Insert/Update Board Records
     * @Return Type                    :  void
     * @Parameters                     :  String,String
     */


    Public void BoardGenerator(String sRecordName, String sSimulationId) {

        List < Boards__c > lBoards = new List < Boards__c > ();
    
        Boards__c oBoard = new Boards__c();
        oBoard.Simulation__c = sSimulationId;
        oBoard.Board_Title__c = sRecordName.SubString(0, sRecordName.lastIndexOf('.'));
        oBoard.Board_TF__c = sSimulationId + '+' + oBoard.Board_Title__c;
        lBoards.add(oBoard);
    
        If(!lBoards.IsEmpty()) {
            Database.Upsert(lBoards , Boards__c.Fields.Board_TF__c, false);
        }
    }


    /* 
     * @Method Name                    :  AttachmentGenerator
     * @Description                    :  Method to Insert Attachments
     * @Return Type                    :  void
     * @Parameters                     :  String,Blob,String,String
     */

    Public void AttachmentGenerator(String sRecordName, Blob bData, String sType, String sSimulationId, String sMsg) {
        String err = null;

        try {

            List < Attachment > lAttached = new List < Attachment > ();
            For(Boards__c oCBoard: [Select Id, Board_Title__c, Simulation__c from Boards__c]) {
                If(sRecordName.SubString(0, sRecordName.lastIndexOf('.')) == oCBoard.Board_Title__c && oCBoard.Simulation__c == sSimulationId) {
                    If(sType == 'text/plain') {
                        HttpRequest tmp = new HttpRequest(); //Using to Convert Blob to UTF-8. 
                        tmp.setBodyAsBlob(bData);
                        Attachment att = new Attachment();
                        att.ParentId = oCBoard.Id;
                        att.Body = bData;
                        att.Name = sRecordName;
                        att.ContentType = sType;
                        sNameFile = tmp.getBody();
                        sContent = sNameFile.split('\n');
                        lAttached.add(att);
                        for (Integer i = 0; i < sContent.size(); i++) {
                            String[] inputvalues = new String[] {};
                            inputvalues = sContent[i].split('\t');
                            lData.add(inputvalues);
                        }
                    } else {
                        Attachment att = new Attachment();
                        att.ParentId = oCBoard.Id;
                        att.Body = bData;
                        att.Name = sRecordName;
                        att.ContentType = sType;
                        lAttached.add(att);
                    }
                }
            }
            Insert lAttached;
            If(sMsg == 'TRUE'){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm, 'File ' + sAttachmentName + ' Uploaded Successfully'));
            }


        } catch (Exception e) {
            err = e.getMessage();
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, err));
        }
    }

    /* 
     * @Method Name                    :  FiletoObject
     * @Description                    :  Method to Read Data from TXT File and Inserting/Updating on Simulation Notes
     * @Return Type                    :  List of Simulation_Note__c
     * @Parameters                     :  List<String<String>>,String,String
     */

    Public List < Simulation_Note__c > FiletoObject(List < List < String >> lParsedFile, String sRecordName, String sSimulationId) {

        String err = null;

        List < String > lHeaders = new List < String > ();

        list < Simulation_Note__c > lNotes = new list < Simulation_Note__c > ();

        For(List < String > row: lParsedFile) {
            for (string col: row) {
                lHeaders.add(col);
            }
            break;
        }


        integer rowNumber = 0;
        For(Boards__c oCBoard: [Select Id, Board_Title__c, Simulation__c from Boards__c]) {
            If(sRecordName.SubString(0, sRecordName.lastIndexOf('.')) == oCBoard.Board_Title__c && oCBoard.Simulation__c == sSimulationId) {
                for (list < string > row: lParsedFile) {
                    if (rowNumber == 0) {
                        rowNumber++;
                        continue;
                    } else {
                        Simulation_Note__c oNote = new Simulation_Note__c();
                        integer colIndex = 0;
                        for (string col: row) {
                            string headerName = lheaders[colIndex].trim();
                            If(headerName == 'contentLabel') {
                                oNote.put('Note_Content__c', col.trim());
                            }
                            If(headerName == 'label0') {
                                oNote.put('Header__c', col.trim());
                            }
                            If(headerName == 'label1') {
                                oNote.put('Responsible_Party__c', col.trim());
                            }
                            If(headerName == 'label2') {
                                oNote.put('Footer_Right__c', col.trim());
                            }
                            If(headerName == 'Magnets') {
                                oNote.put('Magnets__c', col.trim());
                            }
                            If(headerName == 'name') {
                                oNote.put('Note_Type__c', col.trim());
                            }
                            If(headerName == 'id') {
                                oNote.put('SimulationNoteId_TF__c', col.trim());
                                String bId = oCBoard.Id;
                                oNote.put('Note_TF__c', bId.substring(0, 15) + '+' + col.trim());
                            }
                            oNote.put('Board__c', oCBoard.Id);
                            oNote.put('Impact_Level__c','Quick Win');
                            colIndex++;
                        }
                        lNotes.add(oNote);
                        rowNumber = rowNumber++;
                    }
                }
            }
        }
        return lNotes;

    }
}