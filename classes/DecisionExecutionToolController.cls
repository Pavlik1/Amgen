public with sharing class DecisionExecutionToolController extends CommonToolsController{
	//private final Id projectId;
	public Integer taskToDelete {get; set;}
    Public String retURL {get; set;}

/*
	public Project__c project {
		get {
			if (null == this.project) {
				this.project = ProjectServices.getProjectById(this.projectId);
			} 
			return this.project;
		}
		set;
	}

    public void openPageAction(){
        if ( this.activityTracking != null && this.activityTracking.Project__c != null){
            insert this.activityTracking;
        }
    }

    private User_Activity_Tracking__c activityTracking{
        get{
            if( this.activityTracking == null ){

                this.activityTracking = UserActivityTrackingServices.createActivityTracking( this.projectId == null ? ApexPages.currentPage().getParameters().get('id') : this.projectId,
                                                                                             Constants.DECISION_EXECUTION_TOOL, Constants.USER_ACTIVITY_TRACKING_VIEW, '', '', '' );
            }

            if (this.activityTracking.Project__c == null){
                this.activityTracking.Project__c = this.projectId;
            }

            return this.activityTracking;
        }
        set;
    }
*/

    public String currentToolName(){ return Constants.DECISION_EXECUTION_TOOL; }
    public void populateExistingWrappers(){
        this.allUpdatedWrappers = new List<ToolsWrapper>();
        this.allUpdatedWrappers.addAll(this.taskWrappers);
    }

    private Tool_Usage_Tracking__c toolUsageTraking{
        get{
            if (this.toolUsageTraking == null){
                this.toolUsageTraking = new Tool_Usage_Tracking__c(AreasAffected__c = 0,
                                                                   Project__c = this.projectId,
                                                                   Date__c = Date.today(),
                                                                   Tool__c = Constants.DECISION_EXECUTION_TOOL );
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

	public List<ToolsWrapper> taskWrappers {
		get {
			if (null == this.taskWrappers) {
				this.taskWrappers = new List<ToolsWrapper>();

				List<Task> projectTasks = TaskServices.getTasksByWhatId(this.projectId);

				for (Integer i = 0; i < projectTasks.size(); i++) {
					this.taskWrappers.add(new ToolsWrapper('Task', projectTasks.get(i), i));
				}
			}
			return this.taskWrappers;
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

	public Boolean displayAddActivity {
		get{
			if (null == this.displayAddActivity) {
				this.displayAddActivity = true;
			}
			return this.displayAddActivity;
		}
		set;
	}

	public DecisionExecutionToolController() {
		this.projectId = ApexPages.currentPage().getParameters().get('id');
        this.retURL    = ApexPages.currentPage().getParameters().get('retURL');

	}

	public PageReference goBack(){
        return String.isBlank(this.retURL) ? new PageReference('/'+this.project.Id) : new PageReference(this.retURL);
	}

	public void deleteTask() {
		try {
			//get record for deleting
			sObject itemToDelete = this.taskWrappers.get(this.taskToDelete).sObjectItem;

			//delete existing record 
			if (null != itemToDelete.Id) {
				delete itemToDelete;
			//show Add New Activity button if user delete unsaved record
			} else {
				this.displayAddActivity = true;
			}

            this.allDeletedWrappers = new List<ToolsWrapper>{this.taskWrappers.get(this.taskToDelete)};
            super.updateView();

			//remove record from wrapper class
			this.taskWrappers.remove(this.taskToDelete);

			//populate taskWrappers by new values (set new index for records)
			reloadTaskWrappers();

			//hide popup
			this.displayPopUp = false; 

			updateToolUsageTraking();
		} catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));

        } 
	}

	public void reloadTaskWrappers() {
		//store old values
		List<ToolsWrapper> oldList = this.taskWrappers;
		this.taskWrappers = new List<ToolsWrapper>();

		//populate taskWrappers by new values (set new index for records)
		for (Integer i = 0; i < oldList.size(); i++) {
			this.taskWrappers.add(new ToolsWrapper('Task', oldList.get(i).sObjectItem, i));
		}
	}

	public void saveAndNew(){
		submit();
		addTask();
	}

	public void addTask() {
		ToolsWrapper taskWrapper = new ToolsWrapper('Task', new Task(WhatId = this.projectId, OwnerId = UserInfo.getUserId()), this.taskWrappers.size());
		this.taskWrappers.add(taskWrapper);

		//hide Add New Activity button if user creates new record
		this.displayAddActivity = false;
	}

	public void submit() {
		try { 
			//get all records from wrapper class
			List<Task> projectTasks = new List<Task>();
			for (ToolsWrapper tw : this.taskWrappers) {
				projectTasks.add((Task)tw.sObjectItem);
			}

			//upsert records
			upsert projectTasks;

            populateExistingWrappers();
            super.updateView();

			//populate taskWrappers by new values
			this.taskWrappers = null;
			//show Add New Activity button when oll changes are saved
			this.displayAddActivity = true;

			//start Check Items Workflow
            WorkflowServices.checkItemWorkflow(Constants.DECISION_EXECUTION_TOOL, this.project.Id); 

			updateToolUsageTraking();
		} catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));

        } 
	}

	public void closePopup() {
		this.displayPopUp = false;
	}
	public void openPopup() {
		this.displayPopUp = true;
	}

}