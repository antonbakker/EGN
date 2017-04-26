SELECT
TOT.datum AS Datum,
TOT.jaar AS Jaar,
TOT.maand AS Maand,
TOT.week AS Week,
TOT.project AS Project,
TOT.omschrijving AS Omschrijving,
TOT.O AS O,
TOT.K AS K,
TOT.ohwexak2 AS ohwexak2,
'' AS POC,
'' AS PercentageGereed,
TOT.ans AS ans,
TOT.voorgecalkost AS voorgecalkost,
TOT.mw AS mw,
TOT.projectleider AS projectleider,
TOT.opmerkingen AS Opmerkingen,
TOT.Omzet2017 AS Omzet2017,
TOT.Kosten2017 AS Kosten2017,
TOT.IC2017 AS IC2017,
TOT.Resultaat2017 AS Resultaat2017,
TOT.ohwexak2 + TOT.Resultaat2017 AS Resultaat

FROM

(

SELECT
q.datum,
year(q.datum) as jaar,
month(q.datum) as maand,
DATEPART(ww, q.datum) as week,
q.Project Collate Database_Default AS Project,
[021]..prproject.Description Collate Database_Default AS Omschrijving,
q.Omzet as O,
q.kosten as K,
q.ohwexak2,
q.Aanneemsom as ans,
q.voorgecalkost,
q.Meerwerk as mw,
q.fullname Collate Database_Default AS Projectleider,
		--,  q.Uitvoerder,  ***** manager is zolang uitvoerder later lid mederwerker die geen projectleider is
[021]..PRProject.Memo Collate Database_Default AS Opmerkingen,
0 AS Omzet2017,
0 AS Kosten2017,
0 AS IC2017,
0 AS Resultaat2017



FROM    (

			SELECT     PRES.project, CONVERT(decimal(10, 2), SUM(PRES.omzet)) * - 1 AS omzet, CONVERT(decimal(10, 2), SUM(PRES.kosten)) AS kosten,
                                              CONVERT(decimal(10, 2), SUM(isnull(PRES.omzet,0))) * + 1 + CONVERT(decimal(10, 2), SUM(Isnull(PRES.kosten,0))) AS ohwexak2,
                                              [021]..PRProject.NumberField1 AS aanneemsom, [021]..PRProject.NumberField2 AS voorgecalkost, [021]..PRProject.NumberField3 AS meerwerk,
                                              [021]..PRProject.Responsible, [021]..humres.fullname, [021]..PRMember.res_id, [021]..PRMember.IsProjectManager
                                              --, PRMember_1.res_id AS Expr1,            humres_1.fullname AS Uitvoerder
                                              , PRES.datum
            FROM          (
							   SELECT     gm.project, gm.datum
										, CASE WHEN omzrek = 'j' THEN (gm.bdr_hfl) END				AS omzet
										, CASE WHEN omzrek <> 'j' THEN (gm.bdr_hfl)   END			AS kosten
								FROM          [021]..gbkmut AS gm
													INNER JOIN  [021]..grtbk AS gb
													ON gm.reknr = gb.reknr

								WHERE      (gm.transtype NOT IN ('V', 'B')) AND (gm.transsubtype <> 'X') AND (gb.bal_vw = 'W') AND (gm.project IS NOT NULL)

						  ) AS PRES
		INNER JOIN [021]..PRProject
		ON PRES.project = [021]..PRProject.ProjectNr
								INNER JOIN  [021]..PRMember
								ON [021]..PRProject.ProjectNr = [021]..PRMember.ProjectNr
											INNER JOIN  [021]..humres
											ON [021]..PRMember.res_id = [021]..humres.res_id

								--INNER JOIN [021]..PRMember AS PRMember_1
								--ON [021]..PRProject.ProjectNr = PRMember_1.ProjectNr
								--			INNER JOIN  [021]..humres AS humres_1
								--			ON PRMember_1.res_id =humres_1.res_id
			--WHERE
   --                   (YEAR(PRMember_1.UntilDate) <> '2009') AND (YEAR([021]..PRMember.UntilDate) <> '2009')-- alleen leden met datum anders dan 2009 zijn uitvoerder

            GROUP BY
					PRES.project, [021]..PRProject.NumberField1, [021]..PRProject.NumberField2, [021]..PRProject.NumberField3, [021]..PRProject.Responsible, [021]..humres.fullname,
                    [021]..PRMember.res_id, [021]..PRMember.IsProjectManager, PRES.datum
                    --,PRMember_1.res_id,PRMember_1.IsProjectManager, humres_1.fullname, PRES.datum

            HAVING      ([021]..PRMember.IsProjectManager = 1)
						--AND (PRMember_1.IsProjectManager = 0)

     ) AS q
     INNER JOIN
     [021].[dbo].PRProject ON [021]..PRProject.ProjectNr = q.project
where
datum <= '2016-12-31' and
[021].[dbo].PRProject.Status='A'
and left(q.Project,4) <> '2117'
and left(q.Project, 6) <> '211606'
and left(q.Project, 6) <> '211608'
and q.Project not in ('21794400', '21794450', '21160001','21160003','21169101','21169102', '21169199')


UNION ALL


SELECT
	q.datum,
	year(q.datum) as jaar,
	month(q.datum) as maand,
	DATEPART(ww, q.datum) as week,
	q.Project Collate Database_Default AS Project,
	[521].[dbo].prproject.Description Collate Database_Default AS Omschrijving,
	0 AS O,
	0 AS K,
	0 AS ohwexak2,
	0 AS ans,
	0 AS voorgecalkost,
	0 AS mw,
	q.fullname Collate Database_Default AS Projectleider,
		--,  q.Uitvoerder,  ***** manager is zolang uitvoerder later lid mederwerker die geen projectleider is
	[521].[dbo].PRProject.Memo Collate Database_Default AS Opmerkingen,
q.Omzet AS Omzet2017,
q.kosten AS Kosten2017,
0 AS IC2017,
q.Omzet - q.kosten AS Resultaat2017


FROM
	(
		SELECT
			PRES.project,
			CONVERT(decimal(10, 2),
			SUM(PRES.omzet)) * - 1 AS omzet,
			CONVERT(decimal(10, 2), SUM(PRES.kosten)) AS kosten,
      CONVERT(decimal(10, 2), SUM(isnull(PRES.omzet,0))) * + 1 + CONVERT(decimal(10, 2), SUM(Isnull(PRES.kosten,0))) AS ohwexak2,
      [521].[dbo].PRProject.NumberField1 AS aanneemsom,
			[521].[dbo].PRProject.NumberField2 AS voorgecalkost,
			[521].[dbo].PRProject.NumberField3 AS meerwerk,
      [521].[dbo].PRProject.Responsible,
			[521].[dbo].humres.fullname,
			[521].[dbo].PRMember.res_id,
			[521].[dbo].PRMember.IsProjectManager,
      --, PRMember_1.res_id AS Expr1,            humres_1.fullname AS Uitvoerder
      PRES.datum
    FROM
			(
			SELECT
				gm.project,
				gm.datum,
				CASE
					WHEN omzrek = 'j' THEN (gm.bdr_hfl)
				END AS omzet,
				CASE
					WHEN omzrek <> 'j' THEN (gm.bdr_hfl)
				END AS kosten
			FROM
				[521].[dbo].gbkmut AS gm
				INNER JOIN  [521].[dbo].grtbk AS gb
					ON gm.reknr = gb.reknr
			WHERE
				(gm.transtype NOT IN ('V', 'B'))
				AND (gm.transsubtype <> 'X')
				AND (gb.bal_vw = 'W')
				AND (gm.project IS NOT NULL)
				) AS PRES
				INNER JOIN [521].[dbo].PRProject
					ON PRES.project = [521].[dbo].PRProject.ProjectNr
					INNER JOIN  [521].[dbo].PRMember
						ON [521].[dbo].PRProject.ProjectNr = [521].[dbo].PRMember.ProjectNr
					INNER JOIN  [521].[dbo].humres
						ON [521].[dbo].PRMember.res_id = [521].[dbo].humres.res_id

								--INNER JOIN [521].[dbo].PRMember AS PRMember_1
								--ON [521].[dbo].PRProject.ProjectNr = PRMember_1.ProjectNr
								--			INNER JOIN  [521].[dbo].humres AS humres_1
								--			ON PRMember_1.res_id =humres_1.res_id
			--WHERE
   --                   (YEAR(PRMember_1.UntilDate) <> '2009') AND (YEAR([521].[dbo].PRMember.UntilDate) <> '2009')-- alleen leden met datum anders dan 2009 zijn uitvoerder

      GROUP BY
				PRES.project,
				[521].[dbo].PRProject.NumberField1,
				[521].[dbo].PRProject.NumberField2,
				[521].[dbo].PRProject.NumberField3,
				[521].[dbo].PRProject.Responsible,
				[521].[dbo].humres.fullname,
        [521].[dbo].PRMember.res_id,
				[521].[dbo].PRMember.IsProjectManager,
				PRES.datum
                    --,PRMember_1.res_id,PRMember_1.IsProjectManager, humres_1.fullname, PRES.datum

      HAVING
				([521].[dbo].PRMember.IsProjectManager = 1)
						--AND (PRMember_1.IsProjectManager = 0)
	) AS q
  INNER JOIN [521].[dbo].PRProject
		ON [521].[dbo].PRProject.ProjectNr = q.project
	where [521].[dbo].PRProject.Status='A'
	and q.datum >= '2017-01-01'
and left(q.Project,4) <> '2117'
and left(q.Project, 6) <> '211606'
and left(q.Project, 6) <> '211608'
and q.Project not in ('21794400', '21794450', '21160001','21160003','21169101','21169102', '21169199')


UNION ALL

Select
IC.datum AS Datum,
IC.jaar AS Jaar,
IC.maand AS Maand,
IC.week AS Week,
IC.project AS Project,
IC.omschrijving AS Omschrijving,
IC.O AS O,
IC.K AS K,
IC.ohwexak2 AS ohwexak2,
IC.ans AS ans,
IC.voorgecalkost AS voorgecalkost,
IC.mw AS mw,
IC.projectleider AS projectleider,
IC.opmerkingen AS Opmerkingen,
IC.O AS Omzet2017,
IC.K AS Kosten2017,
IC.IC AS IC2017,
IC.O - IC.K - IC.IC AS Resultaat2017

FROM
(
select
PRES.datum,
year(PRES.datum) as jaar,
month(PRES.datum) as maand,
DATEPART(ww, PRES.datum) as week,
left(PRES.kstdrcode,8) as project,
PRES.oms25 as omschrijving,
0 as O,
0 as K,
PRES.kosten as IC,
0 AS ohwexak2,
0 as ans,
0 as voorgecalkost,
0 as mw,
'Divisie ' + convert(varchar(50), PRES.Division)  AS projectleider,
'' as opmerkingen

FROM
(
SELECT
gm.datum as datum,
gm.oms25,

case
 when gbtk.omzrek = 'j' then gm.bdr_hfl
end as omzet,

case
 when gbtk.omzrek <> 'j' then -1 * gm.bdr_hfl
end as kosten,

gm.Division as Division,
gm.reknr,
gm.tegreknr,
gm.project,
gm.kstdrcode


from
[512].[dbo].gbkmut AS gm
INNER JOIN  [512].[dbo].grtbk AS gbtk ON gbtk.reknr = gm.reknr

where gm.kstdrcode is not NULL
and len(gm.kstdrcode) = 8
and gm.reknr in (8997, 8998, 8999)
) AS PRES

UNION ALL

select
PRES.datum,
year(PRES.datum) as jaar,
month(PRES.datum) as maand,
DATEPART(ww, PRES.datum) as week,
left(PRES.kstdrcode,8) as project,
PRES.oms25 as omschrijving,
0 as O,
0 as K,
PRES.kosten as IC,
0 AS ohwexak2,
0 as ans,
0 as voorgecalkost,
0 as mw,
'Divisie ' + convert(varchar(50), PRES.Division)  AS projectleider,
'' as opmerkingen

FROM
(
SELECT
gm.datum as datum,
gm.oms25,

case
 when gbtk.omzrek = 'j' then gm.bdr_hfl
end as omzet,

case
 when gbtk.omzrek <> 'j' then -1 * gm.bdr_hfl
end as kosten,

gm.Division as Division,
gm.reknr,
gm.tegreknr,
gm.project,
gm.kstdrcode


from
[513].[dbo].gbkmut AS gm
INNER JOIN  [513].[dbo].grtbk AS gbtk ON gbtk.reknr = gm.reknr

where gm.kstdrcode is not NULL
and len(gm.kstdrcode) = 8
and gm.reknr in (8997, 8998, 8999)
) AS PRES

UNION ALL

select
PRES.datum,
year(PRES.datum) as jaar,
month(PRES.datum) as maand,
DATEPART(ww, PRES.datum) as week,
left(PRES.kstdrcode,8) as project,
PRES.oms25 as omschrijving,
0 as O,
0 as K,
PRES.kosten as IC,
0 AS ohwexak2,
0 as ans,
0 as voorgecalkost,
0 as mw,
'Divisie ' + convert(varchar(50), PRES.Division)  AS projectleider,
'' as opmerkingen

FROM
(
SELECT
gm.datum as datum,
gm.oms25,

case
 when gbtk.omzrek = 'j' then gm.bdr_hfl
end as omzet,

case
 when gbtk.omzrek <> 'j' then -1 * gm.bdr_hfl
end as kosten,

gm.Division as Division,
gm.reknr,
gm.tegreknr,
gm.project,
gm.kstdrcode


from
[514].[dbo].gbkmut AS gm
INNER JOIN  [514].[dbo].grtbk AS gbtk ON gbtk.reknr = gm.reknr

where gm.kstdrcode is not NULL
and len(gm.kstdrcode) = 8
and gm.reknr in (8997, 8998, 8999)
) AS PRES

UNION ALL

select
PRES.datum,
year(PRES.datum) as jaar,
month(PRES.datum) as maand,
DATEPART(ww, PRES.datum) as week,
left(PRES.kstdrcode,8) as project,
PRES.oms25 as omschrijving,
0 as O,
0 as K,
PRES.kosten as IC,
0 AS ohwexak2,
0 as ans,
0 as voorgecalkost,
0 as mw,
'Divisie ' + convert(varchar(50), PRES.Division)  AS projectleider,
'' as opmerkingen

FROM
(
SELECT
gm.datum as datum,
gm.oms25,

case
 when gbtk.omzrek = 'j' then gm.bdr_hfl
end as omzet,

case
 when gbtk.omzrek <> 'j' then -1 * gm.bdr_hfl
end as kosten,

gm.Division as Division,
gm.reknr,
gm.tegreknr,
gm.project,
gm.kstdrcode


from
[521].[dbo].gbkmut AS gm
INNER JOIN  [521].[dbo].grtbk AS gbtk ON gbtk.reknr = gm.reknr

where gm.kstdrcode is not NULL
and len(gm.kstdrcode) = 8
and gm.reknr in (8997, 8998, 8999)
) AS PRES

UNION ALL

select
PRES.datum,
year(PRES.datum) as jaar,
month(PRES.datum) as maand,
DATEPART(ww, PRES.datum) as week,
left(PRES.kstdrcode,8) as project,
PRES.oms25 as omschrijving,
0 as O,
0 as K,
PRES.kosten as IC,
0 AS ohwexak2,
0 as ans,
0 as voorgecalkost,
0 as mw,
'Divisie ' + convert(varchar(50), PRES.Division)  AS projectleider,
'' as opmerkingen

FROM
(
SELECT
gm.datum as datum,
gm.oms25,

case
 when gbtk.omzrek = 'j' then gm.bdr_hfl
end as omzet,

case
 when gbtk.omzrek <> 'j' then -1 * gm.bdr_hfl
end as kosten,

gm.Division as Division,
gm.reknr,
gm.tegreknr,
gm.project,
gm.kstdrcode


from
[522].[dbo].gbkmut AS gm
INNER JOIN  [522].[dbo].grtbk AS gbtk ON gbtk.reknr = gm.reknr

where gm.kstdrcode is not NULL
and len(gm.kstdrcode) = 8
and gm.reknr in (8997, 8998, 8999)
) AS PRES

UNION ALL

select
PRES.datum,
year(PRES.datum) as jaar,
month(PRES.datum) as maand,
DATEPART(ww, PRES.datum) as week,
left(PRES.kstdrcode,8) as project,
PRES.oms25 as omschrijving,
0 as O,
0 as K,
PRES.kosten as IC,
0 AS ohwexak2,
0 as ans,
0 as voorgecalkost,
0 as mw,
'Divisie ' + convert(varchar(50), PRES.Division)  AS projectleider,
'' as opmerkingen

FROM
(
SELECT
gm.datum as datum,
gm.oms25,

case
 when gbtk.omzrek = 'j' then gm.bdr_hfl
end as omzet,

case
 when gbtk.omzrek <> 'j' then -1 * gm.bdr_hfl
end as kosten,

gm.Division as Division,
gm.reknr,
gm.tegreknr,
gm.project,
gm.kstdrcode


from
[523].[dbo].gbkmut AS gm
INNER JOIN  [523].[dbo].grtbk AS gbtk ON gbtk.reknr = gm.reknr

where gm.kstdrcode is not NULL
and len(gm.kstdrcode) = 8
and gm.reknr in (8997, 8998, 8999)
) AS PRES

UNION ALL

select
PRES.datum,
year(PRES.datum) as jaar,
month(PRES.datum) as maand,
DATEPART(ww, PRES.datum) as week,
left(PRES.kstdrcode,8) as project,
PRES.oms25 as omschrijving,
0 as O,
0 as K,
PRES.kosten as IC,
0 AS ohwexak2,
0 as ans,
0 as voorgecalkost,
0 as mw,
'Divisie ' + convert(varchar(50), PRES.Division)  AS projectleider,
'' as opmerkingen

FROM
(
SELECT
gm.datum as datum,
gm.oms25,

case
 when gbtk.omzrek = 'j' then gm.bdr_hfl
end as omzet,

case
 when gbtk.omzrek <> 'j' then -1 * gm.bdr_hfl
end as kosten,

gm.Division as Division,
gm.reknr,
gm.tegreknr,
gm.project,
gm.kstdrcode


from
[524].[dbo].gbkmut AS gm
INNER JOIN  [524].[dbo].grtbk AS gbtk ON gbtk.reknr = gm.reknr

where gm.kstdrcode is not NULL
and len(gm.kstdrcode) = 8
and gm.reknr in (8997, 8998, 8999)
) AS PRES

UNION ALL

select
PRES.datum,
year(PRES.datum) as jaar,
month(PRES.datum) as maand,
DATEPART(ww, PRES.datum) as week,
left(PRES.kstdrcode,8) as project,
PRES.oms25 as omschrijving,
0 as O,
0 as K,
PRES.kosten as IC,
0 AS ohwexak2,
0 as ans,
0 as voorgecalkost,
0 as mw,
'Divisie ' + convert(varchar(50), PRES.Division)  AS projectleider,
'' as opmerkingen

FROM
(
SELECT
gm.datum as datum,
gm.oms25,

case
 when gbtk.omzrek = 'j' then gm.bdr_hfl
end as omzet,

case
 when gbtk.omzrek <> 'j' then -1 * gm.bdr_hfl
end as kosten,

gm.Division as Division,
gm.reknr,
gm.tegreknr,
gm.project,
gm.kstdrcode


from
[525].[dbo].gbkmut AS gm
INNER JOIN  [525].[dbo].grtbk AS gbtk ON gbtk.reknr = gm.reknr

where gm.kstdrcode is not NULL
and len(gm.kstdrcode) = 8
and gm.reknr in (8997, 8998, 8999)
) AS PRES

UNION ALL

select
PRES.datum,
year(PRES.datum) as jaar,
month(PRES.datum) as maand,
DATEPART(ww, PRES.datum) as week,
left(PRES.kstdrcode,8) as project,
PRES.oms25 as omschrijving,
0 as O,
0 as K,
PRES.kosten as IC,
0 AS ohwexak2,
0 as ans,
0 as voorgecalkost,
0 as mw,
'Divisie ' + convert(varchar(50), PRES.Division)  AS projectleider,
'' as opmerkingen

FROM
(
SELECT
gm.datum as datum,
gm.oms25,

case
 when gbtk.omzrek = 'j' then gm.bdr_hfl
end as omzet,

case
 when gbtk.omzrek <> 'j' then -1 * gm.bdr_hfl
end as kosten,

gm.Division as Division,
gm.reknr,
gm.tegreknr,
gm.project,
gm.kstdrcode


from
[527].[dbo].gbkmut AS gm
INNER JOIN  [527].[dbo].grtbk AS gbtk ON gbtk.reknr = gm.reknr

where gm.kstdrcode is not NULL
and len(gm.kstdrcode) = 8
and gm.reknr in (8997, 8998, 8999)
) AS PRES

UNION ALL

select
PRES.datum,
year(PRES.datum) as jaar,
month(PRES.datum) as maand,
DATEPART(ww, PRES.datum) as week,
left(PRES.kstdrcode,8) as project,
PRES.oms25 as omschrijving,
0 as O,
0 as K,
PRES.kosten as IC,
0 AS ohwexak2,
0 as ans,
0 as voorgecalkost,
0 as mw,
'Divisie ' + convert(varchar(50), PRES.Division)  AS projectleider,
'' as opmerkingen

FROM
(
SELECT
gm.datum as datum,
gm.oms25,

case
 when gbtk.omzrek = 'j' then gm.bdr_hfl
end as omzet,

case
 when gbtk.omzrek <> 'j' then -1 * gm.bdr_hfl
end as kosten,

gm.Division as Division,
gm.reknr,
gm.tegreknr,
gm.project,
gm.kstdrcode


from
[528].[dbo].gbkmut AS gm
INNER JOIN  [528].[dbo].grtbk AS gbtk ON gbtk.reknr = gm.reknr

where gm.kstdrcode is not NULL
and len(gm.kstdrcode) = 8
and gm.reknr in (8997, 8998, 8999)
) AS PRES

UNION ALL

select
PRES.datum,
year(PRES.datum) as jaar,
month(PRES.datum) as maand,
DATEPART(ww, PRES.datum) as week,
left(PRES.kstdrcode,8) as project,
PRES.oms25 as omschrijving,
0 as O,
0 as K,
PRES.kosten as IC,
0 AS ohwexak2,
0 as ans,
0 as voorgecalkost,
0 as mw,
'Divisie ' + convert(varchar(50), PRES.Division)  AS projectleider,
'' as opmerkingen

FROM
(
SELECT
gm.datum as datum,
gm.oms25,

case
 when gbtk.omzrek = 'j' then gm.bdr_hfl
end as omzet,

case
 when gbtk.omzrek <> 'j' then -1 * gm.bdr_hfl
end as kosten,

gm.Division as Division,
gm.reknr,
gm.tegreknr,
gm.project,
gm.kstdrcode


from
[541].[dbo].gbkmut AS gm
INNER JOIN  [541].[dbo].grtbk AS gbtk ON gbtk.reknr = gm.reknr

where gm.kstdrcode is not NULL
and len(gm.kstdrcode) = 8
and gm.reknr in (8997, 8998, 8999)
) AS PRES

UNION ALL

select
PRES.datum,
year(PRES.datum) as jaar,
month(PRES.datum) as maand,
DATEPART(ww, PRES.datum) as week,
left(PRES.kstdrcode,8) as project,
PRES.oms25 as omschrijving,
0 as O,
0 as K,
PRES.kosten as IC,
0 AS ohwexak2,
0 as ans,
0 as voorgecalkost,
0 as mw,
'Divisie ' + convert(varchar(50), PRES.Division)  AS projectleider,
'' as opmerkingen

FROM
(
SELECT
gm.datum as datum,
gm.oms25,

case
 when gbtk.omzrek = 'j' then gm.bdr_hfl
end as omzet,

case
 when gbtk.omzrek <> 'j' then -1 * gm.bdr_hfl
end as kosten,

gm.Division as Division,
gm.reknr,
gm.tegreknr,
gm.project,
gm.kstdrcode


from
[542].[dbo].gbkmut AS gm
INNER JOIN  [542].[dbo].grtbk AS gbtk ON gbtk.reknr = gm.reknr

where gm.kstdrcode is not NULL
and len(gm.kstdrcode) = 8
and gm.reknr in (8997, 8998, 8999)
) AS PRES

UNION ALL

select
PRES.datum,
year(PRES.datum) as jaar,
month(PRES.datum) as maand,
DATEPART(ww, PRES.datum) as week,
left(PRES.kstdrcode,8) as project,
PRES.oms25 as omschrijving,
0 as O,
0 as K,
PRES.kosten as IC,
0 AS ohwexak2,
0 as ans,
0 as voorgecalkost,
0 as mw,
'Divisie ' + convert(varchar(50), PRES.Division)  AS projectleider,
'' as opmerkingen

FROM
(
SELECT
gm.datum as datum,
gm.oms25,

case
 when gbtk.omzrek = 'j' then gm.bdr_hfl
end as omzet,

case
 when gbtk.omzrek <> 'j' then -1 * gm.bdr_hfl
end as kosten,

gm.Division as Division,
gm.reknr,
gm.tegreknr,
gm.project,
gm.kstdrcode


from
[543].[dbo].gbkmut AS gm
INNER JOIN  [543].[dbo].grtbk AS gbtk ON gbtk.reknr = gm.reknr

where gm.kstdrcode is not NULL
and len(gm.kstdrcode) = 8
and gm.reknr in (8997, 8998, 8999)
) AS PRES

UNION ALL

select
PRES.datum,
year(PRES.datum) as jaar,
month(PRES.datum) as maand,
DATEPART(ww, PRES.datum) as week,
left(PRES.kstdrcode,8) as project,
PRES.oms25 as omschrijving,
0 as O,
0 as K,
PRES.kosten as IC,
0 AS ohwexak2,
0 as ans,
0 as voorgecalkost,
0 as mw,
'Divisie ' + convert(varchar(50), PRES.Division)  AS projectleider,
'' as opmerkingen

FROM
(
SELECT
gm.datum as datum,
gm.oms25,

case
 when gbtk.omzrek = 'j' then gm.bdr_hfl
end as omzet,

case
 when gbtk.omzrek <> 'j' then -1 * gm.bdr_hfl
end as kosten,

gm.Division as Division,
gm.reknr,
gm.tegreknr,
gm.project,
gm.kstdrcode


from
[544].[dbo].gbkmut AS gm
INNER JOIN  [544].[dbo].grtbk AS gbtk ON gbtk.reknr = gm.reknr

where gm.kstdrcode is not NULL
and len(gm.kstdrcode) = 8
and gm.reknr in (8997, 8998, 8999)
) AS PRES

UNION ALL

select
PRES.datum,
year(PRES.datum) as jaar,
month(PRES.datum) as maand,
DATEPART(ww, PRES.datum) as week,
left(PRES.kstdrcode,8) as project,
PRES.oms25 as omschrijving,
0 as O,
0 as K,
PRES.kosten as IC,
0 AS ohwexak2,
0 as ans,
0 as voorgecalkost,
0 as mw,
'Divisie ' + convert(varchar(50), PRES.Division)  AS projectleider,
'' as opmerkingen

FROM
(
SELECT
gm.datum as datum,
gm.oms25,

case
 when gbtk.omzrek = 'j' then gm.bdr_hfl
end as omzet,

case
 when gbtk.omzrek <> 'j' then -1 * gm.bdr_hfl
end as kosten,

gm.Division as Division,
gm.reknr,
gm.tegreknr,
gm.project,
gm.kstdrcode


from
[547].[dbo].gbkmut AS gm
INNER JOIN  [547].[dbo].grtbk AS gbtk ON gbtk.reknr = gm.reknr

where gm.kstdrcode is not NULL
and len(gm.kstdrcode) = 8
and gm.reknr in (8997, 8998, 8999)
) AS PRES

UNION ALL

select
PRES.datum,
year(PRES.datum) as jaar,
month(PRES.datum) as maand,
DATEPART(ww, PRES.datum) as week,
left(PRES.kstdrcode,8) as project,
PRES.oms25 as omschrijving,
0 as O,
0 as K,
PRES.kosten as IC,
0 AS ohwexak2,
0 as ans,
0 as voorgecalkost,
0 as mw,
'Divisie ' + convert(varchar(50), PRES.Division)  AS projectleider,
'' as opmerkingen

FROM
(
SELECT
gm.datum as datum,
gm.oms25,

case
 when gbtk.omzrek = 'j' then gm.bdr_hfl
end as omzet,

case
 when gbtk.omzrek <> 'j' then -1 * gm.bdr_hfl
end as kosten,

gm.Division as Division,
gm.reknr,
gm.tegreknr,
gm.project,
gm.kstdrcode


from
[561].[dbo].gbkmut AS gm
INNER JOIN  [561].[dbo].grtbk AS gbtk ON gbtk.reknr = gm.reknr

where gm.kstdrcode is not NULL
and len(gm.kstdrcode) = 8
and gm.reknr in (8997, 8998, 8999)
) AS PRES

UNION ALL

select
PRES.datum,
year(PRES.datum) as jaar,
month(PRES.datum) as maand,
DATEPART(ww, PRES.datum) as week,
left(PRES.kstdrcode,8) as project,
PRES.oms25 as omschrijving,
0 as O,
0 as K,
PRES.kosten as IC,
0 AS ohwexak2,
0 as ans,
0 as voorgecalkost,
0 as mw,
'Divisie ' + convert(varchar(50), PRES.Division)  AS projectleider,
'' as opmerkingen

FROM
(
SELECT
gm.datum as datum,
gm.oms25,

case
 when gbtk.omzrek = 'j' then gm.bdr_hfl
end as omzet,

case
 when gbtk.omzrek <> 'j' then -1 * gm.bdr_hfl
end as kosten,

gm.Division as Division,
gm.reknr,
gm.tegreknr,
gm.project,
gm.kstdrcode


from
[571].[dbo].gbkmut AS gm
INNER JOIN  [571].[dbo].grtbk AS gbtk ON gbtk.reknr = gm.reknr

where gm.kstdrcode is not NULL
and len(gm.kstdrcode) = 8
and gm.reknr in (8997, 8998, 8999)
) AS PRES

UNION ALL

select
PRES.datum,
year(PRES.datum) as jaar,
month(PRES.datum) as maand,
DATEPART(ww, PRES.datum) as week,
left(PRES.kstdrcode,8) as project,
PRES.oms25 as omschrijving,
0 as O,
0 as K,
PRES.kosten as IC,
0 AS ohwexak2,
0 as ans,
0 as voorgecalkost,
0 as mw,
'Divisie ' + convert(varchar(50), PRES.Division)  AS projectleider,
'' as opmerkingen

FROM
(
SELECT
gm.datum as datum,
gm.oms25,

case
 when gbtk.omzrek = 'j' then gm.bdr_hfl
end as omzet,

case
 when gbtk.omzrek <> 'j' then -1 * gm.bdr_hfl
end as kosten,

gm.Division as Division,
gm.reknr,
gm.tegreknr,
gm.project,
gm.kstdrcode


from
[581].[dbo].gbkmut AS gm
INNER JOIN  [581].[dbo].grtbk AS gbtk ON gbtk.reknr = gm.reknr

where gm.kstdrcode is not NULL
and len(gm.kstdrcode) = 8
and gm.reknr in (8997, 8998, 8999)
) AS PRES

UNION ALL

select
PRES.datum,
year(PRES.datum) as jaar,
month(PRES.datum) as maand,
DATEPART(ww, PRES.datum) as week,
left(PRES.kstdrcode,8) as project,
PRES.oms25 as omschrijving,
0 as O,
0 as K,
PRES.kosten as IC,
0 AS ohwexak2,
0 as ans,
0 as voorgecalkost,
0 as mw,
'Divisie ' + convert(varchar(50), PRES.Division)  AS projectleider,
'' as opmerkingen

FROM
(
SELECT
gm.datum as datum,
gm.oms25,

case
 when gbtk.omzrek = 'j' then gm.bdr_hfl
end as omzet,

case
 when gbtk.omzrek <> 'j' then -1 * gm.bdr_hfl
end as kosten,

gm.Division as Division,
gm.reknr,
gm.tegreknr,
gm.project,
gm.kstdrcode


from
[582].[dbo].gbkmut AS gm
INNER JOIN  [582].[dbo].grtbk AS gbtk ON gbtk.reknr = gm.reknr

where gm.kstdrcode is not NULL
and len(gm.kstdrcode) = 8
and gm.reknr in (8997, 8998, 8999)
) AS PRES

UNION ALL

select
PRES.datum,
year(PRES.datum) as jaar,
month(PRES.datum) as maand,
DATEPART(ww, PRES.datum) as week,
left(PRES.kstdrcode,8) as project,
PRES.oms25 as omschrijving,
0 as O,
0 as K,
PRES.kosten as IC,
0 AS ohwexak2,
0 as ans,
0 as voorgecalkost,
0 as mw,
'Divisie ' + convert(varchar(50), PRES.Division)  AS projectleider,
'' as opmerkingen

FROM
(
SELECT
gm.datum as datum,
gm.oms25,

case
 when gbtk.omzrek = 'j' then gm.bdr_hfl
end as omzet,

case
 when gbtk.omzrek <> 'j' then -1 * gm.bdr_hfl
end as kosten,

gm.Division as Division,
gm.reknr,
gm.tegreknr,
gm.project,
gm.kstdrcode


from
[583].[dbo].gbkmut AS gm
INNER JOIN  [583].[dbo].grtbk AS gbtk ON gbtk.reknr = gm.reknr

where gm.kstdrcode is not NULL
and len(gm.kstdrcode) = 8
and gm.reknr in (8997, 8998, 8999)
) AS PRES

UNION ALL

select
PRES.datum,
year(PRES.datum) as jaar,
month(PRES.datum) as maand,
DATEPART(ww, PRES.datum) as week,
left(PRES.kstdrcode,8) as project,
PRES.oms25 as omschrijving,
0 as O,
0 as K,
PRES.kosten as IC,
0 AS ohwexak2,
0 as ans,
0 as voorgecalkost,
0 as mw,
'Divisie ' + convert(varchar(50), PRES.Division)  AS projectleider,
'' as opmerkingen

FROM
(
SELECT
gm.datum as datum,
gm.oms25,

case
 when gbtk.omzrek = 'j' then gm.bdr_hfl
end as omzet,

case
 when gbtk.omzrek <> 'j' then -1 * gm.bdr_hfl
end as kosten,

gm.Division as Division,
gm.reknr,
gm.tegreknr,
gm.project,
gm.kstdrcode


from
[591].[dbo].gbkmut AS gm
INNER JOIN  [591].[dbo].grtbk AS gbtk ON gbtk.reknr = gm.reknr

where gm.kstdrcode is not NULL
and len(gm.kstdrcode) = 8
and gm.reknr in (8997, 8998, 8999)
) AS PRES

UNION ALL

select
PRES.datum,
year(PRES.datum) as jaar,
month(PRES.datum) as maand,
DATEPART(ww, PRES.datum) as week,
left(PRES.kstdrcode,8) as project,
PRES.oms25 as omschrijving,
0 as O,
0 as K,
PRES.kosten as IC,
0 AS ohwexak2,
0 as ans,
0 as voorgecalkost,
0 as mw,
'Divisie ' + convert(varchar(50), PRES.Division)  AS projectleider,
'' as opmerkingen

FROM
(
SELECT
gm.datum as datum,
gm.oms25,

case
 when gbtk.omzrek = 'j' then gm.bdr_hfl
end as omzet,

case
 when gbtk.omzrek <> 'j' then -1 * gm.bdr_hfl
end as kosten,

gm.Division as Division,
gm.reknr,
gm.tegreknr,
gm.project,
gm.kstdrcode


from
[593].[dbo].gbkmut AS gm
INNER JOIN  [593].[dbo].grtbk AS gbtk ON gbtk.reknr = gm.reknr

where gm.kstdrcode is not NULL
and len(gm.kstdrcode) = 8
and gm.reknr in (8997, 8998, 8999)
) AS PRES

UNION ALL

select
PRES.datum,
year(PRES.datum) as jaar,
month(PRES.datum) as maand,
DATEPART(ww, PRES.datum) as week,
left(PRES.kstdrcode,8) as project,
PRES.oms25 as omschrijving,
0 as O,
0 as K,
PRES.kosten as IC,
0 AS ohwexak2,
0 as ans,
0 as voorgecalkost,
0 as mw,
'Divisie ' + convert(varchar(50), PRES.Division)  AS projectleider,
'' as opmerkingen

FROM
(
SELECT
gm.datum as datum,
gm.oms25,

case
 when gbtk.omzrek = 'j' then gm.bdr_hfl
end as omzet,

case
 when gbtk.omzrek <> 'j' then -1 * gm.bdr_hfl
end as kosten,

gm.Division as Division,
gm.reknr,
gm.tegreknr,
gm.project,
gm.kstdrcode


from
[594].[dbo].gbkmut AS gm
INNER JOIN  [594].[dbo].grtbk AS gbtk ON gbtk.reknr = gm.reknr

where gm.kstdrcode is not NULL
and len(gm.kstdrcode) = 8
and gm.reknr in (8997, 8998, 8999)
) AS PRES
) AS IC

where left(IC.project,2) = '21'
and left(IC.project, 4) <> '2117'


) AS TOT
