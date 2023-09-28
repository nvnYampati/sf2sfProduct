public class outProductProviderManager {

    public class ATWrap{
        public String id;
        public String access_token;
    }
    
    public static string getAccessTokenUser(){				// working and not recommended flow
        sfTosf__mdt sf2Cred = sfTosf__mdt.getInstance('Dev1_Org');
        
        final string consumerKey = sf2Cred.consumerKey__c;
		final string consumerSecret = sf2Cred.consumerSecret__c;
    	final string endPointUrl = 'https://oscarit52-dev-ed.develop.my.salesforce.com/services/oauth2/token';
    	final string username = sf2Cred.username__c;
    	final string password = sf2Cred.password__c + sf2Cred.securityToken__c;
        
        http protocol = new http();
        httpRequest request = new httpRequest();
        request.setEndpoint(endPointUrl);
        request.setMethod('GET');
        string body = 'grant_type=password'+'&client_id='+consumerKey+'&client_secret='+consumerSecret+'&username='+username+'&password='+password;
        request.setBody(body);
        system.debug(request.getBody());
        
        httpResponse response = protocol.send(request); 
        system.debug('Response body - ' + response.getBody());
        ATWrap resAt = (ATWrap)json.deserialize(response.getBody(), ATWrap.class);
        system.debug('Response wrap - ' + resAt);
        system.debug('access token - ' + resAt.access_token);
        Access_Token__c ac = new Access_Token__c( name = sf2Cred.username__c, Access_Token__c = resAt.access_token );
        insert ac;
        system.debug('Access Token record - '+ac);
        return resAt.access_token;
    }
    
	public static string getAccessTokenCred(){			//working and recommended flow
        sfTosf__mdt sf2Cred = sfTosf__mdt.getInstance('Dev1_Org');
        
        final string consumerKey = sf2Cred.consumerKey__c;
		final string consumerSecret = sf2Cred.consumerSecret__c;
    	final string endPointUrl = 'https://oscarit52-dev-ed.develop.my.salesforce.com/services/oauth2/token';
    	
        http protocol = new http();
        httpRequest request = new httpRequest();
        request.setEndpoint(endPointUrl);
        request.setMethod('GET');
        string body = 'grant_type=client_credentials'+'&client_id='+consumerKey+'&client_secret='+consumerSecret;
        request.setBody(body);
        system.debug(request.getBody());
        
        httpResponse response = protocol.send(request); 
        system.debug('Response body - ' + response.getBody());
        ATWrap resAt = (ATWrap)json.deserialize(response.getBody(), ATWrap.class);
        system.debug('Response wrap - ' + resAt);
        system.debug('access token - ' + resAt.access_token);
        Access_Token__c ac = new Access_Token__c( name = sf2Cred.username__c+'cred', Access_Token__c = resAt.access_token );
        //ac.Name += ' credential';
        try{insert ac;}catch(exception e){ system.debug('Duplicate Token received, do not request again, use the latest token');}
        system.debug('Access Token record - '+ac);
        return resAt.access_token;
    }
    
    public class productResponseWrap{
        public productResponseWrap(){}
         @AuraEnabled
        public string Name {get;set;}
         @AuraEnabled
        public string Description {get;set;}
         @AuraEnabled
        public decimal Price {get;set;}
         @AuraEnabled
        public id id {get;set;}
    }
    
     @future(callout = true)		//	to register Product Ids into another Org, uses user auth flow
    public static void regInAProduct(string orgName, string Name, Id recId ){		// helper method 
		string orgNameStr = '%'+orgName;
        string accessToken = [SELECT Id, Name, Access_Token__c, CreatedDate FROM Access_Token__c WHERE Name LIKE :orgNameStr ORDER BY CreatedDate DESC NULLS LAST LIMIT 1].Access_Token__c;
        http protocol = new http();
        httpRequest request = new httpRequest();
        request.setMethod('POST');
        request.setEndpoint('https://oscarit52-dev-ed.develop.my.salesforce.com/services/apexrest/registerAProduct/');
        request.setHeader('Authorization','Bearer ' + accessToken);
        request.setHeader('Content-Type','application/json');
        string jsonBody = '{"Name":"'+Name+'", "recordId":"'+recId+'"}';
        system.debug(jsonBody);
        request.setBody(jsonBody);
        system.debug('Request - '+request);
        httpResponse response = new httpResponse();
        try { response = protocol.send(request); }
        catch(exception e){ system.debug('Error - ' + e); }
        system.debug('Response - '+response.getBody());
        productResponseWrap pr = (productResponseWrap) json.deserialize(response.getBody(), productResponseWrap.class);
        system.debug('Response - '+pr);
    }
    
     @future(callout = true)	// named credential flow	//	to register Product Ids into another Org
    public static void regInAProductNamed( string Name, Id recId ){		// helper method 
        http protocol = new http();
        httpRequest request = new httpRequest();
        request.setMethod('POST');
        request.setEndpoint('callout:Dev1OrgNameCred/services/apexrest/registerAProduct');
        request.setHeader('Content-Type','application/json');
        string jsonBody = '{"Name":"'+Name+'", "recordId":"'+recId+'"}';
        system.debug(jsonBody);
        request.setBody(jsonBody);
        system.debug('Request - '+request);
        httpResponse response = new httpResponse();
        try { response = protocol.send(request); }
        catch(exception e){ system.debug('Error - ' + e); }
        system.debug('Response - '+response.getBody());
        productResponseWrap pr = (productResponseWrap) json.deserialize(response.getBody(), productResponseWrap.class);
        system.debug('Response - '+pr);
    }
}
