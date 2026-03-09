' check that a manager identity has been selected
If Not String.IsNullOrWhiteSpace(Convert.ToString(Value)) Then
	Dim objPerson = Session.Source.Get(Of Person)(Convert.ToString(Value), EntityLoadType.ReadOnly)
	
    ' selected manager is from LegacyHR
    If objPerson.ImportSource.ToString.Equals("legacyHR") Then
        ' activate parameter for legacy company
        ParameterSet("legacyCompany").IsReadOnly = False ' activate
        ParameterSet("legacyCompany").Value = objPerson.CCC_UID_LegacyCompany ' select manager's company as default value
        ParameterSet("legacyCompany").IsMandatory = True ' make mandatory
        ParameterSet("legacyCompany").Description = Nothing ' remove description
        
        ' deactivate parameter for modern company
        ParameterSet("modernCompany").IsReadOnly = True ' deactivate
        ParameterSet("modernCompany").IsMandatory = False ' not mandatory, because it cannot be set
        ParameterSet("modernCompany").Value = "" ' remove any previously assigned values
        ParameterSet("modernCompany").Description = "Companies from ModernHR cannot be selected because a manager from LegacyHR was selected"
    
    ' selected manager is from ModernHR
    Else If objPerson.ImportSource.ToString.Equals("modernHR") Then
        ' set OtherCompanyDepartment value, set to mandatory and editable
        ParameterSet("modernCompany").IsReadOnly = False
        ParameterSet("modernCompany").Value = objPerson.CCC_UID_DepartmentOtherCompany
        ParameterSet("modernCompany").IsMandatory = True
        ParameterSet("modernCompany").Description = Nothing
        
        ' set unused parameter to not mandatory and readonly, remove value
        ParameterSet("legacyCompany").IsReadOnly = True
        ParameterSet("legacyCompany").IsMandatory = False
        ParameterSet("legacyCompany").Value = ""
        ParameterSet("legacyCompany").Description = "Companies from LegacyHR cannot be selected because a manager from ModernHR was selected"

    ' other import source
    Else
        ' throw exception -> reverts value to previously selected manager (or empty if no manager was selected previously)
        Throw New ViException("Manager must be from LegacyHR or ModernHR.")
    End If
End If