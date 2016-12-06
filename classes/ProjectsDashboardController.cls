global with sharing class ProjectsDashboardController {
	public ProjectsDashboardController() {

	}

    @RemoteAction   
	global static ChartValue[] orderedProjects() {
		List<ChartValue> charts = new List<ChartValue>();

		for (AggregateResult ar : [SELECT COUNT(Id), Phase__c
								   FROM Project__c
								   GROUP BY Phase__c]) {
			charts.add(new ChartValue((Integer)ar.get('expr0'), (String)ar.get('xrospackages__Phase__c')));
		}
		return charts;
	}

	@RemoteAction   
	global static SubPhaseValue[] getSubPhaseValues(String selectedPhase) {
		List<SubPhaseValue> charts = new List<SubPhaseValue>();

		for (AggregateResult ar : [SELECT COUNT(Id), xrospackages__Sub_Phases__c
								   FROM Project__c
								   WHERE Phase__c =: selectedPhase
								   GROUP BY xrospackages__Sub_Phases__c]) {
			charts.add(new SubPhaseValue((String)ar.get('xrospackages__Sub_Phases__c'), (Integer)ar.get('expr0')));
		}
		return charts;
	}


	global class ChartValue {
		global Integer val1 { get; set; }
		global String val2 { get; set; }
	
		public ChartValue(Integer va1, String va2) {
			this.val1 = va1;
			this.val2 = va2;
		}
	}

	global class SubPhaseValue {
		global String subPhaseName { get; set; }
		global Integer projectsCount { get; set; }
	
		public SubPhaseValue(String subPhaseName, Integer projectsCount) {
			this.subPhaseName = subPhaseName;
			this.projectsCount = projectsCount;
		}
	}

}