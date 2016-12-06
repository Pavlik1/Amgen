public with sharing class ProjectListCont {

	public List<xrospackages__Project__c> projects{
        get{
            if(projects == null){
                projects = [ Select Id, xrospackages__Phase__c, xrospackages__Sub_Phases__c, Name, xrospackages__Sponsor__c, 
                                    xrospackages__Sponsor__r.Name, Decision_Maker__c, Decision_Maker__r.Name, 
                                    xrospackages__Due_Date__c, xrospackages__Decision_impact__c, xrospackages__Status__c
                             From xrospackages__Project__c ];
            }
            return projects;
        }
        set;
    }

    public ProjectListCont(ApexPages.StandardController stdController) {
    
    }

}