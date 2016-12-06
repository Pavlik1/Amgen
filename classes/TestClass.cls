@isTest
private class TestClass{
    private static void createAccounts(){
        List<Account> accountList = new List<Account>();
        
        List<sObject> sobjList = Test.loadData(Account.sObjectType, 'testAccounts');
    }
/*

    private static testMethod void testCreateAccountByName(){
        List<Account> accountList = [SELECT Id FROM Account];
        System.assert(accountList.isEmpty());

        Test.startTest();
            TestUtils.getsObjectListByName(1, null, 'Account', true);
        Test.stopTest();

        accountList = [SELECT Id FROM Account];
        System.assert(!accountList.isEmpty());
    }
*/

    private static testMethod void testCreateAccountFromStaticResource(){
        List<Account> accountList = [SELECT Id FROM Account];
        System.assert(accountList.isEmpty());

        Test.startTest();
            TestUtils.createAccountsFromStaticResource();
        Test.stopTest();
        
        accountList = [SELECT Id FROM Account];
        System.assert(!accountList.isEmpty());
    }

    private static testMethod void testCreateAccount(){
        List<Account> accountList = [SELECT Id FROM Account];
        System.assert(accountList.isEmpty());

        SObject account;

        Test.startTest();
            account = TestUtils.createAccount();
            insert account;
        Test.stopTest();
        
        accountList = [SELECT Id FROM Account];
        System.assert(!accountList.isEmpty());
    }

    private static testMethod void testCreateAccountWithParameter(){
        List<Account> accountList = [SELECT Id FROM Account];
        System.assert(accountList.isEmpty());

        SObject account;

        Test.startTest();
            account = TestUtils.createAccount( new Map<String, Object>{'xrospackages__TestRequiredField__c'=>'test method'} );
            insert account;
        Test.stopTest();
        
        accountList = [SELECT Id FROM Account];
        System.assert(!accountList.isEmpty());
    }

    private static testMethod void testCreateContact(){
        List<Contact> checkList = [SELECT Id FROM Contact];
        System.assert(checkList.isEmpty());

        SObject contact;

        Test.startTest();
            contact = TestUtils.createContact();
            insert contact;
        Test.stopTest();
        
        checkList = [SELECT Id FROM Contact];
        System.assert(!checkList.isEmpty());
    }

    private static testMethod void testCreateOpportunity(){
        List<Opportunity> checkList = [SELECT Id FROM Opportunity];
        System.assert(checkList.isEmpty());

        SObject opportunity;

        Test.startTest();
            opportunity = TestUtils.createOpportunity();
            insert opportunity;
        Test.stopTest();

        checkList = [SELECT Id FROM Opportunity];
        System.assert(!checkList.isEmpty());
    }

    private static testMethod void testCreateCase(){
        List<Case> checkList = [SELECT Id FROM Case];
        System.assert(checkList.isEmpty());

        SObject caseRecord;

        Test.startTest();
            caseRecord = TestUtils.createCase();
            insert caseRecord;
        Test.stopTest();

        checkList = [SELECT Id FROM Case];
        System.assert(!checkList.isEmpty());
    }

    private static testMethod void testCreateUser(){
        List<User> checkList = [SELECT Id FROM User];
        Integer i = checkList.size();
//        System.assert(checkList.isEmpty());

        SObject user;

        Test.startTest();
            user = TestUtils.createUser();
            insert user;
        Test.stopTest();

        checkList = [SELECT Id FROM User];
        System.assertEquals(i + 1, checkList.size());
    }

    private static testMethod void testCreateLead(){
        List<Lead> checkList = [SELECT Id FROM Lead];
        System.assert(checkList.isEmpty());

        SObject lead;

        Test.startTest();
            lead = TestUtils.createLead();
            insert lead;
        Test.stopTest();

        checkList = [SELECT Id FROM Lead];
        System.assert(!checkList.isEmpty());
    }

    private static testMethod void testCreateSObjectAccountRecords(){
        List<Account> accountList = [SELECT Id FROM Account];
        System.assert(accountList.isEmpty());

        List<SObject> accounts;

        Test.startTest();
            accounts = TestUtils.createSObjectRecords(10, 'AcCount', false);
            insert accounts;
        Test.stopTest();
        
        accountList = [SELECT Id FROM Account];
        System.assert(!accountList.isEmpty());
        System.assertEquals(10, accountList.size());
    }

    private static testMethod void testCreateSObjectWithIncorrectName(){
        List<Account> accountList = [SELECT Id FROM Account];
        System.assert(accountList.isEmpty());

        List<SObject> accounts;

        Test.startTest();
            accounts = TestUtils.createSObjectRecords(10, 'Ac_Count', false);
            insert accounts;
        Test.stopTest();
        
        accountList = [SELECT Id FROM Account];
        System.assert(!accountList.isEmpty());
        System.assertEquals(10, accountList.size());
    }

    private static testMethod void testCreateCustomSObjectRecords(){
        List<User> checkList = [SELECT Id FROM User];
        Integer i = checkList.size();
//        System.assert(checkList.isEmpty());

        User user = (User)TestUtils.createUser();
        user.ProfileId = '00e58000000rRNv';
        insert user;

        checkList = [SELECT Id FROM User];
        System.assertEquals(i + 1, checkList.size());



        List<xrospackages__TestSObjectForTest__c> testRecordsList = [SELECT Id FROM xrospackages__TestSObjectForTest__c];
        System.assert(testRecordsList.isEmpty());

        List<SObject> result;

        Test.startTest();
            System.runAs(user){
                TestUtils.avoidSObjectPermissions = true;
                result = TestUtils.createSObjectRecords(1, new Map<String, Object>{'xrospackages__TestRequiredField__c'=>'test method'}, 'xrospackages__TestSObjectForTest__c', false);
//                insert result;
                TestUtils.avoidSObjectPermissions = false;
                result = TestUtils.createSObjectRecords(1, new Map<String, Object>{'xrospackages__TestRequiredField__c'=>'test method'}, 'xrospackages__TestSObjectForTest__c', false);
            }
        Test.stopTest();


//        TestUtils.createWithoutRequiredReference = true;

        result = TestUtils.createSObjectRecords(1, 'xrospackages__TestSObjectForTest__c', false);

//        List<SObject> accounts = TestUtils.createSObjectRecords(1, 'Account', true);

//        result = TestUtils.createSObjectRecords(1, 'xrospackages__TestSObjectForTest__c', false);

//        insert result;
        testRecordsList = [SELECT Id FROM xrospackages__TestSObjectForTest__c];
        System.assert(!testRecordsList.isEmpty());


        
        testRecordsList = [SELECT Id FROM xrospackages__TestSObjectForTest__c];
        System.assert(!testRecordsList.isEmpty());
    }

    private static testMethod void testCreatePortalUser(){
        List<User> checkList = [SELECT Id FROM User];
        Integer i = checkList.size();
//        System.assert(checkList.isEmpty());

        SObject user;

        Test.startTest();
            user = TestUtils.createPortalUser();
//            System.assert(false, 'user = ' + user);
            insert user;
        Test.stopTest();

        checkList = [SELECT Id FROM User];
        System.assertEquals(i + 1, checkList.size());
    }
}