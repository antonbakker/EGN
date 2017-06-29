DECLARE @name VARCHAR(50) -- database name 
 
DECLARE db_cursor CURSOR FOR 
SELECT name
FROM master.dbo.sysdatabases
/* WHERE name IN ('521') */  -- include these databases
-- WHERE name IN ('512', '513', '514', '521', '522', '523', '524', '525', '527', '528', '541', '542', '543', '544', '561', '571', '581', '582', '583', '591', '593', '594')  -- include these databases
WHERE name IN ('012', '013', '014', '021', '022', '023', '024', '025', '027', '028', '041', '042', '043', '044', '061', '071', '081', '082', '083', '091', '093', '094')  -- include these databases
/* WHERE name IN ('521') */
 
 
OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @name  
 
WHILE @@FETCH_STATUS = 0  
BEGIN

DECLARE @query VARCHAR(MAX)

/* Projecten */
SET @query =
'
SELECT
G.Division,
G.datum,
G.bkstnr,
G.reknr,
G.tegreknr,
G.[bdr_hfl],
G.oms25,
G.aantal,
G.project,
G.kstplcode,
G.kstdrcode
FROM
[' + @name + '].[dbo].gbkmut  AS G
WHERE
G.dagbknr like ''%90''
and G.bkjrcode = 2016

'

EXEC( @query)

 
  FETCH NEXT FROM db_cursor INTO @name  
END  
 
CLOSE db_cursor  
DEALLOCATE db_cursor