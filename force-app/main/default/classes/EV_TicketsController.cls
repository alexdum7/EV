/*
* @author Alex D
* @date July 2020
* @description Ticket Container server side controller
*/
public class EV_TicketsController{

    @AuraEnabled
    public static InitializationWrapper getTickets(String eventId){

        List<Ticket__c> ticketList = new List<Ticket__c>();
        if (eventId != null)
            ticketList = [SELECT Id, NumberOfTickets__c, Name, TicketsLeft__c, TicketsSold__c 
                                          FROM Ticket__c WHERE Event__c =: eventId];
        
        String recTypeId = Schema.SObjectType.Attendee__c.getRecordTypeInfosByName().get('Admin').getRecordTypeId();

        return new InitializationWrapper(ticketList, recTypeId);

    }

    public class InitializationWrapper{
        @AuraEnabled
        public List<Ticket__c> ticketList {get;set;}
        @AuraEnabled
        public String AttendeeRTypeId {get;set;}

        public InitializationWrapper(List<Ticket__c> tList, String rType){
            this.ticketList = tList;
            this.AttendeeRTypeId = rType;
        }
    }

}