public class opLwcController {
	@AuraEnabled(cacheable = true)
    public static list<outProductEntry__c> getRegList(){
        list<outProductEntry__c> regList = [SELECT Id, Name, Record_Id__c FROM outProductEntry__c];
        return regList;
    }
    
    @AuraEnabled
    public static string getAccess(){
        string aToken = outProductController.getAccessTokenCred();
        return aToken;
    }
    
    @AuraEnabled
    public static void refreshTokenCaller(){
        string aToken = outProductController.getAccessTokenCred();
        system.debug(aToken);
    }
    
    @AuraEnabled
    public static Access_Token__c getTokenObj(){
        Access_Token__c accessToken = [SELECT Id, Name, Access_Token__c, CreatedDate FROM Access_Token__c WHERE Name LIKE 'nav.pidms.dev1@oscar.comcred' ORDER BY CreatedDate DESC NULLS LAST LIMIT 1];
        system.debug(accessToken);
        return accessToken;
    }
    
    @AuraEnabled
    public static string getToken(){
        string accessToken = [SELECT Id, Name, Access_Token__c, CreatedDate FROM Access_Token__c WHERE Name LIKE 'nav.pidms.dev1@oscar.comcred' ORDER BY CreatedDate DESC NULLS LAST LIMIT 1].Access_Token__c;
        system.debug(accessToken);
        return accessToken;
    }
    
    @AuraEnabled
    public static outProductController.productResponseWrap getOutProduct(Id productId){
		string orgName = 'nav.pidms.dev1@oscar.comcred';
        string orgNameStr = '%'+orgName;
        string accessToken = [SELECT Id, Name, Access_Token__c, CreatedDate FROM Access_Token__c WHERE Name LIKE :orgNameStr ORDER BY CreatedDate DESC NULLS LAST LIMIT 1].Access_Token__c;
        http protocol = new http();
        httpRequest request = new httpRequest();
        request.setMethod('GET');
        request.setEndpoint('https://oscaritsolutions30-dev-ed.develop.my.salesforce.com/services/apexrest/out_product/'+productId);
        request.setHeader('Authorization','Bearer ' + accessToken);
        request.setHeader('Content-Type','application/json');
        
        system.debug('Request - '+request);
        httpResponse response = new httpResponse();
        try { response = protocol.send(request); }
        catch(exception e){ system.debug('Error - ' + e); }
        system.debug('Response - '+response.getBody());
        outProductController.productResponseWrap pr = (outProductController.productResponseWrap) json.deserialize(response.getBody(), outProductController.productResponseWrap.class);
    	return pr;
    }
    
    
}