/*
* @author Alex D
* @date July 2020
* @description Get attendees records for the View Attendees functionality
*/
public class EV_ViewAttendeesController {

    @AuraEnabled
    public static AttendeeDetails getAttendees(String objApi, String fieldSetName, String eventId){
        AttendeeDetails dataTableDtls = new AttendeeDetails();
        
        List<EV_FieldSetService.FieldSetProperties> lstOfFieldSetProperties = EV_FieldSetService.getFieldFromFieldSet(objApi, fieldSetName);
        
        //build dynamic query based on field set
        if(lstOfFieldSetProperties != null && lstOfFieldSetProperties.size() > 0){
            String strQuery = 'SELECT ';
            for(EV_FieldSetService.FieldSetProperties inst : lstOfFieldSetProperties){
                dataTableDtls.lstOfFieldLabels.add(inst);
                
                if (inst.fieldName != null)
                    strQuery = strQuery + inst.fieldName + ',';
            }
            if(!strQuery.equalsIgnoreCase('SELECT '))
                strQuery = strQuery + 'Id FROM ' + objApi;
            strQuery = strQuery + ' WHERE Event__c =: eventId ORDER BY LastName__c';

            dataTableDtls.lstOfSObjs = Database.query(strQuery);
        }

     return dataTableDtls;
    }
    
    
    public class AttendeeDetails{
        @AuraEnabled
        public List<sObject> lstOfSObjs = new List<sObject>();
        @AuraEnabled
        public List<EV_FieldSetService.FieldSetProperties> lstOfFieldLabels = new List<EV_FieldSetService.FieldSetProperties>();
    }

}