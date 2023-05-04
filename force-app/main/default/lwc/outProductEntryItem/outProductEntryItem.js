import { LightningElement, api } from 'lwc';
import getOutProd from '@salesforce/apex/opLwcController.getOutProduct';

export default class OutProductEntryItem extends LightningElement {
    @api recordItem;
    error;
    extRec={};

    handleItemClick(){
        var prodRecord;
        getOutProd({productId : this.recordItem.Record_Id__c }).then(
            (result)=>{
                prodRecord = result;
                this.extRec = result
            }
        ).catch(
            (error)=>{
                this.error = error;
            }
        ).finally(
            console.log('- sa -'+JSON.stringify(this.extRec)+' - '+ this.extRec )
        );

        this.dispatchEvent(
            new CustomEvent(
                'itemselect', {
                    detail: {
                        value : this.extRec
                    }
                }
            )
        );
    }
}