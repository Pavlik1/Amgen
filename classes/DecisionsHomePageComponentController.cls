public with sharing class DecisionsHomePageComponentController {
    private static String retProjectId = 'hasselectedproject';

    public Boolean displayPopup {get;set;}
    public Id dashboardId { get { return [SELECT Id FROM Dashboard WHERE DeveloperName = : Constants.ADOPTION_DASHBOARDS][0].Id; }}
    public Boolean refreshPage{ get{if(refreshPage == null) refreshPage = false; return refreshPage;}set;}
    public String redirectPage{ get{if(redirectPage == null) redirectPage = ''; return redirectPage;}set;}

    public String projectId {get{if(projectId == null) projectId = ''; return projectId;}set;}
    public List<SelectOption> projects{
        get{
            List<SelectOption> res = new List<SelectOption>{new SelectOption('', '-- None --')};
            for (Project__c project : ProjectServices.getProjectsByUserAndName(UserInfo.getUserId(), '', false).values()){
                res.add(new SelectOption(project.Id, project.Name, false));
            }
            return res;
        }
        set;
    }

    public DecisionsHomePageComponentController(){
        this.displayPopup = false;
        try{
            String sss = String.valueOf(ApexPages.currentPage().getHeaders());
            System.debug(LoggingLevel.ERROR, '^^^ sss = ' + sss);
            String s = ApexPages.currentPage().getHeaders().get('Referer');
            Integer i = s.indexOf(retProjectId);
            String ss =  s.substring(i + retProjectId.length() + 1, i + retProjectId.length() + 19);
            List<Project__c> projectList = [SELECT Id FROM Project__c WHERE Id = : ss];
            this.projectId = !projectList.isEmpty() ? ss : null;
        }catch(Exception ex){}
    }

    public PageReference showPopup(){
        if(!String.isEmpty(projectId)){
            this.redirectPage = '/apex/' + this.redirectPage + '?id=' + this.projectId + '&retURL=' + Constants.HOME_PAGE_URL + '?' + retProjectId + '=' + this.projectId;
            this.refreshPage = true;
        } else {
            this.displayPopup = true;
        }
        return null;
    }

    public void closePopup(){
        this.projectId = '';
        this.displayPopup = false;
    }

    public PageReference goForvard(){
        if (!String.isEmpty(this.projectId)){
            this.redirectPage = '/apex/' + this.redirectPage + '?id=' + this.projectId + '&retURL=' + Constants.HOME_PAGE_URL + '?' + retProjectId + '=' + this.projectId;
            this.refreshPage = true;
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please choose project' ) );
        }
        return null;
    }
}