public with sharing class UserActivityTrackingServices {
    public Static Integer DAY_OF_MONTH = 3;

    public static User_Activity_Tracking__c getLastActivityTrackingForCurrentUser(Id projectId){
        List<User_Activity_Tracking__c> activityTrackingList = [SELECT Id, View_Update__c, Project__c, User__c, Tool__c, CreatedDate
                                                                FROM User_Activity_Tracking__c
                                                                WHERE Project__c = : projectId AND
                                                                    User__c = : UserInfo.getUserId()
                                                                    ORDER BY CreatedDate desc LIMIT 1];
        return activityTrackingList.isEmpty() ? null : activityTrackingList[0];
    }

    public static User_Activity_Tracking__c createActivityTracking(Id projectIdVal, String toolName, String viewUpdate, String fieldName, String newValue, String oldValue){
        return new User_Activity_Tracking__c(Activity_Time__c = Datetime.now(),
                                             User__c = UserInfo.getUserId(),
                                             View_Update__c = String.isEmpty(viewUpdate) ? Constants.USER_ACTIVITY_TRACKING_VIEW : viewUpdate,
                                             Tool__c = toolName,
                                             Field_Name__c = String.isEmpty(fieldName) ? '' : fieldName,
                                             New_Value__c = String.isEmpty(newValue) ? '' : newValue,
                                             Old_Value__c = String.isEmpty(oldValue) ? '' : oldValue,
                                             Project__c = projectIdVal);
    }

    public static void populatePeriodName(List<User_Activity_Tracking__c> userActivityTrackingList){
        for (User_Activity_Tracking__c item : userActivityTrackingList != null ? userActivityTrackingList : new List<User_Activity_Tracking__c>()){
            Datetime dt = Datetime.newInstanceGMT(item.Activity_Time__c.year(), item.Activity_Time__c.month(), DAY_OF_MONTH);
            String val = dt.format('MMM') + '-' + dt.format('yy');
            item.Period_Name__c = val;
        }
    }
}