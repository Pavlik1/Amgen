public with sharing class RiskAssessmentDetailsController{
    private final Id riskId;
    public Id projectId{
        get {
            if (null == this.projectId) {
                this.projectId = risk.Project__c != null ? risk.Project__c : (risk.Alternative__r.Project__c != null ? risk.Alternative__r.Project__c : '');
            }
            return this.projectId;
        }
        
        set;
    } 

    public Project__c project {
        get {
            if (null == this.project) {
                this.project = ProjectServices.getProjectById(this.projectId);
            } 
            return this.project;
        }
        set;
    }

    public Risk__c risk {
        get {
            if (null == this.risk) {
                this.risk = RiskServices.getRiskById(this.riskId);
            } 
            return this.risk;
        }
        set;
    }

    public List<RiskLevelRule__mdt> riskLevelRules{
        get{
            if (null == this.riskLevelRules) {
                this.riskLevelRules = RiskServices.getRiskLevelRules();
            }
            return this.riskLevelRules;
        }
        set;
    }

    public Map<String, List<RiskLevelRule__mdt>> riskLevelRulesToLikelihood{
        get{
            if (null == this.riskLevelRulesToLikelihood) {
                this.riskLevelRulesToLikelihood = new Map<String, List<RiskLevelRule__mdt>>();
                
                for (RiskLevelRule__mdt rlr : this.riskLevelRules) {
                    if (!this.riskLevelRulesToLikelihood.containsKey(rlr.Likelihood__c)) {
                        this.riskLevelRulesToLikelihood.put(rlr.Likelihood__c, new LIst<RiskLevelRule__mdt>());

                    } 
                    
                    this.riskLevelRulesToLikelihood.get(rlr.Likelihood__c).add(rlr);
                    
                }
            }
            return this.riskLevelRulesToLikelihood;
        }
        set;
    }

    public List<RiskLevelRule__mdt> likelihoodIndexes {
        get{
            if (null == this.likelihoodIndexes) {
                this.likelihoodIndexes = new List<RiskLevelRule__mdt>();
                Set<String> isContains = new Set<String>();

                for (RiskLevelRule__mdt rlr : this.riskLevelRules) {
                    if (!isContains.contains(rlr.Likelihood__c)) {
                        isContains.add(rlr.Likelihood__c);
                        this.likelihoodIndexes.add(rlr);
                    }
                }
            }
            return this.likelihoodIndexes;
        } 
        set; 
    }

    public List<RiskLevelRule__mdt> impactIndexes {
        get{
            if (null == this.impactIndexes) {
                this.impactIndexes = new List<RiskLevelRule__mdt>();
                Set<String> isContains = new Set<String>();

                for (RiskLevelRule__mdt rlr : this.riskLevelRules) {
                    if (!isContains.contains(rlr.Impact__c)) {
                        isContains.add(rlr.Impact__c);
                        this.impactIndexes.add(rlr);
                    }
                }
            }
            return this.impactIndexes;
        } 
        set; 
    }

    public RiskAssessmentDetailsController() {
        this.riskId = ApexPages.currentPage().getParameters().get('id');

    }

    public PageReference goBack(){
        return new PageReference('/apex/RiskAssessmentTool?id=' + this.projectId);
    }
    
    public PageReference submit(){
        update this.risk;
        return goBack();
    }

}