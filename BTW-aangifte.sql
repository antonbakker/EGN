SELECT
'512 SHZ' AS [Admin],
[512].[dbo].[DimTime].[YEAR] AS [Dim-jaar],
[512].[dbo].[DimTime].[MONTH] AS [Dim-Maand],
[512].[dbo].[DimTime].[ISO_WEEK_NO] AS [Dim-Weeknummer],
[512].[dbo].[gbkmut].[bkjrcode] AS [Boekjaar],
[512].[dbo].[gbkmut].[periode] collate database_default AS [Periode],
[512].[dbo].[gbkmut].[datum] AS [Datum],

(
CASE
 when CAST([512].[dbo].[gbkmut].[reknr] AS INT) IN(1810) THEN ([512].[dbo].[gbkmut].[btw_bdr_3] * 100) /
	(SELECT [512].[dbo].[btwtrs].[btwper] FROM [512].[dbo].[btwtrs] WHERE cast([512].[dbo].[btwtrs].[btwtrans] as int) = 10)
 when CAST([512].[dbo].[gbkmut].[reknr] AS INT) IN(1820) THEN ([512].[dbo].[gbkmut].[btw_bdr_3] * 100) /
	(SELECT [512].[dbo].[btwtrs].[btwper] FROM [512].[dbo].[btwtrs] WHERE cast([512].[dbo].[btwtrs].[btwtrans] as int) = 10)
 else [512].[dbo].[gbkmut].[bdr_hfl]
end
) AS [Omzet-bedrag],

[512].[dbo].[btwtrs].[btwper] AS [BTW-percentage],
[512].[dbo].[gbkmut].[btw_bdr_3] AS [BTW-bedrag],
[512].[dbo].[btwtrs].[verlegdbtw] AS [BTW-verlegd],
CAST([512].[dbo].[gbkmut].[reknr] collate database_default as int) AS [Grootboeknummer],

/*

Onerstaande case controleert of een mutatie in een van de aangifte categorieen valt.

*/


/* toevoegen beginbalansen grootboekrekeningen

SELECT
sum([dbo].[GeneralLedgerBalances].[AmountDC])
FROM
[dbo].[DimTime]
JOIN [dbo].[GeneralLedgerBalances]
ON [dbo].[DimTime].[DATE] = [dbo].[GeneralLedgerBalances].[Date]
WHERE
cast([dbo].[GeneralLedgerBalances].[GeneralLedger] as Integer) in(1805)
and [dbo].[DimTime].[YEAR] <
case
when month(GETDATE()) = 1 then year(GETDATE()) - 1
else year(GETDATE())
end

*/



(
	CASE
	WHEN cast([512].[dbo].[gbkmut].[btw_code] as int) = 10 and CAST([512].[dbo].[gbkmut].[reknr] AS INT) IN(8000, 8070, 8111, 8120, 8131, 8161, 8730, 8790) THEN '1a Leveringen/diensten belast met hoog tarief'
	WHEN cast([512].[dbo].[gbkmut].[btw_code] as int) = 10 and CAST([512].[dbo].[gbkmut].[reknr] AS INT) IN(1330) and cast([512].[dbo].[gbkmut].[dagbknr] as int) = 60 THEN '1a Leveringen/diensten belast met hoog tarief'
	WHEN cast([512].[dbo].[gbkmut].[btw_code] as Int) = 11 and CAST([512].[dbo].[gbkmut].[reknr] AS INT) IN(8010, 1330) THEN '1b Leveringen/diensten belast met laag tarief'
	WHEN CAST([512].[dbo].[gbkmut].[reknr] AS INT) IN(8200) THEN '1c Leveringen/diensten belast met overige tarieven, behalve 0%'
	WHEN CAST([512].[dbo].[gbkmut].[reknr] AS INT) IN(1835) THEN '1d Privégebruik'
	WHEN cast([512].[dbo].[gbkmut].[btw_code] as Int) = 13  and CAST([512].[dbo].[gbkmut].[reknr] AS INT) IN(8020, 8710) THEN '1e Leveringen/diensten belast met 0% of niet bij u belast'
	WHEN CAST([512].[dbo].[gbkmut].[reknr] AS INT) IN(1810) THEN '2a Leveringen/diensten waarbij de heffing van omzetbelasting naar u is verlegd'
	WHEN cast([512].[dbo].[gbkmut].[btw_code] as int) = 16  and CAST([512].[dbo].[gbkmut].[reknr] AS INT) IN(8040, 1330) THEN '3a Leveringen naar landen buiten de EU (uitvoer)'
	WHEN cast([512].[dbo].[gbkmut].[btw_code] as Int) = 17 and CAST([512].[dbo].[gbkmut].[reknr] AS INT) IN(8030, 8250, 1330) THEN '3b Leveringen naar of diensten in landen binnen de EU'
	WHEN CAST([512].[dbo].[gbkmut].[reknr] AS INT) IN(1815) THEN '4a Leveringen/diensten uit landen buiten de EU'
	WHEN CAST([512].[dbo].[gbkmut].[reknr] AS INT) IN(1820) THEN '4b Leveringen/diensten uit landen binnen de EU'
	WHEN CAST([512].[dbo].[gbkmut].[reknr] AS INT) IN(1805) THEN '5b Voorbelasting'
	WHEN CAST([512].[dbo].[gbkmut].[reknr] AS INT) IN(4190) THEN 'IC Personeel'
	WHEN CAST([512].[dbo].[gbkmut].[reknr] AS INT) IN(4499) THEN 'IC Materieel'
	WHEN CAST([512].[dbo].[gbkmut].[reknr] AS INT) IN(1825) THEN 'BTW-controle'
	ELSE 'Uitvalbak' END
) COLLATE database_default AS [OmzetType],

(
	CASE
	WHEN cast([512].[dbo].[gbkmut].[btw_code] as int) = 13 and CAST([512].[dbo].[gbkmut].[reknr] AS INT) IN(8060, 8110, 8130, 8730, 1330) THEN 1
	ELSE NULL END
) AS [OmzetBinnenGroep],


[512].[dbo].[grtbk].[oms25_0] collate database_default AS [Grootboekomschrijving],
[512].[dbo].[gbkmut].[bkstnr] collate database_default AS [Boekstuknummer],
[512].[dbo].[gbkmut].[btw_code] collate database_default AS [BTW-code],
[512].[dbo].[btwtrs].[oms30_0] collate database_default AS [BTW-codeomschrijving]

FROM
[512].[dbo].[gbkmut]
JOIN [512].[dbo].[DimTime]
ON [512].[dbo].[gbkmut].[datum] = [512].[dbo].[DimTime].[DATE]
JOIN [512].[dbo].[btwtrs]
ON [512].[dbo].[gbkmut].[btw_code] = [512].[dbo].[btwtrs].[btwtrans]
JOIN [512].[dbo].[grtbk]
ON [512].[dbo].[gbkmut].[reknr] = [512].[dbo].[grtbk].[reknr]

where [512].[dbo].[gbkmut].[bkjrcode] between DATEPART(yyyy,getdate()) - 1 and DATEPART(yyyy,getdate())


union all


