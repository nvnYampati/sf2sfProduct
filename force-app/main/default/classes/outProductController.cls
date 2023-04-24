@RestResource(urlMapping='/out_product/*')
global class outProductController {
    
    global class productWrap{
        public productWrap(){}
         @AuraEnabled
        public string Name {get;set;}
         @AuraEnabled
        public string Description {get;set;}
         @AuraEnabled
        public decimal Price {get;set;}
         @AuraEnabled
        public id id {get;set;}
        
        public productWrap( TestObj__c product){
            this.Name = product.Name;
            this.Description = product.Description__c;
            this.Price = product.Price__c;
            this.id = product.Id;
        }
    }
    
    @HttpGet
    global static productWrap getProduct() { 
        RestRequest request = RestContext.request;
        system.debug(request.requestURI);
        String productId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
         system.debug('productId '+productId);
        TestObj__c product = [SELECT Id, Name, Description__c, Price__c FROM TestObj__c WHERE Id =: productId];
        //map<string, string> paramMap = (map<string, string>)json.deserializeUntyped(request.params.toString());
        //system.debug(paramMap);
		productWrap pw = new productWrap( product );
        return pw;
    }
    
    @HttpPost
    global static id regProduct(string Name, string Description, decimal Price) { 
        TestObj__c product = new TestObj__c( Name = Name, Description__c = Description, Price__c = Price );
        insert product;
        RestRequest req = RestContext.request; 
        RestResponse res = RestContext.response;
        system.debug('RestRequest'+req);
        system.debug('RestResponse'+res);
		productWrap pw = new productWrap( product );
        system.debug(pw);
        return product.Id;
    }
    
}