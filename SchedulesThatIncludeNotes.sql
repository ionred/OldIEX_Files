SELECT r_agtscheddtlact.*, r_agtschedact.*, n1.C_TEXT AS ActivityNote, n2.C_TEXT AS ScheduleNote
FROM r_agtscheddtlact
LEFT JOIN r_agtschedact ON r_agtschedact.C_OID = r_agtscheddtlact.C_AGTSCHED
LEFT JOIN r_agt ON r_agt.C_OID = r_agtschedact.C_AGT
LEFT JOIN r_note n1 ON n1.C_OID = r_agtscheddtlact.C_NOTE
LEFT JOIN r_note n2 ON n2.C_OID = r_agtschedact.C_NOTE
WHERE r_agtschedact.C_DATE > '2019-04-30' AND (n1.C_TEXT IS NOT NULL OR n2.C_TEXT IS NOT NULL)
ORDER BY r_agtscheddtlact.C_STIME
