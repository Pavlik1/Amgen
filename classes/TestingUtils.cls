@isTest
public class TestingUtils {

    public static List<Project__c> createProjectList(Integer numberToCreate, Boolean doInsert){
        List<Project__c> resList = new List<Project__c>();

        for (Integer i = 0; i < numberToCreate; i++){
            resList.add(new Project__c());
        }

        if(doInsert){
            insert resList;
        }

        return resList;
    }

    public static List<Criteria__c> createCriteriaList(Integer numberToCreate, Id projectId, Integer weightingvalue, Boolean doInsert){
        List<Criteria__c> resList = new List<Criteria__c>();

        projectId      = projectId == null ? createProjectList(1, true)[0].Id : projectId;
        weightingvalue = weightingvalue == null ? 1 : weightingvalue;

        for (Integer i = 0; i < numberToCreate; i++){
            resList.add(new Criteria__c(Project__c = projectId, Weighting__c = weightingvalue));
        }

        if(doInsert){
            insert resList;
        }

        return resList;
    }

    public static List<Alternative_Option__c> createAlternativeOptionList(Integer numberToCreate, Id projectId, Boolean doInsert){
        List<Alternative_Option__c> resList = new List<Alternative_Option__c>();

        projectId      = projectId == null ? createProjectList(1, true)[0].Id : projectId;

        for (Integer i = 0; i < numberToCreate; i++){
            resList.add(new Alternative_Option__c(Project__c = projectId));
        }

        if(doInsert){
            insert resList;
        }

        return resList;
    }

    public static List<Check_List_Item__c> createCheckListItemList(Integer numberToCreate, Id projectId, Id recordTypeId, Boolean doInsert){
        List<Check_List_Item__c> resList = new List<Check_List_Item__c>();

        for (Integer i = 0; i < numberToCreate; i++){
        	Check_List_Item__c item = new Check_List_Item__c();
        	if (projectId != null) item.Project__c = projectId;
        	if (recordTypeId != null) item.RecordTypeId = recordTypeId;
            resList.add(new Check_List_Item__c());
        }

        if(doInsert){
            insert resList;
        }

        return resList;
    }
}