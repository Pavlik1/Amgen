@isTest
private class CheckListItemServicesTest {
	private static Integer NUMBER_TO_CREATE_PROJECT = 1;
	private static Integer NUMBER_TO_CREATE_CLI = 2;

	private Static List<Project__c> testProjectList;
	private Static List<Check_List_Item__c> testCheckListItemMasterRecordList;
	private Static List<Check_List_Item__c> testCheckListItemProjectInstanceList;

	private static Id cliMasterRecordType;
	private static Id cliProjectInstanceType;

	private static void prepareRecordTypes(){
		for (RecordType item : [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Check_List_Item__c']){
			if (item.Name == Constants.CLI_RECORDTYPE_MASTER_RECORD){
				cliMasterRecordType = item.Id;
			} else if(item.Name == Constants.CLI_RECORDTYPE_PROJECT_INSTANCE){
				cliProjectInstanceType = item.Id;
			}
		}
	}

	private static void prepareCLIMasterRecords(){
		if (cliMasterRecordType == null){
			prepareRecordTypes();
		}
		testCheckListItemMasterRecordList = TestingUtils.createCheckListItemList(NUMBER_TO_CREATE_CLI, null, cliMasterRecordType, true);
	}

	private static void prepareDataForTest(Boolean doCreateCliMasters, Boolean doCreateProject){
		if (doCreateCliMasters){
			prepareCLIMasterRecords();
		}
		testProjectList = TestingUtils.createProjectList(NUMBER_TO_CREATE_PROJECT, doCreateProject);
	}

	private static testMethod void testInitCheckListItemsForProject(){
		prepareDataForTest(false, true);
		prepareCLIMasterRecords();

		List<Check_List_Item__c> cliList = [SELECT Id, Project__c
											FROM Check_List_Item__c
											WHERE Project__c IN : testProjectList AND
												RecordType.Name =: Constants.CLI_RECORDTYPE_PROJECT_INSTANCE];

		delete cliList;

		Test.startTest();

			CheckListItemServices.initCheckListItemsForProject(testProjectList);

		Test.stopTest();

		List<Check_List_Item__c> testResult = [SELECT Id, Project__c
											   FROM Check_List_Item__c
											   WHERE Project__c IN : testProjectList AND
													RecordType.Name =: Constants.CLI_RECORDTYPE_PROJECT_INSTANCE];

		System.assert(!testResult.isEmpty(), 'Check_List_Item__c for Project__c (s) should be created');
		System.assertEquals(testResult.size(), NUMBER_TO_CREATE_CLI * NUMBER_TO_CREATE_PROJECT, 'Incorrect Check_List_Item__c count are creted' + testResult);

		for (Project__c project : [SELECT Id, (Select Id From Check_List_Items__r)
								   FROM Project__c
								   WHERE Id IN : testProjectList]){
			System.assert(!project.Check_List_Items__r.isEmpty(), 'Check_List_Item__c for Project__c should be created');
			System.assertEquals(project.Check_List_Items__r.size(), NUMBER_TO_CREATE_CLI, 'Incorrect Check_List_Item__c count are creted');
		}
	}

	private static testMethod void testInitCheckListItemsForProjectWithError(){
		prepareDataForTest(false, true);
		prepareCLIMasterRecords();

		delete testProjectList;

		Test.startTest();

			CheckListItemServices.initCheckListItemsForProject(testProjectList);

		Test.stopTest();

		List<Check_List_Item__c> testResult = [SELECT Id, Project__c
											   FROM Check_List_Item__c
											   WHERE Project__c IN : testProjectList AND
													RecordType.Name =: Constants.CLI_RECORDTYPE_PROJECT_INSTANCE];

		System.assert(testResult.isEmpty(), 'Check_List_Item__c for Project__c (s) should not be created');
	}
}