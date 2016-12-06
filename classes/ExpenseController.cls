public with sharing class ExpenseController {
	@AuraEnabled
    public static List<xrospackages__Expense__c> getExpenses(){
        return [ Select Id, Name, xrospackages__Amount__c, xrospackages__Client__c, 
               			xrospackages__Date__c, xrospackages__Reimbursed__c, CreatedDate
                 From xrospackages__Expense__c];
    }
    
    @AuraEnabled
    public static xrospackages__Expense__c saveExpense( xrospackages__Expense__c expense ){
        upsert expense;

        return expense;
    } 
}