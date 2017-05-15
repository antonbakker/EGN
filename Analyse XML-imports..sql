SELECT
CompanyCode,
BatchID,
HumresID,
EventType,
EventDescription,
EventDate,
datepart(yyyy, EventDate) AS Jaar,
datepart(mm, EventDate) AS Maand,
datepart(dd, EventDate) AS Dag,
datepart(ww, EventDate) AS Weeknr,
Topic,
Node,
DataKey
FROM
[512].dbo.XMLEvents
WHERE
ImportExport = 'I'

UNION ALL

SELECT
CompanyCode,
BatchID,
HumresID,
EventType,
EventDescription,
EventDate,
datepart(yyyy, EventDate) AS Jaar,
datepart(mm, EventDate) AS Maand,
datepart(dd, EventDate) AS Dag,
datepart(ww, EventDate) AS Weeknr,
Topic,
Node,
DataKey
FROM
[521].dbo.XMLEvents
WHERE
ImportExport = 'I'

UNION ALL

SELECT
CompanyCode,
BatchID,
HumresID,
EventType,
EventDescription,
EventDate,
datepart(yyyy, EventDate) AS Jaar,
datepart(mm, EventDate) AS Maand,
datepart(dd, EventDate) AS Dag,
datepart(ww, EventDate) AS Weeknr,
Topic,
Node,
DataKey
FROM
[522].dbo.XMLEvents
WHERE
ImportExport = 'I'

UNION ALL

SELECT
CompanyCode,
BatchID,
HumresID,
EventType,
EventDescription,
EventDate,
datepart(yyyy, EventDate) AS Jaar,
datepart(mm, EventDate) AS Maand,
datepart(dd, EventDate) AS Dag,
datepart(ww, EventDate) AS Weeknr,
Topic,
Node,
DataKey
FROM
[523].dbo.XMLEvents
WHERE
ImportExport = 'I'

UNION ALL

SELECT
CompanyCode,
BatchID,
HumresID,
EventType,
EventDescription,
EventDate,
datepart(yyyy, EventDate) AS Jaar,
datepart(mm, EventDate) AS Maand,
datepart(dd, EventDate) AS Dag,
datepart(ww, EventDate) AS Weeknr,
Topic,
Node,
DataKey
FROM
[524].dbo.XMLEvents
WHERE
ImportExport = 'I'

UNION ALL

SELECT
CompanyCode,
BatchID,
HumresID,
EventType,
EventDescription,
EventDate,
datepart(yyyy, EventDate) AS Jaar,
datepart(mm, EventDate) AS Maand,
datepart(dd, EventDate) AS Dag,
datepart(ww, EventDate) AS Weeknr,
Topic,
Node,
DataKey
FROM
[525].dbo.XMLEvents
WHERE
ImportExport = 'I'

UNION ALL

SELECT
CompanyCode,
BatchID,
HumresID,
EventType,
EventDescription,
EventDate,
datepart(yyyy, EventDate) AS Jaar,
datepart(mm, EventDate) AS Maand,
datepart(dd, EventDate) AS Dag,
datepart(ww, EventDate) AS Weeknr,
Topic,
Node,
DataKey
FROM
[527].dbo.XMLEvents
WHERE
ImportExport = 'I'

UNION ALL

SELECT
CompanyCode,
BatchID,
HumresID,
EventType,
EventDescription,
EventDate,
datepart(yyyy, EventDate) AS Jaar,
datepart(mm, EventDate) AS Maand,
datepart(dd, EventDate) AS Dag,
datepart(ww, EventDate) AS Weeknr,
Topic,
Node,
DataKey
FROM
[528].dbo.XMLEvents
WHERE
ImportExport = 'I'

UNION ALL

SELECT
CompanyCode,
BatchID,
HumresID,
EventType,
EventDescription,
EventDate,
datepart(yyyy, EventDate) AS Jaar,
datepart(mm, EventDate) AS Maand,
datepart(dd, EventDate) AS Dag,
datepart(ww, EventDate) AS Weeknr,
Topic,
Node,
DataKey
FROM
[541].dbo.XMLEvents
WHERE
ImportExport = 'I'

UNION ALL

SELECT
CompanyCode,
BatchID,
HumresID,
EventType,
EventDescription,
EventDate,
datepart(yyyy, EventDate) AS Jaar,
datepart(mm, EventDate) AS Maand,
datepart(dd, EventDate) AS Dag,
datepart(ww, EventDate) AS Weeknr,
Topic,
Node,
DataKey
FROM
[542].dbo.XMLEvents
WHERE
ImportExport = 'I'

UNION ALL

SELECT
CompanyCode,
BatchID,
HumresID,
EventType,
EventDescription,
EventDate,
datepart(yyyy, EventDate) AS Jaar,
datepart(mm, EventDate) AS Maand,
datepart(dd, EventDate) AS Dag,
datepart(ww, EventDate) AS Weeknr,
Topic,
Node,
DataKey
FROM
[543].dbo.XMLEvents
WHERE
ImportExport = 'I'

UNION ALL

SELECT
CompanyCode,
BatchID,
HumresID,
EventType,
EventDescription,
EventDate,
datepart(yyyy, EventDate) AS Jaar,
datepart(mm, EventDate) AS Maand,
datepart(dd, EventDate) AS Dag,
datepart(ww, EventDate) AS Weeknr,
Topic,
Node,
DataKey
FROM
[544].dbo.XMLEvents
WHERE
ImportExport = 'I'

UNION ALL

SELECT
CompanyCode,
BatchID,
HumresID,
EventType,
EventDescription,
EventDate,
datepart(yyyy, EventDate) AS Jaar,
datepart(mm, EventDate) AS Maand,
datepart(dd, EventDate) AS Dag,
datepart(ww, EventDate) AS Weeknr,
Topic,
Node,
DataKey
FROM
[561].dbo.XMLEvents
WHERE
ImportExport = 'I'
