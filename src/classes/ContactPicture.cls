/*******************************************
Class Name         :        ContactPicture
Description        :        Class for inline VF page to display Latest Image Attachment as the Contact Picture
********************************************/

Public with sharing class ContactPicture
{
        Public final contact oContact{get;set;}
        public ContactPicture(ApexPages.StandardController controller) 
        {
            oContact = (contact)controller.getrecord();
        }
        
        Public String getsAttachmentId()
        {
            
            for(Attachment oAttachment : [Select id from Attachment where parentid = : oContact.Id  and contenttype LIKE: 'image%' order by Lastmodifieddate desc])
            {
                return oAttachment.Id;
            }
            
            return null;
        }


}