SELECT
'521 SAZ' AS [Admin],
[521].[dbo].[DimTime].[YEAR] AS [Dim-jaar],
[521].[dbo].[DimTime].[MONTH] AS [Dim-Maand],
[521].[dbo].[DimTime].[ISO_WEEK_NO] AS [Dim-Weeknummer],
[521].[dbo].[gbkmut].[bkjrcode] AS [Boekjaar],
[521].[dbo].[gbkmut].[periode] AS [Periode],
[521].[dbo].[gbkmut].[datum] AS [Datum],
(
CASE
 when CAST([521].[dbo].[gbkmut].[reknr] AS INT) IN(1810) THEN ([521].[dbo].[gbkmut].[btw_bdr_3] * 100) /
	(SELECT [521].[dbo].[btwtrs].[btwper] FROM [521].[dbo].[btwtrs] WHERE cast([521].[dbo].[btwtrs].[btwtrans] as int) = 10)
 when CAST([521].[dbo].[gbkmut].[reknr] AS INT) IN(1820) THEN ([521].[dbo].[gbkmut].[btw_bdr_3] * 100) /
	(SELECT [521].[dbo].[btwtrs].[btwper] FROM [521].[dbo].[btwtrs] WHERE cast([521].[dbo].[btwtrs].[btwtrans] as int) = 10)
 else [521].[dbo].[gbkmut].[bdr_hfl]
end
) AS [Omzet-bedrag],
[521].[dbo].[btwtrs].[btwper] AS [BTW-percentage],
[521].[dbo].[gbkmut].[btw_bdr_3] AS [BTW-bedrag],
[521].[dbo].[btwtrs].[verlegdbtw] AS [BTW-verlegd],
CAST([521].[dbo].[gbkmut].[reknr] as int) AS [Grootboeknummer],
(
	CASE
	WHEN cast([521].[dbo].[gbkmut].[btw_code] as int) = 10 and CAST([521].[dbo].[gbkmut].[reknr] AS INT) IN(8000, 8070, 8111, 8120, 8131, 8730, 8790) THEN '1a Leveringen/diensten belast met hoog tarief'
	WHEN cast([521].[dbo].[gbkmut].[btw_code] as int) = 10 and CAST([521].[dbo].[gbkmut].[reknr] AS INT) IN(1330) and cast([521].[dbo].[gbkmut].[dagbknr] as int) = 60 THEN '1a Leveringen/diensten belast met hoog tarief'
	WHEN cast([521].[dbo].[gbkmut].[btw_code] as Int) = 11 and CAST([521].[dbo].[gbkmut].[reknr] AS INT) IN(8010, 1330) THEN '1b Leveringen/diensten belast met laag tarief'
	WHEN CAST([521].[dbo].[gbkmut].[reknr] AS INT) IN(8200) THEN '1c Leveringen/diensten belast met overige tarieven, behalve 0%'
	WHEN CAST([521].[dbo].[gbkmut].[reknr] AS INT) IN(1835) THEN '1d Privégebruik'
	WHEN cast([521].[dbo].[gbkmut].[btw_code] as Int) = 13  and CAST([521].[dbo].[gbkmut].[reknr] AS INT) IN(8020, 8710, 1330) THEN '1e Leveringen/diensten belast met 0% of niet bij u belast'
	WHEN CAST([521].[dbo].[gbkmut].[reknr] AS INT) IN(1810) THEN '2a Leveringen/diensten waarbij de heffing van omzetbelasting naar u is verlegd'
	WHEN cast([521].[dbo].[gbkmut].[btw_code] as int) = 16  and CAST([521].[dbo].[gbkmut].[reknr] AS INT) IN(1330) THEN '3a Leveringen naar landen buiten de EU (uitvoer)'
	WHEN cast([521].[dbo].[gbkmut].[btw_code] as Int) = 17 and CAST([521].[dbo].[gbkmut].[reknr] AS INT) IN(8030, 8250, 1330) THEN '3b Leveringen naar of diensten in landen binnen de EU'
	WHEN CAST([521].[dbo].[gbkmut].[reknr] AS INT) IN(1815) THEN '4a Leveringen/diensten uit landen buiten de EU'
	WHEN CAST([521].[dbo].[gbkmut].[reknr] AS INT) IN(1820) THEN '4b Leveringen/diensten uit landen binnen de EU'
	WHEN CAST([521].[dbo].[gbkmut].[reknr] AS INT) IN(1805) THEN '5b Voorbelasting'
	WHEN CAST([521].[dbo].[gbkmut].[reknr] AS INT) IN(4190) THEN 'IC Personeel'
	WHEN CAST([521].[dbo].[gbkmut].[reknr] AS INT) IN(4499) THEN 'IC Materieel'
	WHEN CAST([521].[dbo].[gbkmut].[reknr] AS INT) IN(1825) THEN 'BTW-controle'
	ELSE 'Uitvalbak' END
) COLLATE database_default AS [OmzetType],

(
	CASE
	WHEN cast([521].[dbo].[gbkmut].[btw_code] as int) = 13 and CAST([521].[dbo].[gbkmut].[reknr] AS INT) IN(8060, 8110, 8130, 8730, 1330) THEN 1
	ELSE NULL END
) AS [OmzetBinnenGroep],


[521].[dbo].[grtbk].[oms25_0] AS [Grootboekomschrijving],
[521].[dbo].[gbkmut].[bkstnr] AS [Boekstuknummer],
[521].[dbo].[gbkmut].[btw_code] AS [BTW-code],
[521].[dbo].[btwtrs].[oms30_0] AS [BTW-codeomschrijving]
FROM
[521].[dbo].[gbkmut]
JOIN [521].[dbo].[DimTime]
ON [521].[dbo].[gbkmut].[datum] = [521].[dbo].[DimTime].[DATE]
JOIN [521].[dbo].[btwtrs]
ON [521].[dbo].[gbkmut].[btw_code] = [521].[dbo].[btwtrs].[btwtrans]
JOIN [521].[dbo].[grtbk]
ON [521].[dbo].[gbkmut].[reknr] = [521].[dbo].[grtbk].[reknr]

where [521].[dbo].[gbkmut].[bkjrcode] between DATEPART(yyyy,getdate()) - 1 and DATEPART(yyyy,getdate())

union all


SELECT
'522 SZVL' AS [Admin],
[522].[dbo].[DimTime].[YEAR] AS [Dim-jaar],
[522].[dbo].[DimTime].[MONTH] AS [Dim-Maand],
[522].[dbo].[DimTime].[ISO_WEEK_NO] AS [Dim-Weeknummer],
[522].[dbo].[gbkmut].[bkjrcode] AS [Boekjaar],
[522].[dbo].[gbkmut].[periode] AS [Periode],
[522].[dbo].[gbkmut].[datum] AS [Datum],
(
CASE
 when CAST([522].[dbo].[gbkmut].[reknr] AS INT) IN(1810) THEN ([522].[dbo].[gbkmut].[btw_bdr_3] * 100) /
	(SELECT [522].[dbo].[btwtrs].[btwper] FROM [522].[dbo].[btwtrs] WHERE cast([522].[dbo].[btwtrs].[btwtrans] as int) = 10)
 when CAST([522].[dbo].[gbkmut].[reknr] AS INT) IN(1820) THEN ([522].[dbo].[gbkmut].[btw_bdr_3] * 100) /
	(SELECT [522].[dbo].[btwtrs].[btwper] FROM [522].[dbo].[btwtrs] WHERE cast([522].[dbo].[btwtrs].[btwtrans] as int) = 10)
 else [522].[dbo].[gbkmut].[bdr_hfl]
end
) AS [Omzet-bedrag],
[522].[dbo].[btwtrs].[btwper] AS [BTW-percentage],
[522].[dbo].[gbkmut].[btw_bdr_3] AS [BTW-bedrag],
[522].[dbo].[btwtrs].[verlegdbtw] AS [BTW-verlegd],
CAST([522].[dbo].[gbkmut].[reknr] as int) AS [Grootboeknummer],
(
	CASE
	WHEN cast([522].[dbo].[gbkmut].[btw_code] as int) = 10 and CAST([522].[dbo].[gbkmut].[reknr] AS INT) IN(8000, 8070, 8111, 8120, 8131, 8730, 8790) THEN '1a Leveringen/diensten belast met hoog tarief'
	WHEN cast([522].[dbo].[gbkmut].[btw_code] as int) = 10 and CAST([522].[dbo].[gbkmut].[reknr] AS INT) IN(1330) and cast([522].[dbo].[gbkmut].[dagbknr] as int) = 60 THEN '1a Leveringen/diensten belast met hoog tarief'
	WHEN cast([522].[dbo].[gbkmut].[btw_code] as Int) = 11 and CAST([522].[dbo].[gbkmut].[reknr] AS INT) IN(8010, 1330) THEN '1b Leveringen/diensten belast met laag tarief'
	WHEN CAST([522].[dbo].[gbkmut].[reknr] AS INT) IN(8200) THEN '1c Leveringen/diensten belast met overige tarieven, behalve 0%'
	WHEN CAST([522].[dbo].[gbkmut].[reknr] AS INT) IN(1835) THEN '1d Privégebruik'
	WHEN cast([522].[dbo].[gbkmut].[btw_code] as Int) = 13  and CAST([522].[dbo].[gbkmut].[reknr] AS INT) IN(8020, 8710, 1330) THEN '1e Leveringen/diensten belast met 0% of niet bij u belast'
	WHEN CAST([522].[dbo].[gbkmut].[reknr] AS INT) IN(1810) THEN '2a Leveringen/diensten waarbij de heffing van omzetbelasting naar u is verlegd'
	WHEN cast([522].[dbo].[gbkmut].[btw_code] as int) = 16  and CAST([522].[dbo].[gbkmut].[reknr] AS INT) IN(8040, 1330) THEN '3a Leveringen naar landen buiten de EU (uitvoer)'
	WHEN cast([522].[dbo].[gbkmut].[btw_code] as Int) = 17 and CAST([522].[dbo].[gbkmut].[reknr] AS INT) IN(8030, 8250, 1330) THEN '3b Leveringen naar of diensten in landen binnen de EU'
	WHEN CAST([522].[dbo].[gbkmut].[reknr] AS INT) IN(1815) THEN '4a Leveringen/diensten uit landen buiten de EU'
	WHEN CAST([522].[dbo].[gbkmut].[reknr] AS INT) IN(1820) THEN '4b Leveringen/diensten uit landen binnen de EU'
	WHEN CAST([522].[dbo].[gbkmut].[reknr] AS INT) IN(1805) THEN '5b Voorbelasting'
	WHEN CAST([522].[dbo].[gbkmut].[reknr] AS INT) IN(4190) THEN 'IC Personeel'
	WHEN CAST([522].[dbo].[gbkmut].[reknr] AS INT) IN(4499) THEN 'IC Materieel'
	WHEN CAST([522].[dbo].[gbkmut].[reknr] AS INT) IN(1825) THEN 'BTW-controle'
	ELSE 'Uitvalbak' END
) COLLATE database_default AS [OmzetType],

