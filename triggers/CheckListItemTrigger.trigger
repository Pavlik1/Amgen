trigger CheckListItemTrigger on Check_List_Item__c (before insert, before update) {
	if (Trigger.isBefore && Trigger.isUpdate){
		CheckListItemServices.checkCchakedItems(Trigger.new, Trigger.oldMap);
	}
}