@isTest
public class EV_TicketsControllerTest{

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
    static void testTicketQuery(){

        Event__c event = [SELECT Id FROM Event__c LIMIT 1];

        test.startTest();

        EV_TicketsController.InitializationWrapper wrap = EV_TicketsController.getTickets(event.Id);

        test.stopTest();

         system.assertEquals(wrap.ticketList.get(0).NumberOfTickets__c, 10);

    }

}