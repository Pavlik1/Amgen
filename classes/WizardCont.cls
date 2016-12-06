public with sharing class WizardCont {
    public xrospackages__Project__c project{get;set;}
    public List<Funding_Role__c> rosters{get;set;}
    public Funding_Role__c roster{get;set;}

    public String currentStep{get;set;}
    public WizardCont(ApexPages.StandardController controller){
        this.project = (xrospackages__Project__c)controller.getRecord();
        if(this.project.Id != null){
            this.project = [SELECT Id, Name, xrospackages__Due_Date__c, xrospackages__Status__c, xrospackages__Workstream__c
                            FROM xrospackages__Project__c
                            WHERE Id = : this.project.Id];
        }
        if (this.project.Id != null){
            this.rosters = [SELECT Id, Name, User__r.FirstName, User__r.LastName,
                                    xrospackages__Role__c, User__r.Email, User__r.Phone
                            FROM Funding_Role__c
                            WHERE xrospackages__Project__c = : this.project.Id];
        } else {
            this.rosters = new List<Funding_Role__c>();
        }
        this.roster = new Funding_Role__c(xrospackages__Project__c = this.project.Id);
        this.currentStep = '1';
    }

    public void addRoster(){
        insert this.roster;
        this.roster = new Funding_Role__c(xrospackages__Project__c = this.project.Id);
    }
}