/*
* @author Alex D
* @date July 2020
* @description Attendee trigger
*/
trigger EV_OnAttendees on Attendee__c (before insert, before update, before delete, after delete, after insert, after update) {

    if (trigger.isAfter){

        if (trigger.isInsert){

            //update tickets remaining based on attendee selection
            EV_AttendeesService.updateTickets(trigger.new);

            //link attendee to existinf contact / create new contacts
            EV_AttendeesService.manageContacts(trigger.new);

        }

    }

}