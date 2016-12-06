public with sharing class ProjectCheckListController extends CommonToolsController {
	public Project__c currentProject {get; set;}

    private Map<String, String> subPhasesMap {get; set;}

    public void populateExistingWrappers(){}

    public String currentToolName(){
        return Constants.PROJECT_VIEW_TOOL;
    }

    public override void updateView(){
        if ( this.activityTracking != null && this.activityTracking.View_Update__c == Constants.USER_ACTIVITY_TRACKING_VIEW){
            this.activityTracking.View_Update__c = Constants.USER_ACTIVITY_TRACKING_UPDATE;
            upsert this.activityTracking;
        }

        List<User_Activity_Tracking__c> userTrackingList = new List<User_Activity_Tracking__c>();
        for (Check_List_Item__c cli : this.itemsList){
            if (cli.Checked__c != oldItemsMap.get(cli.Id).Checked__c){
                User_Activity_Tracking__c uat = UserActivityTrackingServices.createActivityTracking( this.currentProject.Id, Constants.PROJECT_VIEW_TOOL,
                                                                                                     Constants.USER_ACTIVITY_TRACKING_UPDATE,
                                                                                                     'Check_List_Item__c.Checked__c',
                                                                                                     String.valueOf( cli.Checked__c ),
                                                                                                     String.valueOf( oldItemsMap.get(cli.Id).Checked__c ) );
                uat.Chield_Record_Id__c = String.valueOf( cli.Id );
                userTrackingList.add(uat);
            }
        }

        if ( this.activityTracking != null && !userTrackingList.isEmpty() ){
            userTrackingList[0].Id = this.activityTracking.Id;
            this.activityTracking = null;
        }

        upsert userTrackingList;
        this.oldItemsMap = new  Map<Id, Check_List_Item__c>(this.itemsList.deepClone(true, true, true));
    }

    public Map<String, List<Check_List_Item__c>> subphaseNameToItem{
        get {
            if (null == this.subphaseNameToItem) {
                this.subphaseNameToItem = new Map<String, List<Check_List_Item__c>>();

                for (Check_List_Item__c chIt : currentProject.Check_List_Items__r) {
                    if (!this.subphaseNameToItem.containsKey(chIt.Subphase__r.Name)) {
                        this.subphaseNameToItem.put(chIt.Subphase__r.Name, new List<Check_List_Item__c>());
                    }

                    this.subphaseNameToItem.get(chIt.Subphase__r.Name).add(chIt);
                }
            }
            return this.subphaseNameToItem;
        }
        set;
    }

    private Map<Id, Check_List_Item__c> oldItemsMap{get;set;}

    public List<Check_List_Item__c> itemsList {
        get{
            if (null == this.itemsList) {
                this.itemsList = new List<Check_List_Item__c>();

                for(Check_List_Item__c clItem : subphaseNameToItem.get(currentProject.Sub_Phases__c)){
                    itemsList.add(clItem);
                }

                this.oldItemsMap = new  Map<Id, Check_List_Item__c>(this.itemsList.deepClone(true, true, true));
            }

            return this.itemsList;
        }
        set;
    }

    public ProjectCheckListController(ApexPages.StandardController stdController) {
        String s = String.valueOf(ApexPages.currentPage().getUrl());
        System.debug(LoggingLevel.ERROR, '^^^ s = ' + s);


        this.currentProject = ProjectServices.getProjectWithCheckItemsById(stdController.getRecord().Id);
        Cookie testCookie = ApexPages.currentPage().getCookies().get('testCookie');
        System.debug(LoggingLevel.ERROR, '^^^ testCookie(all) = ' +  ApexPages.currentPage().getCookies());
        System.debug(LoggingLevel.ERROR, '^^^ testCookie = ' + testCookie);

        String getparameter = ApexPages.currentPage().getParameters().get('testParam');
        System.debug(LoggingLevel.ERROR, '^^^ getparameter = ' + getparameter);
    }

    public void submit() {
        updateView();
        update this.itemsList;

    }

    public void reloaditemsList() {
        this.itemsList = null;

    }
}