import { LightningElement } from 'lwc';
import runBatchOnce from '@salesforce/apex/MailingSchedulerController.runBatchOnce';
import scheduleBatch from '@salesforce/apex/MailingSchedulerController.scheduleBatch';
import abortBatch from '@salesforce/apex/MailingSchedulerController.abortBatch';

export default class ScheduleMailingLWC extends LightningElement {
    buttonClicked;
    batchName = 'BirthdayBatch';
    schedulerName = 'BirthdayEmailScheduler';
    cronExp = '';

    get cssClass(){
        return this.buttonClicked ? 'slds-float_right slds-button slds-button_destructive slds-var-m-around_xx-small' : 'slds-float_right slds-button slds-button_brand slds-var-m-around_xx-small';
    }

    get batchBtnLabel() {
        return this.buttonClicked ? 'Abort Batch' : 'Schedule Batch';
    }

    handleCronChange(event){
        this.cronExp = event.target.value;
    }

    scheduleBatch() { 
        this.buttonClicked = !this.buttonClicked;
        console.log(this.cronExp);
        if (this.buttonClicked) {
            scheduleBatch({
                cronExp: this.cronExp,
                batchName: this.batchName,
                schedulerName: this.schedulerName
            }).then(result => {
                console.log(result);
            })
        } else {
            alert('Abort');
            abortBatch({
                schedulerName: this.schedulerName
            }).then(result => {
                alert('Aborted');
                console.log(result);
            })
        }
    }

    runOnce() { 
        runBatchOnce({
            batchName: this.batchName
        }).then(result => {
            console.log(result);
        })
    }
}