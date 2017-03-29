SELECT
AMUTAK.BKSTNR,
AMUTAK.DOCDATE AS DOCDATE,
AMUTAK.DATUM AS DATUM,
AMUTAK.SYSCREATED AS SYSCREATED,
ISNULL(dc.crdcode, '') AS DEBCRDNR,
ISNULL(dc.cmp_name, '') AS cmp_name,
AMUTAK.VOLGNR5 AS VOLGNR5,
AMUTAK.FAKTUURNR AS FAKTUURNR,
AMUTAK.DOCNUMBER AS DOCNUMBER,
(CASE
  WHEN amutak.storno <> 0 AND amutak.bedrag > 0
    THEN -amutak.bedrag
  WHEN amutak.storno = 0 AND amutak.bedrag < 0
    THEN -amutak.bedrag
  WHEN amutak.bedrag = 0
    THEN
      (CASE
        WHEN eindsaldo - beginsaldo > 0
          THEN beginsaldo - eindsaldo
        ELSE 0
      END )
        ELSE 0
      END) AS DEBIT,
      (CASE
        WHEN amutak.storno <> 0 AND amutak.bedrag < 0
          THEN amutak.bedrag
        WHEN amutak.storno = 0 AND amutak.bedrag > 0
          THEN amutak.bedrag
        WHEN amutak.bedrag = 0
          THEN (CASE WHEN eindsaldo - beginsaldo < 0 THEN eindsaldo - beginsaldo ELSE 0 END)ELSE 0 END) AS CREDIT, AMUTAK.BEDRAG AS BEDRAG, AMUTAK.VALCODE AS VALCODE, AMUTAK.VAL_BDR AS VAL_BDR, AMUTAK.DOCATTACHMENTID AS DOCATTACHMENTID, AMUTAK.DOCUMENTID AS DOCUMENTID, AMUTAK.OMS25 AS OMS25, H.Fullname AS Fullname, AMUTAK.BEGINSALDO AS BEGINSALDO, AMUTAK.EINDSALDO AS EINDSALDO, AMUTAK.KSTPLCODE, AMUTAK.KSTDRCODE, AMUTAK.PROJECT, (CASE WHEN AMUTAK.STATUS = 'O' THEN 1 ELSE 0 END) AS Status, AMUTAK.OORSPRONG, AMUTAK.BANKACC, (CASE gbkmut.transtype
      WHEN 'B' THEN 'Budget'
      WHEN 'C' THEN 'Correctie'
      WHEN 'E' THEN 'Elimination'
      WHEN 'F' THEN 'Fiscaal'
      WHEN 'I' THEN 'Dochteronderneming'
      WHEN 'N' THEN 'Normaal'
      WHEN 'O' THEN 'Obligation'
      WHEN 'P' THEN 'Beginsaldo'
      WHEN 'V' THEN 'Vervallen boekingen'
      WHEN 'X' THEN 'Non ledger' END ) AS Transtype, AMUTAK.SYSGUID AS SYSGUID, AMUTAK.ID AS rec FROM AMUTAK  LEFT OUTER JOIN cicmpy dc ON AMUTAK.crdnr = dc.crdnr AND AMUTAK.crdnr IS NOT NULL AND dc.crdnr IS NOT NULL  LEFT OUTER JOIN humres h ON h.res_id = AMUTAK.SYSCREATOR  LEFT OUTER JOIN (SELECT AMUTAK.ID, gbkmut.transtype FROM AMUTAK WITH (NOLOCK)
 INNER JOIN (SELECT entryguid, (CASE MAX(CASE transtype WHEN 'P' THEN 1 ELSE 0 END) WHEN 1 THEN 'P' ELSE Min(transtype) END) As Transtype FROM gbkmut WITH (NOLOCK) WHERE transtype <> 'B' Group by entryguid ) gbkmut ON gbkmut.entryguid = AMUTAK.sysguid WHERE  AMUTAK.STATUS IN ('P','E') AND  AMUTAK.DAGBKNR IN (' 50') AND AMUTAK.entrytype NOT IN ('R')
) gbkmut ON AMUTAK.ID = gbkmut.ID
 WHERE AMUTAK.STATUS IN ('P','E') AND  AMUTAK.DAGBKNR IN (' 50') AND AMUTAK.entrytype NOT IN ('R') ORDER BY AMUTAK.BKSTNR DESC
