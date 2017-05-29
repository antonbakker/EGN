DECLARE @name VARCHAR(50) -- database name
DECLARE @BetaaltermijnDebiteuren char(2) = '30'
DECLARE @BetaaltermijnCrediteuren char(2) = '50'

DECLARE db_cursor CURSOR FOR
SELECT name
FROM master.dbo.sysdatabases
WHERE name IN ('512', '513', '514', '521', '522', '523', '524', '525', '527', '528', '541', '542', '543', '544', '561', '571', '581', '582', '583', '591', '593', '594')  -- include these databases
/*WHERE name IN ('421')*/


OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @name

WHILE @@FETCH_STATUS = 0
BEGIN

DECLARE @query VARCHAR(MAX)

set @query = 'select ' + @name
exec(@Query)
/* Debiteuren */
SET @query =
'
UPDATE [' + @name + '].[dbo].[cicmpy]
set PaymentCondition = ' + @BetaaltermijnDebiteuren + '
where (debnr is not NULL)
and PaymentCondition is null
/* PaymentCondition not IN(''30'', ''45'', ''60'') */
'

EXEC( @query)

/* Crediteuren */
SET @query =
'
UPDATE [' + @name + '].[dbo].[cicmpy]
set PaymentCondition = ' + @BetaaltermijnCrediteuren + '
where (crdnr is not NULL)
and PaymentCondition is null
/* PaymentCondition not IN(''GR'', ''08'', ''20'', ''50'', ''99'') */
'

EXEC( @query)


  FETCH NEXT FROM db_cursor INTO @name
END

CLOSE db_cursor
DEALLOCATE db_cursor
