declare @keyword nvarchar(max) = 'uid_person'; -- keyword to search for
declare @onlyCustomObjects bit = 1; -- set to 1 to limit search to custom objects or customized default objects

set @keyword = replace(replace(@keyword, '\', '_'), '.', '_'); -- replace '\' and '.' with single char wildcard to match ConfigParms by fullpath and by type safe notation
with searchResult(ObjectType, ObjectAttribute, ObjectName, ObjectKey) as
(
    -- DialogColumn
    select 'DialogColumn' as ObjectType, 'CanEditScript' as ObjectAttribute, dt.TableName+'.'+dc.ColumnName as ObjectName, dc.XObjectKey as ObjectKey from DialogColumn dc join DialogTable dt on dc.UID_DialogTable = dt.UID_DialogTable where dc.CanEditScript like '%'+@keyword+'%'
    union
    select 'DialogColumn' as ObjectType, 'CanSeeScript' as ObjectAttribute, dt.TableName+'.'+dc.ColumnName as ObjectName, dc.XObjectKey as ObjectKey from DialogColumn dc join DialogTable dt on dc.UID_DialogTable = dt.UID_DialogTable where dc.CanSeeScript like '%'+@keyword+'%'
    union
    select 'DialogColumn' as ObjectType, 'FormatScript' as ObjectAttribute, dt.TableName+'.'+dc.ColumnName as ObjectName, dc.XObjectKey as ObjectKey from DialogColumn dc join DialogTable dt on dc.UID_DialogTable = dt.UID_DialogTable where dc.FormatScript like '%'+@keyword+'%'
    union
    select 'DialogColumn' as ObjectType, 'Template' as ObjectAttribute, dt.TableName+'.'+dc.ColumnName as ObjectName, dc.XObjectKey as ObjectKey from DialogColumn dc join DialogTable dt on dc.UID_DialogTable = dt.UID_DialogTable where dc.Template like '%'+@keyword+'%'

    -- DialogDashBoardDef
    union
    select 'DialogDashBoardDef' as ObjectType, 'AccessWhereClause' as ObjectAttribute, DisplayName as ObjectName, XObjectKey as ObjectKey from DialogDashBoardDef where AccessWhereClause like '%'+@keyword+'%'
    union
    select 'DialogDashBoardDef' as ObjectType, 'QueryDefinition' as ObjectAttribute, DisplayName as ObjectName, XObjectKey as ObjectKey from DialogDashBoardDef where QueryDefinition like '%'+@keyword+'%'
    union
    select 'DialogDashBoardDef' as ObjectType, 'QueryDefinition100' as ObjectAttribute, DisplayName as ObjectName, XObjectKey as ObjectKey from DialogDashBoardDef where QueryDefinition100 like '%'+@keyword+'%'

    -- DialogMethod
    union
    select 'DialogMethod' as ObjectType, 'IsVisibleScript' as ObjectAttribute, MethodName as ObjectName, XObjectKey as ObjectKey from DialogMethod where IsVisibleScript like '%'+@keyword+'%'
    union
    select 'DialogMethod' as ObjectType, 'MethodScript' as ObjectAttribute, MethodName as ObjectName, XObjectKey as ObjectKey from DialogMethod where MethodScript like '%'+@keyword+'%'

    -- DialogNotification
    union
    select 'DialogNotification' as ObjectType, 'WhereClause' as ObjectAttribute, dtsend.TableName+'.'+dcsend.ColumnName+' - '+dtsub.TableName+'.'+dcsub.ColumnName as ObjectName, '<< no object key column on table >>' as ObjectKey from DialogNotification dn join DialogColumn dcsend on dn.UID_DialogColumnSender = dcsend.UID_DialogColumn join DialogTable dtsend on dcsend.UID_DialogTable = dtsend.UID_DialogTable join DialogColumn dcsub on dn.UID_DialogColumnSubscriber = dcsub.UID_DialogColumn join DialogTable dtsub on dcsub.UID_DialogTable = dtsub.UID_DialogTable where WhereClause like '%'+@keyword+'%'

    -- DialogObject
    union
    select 'DialogObject' as ObjectType, 'InsertValues' as ObjectAttribute, DisplayName as ObjectName, XObjectKey as ObjectKey from DialogObject where InsertValues like '%'+@keyword+'%'
    union
    select 'DialogObject' as ObjectType, 'SelectScript' as ObjectAttribute, DisplayName as ObjectName, XObjectKey as ObjectKey from DialogObject where SelectScript like '%'+@keyword+'%'
    union
    select 'DialogObject' as ObjectType, 'WhereClause' as ObjectAttribute, DisplayName as ObjectName, XObjectKey as ObjectKey from DialogObject where WhereClause like '%'+@keyword+'%'

    -- DialogParameter
    union
    select 'DialogParameter' as ObjectType, 'CalculateWhereClause' as ObjectAttribute, dps.DisplayName+'.'+dp.DisplayName as ObjectName, dp.XObjectKey as ObjectKey from DialogParameter dp join DialogParameterSet dps on dp.UID_DialogParameterSet = dps.UID_DialogParameterSet where CalculateWhereClause like '%'+@keyword+'%'
    union
    select 'DialogParameter' as ObjectType, 'OnPropertyChangedScript' as ObjectAttribute, dps.DisplayName+'.'+dp.DisplayName as ObjectName, dp.XObjectKey as ObjectKey from DialogParameter dp join DialogParameterSet dps on dp.UID_DialogParameterSet = dps.UID_DialogParameterSet where OnPropertyChangedScript like '%'+@keyword+'%'
    union
    select 'DialogParameter' as ObjectType, 'QueryWhereClause' as ObjectAttribute, dps.DisplayName+'.'+dp.DisplayName as ObjectName, dp.XObjectKey as ObjectKey from DialogParameter dp join DialogParameterSet dps on dp.UID_DialogParameterSet = dps.UID_DialogParameterSet where QueryWhereClause like '%'+@keyword+'%'
    union
    select 'DialogParameter' as ObjectType, 'ValidationScript' as ObjectAttribute, dps.DisplayName+'.'+dp.DisplayName as ObjectName, dp.XObjectKey as ObjectKey from DialogParameter dp join DialogParameterSet dps on dp.UID_DialogParameterSet = dps.UID_DialogParameterSet where ValidationScript like '%'+@keyword+'%'
    union
    select 'DialogParameter' as ObjectType, 'ValueScript' as ObjectAttribute, dps.DisplayName+'.'+dp.DisplayName as ObjectName, dp.XObjectKey as ObjectKey from DialogParameter dp join DialogParameterSet dps on dp.UID_DialogParameterSet = dps.UID_DialogParameterSet where ValueScript like '%'+@keyword+'%'

    -- DialogReportQuery
    union
    select 'DialogReportQuery' as ObjectType, 'ObjectOrderClause' as ObjectAttribute, dr.ReportName+'.'+drq.QueryName as ObjectName, drq.XObjectKey as ObjectKey from DialogReportQuery drq join DialogReport dr on drq.UID_DialogReport = dr.UID_DialogReport where ObjectOrderClause like '%'+@keyword+'%'
    union
    select 'DialogReportQuery' as ObjectType, 'ObjectWhereClause' as ObjectAttribute, dr.ReportName+'.'+drq.QueryName as ObjectName, drq.XObjectKey as ObjectKey from DialogReportQuery drq join DialogReport dr on drq.UID_DialogReport = dr.UID_DialogReport where ObjectWhereClause like '%'+@keyword+'%'
    union
    select 'DialogReportQuery' as ObjectType, 'QueryDefinition' as ObjectAttribute, dr.ReportName+'.'+drq.QueryName as ObjectName, drq.XObjectKey as ObjectKey from DialogReportQuery drq join DialogReport dr on drq.UID_DialogReport = dr.UID_DialogReport where QueryDefinition like '%'+@keyword+'%'
    union
    select 'DialogReportQuery' as ObjectType, 'ViewWhereClause' as ObjectAttribute, dr.ReportName+'.'+drq.QueryName as ObjectName, drq.XObjectKey as ObjectKey from DialogReportQuery drq join DialogReport dr on drq.UID_DialogReport = dr.UID_DialogReport where ViewWhereClause like '%'+@keyword+'%'

    -- DialogScript
    union
    select 'DialogScript' as ObjectType, 'Scriptcode' as ObjectAttribute, ScriptName as ObjectName, XObjectKey as ObjectKey from DialogScript where ScriptCode like '%'+@keyword+'%'

    -- DialogSheet
    union
    select 'DialogSheet' as ObjectType, 'InsertValues' as ObjectAttribute, SheetName as ObjectName, XObjectKey as ObjectKey from DialogSheet where InsertValues like '%'+@keyword+'%'

    -- DialogTable
    union
    select 'DialogTable' as ObjectType, 'DeleteDelayScript' as ObjectAttribute, TableName as ObjectName, XObjectKey as ObjectKey from DialogTable where DeleteDelayScript like '%'+@keyword+'%'
    union
    select 'DialogTable' as ObjectType, 'ExtensionForProxyTable' as ObjectAttribute, TableName as ObjectName, XObjectKey as ObjectKey from DialogTable where ExtensionForProxyTable like '%'+@keyword+'%'
    union
    select 'DialogTable' as ObjectType, 'InsertValues' as ObjectAttribute, TableName as ObjectName, XObjectKey as ObjectKey from DialogTable where InsertValues like '%'+@keyword+'%'
    union
    select 'DialogTable' as ObjectType, 'OnDiscardedScript' as ObjectAttribute, TableName as ObjectName, XObjectKey as ObjectKey from DialogTable where OnDiscardedScript like '%'+@keyword+'%'
    union
    select 'DialogTable' as ObjectType, 'OnDiscardingScript' as ObjectAttribute, TableName as ObjectName, XObjectKey as ObjectKey from DialogTable where OnDiscardingScript like '%'+@keyword+'%'
    union
    select 'DialogTable' as ObjectType, 'OnLoadedScript' as ObjectAttribute, TableName as ObjectName, XObjectKey as ObjectKey from DialogTable where OnLoadedScript like '%'+@keyword+'%'
    union
    select 'DialogTable' as ObjectType, 'OnSavedScript' as ObjectAttribute, TableName as ObjectName, XObjectKey as ObjectKey from DialogTable where OnSavedScript like '%'+@keyword+'%'
    union
    select 'DialogTable' as ObjectType, 'OnSavingScript' as ObjectAttribute, TableName as ObjectName, XObjectKey as ObjectKey from DialogTable where OnSavingScript like '%'+@keyword+'%'
    union
    select 'DialogTable' as ObjectType, 'SelectScript' as ObjectAttribute, TableName as ObjectName, XObjectKey as ObjectKey from DialogTable where SelectScript like '%'+@keyword+'%'
    union
    select 'DialogTable' as ObjectType, 'TransportSingleUser' as ObjectAttribute, TableName as ObjectName, XObjectKey as ObjectKey from DialogTable where TransportSingleUser like '%'+@keyword+'%'
    union
    select 'DialogTable' as ObjectType, 'TransportWhereClause' as ObjectAttribute, TableName as ObjectName, XObjectKey as ObjectKey from DialogTable where TransportWhereClause like '%'+@keyword+'%'
    union
    select 'DialogTable' as ObjectType, 'ViewWhereClause' as ObjectAttribute, TableName as ObjectName, XObjectKey as ObjectKey from DialogTable where ViewWhereClause like '%'+@keyword+'%'

    -- DialogTableGroupRight
    union
    select 'DialogTableGroupRight' as ObjectType, 'DeleteWhereClause' as ObjectAttribute, dt.TableName+'.'+dg.GroupName as ObjectName, dtgr.XObjectKey as ObjectUID from DialogTableGroupRight dtgr join DialogTable dt on dtgr.UID_DialogTable = dt.UID_DialogTable join DialogGroup dg on dtgr.UID_DialogGroup = dg.UID_DialogGroup where DeleteWhereClause like '%'+@keyword+'%'
    union
    select 'DialogTableGroupRight' as ObjectType, 'InsertWhereClause' as ObjectAttribute, dt.TableName+'.'+dg.GroupName as ObjectName, dtgr.XObjectKey as ObjectUID from DialogTableGroupRight dtgr join DialogTable dt on dtgr.UID_DialogTable = dt.UID_DialogTable join DialogGroup dg on dtgr.UID_DialogGroup = dg.UID_DialogGroup where InsertWhereClause like '%'+@keyword+'%'
    union
    select 'DialogTableGroupRight' as ObjectType, 'SelectWhereClause' as ObjectAttribute, dt.TableName+'.'+dg.GroupName as ObjectName, dtgr.XObjectKey as ObjectUID from DialogTableGroupRight dtgr join DialogTable dt on dtgr.UID_DialogTable = dt.UID_DialogTable join DialogGroup dg on dtgr.UID_DialogGroup = dg.UID_DialogGroup where SelectWhereClause like '%'+@keyword+'%'
    union
    select 'DialogTableGroupRight' as ObjectType, 'UpdateWhereClause' as ObjectAttribute, dt.TableName+'.'+dg.GroupName as ObjectName, dtgr.XObjectKey as ObjectUID from DialogTableGroupRight dtgr join DialogTable dt on dtgr.UID_DialogTable = dt.UID_DialogTable join DialogGroup dg on dtgr.UID_DialogGroup = dg.UID_DialogGroup where UpdateWhereClause like '%'+@keyword+'%'

    -- DialogTree
    union
    select 'DialogTree' as ObjectType, 'InitScript' as ObjectAttribute, TreeNode as ObjectName, XObjectKey as ObjectKey from DialogTree where InitScript like '%'+@keyword+'%'
    union
    select 'DialogTree' as ObjectType, 'ListInsertValues' as ObjectAttribute, TreeNode as ObjectName, XObjectKey as ObjectKey from DialogTree where ListInsertValues like '%'+@keyword+'%'
    union
    select 'DialogTree' as ObjectType, 'ListWhereClause' as ObjectAttribute, TreeNode as ObjectName, XObjectKey as ObjectKey from DialogTree where ListWhereClause like '%'+@keyword+'%'
    union
    select 'DialogTree' as ObjectType, 'StateScript' as ObjectAttribute, TreeNode as ObjectName, XObjectKey as ObjectKey from DialogTree where StateScript like '%'+@keyword+'%'
    union
    select 'DialogTree' as ObjectType, 'VarDefinition' as ObjectAttribute, TreeNode as ObjectName, XObjectKey as ObjectKey from DialogTree where VarDefinition like '%'+@keyword+'%'
    union
    select 'DialogTree' as ObjectType, 'WhereClause' as ObjectAttribute, TreeNode as ObjectName, XObjectKey as ObjectKey from DialogTree where WhereClause like '%'+@keyword+'%'

    -- DialogWebService
    union
    select 'DialogWebService' as ObjectType, 'ProxyCode' as ObjectAttribute, Ident_DialogWebService as ObjectName, XObjectKey as ObjectKey from DialogWebService where ProxyCode like '%'+@keyword+'%'

    -- Job
    union
    select 'Job' as ObjectType, 'GenCondition' as ObjectAttribute, jc.Name+'.'+j.Name ObjectName, j.XObjectKey as ObjectKey from Job j join JobChain jc on j.UID_JobChain = jc.UID_JobChain where j.GenCondition like '%'+@keyword+'%'
    union
    select 'Job' as ObjectType, 'NotifyAddress' as ObjectAttribute, jc.Name+'.'+j.Name ObjectName, j.XObjectKey as ObjectKey from Job j join JobChain jc on j.UID_JobChain = jc.UID_JobChain where j.NotifyAddress like '%'+@keyword+'%'
    union
    select 'Job' as ObjectType, 'NotifyAddressSuccess' as ObjectAttribute, jc.Name+'.'+j.Name ObjectName, j.XObjectKey as ObjectKey from Job j join JobChain jc on j.UID_JobChain = jc.UID_JobChain where j.NotifyAddressSuccess like '%'+@keyword+'%'
    union
    select 'Job' as ObjectType, 'NotifyBody' as ObjectAttribute, jc.Name+'.'+j.Name ObjectName, j.XObjectKey as ObjectKey from Job j join JobChain jc on j.UID_JobChain = jc.UID_JobChain where j.NotifyBody like '%'+@keyword+'%'
    union
    select 'Job' as ObjectType, 'NotifyBodySuccess' as ObjectAttribute, jc.Name+'.'+j.Name ObjectName, j.XObjectKey as ObjectKey from Job j join JobChain jc on j.UID_JobChain = jc.UID_JobChain where j.NotifyBodySuccess like '%'+@keyword+'%'
    union
    select 'Job' as ObjectType, 'NotifySender' as ObjectAttribute, jc.Name+'.'+j.Name ObjectName, j.XObjectKey as ObjectKey from Job j join JobChain jc on j.UID_JobChain = jc.UID_JobChain where j.NotifySender like '%'+@keyword+'%'
    union
    select 'Job' as ObjectType, 'NotifySenderSuccess' as ObjectAttribute, jc.Name+'.'+j.Name ObjectName, j.XObjectKey as ObjectKey from Job j join JobChain jc on j.UID_JobChain = jc.UID_JobChain where j.NotifySenderSuccess like '%'+@keyword+'%'
    union
    select 'Job' as ObjectType, 'NotifySubject' as ObjectAttribute, jc.Name+'.'+j.Name ObjectName, j.XObjectKey as ObjectKey from Job j join JobChain jc on j.UID_JobChain = jc.UID_JobChain where j.NotifySubject like '%'+@keyword+'%'
    union
    select 'Job' as ObjectType, 'NotifySubjectSuccess' as ObjectAttribute, jc.Name+'.'+j.Name ObjectName, j.XObjectKey as ObjectKey from Job j join JobChain jc on j.UID_JobChain = jc.UID_JobChain where j.NotifySubjectSuccess like '%'+@keyword+'%'
    union
    select 'Job' as ObjectType, 'PreCode' as ObjectAttribute, jc.Name+'.'+j.Name ObjectName, j.XObjectKey as ObjectKey from Job j join JobChain jc on j.UID_JobChain = jc.UID_JobChain where j.PreCode like '%'+@keyword+'%'
    union
    select 'Job' as ObjectType, 'PriorityDefinition' as ObjectAttribute, jc.Name+'.'+j.Name ObjectName, j.XObjectKey as ObjectKey from Job j join JobChain jc on j.UID_JobChain = jc.UID_JobChain where j.PriorityDefinition like '%'+@keyword+'%'
    union
    select 'Job' as ObjectType, 'ProcessDisplay' as ObjectAttribute, jc.Name+'.'+j.Name ObjectName, j.XObjectKey as ObjectKey from Job j join JobChain jc on j.UID_JobChain = jc.UID_JobChain where j.ProcessDisplay like '%'+@keyword+'%'
    union
    select 'Job' as ObjectType, 'ServerDetectScript' as ObjectAttribute, jc.Name+'.'+j.Name ObjectName, j.XObjectKey as ObjectKey from Job j join JobChain jc on j.UID_JobChain = jc.UID_JobChain where j.ServerDetectScript like '%'+@keyword+'%'

    -- JobAutoStart
    union
    select 'JobAutoStart' as ObjectType, 'WhereClause' as ObjectAttribute, Name as ObjectName, XObjectKey as ObjectKey from JobAutoStart where WhereClause like '%'+@keyword+'%'

    -- JobChain
    union
    select 'JobChain' as ObjectType, 'GenCondition' as ObjectAttribute, Name as ObjectName, XObjectKey as ObjectKey from JobChain where GenCondition like '%'+@keyword+'%'
    union
    select 'JobChain' as ObjectType, 'PreCode' as ObjectAttribute, Name as ObjectName, XObjectKey as ObjectKey from JobChain where PreCode like '%'+@keyword+'%'
    union
    select 'JobChain' as ObjectType, 'ProcessDisplay' as ObjectAttribute, Name as ObjectName, XObjectKey as ObjectKey from JobChain where ProcessDisplay like '%'+@keyword+'%'

    -- JobEventGen
    union
    select 'JobEventGen' as ObjectType, 'ProcessDisplay' as ObjectAttribute, qe.DisplayName+'.'+jc.Name as ObjectName, jeg.XObjectKey as ObjectKey from JobEventGen jeg join QBMEvent qe on jeg.UID_QBMEvent = qe.UID_QBMEvent join JobChain jc on jeg.UID_JobChain = jc.UID_JobChain where jeg.ProcessDisplay like '%'+@keyword+'%'

    -- JobParameter
    -- skip JobParameter, since they are only used as templates when creating a new process step and the code is never executed (the code created from the template is stored in JobRunParameter)
    --union
    --select 'JobParameter' as ObjectType, 'ValueTemplateDefault' as ObjectAttribute, Name as ObjectName, XObjectKey as ObjectKey from JobParameter where ValueTemplateDefault like '%'+@keyword+'%'

    -- JobRunParameter
    union
    select 'JobRunParameter' as ObjectType, 'ValueTemplate' as ObjectAttribute, jc.Name+'.'+j.Name+'.'+jrp.Name as ObjectName, jrp.XObjectKey as ObjectKey from JobChain jc join Job j on jc.UID_JobChain = j.UID_JobChain join JobRunParameter jrp on j.UID_Job = jrp.UID_Job where ValueTemplate like '%'+@keyword+'%'

    -- AccProductParameter
    union
    select 'AccProductParameter' as ObjectType, 'FKWhereClause' as ObjectAttribute, appc.Ident_AccProductParamCategory+'.'+app.DisplayValue as ObjectName, app.XObjectKey as ObjectKey from AccProductParameter app join AccProductParamCategory appc on app.UID_AccProductParamCategory = appc.UID_AccProductParamCategory where FKWhereClause like '%'+@keyword+'%'

    -- AttestationPolicy
    union
    select 'AttestationPolicy' as ObjectType, 'WhereClause' as ObjectAttribute, Ident_AttestationPolicy as ObjectName, XObjectKey as ObjectKey from AttestationPolicy where WhereClause like '%'+@keyword+'%'

    -- AttestationWizardParm
    union
    select 'AttestationWizardParm' as ObjectType, 'WhereClauseSnippet' as ObjectAttribute, DisplayValue as ObjectName, XObjectKey as ObjectKey from AttestationWizardParm where WhereClauseSnippet like '%'+@keyword+'%'

    -- AttestationWizardParmOpt
    union
    select 'AttestationWizardParmOpt' as ObjectType, 'WhereClauseSnippet' as ObjectAttribute, DisplayValue as ObjectName, XObjectKey as ObjectKey from AttestationWizardParmOpt where WhereClauseSnippet like '%'+@keyword+'%'

    -- ComplianceRule
    union
    select 'ComplianceRule' as ObjectType, 'WhereClause' as ObjectAttribute, Ident_ComplianceRule as ObjectName, XObjectKey as ObjectKey from ComplianceRule where WhereClause like '%'+@keyword+'%'
    union
    select 'ComplianceRule' as ObjectType, 'WhereClausePerson' as ObjectAttribute, Ident_ComplianceRule as ObjectName, XObjectKey as ObjectKey from ComplianceRule where WhereClausePerson like '%'+@keyword+'%'

    -- ComplianceSubRule
    union
    select 'ComplianceSubRule' as ObjectType, 'WhereClause' as ObjectAttribute, cr.Ident_ComplianceRule+'.'+csr.SortOrder as ObjectName, csr.XObjectKey as ObjectKey from ComplianceSubRule csr join ComplianceRule cr on csr.UID_ComplianceRule = cr.UID_ComplianceRule where csr.WhereClause like '%'+@keyword+'%'

    -- DPRNameSpaceHasDialogTable
    union
    select 'DPRNameSpaceHasDialogTable' as ObjectType, 'WhereClause' as ObjectAttribute, dt.Tablename+'.'+dns.DisplayName as ObjectName, dnsht.XObjectKey as ObjectKey from DPRNameSpaceHasDialogTable dnsht join DialogTable dt on dnsht.UID_DialogTable = dt.UID_DialogTable join DPRNameSpace dns on dnsht.UID_DPRNameSpace = dns.UID_DPRNameSpace where WhereClause like '%'+@keyword+'%'

    -- DynamicGroup
    union
    select 'DynamicGroup' as ObjectType, 'WhereClause' as ObjectAttribute, DisplayName as ObjectName, XObjectKey as ObjectKey from DynamicGroup where WhereClause like '%'+@keyword+'%'

    -- PWODecisionRuleRulerDetect
    union
    select 'PWODecisionRuleRulerDetect' as ObjectType, 'SQLQuery' as ObjectAttribute, pdr.DecisionRule+'.'+pdrrd.Ident_RulerDetect as ObjectName, pdrrd.XObjectKey as ObjectKey from PWODecisionRuleRulerDetect pdrrd join PWODecisionRule pdr on pdrrd.UID_PWODecisionRule = pdr.UID_PWODecisionRule where SQLQuery like '%'+@keyword+'%'
    union
    select 'PWODecisionRuleRulerDetect' as ObjectType, 'SQLQueryObjectsToRecalc' as ObjectAttribute, pdr.DecisionRule+'.'+pdrrd.Ident_RulerDetect as ObjectName, pdrrd.XObjectKey as ObjectKey from PWODecisionRuleRulerDetect pdrrd join PWODecisionRule pdr on pdrrd.UID_PWODecisionRule = pdr.UID_PWODecisionRule where SQLQueryObjectsToRecalc like '%'+@keyword+'%'

    -- PWODecisionStep
    union
    select 'PWODecisionStep' as ObjectType, 'WhereClause' as ObjectAttribute, pdsm.Ident_PWODecisionSubMethod+'.'+pds.Ident_PWODecisionStep as ObjectName, pds.XObjectKey as ObjectKey from PWODecisionStep pds join PWODecisionSubMethod pdsm on pds.UID_PWODecisionSubMethod = pdsm.UID_PWODecisionSubMethod where WhereClause like '%'+@keyword+'%'

    -- QBMConsistencyCheck
    union
    select 'QBMConsistencyCheck' as ObjectType, 'SQLCheck' as ObjectAttribute, Ident_QBMConsistencyCheck as ObjectName, XObjectKey as ObjectKey from QBMConsistencyCheck where SQLCheck like '%'+@keyword+'%'
    union
    select 'QBMConsistencyCheck' as ObjectType, 'SQLElementDetect' as ObjectAttribute, Ident_QBMConsistencyCheck as ObjectName, XObjectKey as ObjectKey from QBMConsistencyCheck where SQLElementDetect like '%'+@keyword+'%'
    union
    select 'QBMConsistencyCheck' as ObjectType, 'SQLRepair' as ObjectAttribute, Ident_QBMConsistencyCheck as ObjectName, XObjectKey as ObjectKey from QBMConsistencyCheck where SQLRepair like '%'+@keyword+'%'

    -- QBMCustomSQSL
    union
    select 'QBMCustomSQL' as ObjectType, 'ScriptCode' as ObjectAttribute, ScriptName as ObjectName, XObjectKey as ObjectKey from QBMCustomSQL where ScriptCode like '%'+@keyword+'%'

    --QBMDBQueueTask
    union
    select 'QBMDBQueueTask' as ObjectType, 'ProcedureName' as ObjectAttribute, UID_Task as ObjectName, XObjectKey as ObjectKey from QBMDBQueueTask where ProcedureName like '%'+@keyword+'%'
    union
    select 'QBMDBQueueTask' as ObjectType, 'QueryForRecalculate' as ObjectAttribute, UID_Task as ObjectName, XObjectKey as ObjectKey from QBMDBQueueTask where QueryForRecalculate like '%'+@keyword+'%'

    --QBMLimitedSQL
    union
    select 'QBMLimitedSQL' as ObjectType, 'SQLContent' as ObjectAttribute, Ident_QBMLimitedSQL as ObjectName, XObjectKey as ObjectKey from QBMLimitedSQL where SQLContent like '%'+@keyword+'%'

    --QBMViewAddOn
    union
    select 'QBMViewAddOn' as ObjectType, 'QueryString' as ObjectAttribute, Ident_QBMViewAddOn as ObjectName, XObjectKey as ObjectKey from QBMViewAddOn where QueryString like '%'+@keyword+'%'

    --QEREntitlementSource
    union
    select 'QEREntitlementSource' as ObjectType, 'SQLQuery' as ObjectAttribute, Ident_QEREntitlementSource as ObjectName, XObjectKey as ObjectKey from QEREntitlementSource where SQLQuery like '%'+@keyword+'%'

    --QERPolicy
    union
    select 'QERPolicy' as ObjectType, 'WhereClause' as ObjectAttribute, Ident_QERPolicy as ObjectName, XObjectKey as ObjectKey from QERPolicy where WhereClause like '%'+@keyword+'%'

    --QERRiskIndex
    union
    select 'QERRiskIndex' as ObjectType, 'QueryString' as ObjectAttribute, DisplayValue as ObjectName, XObjectKey as ObjectKey from QERRiskIndex where QueryString like '%'+@keyword+'%'

    --RelatedApplication
    union
    select 'RelatedApplication' as ObjectType, 'WhereClause' as ObjectAttribute, DisplayName as ObjectName, XObjectKey as ObjectKey from RelatedApplication where WhereClause like '%'+@keyword+'%'
)
select
    *
from
    SearchResult
where
	(
		-- custom object
		dbo.QBM_FCVObjectKeyToModuleOwner(ObjectKey) = 'CCC'
		or
		-- object attribute has been customized
		exists(select 1 from QBMBufferConfig where ObjectKeyOfRow = SearchResult.ObjectKey and ColumnName = SearchResult.ObjectAttribute)
	)
	or
	-- include default objects if "only custom objects" flag is not set
	@onlyCustomObjects=0