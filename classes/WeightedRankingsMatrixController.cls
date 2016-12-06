public with sharing class WeightedRankingsMatrixController extends CommonToolsController {
    public Integer itemToDelete {get; set;}
    public Integer criteriaIndex {get; set;}
    public Id editedCriteriaId {get; set;}
    public Integer weightingValue {get; set;}
    Public String retURL {get; set;}

    //this method should be updated
    public override void updateView(){
        if (this.activityTracking != null && this.activityTracking.View_Update__c == Constants.USER_ACTIVITY_TRACKING_VIEW && this.project != null && this.project.Id != null){
            this.activityTracking.View_Update__c = Constants.USER_ACTIVITY_TRACKING_UPDATE;
            if (this.activityTracking.Project__c == null) this.activityTracking.Project__c = this.project.Id;
            upsert this.activityTracking;
            this.activityTracking = null;
        }
    }

    public String currentToolName(){ return Constants.WEIGHTED_RANKINGS_MATRIX; }
    public void populateExistingWrappers(){
        this.allUpdatedWrappers = new List<ToolsWrapper>();
        this.allUpdatedWrappers.addAll(this.criteriaWrappers);
    }


    private Tool_Usage_Tracking__c toolUsageTraking{
        get{
            if (this.toolUsageTraking == null){
                this.toolUsageTraking = new Tool_Usage_Tracking__c(AreasAffected__c = 0,
                                                                  Project__c = this.projectId,
                                                                  Date__c = Date.today(),
                                                                  Tool__c = Constants.WEIGHTED_RANKINGS_MATRIX);
            }
            return toolUsageTraking;
        }
        set;
    }

    private void updateToolUsageTrakingOnDeleteRow(){
        this.toolUsageTraking.AreasAffected__c = this.toolUsageTraking.AreasAffected__c + 1;

        if (this.toolUsageTraking.AreasAffected__c > 0 ){
            if(this.toolUsageTraking.Project__c == null) this.toolUsageTraking.Project__c = this.project.Id ;
            upsert this.toolUsageTraking;
        }
    }

    private void updateToolUsageTrakingOnSubmit(){
        this.toolUsageTraking.AreasAffected__c = this.toolUsageTraking.AreasAffected__c + 1;

        if (this.toolUsageTraking.AreasAffected__c > 0 ){
            if(this.toolUsageTraking.Project__c == null) this.toolUsageTraking.Project__c = this.project.Id ;
            upsert this.toolUsageTraking;
        }
    }

    public List<Criteria__c> criterias {
        get{
            if (null == this.criterias) {
                this.criterias = CriteriaServices.getCriteriasByProjectId(this.projectId);
            }
            return this.criterias;
        }
        set;
    }

    public List<ToolsWrapper> criteriaWrappers {
		get {
			if (null == this.criteriaWrappers) {
				this.criteriaWrappers = new List<ToolsWrapper>();

				for (Integer i = 0; i < this.criterias.size(); i++) {
					this.criteriaWrappers.add(new ToolsWrapper(this.criterias.get(i), i));
				}
			}
			return this.criteriaWrappers;
		}
		set;
	}

    public List<Alternative_Option__c> alternatives {
        get{
            if (null == this.alternatives) {
                this.alternatives = AlternativeOptionServices.getAlternativesByProjectId(this.projectId);
            }
            return this.alternatives;
        }
        set;
    }

    public Boolean displayPopUp {
        get{
            if (null == this.displayPopUp) {
                this.displayPopUp = false;
            }
            return this.displayPopUp;
        }
        set;
    }

    public Boolean removeCriteria {
        get{
            if (null == this.removeCriteria) {
                this.removeCriteria = false;
            }
            return this.removeCriteria;
        }
        set;
    }

    public WeightedRankingsMatrixController() {
        this.projectId = ApexPages.currentPage().getParameters().get('id');
        this.retURL    = ApexPages.currentPage().getParameters().get('retURL');

    }

    public PageReference goBack(){
        return String.isBlank(this.retURL) ? new PageReference('/'+this.project.Id) : new PageReference(this.retURL);
    }

    public void submit() {
        try{
            List<Participant_Vote__c> votesToUpdate = new List<Participant_Vote__c>();

            for (Alternative_Option__c alter : this.alternatives) {
                for (Participant_Vote__c pv : alter.Participant_Votes__r) {
                    pv.Ranking__c =  String.isNotBlank(pv.Votes__c) ? Integer.valueOf(pv.Votes__c) * pv.Criteria__r.Weighting__c : 0;
                    votesToUpdate.add(pv);
                }
            }

            upsert this.criterias;
            update votesToUpdate;
            //reload wrapper by new values
            this.criteriaWrappers = null;

            //start Check Items Workflow
            WorkflowServices.checkItemWorkflow(Constants.WEIGHTED_RANKINGS_MATRIX, this.project.Id); 

            updateToolUsageTrakingOnSubmit();
            this.updateView();

        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));

        }
    }

    public void addAlternative() {
        if (this.alternatives.isEmpty() || null != this.alternatives.get(this.alternatives.size()-1).Id) {
            this.alternatives.add(new Alternative_Option__c(Project__c = this.projectId));
        }
        
    }

    public void addCriteria() {
        if (this.criterias.isEmpty() || null != this.criterias.get(this.criterias.size()-1).Id) {
            this.criterias.add(new Criteria__c(Project__c = this.projectId));
        }
        
    }

    public void submitAlternatives() {
        try{
            upsert this.alternatives;
            this.alternatives = null;

            updateToolUsageTrakingOnSubmit();
            this.updateView();

        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));

        }
    }

    public void submitCriterias() {
        try{
            upsert this.criterias;

            //reload by new values
            this.criterias = null;
            this.alternatives = null;
            this.criteriaWrappers = null;

            updateToolUsageTrakingOnSubmit();
            this.updateView();

        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));

        }
    }

    public void deleteAlternative() {
        try{

            Alternative_Option__c alternative = this.alternatives.get(this.itemToDelete);

            if (null != alternative.Id) {
                delete alternative;
                this.alternatives = null;

                updateToolUsageTrakingOnDeleteRow();

            } else {
                this.alternatives.remove(this.itemToDelete);
            }

            this.displayPopUp = false;
            this.updateView();

        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));

        }
    }

    public void deleteCriteria() {
        try{

            Criteria__c criteria = this.criterias.get(this.criteriaIndex);

            if (null != criteria.Id) {
                delete criteria;
                this.criterias        = null;
                this.alternatives     = null;

                updateToolUsageTrakingOnDeleteRow();
                this.updateView();

            } else {
                this.criterias.remove(this.criteriaIndex);
            }

            //reload wrapper by new values
            this.criteriaWrappers = null;
            this.displayPopUp = false;

        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));

        }
    }

    public void changeWeightingValue() {
    	for (Alternative_Option__c alter : this.alternatives) {
            for (Participant_Vote__c pv : alter.Participant_Votes__r) {
                if (pv.Criteria__c == this.editedCriteriaId) {
                	pv.Criteria__r.Weighting__c = this.weightingValue;
                }
            }
        }
    }

    public void editWeighting() {
    	this.criteriaWrappers.get(this.criteriaIndex).isEditMode = true;
    }

    public void closePopup() {
        this.displayPopUp = false;
    }
    public void openPopup() {
        this.displayPopUp = true;
    }
}