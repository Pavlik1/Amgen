public with sharing class AlternativeOptionServices{
    //this method create new Participant_Vote__c records for Criterias and Alternative Options
    public static void createVotes(Map<Id, Alternative_Option__c> alternativesToIds) {
        //group Creteria by Alternative Options Project
        Map<Id, List<Criteria__c>> criteriasToProjectId = CriteriaServices.groupCriteriasByProjectId(alternativesToIds.keySet());
        List<Participant_Vote__c> votes = new List<Participant_Vote__c>();

        for (Alternative_Option__c alternative : alternativesToIds.values()) {
            
            if (!criteriasToProjectId.containsKey(alternative.Project__c)) {
                continue;
            }

            for (Criteria__c criteria : criteriasToProjectId.get(alternative.Project__c)) {
                votes.add(new Participant_Vote__c(Criteria__c = criteria.Id, Alternative_Option__c = alternative.Id));
            }
        }

        insert votes;
        
    }

/* -------------------------------------- Begin DAO methods ----------------------------------------------- */
    
    //this method select and group Alternative Option records by Criterias Project
    public static Map<Id, List<Alternative_Option__c>> groupAlternativesByProjectId(Set<Id> criteriaIds) {
        Map<Id, List<Alternative_Option__c>> projectId2Alternatives = new Map<Id, List<Alternative_Option__c>>();

        for (Alternative_Option__c alter : [SELECT Id, Name, Description__c, Project__c
                                            FROM Alternative_Option__c
                                            WHERE Project__c IN (SELECT Project__c FROM Criteria__c WHERE Id IN :criteriaIds AND Project__c != null)]) {
            if (!projectId2Alternatives.containsKey(alter.Project__c)) {
                projectId2Alternatives.put(alter.Project__c, new List<Alternative_Option__c>());
            }
            projectId2Alternatives.get(alter.Project__c).add(alter);

        }

        return projectId2Alternatives;
    }

    public static List<Alternative_Option__c> getAlternativesByProjectId(final Id projectId) { 
        return new List<Alternative_Option__c>([SELECT Id, Name, Project__c, Description__c, CreatedDate, Risk_Score__c,
                                                    (SELECT Id, Ranking__c, Votes__c, Criteria__r.Weighting__c, Criteria__c FROM Participant_Votes__r ORDER BY Criteria__r.Name)
                                                FROM Alternative_Option__c
                                                WHERE Project__c =: projectId]);
        
    }

    /* -------------------------------------- End DAO methods ----------------------------------------------- */
}