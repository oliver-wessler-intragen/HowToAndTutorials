-- create search statement for all code columns of a table
-- uses columns from table display pattern for object name
select
	'select ''' + dt.TableName + ''' as ObjectType, ''' + dc.ColumnName + ''' as ObjectAttribute, ' + isnull(dname.columnname, '<<ObjectName>>') + ' as ObjectName, XObjectKey as ObjectKey from ' + dt.TableName + ' where ' + dc.ColumnName + ' like ''%''+@keyword+''%'''
from
	dialogtable dt -- search table
	join dialogcolumn dc on dt.uid_dialogtable = dc.uid_dialogtable -- search column
	left join dialogcolumn dname on dt.uid_dialogtable = dname.uid_dialogtable and (dt.displaypattern like '%'+dname.columnname+'%') -- object name column
where
	-- anything programmable
	(
		dc.syntaxtype like 'VB%'
		or
		dc.syntaxtype like 'SQL%'
	)
	and	dt.tablename = 'QBMCustomSQL'
	-- uncomment following line and set desired columnname for objectname if multiple columns are used in display pattern
	--and	dname.ColumnName = 'SheetName'
	
	
-- find tables
select
	distinct dt.tablename
	--dt.tablename, dc.columnname
from
	dialogtable dt
	join dialogcolumn dc on dt.uid_dialogtable = dc.uid_dialogtable
where
	(
		dc.syntaxtype like 'VB%'
		or
		dc.syntaxtype like 'SQL%'
	)
	--and dt.tablename not in ('Job', 'JobAutoStart', 'JobChain', 'JobEventGen', 'JobParameter', 'JobRunParameter')
	and	dt.tablename not like 'Dialog%' and dt.tablename not like 'Job%'
order by 1

-- test
declare @keyword nvarchar(max) = 'uid_person';
select 'QBMCustomSQL' as ObjectType, 'ScriptCode' as ObjectAttribute, ScriptName as ObjectName, XObjectKey as ObjectKey from QBMCustomSQL where ScriptCode like '%'+@keyword+'%'