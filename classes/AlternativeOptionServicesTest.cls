@isTest
private class AlternativeOptionServicesTest {
	private static Integer NUMBER_TO_CREATE_PROJECT = 1;
	private static Integer NUMBER_TO_CREATE_CRITERIA = 1;
	private static Integer NUMBER_TO_CREATE_ALTERNATIVE_OPTION = 1;

	private static List<Project__c> testProjectList;
	private static List<Alternative_Option__c> testAlternativeOptionList;
	private static List<Criteria__c> testCriteriaList;

	private static void prepareDataForTest(Boolean doCreateCriteria, Boolean doCreateAlternativeOption){
		testProjectList = TestingUtils.createProjectList(NUMBER_TO_CREATE_PROJECT, true);
		if (doCreateCriteria) testCriteriaList = TestingUtils.createCriteriaList(NUMBER_TO_CREATE_PROJECT, testProjectList[0].Id, 5, doCreateCriteria);
		testAlternativeOptionList = TestingUtils.createAlternativeOptionList(NUMBER_TO_CREATE_PROJECT, testProjectList[0].Id, doCreateAlternativeOption);
	}

	private static testMethod void testCreateVotes() {
		//create Project with Criteria, init Alternative Option
		prepareDataForTest(true, true);

		List<Participant_Vote__c> votes = [SELECT Id FROM Participant_Vote__c];
		delete votes;

		Test.startTest();

			AlternativeOptionServices.createVotes( new Map<Id, Alternative_Option__c>(testAlternativeOptionList) );

		Test.stopTest();

		List<Participant_Vote__c> votesResult = [SELECT Id,  Criteria__c, Alternative_Option__c
												 FROM Participant_Vote__c];

		System.assert (!votesResult.isEmpty(), 'Participant_Vote__c should be created');
		System.assertEquals (votesResult.size(), NUMBER_TO_CREATE_CRITERIA * NUMBER_TO_CREATE_ALTERNATIVE_OPTION, 'Incorrect Participant_Vote__c records are created');
	}

	private static testMethod void testCreateVotesWithoutCriteria() {
		//create Project with Criteria, init Alternative Option
		prepareDataForTest(false, true);

		List<Participant_Vote__c> votes = [SELECT Id FROM Participant_Vote__c];
		delete votes;

		Test.startTest();

			AlternativeOptionServices.createVotes( new Map<Id, Alternative_Option__c>(testAlternativeOptionList) );

		Test.stopTest();

		List<Participant_Vote__c> votesResult = [SELECT Id,  Criteria__c, Alternative_Option__c
												 FROM Participant_Vote__c];

		System.assert (votesResult.isEmpty(), 'Participant_Vote__c should not be created');
	}

	private static testMethod void testGroupAlternativesByProjectId() {
		//create Project with Criteria, init Alternative Option
		prepareDataForTest(true, true);

		 Map<Id, List<Alternative_Option__c>> testResult;

		Test.startTest();

			testResult = AlternativeOptionServices.groupAlternativesByProjectId( new Map<Id, Criteria__c>(testCriteriaList).keySet() );

		Test.stopTest();

		System.assert(testResult != null, 'Result can not be null value');
		System.assert(!testResult.isEmpty(), 'Result can not be empty');
		System.assertEquals(testResult.size(), 1, 'Result size is incorrect');
		System.assert(testResult.containsKey(testProjectList[0].Id), 'Result is incorrect');
		System.assertEquals(testResult.get(testProjectList[0].Id).size(), testAlternativeOptionList.size(), 'Result contains incorrect Alternative_Option__c records numbers');
		System.assertEquals(new Map<Id, Alternative_Option__c>(testResult.get(testProjectList[0].Id)).keySet(), new Map<Id, Alternative_Option__c>(testAlternativeOptionList).keySet(), 'Result contains incorrect Alternative_Option__c records');
	}

	private static testMethod void testGetAlternativesByProjectId() {
		//create Project with Criteria, init Alternative Option
		prepareDataForTest(false, true);

		List<Alternative_Option__c> testResult;

		Test.startTest();

			testResult = AlternativeOptionServices.getAlternativesByProjectId( testProjectList[0].Id );

		Test.stopTest();

		System.assert(testResult != null, 'Result can not be null value');
		System.assert(!testResult.isEmpty(), 'Result can not be empty');
		System.assertEquals(new Map<Id, Alternative_Option__c>(testResult).keySet(), new Map<Id, Alternative_Option__c>(testAlternativeOptionList).keySet(), 'Incorrect Alternative_Option__c records Result');
	}
}