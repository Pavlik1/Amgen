trigger CriteriaTrigger on Criteria__c (after insert) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            CriteriaServices.createVotes(Trigger.newMap);
        }
    }
}