(
	CASE
	WHEN cast([522].[dbo].[gbkmut].[btw_code] as int) = 13 and CAST([522].[dbo].[gbkmut].[reknr] AS INT) IN(8060, 8110, 8130, 8730, 1330) THEN 1
	ELSE NULL END
) AS [OmzetBinnenGroep],


[522].[dbo].[grtbk].[oms25_0] AS [Grootboekomschrijving],
[522].[dbo].[gbkmut].[bkstnr] AS [Boekstuknummer],
[522].[dbo].[gbkmut].[btw_code] AS [BTW-code],
[522].[dbo].[btwtrs].[oms30_0] AS [BTW-codeomschrijving]
FROM
[522].[dbo].[gbkmut]
JOIN [522].[dbo].[DimTime]
ON [522].[dbo].[gbkmut].[datum] = [522].[dbo].[DimTime].[DATE]
JOIN [522].[dbo].[btwtrs]
ON [522].[dbo].[gbkmut].[btw_code] = [522].[dbo].[btwtrs].[btwtrans]
JOIN [522].[dbo].[grtbk]
ON [522].[dbo].[gbkmut].[reknr] = [522].[dbo].[grtbk].[reknr]

where [522].[dbo].[gbkmut].[bkjrcode] between DATEPART(yyyy,getdate()) - 1 and DATEPART(yyyy,getdate())

union all


SELECT
'523 SMA' AS [Admin],
[523].[dbo].[DimTime].[YEAR] AS [Dim-jaar],
[523].[dbo].[DimTime].[MONTH] AS [Dim-Maand],
[523].[dbo].[DimTime].[ISO_WEEK_NO] AS [Dim-Weeknummer],
[523].[dbo].[gbkmut].[bkjrcode] AS [Boekjaar],
[523].[dbo].[gbkmut].[periode] AS [Periode],
[523].[dbo].[gbkmut].[datum] AS [Datum],

(
CASE
 when CAST([523].[dbo].[gbkmut].[reknr] AS INT) IN(1810) THEN ([523].[dbo].[gbkmut].[btw_bdr_3] * 100) /
	(SELECT [523].[dbo].[btwtrs].[btwper] FROM [523].[dbo].[btwtrs] WHERE cast([523].[dbo].[btwtrs].[btwtrans] as int) = 10)
 when CAST([523].[dbo].[gbkmut].[reknr] AS INT) IN(1820) THEN ([523].[dbo].[gbkmut].[btw_bdr_3] * 100) /
	(SELECT [523].[dbo].[btwtrs].[btwper] FROM [523].[dbo].[btwtrs] WHERE cast([523].[dbo].[btwtrs].[btwtrans] as int) = 10)
 else [523].[dbo].[gbkmut].[bdr_hfl]
end
) AS [Omzet-bedrag],

[523].[dbo].[btwtrs].[btwper] AS [BTW-percentage],
[523].[dbo].[gbkmut].[btw_bdr_3] AS [BTW-bedrag],
[523].[dbo].[btwtrs].[verlegdbtw] AS [BTW-verlegd],
CAST([523].[dbo].[gbkmut].[reknr] as int) AS [Grootboeknummer],
(
	CASE
	WHEN cast([523].[dbo].[gbkmut].[btw_code] as int) = 10 and (CAST([523].[dbo].[gbkmut].[reknr] AS INT) between 8300 and 8312 or CAST([523].[dbo].[gbkmut].[reknr] AS INT) between 8340 and 8352 or CAST([523].[dbo].[gbkmut].[reknr] AS INT) IN(8000, 8070, 8111, 8120, 8131, 8730, 8790)) THEN '1a Leveringen/diensten belast met hoog tarief'
	WHEN cast([523].[dbo].[gbkmut].[btw_code] as int) = 10 and CAST([523].[dbo].[gbkmut].[reknr] AS INT) IN(1330) and cast([523].[dbo].[gbkmut].[dagbknr] as int) = 60 THEN '1a Leveringen/diensten belast met hoog tarief'
	WHEN cast([523].[dbo].[gbkmut].[btw_code] as Int) = 11 and CAST([523].[dbo].[gbkmut].[reknr] AS INT) IN(8010, 1330) THEN '1b Leveringen/diensten belast met laag tarief'
	WHEN CAST([523].[dbo].[gbkmut].[reknr] AS INT) IN(99999999) THEN '1c Leveringen/diensten belast met overige tarieven, behalve 0%'
	WHEN CAST([523].[dbo].[gbkmut].[reknr] AS INT) IN(1835) THEN '1d Privégebruik'
	WHEN cast([523].[dbo].[gbkmut].[btw_code] as Int) = 13  and CAST([523].[dbo].[gbkmut].[reknr] AS INT) IN(8020, 8710, 1330) THEN '1e Leveringen/diensten belast met 0% of niet bij u belast'
	WHEN CAST([523].[dbo].[gbkmut].[reknr] AS INT) IN(1810) THEN '2a Leveringen/diensten waarbij de heffing van omzetbelasting naar u is verlegd'
	WHEN cast([523].[dbo].[gbkmut].[btw_code] as int) = 16  and CAST([523].[dbo].[gbkmut].[reknr] AS INT) IN(8040, 1330) THEN '3a Leveringen naar landen buiten de EU (uitvoer)'
	WHEN cast([523].[dbo].[gbkmut].[btw_code] as Int) = 17 and CAST([523].[dbo].[gbkmut].[reknr] AS INT) IN(8030, 8250, 1330) THEN '3b Leveringen naar of diensten in landen binnen de EU'
	WHEN CAST([523].[dbo].[gbkmut].[reknr] AS INT) IN(1815) THEN '4a Leveringen/diensten uit landen buiten de EU'
	WHEN CAST([523].[dbo].[gbkmut].[reknr] AS INT) IN(1820) THEN '4b Leveringen/diensten uit landen binnen de EU'
	WHEN CAST([523].[dbo].[gbkmut].[reknr] AS INT) IN(1805) THEN '5b Voorbelasting'
	WHEN CAST([523].[dbo].[gbkmut].[reknr] AS INT) IN(4190) THEN 'IC Personeel'
	WHEN CAST([523].[dbo].[gbkmut].[reknr] AS INT) IN(4499) THEN 'IC Materieel'
	WHEN CAST([523].[dbo].[gbkmut].[reknr] AS INT) IN(1825) THEN 'BTW-controle'
	ELSE 'Uitvalbak' END
) COLLATE database_default AS [OmzetType],

(
	CASE
	WHEN cast([523].[dbo].[gbkmut].[btw_code] as int) = 13 and CAST([523].[dbo].[gbkmut].[reknr] AS INT) IN(8060, 8110, 8130, 8730, 1330) THEN 1
	ELSE NULL END
) AS [OmzetBinnenGroep],


[523].[dbo].[grtbk].[oms25_0] AS [Grootboekomschrijving],
[523].[dbo].[gbkmut].[bkstnr] AS [Boekstuknummer],
[523].[dbo].[gbkmut].[btw_code] AS [BTW-code],
[523].[dbo].[btwtrs].[oms30_0] AS [BTW-codeomschrijving]
FROM
[523].[dbo].[gbkmut]
JOIN [523].[dbo].[DimTime]
ON [523].[dbo].[gbkmut].[datum] = [523].[dbo].[DimTime].[DATE]
JOIN [523].[dbo].[btwtrs]
ON [523].[dbo].[gbkmut].[btw_code] = [523].[dbo].[btwtrs].[btwtrans]
JOIN [523].[dbo].[grtbk]
ON [523].[dbo].[gbkmut].[reknr] = [523].[dbo].[grtbk].[reknr]

where [523].[dbo].[gbkmut].[bkjrcode] between DATEPART(yyyy,getdate()) - 1 and DATEPART(yyyy,getdate())

