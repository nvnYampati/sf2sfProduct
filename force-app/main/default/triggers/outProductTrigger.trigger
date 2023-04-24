trigger outProductTrigger on TestObj__c (after insert) {
    if(trigger.isAfter && trigger.isInsert){		//send record to external
        for( TestObj__c tObj : trigger.new){
        	outProductOutManager.regInAProduct('nav.taskorg.dev@oscar.com', tObj.Name, tObj.Id);
        }
    }
}