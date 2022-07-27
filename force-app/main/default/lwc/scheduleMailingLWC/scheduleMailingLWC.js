import { LightningElement, wire } from 'lwc';
import runBatchOnce from '@salesforce/apex/MailingSchedulerController.runBatchOnce';
import scheduleBatch from '@salesforce/apex/MailingSchedulerController.scheduleBatch';
import abortBatch from '@salesforce/apex/MailingSchedulerController.abortBatch';
import checkSchedulerStatus from '@salesforce/apex/MailingSchedulerController.checkSchedulerStatus';

export default class ScheduleMailingLWC extends LightningElement {
    buttonClicked;
    batchName = 'BirthdayBatch';
    schedulerName = 'BirthdayEmailScheduler';
    cronExp = '';
    isScheduled = false;

    get cssClass(){
        return this.buttonClicked ? 'slds-float_right slds-button slds-button_destructive slds-var-m-around_xx-small' : 'slds-float_right slds-button slds-button_brand slds-var-m-around_xx-small';
    }

    get batchBtnLabel() {
        return this.buttonClicked ? 'Abort Batch' : 'Schedule Batch';
    }

    @wire(checkSchedulerStatus, {schedulerName: '$schedulerName'})
    status({data, error}) {
        if(data) {
            console.log(data);
            this.isScheduled = data.status;
            this.buttonClicked = this.isScheduled;
            if (this.isScheduled) {
                this.cronExp = data.cronexp;
            }
        }
        if (error) {
            console.log('An error has occurred:');
            console.log(error);
        }
    }

    handleCronChange(event){
        this.cronExp = event.target.value;
    }

    toggleBatch() { 
        console.log(this.cronExp);
        if (!this.buttonClicked) {
            this.scheduleBatch();
        } else {
            this.abortBatch();
        }
    }

    scheduleBatch() {
        const isInputsCorrect = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputField) => {
                inputField.reportValidity();
                return validSoFar && inputField.checkValidity();
            }, true);
        if (isInputsCorrect) {   
            scheduleBatch({
                cronExp: this.cronExp,
                batchName: this.batchName,
                schedulerName: this.schedulerName
            }).then(result => {
                console.log(result);
            })
            this.buttonClicked = !this.buttonClicked;
        }
    }

    abortBatch() {
        abortBatch({
            schedulerName: this.schedulerName
        }).then(result => {
            console.log(result);
            if (result == 'Job has been aborted successfully.') {
                this.buttonClicked = !this.buttonClicked;
            }
        })
    }

    runOnce() { 
        runBatchOnce({
            batchName: this.batchName
        }).then(result => {
            console.log(result);
        })
    }
}