union all


SELECT
'524 Kraay' AS [Admin],
[524].[dbo].[DimTime].[YEAR] AS [Dim-jaar],
[524].[dbo].[DimTime].[MONTH] AS [Dim-Maand],
[524].[dbo].[DimTime].[ISO_WEEK_NO] AS [Dim-Weeknummer],
[524].[dbo].[gbkmut].[bkjrcode] AS [Boekjaar],
[524].[dbo].[gbkmut].[periode] AS [Periode],
[524].[dbo].[gbkmut].[datum] AS [Datum],
(
CASE
 when CAST([524].[dbo].[gbkmut].[reknr] AS INT) IN(1810) THEN ([524].[dbo].[gbkmut].[btw_bdr_3] * 100) /
	(SELECT [524].[dbo].[btwtrs].[btwper] FROM [524].[dbo].[btwtrs] WHERE cast([524].[dbo].[btwtrs].[btwtrans] as int) = 10)
 when CAST([524].[dbo].[gbkmut].[reknr] AS INT) IN(1820) THEN ([524].[dbo].[gbkmut].[btw_bdr_3] * 100) /
	(SELECT [524].[dbo].[btwtrs].[btwper] FROM [524].[dbo].[btwtrs] WHERE cast([524].[dbo].[btwtrs].[btwtrans] as int) = 10)
 else [524].[dbo].[gbkmut].[bdr_hfl]
end
) AS [Omzet-bedrag],
[524].[dbo].[btwtrs].[btwper] AS [BTW-percentage],
[524].[dbo].[gbkmut].[btw_bdr_3] AS [BTW-bedrag],
[524].[dbo].[btwtrs].[verlegdbtw] AS [BTW-verlegd],
CAST([524].[dbo].[gbkmut].[reknr] as int) AS [Grootboeknummer],
(
	CASE
	WHEN cast([524].[dbo].[gbkmut].[btw_code] as int) = 10 and CAST([524].[dbo].[gbkmut].[reknr] AS INT) IN(8000, 8070, 8111, 8120, 8131, 8730, 8790) THEN '1a Leveringen/diensten belast met hoog tarief'
	WHEN cast([524].[dbo].[gbkmut].[btw_code] as int) = 10 and CAST([524].[dbo].[gbkmut].[reknr] AS INT) IN(1330) and cast([524].[dbo].[gbkmut].[dagbknr] as int) = 60 THEN '1a Leveringen/diensten belast met hoog tarief'
	WHEN cast([524].[dbo].[gbkmut].[btw_code] as Int) = 11 and CAST([524].[dbo].[gbkmut].[reknr] AS INT) IN(8010, 1330) THEN '1b Leveringen/diensten belast met laag tarief'
	WHEN CAST([524].[dbo].[gbkmut].[reknr] AS INT) IN(8200) THEN '1c Leveringen/diensten belast met overige tarieven, behalve 0%'
	WHEN CAST([524].[dbo].[gbkmut].[reknr] AS INT) IN(1835) THEN '1d Privégebruik'
	WHEN cast([524].[dbo].[gbkmut].[btw_code] as Int) = 13  and CAST([524].[dbo].[gbkmut].[reknr] AS INT) IN(8020, 8710, 1330) THEN '1e Leveringen/diensten belast met 0% of niet bij u belast'
	WHEN CAST([524].[dbo].[gbkmut].[reknr] AS INT) IN(1810) THEN '2a Leveringen/diensten waarbij de heffing van omzetbelasting naar u is verlegd'
	WHEN cast([524].[dbo].[gbkmut].[btw_code] as int) = 16  and CAST([524].[dbo].[gbkmut].[reknr] AS INT) IN(8040, 1330) THEN '3a Leveringen naar landen buiten de EU (uitvoer)'
	WHEN cast([524].[dbo].[gbkmut].[btw_code] as Int) = 17 and CAST([524].[dbo].[gbkmut].[reknr] AS INT) IN(8030, 8250, 1330) THEN '3b Leveringen naar of diensten in landen binnen de EU'
	WHEN CAST([524].[dbo].[gbkmut].[reknr] AS INT) IN(1815) THEN '4a Leveringen/diensten uit landen buiten de EU'
	WHEN CAST([524].[dbo].[gbkmut].[reknr] AS INT) IN(1820) THEN '4b Leveringen/diensten uit landen binnen de EU'
	WHEN CAST([524].[dbo].[gbkmut].[reknr] AS INT) IN(1805) THEN '5b Voorbelasting'
	WHEN CAST([524].[dbo].[gbkmut].[reknr] AS INT) IN(4190) THEN 'IC Personeel'
	WHEN CAST([524].[dbo].[gbkmut].[reknr] AS INT) IN(4499) THEN 'IC Materieel'
	WHEN CAST([524].[dbo].[gbkmut].[reknr] AS INT) IN(1825) THEN 'BTW-controle'
	ELSE 'Uitvalbak' END
) COLLATE database_default AS [OmzetType],

(
	CASE
	WHEN cast([524].[dbo].[gbkmut].[btw_code] as int) = 13 and CAST([524].[dbo].[gbkmut].[reknr] AS INT) IN(8060, 8110, 8130, 8730, 1330) THEN 1
	ELSE NULL END
) AS [OmzetBinnenGroep],


[524].[dbo].[grtbk].[oms25_0] AS [Grootboekomschrijving],
[524].[dbo].[gbkmut].[bkstnr] AS [Boekstuknummer],
[524].[dbo].[gbkmut].[btw_code] AS [BTW-code],
[524].[dbo].[btwtrs].[oms30_0] AS [BTW-codeomschrijving]
FROM
[524].[dbo].[gbkmut]
JOIN [524].[dbo].[DimTime]
ON [524].[dbo].[gbkmut].[datum] = [524].[dbo].[DimTime].[DATE]
JOIN [524].[dbo].[btwtrs]
ON [524].[dbo].[gbkmut].[btw_code] = [524].[dbo].[btwtrs].[btwtrans]
JOIN [524].[dbo].[grtbk]
ON [524].[dbo].[gbkmut].[reknr] = [524].[dbo].[grtbk].[reknr]

where [524].[dbo].[gbkmut].[bkjrcode] between DATEPART(yyyy,getdate()) - 1 and DATEPART(yyyy,getdate())


union all

