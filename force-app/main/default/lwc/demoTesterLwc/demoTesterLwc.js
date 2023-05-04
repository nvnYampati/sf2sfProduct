import { LightningElement, wire } from 'lwc';
import getRegProd from '@salesforce/apex/opLwcController.getRegList'; 

export default class DemoTesterLwc extends LightningElement {
    recordList=[];
    error;
    //@wire(getRegProd,{})recordList;
    @wire(getRegProd,{})wiredData({data, error}){
        if(data){
            this.recordList = JSON.parse(JSON.stringify(data));
            this.error = undefined;
            console.log('from DemoTesterLwc '+ JSON.stringify(this.recordList) ); 
        }
        else if(error){
            this.recordList = undefined;
            this.error = error;
            console.log('error from DemoTesterLwc '+JSON.stringify(this.error));
        }
    };
}