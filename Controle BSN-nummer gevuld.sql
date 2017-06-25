





SELECT
dbo.humres.[res_id],
dbo.humres.fullname,
dbo.humres.[socsec_nr]
FROM
dbo.humres
WHERE
dbo.humres.[socsec_nr] is null