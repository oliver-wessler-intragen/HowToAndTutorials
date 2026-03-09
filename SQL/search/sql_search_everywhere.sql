SET NOCOUNT ON

DECLARE @Search_For varchar(4000)
DECLARE @Table_Name varchar(255)
DECLARE @Column_Name varchar(255)
DECLARE @Row_Count int
DECLARE @Sql nvarchar(4000)

DECLARE @Results Table 
(
    Table_Name varchar(255),
    Column_Name varchar(255),
    Row_Count int
)

DECLARE Field_List CURSOR FOR 
SELECT
    COLUMNS.Table_Name, COLUMNS.Column_Name 
FROM
    INFORMATION_SCHEMA.COLUMNS COLUMNS
    INNER JOIN INFORMATION_SCHEMA.TABLES TABLES ON COLUMNS.Table_Name = TABLES.Table_Name
WHERE
    COLUMNS.Data_Type IN ('char','varchar','nchar','nvarchar','text','ntext') 
    AND TABLES.Table_Type = 'Base Table'

----------------------------------
SET @Search_For = '<<enter search term here>>'
----------------------------------

OPEN Field_List

FETCH NEXT FROM Field_List INTO @Table_Name, @Column_Name
WHILE (@@fetch_status <> -1)
BEGIN
    IF (@@fetch_status <> -2)
    BEGIN
        -- Generate & run dynamic SQL
        SET @Sql = 'SELECT @Row_Count = COUNT(*) '+
        ' FROM [' + @Table_Name + '] (NOLOCK) WHERE [' + @Column_Name + '] LIKE ''%' + @Search_For + '%'''
        --' FROM [' + @Table_Name + '] (NOLOCK) WHERE [' + @Column_Name + '] LIKE ''%' + @Search_For + '''' --alternative ohne beliebige Zeichenfolgen

        EXEC sp_ExecuteSql @Sql, N'@Row_Count Int OUTPUT', @Row_Count OUTPUT

        IF @@Error <> 0
        PRINT @Sql

        -- Store results
        IF @Row_Count > 0
        INSERT INTO @Results VALUES (@Table_Name, @Column_Name, @Row_Count)

    END
    FETCH NEXT FROM Field_List INTO @Table_Name, @Column_Name
END

CLOSE Field_List
DEALLOCATE Field_List

SELECT * FROM @Results

GO