SELECT
'525 Zeecom' AS [Admin],
[525].[dbo].[DimTime].[YEAR] AS [Dim-jaar],
[525].[dbo].[DimTime].[MONTH] AS [Dim-Maand],
[525].[dbo].[DimTime].[ISO_WEEK_NO] AS [Dim-Weeknummer],
[525].[dbo].[gbkmut].[bkjrcode] AS [Boekjaar],
[525].[dbo].[gbkmut].[periode] AS [Periode],
[525].[dbo].[gbkmut].[datum] AS [Datum],
(
CASE
 when CAST([525].[dbo].[gbkmut].[reknr] AS INT) IN(1810) THEN ([525].[dbo].[gbkmut].[btw_bdr_3] * 100) /
	(SELECT [525].[dbo].[btwtrs].[btwper] FROM [525].[dbo].[btwtrs] WHERE cast([525].[dbo].[btwtrs].[btwtrans] as int) = 10)
 when CAST([525].[dbo].[gbkmut].[reknr] AS INT) IN(1820) THEN ([525].[dbo].[gbkmut].[btw_bdr_3] * 100) /
	(SELECT [525].[dbo].[btwtrs].[btwper] FROM [525].[dbo].[btwtrs] WHERE cast([525].[dbo].[btwtrs].[btwtrans] as int) = 10)
 else [525].[dbo].[gbkmut].[bdr_hfl]
end
) AS [Omzet-bedrag],
[525].[dbo].[btwtrs].[btwper] AS [BTW-percentage],
[525].[dbo].[gbkmut].[btw_bdr_3] AS [BTW-bedrag],
[525].[dbo].[btwtrs].[verlegdbtw] AS [BTW-verlegd],
CAST([525].[dbo].[gbkmut].[reknr] as int) AS [Grootboeknummer],
(
	CASE
	WHEN cast([525].[dbo].[gbkmut].[btw_code] as int) = 10 and CAST([525].[dbo].[gbkmut].[reknr] AS INT) IN(8000, 8070, 8111, 8120, 8131, 8730, 8790) THEN '1a Leveringen/diensten belast met hoog tarief'
	WHEN cast([525].[dbo].[gbkmut].[btw_code] as int) = 10 and CAST([525].[dbo].[gbkmut].[reknr] AS INT) IN(1330) and cast([525].[dbo].[gbkmut].[dagbknr] as int) = 60 THEN '1a Leveringen/diensten belast met hoog tarief'
	WHEN cast([525].[dbo].[gbkmut].[btw_code] as Int) = 11 and CAST([525].[dbo].[gbkmut].[reknr] AS INT) IN(8010, 1330) THEN '1b Leveringen/diensten belast met laag tarief'
	WHEN CAST([525].[dbo].[gbkmut].[reknr] AS INT) IN(8200) THEN '1c Leveringen/diensten belast met overige tarieven, behalve 0%'
	WHEN CAST([525].[dbo].[gbkmut].[reknr] AS INT) IN(1835) THEN '1d Privégebruik'
	WHEN cast([525].[dbo].[gbkmut].[btw_code] as Int) = 13  and CAST([525].[dbo].[gbkmut].[reknr] AS INT) IN(8020, 8710, 1330) THEN '1e Leveringen/diensten belast met 0% of niet bij u belast'
	WHEN CAST([525].[dbo].[gbkmut].[reknr] AS INT) IN(1810) THEN '2a Leveringen/diensten waarbij de heffing van omzetbelasting naar u is verlegd'
	WHEN cast([525].[dbo].[gbkmut].[btw_code] as int) = 16  and CAST([525].[dbo].[gbkmut].[reknr] AS INT) IN(8040, 1330) THEN '3a Leveringen naar landen buiten de EU (uitvoer)'
	WHEN cast([525].[dbo].[gbkmut].[btw_code] as Int) = 17 and CAST([525].[dbo].[gbkmut].[reknr] AS INT) IN(8030, 8250, 1330) THEN '3b Leveringen naar of diensten in landen binnen de EU'
	WHEN CAST([525].[dbo].[gbkmut].[reknr] AS INT) IN(1815) THEN '4a Leveringen/diensten uit landen buiten de EU'
	WHEN CAST([525].[dbo].[gbkmut].[reknr] AS INT) IN(1820) THEN '4b Leveringen/diensten uit landen binnen de EU'
	WHEN CAST([525].[dbo].[gbkmut].[reknr] AS INT) IN(1805) THEN '5b Voorbelasting'
	WHEN CAST([525].[dbo].[gbkmut].[reknr] AS INT) IN(4190) THEN 'IC Personeel'
	WHEN CAST([525].[dbo].[gbkmut].[reknr] AS INT) IN(4499) THEN 'IC Materieel'
	WHEN CAST([525].[dbo].[gbkmut].[reknr] AS INT) IN(1825) THEN 'BTW-controle'
	ELSE 'Uitvalbak' END
) COLLATE database_default AS [OmzetType],

(
	CASE
	WHEN cast([525].[dbo].[gbkmut].[btw_code] as int) = 13 and CAST([525].[dbo].[gbkmut].[reknr] AS INT) IN(8060, 8110, 8130, 8730, 1330) THEN 1
	ELSE NULL END
) AS [OmzetBinnenGroep],


[525].[dbo].[grtbk].[oms25_0] AS [Grootboekomschrijving],
[525].[dbo].[gbkmut].[bkstnr] AS [Boekstuknummer],
[525].[dbo].[gbkmut].[btw_code] AS [BTW-code],
[525].[dbo].[btwtrs].[oms30_0] AS [BTW-codeomschrijving]
FROM
[525].[dbo].[gbkmut]
JOIN [525].[dbo].[DimTime]
ON [525].[dbo].[gbkmut].[datum] = [525].[dbo].[DimTime].[DATE]
JOIN [525].[dbo].[btwtrs]
ON [525].[dbo].[gbkmut].[btw_code] = [525].[dbo].[btwtrs].[btwtrans]
JOIN [525].[dbo].[grtbk]
ON [525].[dbo].[gbkmut].[reknr] = [525].[dbo].[grtbk].[reknr]

where [525].[dbo].[gbkmut].[bkjrcode] between DATEPART(yyyy,getdate()) - 1 and DATEPART(yyyy,getdate())


union all


SELECT
'541 INN' AS [Admin],
[541].[dbo].[DimTime].[YEAR] AS [Dim-jaar],
[541].[dbo].[DimTime].[MONTH] AS [Dim-Maand],
[541].[dbo].[DimTime].[ISO_WEEK_NO] AS [Dim-Weeknummer],
[541].[dbo].[gbkmut].[bkjrcode] AS [Boekjaar],
[541].[dbo].[gbkmut].[periode] AS [Periode],
[541].[dbo].[gbkmut].[datum] AS [Datum],
(
CASE
 when CAST([541].[dbo].[gbkmut].[reknr] AS INT) IN(1810) THEN ([541].[dbo].[gbkmut].[btw_bdr_3] * 100) /
	(SELECT [541].[dbo].[btwtrs].[btwper] FROM [541].[dbo].[btwtrs] WHERE cast([541].[dbo].[btwtrs].[btwtrans] as int) = 10)
 when CAST([541].[dbo].[gbkmut].[reknr] AS INT) IN(1820) THEN ([541].[dbo].[gbkmut].[btw_bdr_3] * 100) /
	(SELECT [541].[dbo].[btwtrs].[btwper] FROM [541].[dbo].[btwtrs] WHERE cast([541].[dbo].[btwtrs].[btwtrans] as int) = 10)
 else [541].[dbo].[gbkmut].[bdr_hfl]
end
) AS [Omzet-bedrag],
[541].[dbo].[btwtrs].[btwper] AS [BTW-percentage],
[541].[dbo].[gbkmut].[btw_bdr_3] AS [BTW-bedrag],
[541].[dbo].[btwtrs].[verlegdbtw] AS [BTW-verlegd],
CAST([541].[dbo].[gbkmut].[reknr] as int) AS [Grootboeknummer],
(
	CASE
	WHEN cast([541].[dbo].[gbkmut].[btw_code] as int) = 10 and CAST([541].[dbo].[gbkmut].[reknr] AS INT) IN(8000, 8070, 8111, 8120, 8131, 8730, 8790) THEN '1a Leveringen/diensten belast met hoog tarief'
	WHEN cast([541].[dbo].[gbkmut].[btw_code] as int) = 10 and CAST([541].[dbo].[gbkmut].[reknr] AS INT) IN(1330) and cast([541].[dbo].[gbkmut].[dagbknr] as int) = 60 THEN '1a Leveringen/diensten belast met hoog tarief'
	WHEN cast([541].[dbo].[gbkmut].[btw_code] as Int) = 11 and CAST([541].[dbo].[gbkmut].[reknr] AS INT) IN(8010, 1330) THEN '1b Leveringen/diensten belast met laag tarief'
	WHEN CAST([541].[dbo].[gbkmut].[reknr] AS INT) IN(8200) THEN '1c Leveringen/diensten belast met overige tarieven, behalve 0%'
	WHEN CAST([541].[dbo].[gbkmut].[reknr] AS INT) IN(1835) THEN '1d Privégebruik'
	WHEN cast([541].[dbo].[gbkmut].[btw_code] as Int) = 13  and CAST([541].[dbo].[gbkmut].[reknr] AS INT) IN(8020, 8710, 1330) THEN '1e Leveringen/diensten belast met 0% of niet bij u belast'
	WHEN CAST([541].[dbo].[gbkmut].[reknr] AS INT) IN(1810) THEN '2a Leveringen/diensten waarbij de heffing van omzetbelasting naar u is verlegd'
	WHEN cast([541].[dbo].[gbkmut].[btw_code] as int) = 16  and CAST([541].[dbo].[gbkmut].[reknr] AS INT) IN(8040, 1330) THEN '3a Leveringen naar landen buiten de EU (uitvoer)'
	WHEN cast([541].[dbo].[gbkmut].[btw_code] as Int) = 17 and CAST([541].[dbo].[gbkmut].[reknr] AS INT) IN(8030, 8250, 1330) THEN '3b Leveringen naar of diensten in landen binnen de EU'
	WHEN CAST([541].[dbo].[gbkmut].[reknr] AS INT) IN(1815) THEN '4a Leveringen/diensten uit landen buiten de EU'
	WHEN CAST([541].[dbo].[gbkmut].[reknr] AS INT) IN(1820) THEN '4b Leveringen/diensten uit landen binnen de EU'
	WHEN CAST([541].[dbo].[gbkmut].[reknr] AS INT) IN(1805) THEN '5b Voorbelasting'
	WHEN CAST([541].[dbo].[gbkmut].[reknr] AS INT) IN(4190) THEN 'IC Personeel'
	WHEN CAST([541].[dbo].[gbkmut].[reknr] AS INT) IN(4499) THEN 'IC Materieel'
	WHEN CAST([541].[dbo].[gbkmut].[reknr] AS INT) IN(1825) THEN 'BTW-controle'
	ELSE 'Uitvalbak' END
) COLLATE database_default AS [OmzetType],

