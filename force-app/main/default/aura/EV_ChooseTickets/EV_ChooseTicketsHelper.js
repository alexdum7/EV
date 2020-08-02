/*
* @author Alex D
* @date July 2020
* @description Choose Tickets js helper
*/
({
	closeModal : function() {
		
		$A.get("e.force:closeQuickAction").fire();

	}
})