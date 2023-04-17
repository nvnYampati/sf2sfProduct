trigger AccessTokenTrigger on Access_Token__c (before insert) {
    
    if( trigger.isBefore && trigger.isInsert){		//delete previous tokens
    	for(Access_Token__c at : trigger.new){
        	string namestr = '%'+at.name;
        	list<Access_Token__c> atList = [SELECT Id, Name FROM Access_Token__c WHERE Name LIKE :namestr];
        	if( atList.size() > 0){
            	delete atList;
        	}
    	}   
    }
}