(
	CASE
	WHEN cast([541].[dbo].[gbkmut].[btw_code] as int) = 13 and CAST([541].[dbo].[gbkmut].[reknr] AS INT) IN(8060, 8110, 8130, 8730, 1330) THEN 1
	ELSE NULL END
) AS [OmzetBinnenGroep],


[541].[dbo].[grtbk].[oms25_0] AS [Grootboekomschrijving],
[541].[dbo].[gbkmut].[bkstnr] AS [Boekstuknummer],
[541].[dbo].[gbkmut].[btw_code] AS [BTW-code],
[541].[dbo].[btwtrs].[oms30_0] AS [BTW-codeomschrijving]
FROM
[541].[dbo].[gbkmut]
JOIN [541].[dbo].[DimTime]
ON [541].[dbo].[gbkmut].[datum] = [541].[dbo].[DimTime].[DATE]
JOIN [541].[dbo].[btwtrs]
ON [541].[dbo].[gbkmut].[btw_code] = [541].[dbo].[btwtrs].[btwtrans]
JOIN [541].[dbo].[grtbk]
ON [541].[dbo].[gbkmut].[reknr] = [541].[dbo].[grtbk].[reknr]

where [541].[dbo].[gbkmut].[bkjrcode]between DATEPART(yyyy,getdate()) - 1 and DATEPART(yyyy,getdate())


union all

SELECT
'542 GBZ' AS [Admin],
[542].[dbo].[DimTime].[YEAR] AS [Dim-jaar],
[542].[dbo].[DimTime].[MONTH] AS [Dim-Maand],
[542].[dbo].[DimTime].[ISO_WEEK_NO] AS [Dim-Weeknummer],
[542].[dbo].[gbkmut].[bkjrcode] AS [Boekjaar],
[542].[dbo].[gbkmut].[periode] AS [Periode],
[542].[dbo].[gbkmut].[datum] AS [Datum],
(
CASE
 when CAST([542].[dbo].[gbkmut].[reknr] AS INT) IN(1810) THEN ([542].[dbo].[gbkmut].[btw_bdr_3] * 100) /
	(SELECT [542].[dbo].[btwtrs].[btwper] FROM [542].[dbo].[btwtrs] WHERE cast([542].[dbo].[btwtrs].[btwtrans] as int) = 10)
 when CAST([542].[dbo].[gbkmut].[reknr] AS INT) IN(1820) THEN ([542].[dbo].[gbkmut].[btw_bdr_3] * 100) /
	(SELECT [542].[dbo].[btwtrs].[btwper] FROM [542].[dbo].[btwtrs] WHERE cast([542].[dbo].[btwtrs].[btwtrans] as int) = 10)
 else [542].[dbo].[gbkmut].[bdr_hfl]
end
) AS [Omzet-bedrag],
[542].[dbo].[btwtrs].[btwper] AS [BTW-percentage],
[542].[dbo].[gbkmut].[btw_bdr_3] AS [BTW-bedrag],
[542].[dbo].[btwtrs].[verlegdbtw] AS [BTW-verlegd],
CAST([542].[dbo].[gbkmut].[reknr] as int) AS [Grootboeknummer],
(
	CASE
	WHEN cast([542].[dbo].[gbkmut].[btw_code] as int) = 10 and CAST([542].[dbo].[gbkmut].[reknr] AS INT) IN(8000, 8070, 8111, 8120, 8131, 8730, 8790) THEN '1a Leveringen/diensten belast met hoog tarief'
	WHEN cast([542].[dbo].[gbkmut].[btw_code] as int) = 10 and CAST([542].[dbo].[gbkmut].[reknr] AS INT) IN(1330) and cast([542].[dbo].[gbkmut].[dagbknr] as int) = 60 THEN '1a Leveringen/diensten belast met hoog tarief'
	WHEN cast([542].[dbo].[gbkmut].[btw_code] as Int) = 11 and CAST([542].[dbo].[gbkmut].[reknr] AS INT) IN(8010, 1330) THEN '1b Leveringen/diensten belast met laag tarief'
	WHEN CAST([542].[dbo].[gbkmut].[reknr] AS INT) IN(8200) THEN '1c Leveringen/diensten belast met overige tarieven, behalve 0%'
	WHEN CAST([542].[dbo].[gbkmut].[reknr] AS INT) IN(1835) THEN '1d Privégebruik'
	WHEN cast([542].[dbo].[gbkmut].[btw_code] as Int) = 13  and CAST([542].[dbo].[gbkmut].[reknr] AS INT) IN(8020, 8710, 1330) THEN '1e Leveringen/diensten belast met 0% of niet bij u belast'
	WHEN CAST([542].[dbo].[gbkmut].[reknr] AS INT) IN(1810) THEN '2a Leveringen/diensten waarbij de heffing van omzetbelasting naar u is verlegd'
	WHEN cast([542].[dbo].[gbkmut].[btw_code] as int) = 16  and CAST([542].[dbo].[gbkmut].[reknr] AS INT) IN(8040, 1330) THEN '3a Leveringen naar landen buiten de EU (uitvoer)'
	WHEN cast([542].[dbo].[gbkmut].[btw_code] as Int) = 17 and CAST([542].[dbo].[gbkmut].[reknr] AS INT) IN(8030, 8250, 1330) THEN '3b Leveringen naar of diensten in landen binnen de EU'
	WHEN CAST([542].[dbo].[gbkmut].[reknr] AS INT) IN(1815) THEN '4a Leveringen/diensten uit landen buiten de EU'
	WHEN CAST([542].[dbo].[gbkmut].[reknr] AS INT) IN(1820) THEN '4b Leveringen/diensten uit landen binnen de EU'
	WHEN CAST([542].[dbo].[gbkmut].[reknr] AS INT) IN(1805) THEN '5b Voorbelasting'
	WHEN CAST([542].[dbo].[gbkmut].[reknr] AS INT) IN(4190) THEN 'IC Personeel'
	WHEN CAST([542].[dbo].[gbkmut].[reknr] AS INT) IN(4499) THEN 'IC Materieel'
	WHEN CAST([542].[dbo].[gbkmut].[reknr] AS INT) IN(1825) THEN 'BTW-controle'
	ELSE 'Uitvalbak' END
) COLLATE database_default AS [OmzetType],

(
	CASE
	WHEN cast([542].[dbo].[gbkmut].[btw_code] as int) = 13 and CAST([542].[dbo].[gbkmut].[reknr] AS INT) IN(8060, 8110, 8130, 8730, 1330) THEN 1
	ELSE NULL END
) AS [OmzetBinnenGroep],


[542].[dbo].[grtbk].[oms25_0] AS [Grootboekomschrijving],
[542].[dbo].[gbkmut].[bkstnr] AS [Boekstuknummer],
[542].[dbo].[gbkmut].[btw_code] AS [BTW-code],
[542].[dbo].[btwtrs].[oms30_0] AS [BTW-codeomschrijving]
FROM
[542].[dbo].[gbkmut]
JOIN [542].[dbo].[DimTime]
ON [542].[dbo].[gbkmut].[datum] = [542].[dbo].[DimTime].[DATE]
JOIN [542].[dbo].[btwtrs]
ON [542].[dbo].[gbkmut].[btw_code] = [542].[dbo].[btwtrs].[btwtrans]
JOIN [542].[dbo].[grtbk]
ON [542].[dbo].[gbkmut].[reknr] = [542].[dbo].[grtbk].[reknr]

where [542].[dbo].[gbkmut].[bkjrcode] between DATEPART(yyyy,getdate()) - 1 and DATEPART(yyyy,getdate())


union all


