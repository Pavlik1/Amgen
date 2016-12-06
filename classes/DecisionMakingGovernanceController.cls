public with sharing class DecisionMakingGovernanceController extends CommonToolsController {
    private static String separator = ';';

    Public String retURL {get; set;}

    public String currentToolName(){ return Constants.DMGT; }
    public void populateExistingWrappers(){
        this.allUpdatedWrappers = new List<ToolsWrapper>();
        this.allUpdatedWrappers.addAll(this.fundingRoles);
        this.allUpdatedWrappers.addAll(this.decisionDueDate);
        this.allUpdatedWrappers.addAll(this.teamRolesList);
        this.allUpdatedWrappers.addAll(this.decisionImpactList);
    }

    private Tool_Usage_Tracking__c toolUsageTraking{
        get{
            if (this.toolUsageTraking == null){
                this.toolUsageTraking = new Tool_Usage_Tracking__c(AreasAffected__c = 0,
                                                                   Project__c = projectId,
                                                                   Date__c = Date.today(),
                                                                   Tool__c = Constants.DMGT);
            }
            return toolUsageTraking;
        }
        set;
    }

    public Integer changesForToolsWrapper(List<ToolsWrapper> listToolsWrapper){
        Integer res = 0;
        for (ToolsWrapper item : listToolsWrapper){
            res += item.getChangedValues;
        }

        return res;
    }

    public Project__c projectIncomming { get; set; }

    public Contact contact {
        get {
            if (null == this.contact) {
                this.contact = new Contact();
            } 
            return this.contact;
        }
        set;
    }

    public List<ToolsWrapper> fundingRoles { 
        get {
            if (null == this.fundingRoles) {
                this.fundingRoles = new List<ToolsWrapper>();

                List<Funding_Role__c> roles = ProjectServices.getFundingRoleByProjectId(this.projectId);

                for (Integer i = 0; i < roles.size(); i++) {
                    this.fundingRoles.add(new ToolsWrapper('Funding_Role__c', roles.get(i), i));
                }

            }
            return this.fundingRoles;
        }
        set;
    }

    public List<ToolsWrapper> decisionDueDate { 
        get {
            if (null == this.decisionDueDate) {
                this.decisionDueDate = new List<ToolsWrapper>();

                List<Decision_Due_Date__c> roles = ProjectServices.getDueDatByProjectId(this.projectId);

                for (Integer i = 0; i < roles.size(); i++) {
                    this.decisionDueDate.add(new ToolsWrapper('Decision_Due_Date__c', roles.get(i), i));
                }
            }
            return this.decisionDueDate;
        }
        set;
    }


    public List<ToolsWrapper> teamRolesList { 
        get {
            if (null == this.teamRolesList) {
                this.teamRolesList = new List<ToolsWrapper>();

                List<Team_Role__c> roles = ProjectServices.getTeamRoleByProjectId(this.projectId);

                for (Integer i = 0; i < roles.size(); i++) {
                    this.teamRolesList.add(new ToolsWrapper('Team_Role__c', roles.get(i), i, roles.get(i).User__r.Title));
                }
            }
            return this.teamRolesList;
        }
        set;
    }

    public List<ToolsWrapper> decisionImpactList { 
        get {
            if (null == this.decisionImpactList) {
                this.decisionImpactList = new List<ToolsWrapper>();

                List<Task> projectTasks = TaskServices.getTasksByWhatId(this.projectId);

                for (Integer i = 0; i < projectTasks.size(); i++) {
                    this.decisionImpactList.add(new ToolsWrapper('task', projectTasks.get(i), i));
                }
            }
            return this.decisionImpactList;
        }
        set;
    }

    public DecisionMakingGovernanceController() {
        this.projectId = ApexPages.currentPage().getParameters().get('id');
        this.retURL    = ApexPages.currentPage().getParameters().get('retURL');

    }

    public PageReference goBack(){

        PageReference pr = String.isBlank(this.retURL)
                                ? new PageReference(this.project.Id != null ? '/' + String.valueOf(this.project.Id) : '/' + Constants.HOME_PAGE_URL)
                                : new PageReference(this.retURL);

        pr.setCookies(new List<Cookie>{new Cookie('testCookie', 'test cookie value', null, 1440, false)});
        pr.getParameters().put('testParam', 'testparamvalue');
        pr.getHeaders().put('testParam', 'test value');

        return pr;

        //return String.isBlank(this.retURL)
        //                        ? new PageReference(this.project.Id != null ? '/' + String.valueOf(this.project.Id) : '/' + Constants.HOME_PAGE_URL)
        //                        : new PageReference(this.retURL);
    }

    public void submit() {
        try {
            //upsert project records
            upsert this.project;

            saveFundingRole();
            saveDecisionDueDate();
            saveTeamRoles();
            saveDecisionImpact();  

            //start Check Items Workflow

            Set<String> fieldsForCurrentTool = new Set<String>{'Id'};

            WorkflowServices.checkItemWorkflow(fieldsForCurrentTool, Constants.DMGT, this.project.Id);


            System.debug(LoggingLevel.ERROR, '^^^ fieldsForCurrentTool = ' + fieldsForCurrentTool);


            List<ToolsWrapper> tmpToolsWrapperList = new List<ToolsWrapper>();
                               tmpToolsWrapperList.addAll(this.fundingRoles);
                               tmpToolsWrapperList.addAll(this.decisionDueDate);
                               tmpToolsWrapperList.addAll(this.teamRolesList);
                               tmpToolsWrapperList.addAll(this.decisionImpactList);

            this.toolUsageTraking.AreasAffected__c = changesForToolsWrapper(tmpToolsWrapperList);

            populateExistingWrappers();

            if (this.processedProject != this.project){
                super.changesForProject(fieldsForCurrentTool);
            }

            super.updateView();

            saveToolUsage();

            //updateView();
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));

        }
    }

    public void addFundingRole(){
        this.fundingRoles.add(new ToolsWrapper('Funding_Role__c', new Funding_Role__c(Project__c = this.project.Id), this.fundingRoles.size()));

    }

    public void addDecisionDueDate(){
        this.decisionDueDate.add(new ToolsWrapper('Decision_Due_Date__c', new Decision_Due_Date__c(Project__c = this.project.Id), this.decisionDueDate.size()));

    }

    public void addTeamRoles(){
        this.teamRolesList.add(new ToolsWrapper('Team_Role__c', new Team_Role__c(Project__c = this.project.Id), this.teamRolesList.size()));

    }

    public void addDecisionImpact(){
        this.decisionImpactList.add(new ToolsWrapper('Task', new Task(WhatId = this.project.Id, OwnerId = UserInfo.getUserId()), this.decisionImpactList.size()));

    }

    private void saveToolUsage(){
        if (this.toolUsageTraking.AreasAffected__c > 0 ){
            if(this.toolUsageTraking.Project__c == null) this.toolUsageTraking.Project__c = this.project.Id ;
            upsert this.toolUsageTraking;
        }

        this.toolUsageTraking = null;
    }

    public void saveFundingRole(){
        //upsert child Funding_Role__c records
        List<Funding_Role__c> roles = new List<Funding_Role__c>();

        for (ToolsWrapper tw : this.fundingRoles) {
            roles.add((Funding_Role__c)tw.sObjectItem);
        }

        upsert roles;

    }

    public void saveDecisionDueDate(){
        //upsert child Decision_Due_Date__c records
        List<Decision_Due_Date__c> dueDates = new List<Decision_Due_Date__c>();

        for (ToolsWrapper tw : this.decisionDueDate) {
            dueDates.add((Decision_Due_Date__c)tw.sObjectItem);
        }

        upsert dueDates;
    }

    public void saveTeamRoles(){
        //upsert child Team_Role__c records
        List<Team_Role__c> teamRoles = new List<Team_Role__c>();

        for (ToolsWrapper tw : this.teamRolesList) {
            teamRoles.add((Team_Role__c)tw.sObjectItem);
        }

        upsert teamRoles;

    }

    public void saveDecisionImpact(){
        //upsert child Impact_Area__c records
        List<Task> tasks = new List<Task>();

        for (ToolsWrapper tw : this.decisionImpactList) {
            tasks.add((Task)tw.sObjectItem);
        }

        upsert tasks;
    }

    public PageReference saveProject(){
        upsert this.project;
        Set<String> fields = new Set<String>{'Name'};
        WorkflowServices.checkItemWorkflow(Constants.DMGT, this.project.Id);
        saveToolUsage();
        super.changesForProject(fields);
        return new PageReference('/'+this.project.Id);
    }
}