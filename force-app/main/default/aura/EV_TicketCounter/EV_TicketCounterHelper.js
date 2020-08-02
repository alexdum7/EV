/*
* @author Alex D
* @date July 2020
* @description Ticket Counter js helper js controller
*/
({
	registerCount : function(component, event, helper, ticketId, ticketCount) {
		
		//pass ticket count to parent
		var event = component.getEvent("counterEvent");
		var ticketId = ticketId;

		if (ticketCount == null)
			ticketCount = 0;
		event.setParams({
			"ticketId" : ticketId,
			"ticketCount" : ticketCount
			});

		event.fire();

	}
})