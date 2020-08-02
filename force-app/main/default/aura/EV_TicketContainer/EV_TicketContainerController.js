/*
* @author Alex D
* @date July 2020
* @description Client Side controller for the Container component
*/
({
	doInit : function(component, event, helper) {
		
		//query tickets for the current event
		var ticketMap = component.get("v.ticketMap");
		var action = component.get("c.getTickets");
		action.setParams({ eventId : component.get("v.recordId") });
		action.setCallback(this, function(response){
			if (response.getState() == "SUCCESS"){
				var tickets = response.getReturnValue();
				component.set("v.tickets", tickets.ticketList);
				tickets.ticketList.forEach(record => {
					ticketMap[record.Id] = 0;
				});
				component.set("v.ticketMap", ticketMap);
				component.set("v.attendeeRTypeId", tickets.AttendeeRTypeId);
			}
		})
		$A.enqueueAction(action);

		

	},

	//register selected tickets
	registerTicketCounter : function(component, event, helper){

		var tickets = component.get("v.tickets");
		var ticketMap = component.get("v.ticketMap");
		tickets.forEach(record => {
			var ticketId = event.getParam("ticketId");
			var ticketCount = event.getParam("ticketCount");
			ticketMap[ticketId] = ticketCount;
			component.set("v.ticketMap", ticketMap);
		});
		component.set("v.showError", false);
		
	}
})