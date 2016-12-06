public with sharing class ProjectsToStatesChartController {
    public List<ProjectsToState> projectsToStates{
        get {
            if (null == this.projectsToStates) {
                this.projectsToStates = new List<ProjectsToState>();
                
                String query  = 'SELECT COUNT(Id), xrospackages__Project_State__c FROM Project__c ';
                query += ' GROUP BY xrospackages__Project_State__c ';

                for (AggregateResult ar : Database.query(query)) {
                    this.projectsToStates.add(new ProjectsToState((String)ar.get('xrospackages__Project_State__c'), (Integer)ar.get('expr0')));
                }
            }
            return this.projectsToStates;
        }
        set;
    }
}