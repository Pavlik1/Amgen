@isTest
private class CriteriaTriggerTest {
	private static Integer NUMBER_TO_CREATE_PROJECT = 1;
	private static Integer NUMBER_TO_CREATE_CRITERIA = 1;
	private static Integer NUMBER_TO_CREATE_ALTERNATIVE_OPTION = 1;

	private static List<Project__c> testProjectList;
	private static List<Alternative_Option__c> testAlternativeOptionList;
	private static List<Criteria__c> testCriteriaList;

	private static void prepareDataForTest(Boolean doCreateCriteria, Boolean doCreateAlternativeOption){
		testProjectList = TestingUtils.createProjectList(NUMBER_TO_CREATE_PROJECT, true);
		if (doCreateAlternativeOption) testAlternativeOptionList = TestingUtils.createAlternativeOptionList(NUMBER_TO_CREATE_PROJECT, testProjectList[0].Id, doCreateAlternativeOption);
		testCriteriaList = TestingUtils.createCriteriaList(NUMBER_TO_CREATE_PROJECT, testProjectList[0].Id, 5, doCreateCriteria);
	}

	private static testMethod void testCreateVotes() {
		//create Project with Alternative Option, init Criteria
		prepareDataForTest(false, true);

		List<Participant_Vote__c> votes = [SELECT Id FROM Participant_Vote__c];
		delete votes;

		Test.startTest();

			insert testCriteriaList;

		Test.stopTest();

		List<Participant_Vote__c> votesResult = [SELECT Id,  Criteria__c, Alternative_Option__c
												 FROM Participant_Vote__c];

		System.assert (!votesResult.isEmpty(), 'Participant_Vote__c should be created');
		System.assertEquals (votesResult.size(), NUMBER_TO_CREATE_CRITERIA * NUMBER_TO_CREATE_ALTERNATIVE_OPTION, 'Incorrect Participant_Vote__c records are created');
	}
}