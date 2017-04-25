set transaction isolation level read uncommitted
SELECT DISTINCT  Qurencontrole.Urenid,Referentie, Aanmaakdatum, ProjectNr
FROM
  (
    SELECT
      freefield5
    FROM
      [521].dbo.gbkmut
    where
      freefield5 is not null
      and dagbknr=' 98'

    UNION ALL

    SELECT
      freefield5
    FROM
      [522].dbo.gbkmut
    where
      freefield5 is not null
      and dagbknr=' 98'
                       UNION ALL
                       SELECT     freefield5
                       FROM         [523].dbo.gbkmut
                       where freefield5 is not null and dagbknr=' 98'
                       UNION ALL
                       SELECT     freefield5
                       FROM         [524].dbo.gbkmut
                       where freefield5 is not null and dagbknr=' 98'
                       UNION ALL
                       SELECT     freefield5
                       FROM         [525].dbo.gbkmut
                       where freefield5 is not null and dagbknr=' 98'
                       UNION ALL
                       SELECT     freefield5
                       FROM         [527].dbo.gbkmut
                       where freefield5 is not null and dagbknr=' 98'
                       UNION ALL
                       SELECT     freefield5
                       FROM         [528].dbo.gbkmut
                       where freefield5 is not null and dagbknr=' 98'
                       UNION ALL
                       SELECT     freefield5
                       FROM         [541].dbo.gbkmut
                       where freefield5 is not null and dagbknr=' 98'
                       UNION ALL
                       SELECT     freefield5
                       FROM         [561].dbo.gbkmut
                       where freefield5 is not null and dagbknr=' 98'

                       UNION ALL
                       SELECT     freefield5
                       FROM         [547].dbo.gbkmut
                       where freefield5 is not null and dagbknr=' 98'
                        UNION ALL
                       SELECT     freefield5
                       FROM         [512].dbo.gbkmut
                       where freefield5 is not null and dagbknr=' 98'

  ) AS alleurenids

  RIGHT OUTER JOIN Qurencontrole ON alleurenids.freefield5 = Qurencontrole.Urenid
  WHERE
    (alleurenids.freefield5 IS NULL)
    and Referentie is not null
    and  left (Projectnr,2) <> '43'

  order by 4