SELECT
'544 IH' AS [Admin],
[544].[dbo].[DimTime].[YEAR] AS [Dim-jaar],
[544].[dbo].[DimTime].[MONTH] AS [Dim-Maand],
[544].[dbo].[DimTime].[ISO_WEEK_NO] AS [Dim-Weeknummer],
[544].[dbo].[gbkmut].[bkjrcode] AS [Boekjaar],
[544].[dbo].[gbkmut].[periode] AS [Periode],
[544].[dbo].[gbkmut].[datum] AS [Datum],
(
CASE
 when CAST([544].[dbo].[gbkmut].[reknr] AS INT) IN(1810) THEN ([544].[dbo].[gbkmut].[btw_bdr_3] * 100) /
	(SELECT [544].[dbo].[btwtrs].[btwper] FROM [544].[dbo].[btwtrs] WHERE cast([544].[dbo].[btwtrs].[btwtrans] as int) = 10)
 when CAST([544].[dbo].[gbkmut].[reknr] AS INT) IN(1820) THEN ([544].[dbo].[gbkmut].[btw_bdr_3] * 100) /
	(SELECT [544].[dbo].[btwtrs].[btwper] FROM [544].[dbo].[btwtrs] WHERE cast([544].[dbo].[btwtrs].[btwtrans] as int) = 10)
 else [544].[dbo].[gbkmut].[bdr_hfl]
end
) AS [Omzet-bedrag],
[544].[dbo].[btwtrs].[btwper] AS [BTW-percentage],
[544].[dbo].[gbkmut].[btw_bdr_3] AS [BTW-bedrag],
[544].[dbo].[btwtrs].[verlegdbtw] AS [BTW-verlegd],
CAST([544].[dbo].[gbkmut].[reknr] as int) AS [Grootboeknummer],
(
	CASE
	WHEN cast([544].[dbo].[gbkmut].[btw_code] as int) = 10 and CAST([544].[dbo].[gbkmut].[reknr] AS INT) IN(8000, 8070, 8111, 8120, 8131, 8730, 8790) THEN '1a Leveringen/diensten belast met hoog tarief'
	WHEN cast([544].[dbo].[gbkmut].[btw_code] as int) = 10 and CAST([544].[dbo].[gbkmut].[reknr] AS INT) IN(1330) and cast([544].[dbo].[gbkmut].[dagbknr] as int) = 60 THEN '1a Leveringen/diensten belast met hoog tarief'
	WHEN cast([544].[dbo].[gbkmut].[btw_code] as Int) = 11 and CAST([544].[dbo].[gbkmut].[reknr] AS INT) IN(8010, 1330) THEN '1b Leveringen/diensten belast met laag tarief'
	WHEN CAST([544].[dbo].[gbkmut].[reknr] AS INT) IN(8200) THEN '1c Leveringen/diensten belast met overige tarieven, behalve 0%'
	WHEN CAST([544].[dbo].[gbkmut].[reknr] AS INT) IN(1835) THEN '1d Privégebruik'
	WHEN cast([544].[dbo].[gbkmut].[btw_code] as Int) = 13  and CAST([544].[dbo].[gbkmut].[reknr] AS INT) IN(8020, 8710, 1330) THEN '1e Leveringen/diensten belast met 0% of niet bij u belast'
	WHEN CAST([544].[dbo].[gbkmut].[reknr] AS INT) IN(1810) THEN '2a Leveringen/diensten waarbij de heffing van omzetbelasting naar u is verlegd'
	WHEN cast([544].[dbo].[gbkmut].[btw_code] as int) = 16  and CAST([544].[dbo].[gbkmut].[reknr] AS INT) IN(8040, 1330) THEN '3a Leveringen naar landen buiten de EU (uitvoer)'
	WHEN cast([544].[dbo].[gbkmut].[btw_code] as Int) = 17 and CAST([544].[dbo].[gbkmut].[reknr] AS INT) IN(8030, 8250, 1330) THEN '3b Leveringen naar of diensten in landen binnen de EU'
	WHEN CAST([544].[dbo].[gbkmut].[reknr] AS INT) IN(1815) THEN '4a Leveringen/diensten uit landen buiten de EU'
	WHEN CAST([544].[dbo].[gbkmut].[reknr] AS INT) IN(1820) THEN '4b Leveringen/diensten uit landen binnen de EU'
	WHEN CAST([544].[dbo].[gbkmut].[reknr] AS INT) IN(1805) THEN '5b Voorbelasting'
	WHEN CAST([544].[dbo].[gbkmut].[reknr] AS INT) IN(4190) THEN 'IC Personeel'
	WHEN CAST([544].[dbo].[gbkmut].[reknr] AS INT) IN(4499) THEN 'IC Materieel'
	WHEN CAST([544].[dbo].[gbkmut].[reknr] AS INT) IN(1825) THEN 'BTW-controle'
	ELSE 'Uitvalbak' END
) COLLATE database_default AS [OmzetType],

(
	CASE
	WHEN cast([544].[dbo].[gbkmut].[btw_code] as int) = 13 and CAST([544].[dbo].[gbkmut].[reknr] AS INT) IN(8060, 8110, 8130, 8730, 1330) THEN 1
	ELSE NULL END
) AS [OmzetBinnenGroep],


[544].[dbo].[grtbk].[oms25_0] AS [Grootboekomschrijving],
[544].[dbo].[gbkmut].[bkstnr] AS [Boekstuknummer],
[544].[dbo].[gbkmut].[btw_code] AS [BTW-code],
[544].[dbo].[btwtrs].[oms30_0] AS [BTW-codeomschrijving]
FROM
[544].[dbo].[gbkmut]
JOIN [544].[dbo].[DimTime]
ON [544].[dbo].[gbkmut].[datum] = [544].[dbo].[DimTime].[DATE]
JOIN [544].[dbo].[btwtrs]
ON [544].[dbo].[gbkmut].[btw_code] = [544].[dbo].[btwtrs].[btwtrans]
JOIN [544].[dbo].[grtbk]
ON [544].[dbo].[gbkmut].[reknr] = [544].[dbo].[grtbk].[reknr]

where [544].[dbo].[gbkmut].[bkjrcode] between DATEPART(yyyy,getdate()) - 1 and DATEPART(yyyy,getdate())


union all


SELECT
'581 TV' AS [Admin],
[581].[dbo].[DimTime].[YEAR] AS [Dim-jaar],
[581].[dbo].[DimTime].[MONTH] AS [Dim-Maand],
[581].[dbo].[DimTime].[ISO_WEEK_NO] AS [Dim-Weeknummer],
[581].[dbo].[gbkmut].[bkjrcode] AS [Boekjaar],
[581].[dbo].[gbkmut].[periode] AS [Periode],
[581].[dbo].[gbkmut].[datum] AS [Datum],
(
CASE
 when CAST([581].[dbo].[gbkmut].[reknr] AS INT) IN(1810) THEN ([581].[dbo].[gbkmut].[btw_bdr_3] * 100) /
	(SELECT [581].[dbo].[btwtrs].[btwper] FROM [581].[dbo].[btwtrs] WHERE cast([581].[dbo].[btwtrs].[btwtrans] as int) = 10)
 when CAST([581].[dbo].[gbkmut].[reknr] AS INT) IN(1820) THEN ([581].[dbo].[gbkmut].[btw_bdr_3] * 100) /
	(SELECT [581].[dbo].[btwtrs].[btwper] FROM [581].[dbo].[btwtrs] WHERE cast([581].[dbo].[btwtrs].[btwtrans] as int) = 10)
 else [581].[dbo].[gbkmut].[bdr_hfl]
end
) AS [Omzet-bedrag],
[581].[dbo].[btwtrs].[btwper] AS [BTW-percentage],
[581].[dbo].[gbkmut].[btw_bdr_3] AS [BTW-bedrag],
[581].[dbo].[btwtrs].[verlegdbtw] AS [BTW-verlegd],
CAST([581].[dbo].[gbkmut].[reknr] as int) AS [Grootboeknummer],
(
	CASE
	WHEN cast([581].[dbo].[gbkmut].[btw_code] as int) = 10 and CAST([581].[dbo].[gbkmut].[reknr] AS INT) IN(8000, 8070, 8111, 8120, 8131, 8730, 8790) THEN '1a Leveringen/diensten belast met hoog tarief'
	WHEN cast([581].[dbo].[gbkmut].[btw_code] as int) = 10 and CAST([581].[dbo].[gbkmut].[reknr] AS INT) IN(1330) and cast([581].[dbo].[gbkmut].[dagbknr] as int) = 60 THEN '1a Leveringen/diensten belast met hoog tarief'
	WHEN cast([581].[dbo].[gbkmut].[btw_code] as Int) = 11 and CAST([581].[dbo].[gbkmut].[reknr] AS INT) IN(8010, 1330) THEN '1b Leveringen/diensten belast met laag tarief'
	WHEN CAST([581].[dbo].[gbkmut].[reknr] AS INT) IN(8200) THEN '1c Leveringen/diensten belast met overige tarieven, behalve 0%'
	WHEN CAST([581].[dbo].[gbkmut].[reknr] AS INT) IN(1835) THEN '1d Privégebruik'
	WHEN cast([581].[dbo].[gbkmut].[btw_code] as Int) = 13  and CAST([581].[dbo].[gbkmut].[reknr] AS INT) IN(8020, 8710, 1330) THEN '1e Leveringen/diensten belast met 0% of niet bij u belast'
	WHEN CAST([581].[dbo].[gbkmut].[reknr] AS INT) IN(1810) THEN '2a Leveringen/diensten waarbij de heffing van omzetbelasting naar u is verlegd'
	WHEN cast([581].[dbo].[gbkmut].[btw_code] as int) = 16  and CAST([581].[dbo].[gbkmut].[reknr] AS INT) IN(8040, 1330) THEN '3a Leveringen naar landen buiten de EU (uitvoer)'
	WHEN cast([581].[dbo].[gbkmut].[btw_code] as Int) = 17 and CAST([581].[dbo].[gbkmut].[reknr] AS INT) IN(8030, 8250, 1330) THEN '3b Leveringen naar of diensten in landen binnen de EU'
	WHEN CAST([581].[dbo].[gbkmut].[reknr] AS INT) IN(1815) THEN '4a Leveringen/diensten uit landen buiten de EU'
	WHEN CAST([581].[dbo].[gbkmut].[reknr] AS INT) IN(1820) THEN '4b Leveringen/diensten uit landen binnen de EU'
	WHEN CAST([581].[dbo].[gbkmut].[reknr] AS INT) IN(1805) THEN '5b Voorbelasting'
	WHEN CAST([581].[dbo].[gbkmut].[reknr] AS INT) IN(4190) THEN 'IC Personeel'
	WHEN CAST([581].[dbo].[gbkmut].[reknr] AS INT) IN(4499) THEN 'IC Materieel'
	WHEN CAST([581].[dbo].[gbkmut].[reknr] AS INT) IN(1825) THEN 'BTW-controle'
	ELSE 'Uitvalbak' END
) COLLATE database_default AS [OmzetType],

