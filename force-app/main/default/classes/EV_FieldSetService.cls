/*
* @author Alex D
* @date July 2020
* @description returns fields to be shown in the View Attednees service, based on field set
*/
public class EV_FieldSetService {

    public static List<FieldSetProperties> getFieldFromFieldSet(String objApi, String fieldSetName){
        List<FieldSetProperties> lstOfWrapper = new List<FieldSetProperties>();
        
        
        Schema.SObjectType sObjType = Schema.getGlobalDescribe().get(objApi);
        Schema.DescribeSObjectResult desSObjRslt = sObjType.getDescribe();            
        Schema.FieldSet fieldSetIns = desSObjRslt.FieldSets.getMap().get(fieldSetName);

        for( Schema.FieldSetMember fieldSetMember : fieldSetIns.getFields() ){
            FieldSetProperties wrapperIns = new FieldSetProperties();
            
            wrapperIns.label = String.valueOf(fieldSetMember.getLabel()); 
            wrapperIns.fieldName = String.valueOf(fieldSetMember.getFieldPath()); 
            wrapperIns.type = String.valueOf(fieldSetMember.getType()).toLowerCase();
            
            lstOfWrapper.add(wrapperIns);
        }        

        RowAction action = new RowAction();
        action.label = 'View Details';
        action.name = 'ViewDetails';
        TypeAttribute attribute = new TypeAttribute();
        attribute.rowActions.add(action);
        FieldSetProperties property = new FieldSetProperties();
        property.type = 'action';
        property.typeAttributes = attribute;
        lstOfWrapper.add(property);

        
        return lstOfWrapper;
    }

    public class FieldSetProperties{
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String fieldName;
        @AuraEnabled
        public String type;
        @AuraEnabled
        public TypeAttribute typeAttributes;
    }

    public class TypeAttribute{
        @AuraEnabled
        public List<RowAction> rowActions = new List<RowAction>();
    }

    public class RowAction{
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String name;
    }

}