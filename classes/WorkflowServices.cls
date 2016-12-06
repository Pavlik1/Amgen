public with sharing class WorkflowServices{

	public static List<Check_List_Item__c> getListItemsByTool(String tool, Id projectId) {
		return [SELECT Id, Tools__c, Tool_Is_Used__c, Tool_Area__c, Tool_Area_Alternative__c, Tools_Alternative__c, Field_Object__c, Field_Object_Alternative__c, Logical_Operator__c
		        FROM Check_List_Item__c
		        WHERE (Tools__c =: tool OR Tools_Alternative__c =: tool)
		        AND Project__c =: projectId];
	}

	public static void checkItemWorkflow(String tool, Id projectId) {
        checkItemWorkflow(new Set<String>(), tool, projectId);
    }


    public static void checkItemWorkflow(Set<String> fieldNames, String tool, Id projectId) {
		Project__c project = ProjectServices.getProjectById(projectId);

        List<Check_List_Item__c> checkItems = WorkflowServices.getListItemsByTool(tool, projectId);
        Set<String> objectsAreas            = new Set<String>();
System.debug(LoggingLevel.ERROR, '^^^ checkItems = ' + checkItems);
        String query  = 'SELECT Id ';
        for (Check_List_Item__c cli : checkItems) {
            query += cli.Field_Object__c == Constants.OBJECT_VAL             && !objectsAreas.contains(cli.Tool_Area__c) ? ' ,             (SELECT Id FROM ' + cli.Tool_Area__c + ') ' : '';
            query += cli.Field_Object_Alternative__c == Constants.OBJECT_VAL && !objectsAreas.contains(cli.Tool_Area_Alternative__c) ? ' , (SELECT Id FROM ' + cli.Tool_Area_Alternative__c + ') ' : '';
            //avoid duplicate data
            objectsAreas.add(cli.Tool_Area__c);
            objectsAreas.add(cli.Tool_Area_Alternative__c);
        }
        query += ' FROM Project__c WHERE Id = \'' + projectId +'\'';

        Project__c projectWithChild = Database.query(query);

        Boolean result;
        Boolean alternativeResult;

        for (Check_List_Item__c cli : checkItems) {
        	if (cli.Field_Object__c == Constants.FIELD_VAL) {
        		result = null  != project.get(cli.Tool_Area__c) && 
        		         0     != project.get(cli.Tool_Area__c) && 
        		         false != project.get(cli.Tool_Area__c) && 
        		         ''    != project.get(cli.Tool_Area__c);

                fieldNames.add(cli.Tool_Area__c);

        	} if (cli.Field_Object__c == Constants.OBJECT_VAL) {
        		result = projectWithChild.getSObjects(cli.Tool_Area__c) != null && !projectWithChild.getSObjects(cli.Tool_Area__c).isEmpty();
        	}

        	//find Alternative Result if Alternative Tool is used
        	if (String.isNotBlank(cli.Tools_Alternative__c)) {
        		if (cli.Field_Object_Alternative__c == Constants.FIELD_VAL) {
	        		alternativeResult = null  != project.get(cli.Tool_Area_Alternative__c) && 
	        		                    0     != project.get(cli.Tool_Area_Alternative__c) && 
	        		                    false != project.get(cli.Tool_Area_Alternative__c) && 
	        		                    ''    != project.get(cli.Tool_Area_Alternative__c);

                    fieldNames.add(cli.Tool_Area__c);

	        	} if (cli.Field_Object_Alternative__c == Constants.OBJECT_VAL) {
	        		alternativeResult = projectWithChild.getSObjects(cli.Tool_Area_Alternative__c) != null && !projectWithChild.getSObjects(cli.Tool_Area_Alternative__c).isEmpty(); 
	        	}

	        	cli.Tool_Is_Used__c = cli.Logical_Operator__c == 'AND' ? result && alternativeResult : result || alternativeResult;

        	} else {
        		cli.Tool_Is_Used__c = result;
        	}
        }

        upsert checkItems;
    }
}