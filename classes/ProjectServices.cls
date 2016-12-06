public with sharing class ProjectServices{

    /* -------------------------------------- Begin DAO methods ----------------------------------------------- */
    public static Project__c getProjectById(final Id projectId) { 
        List<Project__c> projects = new List<Project__c>([SELECT Id, Name, Phase__c, Larger_workstream__c, Due_Date__c, Sponsor__c, Is_the_sponsor_an_Advice_Giver__c, Status_Image__c,
                                                            Is_the_sponsor_an_Decision_Maker__c, Decision_Recommendation__c, Decision_impact__c, Risk_Associated__c, Is_GMT_PDF__c, Completed_Weighted_Ranking_Matrix__c,
                                                            Anticipated_Risk_Challenges__c, Communication_Expectations__c, Decision_Maker__c, Did_the_decision_meet_expected_outcomes__c,
                                                            Variance__c, Was_decision_based_on_appropriate_facts__c, Was_decision_made_within_stated_time__c, Was_the_execution_plan_effective__c, 
                                                            Was_execution_plan_effective_Comment__c, D_at_appropriate_level_to_make_decision__c, Appropriate_level_make_decision_Comment__c,
                                                            Did_the_D_select_appropriate_A_s__c, Did_the_D_select_appropriate_A_s_Comment__c, What_coaching_have_you_given_the_D__c,
                                                            Sponsor_played_role_on_decision_making__c, Sponsor_role_on_decision_making_Comment__c, What_is_your_path_moving_forward__c       
                                                          FROM Project__c
                                                          WHERE Id =: projectId]);
        return projects.isEmpty() ? new Project__c() : projects.get(0);
        
    }

    public static Project__c getProjectWithCheckItemsById(final Id projectId) { 
        List<Project__c> projects = new List<Project__c>([SELECT Id, Phase__c, Sub_Phases__c, Status_Image__c, Decision_impact__c,
                                                            (SELECT Id, Subphase__r.Name, Subphase__r.Phase__r.Name, Subphase__r.Phase__r.Description__c, Checked__c, Tool_Is_Used__c, Item_Text__c
                                                             FROM Check_List_Items__r ORDER BY Subphase__r.Sequence_Number__c, Sequence_Number__c)
                                                          FROM Project__c
                                                          WHERE Id = :projectId]);
        return projects.isEmpty() ? new Project__c() : projects.get(0);
        
    }

    public static List<Business_Result__c> getResultsByProjectId(final Id projectId) { 
        return new List<Business_Result__c>([SELECT Id, Name, Project__c, Result__c
                                             FROM Business_Result__c
                                             WHERE Project__c =: projectId]);
        
    }   

    public static List<Project__c> getProjects() { 
        return new List<Project__c>([SELECT Id, Name, Phase__c, Project_State__c
                                     FROM Project__c]);
        
    }

    public static List<Funding_Role__c> getFundingRoleByProjectId(final Id projectId) { 
        return new List<Funding_Role__c>([SELECT Id, Name, Project__c, User__c, Role__c
                                             FROM Funding_Role__c
                                             WHERE Project__c =: projectId]);
        
    }

    public static List<Decision_Due_Date__c> getDueDatByProjectId(final Id projectId) { 
        return new List<Decision_Due_Date__c>([SELECT Id, Name, Project__c, Date__c, Milestones_Deliverables__c
                                               FROM Decision_Due_Date__c
                                               WHERE Project__c =: projectId]);
        
    } 

    public static List<Team_Role__c> getTeamRoleByProjectId(final Id projectId) { 
        return new List<Team_Role__c>([SELECT Id, Name, Project__c, User__c, User__r.Title
                                       FROM Team_Role__c
                                        WHERE Project__c =: projectId]);
        
    }

    public static Map<Id, Project__c> getProjectsByUserAndName(Id userId, String name, Boolean allProjects) { 
        Set<Id> projectsIds = getProjectsIdsByUserTeamRoles(userId);

        String query  = 'SELECT Id, Phase__c, Sub_Phases__c, Name, Sponsor__c, Sponsor__r.Name, Decision_Maker__c, Decision_Maker__r.Name,  ';
        query += 'Due_Date__c, Decision_impact__c, Status__c, Project_State__c, Status_Image__c , Risk_Associated__c, ';
        query += '(SELECT User__c FROM Team_Roles__r), ';
        query += '(SELECT Id, Checked__c, Subphase__r.Name, Item_Text__c FROM Check_List_Items__r ORDER BY Subphase__r.Sequence_Number__c, Sequence_Number__c) ';
        query += 'FROM Project__c ';
        query += !allProjects ? 'WHERE (Sponsor__c =: userId OR Decision_Maker__c =: userId OR Id IN :projectsIds) ' : '';
        query += String.isBlank(name) ? '' : (allProjects ? 'WHERE ' : ' AND ' ) + ' Name Like \'%'+name+'%\'';

        Map<Id, Project__c> projects2Ids = new Map<Id, Project__c>((List<Project__c>)Database.query(query));
        return projects2Ids;   
    } 

    public static Set<Id> getProjectsIdsByUserTeamRoles(Id userId) {
        Set<Id> projectsIds = new Set<Id>();

        for (Team_Role__c role : [SELECT Id, Project__c 
                                  FROM Team_Role__c 
                                  WHERE User__c =: userId]) {
            projectsIds.add(role.Project__c);
        }

        return projectsIds;
    }

    /* -------------------------------------- End DAO methods ----------------------------------------------- */

    public static List<Project__c> filteredProjectForChangedPhaseNotification( List<Project__c> newProjects, Map<Id, Project__c> oldProjectsMap ){
        List<Project__c> filteredProjects = new List<Project__c>();

        for (Project__c project : newProjects){
            if ( project.Prev_Phase_Value__c != oldProjectsMap.get(project.Id).Phase__c && (project.Sponsor__c != null || project.Decision_Maker__c != null) ){
                filteredProjects.add( project );
            }
        }

        return filteredProjects;
    }

    public static void populatePrevPhase( List<Project__c> newProjects, Map<Id, Project__c> oldProjectsMap ){
        for (Project__c project : newProjects){
            if (project.Prev_Phase_Value__c != oldProjectsMap.get(project.Id).Phase__c){//please check if this condition is correct
                project.Prev_Phase_Value__c = oldProjectsMap.get(project.Id).Phase__c;
            }
        }
    }

    public static List<Project__c> filteredProjectWithCompleteStatePopulateCompleteDate( List<Project__c> newProjects, Map<Id, Project__c> oldProjectsMap ){
        List<Project__c> filterResult = new List<Project__c>();

        if (newProjects != null && oldProjectsMap != null){
            for (Project__c project : newProjects){
                if( project.Project_State__c == 'Completed' && project.Project_State__c != oldProjectsMap.get( project.Id ).Project_State__c ){
                    project.Completed_Date__c = Datetime.now();
                    filterResult.add(project);
                }
            }
        }

        return filterResult;
    }

    public static void completeAllExistingPhase( List<Project__c> filteredProjects, Map<Id, Project__c> oldProjectsMap ){
        if ( filteredProjects == null || filteredProjects.isEmpty() ){ return; }

        List<Phase__c> updatePhaseList = [SELECT Id, Name, Project__c, End_Date__c, Start_Date__c, Project__r.Completed_Date__c
                                          FROM Phase__c
                                          WHERE Project__c IN : filteredProjects AND
                                                RecordType.Name = : Constants.PHASE_PROJECT_INSTANCE_TYPE_NAME AND
                                                (End_Date__c = null OR Start_Date__c = null)];

        for (Phase__c phase : updatePhaseList){
            if ( phase.Start_Date__c == null ){
                //populate on before update
                phase.Start_Date__c = Datetime.now();
            }
            if( phase.End_Date__c == null ){
                //populate on before update
                phase.End_Date__c = Datetime.now();
            }
        }

        try{
            update updatePhaseList;
        } catch (DmlException dmlEx){
            for ( Integer i = 0; i < dmlEx.getNumDml(); i++ ){
                new Map<Id, Project__c>( filteredProjects ).get( updatePhaseList[dmlEx.getDmlIndex(i)].Project__c ).addError('Can not update Phase for project: ' + dmlEx.getMessage() );
            }
        }
    }

    public static List<Project__c> filteredProjectForUpdatePhase( List<Project__c> newProjects, Map<Id, Project__c> oldProjectsMap ){
        List<Project__c> filterResult = new List<Project__c>();

        if (newProjects != null && oldProjectsMap != null){
            for (Project__c project : newProjects){
                if( project.Phase__c != oldProjectsMap.get( project.Id ).Phase__c ){
                    filterResult.add(project);
                }
            }
        }

        return filterResult;
    }

    public static void updateExistingPhase( List<Project__c> filteredProjects, Map<Id, Project__c> oldProjectsMap ){
        if ( filteredProjects == null || filteredProjects.isEmpty() ){ return; }

        List<Phase__c> updatePhaseList = new List<Phase__c>();
        List<Phase__c> existingPhases = [SELECT Id, Name, Project__c, End_Date__c, Start_Date__c,
                                            Project__r.Prev_Phase_Value__c, Project__r.Phase__c
                                         FROM Phase__c
                                         WHERE Project__c IN : filteredProjects AND
                                                RecordType.Name = : Constants.PHASE_PROJECT_INSTANCE_TYPE_NAME];

        for (Phase__c phase : existingPhases){
            Boolean doUpdate = false;
            if ( phase.Name == phase.Project__r.Phase__c ){
                phase.Start_Date__c = Datetime.now();
                doUpdate = true;
            }
            if( phase.Name == phase.Project__r.Prev_Phase_Value__c ){
                phase.End_Date__c = Datetime.now();
                doUpdate = true;
            }
            if (doUpdate){
                updatePhaseList.add(phase);
            }
        }

        try{
            update updatePhaseList;
        } catch (DmlException dmlEx){
            for ( Integer i = 0; i < dmlEx.getNumDml(); i++ ){
                new Map<Id, Project__c>( filteredProjects ).get( updatePhaseList[dmlEx.getDmlIndex(i)].Project__c ).addError('Can not update Phase for project: ' + dmlEx.getMessage() );
            }
        }
    }

    public static void initPhaseForProjects( List<Project__c> filteredProjects ){
        if( filteredProjects == null || filteredProjects.isEmpty() ){ return; }

        List<Phase__c> newPhaseList = new List<Phase__c>();

        Id phaseProjectInstanceRecordType;
        for (Schema.RecordTypeInfo schemaRecordTypeInfoItem : Phase__c.SObjectType.getDescribe().getRecordTypeInfos()){
            if ( schemaRecordTypeInfoItem.getName() == Constants.PHASE_PROJECT_INSTANCE_TYPE_NAME){
                phaseProjectInstanceRecordType = schemaRecordTypeInfoItem.getRecordTypeId();
            }
        }

        List<Phase__c> masterPhaseRecords = [SELECT Id, Name
                                             FROM Phase__c
                                             WHERE RecordType.Name = : Constants.PHASE_MASTER_RECORD_TYPE_NAME ORDER BY Name];

        for ( Project__c project : filteredProjects ){
            for (Phase__c phaseItem : masterPhaseRecords){
                Phase__c newPhase = new Phase__c(Project__c = project.Id, Name = phaseItem.Name, RecordTypeId = phaseProjectInstanceRecordType);
                if(phaseItem.Name.endsWith('1')){
                    newPhase.Start_Date__c = Datetime.now();
                }
                newPhaseList.add( newPhase );
            }
        }

        try{
            insert newPhaseList;
        } catch(DmlException dmlEx) {
            for ( Integer i = 0; i < dmlEx.getNumDml(); i++ ){
                new Map<Id, Project__c>( filteredProjects ).get( newPhaseList[dmlEx.getDmlIndex(i)].Project__c ).addError('Can not create Phase for project: ' + dmlEx.getMessage() );
            }
        }
    }
}