public with sharing class CheckListItemServices {
	private static id projectInstanceRecordtypeId {
		get{
			if (projectInstanceRecordtypeId == null){
				for (Schema.RecordTypeInfo schemaRecordTypeInfoItem : Check_List_Item__c.SObjectType.getDescribe().getRecordTypeInfos()){
					if ( schemaRecordTypeInfoItem.getName() == Constants.CLI_RECORDTYPE_PROJECT_INSTANCE){
						projectInstanceRecordtypeId = schemaRecordTypeInfoItem.getRecordTypeId();
					}
				}
			}
			return projectInstanceRecordtypeId;
		}
		set;
	}

	public static void initCheckListItemsForProject( List<Project__c> projects ){
		List<Check_List_Item__c> chListItems = [SELECT Id, Item_Text__c, Sequence_Number__c, Subphase__c, Field_Object__c,
													Field_Object_Alternative__c, Logical_Operator__c, Tool_Area__c,
													Tool_Area_Alternative__c, Tools__c, Tools_Alternative__c, PhaseName__c
												FROM Check_List_Item__c 
												WHERE Project__c = null AND
													RecordType.Name = : Constants.CLI_RECORDTYPE_MASTER_RECORD];

		List<Check_List_Item__c> chListItemsNew = new List<Check_List_Item__c>();
		for ( Project__c project : projects ){
			for( Check_List_Item__c cli : chListItems ){
				Check_List_Item__c newRec = cli.clone();
				newRec.Project__c = project.Id;
				newRec.RecordTypeId = projectInstanceRecordtypeId;
				chListItemsNew.add( newRec );
			}
		}

		try{
			insert chListItemsNew;
		} catch (DMLException dmlEx){
			for ( Integer i = 0; i < dmlEx.getNumDml(); i++ ){
				new Map<Id, Project__c>( projects ).get( chListItemsNew[dmlEx.getDmlIndex(i)].Project__c ).addError('Can not create Check List Item for project: ' + dmlEx.getMessage() );
			}
		}
	}

	//this method is not used
/*
	public static Set<Id> filterCheckItems(List<Check_List_Item__c> newList, Map<Id, Check_List_Item__c> oldMap) {
		Set<Id> projectsIds = new Set<Id>();

		for (Check_List_Item__c cli : newList) {
			//On Insert
			if (null == oldMap) {
				projectsIds.add(cli.Project__c);

			//On Update
			} else {
				Check_List_Item__c oldItem = oldMap.get(cli.Id);
				if (oldItem.Tool_Is_Used__c != cli.Tool_Is_Used__c) {
					projectsIds.add(cli.Project__c);
				}
			}
		}

		projectsIds.remove(null);
		return projectsIds;
	}
*/

	//this method is not used
/*
	public static void determineToolUsage(Set<Id> projectsIds) {
		if (null == projectsIds || projectsIds.isEmpty()) {
			return;
		}

		Set<String> tools = new Set<String>{Constants.DMGT, Constants.RISK_ASSESSMENT_TOOL, Constants.WEIGHTED_RANKINGS_MATRIX, Constants.DECISION_EXECUTION_TOOL, Constants.DECISION_EVALUATION_TOOL};
		Map<String, String> tools2FieldUsage = new Map<String, String>{Constants.DMGT => 'DMGT_Usage__c'};

		List<Project__c> projects = [SELECT Id, Decision_Evaluation_Tool_Usage__c, Decision_Execution_Tool_Usage__c, Risk_Assessment_Tool_Usage__c, DMGT_Usage__c, Weighted_Rankings_Matrix_Usage__c, Project_State__c
                                     FROM Project__c
                                     WHERE Id IN: projectsIds];

		List<Check_List_Item__c> checkItems = [SELECT Id, Tool_Is_Used__c, Tools__c, Tools_Alternative__c, Project__c, 
		                                               Project__r.Decision_Evaluation_Tool_Usage__c, Project__r.Decision_Execution_Tool_Usage__c, Project__r.Risk_Assessment_Tool_Usage__c, 
		                                               Project__r.DMGT_Usage__c, Project__r.Weighted_Rankings_Matrix_Usage__c
		                                       FROM Check_List_Item__c 
		                                       WHERE Project__c IN :projectsIds AND (Tools__c != '' OR Tools_Alternative__c != '')];

		Map<Id, Map<String, List<Check_List_Item__c>>> projectId2ProjectsTools = new Map<Id, Map<String, List<Check_List_Item__c>>>();


		for (Check_List_Item__c cli : checkItems) {
			if (!projectId2ProjectsTools.containsKey(cli.Project__c)) {
				projectId2ProjectsTools.put(cli.Project__c, new Map<String, List<Check_List_Item__c>>());
			}

			for (String toolName : tools) {
				if (!projectId2ProjectsTools.get(cli.Project__c).containsKey(toolName)) {
					projectId2ProjectsTools.get(cli.Project__c).put(toolName, new LIst<Check_List_Item__c>());
				}

				if (cli.Tools__c == toolName || cli.Tools_Alternative__c == toolName) {
					projectId2ProjectsTools.get(cli.Project__c).get(toolName).add(cli);
				}
			}

		}


		for (Project__c pr : projects) {
			Boolean used = false;
			Boolean notUsed = false;

			for (String toolName : tools) {
				for (Check_List_Item__c cli : projectId2ProjectsTools.get(pr.Id).get(toolName)) {
					if (cli.Tool_Is_Used__c) {
						used = true;

					} else {
						notUsed = true;
					}	
				}

				if (used && notUsed) {
					pr.put(tools2FieldUsage.get(toolName), Constants.PARTIALLY_USED);

				} else if (used && !notUsed) {
					pr.put(tools2FieldUsage.get(toolName), Constants.USED);

				} else {
					pr.put(tools2FieldUsage.get(toolName), Constants.NOT_USE);
				}
			}
		
		}

		update projects;

	}
*/

	public static void checkCchakedItems(List<Check_List_Item__c> newList, Map<Id, Check_List_Item__c> oldMap) {
		if (null != oldMap && null != newList) {
			for (Check_List_Item__c cli : newList) {
				Check_List_Item__c oldItem = oldMap.get(cli.Id);
				if (cli.Tool_Is_Used__c && !cli.Checked__c && oldItem.Tool_Is_Used__c != cli.Tool_Is_Used__c) {
					cli.Checked__c = true;
				}
			}
		} else if(null != newList){
			for (Check_List_Item__c cli : newList) {
				cli.Checked__c = cli.Tool_Is_Used__c;
			}
		}
	}
}