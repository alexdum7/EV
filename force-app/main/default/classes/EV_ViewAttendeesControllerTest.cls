@isTest
public class EV_ViewAttendeesControllerTest{

    @TestSetup
    static void makeData(){
        
        Event__c event = new Event__c(
            Name='test Event');
        insert event;

        Attendee__c attendee = new Attendee__c(
            Event__c = event.Id, 
            LastName__c = 'test', 
            Email__c = 'test@test.com');
        insert attendee;

    }

    @IsTest
    static void testAttendeeQuery(){
        
        Event__c event = [SELECT Id FROM Event__c LIMIT 1];

        Test.startTest();

        EV_ViewAttendeesController.AttendeeDetails att = EV_ViewAttendeesController.getAttendees('TrueEvents__attendee__c', 'TrueEvents__AttendeeModalSet', event.Id);

        Test.stopTest();

        system.assertEquals(((List<Attendee__c>)att.lstOfSObjs).get(0).LastName__c, 'test');


        
    }

}