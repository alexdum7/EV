@isTest
public class EV_AttendeesServiceTest{

    @TestSetup
    static void makeData(){
        
        Event__c event = new Event__c(
            Name='test Event');
        insert event;

        Ticket__c ticket = new Ticket__c(
            Event__c = event.Id,
            NumberOfTickets__c = 10
        );
        insert ticket;
    }

    @IsTest
    static void testTicketUpdate(){

        Event__c event = [SELECT Id FROM Event__c LIMIT 1];
        Ticket__c ticket = [SELECT Id FROM Ticket__c LIMIT 1];

        test.startTest();

        Attendee__c attendee = new Attendee__c(
            Event__c = event.Id, 
            LastName__c = 'test', 
            Email__c = 'test@test.com',
            TicketString__c = ticket.Id + ':2');
        insert attendee;

        test.stoptest();

        Ticket__c ticketResult = [SELECT Id, TicketsSold__c, TicketsLeft__c FROM Ticket__c WHERE Id =: ticket.Id];
        system.assertEquals(ticketResult.TicketsSold__c, 2);
        system.assertEquals(ticketResult.TicketsLeft__c, 8);

    }

    @IsTest
    static void testContactUpsert(){

        Event__c event = [SELECT Id FROM Event__c LIMIT 1];

        test.startTest();

        Attendee__c attendee = new Attendee__c(
            Event__c = event.Id,
            FirstName__c = 'alex', 
            LastName__c = 'test', 
            Email__c = 'test@test.com');
        insert attendee;

        test.stoptest();

        List<Contact> cnt = [SELECT Id, FirstName, LastName FROM Contact WHERE Email =: attendee.Email__c];
        if (cnt.size() != 0){

            system.assertEquals(cnt.get(0).LastName, 'test');
            system.assertEquals(cnt.get(0).FirstName, 'alex');

            Attendee__c attendee2 = new Attendee__c(
                Event__c = event.Id,
                FirstName__c = 'test', 
                LastName__c = 'test', 
                Email__c = 'test@test.com');
            insert attendee2;

            List<Contact> cnt2 = [SELECT Id, FirstName, LastName FROM Contact WHERE Email =: attendee.Email__c];

            system.assertEquals(cnt2.get(0).LastName, 'test');
            system.assertEquals(cnt2.get(0).FirstName, 'test');

        }

    }

}