public with sharing class RiskServices{

    /* -------------------------------------- Begin DAO methods ----------------------------------------------- */
    public static Risk__c getRiskById(final Id riskId) { 
        List<Risk__c> risks = new List<Risk__c>([SELECT Id, Name, Actions__c, Description__c, Impact__c, Impact_Value__c, Likelihood__c, Likelihood_Value__c, Project__c, Risk_Result__c, Risk_Type__c, 
                                                       CreatedDate, OwnerId, Project__r.Phase__c, Project__r.Name,  Project__r.Larger_workstream__c,  Project__r.Due_Date__c,  Project__r.Sponsor__c,  
                                                       Project__r.Is_the_sponsor_an_Advice_Giver__c,  Project__r.Is_the_sponsor_an_Decision_Maker__c, Owner.Name,  Project__r.Decision_Maker__c, 
                                                       Project__r.Decision_Recommendation__c, Alternative__r.Project__c
                                                FROM Risk__c
                                                WHERE Id =: riskId]);
        return risks.isEmpty() ? new Risk__c() : risks.get(0);
        
    }

    public static List<Risk__c> getRisksByProjectIdAndFilter(final Id projectId, String filter) { 
        String query  = 'SELECT Id, Name, Actions__c, Description__c, Impact__c, Impact_Value__c, Likelihood__c, Likelihood_Value__c, Project__c, Risk_Result__c, Risk_Type__c, CreatedDate,  ';
        query += ' OwnerId, Owner.Name, Alternative__c, Project__r.Id, Project__r.Name, Alternative__r.Name, Alternative__r.Id, ';
        query += '(SELECT Id, Name, Risk__c, User__c, User__r.Name, User__r.Id, Risk__r.Project__c FROM Risk_Owners__r) ';
        query += 'FROM Risk__c ';
        query += filter == Constants.ALL ? 'WHERE Project__c =: projectId OR Alternative__r.Project__c =: projectId ' : '';
        query += filter == Constants.DECISION ? 'WHERE Project__c =: projectId ' : '';
        query += filter instanceof Id ? 'WHERE Alternative__c =: filter ' : '';
        query += 'ORDER BY CreatedDate ';

        return Database.query(query);  
    }

    public static List<RiskLevelRule__mdt> getRiskLevelRules() { 
        return new List<RiskLevelRule__mdt>([SELECT DeveloperName, MasterLabel, Impact__c, Impact_Value__c, Likelihood__c, Likelihood_Value__c, Risk_Level__c
                                             FROM RiskLevelRule__mdt ORDER BY Likelihood_Value__c DESC, Impact_Value__c ]);
        
    }

    public static List<Action_Owner__c> getActionOwnerByRiskProject(final Id projectId) { 
        return new List<Action_Owner__c>([SELECT Id, Name, Risk__c, User__c, User__r.Name, User__r.Id, Risk__r.Project__c
		                                  FROM Action_Owner__c 
		                                  WHERE Risk__r.Project__c =: projectId]);
        
    }
    /* -------------------------------------- End DAO methods ----------------------------------------------- */
}