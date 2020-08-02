/*
* @author Alex D
* @date July 2020
* @description View Attendees js controller
*/
({
	doInit : function(component, event, helper) {
		
		//get attendees for current event
		var action = component.get("c.getAttendees");
        action.setParams({
            objApi : 'Attendee__c',
			fieldSetName : 'AttendeeModalSet',
			eventId : component.get("v.recordId") 
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
				component.set("v.columns", response.getReturnValue().lstOfFieldLabels);
				console.log('columns', response.getReturnValue().lstOfFieldLabels)
				component.set("v.attendees", response.getReturnValue().lstOfSObjs);  
				component.set("v.allAttendees", response.getReturnValue().lstOfSObjs); 
				component.set("v.recordCount", response.getReturnValue().lstOfSObjs.length);
            }
        });
		$A.enqueueAction(action);
		
		component.set("v.showSection", 'Attendees');

	},

	//refresh attendees based on search
	refreshAttendees : function(component, event, helper){

		component.set("v.attendees", event.getParam("attendeeList"));

	},

	//create new attendee
	newAttendee : function(component, event, helper){

		component.set("v.showSection", 'Tickets');

	},

	closeModal : function() {
		
		$A.get("e.force:closeQuickAction").fire();

	},

	//select row action
	actionSelect : function(component, event, handler){

		var row = event.getParam("row");
		if (event.getParam("action").name == 'ViewDetails')
			window.open('/' + row.Id);

	}
})