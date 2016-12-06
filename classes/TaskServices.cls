public with sharing class TaskServices{

  /* -------------------------------------- Begin DAO methods ----------------------------------------------- */
    public static List<Task> getTasksByWhatId(final Id projectId) { 
        return new List<Task>([SELECT Id, OwnerId, Owner.Name, Description, ActivityDate, Subject, CreatedDate, xrospackages__Actions__c, Impacted_Functions__c, xrospackages__Title__c
                               FROM Task
                               WHERE WhatId =: projectId AND WhatId != null]);
        
    }
    /* -------------------------------------- End DAO methods ----------------------------------------------- */
}