@RestResource(urlMapping = '/registerAProduct/')
global class registerAProduct {
	
    @HttpPost
    global static Id registerProduct(string Name, string recordId){
        outProductEntry__c op = new outProductEntry__c( Name__c = Name, Record_Id__c = recordId);
        insert op;
        return op.Id;
    }
    
}