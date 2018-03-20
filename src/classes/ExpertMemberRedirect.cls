public with sharing class ExpertMemberRedirect 
{        ApexPages.StandardController sController; 

    public ExpertMemberRedirect(ApexPages.StandardController controller) 
    {
     sController = controller; 
    }

    public pagereference Redirect()
    {
            schema.sobjecttype oDynamicObjectype = ((sobject)sController.getRecord()).getsObjectType();
            PageReference pRedirectObjectPageReference = new PageReference('/' + oDynamicObjectype.getDescribe().getKeyPrefix()+ '/e');
            Map<String, String> mPageParameters = pRedirectObjectPageReference.getParameters();
            
            mPageParameters.putall(ApexPages.currentPage().getParameters());
            mPageParameters.put('nooverride', '1');
            mPageParameters.put('Name', 'DO NOT ENTER');
            if(mPageParameters.containskey('save_new')){
                mPageParameters.remove('save_new');
            } 
            return pRedirectObjectPageReference;

    }
}