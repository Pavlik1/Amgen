public with sharing abstract class CommonToolsController {
	public Id projectId{get;set;}

	public virtual void openPageAction(){
		String isFromProject = ApexPages.currentPage().getParameters().get('isfromproject');
		Id activityTrackingId = null;
		Id projectIdFromUrl = this.projectId == null ? ApexPages.currentPage().getParameters().get('id') : this.projectId;


		this.activityTracking = UserActivityTrackingServices.createActivityTracking( projectIdFromUrl,
																					 currentToolName(), Constants.USER_ACTIVITY_TRACKING_VIEW, '', '', '' );


		System.Debug (LoggingLevel.ERROR, '^^^ projectIdFromUrl = ' + projectIdFromUrl);
		System.Debug (LoggingLevel.ERROR, '^^^ projectIdFromUrl == null = ' + (projectIdFromUrl == null));
		if (!String.isEmpty(isFromProject) && isFromProject == 'true' || projectIdFromUrl == null){
			User_Activity_Tracking__c uat = UserActivityTrackingServices.getLastActivityTrackingForCurrentUser(projectIdFromUrl);
			if (uat != null && uat.View_Update__c == Constants.USER_ACTIVITY_TRACKING_VIEW && uat.Tool__c == Constants.PROJECT_VIEW_TOOL){
				this.activityTracking.Id = uat.Id;
			}
		}

		if (this.activityTracking.Project__c != null){
			upsert this.activityTracking;
		}
	}

	abstract String currentToolName();
	abstract void populateExistingWrappers();

	public String toolValue{
		get {
			if (toolValue == null){
				toolValue = Constants.PROJECT_VIEW_TOOL;
			}

			return toolValue;
		}
		set;
	}

	public User_Activity_Tracking__c activityTracking{get;set;}

	public Project__c processedProject{get;set;}
	public List<ToolsWrapper> allUpdatedWrappers{get;set;}
	public List<ToolsWrapper> allCreatedWrappers{get;set;}
	public List<ToolsWrapper> allDeletedWrappers{get;set;}

    public Project__c project {
        get {
            if (null == this.project) {
                this.project = ProjectServices.getProjectById(this.projectId);

                this.processedProject = this.project.clone(true, true, true, true);
            }
            return this.project;
        }
        set;
    }

    public virtual void updateView(){
        if (this.activityTracking != null && this.activityTracking.View_Update__c == Constants.USER_ACTIVITY_TRACKING_VIEW && this.project != null && this.project.Id != null){
            this.activityTracking.View_Update__c = Constants.USER_ACTIVITY_TRACKING_UPDATE;
            if (this.activityTracking.Project__c == null) this.activityTracking.Project__c = this.project.Id;
            upsert this.activityTracking;
        }

        if ( this.project.Id != null ){
			List<User_Activity_Tracking__c> userTrackingList = new List<User_Activity_Tracking__c>();
			if(this.allUpdatedWrappers != null){
		        for (ToolsWrapper item : this.allUpdatedWrappers){
		            userTrackingList.addAll(item.userActivityTrackings);
		        }
		        this.allUpdatedWrappers = null;
		    }

			if(this.allCreatedWrappers != null){
		        for (ToolsWrapper item : this.allCreatedWrappers){
		        	item.sObjectItem.Id = null;
		            userTrackingList.addAll(item.userActivityTrackings);
		        }
		        this.allCreatedWrappers = null;
		    }

			if(this.allDeletedWrappers != null){
		        for (ToolsWrapper item : this.allDeletedWrappers){
		        	item.sObjectItem.Id = null;
		            userTrackingList.addAll(item.userActivityTrackings);
		        }
		        this.allDeletedWrappers = null;
		    }

	        for (User_Activity_Tracking__c item : userTrackingList){
	            item.Project__c = this.project.Id;
	            item.Tool__c    = currentToolName();
	        }

	        if(!userTrackingList.isEmpty() && this.activityTracking != null){
	        	userTrackingList[0].id = this.activityTracking.Id;
	        	this.activityTracking = null;
	        }

	        System.debug(LoggingLevel.ERROR, '^^^ userTrackingList.size() = ' + userTrackingList.size());

	        upsert userTrackingList;
	    }
    }

    public void changesForProject(Set<String> fieldValues){
        if (this.activityTracking != null && this.activityTracking.View_Update__c == Constants.USER_ACTIVITY_TRACKING_VIEW && this.project != null && this.project.Id != null){
            this.activityTracking.View_Update__c = Constants.USER_ACTIVITY_TRACKING_UPDATE;
            if (this.activityTracking.Project__c == null) this.activityTracking.Project__c = this.project.Id;
            upsert this.activityTracking;
        }

        List<User_Activity_Tracking__c> activityTrackingList = new List<User_Activity_Tracking__c>();



        System.debug(LoggingLevel.ERROR, '^^^ this.project = ' + this.project);
        System.debug(LoggingLevel.ERROR, '^^^ this.processedProject = ' + this.processedProject);


        if (this.project != null && this.processedProject != null && this.project.Id != null){
            for (String fieldValue : fieldValues){
                try{
                    if (fieldValue == 'LastModifiedDate' || fieldValue == 'LastModifiedById'){ continue; }
                    System.debug(LoggingLevel.ERROR, '^^^ fieldValue = ' + fieldValue);
                    System.debug(LoggingLevel.ERROR, '^^^ this.project.get(fieldValue) = ' + this.project.get(fieldValue));
                    System.debug(LoggingLevel.ERROR, '^^^ this.processedProject.get(fieldValue) = ' + this.processedProject.get(fieldValue));


                    String newValue = this.project.get( fieldValue ) == null ? '' : String.valueOf( this.project.get( fieldValue ) );
                    String oldValue = this.processedProject.get( fieldValue ) == null ? '' : String.valueOf( this.processedProject.get( fieldValue ) );

                    oldValue = String.isEmpty(oldValue) ? '' : oldValue;
                    oldValue = String.isEmpty(newValue) ? '' : newValue;

			        System.debug(LoggingLevel.ERROR, '^^^ fieldValue res oldValue = ' + oldValue);
			        System.debug(LoggingLevel.ERROR, '^^^ fieldValue res newValue = ' + newValue);

                    if ( newValue != oldValue ){
                        activityTrackingList.add( UserActivityTrackingServices.createActivityTracking( this.project.Id,
                                                                                                       currentToolName(),
                                                                                                       Constants.USER_ACTIVITY_TRACKING_UPDATE,
                                                                                                       fieldValue,
                                                                                                       newValue,
                                                                                                       oldValue ) );
                    }
                } catch (Exception ex){}
            }
        }

        if(!activityTrackingList.isEmpty() && this.activityTracking != null){
        	activityTrackingList[0].id = this.activityTracking.Id;
        	this.activityTracking = null;
        }

        try{
            upsert activityTrackingList;
        } catch (Exception ex){}

        this.processedProject = this.project.clone(true, true, true, true);
    }
}