public with sharing class MyProjectsController {
	public Id selectedProjectId {get;set;}
	public String selectedSubPhase {get;set;}

	public Map<Id, Boolean> projId2IsSubPhaseChecked {
		get {
			if (null == this.projId2IsSubPhaseChecked) {
				this.projId2IsSubPhaseChecked = new Map<Id, Boolean>();

				for (Project__c p : this.projects2Ids.values()) {
					if (!this.projId2IsSubPhaseChecked.containsKey(p.Id)) {
						this.projId2IsSubPhaseChecked.put(p.Id, false);
					}
				}
			}
			return this.projId2IsSubPhaseChecked;
		}
		set;
	}

    public Boolean showAllProjects{
        get{
            if (showAllProjects == null){
                showAllProjects = false;
            }
            return showAllProjects;
        }
        set;
    }

    public void showAllProjectsAction(){
        projects2Ids             = null;
        projectId2RoleIcons      = null;
        projectName              = null;
        filterBy                 = null;
        selectedFilter           = null;
        filterRisk               = null;
        projId2SubPhase2Items    = null;
        projId2IsSubPhaseChecked = null;
    }

    public Map<Id, Project__c> projects2Ids{
        get{
            if(null == this.projects2Ids){
                this.projects2Ids = ProjectServices.getProjectsByUserAndName(UserInfo.getUserId(), this.projectName, showAllProjects);
            }
            return this.projects2Ids;
        }
        set;
    }

    public Map<Id, Set<String>> projectId2RoleIcons {
    	get {
    		if (null == this.projectId2RoleIcons) {
    			this.projectId2RoleIcons = new Map<Id, Set<String>>();

    			Id userId = UserInfo.getUserId();

    			for (Project__c p : this.projects2Ids.values()) {
    				if (!this.projectId2RoleIcons.containsKey(p.Id)) {
    					this.projectId2RoleIcons.put(p.Id, new Set<String>());
    				}

    				if (p.Sponsor__c == userId) {
    					this.projectId2RoleIcons.get(p.Id).add(Constants.ICON_S);
    				}

    				if (p.Decision_Maker__c == userId) {
    					this.projectId2RoleIcons.get(p.Id).add(Constants.ICON_D);
    				}

    				for (Team_Role__c tr : p.Team_Roles__r) {
    					if (tr.User__c == userId) {
    						this.projectId2RoleIcons.get(p.Id).add(Constants.ICON_A);
    					}
    				}
    			}
    		}

    		return this.projectId2RoleIcons;
    	}
    	set;
    }

    public String projectName {
    	get {
    		if (null == this.projectName) {
    			this.projectName = '';
    		}
    		return this.projectName;
    	}
    	set;
    }

    public String filterBy {
    	get {
    		if (null == this.filterBy) {
    			this.filterBy = '';
    		}
    		return this.filterBy;
    	}
    	set;
    }

    public String selectedFilter {
    	get {
    		if (null == this.selectedFilter) {
    			this.selectedFilter = '';
    		}
    		return this.selectedFilter;
    	}
    	set;
    }

    public List<SelectOption> filters {
        get{
            if (null == this.filters) {
                this.filters = new List<SelectOption>();

                this.filters.add(new SelectOption('', Constants.NONE));
                this.filters.add(new SelectOption(Constants.SPONSOR,         Constants.SPONSOR));
                this.filters.add(new SelectOption(Constants.DECISION_MAKER,  Constants.DECISION_MAKER));
                this.filters.add(new SelectOption(Constants.RISK_LEVEL,      Constants.RISK_LEVEL));
                this.filters.add(new SelectOption(Constants.DECISION_IMPACT, Constants.DECISION_IMPACT));

            }
            return this.filters;
        }
        set;
    }

    public List<SelectOption> filterByUser {
        get{
            if (null == this.filterByUser) {
                this.filterByUser = new List<SelectOption>();

                this.filterByUser.add(new SelectOption('', Constants.NONE));

                for (User us : [SELECT Id, Name FROM User]) {
                	 this.filterByUser.add(new SelectOption(us.Id, us.Name));

                }
            }
            return this.filterByUser;
        }
        set;
    }

    public List<SelectOption> filterRisk {
        get{
            if (null == this.filterRisk) {
                this.filterRisk = new List<SelectOption>();

                this.filterRisk.add(new SelectOption('', Constants.NONE));

                Schema.DescribeFieldResult fieldResult = Project__c.Risk_Associated__c.getDescribe();
				List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
				
				for(Schema.PicklistEntry f : ple) {
					this.filterRisk.add(new SelectOption(f.getLabel(), f.getValue()));
				}
            }
            return this.filterRisk;
        }
        set;
    }

    public List<SelectOption> filterByImpact {
        get{
            if (null == this.filterByImpact) {
                this.filterByImpact = new List<SelectOption>();

                this.filterByImpact.add(new SelectOption('', Constants.NONE));

                Schema.DescribeFieldResult fieldResult = Project__c.Decision_impact__c.getDescribe();
				List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
				
				for(Schema.PicklistEntry f : ple) {
					this.filterByImpact.add(new SelectOption(f.getLabel(), f.getValue()));
				}
            }
            return this.filterByImpact;
        }
        set;
    }

    public Map<Id, Map<String, List<Check_List_Item__c>>> projId2SubPhase2Items {
    	get {
    		if (null == this.projId2SubPhase2Items) {
    			this.projId2SubPhase2Items = new Map<Id, Map<String, List<Check_List_Item__c>>>();

    			for (Project__c pr : this.projects2Ids.values()) {
    				if (!this.projId2SubPhase2Items.containsKey(pr.Id)) {
    					this.projId2SubPhase2Items.put(pr.Id, new Map<String, List<Check_List_Item__c>>());

    				}

    				for (Check_List_Item__c chIt : pr.Check_List_Items__r) {
	                    if (!this.projId2SubPhase2Items.get(pr.Id).containsKey(chIt.Subphase__r.Name)) {
	                    	this.projId2SubPhase2Items.get(pr.Id).put(chIt.Subphase__r.Name, new List<Check_List_Item__c>());
	                    }

	                    this.projId2SubPhase2Items.get(pr.Id).get(chIt.Subphase__r.Name).add(chIt);
	                }
    				
    			}
    		}
    		return this.projId2SubPhase2Items;
    	}
    	set;
    }

    public MyProjectsController() {
    }

    public void searchByName() {
    	this.projects2Ids = null;
    }

    public void clearFilter() {
        this.projectName  = '';
        this.projects2Ids = null;
    }

    public void filterBy() {
    	this.projects2Ids = null;
    	
    	if (String.isBlank(this.filterBy) || String.isBlank(this.selectedFilter)) {
    		return;
    	}

    	
    	Map<Id, Project__c> allProjects = this.projects2Ids;
    	this.projects2Ids = new Map<Id, Project__c>();

    	for (Project__c p : allProjects.values()) {
    		if ((this.selectedFilter == Constants.SPONSOR && p.Sponsor__c == this.filterBy)               || 
    			(this.selectedFilter == Constants.DECISION_MAKER && p.Decision_Maker__c == this.filterBy) ||
    			(this.selectedFilter == Constants.RISK_LEVEL && p.Risk_Associated__c == this.filterBy)    ||
    			(this.selectedFilter == Constants.DECISION_IMPACT && p.Decision_impact__c == this.filterBy)) {

    			this.projects2Ids.put(p.Id, p);
    		}
    	}
    }

    public void selectSubPhase() {
    	if (this.projects2Ids.get(this.selectedProjectId).Sub_Phases__c == this.selectedSubPhase && this.projId2IsSubPhaseChecked.get(this.selectedProjectId)) {
    		this.projId2IsSubPhaseChecked.put(this.selectedProjectId, false);

    	} else {
    		this.projects2Ids.get(this.selectedProjectId).Sub_Phases__c = this.selectedSubPhase;
    		this.projId2IsSubPhaseChecked.put(this.selectedProjectId, true);
    	}
    }
}