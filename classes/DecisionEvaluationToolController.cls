public with sharing class DecisionEvaluationToolController extends CommonToolsController {
	public Integer resultToDelete {get; set;}
    Public String retURL {get; set;}

    public String currentToolName(){ return Constants.DECISION_EVALUATION_TOOL; }
    public void populateExistingWrappers(){
        this.allUpdatedWrappers = new List<ToolsWrapper>();
        this.allUpdatedWrappers.addAll(this.resultWrappers);
    }


	public List<ToolsWrapper> resultWrappers {
		get {
			if (null == this.resultWrappers) {
				this.resultWrappers = new List<ToolsWrapper>();

				List<Business_Result__c> projectresults = ProjectServices.getResultsByProjectId(this.projectId);

				for (Integer i = 0; i < projectresults.size(); i++) {
					this.resultWrappers.add(new ToolsWrapper('Business_Result__c', projectresults.get(i), i));
				}
			}
			return this.resultWrappers;
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

	public Boolean displayAddResult {
		get{
			if (null == this.displayAddResult) {
				this.displayAddResult = true;
			}
			return this.displayAddResult;
		}
		set;
	}

	public DecisionEvaluationToolController() {
		this.projectId = ApexPages.currentPage().getParameters().get('id');
        this.retURL    = ApexPages.currentPage().getParameters().get('retURL');

	}

	public PageReference goBack(){
        return String.isBlank(this.retURL) ? new PageReference('/'+this.project.Id) : new PageReference(this.retURL);
	}

	public void submit() {
		try {
			//upsert project records
			upsert this.project;

			Set<String> fields = new Set<String>{'Id','Name','Phase__c','Did_the_decision_meet_expected_outcomes__c','Variance__c',
												 'Was_decision_based_on_appropriate_facts__c','Was_decision_made_within_stated_time__c',
												 'Was_the_execution_plan_effective__c','Was_execution_plan_effective_Comment__c',
												 'D_at_appropriate_level_to_make_decision__c','Appropriate_level_make_decision_Comment__c',
												 'Did_the_D_select_appropriate_A_s__c','Did_the_D_select_appropriate_A_s_Comment__c',
												 'What_coaching_have_you_given_the_D__c','Sponsor_played_role_on_decision_making__c',
												 'Sponsor_role_on_decision_making_Comment__c','What_is_your_path_moving_forward__c'};

			//start Check Items Workflow
            WorkflowServices.checkItemWorkflow(fields, Constants.DECISION_EVALUATION_TOOL, this.project.Id); 

            System.debug(LoggingLevel.ERROR, '^^^ fields = ' + fields);

            super.changesForProject(fields);
            System.debug(LoggingLevel.ERROR, '^^^ DONE');

		} catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));

        } 
	}

	public void saveAndNew(){
		saveResult();
		addResult();
	}

	public void saveResult() {
		try {
			//get all records from wrapper class
			List<Business_Result__c> projectResults = new List<Business_Result__c>();
			for (ToolsWrapper rw : this.resultWrappers) {
				projectResults.add((Business_Result__c)rw.sObjectItem);
			}

			//upsert records
			upsert projectResults;

			populateExistingWrappers();
			super.updateView();

			//populate resultWrappers by new values
			this.resultWrappers = null;
			//show Add Business Result button when oll changes are saved
			this.displayAddResult = true;

			//updateToolUsageTraking();
		} catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));

        } 
	}

	public void addResult() {
		ToolsWrapper resultWrapper = new ToolsWrapper('Business_Result__c', new Business_Result__c(Project__c = this.projectId), this.resultWrappers.size());
		this.resultWrappers.add(resultWrapper);

		//hide Add Business Result button if user creates new record
		this.displayAddResult = false;
	}

	public void deleteResult() {
		try {
			//get record for deleting
			Business_Result__c itemToDelete = (Business_Result__c)this.resultWrappers.get(this.resultToDelete).sObjectItem;
			//delete existing record 
			if (null != itemToDelete.Id) {
				delete itemToDelete;
			//show Add Business Result button if user delete unsaved record
			} else {
				this.displayAddResult = true;
			}

            this.allDeletedWrappers = new List<ToolsWrapper>{this.resultWrappers.get(this.resultToDelete)};
            super.updateView();

			//remove record from wrapper class
			this.resultWrappers.remove(this.resultToDelete);
			//populate resultWrappers by new values (set new index for records)
			reloadWrappers();
			//hide popup
			this.displayPopUp = false; 

			//updateToolUsageTraking();
		} catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));

        } 
	}

	public void reloadWrappers() {
		//store old values
		List<ToolsWrapper> oldList = this.resultWrappers;
		this.resultWrappers = new List<ToolsWrapper>();

		//populate resultWrappers by new values (set new index for records)
		for (Integer i = 0; i < oldList.size(); i++) {
			this.resultWrappers.add(new ToolsWrapper('Business_Result__c', oldList.get(i).sObjectItem, i));
		}
	}

	public void closePopup() {
		this.displayPopUp = false;
	}
	public void openPopup() {
		this.displayPopUp = true;
	}
}