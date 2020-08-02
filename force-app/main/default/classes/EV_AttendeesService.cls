/*
* @author Alex D
* @date July 2020
* @description Handler class for the Attendee trigger
*/
public with sharing class EV_AttendeesService{

    public static void updateTickets(List<Attendee__c> newList){

        Map<Id, Integer> usedTickets = new Map<Id, Integer>();
        Set<Id> eventSet = new Set<Id>();
        Map<Id, Attendee__c> attendeeMap = new Map<Id, Attendee__c>();
        //get Ticket info
        for (Attendee__c attendee : newList){
            if (attendee.TicketString__c != null){
                for (String s : attendee.TicketString__c.split(',')){
                    usedTickets.put(s.split(':').get(0), Integer.valueOf(s.split(':').get(1)));
                    attendeeMap.put(s.split(':').get(0), attendee);
                }
                eventSet.add(attendee.Event__c);
            }
        }

        if (eventSet.size() != 0){

            //update tickets remaining based on current attendee's selections
            List<Ticket__c> ticketsToUpdate = new List<Ticket__c>();
            for (Ticket__c ticket : [SELECT Id, TicketsLeft__c, TicketsSold__c FROM Ticket__c WHERE Event__c IN : eventSet]){
                if (ticket.TicketsSold__c == null)
                    ticket.TicketsSold__c = 0;
                if (usedTickets.containsKey(ticket.Id)){
                    if (ticket.TicketsLeft__c >= usedTickets.get(ticket.Id)){
                        ticket.TicketsSold__c += usedTickets.get(ticket.Id);
                        ticketsToUpdate.add(ticket);
                    }
                    else if (attendeeMap.containsKey(ticket.Id))
                        attendeeMap.get(ticket.Id).addError('There is an issue with the number of tickets. Please contact Support');

                }
                    
            }

            update ticketsToUpdate;

        }

    }

    public static void manageContacts(List<Attendee__c> newList){

        Map<String, Set<Id>> emailMap = new Map<String, Set<Id>>();
        for (Attendee__c attendee : newList){
            if (!emailMap.containsKey(attendee.Email__c))
                emailMap.put(attendee.Email__c, new Set<Id>{attendee.Id});
            else 
                emailMap.get(attendee.Email__c).add(attendee.Id);
        }

        if (emailMap.keySet().size() != 0){
            //get existing contacts by attendee email
            Map<String, Contact> contactByEmail = new Map<String, Contact>();
            Set<String> emailSet = new Set<String>();
            emailSet = emailMap.keySet();
            String contactQuery = 'SELECT Id, Email';
            for (Attendee_To_Contact_fields__mdt mdt : [SELECT Id, ContactAPIName__c FROM Attendee_To_Contact_fields__mdt])
                contactQuery += ', ' + mdt.ContactAPIName__c;
            contactQuery += ' FROM Contact WHERE Email IN : emailSet';
            for (Contact cnt : database.query(contactQuery)){
                contactByEmail.put(cnt.Email, cnt);
            }

            List<Contact> contactsToUpsert = new List<Contact>();
            Set<Id> attendeeSet = new Set<Id>();
            for (Attendee__c attendee : newList){
                Contact cnt;
                //if contacts does not exist
                if (!contactByEmail.containsKey(attendee.Email__c)){
                    cnt = new Contact(Email = attendee.Email__c);
                    contactByEmail.put(cnt.Email, cnt);
                }
                //if contact exists
                else
                    cnt = contactByEmail.get(attendee.Email__c);
                
                //upsert contact fields based on custom metadata type
                for (Attendee_To_Contact_fields__mdt mdt : [SELECT Id, ContactAPIName__c, AttendeeAPIName__c FROM Attendee_To_Contact_fields__mdt])
                    cnt.put(mdt.ContactAPIName__c, attendee.get(mdt.AttendeeAPIName__c));
                contactsToUpsert.add(cnt);
                attendeeSet.add(attendee.Id);
            }

            upsert contactsToUpsert;

            //parent new attendees after contact gets created
            List<Attendee__c> attendeesToUpdate = new List<Attendee__c>();
            for (Attendee__c attendee : [SELECT Id, Email__c, Contact__c FROM Attendee__c WHERE Id IN : attendeeSet]){
                if (contactByEmail.containsKey(attendee.Email__c)){
                    attendee.Contact__c = contactByEmail.get(attendee.Email__c).Id;
                    attendeesToUpdate.add(attendee);
                }
            }

            update attendeesToUpdate;
        }

    }

}