use [061]

SELECT
dbo.gbkmut.bkjrcode,
dbo.gbkmut.dagbknr,
dbo.gbkmut.reknr,
dbo.grtbk.[oms25_0],
dbo.gbkmut.tegreknr,
-dbo.gbkmut.[bdr_hfl] AS Omzet,
-dbo.gbkmut.[btw_bdr_3] AS BTW,
dbo.gbkmut.kstplcode,
dbo.gbkmut.kstdrcode,
dbo.gbkmut.aantal,
dbo.gbkmut.project,
dbo.cicmpy.[cmp_code],
dbo.cicmpy.[cmp_name]
FROM
dbo.gbkmut
JOIN dbo.grtbk
ON dbo.gbkmut.reknr = dbo.grtbk.reknr
JOIN dbo.cicmpy
ON dbo.gbkmut.debnr = dbo.cicmpy.debnr
WHERE
dbo.gbkmut.dagbknr = 60
and ltrim(dbo.gbkmut.reknr) like '8%'
order by dbo.gbkmut.bkjrcode desc
