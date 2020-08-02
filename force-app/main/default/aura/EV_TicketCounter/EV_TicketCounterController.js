/*
* @author Alex D
* @date July 2020
* @description Ticket counter js controller
*/
({

	doInit : function(component, event, helper) {

		//initializations
		component.set("v.incrementDisabled", "false");
		component.set("v.decrementDisabled", "true");
		component.set("v.ticketCount", 0);
		component.set("v.ticketsRemaining", 'There are ' + component.get("v.ticket.TicketsLeft__c") + ' remaining');

	},

	onIncrement : function(component, event, helper) {
		
		component.set("v.decrementDisabled", "false");
		var ticketCount = component.get("v.ticketCount");
		ticketCount = ++ticketCount;

		if (ticketCount > component.get("v.ticket.TicketsLeft__c"))
			component.set("v.incrementDisabled", "true");
		else
			component.set("v.ticketCount", ticketCount);

		helper.registerCount(component, event, helper, component.get("v.ticket.Id"), ticketCount);
		
		
	},

	onDecrement : function(component, event, helper) {

		var ticketCount = component.get("v.ticketCount");
		ticketCount = --ticketCount;

		if (ticketCount == -1)
			component.set("v.decrementDisabled", "true");
		else
			component.set("v.ticketCount", ticketCount);
		
		if ((ticketCount <= component.get("v.ticket.TicketsLeft__c")) && (component.get("v.incrementDisabled") === "true"))
			component.set("v.incrementDisabled", "false");

		helper.registerCount(component, event, helper, component.get("v.ticket.Id"), ticketCount);
		
	},

	onManualUpdate : function(component, event, helper){
		
		var ticketCount = component.get("v.ticketCount");
		var inputfield = event.getSource();

		if (ticketCount > component.get("v.ticket.TicketsLeft__c")){
			inputfield.setCustomValidity("There are " + component.get("v.ticket.TicketsLeft__c") + " tickets available"); 
			inputfield.reportValidity();
		}
		else{
			inputfield.setCustomValidity("");
		}
		if (ticketCount < 0){
			inputfield.setCustomValidity("Please enter a positive value"); 
			inputfield.reportValidity();
		}
		else{
			inputfield.setCustomValidity("");
		}
		
		helper.registerCount(component, event, helper, component.get("v.ticket.Id"), ticketCount);
	}
})