global without sharing class PreChatFormController {
    
    //Public Properties.
    public String strLanguage {get;set;}
    public String strCustomerName {get;set;}
    public String strCustomerID {get;set;}
    public String strCustomerUsername {get;set;}
    public String strCustomSessionId {get;set;}
    public String strCountry {get;set;}
    public String strCaseRecordTypeId {get;set;}
    
    public String subject {get;set;}
    public String caseOrigin {get;set;}
    public Account customerAccount {get;set;} 
    
    public Map<String, String> getParms {get{return ApexPages.currentPage().getParameters();}}
    
    //Constructor, defaulting langugae to English.
    public PreChatFormController() {
        system.debug('##################Param###########'+ApexPages.currentPage().getParameters().get('endpoint'));
        
        //Read endpoint Parameter from URL and extract Language sub parameter.
        String endpointURL = ApexPages.currentPage().getParameters().get('endpoint');
        caseOrigin = 'Chat';
        strLanguage = 'EN';
    }
    
    
    public List<SelectOption> getQueryOptions(){
    
        List<SelectOption> options = new List<SelectOption>();
    
        //Iterate through CustomSetting record and generate List<SelectOptions>
        for(Integer i=1;i<=3;i++) {
            try {
                String strValue = 'Value'+i;                
                system.debug('######################'+strValue);
                options.add(new SelectOption(strValue,strValue));
            }catch(Exception ex){system.debug('######################'+ex);break;}
        }
        return options;
    }
    //End getQueryOptions.
    
    
    @RemoteAction
    global static String getPlayerAccount(String contEmail){
        String result = '';
        return result;
    }
    
    @RemoteAction
    global static string createLogRemote(String checkpoint , String recId ,String recData ,String errorLog){
        return '';
    }
    
    private static string createLog(String checkpoint , String recId ,String recData ,String errorLog){
        return '';
    }
   
    //Called from PreChatForm Page action.
    public PageReference onLoadRedirectOffBusinessHours() { 
        return null;
    }

  @RemoteAction
   //Javascript Remoting method, which will check for exiting Account and if not found then will create a Lead.
   global static void getContact(String UserName, String contEmail,String Name, String strCustomSessionId ) {
   }   
}