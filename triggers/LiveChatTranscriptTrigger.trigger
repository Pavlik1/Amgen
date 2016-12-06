trigger LiveChatTranscriptTrigger on LiveChatTranscript (before insert) {
    system.debug('@@@@@@@@@@ LiveChatTranscriptTrigger BEFORE INSERT START');
    
    if (trigger.new.size()==1) {
        LiveChatTranscript lct = trigger.new[0];
        system.debug('@@@@@@@@@@ lct = ' + lct);
        lct.SkillId = '0C55800000000hW';
    }
    
    
    system.debug('@@@@@@@@@@ LiveChatTranscriptTrigger BEFORE INSERT END');
}