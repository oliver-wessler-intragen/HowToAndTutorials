# Request Parameter samples

Code samples, explanations, and tricks for request parameters for the Angular portal.

## dynamically_activated_params.vb

### Summary

Script sample for dynamically activating/deactivating request parameters.

### Origin

This is based on work done in a customer project. The customer wanted requestable products to allow their Service Desk to request new identities from the Angular portal. The relevant requirements were:

- required information for new identity
    - a manager has to assigned to the new identity
    - the new identity has to be assigned to a company
        - manager identities and companies can be imported from two different HR systems ("legacyHR" and "modernHR")
        - the assigned company has to be from the same HR system as the assigned manager
        - it is not possible to assign the manager and company from different HR systems
- attributes that need to be set on a new identity
    - Person.UID_PersonHead: manager that was selected in the request
    - Person.CCC_UID_LegacyCompany: a Department object that was imported from "legacyHR"
        - required if the selected manager identity was imported from "legacyHR"
        - must not be set if the selected manager identity was imported from "modernHR"
    - Person.CCC_UID_ModernCompany: an entry in a custom table CCC_ModernCompany, imported from "modernHR"
        - required if the selected manager identity was imported from "modernHR"
        - must not be set if the selected manager identity was imported from "legacyHR"

To gather the required information, three request parameters were created:
- Manager (name: manager; data source: Person.UID_Person)
- Legacy Company (name: legacyCompany; data source: Department.UID_Department)
- Modern Company (name: modernCompany; data source: CCC_ModernCompany.UID_CCC_ModernCompany)

The parameter "Manager" can be configured as a mandatory parameter, since a value is always required. For the company parameters, this is not possible, since the selected manager determines which company type needs to be selected.

To solve this, the code in dynamically_activated_params.vb was set as the Data dependencies script of the "Manager" request parameter. When a manager identity is selected, it checks the import source of the manager, activates the corresponding company parameter and sets it to mandatory, while also deactivating the other company parameter. This ensures that a company has to be selected and that the company's import source matches the manager's import source.

The script is run when the value of the parameter "Manager" changes. Depending on the selected identity's import source, it:
- activates the corresponding company parameter and makes it mandatory
- deactivates the other company parameter
- adds a note in the other company parameter to explain why this parameter cannot be used