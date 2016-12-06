trigger AlternativeOptionTrigger on Alternative_Option__c (after insert) {
     if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            AlternativeOptionServices.createVotes(Trigger.newMap);
        }
    }
}