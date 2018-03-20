/****************************************************************************************************************************************** 
 * Class Name   : BoardAttachment
 * Description  : Class for Attachments Handling for Board Records
 * Created By   : Deloitte Consulting
 * 
 *****************************************************************************************************************************************/
Public with Sharing Class BoardAttachment{
    
    public Id currentPicture { get; set; }

   //Loading the Constructor
    Public BoardAttachment(ApexPages.StandardController controller) {
        Boards__c oBoard = (Boards__c)controller.getRecord();
        
        //Querying the Latest Attached Image
        List<Attachment> lCurrentPictures = [SELECT Id FROM Attachment WHERE parentId = :oBoard.Id AND ContentType LIKE 'image%' ORDER BY CreatedDate DESC LIMIT 1];
        if(lCurrentPictures.size() != 0) {
            currentPicture = lCurrentPictures.get(0).Id;
        }
    }
}