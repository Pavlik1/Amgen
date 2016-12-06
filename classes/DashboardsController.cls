global with sharing class DashboardsController{
    private static Integer DAY_OF_MONTH = 3;
    private static String INFORMED_STAKEHOLDER_USER_ROLE = 'Informed Stakeholder';


    public String activePanelName{
        get{
            if(String.isEmpty(this.activePanelName)){
                this.activePanelName = 'Project Adoption';
            }
            return this.activePanelName;
        }
        set;
    }

    private Set<String> currentUserProjects;
    private List<ProjectModel> projectModels;

    public String selectedFilter {
        get {
            if (null == this.selectedFilter) {
                this.selectedFilter = 'Project';
            }
            return this.selectedFilter;
        }
        set;
    }

    public List<String> projectIds {
        get {
            if (null == this.projectIds) {
                this.projectIds = new List<String>();
                this.projectIds.add('All');
                System.debug(LoggingLevel.ERROR, '^^^ this.projectIds = ' + this.projectIds);
            }
            System.debug(LoggingLevel.ERROR, '^^^ this.projectIds = ' + this.projectIds);
            return this.projectIds;
        }
        set;
    }

    public List<SelectOption> projects {
        get{
            if (null == this.projects) {
                this.projects = new List<SelectOption>();
                this.projects.add(new SelectOption('All', 'All'));

                this.projectModels = new List<ProjectModel>();
                this.currentUserProjects = new Set<String>();
                for (Project__c p : allProjects()){
                    this.currentUserProjects.add(p.Id);
                    this.projects.add(new SelectOption(p.Id, p.Name));
                    this.projectModels.add(new ProjectModel(p));
                }
            }
            return this.projects;
        }
        set;
    }

    public List<SelectOption> filters {
        get{
            if (null == this.filters) {
                this.filters = new List<SelectOption>();

                this.filters.add(new SelectOption('Project', 'Project'));
                this.filters.add(new SelectOption('Risk Level', 'Risk Level'));
                this.filters.add(new SelectOption('Type of Impact', 'Type of Impact'));

            }
            return this.filters;
        }
        set;
    }

    public List<String> selectedRoles {
        get {
            if (null == this.selectedRoles) {
                this.selectedRoles = new List<String>{'All'};
            }
            return this.selectedRoles;
        }
        set;
    }

    public List<SelectOption> userRole {
        get{
            if (null == this.userRole) {
                this.userRole = new List<SelectOption>();
                this.userRole.add(new SelectOption('All', 'All'));
                this.userRole.add(new SelectOption('Any', 'Any'));

                this.userRole.add(new SelectOption('Sponsor', 'Sponsor'));
                this.userRole.add(new SelectOption('Decision Maker', 'Decision Maker'));
                this.userRole.add(new SelectOption('Decision Adviser', 'Decision Adviser'));
                this.userRole.add(new SelectOption('Informed Stakeholder', 'Informed Stakeholder'));
            }
            return this.userRole;
        }
        set;
    }

    public List<String> selectedRiskStatuses {
        get {
            if (null == this.selectedRiskStatuses) {
                this.selectedRiskStatuses = new List<String>{'All'};
            }
            return this.selectedRiskStatuses;
        }
        set;
    }

    public List<SelectOption> riskStatuses {
        get{
            if (null == this.riskStatuses) {
                this.riskStatuses = new List<SelectOption>();
                this.riskStatuses.add(new SelectOption('All', 'All'));

                for( Schema.PicklistEntry f : xrospackages__Project__c.xrospackages__Risk_Associated__c.getDescribe().getPicklistValues()){
                    this.riskStatuses.add(new SelectOption(f.getLabel(), f.getValue()));
                }

                //this.riskStatuses.add(new SelectOption('Low', 'Low'));
                //this.riskStatuses.add(new SelectOption('Moderate', 'Moderate'));
                //this.riskStatuses.add(new SelectOption('High', 'High'));
                //this.riskStatuses.add(new SelectOption('Critical', 'Critical'));
            }
            return this.riskStatuses;
        }
        set;
    }



    public List<String> selectedTypeOfImpacts {
        get {
            if (null == this.selectedTypeOfImpacts) {
                this.selectedTypeOfImpacts = new List<String>{'All'};
            }
            return this.selectedTypeOfImpacts;
        }
        set;
    }

    public List<SelectOption> typeOfImpacts {
        get{
            if (null == this.typeOfImpacts) {
                this.typeOfImpacts = new List<SelectOption>();
                this.typeOfImpacts.add(new SelectOption('All', 'All'));

                for( Schema.PicklistEntry f : xrospackages__Project__c.xrospackages__Decision_impact__c.getDescribe().getPicklistValues()){
                    this.typeOfImpacts.add(new SelectOption(f.getLabel(), f.getValue()));
                }

            }
            return this.typeOfImpacts;
        }
        set;
    }

    //public List<ProjectsToState> projectsToStates{
    //    get {
    //        if (null == this.projectsToStates) {
    //            this.projectsToStates = new List<ProjectsToState>();
    //            Set<String> setProjectIds = new Set<String>(this.projectIds);
    //            if (setProjectIds.contains('All')){
    //                setProjectIds.remove('All');
    //                setProjectIds.addAll(this.currentUserProjects);
    //            }

    //            String query  = 'SELECT COUNT(Id), xrospackages__Project_State__c FROM Project__c ';
    //            query += this.currentUserProjects.isEmpty() ? 'WHERE Id = null ' : 'WHERE Id IN : setProjectIds ';


    //            if (selectedFilter == 'Project'){

    //            } else if (selectedFilter == 'Type Of Impact'){
    //                Set<String> impacts = new Set<String>(this.selectedTypeOfImpacts);
    //                if (!impacts.contains('All')){
    //                    query += ' AND ( xrospackages__Decision_impact__c != null AND xrospackages__Decision_impact__c IN: impacts ) ';
    //                }
    //            } else if (selectedFilter == 'Risk Level'){
    //                Set<String> risks = new Set<String>(this.selectedRiskStatuses);
    //                if (!risks.contains('All')){
    //                    query += ' AND ( xrospackages__Risk_Associated__c != null AND xrospackages__Risk_Associated__c IN: risks ) ';
    //                }
    //            }


    //            query += ' GROUP BY xrospackages__Project_State__c ';

    //            system.debug('!!!query='+query);

    //            for (AggregateResult ar : Database.query(query)) {
    //                this.projectsToStates.add(new ProjectsToState((String)ar.get('xrospackages__Project_State__c'), (Integer)ar.get('expr0')));
    //            }

    //            if(this.projectsToStates.isEmpty()){
    //                this.projectsToStates.add(new ProjectsToState('No Projects', 0));
    //            }

    //        }
    //        return this.projectsToStates;
    //    }
    //    set;
    //}

    public void reloadFilters() {
        System.debug(LoggingLevel.ERROR, '^^^ start reload filters');
        this.projectIds            = null;
        this.selectedRiskStatuses  = null;
        this.selectedTypeOfImpacts = null;
        this.selectedRoles         = null;
        reloadProjectsToStates();
        System.debug(LoggingLevel.ERROR, '^^^ end reload filters');
    }

    public void reloadProjectsToStates() {
        this.filteredProject                = null;
        this.projectsToStates               = null;
        this.newProjects                    = null;
        this.projectImpacts                 = null;
        this.projectToolUsageTrackings      = null;
        this.projectsFromStartToCompletions = null;
        this.projectsWithPhase              = null;
        this.viewProjects                   = null;
        this.editProjects                   = null;
    }

    public void send() {
        // Define the email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        PageReference pdf = Page.DashboardsPDF;
        pdf.setRedirect(true);
     
        Blob b = pdf.getContent();

        // Create the email attachment
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName('ProjectsByState.pdf');
        attachment.setBody(b);

        email.setSubject('Projects By State');
        List<String> setTo = new List<String> {'yshaleva@corevalue.net'};
        email.setToAddresses(setTo);

        email.setPlainTextBody('Projects By State' );
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {attachment});

        // Send it
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
         
    }

    public string strImageBlob {get;set;}
    
    public void sendEmail()
    {
        Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
        List<String> lstString = new List<String>();
        mail.setToAddresses(new String[]{'yshaleva@corevalue.net'});
        mail.setSubject('Email found');
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.setContentType('image/png');
        attach.setFileName('Test.png');
        attach.setInline(false);
        attach.Body = EncodingUtil.base64Decode(strImageBlob.replaceFirst('data:image/png;base64,',''));
        mail.setHtmlBody('Please find the attached Image');
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }

    @RemoteAction   
	global static void saveAtt(String body) {
		System.debug('!!! body = ' + body);

		Attachment att = new Attachment();
		att.ParentId = '0035800000G34Jz';
		att.Body = Blob.valueOf(body);
		att.Name = 'test.png';
    	insert att;

    	System.debug('!!!! id = ' + att.Id);
	}

    public List<ProjectModel> filteredProject{
        get {
            if (null == this.filteredProject) {
                this.filteredProject = new List<ProjectModel>();

                if (selectedFilter == 'Project'){
                    Set<String> setProjectIds = new Set<String>(this.projectIds);
                    Set<String> setRoles = new Set<String>(this.selectedRoles);

                    for (ProjectModel projectModel : projectModels){
                        if ( (setProjectIds.contains('All') || setProjectIds.contains(projectModel.projectId)) &&
                            ( setRoles.contains('Any') ||
                              ( setRoles.contains('All') && (projectModel.isSponsor || projectModel.isDecisionMaker || projectModel.isDecisionAdviser || projectModel.isInformedStakeholder) ) ||
                              ( setRoles.contains('Sponsor') && projectModel.isSponsor ) ||
                              ( setRoles.contains('Decision Maker') && projectModel.isDecisionMaker ) || 
                              ( setRoles.contains('Decision Adviser') && projectModel.isDecisionAdviser ) ||
                              ( setRoles.contains('Informed Stakeholder') && projectModel.isInformedStakeholder ) ) ){

                            this.filteredProject.add(projectModel);

                        }
                    }
                } else if (selectedFilter == 'Risk Level'){
                    Set<String> setRiskStatuses = new Set<String>(this.selectedRiskStatuses);
                    for (ProjectModel projectModel : projectModels){
                        if ( setRiskStatuses.contains('All') || setRiskStatuses.contains(projectModel.projectRisk) ){

                            this.filteredProject.add(projectModel);

                        }
                    }
                } else if (selectedFilter == 'Type Of Impact'){
                    Set<String> setTypeOfImpacts = new Set<String>(this.selectedTypeOfImpacts);
                    for (ProjectModel projectModel : projectModels){
                        if ( setTypeOfImpacts.contains('All') || setTypeOfImpacts.contains(projectModel.projectImpact) ){

                            this.filteredProject.add(projectModel);

                        }
                    }
                }

            }
            return this.filteredProject;
        }
        set;
    }

    public List<ProjectsToState> projectsToStates{
        get {
            if (null == this.projectsToStates) {
                this.projectsToStates = new List<ProjectsToState>();

                Map<String, ProjectsToState> groupedMap = new Map<String, ProjectsToState>();

                for (ProjectModel projectModel : this.filteredProject){
                    if( !groupedMap.containsKey(projectModel.projectState) ){
                        groupedMap.put( projectModel.projectState, new ProjectsToState(projectModel.projectState, 0) );
                    }
                    ProjectsToState ps = groupedMap.get( projectModel.projectState );
                    ps.projectsCount = ps.projectsCount + 1;
                }

                this.projectsToStates = groupedMap.values();

                if(this.projectsToStates.isEmpty()){
                    this.projectsToStates.add(new ProjectsToState('No Projects', 0));
                }

            }
            return this.projectsToStates;
        }
        set;
    }


    public List<NewProjectsWrapper> newProjects{
        get {
            if (null == this.newProjects) {

                Map<Datetime, NewProjectsWrapper> monthWithCountMap = new Map<Datetime, NewProjectsWrapper>();
                this.newProjects = new List<NewProjectsWrapper>();

                if (!this.filteredProject.isEmpty()){
                    for (Datetime dt = Datetime.newInstanceGMT(this.filteredProject[0].projectCreatedDate.year(), this.filteredProject[0].projectCreatedDate.month(), DAY_OF_MONTH);
                                  dt <= Datetime.newInstanceGMT(this.filteredProject[this.filteredProject.size() - 1].projectCreatedDate.year(), this.filteredProject[this.filteredProject.size() - 1].projectCreatedDate.month(), DAY_OF_MONTH); ){

                        String monthName = convertDateTime( dt, true );
                        NewProjectsWrapper proj = new NewProjectsWrapper(monthName, 0);
                        this.newProjects.add(proj);
                        monthWithCountMap.put(dt, proj);
                        dt = Datetime.newInstanceGMT(dt.addMonths(1).year(), dt.addMonths(1).month(), DAY_OF_MONTH);

                    }
                } else {
                    this.newProjects.add(new NewProjectsWrapper( convertDateTime( Datetime.now(), true ), 0 ) );
                }

                for (ProjectModel projectModel : this.filteredProject) {
                    NewProjectsWrapper proj = monthWithCountMap.get( Datetime.newInstanceGMT(projectModel.projectCreatedDate.year(), projectModel.projectCreatedDate.month(), DAY_OF_MONTH) );
                    if (proj != null) proj.projectCounts = proj.projectCounts + 1;
                }
            }
            return this.newProjects;
        }
        set;
    }

    public List<ProjectImpactWrapper> projectImpacts{
        get {
            if (null == this.projectImpacts) {
                this.projectImpacts = new List<ProjectImpactWrapper>();

                Map<String, ProjectImpactWrapper> groupedMap = new Map<String, ProjectImpactWrapper>();

                for (ProjectModel projectModel : this.filteredProject){
                    if( !groupedMap.containsKey(projectModel.projectImpact) ){
                        groupedMap.put( projectModel.projectImpact, new ProjectImpactWrapper(projectModel.projectImpact, 0) );
                    }
                    ProjectImpactWrapper piw = groupedMap.get( projectModel.projectImpact );
                    piw.projectsCount = piw.projectsCount + 1;
                }

                this.projectImpacts = groupedMap.values();

                if(this.projectImpacts.isEmpty()){
                    this.projectImpacts.add(new ProjectImpactWrapper('No Projects', 0));
                }
            }
            return this.projectImpacts;
        }
        set;
    }

    public List<ProjectsToolUsageTracking> projectToolUsageTrackings{
        get {
            if (null == this.projectToolUsageTrackings) {
                this.projectToolUsageTrackings = new List<ProjectsToolUsageTracking>();

                Date dateValue = Date.newInstance(Date.today().year(), Date.today().month() - 12, 1);

                Set<Id> filteredSetProjectIds = new Set<Id>();
                for (ProjectModel projectModel : this.filteredProject){
                    filteredSetProjectIds.add(projectModel.projectId);
                }

                List<User_Activity_Tracking__c> toolsList = [SELECT Id, Project__c, Project__r.Name, Activity_Time__c, CreatedDate, Tool__c, Period_Name__c
                                                             FROM User_Activity_Tracking__c
                                                             WHERE Project__c IN : filteredSetProjectIds AND
                                                                   Tool__c != null AND
                                                                   Tool__c !=: Constants.PROJECT_VIEW_TOOL AND
                                                                   View_Update__c =: Constants.USER_ACTIVITY_TRACKING_UPDATE AND
                                                                   Period_Name__c != null AND
                                                                   Activity_Time__c >= : dateValue ORDER BY Activity_Time__c];

                Map<String, ProjectsToolUsageTracking> groupedMap = new Map<String, ProjectsToolUsageTracking>();

                if (!toolsList.isEmpty()){
                    for (Datetime dt = Datetime.newInstanceGMT(toolsList[0].Activity_Time__c.year(), toolsList[0].Activity_Time__c.month(), DAY_OF_MONTH);
                                  dt <= Datetime.newInstanceGMT(toolsList[toolsList.size() - 1].Activity_Time__c.year(), toolsList[toolsList.size() - 1].Activity_Time__c.month(), DAY_OF_MONTH); ){


                        String monthVal = convertDateTime( dt, true );
                        ProjectsToolUsageTracking projectUTT = new ProjectsToolUsageTracking(monthVal);
                        this.projectToolUsageTrackings.add(projectUTT);
                        groupedMap.put(monthVal, projectUTT);
                        dt = Datetime.newInstanceGMT(dt.addMonths(1).year(), dt.addMonths(1).month(), DAY_OF_MONTH);

                    }
                } else {
                    this.projectToolUsageTrackings.add(new ProjectsToolUsageTracking( convertDateTime( Datetime.now(), true ) ) );
                }


                for (User_Activity_Tracking__c ut : toolsList){
                    String monthVal = convertDateTime( Datetime.newInstanceGMT(ut.Activity_Time__c.year(), ut.Activity_Time__c.month(), DAY_OF_MONTH), true );
                    ProjectsToolUsageTracking projectUTT = groupedMap.get(monthVal);
                    projectUTT.totalProjectsMap.put(ut.Project__c, new Project__c(Id = ut.Project__c, Name = ut.Project__r.Name));

                    if(ut.Tool__c.contains(Constants.DMGT)){
                        projectUTT.dgmtToolProjectIds.add(ut.Project__c);
                    }

                    if(ut.Tool__c.contains(Constants.RISK_ASSESSMENT_TOOL)){
                        projectUTT.riskAssessmentToolProjectIds.add(ut.Project__c);
                    }

                    if(ut.Tool__c.contains(Constants.WEIGHTED_RANKINGS_MATRIX)){
                        projectUTT.weightedRankingsMatrixProjectIds.add(ut.Project__c);
                    }

                    if(ut.Tool__c.contains(Constants.DECISION_EXECUTION_TOOL)){
                        projectUTT.decisionExecutionToolProjectIds.add(ut.Project__c);
                    }

                    if(ut.Tool__c.contains(Constants.DECISION_EVALUATION_TOOL)){
                        projectUTT.decisionEvaluationToolProjectIds.add(ut.Project__c);
                    }
                }

                for (ProjectsToolUsageTracking projectUTT : projectToolUsageTrackings){
                    projectUTT.totalProjects          = projectUTT.totalProjectsMap.size();
                    projectUTT.dgmtTool               = projectUTT.totalProjects == 0 ? 0 : (projectUTT.dgmtToolProjectIds.size() * 100 )/ projectUTT.totalProjects;
                    projectUTT.riskAssessmentTool     = projectUTT.totalProjects == 0 ? 0 : (projectUTT.riskAssessmentToolProjectIds.size() * 100 )/ projectUTT.totalProjects;
                    projectUTT.weightedRankingsMatrix = projectUTT.totalProjects == 0 ? 0 : (projectUTT.weightedRankingsMatrixProjectIds.size() * 100 )/ projectUTT.totalProjects;
                    projectUTT.decisionExecutionTool  = projectUTT.totalProjects == 0 ? 0 : (projectUTT.decisionExecutionToolProjectIds.size() * 100 )/ projectUTT.totalProjects;
                    projectUTT.decisionEvaluationTool = projectUTT.totalProjects == 0 ? 0 : (projectUTT.decisionEvaluationToolProjectIds.size() * 100 )/ projectUTT.totalProjects;
                }
            }
            return this.projectToolUsageTrackings;
        }
        set;
    }

    public List<ProjectsFromStartToCompletion> projectsFromStartToCompletions{
        get {
            if (null == this.projectsFromStartToCompletions) {
                this.projectsFromStartToCompletions = new List<ProjectsFromStartToCompletion>();

                Datetime dateValue = Datetime.newInstanceGMT(Date.today().year(), Date.today().month() - 12, 1);

                Set<Id> filteredSetProjectIds = new Set<Id>();
                for (ProjectModel projectModel : this.filteredProject){
                    filteredSetProjectIds.add(projectModel.projectId);
                }

                List<Phase__c> phasesList = [SELECT Id, Name, Project__c, Start_Date__c, End_Date__c, Phase_Duration__c
                                             FROM Phase__c
                                             WHERE Project__c IN : filteredSetProjectIds AND
                                                    Phase_Duration__c != null AND
                                                    Phase_Duration__c > 0 AND
                                                    ( End_Date__c != null and End_Date__c >= : dateValue ) ORDER BY End_Date__c];

                Map<String, ProjectsFromStartToCompletion> groupedMap = new Map<String, ProjectsFromStartToCompletion>();

                if (!phasesList.isEmpty()){
                    for (Datetime dt = Datetime.newInstanceGMT(phasesList[0].End_Date__c.year(), phasesList[0].End_Date__c.month(), DAY_OF_MONTH);
                                  dt <= Datetime.newInstanceGMT(phasesList[phasesList.size() - 1].End_Date__c.year(), phasesList[phasesList.size() - 1].End_Date__c.month(), DAY_OF_MONTH); ){

                        String monthVal = convertDateTime( dt, true );
                        ProjectsFromStartToCompletion projectPhase = new ProjectsFromStartToCompletion(monthVal);
                        this.projectsFromStartToCompletions.add(projectPhase);
                        groupedMap.put(monthVal, projectPhase);
                        dt = Datetime.newInstanceGMT(dt.addMonths(1).year(), dt.addMonths(1).month(), DAY_OF_MONTH);

                    }
                } else {
                    this.projectsFromStartToCompletions.add(new ProjectsFromStartToCompletion( convertDateTime( Datetime.now(), true ) ) );
                }


                for (Phase__c phase : phasesList){
                    String monthVal = convertDateTime( Datetime.newInstanceGMT(phase.End_Date__c.year(), phase.End_Date__c.month(), DAY_OF_MONTH), true );
                    ProjectsFromStartToCompletion projectPhase = groupedMap.get(monthVal);
                    projectPhase.addPhase(phase.Name, Integer.valueOf(phase.Phase_Duration__c));
                }
            }

            for (ProjectsFromStartToCompletion projectPhase : this.projectsFromStartToCompletions){
                projectPhase.calculateAll();
            }

            return this.projectsFromStartToCompletions;
        }
        set;
    }

    private static Integer weekNumbersBetweenTwoPeriods(Datetime periodStart, Datetime periodEnd, Datetime startDate, Datetime endDate, Integer weekNumber){
        if (periodStart == null || periodEnd == null || startDate == null || endDate == null || weekNumber == null || weekNumber == 0){ return 0;}

        if (periodStart <= startDate && endDate <= periodEnd){
            return weekNumber;
        } else {
            Date calculateStartDate = Date.valueOf(startDate <= periodStart ? periodStart : startDate);
            Date calculateEndDate =  Date.valueOf(endDate <= periodEnd ? endDate : periodEnd);

            return math.abs ( calculateStartDate.daysBetween(calculateEndDate) / 7 );
        }
    }

    public List<ProjectsByPhaseWrapper> projectsWithPhase{
        get {
            if (null == this.projectsWithPhase) {
                this.projectsWithPhase = new List<ProjectsByPhaseWrapper>();

                Datetime minProjectCompleteDatetime = Datetime.newInstanceGMT(Date.today().year(), Date.today().month() - 12, 1);

                Datetime minDatetime;
                Datetime maxDatetime;

                Map<Id, Project__c> filteredProjectToPhase = new Map<Id, Project__c>();
                Datetime dtNow = Datetime.newInstanceGMT(Datetime.now().year(), Datetime.now().month() + 1, 1).addMinutes(-1);

                //get all periods
                for (ProjectModel projectModel : this.filteredProject){
                    if (projectModel.projectCompletedDate < minProjectCompleteDatetime){ continue; }

                    if ( projectModel.projectCreatedDate < minProjectCompleteDatetime ){
                        minDatetime = minProjectCompleteDatetime;//start period in the dashbord
                    } else if ( minDatetime == null || projectModel.projectCreatedDate < minDatetime ){
                        minDatetime = projectModel.projectCreatedDate;
                    }

                    if ( projectModel.projectCompletedDate == null || projectModel.projectCompletedDate >= dtNow ){
                        maxDatetime = dtNow;//end of the current month
                    } else if ( maxDatetime == null || (maxDatetime != null && maxDatetime < projectModel.projectCompletedDate) ){
                        maxDatetime = projectModel.projectCompletedDate;
                    }
                    filteredProjectToPhase.put(projectModel.projectId, projectModel.project);
                }

                minDatetime = minDatetime != null ? Datetime.newInstanceGMT(minDatetime.year(), minDatetime.month(), 1) : minDatetime;
                maxDatetime = maxDatetime != null ? Datetime.newInstanceGMT(maxDatetime.year(), maxDatetime.month() + 1, 1).addMinutes(-1) : dtNow;

                Map<String, ProjectsByPhaseWrapper> groupedMap = new Map<String, ProjectsByPhaseWrapper>();

                //create all periods
                if (minDatetime != null){
                    for (Datetime dt = minDatetime; dt <= maxDatetime; ){

                        String monthVal = convertDateTime( dt, true );
                        ProjectsByPhaseWrapper projectPhase = new ProjectsByPhaseWrapper( monthVal, dt );
                        this.projectsWithPhase.add( projectPhase );
                        groupedMap.put(monthVal, projectPhase);
                        dt = Datetime.newInstanceGMT(dt.addMonths(1).year(), dt.addMonths(1).month(), DAY_OF_MONTH);

                    }
                } else {
                    this.projectsWithPhase.add(new ProjectsByPhaseWrapper( convertDateTime( Datetime.now(), true ), Datetime.now() ) );
                }

                List<Phase__c> phases = [SELECT Id, Name, Project__c, Start_Date__c, End_Date__c
                                         FROM Phase__c
                                         WHERE Project__c IN : filteredProjectToPhase.keyset() AND
                                            Start_Date__c != null];

                for (Phase__c phase : phases){
                    for(ProjectsByPhaseWrapper projectPhase : this.projectsWithPhase){
                        projectPhase.addPhase(phase.Project__c, phase.Name, phase.Start_Date__c, phase.End_Date__c);
                    }
                }
            }
            return this.projectsWithPhase;
        }
        set;
    }

    @RemoteAction
    public static List<LoginHistoryWrapper> getLoginHistoriesRemote() {
        return loginHistoriesStatic();
    }


    public static List<LoginHistoryWrapper> loginHistoriesStatic(){
        List<LoginHistoryWrapper> loginHistoriesList = new List<LoginHistoryWrapper>();

        Map<String, LoginHistoryWrapper> groupedMap = new Map<String, LoginHistoryWrapper>();

        Datetime minDateTime = Datetime.newInstanceGMT(Date.today().year(), Date.today().month() - 12, 1);
        List<LoginHistory> loginHistoryList = [SELECT Id, UserId, LoginTime
                                                      FROM LoginHistory
                                                      WHERE LoginTime >= : minDateTime ORDER BY LoginTime];

        if (!loginHistoryList.isEmpty()){
            for (Datetime dt = Datetime.newInstanceGMT(loginHistoryList[0].LoginTime.year(), loginHistoryList[0].LoginTime.month(), DAY_OF_MONTH);
                          dt <= Datetime.newInstanceGMT(loginHistoryList[loginHistoryList.size() - 1].LoginTime.year(), loginHistoryList[loginHistoryList.size() - 1].LoginTime.month(), DAY_OF_MONTH); ){

                String monthVal = convertDateTime( dt, true );
                LoginHistoryWrapper loginHistoryWrapper = new LoginHistoryWrapper(monthVal);
                loginHistoriesList.add(loginHistoryWrapper);
                groupedMap.put(monthVal, loginHistoryWrapper);
                dt = Datetime.newInstanceGMT(dt.addMonths(1).year(), dt.addMonths(1).month(), DAY_OF_MONTH);

            }
        }

        for (LoginHistory item : loginHistoryList){
            String monthVal = convertDateTime( item.LoginTime, true );
            LoginHistoryWrapper loginHistoryWrapper = groupedMap.get(monthVal);
            loginHistoryWrapper.addUser(item.UserId);
        }

        return loginHistoriesList;
    }

    public List<LoginHistoryWrapper> loginHistories{
        get{
            if (loginHistories == null){
                loginHistories = new List<LoginHistoryWrapper>();

                Map<String, LoginHistoryWrapper> groupedMap = new Map<String, LoginHistoryWrapper>();

                if (!loginHistoryForAllUsers.isEmpty()){
                    for (Datetime dt = Datetime.newInstanceGMT(loginHistoryForAllUsers[0].LoginTime.year(), loginHistoryForAllUsers[0].LoginTime.month(), DAY_OF_MONTH);
                                  dt <= Datetime.newInstanceGMT(loginHistoryForAllUsers[loginHistoryForAllUsers.size() - 1].LoginTime.year(), loginHistoryForAllUsers[loginHistoryForAllUsers.size() - 1].LoginTime.month(), DAY_OF_MONTH); ){

                        String monthVal = convertDateTime( dt, true );
                        LoginHistoryWrapper loginHistoryWrapper = new LoginHistoryWrapper(monthVal);
                        this.loginHistories.add(loginHistoryWrapper);
                        groupedMap.put(monthVal, loginHistoryWrapper);
                        dt = Datetime.newInstanceGMT(dt.addMonths(1).year(), dt.addMonths(1).month(), DAY_OF_MONTH);

                    }
                }

                for (LoginHistory item : loginHistoryForAllUsers){
                    String monthVal = convertDateTime( item.LoginTime, true );
                    LoginHistoryWrapper loginHistoryWrapper = groupedMap.get(monthVal);
                    loginHistoryWrapper.addUser(item.UserId);
                }

            }

            return loginHistories;
        }
        set;
    }

    private List<LoginHistory> loginHistoryForAllUsers{
        get{
            if (this.loginHistoryForAllUsers == null){
                Datetime dt = Datetime.newInstanceGMT(Date.today().year(), Date.today().month() - 12, 1);
                this.loginHistoryForAllUsers = [SELECT Id, UserId, LoginTime
                                                FROM LoginHistory
                                                WHERE LoginTime >= : dt ORDER BY LoginTime];
            }
            return this.loginHistoryForAllUsers;
        }
        set;
    }

    public List<EditProjectWrapper> editProjects{
        get{
            if (this.editProjects == null){
                this.editProjects = new List<EditProjectWrapper>();

                Set<Id> filteredSetProjectIds = new Set<Id>();
                Datetime minProjectCompleteDatetime = Datetime.newInstanceGMT(Date.today().year(), Date.today().month() - 12, 1);

                Datetime minDatetime;
                Datetime maxDatetime;

                Map<Id, Project__c> filteredProjectToPhase = new Map<Id, Project__c>();
                Datetime dtNow = Datetime.newInstanceGMT(Datetime.now().year(), Datetime.now().month() + 1, 1).addMinutes(-1);

                //get all periods and 
                for (ProjectModel projectModel : this.filteredProject){
                    if (projectModel.projectCompletedDate < minProjectCompleteDatetime){ continue; }

                    if ( projectModel.projectCreatedDate < minProjectCompleteDatetime ){
                        minDatetime = minProjectCompleteDatetime;//start period in the dashbord
                    } else if ( minDatetime == null || projectModel.projectCreatedDate < minDatetime ){
                        minDatetime = projectModel.projectCreatedDate;
                    }

                    if ( projectModel.projectCompletedDate == null || projectModel.projectCompletedDate >= dtNow ){
                        maxDatetime = dtNow;//end of the current month
                    } else if ( maxDatetime == null || (maxDatetime != null && maxDatetime < projectModel.projectCompletedDate) ){
                        maxDatetime = projectModel.projectCompletedDate;
                    }
                    filteredSetProjectIds.add(projectModel.projectId);
                }

                minDatetime = minDatetime != null ? Datetime.newInstanceGMT(minDatetime.year(), minDatetime.month(), 1) : minDatetime;
                maxDatetime = maxDatetime != null ? Datetime.newInstanceGMT(maxDatetime.year(), maxDatetime.month() + 1, 1).addMinutes(-1) : dtNow;

                Map<String, EditProjectWrapper> groupedMap = new Map<String, EditProjectWrapper>();

                //create all periods
                if (minDatetime != null){
                    for (Datetime dt = minDatetime; dt <= maxDatetime; ){
                        String monthVal = convertDateTime( dt, true );
                        EditProjectWrapper viewProject = new EditProjectWrapper( monthVal );
                        this.editProjects.add( viewProject );
                        groupedMap.put(monthVal, viewProject);
                        dt = Datetime.newInstanceGMT(dt.addMonths(1).year(), dt.addMonths(1).month(), DAY_OF_MONTH);
                    }
                } else {
                    this.editProjects.add(new EditProjectWrapper( convertDateTime( Datetime.now(), true ) ) );
                }

                List<User_Activity_Tracking__c> uatList = [SELECT Id, Period_Name__c, Project__c, User__c
                                                           FROM User_Activity_Tracking__c
                                                           WHERE Project__c IN : filteredSetProjectIds AND
                                                                   Period_Name__c != null AND
                                                                   View_Update__c =: Constants.USER_ACTIVITY_TRACKING_UPDATE];

                for (User_Activity_Tracking__c item : uatList){
                    if( groupedMap.containsKey( item.Period_Name__c ) ){
                        groupedMap.get( item.Period_Name__c ).addUAT(item);
                    }
                }

                for (EditProjectWrapper item : this.editProjects){
                    item.calculateAll();
                }

            }

            return this.editProjects;
        }
        set;
    }

    public class EditProjectWrapper{
        public String monthName {get;set;}
        public Integer editNumber {get;set;}

        Map<Id, Set<id>> userWithProjects{get;set;}

        public void addUAT(User_Activity_Tracking__c uat){
            if (!userWithProjects.containsKey(uat.User__c)){
                this.userWithProjects.put(uat.User__c, new Set<Id>());
            }
            this.userWithProjects.get(uat.User__c).add(uat.Project__c);
        }

        public void calculateAll(){
            for (Set<Id> setProjectIds : this.userWithProjects.values()){
                this.editNumber = this.editNumber + setProjectIds.size();
            }
        }

        public EditProjectWrapper(String monthValue, Integer editNumber){
            this.monthName = monthValue;
            this.editNumber = editNumber;
            this.userWithProjects = new Map<Id, Set<Id>>();
        }

        public EditProjectWrapper(String monthValue){
            THIS(monthValue, 0);
        }
    }

    public List<ViewProjectWrapper> viewProjects{
        get{
            if (this.viewProjects == null){
                this.viewProjects = new List<ViewProjectWrapper>();

                Set<Id> filteredSetProjectIds = new Set<Id>();
                Datetime minProjectCompleteDatetime = Datetime.newInstanceGMT(Date.today().year(), Date.today().month() - 12, 1);

                Datetime minDatetime;
                Datetime maxDatetime;

                Map<Id, Project__c> filteredProjectToPhase = new Map<Id, Project__c>();
                Datetime dtNow = Datetime.newInstanceGMT(Datetime.now().year(), Datetime.now().month() + 1, 1).addMinutes(-1);

                //get all periods and 
                for (ProjectModel projectModel : this.filteredProject){
                    if (projectModel.projectCompletedDate < minProjectCompleteDatetime){ continue; }

                    if ( projectModel.projectCreatedDate < minProjectCompleteDatetime ){
                        minDatetime = minProjectCompleteDatetime;//start period in the dashbord
                    } else if ( minDatetime == null || projectModel.projectCreatedDate < minDatetime ){
                        minDatetime = projectModel.projectCreatedDate;
                    }

                    if ( projectModel.projectCompletedDate == null || projectModel.projectCompletedDate >= dtNow ){
                        maxDatetime = dtNow;//end of the current month
                    } else if ( maxDatetime == null || (maxDatetime != null && maxDatetime < projectModel.projectCompletedDate) ){
                        maxDatetime = projectModel.projectCompletedDate;
                    }
                    filteredSetProjectIds.add(projectModel.projectId);
                }

                minDatetime = minDatetime != null ? Datetime.newInstanceGMT(minDatetime.year(), minDatetime.month(), 1) : minDatetime;
                maxDatetime = maxDatetime != null ? Datetime.newInstanceGMT(maxDatetime.year(), maxDatetime.month() + 1, 1).addMinutes(-1) : dtNow;

                Map<String, ViewProjectWrapper> groupedMap = new Map<String, ViewProjectWrapper>();

                //create all periods
                if (minDatetime != null){
                    for (Datetime dt = minDatetime; dt <= maxDatetime; ){

                        String monthVal = convertDateTime( dt, true );
                        ViewProjectWrapper viewProject = new ViewProjectWrapper( monthVal );
                        this.viewProjects.add( viewProject );
                        groupedMap.put(monthVal, viewProject);
                        dt = Datetime.newInstanceGMT(dt.addMonths(1).year(), dt.addMonths(1).month(), DAY_OF_MONTH);

                    }
                } else {
                    this.viewProjects.add(new ViewProjectWrapper( convertDateTime( Datetime.now(), true ) ) );
                }

                List<User_Activity_Tracking__c> uatList = [SELECT Id, Period_Name__c, Project__c, User__c
                                                           FROM User_Activity_Tracking__c
                                                           WHERE Project__c IN : filteredSetProjectIds AND
                                                                   Period_Name__c != null AND
                                                                   View_Update__c =: Constants.USER_ACTIVITY_TRACKING_VIEW];

                for (User_Activity_Tracking__c item : uatList){
                    if( groupedMap.containsKey( item.Period_Name__c ) ){
                        groupedMap.get( item.Period_Name__c ).addUAT(item);
                    }
                }


                for (ViewProjectWrapper item : this.viewProjects){
                    item.calculateAll();
                }
            }

            return this.viewProjects;
        }
        set;
    }

    public class ViewProjectWrapper{
        public String monthName {get;set;}
        public Integer viewNumber {get;set;}

        Map<Id, Set<id>> userWithProjects{get;set;}

        public void addUAT(User_Activity_Tracking__c uat){
            if (!userWithProjects.containsKey(uat.User__c)){
                this.userWithProjects.put(uat.User__c, new Set<Id>());
            }
            this.userWithProjects.get(uat.User__c).add(uat.Project__c);
        }

        public void calculateAll(){
            for (Set<Id> setProjectIds : this.userWithProjects.values()){
                this.viewNumber = this.viewNumber + setProjectIds.size();
            }
        }

        public ViewProjectWrapper(String monthValue, Integer viewNumber){
            this.monthName = monthValue;
            this.viewNumber = viewNumber;
            this.userWithProjects = new Map<Id, Set<Id>>();
        }

        public ViewProjectWrapper(String monthValue){
            THIS(monthValue, 0);
        }
    }

    public class NewProjectsWrapper {
        public String monthName {get;set;}
        public Integer projectCounts{get{if (projectCounts == null) {projectCounts = 0;} return projectCounts;}set;}

        public NewProjectsWrapper (String monthValue, Integer projectsCount) {
            this.monthName = monthValue;
            this.projectCounts = projectsCount;
        }
    }

    public class ProjectImpactWrapper {
        public String state { get; set; }
        public Integer projectsCount { get; set; }

        public ProjectImpactWrapper (String state, Integer projectsCount) {
            this.state = state;
            this.projectsCount = projectsCount;
        }
    }

    public class ProjectsToolUsageTracking {
        public String monthName {get;set;}
        public String pb_test_value{get;set;}
        public String pb_test_label{get;set;}

        public Integer totalProjects{get{this.totalProjects = this.totalProjectsMap.size(); return this.totalProjects;}set;}
        public Integer dgmtTool{get;set;}
        public Integer riskAssessmentTool{get;set;}
        public Integer weightedRankingsMatrix{get;set;}
        public Integer decisionExecutionTool{get;set;}
        public Integer decisionEvaluationTool{get;set;}

        public Map<Id, Project__c> totalProjectsMap{get{if (totalProjectsMap == null) {totalProjectsMap = new Map<Id, Project__c>();} return totalProjectsMap;}set;}
        public Set<Id> dgmtToolProjectIds{get{if (dgmtToolProjectIds == null) {dgmtToolProjectIds = new Set<Id>();} return dgmtToolProjectIds;}set;}
        public Set<Id> riskAssessmentToolProjectIds{get{if (riskAssessmentToolProjectIds == null) {riskAssessmentToolProjectIds = new Set<Id>();} return riskAssessmentToolProjectIds;}set;}
        public Set<Id> weightedRankingsMatrixProjectIds{get{if (weightedRankingsMatrixProjectIds == null) {weightedRankingsMatrixProjectIds = new Set<Id>();} return weightedRankingsMatrixProjectIds;}set;}
        public Set<Id> decisionExecutionToolProjectIds{get{if (decisionExecutionToolProjectIds == null) {decisionExecutionToolProjectIds = new Set<Id>();} return decisionExecutionToolProjectIds;}set;}
        public Set<Id> decisionEvaluationToolProjectIds{get{if (decisionEvaluationToolProjectIds == null) {decisionEvaluationToolProjectIds = new Set<Id>();} return decisionEvaluationToolProjectIds;}set;}

        public ProjectsToolUsageTracking (String monthValue) {
            this.monthName = monthValue;
            this.totalProjectsMap                  = new Map<Id, Project__c>();
            this.dgmtToolProjectIds               = new Set<Id>();
            this.riskAssessmentToolProjectIds     = new Set<Id>();
            this.weightedRankingsMatrixProjectIds = new Set<Id>();
            this.decisionExecutionToolProjectIds  = new Set<Id>();
            this.decisionEvaluationToolProjectIds = new Set<Id>();

            this.totalProjects          = 0;
            this.dgmtTool               = 0;
            this.riskAssessmentTool     = 0;
            this.weightedRankingsMatrix = 0;
            this.decisionExecutionTool  = 0;
            this.decisionEvaluationTool = 0;

            pb_test_value = 'test_val';
            pb_test_label = 'test_lbl';
        }
    }

    public class ProjectsFromStartToCompletion {
        public String monthName {get;set;}
        public Integer phase1Duration {get;set;}
        public Integer phase2Duration {get;set;}
        public Integer phase3Duration {get;set;}
        public Integer phase4Duration {get;set;}
        public Integer projectCountsTotal   {get;set;}
        public Integer projectCountsAverage {get;set;}

        public Integer phase1Number {get;set;}
        public Integer phase2Number {get;set;}
        public Integer phase3Number {get;set;}
        public Integer phase4Number {get;set;}

        public void addPhase(String paseName, Integer weekNumber){
            if(paseName == 'Phase 1'){
                this.phase1Duration = this.phase1Duration + weekNumber;
                this.phase1Number = this.phase1Number + 1;
            } else if(paseName == 'Phase 2'){
                this.phase2Duration = this.phase2Duration + weekNumber;
                this.phase2Number = this.phase2Number + 1;
            } else if(paseName == 'Phase 3'){
                this.phase3Duration = this.phase3Duration + weekNumber;
                this.phase3Number = this.phase3Number + 1;
            } else if(paseName == 'Phase 4'){
                this.phase4Duration = this.phase4Duration + weekNumber;
                this.phase4Number = this.phase4Number + 1;
            }
        }

        public void calculateAll(){
            this.phase1Duration = phase1Number != null && phase1Number != 0 ? this.phase1Duration / this.phase1Number : this.phase1Duration;
            this.phase2Duration = phase2Number != null && phase2Number != 0 ? this.phase2Duration / this.phase2Number : this.phase2Duration;
            this.phase3Duration = phase3Number != null && phase3Number != 0 ? this.phase3Duration / this.phase3Number : this.phase3Duration;
            this.phase4Duration = phase4Number != null && phase4Number != 0 ? this.phase4Duration / this.phase4Number : this.phase4Duration;
        }

        public ProjectsFromStartToCompletion (String monthValue) {
            this.monthName = monthValue;
            this.phase1Duration       = 0;
            this.phase2Duration       = 0;
            this.phase3Duration       = 0;
            this.phase4Duration       = 0;
            this.phase1Number         = 0;
            this.phase2Number         = 0;
            this.phase3Number         = 0;
            this.phase4Number         = 0;
            this.projectCountsTotal   = 0;
            this.projectCountsAverage = 0;
        }
    }

    public class ProjectsByPhaseWrapper {
        public String monthName {get;set;}
        public Integer projectsInPhase1 {get;set;}
        public Integer projectsInPhase2 {get;set;}
        public Integer projectsInPhase3 {get;set;}
        public Integer projectsInPhase4 {get;set;}
        public Set<Id> projectIds { get{ if ( projectIds == null ){ projectIds = new Set<Id>(); } return projectIds; } set; }

        private Datetime startDateTime;
        private Datetime endDateTime;


        public void addPhase(Id projectId, String phaseName, Datetime startDateTimeCheck, Datetime endDateTimeCheck){
            if( startDateTimeCheck == null ){ return; }

            Boolean checkBoolean = false;

            if(this.projectIds.contains(projectId)){
                checkBoolean = true;
            } else {
                if ( startDateTime <= startDateTimeCheck && startDateTimeCheck <= endDateTime ){
                    checkBoolean = true;
                } else if( endDateTimeCheck != null && startDateTime <= endDateTimeCheck && endDateTimeCheck <= endDateTime ){
                    checkBoolean = true;
                } else if( endDateTimeCheck != null && startDateTimeCheck <= startDateTime && endDateTime <= endDateTimeCheck ){
                    checkBoolean = true;
                }
            }

            if ( checkBoolean ){
                this.projectIds.add(projectId);
                if(phaseName == 'Phase 1'){
                    this.projectsInPhase1 = this.projectsInPhase1 + 1;
                } else if(phaseName == 'Phase 2'){
                    this.projectsInPhase2 = this.projectsInPhase2 + 1;
                } else if(phaseName == 'Phase 3'){
                    this.projectsInPhase3 = this.projectsInPhase3 + 1;
                } else if(phaseName == 'Phase 4'){
                    this.projectsInPhase4 = this.projectsInPhase4 + 1;
                }
            }
        }

        public ProjectsByPhaseWrapper (String monthValue, Datetime intervalDate) {
            this.monthName        = monthValue;
            this.projectsInPhase1 = 0;
            this.projectsInPhase2 = 0;
            this.projectsInPhase3 = 0;
            this.projectsInPhase4 = 0;

            this.startDateTime = Datetime.newInstanceGMT(intervalDate.year(), intervalDate.month(), 1);
            this.endDateTime   = Datetime.newInstanceGMT(intervalDate.year(), intervalDate.month() + 1, 1).addMinutes( -1 );
        }
    }

    public class LoginHistoryWrapper{
        public String monthName {get;set;}
        public Integer usersNumber {get;set;}
        private Set<Id> userIds{get;set;}

        public void addUser(Id userId){
            if (!this.userIds.contains(userId)){
                this.userIds.add(userId);
                this.usersNumber = this.usersNumber + 1;
            }
        }

        public LoginHistoryWrapper(String monthValue){
            this.monthName = monthValue;
            this.usersNumber = 0;
            this.userIds = new Set<Id>();
        }
    }


    private List<Project__c> allProjects(){
        return [SELECT Id, Name, Decision_Maker__c, Sponsor__c, Project_State__c, Risk_Associated__c,
                    Decision_impact__c, Phase__c, CreatedDate, Completed_Date__c,

                    IsDecisionEvaluation__c, IsDecisionExecution__c, IsDMGT__c, IsRiskAssessment__c, IsWeightedRankingsMatrix__c,

                    (Select Id From Team_Roles__r Where User__c = : UserInfo.getUserId() Limit 1),
                    (Select Id From Funding_Roles__r Where User__c = : UserInfo.getUserId() AND Role__c = : INFORMED_STAKEHOLDER_USER_ROLE Limit 1)/*,
                    (Select Id, Tool__c, Date__c, CreatedDate From Tool_Usage_Trackings__r Where Tool__c != null And CreatedDate >= : dt Order By CreatedDate)
                    (Select Id, Tool__c, Date__c, CreatedDate From Tool_Usage_Trackings__r Where Tool__c != null And Date__c >= : dateValue Order By Date__c)*/
                FROM Project__c
                    ORDER BY CreatedDate];
    }

    public class ProjectModel{
        public Id projectId {get;set;}
        public Project__c project {get; set;}

        //User role
        public Boolean isDecisionAdviser {get;set;}
        public Boolean isDecisionMaker {get;set;}
        public Boolean isSponsor {get;set;}
        public Boolean isInformedStakeholder {get;set;}

        public String projectName {get;set;}
        public String projectState {get;set;}
        public String projectRisk {get;set;}
        public String projectImpact {get;set;}
        public String projectPhase {get;set;}
        public String monthName {get;set;}

        public Datetime projectCreatedDate  {get;set;}
        public Datetime projectCompletedDate{get;set;}

        public ProjectModel(Project__c project){
            this.projectId = project.Id;
            this.project   = project;

            this.isDecisionAdviser     = !project.Team_Roles__r.isEmpty();
            this.isDecisionMaker       = project.Decision_Maker__c == UserInfo.getUserId();
            this.isSponsor             = project.Sponsor__c == UserInfo.getUserId();
            this.isInformedStakeholder = false;//!project.Funding_Roles__r.isEmpty();

            this.projectName   = project.Name;
            this.projectState  = project.Project_State__c != null ? project.Project_State__c : 'Not Selected';
            this.projectRisk   = project.Risk_Associated__c;
            this.projectImpact = project.Decision_impact__c != null ? project.Decision_impact__c : 'Not Selected';
            this.projectPhase  = project.Phase__c;

            this.projectCreatedDate   = project.CreatedDate;
            this.monthName            = project.CreatedDate.format('MMM') + '-' + project.CreatedDate.format('yy');
            this.projectCompletedDate = project.Completed_Date__c;
        }
    }

    private static String convertDateTime(Datetime datetimeValue, Boolean isShortMonthValue){
        Datetime dt = Datetime.newInstanceGMT(datetimeValue.year(), datetimeValue.month(), DAY_OF_MONTH);
        return dt.format(isShortMonthValue ? 'MMM' : 'MMMMM') + '-' + dt.format('yy');
    }
}