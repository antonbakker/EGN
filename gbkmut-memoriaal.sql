DECLARE @name VARCHAR ( 50 ) -- database name
DECLARE
	db_cursor CURSOR FOR SELECT
	name 
FROM
	master.dbo.sysdatabases 
WHERE
	name IN (
		'512',
		'513',
		'514',
		'521',
		'522',
		'523',
		'524',
		'525',
		'527',
		'528',
		'541',
		'542',
		'543',
		'544',
		'561',
		'571',
		'581',
		'582',
		'583',
		'591',
		'593',
		'594' 
	) -- include these databases
-- WHERE name IN ('561')
	OPEN db_cursor FETCH NEXT 
FROM
	db_cursor INTO @name
WHILE
		@@FETCH_STATUS = 0 
	BEGIN
		DECLARE
			@query VARCHAR ( MAX ) 
			SET @query = '
			SELECT
				G.Division AS Administratie,
				G.datum AS Boekdatum,
				G.reknr AS Rekeningnummer,
				G.tegreknr AS Tegenrekening,
				G.bkstnr AS Boekstuknummer,
				G.kstplcode AS Kostenplaats,
				G.kstdrcode AS Kkostendrager,
				G.oms25 AS Omschrijvinf,
				G.[bdr_hfl] AS Bedrag,
				G.project AS Project
			FROM
				[' + @name + '].dbo.gbkmut AS G
			WHERE
				G.dagbknr like ''%90''
			'
		EXEC ( @query ) FETCH NEXT 
		FROM
		db_cursor INTO @name 
	END CLOSE db_cursor DEALLOCATE db_cursor