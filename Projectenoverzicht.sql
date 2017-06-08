DECLARE @name VARCHAR(50) -- database name 

  
DECLARE db_cursor CURSOR FOR 
SELECT name
FROM master.dbo.sysdatabases
WHERE name IN ('512', '513', '514', '521', '522', '523', '524', '525', '527', '528', '541', '542', '543', '544', '561', '571', '581', '582', '583', '591', '593', '594')  -- include these databases
/* WHERE name IN ('012', '013', '014', '021', '022', '023', '024', '025', '027', '028', '041', '042', '043', '044', '061', '071', '081', '082', '083', '091', '093', '094') */  -- include these databases
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
        PRJ.ProjectNr AS Projectnummer,
        PRJ.Description AS Projectomschrijving,
        PRJ.Division AS Divisie,
        DIV.bedrnm AS Werkmaatschappij,
        -- PRJ.Memo,
        -- PRJ.NumberField1,
        -- PRJ.NumberField2,
        -- PRJ.NumberField3,
        -- PRJ.NumberField4,
        -- PRJ.NumberField5,
        PRJ.TextField1 AS Projecleider,
        PRJ.TextField2 AS Uitvoerder,
        PRJ.TextField3 AS Calculator,
        PRJ.TextField4 AS Vrijveld,
        PRJ.TextField5 AS Kernactiviteit,
        CIC.[cmp_code] AS Relatiecode,
        CIC.[cmp_name] AS Relatienaam,
        CIC.[cmp_fadd1] AS Adres,
        CIC.[cmp_fpc] AS Postcode,
        CIC.[cmp_fcity] AS Plaatsnaam,
        CIC.[cmp_fctry] AS Land
    FROM
        [' + @name + '].[dbo].[PRProject] AS PRJ
        LEFT JOIN [' + @name + '].[dbo].[cicmpy] AS CIC ON PRJ.IDCustomer = CIC.[cmp_wwn]
        LEFT JOIN [' + @name + '].[dbo].[bedryf] AS DIV ON PRJ.Division = DIV.bedrnr
    WHERE PRJ.Status = ''A''
'

EXEC( @query)

 
  FETCH NEXT FROM db_cursor INTO @name  
END  
 
CLOSE db_cursor  
DEALLOCATE db_cursor