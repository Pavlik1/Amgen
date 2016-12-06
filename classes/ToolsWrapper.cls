public with sharing class ToolsWrapper{
    public sObject sObjectItem {
        get;
        set;
    }

    public sObject sObjectItemStart {
        get;
        set;
    }

    public String objectName {
        get;
        set;
    }

    public Integer getChangedValues{
        get{
            if (this.sObjectItem != this.sObjectItemStart){
//                this.sObjectItemStart = this.sObjectItem.clone(true, true, true, true);
                return 1;
            }
            return 0;
        }
    }

    public List<User_Activity_Tracking__c> userActivityTrackings{
        get{
            List<User_Activity_Tracking__c> userTrackingList = new List<User_Activity_Tracking__c>();

            if (this.sObjectItem != this.sObjectItemStart){

                String currentRecordId = this.sObjectItem != null && this.sObjectItem.get('Id') != null
                                                        ? String.valueOf( this.sObjectItem.get('Id') )
                                                        : this.sObjectItemStart != null && this.sObjectItemStart.get('Id') != null ? String.valueOf( this.sObjectItemStart.get('Id') ) : null;

                if (this.sObjectItem.get('Id') != this.sObjectItemStart.get('Id')){
                    Map<String, String> identMap = new Map<String, String> {'Decision_Due_Date__c' => 'Milestones_Deliverables__c', 'Task' => 'Impacted_Functions__c', 'Team_Role__c' => 'User__c',
                                                                            'Risk__c' => 'Name', 'Business_Result__c' => 'Name','Funding_Role__c' => 'User__c'};

                    String mainField = !identMap.containsKey( objectName ) ? 'Id' : identMap.get(objectName);

                    if (objectName == 'Task'){
                        mainField = this.sObjectItem.get('Impacted_Functions__c') != null ? 'Impacted_Functions__c' : this.sObjectItem.get('Title__c') != null ? 'Title__c' : 'Id';
                    }

                    User_Activity_Tracking__c uat = UserActivityTrackingServices.createActivityTracking( null, '',
                                                                                                         Constants.USER_ACTIVITY_TRACKING_UPDATE,
                                                                                                         objectName + '.' + mainField,
                                                                                                         this.sObjectItem.get('Id') == null ? null : String.valueOf( this.sObjectItem.get( mainField ) ),
                                                                                                         String.valueOf( this.sObjectItemStart.get( mainField ) ) );

                    uat.Chield_Record_Id__c = currentRecordId;
                    userTrackingList.add( uat );

                } else {

                    for (String field : new Set<String>{'Id', 'Name','Role__c','User__c','Date__c','Milestones_Deliverables__c',
                                                        'Title_Responsibility__c','Impacted_Functions__c','Description__c',
                                                        'Risk_Type__c','Impact__c','Likelihood__c','Actions__c','Risk_Owners__r',
                                                        'Actions__c','Impacted_Functions__c','Title__c','Description','Subject','ActivityDate','Result__c'}){

                        try{
                            if (this.sObjectItemStart.get(field) != this.sObjectItem.get(field)){
                                User_Activity_Tracking__c uat = UserActivityTrackingServices.createActivityTracking( null, '',
                                                                                                                     Constants.USER_ACTIVITY_TRACKING_UPDATE,
                                                                                                                     objectName + '.' + field,
                                                                                                                     String.valueOf( this.sObjectItem.get(field) ),
                                                                                                                     String.valueOf( this.sObjectItemStart.get(field) ) );
                                uat.Chield_Record_Id__c = currentRecordId;
                                userTrackingList.add( uat );
                            }
                        }catch (Exception ex) {}

                    }

                }

                this.sObjectItemStart = this.sObjectItem.clone(true, true, true, true);

            }

            return userTrackingList;
        }
    }

    public Integer index {
        get;
        set;
    }

    public Boolean isEditMode {
        get {
            if (null == this.isEditMode) {
                this.isEditMode = false;
            }
            return this.isEditMode;
        }
        set;
    }

    public String additionalInfo {
        get {
            if (null == this.additionalInfo) {
                this.additionalInfo = '';
            }
            return this.additionalInfo;
        }
        set;
    }

    public ToolsWrapper(String objectName, sObject sObjectItem, Integer index) {
        this.sObjectItem      = sObjectItem;
        if (sObjectItem != null) this.sObjectItemStart = sObjectItem.clone(true, true, true, true);
        this.objectName       = objectName;
        this.index            = index;
    }

    public ToolsWrapper(String objectName, sObject sObjectItem, Integer index, String additionalInfo) {
        this.sObjectItem      = sObjectItem;
        if (sObjectItem != null) this.sObjectItemStart = sObjectItem.clone(true, true, true, true);
        this.objectName       = objectName;
        this.index            = index;
        this.additionalInfo   = additionalInfo;
    }

    public ToolsWrapper(sObject sObjectItem, Integer index) {
        this.sObjectItem      = sObjectItem;
        if (sObjectItem != null) this.sObjectItemStart = sObjectItem.clone(true, true, true, true);
        this.index            = index;
    }

    public ToolsWrapper(sObject sObjectItem, Integer index, String additionalInfo) {
        this.sObjectItem      = sObjectItem;
        if (sObjectItem != null) this.sObjectItemStart = sObjectItem.clone(true, true, true, true);
        this.index            = index;
        this.additionalInfo   = additionalInfo;
    }
}