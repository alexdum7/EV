/*
* @author Alex D
* @date July 2020
* @description Choose Tickets js controller
*/
({
	doInit : function(component, event, helper) {
		
		component.set("v.showError", false);

	},

	Save : function(component, event, helper){

		var tickets = component.get("v.tickets");
		var ticketMap = component.get("v.ticketMap");
		var totalTickets = 0;
		
		//get tickets selected
		tickets.forEach(record => {
			
			if (ticketMap[record.Id] > record.TicketsLeft__c){
				component.set("v.errorMessage", ' There are only ' + record.TicketsLeft__c + ' ' + record.Name + ' tickets left');
				component.set("v.showError", true);
			}
			totalTickets = totalTickets + ticketMap[record.Id];
		});

		//error handling
		if (totalTickets == 0){
			component.set("v.errorMessage", 'You haven\'t selected any tickets');
			component.set("v.showError", true);
		}

		//open new attendee modal with predefined fields
		if (component.get("v.showError") === false){
			var createRecordEvent = $A.get("e.force:createRecord");
			var ticketMap = component.get("v.ticketMap");
			var ticketString = '';
			for(var key in ticketMap){
				ticketString = ticketString + key + ":" + ticketMap[key] + ",";
			}
			helper.closeModal();
			createRecordEvent.setParams({
				"entityApiName": "Attendee__c",
				"recordTypeId": component.get("v.attendeeRTypeId"),
				"defaultFieldValues": {
					'Event__c' : component.get("v.eventId"),
					'TicketString__c' : ticketString
				},
				"navigationLocation": "RELATED_LIST"
			});
			createRecordEvent.fire();

			
		}

	},

	closeModal : function(component, event, helper){

		helper.closeModal();

	}
})