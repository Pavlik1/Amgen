public with sharing class PhaseProgressBarController {

    public String fieldValue {get;set;}
    public String fieldName {get;set;}
    public String controllingFieldName {get;set;}
    public String projectId {get;set;}

    public Boolean isPhaseVal {get;set;}

    public PageReference clearProperties() {
        this.currentProject         = null;
        this.phaseToSubPhaseWrapper = null;
        this.subphaseIdToItem       = null;

        this.phaseIdToSubPhase      = null;
        return null;
    }

    public Project__c currentProject {
        get {
            if (null == this.currentProject) {
                this.currentProject = ProjectServices.getProjectWithCheckItemsById(this.projectId);
            }
            return this.currentProject;
        }
        set;
    }

    public Map<String, Set<SubPhaseWrapper>> phaseToSubPhaseWrapper {
        get{
            if (null == this.phaseToSubPhaseWrapper) {
                this.phaseToSubPhaseWrapper = new Map<String, Set<SubPhaseWrapper>>();

                if(!isPhaseVal) { // Required only for Phases

                    for(Check_List_Item__c chIt : currentProject.Check_List_Items__r){
                        this.subphases.add(chIt.Subphase__r);

                        if(!phaseToSubPhaseWrapper.containsKey(chIt.Subphase__r.Phase__r.Name)) {
                            phaseToSubPhaseWrapper.put(chIt.Subphase__r.Phase__r.Name, new Set<SubPhaseWrapper>());
                        }
                    }

                    for (Subphase__c subphase : this.subphases) {
                        phaseToSubPhaseWrapper.get(subphase.Phase__r.Name).add(new SubPhaseWrapper(subphase.Name, getSubPhaseIcon(subphase.Id)));
                    }
                }
            }
            return this.phaseToSubPhaseWrapper;
        }
        set;
    }

    public Set<Phase__c> phases {
        get {
            if (null == this.phases) {
                this.phases = new Set<Phase__c>();

                for(Check_List_Item__c chIt : currentProject.Check_List_Items__r){
                    this.phases.add(chIt.Subphase__r.Phase__r);
                    
                }
            }
            return this.phases;
        }
        set;
    }

    public Map<Id, Set<Subphase__c>> phaseIdToSubPhase {
        get {
            if (null == this.phaseIdToSubPhase) {
                System.debug('!!!1');
                
                this.phaseIdToSubPhase = new Map<Id, Set<Subphase__c>>();

                for(Check_List_Item__c chIt : this.currentProject.Check_List_Items__r){
                    if(!this.phaseIdToSubPhase.containsKey(chIt.Subphase__r.Phase__r.Id)){
                        this.phaseIdToSubPhase.put(chIt.Subphase__r.Phase__r.Id, new Set<Subphase__c>());
                    }
                    this.phaseIdToSubPhase.get(chIt.Subphase__r.Phase__r.Id).add(chIt.Subphase__r);
                }
            }
            return this.phaseIdToSubPhase;
        }
        set;
    }

    public Set<Subphase__c> subphases{
        get{
            if (null == this.subphases) {
                this.subphases = new Set<Subphase__c>();
            }
            return this.subphases;
        }
        set;
    }

    public Map<Id, List<Check_List_Item__c>> subphaseIdToItem{
        get {
            if (null == this.subphaseIdToItem) {
                this.subphaseIdToItem = new Map<Id, List<Check_List_Item__c>>();

                for (Check_List_Item__c chIt : currentProject.Check_List_Items__r) {
                    if (!this.subphaseIdToItem.containsKey(chIt.Subphase__c)) {
                        this.subphaseIdToItem.put(chIt.Subphase__c, new List<Check_List_Item__c>());
                    }

                    this.subphaseIdToItem.get(chIt.Subphase__c).add(chIt);
                }
            }
            return this.subphaseIdToItem;
        }
        set;
    }


    public Map<String, Set<String>> icons{
        get{
            if( icons == null ){
                icons = new Map<String, Set<String>>();
                icons.put('Phase 1', new Set<String>{'icon_s.png', 'icon_d.png'});
                icons.put('Phase 2', new Set<String>{'icon_d.png', 'icon_a.png'});
                icons.put('Phase 3', new Set<String>{'icon_d.png', 'icon_a.png', 'icon_i.png'});
                icons.put('Phase 4', new Set<String>{'icon_s.png', 'icon_d.png'});
            }
            return icons;
        }
        set;
    }

    //calculate how many related Check List Items are checked and based on it return appropriate icon
    public String getSubPhaseIcon(Id subphaseId) {
        List<Check_List_Item__c> checkedItems = new List<Check_List_Item__c>();
        List<Check_List_Item__c> allItems = this.subphaseIdToItem.get(subphaseId); 

        for (Check_List_Item__c cli : allItems) {
            if (cli.Checked__c) {
                checkedItems.add(cli);
            }
        }

        if (checkedItems.size() == allItems.size()) {
            return 'i-check.png';

        } else if (checkedItems.isEmpty()) {
            return null;

        } else {
            return 'i-loading.png';
        }                                        

    }

    public class SubPhaseWrapper {
        public String subPhaseName {get; set;}
        public String icon {get; set;}

        public Boolean isManualChanges {get; set;}

        public SubPhaseWrapper(String subPhaseName, String icon) {
            this.subPhaseName = subPhaseName;
            this.icon         = icon;
        }
    }
}