(
	CASE
	WHEN cast([581].[dbo].[gbkmut].[btw_code] as int) = 13 and CAST([581].[dbo].[gbkmut].[reknr] AS INT) IN(8060, 8110, 8130, 8730, 1330) THEN 1
	ELSE NULL END
) AS [OmzetBinnenGroep],


[581].[dbo].[grtbk].[oms25_0] AS [Grootboekomschrijving],
[581].[dbo].[gbkmut].[bkstnr] AS [Boekstuknummer],
[581].[dbo].[gbkmut].[btw_code] AS [BTW-code],
[581].[dbo].[btwtrs].[oms30_0] AS [BTW-codeomschrijving]
FROM
[581].[dbo].[gbkmut]
JOIN [581].[dbo].[DimTime]
ON [581].[dbo].[gbkmut].[datum] = [581].[dbo].[DimTime].[DATE]
JOIN [581].[dbo].[btwtrs]
ON [581].[dbo].[gbkmut].[btw_code] = [581].[dbo].[btwtrs].[btwtrans]
JOIN [581].[dbo].[grtbk]
ON [581].[dbo].[gbkmut].[reknr] = [581].[dbo].[grtbk].[reknr]

where [581].[dbo].[gbkmut].[bkjrcode] between DATEPART(yyyy,getdate()) - 1 and DATEPART(yyyy,getdate())


/* toevoegen beginbalansen  grootboekrekeningen */

UNION ALL



SELECT

'512 SHZ' AS [Admin],
case
when month(GETDATE()) = 1 then year(GETDATE()) - 1
else year(GETDATE())
end AS [Dim-jaar],

case
when month(GETDATE()) = 1 then 12
else month(GETDATE()) - 1
end AS [Dim-Maand],

53 AS [Dim-Weeknummer],

case
when month(GETDATE()) = 1 then year(GETDATE()) - 1
else year(GETDATE())
end as [Boekjaar],

month(GETDATE()) AS [Periode],
CONVERT(VARCHAR(4),DATEPART(YEAR, GETDATE()))
       + '/'+ CONVERT(VARCHAR(2),DATEPART(MONTH, GETDATE())-1)
       + '/' + CONVERT(VARCHAR(2),01)  as [Datum],

0 as [Omzet-bedrag],
0 AS [BTW-percentage],
sum([512].[dbo].[GeneralLedgerBalances].[AmountDC]) AS [BTW-bedrag],
0 AS [BTW-verlegd],
1805 AS [Grootboeknummer],

'5b Voorbelasting' COLLATE database_default AS [OmzetType],

1 AS [OmzetBinnenGroep],

'Beginsaldo' AS [Grootboekomschrijving],
'Beginsaldo' AS [Boekstuknummer],
'Beginsaldo' AS [BTW-code],
'Beginsaldo' collate database_default AS [BTW-codeomschrijving]

FROM
[512].[dbo].[DimTime]
JOIN [512].[dbo].[GeneralLedgerBalances]
ON [512].[dbo].[DimTime].[DATE] = [512].[dbo].[GeneralLedgerBalances].[Date]
WHERE
cast([512].[dbo].[GeneralLedgerBalances].[GeneralLedger] as Integer) in(1805)
and [512].[dbo].[DimTime].[YEAR] <
case
when month(GETDATE()) = 1 then year(GETDATE()) - 1
else year(GETDATE())
end


UNION ALL

SELECT

'521 SAZ' AS [Admin],
case
when month(GETDATE()) = 1 then year(GETDATE()) - 1
else year(GETDATE())
end AS [Dim-jaar],

case
when month(GETDATE()) = 1 then 12
else month(GETDATE()) - 1
end AS [Dim-Maand],

53 AS [Dim-Weeknummer],

case
when month(GETDATE()) = 1 then year(GETDATE()) - 1
else year(GETDATE())
end as [Boekjaar],

month(GETDATE()) AS [Periode],
CONVERT(VARCHAR(4),DATEPART(YEAR, GETDATE()))
       + '/'+ CONVERT(VARCHAR(2),DATEPART(MONTH, GETDATE())-1)
       + '/' + CONVERT(VARCHAR(2),01)  as [Datum],

0 as [Omzet-bedrag],

0 AS [BTW-percentage],
sum([521].[dbo].[GeneralLedgerBalances].[AmountDC]) AS [BTW-bedrag],
0 AS [BTW-verlegd],
1810 AS [Grootboeknummer],

'2a Leveringen/diensten waarbij de heffing van omzetbelasting naar u is verlegd' COLLATE database_default AS [OmzetType],

1 AS [OmzetBinnenGroep],

'Beginsaldo' AS [Grootboekomschrijving],
'Beginsaldo' AS [Boekstuknummer],
'Beginsaldo' AS [BTW-code],
'Beginsaldo' collate database_default AS [BTW-codeomschrijving]

FROM
[521].[dbo].[DimTime]
JOIN [521].[dbo].[GeneralLedgerBalances]
ON [521].[dbo].[DimTime].[DATE] = [521].[dbo].[GeneralLedgerBalances].[Date]
WHERE
cast([521].[dbo].[GeneralLedgerBalances].[GeneralLedger] as Integer) in(1810)
and [521].[dbo].[DimTime].[YEAR] <
case
when month(GETDATE()) = 1 then year(GETDATE()) - 1
else year(GETDATE())
end


UNION ALL


SELECT

'521 SAZ' AS [Admin],
case
when month(GETDATE()) = 1 then year(GETDATE()) - 1
else year(GETDATE())
end AS [Dim-jaar],

case
when month(GETDATE()) = 1 then 12
else month(GETDATE()) - 1
end AS [Dim-Maand],

53 AS [Dim-Weeknummer],

case
when month(GETDATE()) = 1 then year(GETDATE()) - 1
else year(GETDATE())
end as [Boekjaar],

month(GETDATE()) AS [Periode],
CONVERT(VARCHAR(4),DATEPART(YEAR, GETDATE()))
       + '/'+ CONVERT(VARCHAR(2),DATEPART(MONTH, GETDATE())-1)
       + '/' + CONVERT(VARCHAR(2),01)  as [Datum],

0 as [Omzet-bedrag],

0 AS [BTW-percentage],
sum([521].[dbo].[GeneralLedgerBalances].[AmountDC]) AS [BTW-bedrag],
0 AS [BTW-verlegd],
1805 AS [Grootboeknummer],

'5b Voorbelasting' COLLATE database_default AS [OmzetType],

1 AS [OmzetBinnenGroep],

'Beginsaldo' AS [Grootboekomschrijving],
'Beginsaldo' AS [Boekstuknummer],
'Beginsaldo' AS [BTW-code],
'Beginsaldo' collate database_default AS [BTW-codeomschrijving]

FROM
[521].[dbo].[DimTime]
JOIN [521].[dbo].[GeneralLedgerBalances]
ON [521].[dbo].[DimTime].[DATE] = [521].[dbo].[GeneralLedgerBalances].[Date]
WHERE
cast([521].[dbo].[GeneralLedgerBalances].[GeneralLedger] as Integer) in(1805)
and [521].[dbo].[DimTime].[YEAR] <
case
when month(GETDATE()) = 1 then year(GETDATE()) - 1
else year(GETDATE())
end
