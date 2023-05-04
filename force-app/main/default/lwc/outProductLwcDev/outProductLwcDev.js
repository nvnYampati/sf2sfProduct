import { LightningElement, wire } from 'lwc';
import getTokenStr from '@salesforce/apex/opLwcController.getToken';
import refreshToken from '@salesforce/apex/opLwcController.refreshTokenCaller';
import getRegProd from '@salesforce/apex/opLwcController.getRegList'; 

export default class OutProductLwcDev extends LightningElement {
    error;
    tokenStr = '';
    endPUrl = 'https://oscaritsolutions30-dev-ed.develop.my.salesforce.com/services/apexrest/out_product/';
    regProdList =[];
    selectedItem ={};
    isTrue = true;

    @wire(getRegProd)regProdList;
    // @wire(getRegProd, {})wiredData({error, data}){
    //     if(data){
    //         this.regProdList = data;
    //         error = undefined;
    //         console.log('records');
    //         console.log(this.regProdList);
    //     }else if(error){
    //         this.error = error;
    //         this.regProdList = [];
    //         console.log(this.error);
    //     }
    // };

    connectedCallback(){
        getTokenStr().then(
            (data)=>{
                this.tokenStr = data;
            }
        ).catch(
            (error)=>{this.error = error;}
        ).finally();

        console.log('wuss connected - '+this.tokenStr);
    }

    refreshAccess(){
        refreshToken();
    }

    handleItemSelect(event){
        this.selectedItem = event.detail.value;
        console.log('From OutProductLwcDev - event value - '+ JSON.stringify(this.selectedItem) );
    }
}


/*fetch(
            endUrl, {
                method : GET_METHOD,
                headers : {
                    'Authorization' : authTok,
                    'Content-Type' : 'application/json'
                }
            }
        ).then(
            (data)=>{
                this.endData = data;
                console.log(json.stringify(data));
            }
        ).catch(
            (error)=>{ this.error = error; }
        ).finally();*/