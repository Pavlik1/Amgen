trigger UserActivityTrackingTrigger on User_Activity_Tracking__c (before insert, before update) {
	if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
		//populate Period Name
		UserActivityTrackingServices.populatePeriodName(Trigger.new);
	}
}