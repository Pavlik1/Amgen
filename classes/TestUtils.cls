public class TestUtils{
    public static String EMAIL_SUFFIX = '@company.com';
    public static String URL_PREFIX   = 'http://www.google.com/';
    public static String ACCAUNT_API_NAME     = 'Account';
    public static String CONTACT_API_NAME     = 'Contact';
    public static String CASE_API_NAME        = 'Case';
    public static String OPPORTUNITY_API_NAME = 'Opportunity';
    public static String USER_API_NAME        = 'User';
    public static String LEAD_API_NAME        = 'Lead';

    public static Boolean avoidSObjectPermissions        = false;
    public static Boolean createWithoutRequiredReference = false;

    private static String USER_LICENSE_CUSTOMER_COMUNITY = '%Customer Community%';
    private static String USER_LICENSE_PORTAL            = '%Portal%';

    private static String ERROR_MASSAGE_OBJECT_DOES_NOT_EXIST = 'Object "{0}" does not exist';
    private static String ERROR_MASSAGE_OBJECT_IS_NOT_ACCESIBLE = 'Object "{0}" is not accesible for current user "{1}" with ProfileId = "{2}"';
    private static String ERROR_MASSAGE_OBJECT_IS_NOT_CREATABLE = 'Object "{0}" is not createable for current user "{1}" with ProfileId = "{2}"';

    private static String ACCOUNTID_FIELD_NAME         = 'AccountId';
    private static String CONTACTID_FIELD_NAME         = 'ContactId';
    private static String PROFILEID_FIELD_NAME         = 'ProfileId';
    private static String USERNAME_FIELD_NAME          = 'UserName';
    private static String TIMEZONESIDKEY_FIELD_NAME    = 'TimeZoneSidKey';
    private static String EMAILENCODINGKEY_FIELD_NAME  = 'EmailEncodingKey';
    private static String LOCALESIDKEY_FIELD_NAME      = 'LocaleSidKey';
    private static String LANGUAGELOCALEKEY_FIELD_NAME = 'LanguageLocaleKey';

    private static Map<String, List<sObject>> existingSObjects;
    private static Map<String, Schema.SObjectType> sObjMap;
    private static Map<String, Map<String, Schema.SObjectField>> sObjMapWithFields;
    private static Map<String, Map<String, DescribeFieldResult>> objectWithFieldDescribe;

    public static List<sObject> createSObjectRecords(Integer numberToCreate, String sObjectName, Boolean doInsert){
        return createSObjectRecords(numberToCreate, new Map<String, Object>(), sObjectName, doInsert);
    }

    public static List<sObject> createSObjectRecords(Integer numberToCreate, Map<String, Object> prepopulatedFieldsWithValues, String sObjectName, Boolean doInsert){
        List<sObject> sObjects = new List<sObject>();
        for(Integer i = 0; i < numberToCreate; i++){
            sObjects.add(  createSObjectRecord( prepopulatedFieldsWithValues, sObjectName ) );
        }

        if ( doInsert ){
            insert sObjects;
        }

        return sObjects;
    }

    public static SObject createAccount(){
        return createSObjectRecord( ACCAUNT_API_NAME );
    }

    public static SObject createAccount(Map<String, Object> prepopulatedFieldsWithValues){

        return createSObjectRecord(prepopulatedFieldsWithValues, ACCAUNT_API_NAME);
    }

    public static SObject createContact(){
        return createSObjectRecord( CONTACT_API_NAME );
    }

    public static SObject createContact(Map<String, Object> prepopulatedFieldsWithValues){
        return createSObjectRecord(prepopulatedFieldsWithValues, CONTACT_API_NAME);
    }

    public static SObject createOpportunity(){
        return createSObjectRecord( OPPORTUNITY_API_NAME );
    }

    public static SObject createCase(){
        return createSObjectRecord( CASE_API_NAME );
    }

    public static SObject createUser(){
        return createSObjectRecord( USER_API_NAME );
    }

    public static SObject createUser(Map<String, Object> prepopulatedFieldsWithValues){
        return createSObjectRecord(prepopulatedFieldsWithValues, USER_API_NAME);
    }

    public static SObject createPortalUser(){
        return createPortalUser( new Map<String, Object>() );
    }

    public static SObject createPortalUser( Map<String, Object> prepopulatedFieldsWithValues ){
        //required fields
        Boolean passContact = true;
        Boolean passProfile = true;
        if ( prepopulatedFieldsWithValues != null ){
            passContact = !prepopulatedFieldsWithValues.containsKey(CONTACTID_FIELD_NAME);
            passProfile = !prepopulatedFieldsWithValues.containsKey(PROFILEID_FIELD_NAME);
        } else {
            prepopulatedFieldsWithValues = new Map<String, Object>();
        }
        if ( passContact ){
            Account account = (Account)createAccount();
            Insert account;
            Contact contact = (Contact)createContact(new Map<String, Object>{ACCOUNTID_FIELD_NAME => account.Id});
            Insert contact;
            prepopulatedFieldsWithValues.put(CONTACTID_FIELD_NAME, contact.Id);
        }
        if ( passProfile ){
            List<Profile> profileList = [SELECT Id
                                         FROM Profile
                                         WHERE UserLicense.Name Like : USER_LICENSE_CUSTOMER_COMUNITY OR
                                               UserLicense.Name Like : USER_LICENSE_PORTAL];
            if ( !profileList.isEmpty() )prepopulatedFieldsWithValues.put(PROFILEID_FIELD_NAME, profileList[0].Id);
        }
        return createSObjectRecord(prepopulatedFieldsWithValues, USER_API_NAME);
    }

    public static SObject createLead(){
        return createSObjectRecord( LEAD_API_NAME );
    }

    public static SObject createSObjectRecord(String sObjectName){
        return createSObjectRecord( new Map<String, Object>(),
                                    sObjectName);
    }

    public static SObject createSObjectRecord( Map<String, Object> prepopulatedFieldsWithValues,
                                               String sObjectName ){
        prepareData();
        if ( !sObjMap.containsKey( sObjectName ) ){
            throw new TestMethodException( String.format('Object "' + sObjectName + '" does not exist', new List<String>{sObjectName}));
        }

        Schema.SObjectType sObjectToken = sObjMap.get( sObjectName );

        if ( !avoidSObjectPermissions ){
            Schema.DescribeSObjectResult dsr = sObjectToken.getDescribe();
            if (!dsr.isAccessible()){
                throw new TestMethodException( String.format(ERROR_MASSAGE_OBJECT_IS_NOT_ACCESIBLE, new List<String>{sObjectName, UserInfo.getName(), UserInfo.getProfileId()}) );
            }
            if (!dsr.isCreateable()){
                throw new TestMethodException( String.format(ERROR_MASSAGE_OBJECT_IS_NOT_CREATABLE, new List<String>{sObjectName, UserInfo.getName(), UserInfo.getProfileId()}) );
            }
        }

        SObject sObjectRecord = sObjectToken.newSObject();
        System.debug('sObjectToken = ' + sObjectToken);
        System.debug('sObjectRecord = ' + sObjectRecord);
        Map<String, Schema.SObjectField> sObjectFieldsMap = fieldDescriptionByObjectName(sObjectName);
        prepopulateFieldsWithValues(prepopulatedFieldsWithValues, sObjectFieldsMap.keySet(), sObjectRecord);
        sObject sObjRec = createSObjectRecordPrivate(sObjectName, sObjectRecord, sObjectFieldsMap);
        addExistingSObjectRecordByObjectName(sObjectName, new List<sObject>{sObjRec});
        return sObjRec;
    }

    private static void prepareData(){
        prepareObjectAndFieldDescription();
        prepareObjectWithExistingRecords();
    }

    private static void prepareObjectAndFieldDescription(){
        if (sObjMap == null){
            sObjMap = Schema.getGlobalDescribe();
        }
    }

    private static DescribeFieldResult getFieldDescibe(String sObjectName, String fieldName){
        if ( objectWithFieldDescribe == null ){
            objectWithFieldDescribe = new Map<String, Map<String, DescribeFieldResult>>();
        }
        if ( !objectWithFieldDescribe.containsKey( sObjectName ) ){
            objectWithFieldDescribe.put( sObjectName.toLowerCase(), new Map<String, DescribeFieldResult>());
        }
        if ( !objectWithFieldDescribe.get( sObjectName.toLowerCase() ).containsKey( fieldName.toLowerCase() ) ){
            objectWithFieldDescribe.get( sObjectName.toLowerCase() ).put( fieldName, fieldDescriptionByObjectName( sObjectName ).get( fieldName ).getDescribe() );
        }
        return objectWithFieldDescribe.get( sObjectName.toLowerCase() ).get( fieldName );
    }

    private static Map<String, Schema.SObjectField> fieldDescriptionByObjectName(String sObjectName){
        if (sObjMapWithFields == null){
            sObjMapWithFields = new Map<String, Map<String, Schema.SObjectField>>();
        }
        if (!sObjMapWithFields.containsKey(sObjectName.toLowerCase())){
            Schema.SObjectType sObjectToken = sObjMap.get(sObjectName);
            Map<String, Schema.SObjectField> sObjectFieldsMap = sObjectToken.getDescribe().fields.getMap();
            sObjMapWithFields.put(sObjectName.toLowerCase(), sObjectFieldsMap);
        }
        return sObjMapWithFields.get(sObjectName.toLowerCase());
    }

    private static void prepareObjectWithExistingRecords(){
        if ( existingSObjects == null ){
            existingSObjects = new Map<String, List<sObject>>();
        }
    }

    private static void addExistingSObjectRecordByObjectName(String objectName, List<sObject> sObjectRecords){
        if (existingSObjects == null){  
            prepareObjectWithExistingRecords();
        }
        if (!existingSObjects.containsKey(objectName.toLowerCase())){
            existingSObjects.put(objectName.toLowerCase(), new List<sObject>());
        }
    }

    private static void prepopulateFieldsWithValues(Map<String, Object> fieldsWithValues,
                                                    Set<String> existingFieldsForSObject,
                                                    sObject record){

        if (fieldsWithValues == null || fieldsWithValues.isEmpty()){
            return;
        }

        Set<String> fieldsNamesLowerCase = new Set<String>();
        for (String field : existingFieldsForSObject){
            fieldsNamesLowerCase.add(field.toLowerCase());
        }

        for (String field : fieldsWithValues.keySet()){
            if (fieldsNamesLowerCase.contains(field.toLowerCase())){
                record.put(field, fieldsWithValues.get(field));
            }
        }
    }

    private static SObject createSObjectRecordPrivate(String sObjectName, SObject sObjectRecord, Map<String, Schema.SObjectField> sObjectFieldsMap){
        //iterate through fields to assign them proper values
        for(String fieldName : sObjectFieldsMap.keySet()){
            if ( sObjectRecord.get( fieldName ) != null ){
                continue;
            }
            //note only custom fields can be set to required. However doesn't account for validation rules...
            SObjectField fieldToken = sObjectFieldsMap.get( fieldName );
            DescribeFieldResult fieldDescribe = getFieldDescibe(sObjectName, fieldName);
            assignFieldValue(sObjectName, sObjectRecord, fieldDescribe);
        }
        
        return sObjectRecord;
    }

    public static void assignFieldValue(String sObjectName, SObject sObjectRecord, DescribeFieldResult fieldDescribe){
        Schema.DisplayType fType = fieldDescribe.getType();
        String fName = fieldDescribe.getName();
        if (fName == 'OwnerId'){
            return;
        }

        System.debug('FIELD NAME: ' + fName);
        System.debug('FIELD TYPE: ' + fType);
        System.debug('fieldDescribe.isCreateable(): ' + fieldDescribe.isCreateable());
        System.debug('fieldDescribe.isNillable(): ' + fieldDescribe.isNillable());
        System.debug('fieldDescribe.isDefaultedOnCreate(): ' + fieldDescribe.isDefaultedOnCreate());
        System.debug('fieldDescribe.isAutoNumber(): ' + fieldDescribe.isAutoNumber());
        System.debug('fieldDescribe.isCalculated(): ' + fieldDescribe.isCalculated());
        //if a field is required, specify value:
        //only add 1 to count if: creatable, not nillable, not defaulted, not an auto number, and not calculated

        if( fieldDescribe.isCreateable() && !fieldDescribe.isNillable() && !fieldDescribe.isDefaultedOnCreate()&& !fieldDescribe.isAutoNumber() && !fieldDescribe.isCalculated()){
            if (sObjectName == USER_API_NAME && (fName == PROFILEID_FIELD_NAME ||
                                                 fName == USERNAME_FIELD_NAME ||
                                                 fName == TIMEZONESIDKEY_FIELD_NAME ||
                                                 fName == EMAILENCODINGKEY_FIELD_NAME ||
                                                 fName == LOCALESIDKEY_FIELD_NAME ||
                                                 fName == LANGUAGELOCALEKEY_FIELD_NAME)){
                if (fName == PROFILEID_FIELD_NAME){
                    sObjectRecord.put( fName, UserInfo.getProfileId() );
                } else if ( fName == USERNAME_FIELD_NAME ){
                    sObjectRecord.put( fName, constructUniqueText(5) + UserInfo.getUserName() );
                } else if ( fName == TIMEZONESIDKEY_FIELD_NAME ){
                    sObjectRecord.put( fName, fieldDescribe.getPicklistValues()[0].getvalue() );
                } else if ( fName == EMAILENCODINGKEY_FIELD_NAME ){
                    sObjectRecord.put( fName, fieldDescribe.getPicklistValues()[0].getvalue() );
                } else if ( fName == LOCALESIDKEY_FIELD_NAME ){
                    sObjectRecord.put( fName, fieldDescribe.getPicklistValues()[0].getvalue() );
                } else if ( fName == LANGUAGELOCALEKEY_FIELD_NAME ){
                    sObjectRecord.put( fName, fieldDescribe.getPicklistValues()[0].getvalue() );
                }
                return;
            }
            //increment as the # fieldDescribe results is limited
            //check if field is unique
            if(fieldDescribe.isUnique()){
                if(fType == Schema.DisplayType.STRING || fType == Schema.DisplayType.TEXTAREA ||fType == Schema.DisplayType.ENCRYPTEDSTRING){//text fields: String, TextArea, EncryptedString
                    sObjectRecord.put(fName, constructUniqueText(fieldDescribe.getLength()));
                } else if(fType == Schema.DisplayType.DOUBLE){
                    sObjectRecord.put(fName,constructUniqueNumber(fieldDescribe.getPrecision() - fieldDescribe.getScale(),fieldDescribe.getScale()));
                } else if(fType == Schema.DisplayType.INTEGER){
                    sObjectRecord.put(fName,constructUniqueInteger(fieldDescribe.getDigits()));
                } else if(fType == Schema.DisplayType.EMAIL){
                    sObjectRecord.put(fName, constructUniqueText(fieldDescribe.getLength()) + EMAIL_SUFFIX);
                }
            }else{
                //just give it a value
                //text fields
                if(fType == Schema.DisplayType.STRING || fType == Schema.DisplayType.TEXTAREA ||fType == Schema.DisplayType.ENCRYPTEDSTRING){
                    sObjectRecord.put(fName, constructUniqueText(fieldDescribe.getLength())); 
                } else if(fType == Schema.DisplayType.DOUBLE || fType == Schema.DisplayType.CURRENCY|| fType == Schema.DisplayType.PERCENT){
                    System.debug('GENERATION OF A DOUBLE NUMBER START ...');
                    System.debug('fName ' + fName);
                    System.debug('fieldDescribe.getPrecision() ' + fieldDescribe.getPrecision());
                    System.debug('fieldDescribe.getScale() ' + fieldDescribe.getScale());
                    sObjectRecord.put(fName,constructUniqueNumber(fieldDescribe.getPrecision() - fieldDescribe.getScale(),fieldDescribe.getScale()));
                    System.debug('GENERATION OF A DOUBLE NUMBER END ...');
                } else if(fType == Schema.DisplayType.INTEGER){
                    sObjectRecord.put(fName,constructUniqueNumber(fieldDescribe.getDigits(),0));
                } else if(fType == Schema.DisplayType.EMAIL){
                    sObjectRecord.put(fName, constructUniqueText(fieldDescribe.getLength()) + EMAIL_SUFFIX);
                } else if(fType == Schema.DisplayType.URL){
                    sObjectRecord.put(fName, URL_PREFIX + constructUniqueText(fieldDescribe.getLength()));
                } else if(fType == Schema.DisplayType.DATE){
                    sObjectRecord.put(fName, System.today());
                } else if(fType == Schema.DisplayType.DATETIME){
                    sObjectRecord.put(fName, System.now());
                } else if(fType == Schema.DisplayType.PHONE){
                    System.debug('GENERATION OF A PHONE NUMBER START ...');
                    sObjectRecord.put(fName, constructUniqueText(fieldDescribe.getLength()));
                    System.debug('GENERATION OF A PHONE NUMBER END ...'); 
                } else if(fType == Schema.DisplayType.COMBOBOX){
                    sObjectRecord.put(fName, constructUniqueText(fieldDescribe.getLength()));
                } else if(fType == Schema.DisplayType.MULTIPICKLIST){
                    sObjectRecord.put(fName, constructUniqueText(fieldDescribe.getLength()));
                } else if(fType == Schema.DisplayType.PICKLIST){
                    sObjectRecord.put(fName, constructUniqueText(fieldDescribe.getLength()));
                } else if(fType == Schema.DisplayType.TIME){
                    sObjectRecord.put(fName, System.now());
                } else if(fType == Schema.DisplayType.REFERENCE){
                    List<Schema.sObjectType> referenceToList = fieldDescribe.getReferenceTo();
                    String referenceSObjectName;
                    if(referenceToList != null && referenceToList.size()>0){ referenceSObjectName = referenceToList[0].getDescribe().getName(); }
                    throw new TestMethodException( '"' + referenceSObjectName + '" record should be created before you create "' + sObjectName + '"' );
                }
            }
        }
    }

    private static Integer constructUniqueInteger(Integer intSize){
        String uniqueKey = String.valueOf(System.now().getTime());
        System.debug('uniqueKey: ' + uniqueKey);
        String intPart = '';
        if(intSize != null && intSize != 0){
            if(intSize < uniqueKey.length()){
                intPart = uniqueKey.substring(uniqueKey.length() - intSize,uniqueKey.length());
            } else {
                intPart = uniqueKey;
            }
        }
        System.debug('uniqueKey: ' + uniqueKey);
        System.debug('intPart: ' + intPart);
        return Integer.valueOf(intPart);
    }

    private static Double constructUniqueNumber(Integer intSize, Integer fractSize){
        String uniqueKey = String.valueOf(System.now().getTime());
        System.debug('uniqueKey: ' + uniqueKey);
        String fractPart = '';
        String intPart = '';
        if(fractSize != null && fractSize != 0){
            if(fractSize < uniqueKey.length()){
                fractPart = '.' + uniqueKey.substring(uniqueKey.length() - fractSize,uniqueKey.length());
            } else {
                fractPart = uniqueKey;
            }
        }
        System.debug('fractPart: ' + fractPart);
        if(intSize != null && intSize != 0){
            if(intSize < uniqueKey.length()){
                intPart = uniqueKey.substring(uniqueKey.length() - intSize,uniqueKey.length());
            } else {
                intPart = uniqueKey;
            }
        }
        System.debug('uniqueKey: ' + uniqueKey);
        System.debug('intPart + fractPart: ' + (intPart + fractPart));
        if(!fractPart.contains('.')){
            return Double.valueOf(intPart + fractPart + '.0');
        } else {
            return Double.valueOf(intPart + fractPart);
        }
    }

    private static String constructUniqueText(Integer fieldSize){
        String uniqueKey = String.valueOf(System.now().getTime());
        if(fieldSize < uniqueKey.length()){
            return uniqueKey.substring(uniqueKey.length() - fieldSize,uniqueKey.length());
        } else {
            return uniqueKey;
        }
        return null;
    }

    public static List<Account> createAccountsFromStaticResource(){
        List<sObject> sobjList = Test.loadData(Account.sObjectType, 'testAccounts');

        return (List<Account>)sobjList;
    }

    public static List<sObject> getSObjectListByName(Integer numberToCreate, Id recordTypeId, String sobjectName, Boolean doInsert){
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sobjectName);
        List<sObject> sObjectResultList = new List<sObject>();
        for (Integer i = 0; i < numberToCreate; i++){
            sObjectResultList.add(targetType.newSObject( recordTypeId, true));
        }
        if(doInsert){
            insert sObjectResultList;
        }
        return sObjectResultList;
    }

    public class TestMethodException extends Exception {}
}