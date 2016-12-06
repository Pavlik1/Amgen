public with sharing class CriteriaServices{
    //this method create new Participant_Vote__c records for Criterias and Alternative Options
    public static void createVotes(Map<Id, Criteria__c> criteriasToIds) {
        //group Alternative Options by Criteria Project
        Map<Id, List<Alternative_Option__c>> alternatives = AlternativeOptionServices.groupAlternativesByProjectId(criteriasToIds.keySet());
        List<Participant_Vote__c> votes = new List<Participant_Vote__c>();

        for (Criteria__c criteria : criteriasToIds.values()) {
            
            if (!alternatives.containsKey(criteria.Project__c)) {
                continue;
            }

            for (Alternative_Option__c alternative : alternatives.get(criteria.Project__c)) {
                votes.add(new Participant_Vote__c(Alternative_Option__c = alternative.Id, Criteria__c = criteria.Id));
            }
        }

        insert votes;
        
    }

/* -------------------------------------- Begin DAO methods ----------------------------------------------- */
    
    //this method select and group Alternative Option records by Criterias Project
    public static Map<Id, List<Criteria__c>> groupCriteriasByProjectId(Set<Id> alternativesIds) {
        Map<Id, List<Criteria__c>> projectId2Criterias = new Map<Id, List<Criteria__c>>();

        for (Criteria__c crit : [SELECT Id, Name, Weighting__c, Project__c
                                            FROM Criteria__c
                                            WHERE Project__c IN (SELECT Project__c FROM Alternative_Option__c WHERE Id IN :alternativesIds AND Project__c != null)]) {

            if (!projectId2Criterias.containsKey(crit.Project__c)) {
                projectId2Criterias.put(crit.Project__c, new List<Criteria__c>());
            }

            projectId2Criterias.get(crit.Project__c).add(crit);
        }
        
        return projectId2Criterias;
    }

    public static List<Criteria__c> getCriteriasByProjectId(final Id projectId) { 
        return new List<Criteria__c>([SELECT Id, Name, Project__c, Weighting__c, CreatedDate 
                                      FROM Criteria__c
                                      WHERE Project__c =: projectId ORDER BY Name]);
        
    }

}