Public with sharing Class DRDP_Content{
Public List<DRDP_Admin_Console__c> Oconsole{get;set;}
    Public DRDP_Content(){
        String sPage = ApexPages.currentPage().getParameters().get('Page');

        if(sPage!=null){
            sPage = sPage.toLowercase();
            Oconsole = [select id,Content__c,name,Type__c from DRDP_Admin_Console__c where active__c =: true and Page_TF__c=:sPage order by Sequence__c asc];

        }

    }

    Public String getsChatterPic(){
                
                return  [select id,smallphotourl from user where id =: userinfo.getuserid() limit 1].smallphotourl;

    }

    Public List<wComponentDetails> Tabs{
        
        get { 
            if(Tabs==null){
                String sPage = ApexPages.currentPage().getParameters().get('Page');

                if(sPage!=null){
                    sPage = sPage.toLowercase();
                }

                Tabs = new List<wComponentDetails>();
                Map<String,List<DRDP_Admin_Console__c>> mTabTypes = new Map<String,List<DRDP_Admin_Console__c>>();
                for(DRDP_Admin_Console__c oConsole : [Select id,Name,Type__c from DRDP_Admin_Console__c  where active__c =: true and Page_TF__c=:sPage order by Type__c,Sequence__c asc]){

                    if(mTabTypes!=null && mTabTypes.containsKey(oConsole.Type__c)){
                        mTabTypes.get(oConsole.Type__c).add(oConsole);
                    }
                    else
                        mTabTypes.put(oConsole.Type__c,new List<DRDP_Admin_Console__c>{oConsole});
                }

                for(string oSubtabname : mTabTypes.keyset()){
                    Tabs.add(new wComponentDetails(oSubtabname,mTabTypes.get(oSubtabname)));
                }
            }   
            
            return Tabs;
        }   
        set;
        
    }

    Public class wComponentDetails{
        Public string Name{get;set;}
        Public string sURL{get;set;}
        Public List<DRDP_Admin_Console__c> sSubTabs{get;set;}
        
        Public wComponentDetails(string Name, List<DRDP_Admin_Console__c> sSubTabs){
            this.Name = Name;
            this.sURL = sURL;
            this.sSubTabs = sSubTabs;
        }
    }

}