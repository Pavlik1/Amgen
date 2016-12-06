trigger ProjectTrigger on xrospackages__Project__c (after insert, before update, after update) {

    if ( Trigger.isAfter ){
        if ( Trigger.isInsert ){
            CheckListItemServices.initCheckListItemsForProject( Trigger.new );
            //create Phases for newly created Projects
            ProjectServices.initPhaseForProjects( Trigger.new );
            //List<xrospackages__Check_List_Item__c> chListItems =  [ Select Id, xrospackages__Item_Text__c, xrospackages__Sequence_Number__c, xrospackages__Subphase__c
            //                                                       From xrospackages__Check_List_Item__c 
            //                                                       Where xrospackages__Project__c = null AND RecordTypeId = '012580000004zGU'];
            //List<xrospackages__Check_List_Item__c> chListItemsNew = new List<xrospackages__Check_List_Item__c>();
            //for( xrospackages__Check_List_Item__c cli : chListItems ){
            //    xrospackages__Check_List_Item__c newRec = cli.clone();
            //    newRec.xrospackages__Project__c = Trigger.new[0].Id;
            //    newRec.RecordTypeId = '012580000004zGZ';
            //    chListItemsNew.add(newRec);
            //}


            //insert chListItemsNew;
        }
    }

    if ( Trigger.isBefore ){
        if ( Trigger.isUpdate ){
            for (xrospackages__Project__c project : Trigger.new){
                project.xrospackages__Prev_Phase_Value__c = Trigger.oldMap.get(project.Id).xrospackages__Phase__c;
            }
            ProjectServices.completeAllExistingPhase ( ProjectServices.filteredProjectWithCompleteStatePopulateCompleteDate( Trigger.new, Trigger.oldMap), Trigger.oldMap);
        }
    }

    if ( Trigger.isAfter ){
        if ( Trigger.isUpdate ){
            List<xrospackages__Project__c> filteredProjectList = new List<xrospackages__Project__c>();
            for (xrospackages__Project__c project : Trigger.new){
                if ( project.xrospackages__Phase__c != Trigger.oldMap.get(project.Id).xrospackages__Phase__c ){

                    if (project.xrospackages__Sponsor__c != null || project.xrospackages__Decision_Maker__c != null){
                        filteredProjectList.add( project );
                    }
                }
            }

            if ( !filteredProjectList.isEmpty() ){
                EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE  DeveloperName = 'Change_Phase_Notification'];
                System.Debug(LoggingLevel.ERROR, '^^^ template = ' + template);

                List<Messaging.Email> emailList = new List<Messaging.Email>();
                for (xrospackages__Project__c project : filteredProjectList){
                    if ( project.xrospackages__Sponsor__c != null ){
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setWhatId(project.Id); // mail prepared for current bulletin
                        mail.setTargetObjectId(project.xrospackages__Sponsor__c);
                        mail.setSaveAsActivity(false);
                        mail.setTemplateId(template.Id);
                        emailList.add(mail);
                    }
                    if ( project.xrospackages__Sponsor__c != null ){
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setWhatId(project.Id); // mail prepared for current bulletin
                        mail.setTargetObjectId(project.xrospackages__Decision_Maker__c);
                        mail.setSaveAsActivity(false);
                        mail.setTemplateId(template.Id);
                        emailList.add(mail);
                    }
                }
                System.Debug(LoggingLevel.ERROR, '^^^ emailList = ' + emailList);
                if ( !emailList.isEmpty() ){
                    Messaging.sendEmail(emailList, false);
                }
            }
        }
    }

    if(Trigger.isAfter && Trigger.isUpdate){
        ProjectServices.updateExistingPhase ( ProjectServices.filteredProjectForUpdatePhase( Trigger.new, Trigger.oldMap), Trigger.oldMap);
    }
}