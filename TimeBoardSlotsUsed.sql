SELECT r_tbslotconfig.C_OID
	,SUM(CAST(DATEDIFF(n, CAST(C_STIME AS TIME), CAST(C_ETIME AS TIME)) AS DECIMAL) / 60 * C_OFFEREDCNT) AS hoursoffered
	,isnull(SUM(change_detail_.hourstaken), 0) AS hours_taken
	,r_tbslotconfig.C_STIME
	,r_tbslotconfig.C_ETIME
	,r_entity.C_ID
	,r_entity.C_NAME
	,r_excp.C_NAME
	,r_tbslotconfig.C_DATE
FROM r_tbslotconfig
LEFT JOIN (
	SELECT r_schedchgrqst.C_TIMEBOARDSLOT
		,CAST(CAST(sum(DATEDIFF(n, r_agtscheddtlact.C_STIME, r_agtscheddtlact.C_ETIME)) AS DECIMAL) / 60 AS DECIMAL(38, 2)) AS hourstaken
	FROM r_schedchgrqst
	LEFT JOIN r_agtschedact ON r_schedchgrqst.C_AGT = r_agtschedact.C_AGT
		AND r_schedchgrqst.C_DATE = r_agtschedact.C_DATE
	LEFT JOIN r_agtscheddtlact ON r_agtscheddtlact.C_AGTSCHED = r_agtschedact.C_OID
		AND r_agtscheddtlact.C_ETIME <= r_schedchgrqst.C_ETIME
		AND r_agtscheddtlact.C_EXCP = r_schedchgrqst.C_EXCP
	WHERE r_agtscheddtlact.C_AGTSCHED IS NOT NULL
		AND C_TIMEBOARDSLOT IS NOT NULL
		AND C_ACT = 'A'
	GROUP BY r_schedchgrqst.C_TIMEBOARDSLOT
	) AS change_detail_ ON change_detail_.C_TIMEBOARDSLOT = r_tbslotconfig.C_OID
LEFT JOIN r_entity ON r_entity.C_OID = r_tbslotconfig.C_MU
LEFT JOIN r_excp ON r_excp.C_OID = r_tbslotconfig.C_EXCP
WHERE C_DATE > dateadd(dd, - 30, getdate())
GROUP BY r_tbslotconfig.C_OID
	,r_tbslotconfig.C_STIME
	,r_tbslotconfig.C_ETIME
	,r_entity.C_ID
	,r_entity.C_NAME
	,r_excp.C_NAME
	,r_tbslotconfig.C_DATE