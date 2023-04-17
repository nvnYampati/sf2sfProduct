public class outProductManager {
	//sf2sf__mdt sf2Cred = sf2sf__mdt.getInstance('PIDMS_Org');
	
    public class ATWrap{
        public String id;
        public String access_token;
    }
    
    public static string getAccessTokenUser(){
        sf2sf__mdt sf2Cred = sf2sf__mdt.getInstance('PIDMS_Org');
        
        final string consumerKey = sf2Cred.consumerKey__c;
		final string consumerSecret = sf2Cred.consumerSecret__c;
    	final string endPointUrl = 'https://oscaritsolutions30-dev-ed.develop.my.salesforce.com/services/oauth2/token';
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
        Access_Token__c ac = new Access_Token__c( name = sf2Cred.username__c+' 3', Access_Token__c = resAt.access_token );
        insert ac;
        system.debug('Access Token record - '+ac);
        return resAt.access_token;
    }
    
        public static string getAccessTokenCred(){
        sf2sf__mdt sf2Cred = sf2sf__mdt.getInstance('PIDMS_Org');
        
        final string consumerKey = sf2Cred.consumerKey__c;
		final string consumerSecret = sf2Cred.consumerSecret__c;
    	final string endPointUrl = 'https://oscaritsolutions30-dev-ed.develop.my.salesforce.com/services/oauth2/token';
    	
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
        Access_Token__c ac = new Access_Token__c( name = sf2Cred.username__c+' cred', Access_Token__c = resAt.access_token );
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
    
    @future(callout = true)
    public static void getInAProductList(){		
        string accessToken = '00D2w00000Ks6lf!ASAAQHRVsfEZHop48Oy0YXPyOgUNHzsB.ef_p7Q.DtAkHnJ91dKLiLbqWR7a2JMiH7VYZvLm7Z8aBKWC_7AHOVe607c_wRfH';
        http protocol = new http();
        httpRequest request = new httpRequest();
        request.setMethod('GET');
        request.setEndpoint('https://oscaritsolutions30-dev-ed.develop.my.salesforce.com/services/apexrest/outProductList');
        request.setHeader('Authorization','Bearer ' + accessToken);
        request.setHeader('Content-Type','application/json');
        
        system.debug('Request - '+request);
        httpResponse response = new httpResponse();
        try { response = protocol.send(request); }
        catch(exception e){ system.debug('Error - ' + e); }
        string responseString = response.getBody();
        system.debug('Response string - '+ responseString);
        //List<productResponseWrap> prList = new List<productResponseWrap>();
        //prList = ( List<productResponseWrap> ) json.deserialize( responseString , List<productResponseWrap>.class );
        list<object> objList = (list<object>)json.deserializeUntyped(responseString);
        system.debug('Response list - ');
        //handleWrapList(prList);
        for(object pr : objList){
            system.debug(pr);
        }
    }

    public static void handleWrapList(List<productResponseWrap> prList){
        system.debug('Wrapper is - ');
        for(productResponseWrap pr : prList){
            system.debug(pr);
        }
    }
        
    @future(callout = true)
    public static void getInAProduct(id productId){		// testing ID a012w00001CrsXCAAZ
        string accessToken = '00D2w00000Ks6lf!ASAAQHRVsfEZHop48Oy0YXPyOgUNHzsB.ef_p7Q.DtAkHnJ91dKLiLbqWR7a2JMiH7VYZvLm7Z8aBKWC_7AHOVe607c_wRfH';
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
        productResponseWrap pr = (productResponseWrap) json.deserialize(response.getBody(), productResponseWrap.class);
        //system.debug('Response - '+pr);
    }
    
     @future(callout = true)
    public static void regInAProduct(string Name, decimal Dec ){		// testing ID a012w00001CrsXCAAZ
        string accessToken = '00D2w00000Ks6lf!ASAAQHRVsfEZHop48Oy0YXPyOgUNHzsB.ef_p7Q.DtAkHnJ91dKLiLbqWR7a2JMiH7VYZvLm7Z8aBKWC_7AHOVe607c_wRfH';
        http protocol = new http();
        httpRequest request = new httpRequest();
        request.setMethod('POST');
        request.setEndpoint('https://oscaritsolutions30-dev-ed.develop.my.salesforce.com/services/apexrest/out_product');
        request.setHeader('Authorization','Bearer ' + accessToken);
        request.setHeader('Content-Type','application/json');
        string jsonBody = '{"Name":"'+Name+'", "Description":"test description from oscarit52-dev", "Price":"'+Dec+'"}';
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

    
 	/*final string consumerKey = '3MVG9n_HvETGhr3D51Cy4uFq0T84awbKgubQV0nml_lvHVW42S_.rAYWHU2TYjqKzaJeP5dM_XrFWcopV.Jzx	';//sf2Cred.consumerKey__c;
	final string consumerSecret ='0205EF139ED75FEF5A9F06B747B2F2DB049850BEE71BC934265C1F33DC7479E8'; //sf2Cred.consumerSecret__c;
    final string endPointUrl = '';//'https://oscarit52-dev-ed.develop.my.salesforce.com/services/oauth2/token';
    final string username = 'nav.pidms.dev1@oscar.com';//sf2Cred.username__c;
    final string password = 'deadmau5fiQPINX2cp2Ps1Ry596kyTx1';//sf2Cred.password__c + sf2Cred.securityToken__c; 
	string accessToken = '00D2w00000Ks6lf!ASAAQOJ3Mc4OPQjvRpRfpMkcUdDUG0m4JOOKA0FDnbziQutgSWlyqEwfE1u964OQ39y5U4aMtAkxU8F7.tjeF0jKIoTVSxQ6';
*/