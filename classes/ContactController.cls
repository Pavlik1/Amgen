public with sharing class ContactController {

    @AuraEnabled
    public static List<Contact> getContacts(){
        List<Contact> contacts = [ Select Id, Name, MailingStreet, Phone, Email, xrospackages__Level__c  From Contact ];
        return contacts;
    }
    
    @AuraEnabled
    public static List<Contact> getPrimary(){
        List<Contact> contacts = [ Select Id, Name, MailingStreet, Phone, Email, xrospackages__Level__c  From Contact 
                                   Where xrospackages__Level__c = 'Primary' ];
        
        return contacts;
    }
    
}