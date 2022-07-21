import { LightningElement } from 'lwc';

export default class ScheduleMailingLWC extends LightningElement {
    message = '';
    buttonClicked;

    get cssClass(){
        return this.buttonClicked ? 'slds-float_right slds-button slds-button_destructive slds-var-m-around_xx-small' : 'slds-float_right slds-button slds-button_brand slds-var-m-around_xx-small';
    }

    get batchBtnLabel() {
        return this.buttonClicked ? 'Abort Batch' : 'Schedule Batch';
    }

    scheduleBatch() { 
        this.buttonClicked = !this.buttonClicked;
    }

    runOnce() { 
        
    }
}