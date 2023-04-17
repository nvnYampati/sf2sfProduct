@RestResource(urlMapping = '/outProductList/*')
global class outProductListManager {
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
    
     public class productListWrap{
        public productListWrap(){}
        @AuraEnabled 
        public List<productWrap> pwList {get;set;}
        
        public productListWrap(List<productWrap> paramList){
            this.pwList = paramList;
        }
    }
    
    @HttpGet
    global static list<productWrap> getProductList(){
        list<productWrap> pwList = new list<productWrap>();
        for(TestObj__c record : [SELECT Name, Id, Description__c, Price__c FROM TestObj__c] ){
            productWrap pw = new productWrap(record);
            system.debug(pw);
        }
        return pwList;
    }
}