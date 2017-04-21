DECLARE @name VARCHAR(50) -- database name


DECLARE db_cursor CURSOR FOR
SELECT name
FROM master.dbo.sysdatabases
WHERE name IN ('512', '513', '514', '521', '522', '523', '524', '525', '527', '528', '541', '542', '543', '544', '561', '571', '581', '582', '583', '591', '593', '594')  -- include these databases */
/* WHERE name IN ('012', '013', '014', '021', '022', '023', '024', '025', '027', '028', '041', '042', '043', '044', '061', '071', '081', '082', '083', '091', '093', '094')  -- include these databases */
/* WHERE name IN ('521') */


OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @name

WHILE @@FETCH_STATUS = 0
BEGIN

DECLARE @query VARCHAR(MAX)

/* Debiteuren */
SET @query =
'
DELETE
FROM [' + @name + '].[dbo].grtbk
WHERE
[' + @name + '].[dbo].grtbk.reknr IN

(
SELECT DISTINCT
-- ' + @name + ' AS Div,
[' + @name + '].[dbo].grtbk.reknr
FROM
[' + @name + '].[dbo].grtbk
LEFT JOIN [' + @name + '].[dbo].gbkmut
ON [' + @name + '].[dbo].gbkmut.reknr = [' + @name + '].[dbo].grtbk.reknr
WHERE
[' + @name + '].[dbo].gbkmut.reknr is NULL
AND [' + @name + '].[dbo].grtbk.reknr in (

     0800,
     0801,
     0802,
     0803,
     0804,
     0805,
     0806,
     0807,
     0808,
     0809,
     0810,
     0811,
     0812,
     0813,
     0814,
     0815,
     0816,
     0817,
     0818,
     0819,
     0820,
     0821,
     0822,
     0823,
     0824,
     0825,
     0826 /*,

     5810,
     5811,
     5812,
     5813,
     5814,
     5815,
     5816,
     5817,
     5818,
     5819,

     8300,
     8301,
     8302,
     8303,
     8304,
     8305,
     8306,
     8307,
     8308,
     8309,
     8310,
     8311,
     8312,
     8320,
     8321,
     8322,
     8323,
     8324,
     8325,
     8326,
     8327,
     8328,
     8329,
     8330,
     8331,
     8332,
     8340,
     8341,
     8342,
     8343,
     8344,
     8345,
     8346,
     8347,
     8348,
     8349,
     8350,
     8351,
     8352,
     8363 */


)
)

'

EXEC( @query)


  FETCH NEXT FROM db_cursor INTO @name
END

CLOSE db_cursor
DEALLOCATE db_cursor
