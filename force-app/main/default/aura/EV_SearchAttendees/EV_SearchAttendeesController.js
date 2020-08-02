/*
* @author Alex D
* @date July 2020
* @description js controller for the Search Attendees functionality
*/
({
	handleChange : function(component, event, helper) {
		
		var att = component.get("v.attendee").toLowerCase();
		var allAttendees = component.get("v.attendees");
		var attendeeResults = [];
		if ((att != null) && (att != '')){
			allAttendees.forEach(item => {
				if (((item.FirstName__c != null) && (item.FirstName__c.toLowerCase().includes(att))) || 
				   ((item.LastName__c != null) && (item.LastName__c.toLowerCase().includes(att)))){
					attendeeResults.push(item);
				}
			});
		}
		else
			attendeeResults = allAttendees;


		var event = component.getEvent("refreshAttendees");
		event.setParams({
			"attendeeList" : attendeeResults
			});
		event.fire();

	}
})