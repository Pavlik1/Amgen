public with sharing class RiskAssessmentToolController extends CommonToolsController{
    private final Id altId;
    public Integer itemToDelete {get; set;}
    public Integer itemToEdit {get; set;}
    Public String retURL {get; set;}

    public void populateExistingWrappers(){
    	this.allUpdatedWrappers = new List<ToolsWrapper>();
    	this.allUpdatedWrappers.addAll( this.riskWrappers );
    }

	public String currentToolName(){
		return Constants.RISK_ASSESSMENT_TOOL;
	}

    private Tool_Usage_Tracking__c toolUsageTraking{
        get{
            if (this.toolUsageTraking == null){
                this.toolUsageTraking = new Tool_Usage_Tracking__c(AreasAffected__c = 0,
                                                                   Project__c = this.projectId,
                                                                   Date__c = Date.today(),
                                                                   Tool__c = currentToolName() );
            }
            return toolUsageTraking;
        }
        set;
    }

    private void updateToolUsageTraking(){
    	this.toolUsageTraking.AreasAffected__c = this.toolUsageTraking.AreasAffected__c + 1;

        if (this.toolUsageTraking.AreasAffected__c > 0 ){
            if(this.toolUsageTraking.Project__c == null) this.toolUsageTraking.Project__c = this.project.Id ;
            upsert this.toolUsageTraking;
        }
    }

    public List<ToolsWrapper> riskWrappers {
		get {
			if (null == this.riskWrappers) {
				this.riskWrappers = new List<ToolsWrapper>();

				List<Risk__c> risks = RiskServices.getRisksByProjectIdAndFilter(this.projectId, this.selectedFilter);

				for (Integer i = 0; i < risks.size(); i++) {
					this.riskWrappers.add(new ToolsWrapper('Risk__c', risks.get(i), i));
				}
			}
			return this.riskWrappers;
		}
		set;
	}

	public Boolean displayAddRow {
		get{
			if (null == this.displayAddRow) {
				this.displayAddRow = true;
			}
			return this.displayAddRow;
		}
		set;
	}

	public Boolean displaySubmit {
		get{
			if (null == this.displaySubmit) {
				this.displaySubmit = false;
			}
			return this.displaySubmit;
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

	public List<SelectOption> userOptions {
        get {
            if (null == this.userOptions) {
                this.userOptions = new List<SelectOption>();

                for (User u : UserServices.getUsers()) {
                    this.userOptions.add(new SelectOption(u.Id, u.Name));
                }
            }
            return this.userOptions;
        
        }
        set;
    }

    public List<SelectOption> filters {
        get{
            if (null == this.filters) {
                this.filters = new List<SelectOption>();

                //this.filters.add(new SelectOption(Constants.ALL, Constants.ALL));
                List<Alternative_Option__c> alternativeOptionList = AlternativeOptionServices.getAlternativesByProjectId(this.projectId);
                if (!alternativeOptionList.isEmpty()){
	                this.filters.add(new SelectOption(Constants.ALL, 'Decision and Alternatives'));
	            }
                this.filters.add(new SelectOption(Constants.DECISION, Constants.DECISION));
                //add alternatives
                for (Alternative_Option__c altern : alternativeOptionList) {
                	this.filters.add(new SelectOption(altern.Id, altern.Name));
                }   
            }
            return this.filters;
        }
        set;
    }

    public String selectedFilter {
    	get {
    		if (null == this.selectedFilter) {
    			this.selectedFilter = null == this.altId ? Constants.DECISION : this.altId;
    		}
    		return this.selectedFilter;
    	}
    	set;
    }

    public Map<Integer, List<String>> selectedActionOwnersToRisk {
    	get {
    		if (null == this.selectedActionOwnersToRisk) {
    			this.selectedActionOwnersToRisk = new Map<Integer, List<String>>();

    			Risk__c risk;
    			for (Integer i = 0; i < this.riskWrappers.size(); i++) {
    				if (!this.selectedActionOwnersToRisk.containskey(i)) {
    					this.selectedActionOwnersToRisk.put(i, new List<String>());
    				}

    				risk = (Risk__c)this.riskWrappers.get(i).sObjectItem;
    				for (Action_Owner__c owner : risk.Risk_Owners__r) {
    					this.selectedActionOwnersToRisk.get(i).add(owner.User__c);
    				}

    			}

    		}	
    		return this.selectedActionOwnersToRisk;
    	}
    	set;
    }

    public RiskAssessmentToolController() {
        this.projectId     = ApexPages.currentPage().getParameters().get('id');
        this.retURL        = ApexPages.currentPage().getParameters().get('retURL');
        this.altId = ApexPages.currentPage().getParameters().get('altId');

    }

    public PageReference goBack(){
		return String.isBlank(this.retURL) ? new PageReference('/'+this.project.Id) : new PageReference(this.retURL);
	}

	public void submitAndAddRow(){
		submit();
		addRow();
	}

	public void addRow() {
		ToolsWrapper iskWrapper = new ToolsWrapper('Risk__c', new Risk__c(), this.riskWrappers.size());

		if (this.selectedFilter == Constants.DECISION) {
			Risk__c risk = new Risk__c(OwnerId = UserInfo.getUserId(), Project__c = this.projectId);
			iskWrapper.sObjectItem = risk;
			
		} else if (this.selectedFilter instanceof Id) {
			Risk__c risk = new Risk__c(OwnerId = UserInfo.getUserId(), Alternative__c = this.selectedFilter);
			iskWrapper.sObjectItem = risk;
		}

		iskWrapper.isEditMode = true;
		this.riskWrappers.add(iskWrapper);

		//add new value for new row
		this.selectedActionOwnersToRisk.put(iskWrapper.index, new List<String>());

		//hide Add Row button if user creates new record
		this.displayAddRow = false;

		//show Submit button if user creates new record
		this.displaySubmit = true;
	}

	public void submit() {
		try { 
			//get all records from wrapper class
			List<Risk__c> projectRisks = new List<Risk__c>();

			for (ToolsWrapper tw : this.riskWrappers) {
				Risk__c risk = (Risk__c)tw.sObjectItem;
				projectRisks.add(risk);
			}

			//upsert records
			upsert projectRisks;

			this.populateExistingWrappers();
			this.updateView();

			reloadWrappers();

			//update Action Owners
			submitActionOwners();

			//show Add Row button when oll changes are saved
			this.displayAddRow = true;

			//hide Submit button when oll changes are saved
			this.displaySubmit = false;

			//start Check Items Workflow
            WorkflowServices.checkItemWorkflow(Constants.RISK_ASSESSMENT_TOOL, this.project.Id); 

            updateToolUsageTraking();
		} catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));

        }
	}

	public void submitActionOwners() {
		List<Action_Owner__c> actionOwnersToDelete = new List<Action_Owner__c>();
		List<Action_Owner__c> actionOwners         = new List<Action_Owner__c>();

		for (ToolsWrapper tw : this.riskWrappers) {
			Risk__c risk = (Risk__c)tw.sObjectItem;

			if (tw.isEditMode) {
				Set<String> selectedUsersIds = new Set<String>(this.selectedActionOwnersToRisk.get(tw.Index));

				for (Action_Owner__c owner : risk.Risk_Owners__r) {
					//delete unselected records
					if (!selectedUsersIds.contains(owner.User__c)) {
						actionOwnersToDelete.add(owner);

					//if records already exist don't need create new Action Owner
					} else {
						selectedUsersIds.remove(owner.User__c);
					}

				}
				//create new action Owners for selected users
				for (String userId : selectedUsersIds) {
					actionOwners.add(new Action_Owner__c(User__c = userId, Risk__c = risk.Id));
				}
			}
		}

		if (!actionOwnersToDelete.isEmpty()) {
			delete actionOwnersToDelete;
		}

		if (!actionOwners.isEmpty()) {
			insert actionOwners;
		}

		//reload by new values
		this.selectedActionOwnersToRisk = null;
		this.riskWrappers = null;

	}

	public void deleteRisk() {
		try {
			//get record for deleting
			sObject itemToDelete = this.riskWrappers.get(this.itemToDelete).sObjectItem;

			//delete existing record 
			if (null != itemToDelete.Id) {
				delete itemToDelete;
			//show Add New Row button if user delete unsaved record
			} else {
				this.displayAddRow = true;
				this.displaySubmit = false;
			}

			this.allDeletedWrappers = new List<ToolsWrapper>{this.riskWrappers.get(this.itemToDelete)};
			updateView();

			//remove record from wrapper class
			this.riskWrappers.remove(this.itemToDelete);

			//populate riskWrappers by new values (set new index for records)
			reloadWrappers();

			//reload by new values
			this.selectedActionOwnersToRisk = null;

			//hide popup
			this.displayPopUp = false; 

			updateToolUsageTraking();
		} catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));

        } 
	}

	public void reloadWrappers() {
		//store old values
		List<ToolsWrapper> oldList = this.riskWrappers;
		this.riskWrappers = new List<ToolsWrapper>();

		//populate riskWrappers by new values (set new index for records)
		for (Integer i = 0; i < oldList.size(); i++) {
			ToolsWrapper tw = new ToolsWrapper('Risk__c', oldList.get(i).sObjectItem, i);
			tw.isEditMode = oldList.get(i).isEditMode;
			this.riskWrappers.add(tw);
		}
	}

	public void editActionOwners() {
		this.riskWrappers.get(this.itemToEdit).isEditMode = true;
		this.displaySubmit = true;
	}

	public void closePopup() {
		this.displayPopUp = false;
	}

	public void openPopup() {
		this.displayPopUp = true;
	}

	public void reloadRisks() {
		this.riskWrappers = null;
	}

}