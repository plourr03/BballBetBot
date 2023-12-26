with base as (
SELECT 
PSA.GAME_ID
,PSA.PLAYER_ID
,PSA.POSITION
,coalesce(avg(pgl.PTS) over (partition by PSA.PLAYER_ID,psa.yearSeason  order by  psa.GAME_DATE  ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING),avg(pgl.PTS) over (partition by PSA.PLAYER_ID order by  psa.GAME_DATE  ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)) as avg_pts
,pgl.PTS
,PSA.Player_Right_Side_Shot_PCT
,TSA.Team_Allowed_Right_Side_Shot_PCT
,CAST(CASE WHEN PSA.Player_Right_Side_Shot_PCT < TSA.Team_Allowed_Right_Side_Shot_PCT THEN 1 ELSE 0 END AS FLOAT) AS Right_Side_Pct_Edge	
,CAST(CASE WHEN PSA.Player_Left_Side_Shot_PCT < TSA.Team_Allowed_Left_Side_Shot_PCT THEN 1 ELSE 0 END AS FLOAT) AS Left_Side_Pct_Edge
,CAST(CASE WHEN PSA.Player_Left_Center_Shot_PCT < TSA.Team_Allowed_Left_Center_Shot_PCT THEN 1 ELSE 0 END AS FLOAT) AS Left_Center_Pct_Edge
,CAST(CASE WHEN PSA.Player_Center_Shot_PCT < TSA.Team_Allowed_Center_Shot_PCT THEN 1 ELSE 0 END AS FLOAT) AS Center_Shot_Pct_Edge
,CAST(CASE WHEN PSA.Player_Back_Court_Shot_PCT < TSA.Team_Allowed_Back_Court_Shot_PCT THEN 1 ELSE 0 END AS FLOAT) AS Back_Court_Pct_Edge
,CAST(CASE WHEN PSA.Player_Right_Center_Shot_PCT < TSA.Team_Allowed_Right_Center_Shot_PCT THEN 1 ELSE 0 END AS FLOAT) AS Right_Center_Pct_Edge
 
,CAST(CASE WHEN PSA.Player_Right_Side_Shot_COUNT < TSA.Team_Allowed_Right_Side_Shot_COUNT THEN 1 ELSE 0 END AS FLOAT) AS Right_Side_Count_Edge
,CAST(CASE WHEN PSA.Player_Left_Side_Shot_COUNT < TSA.Team_Allowed_Left_Side_Shot_COUNT THEN 1 ELSE 0 END AS FLOAT) AS Left_Side_Count_Edge
,CAST(CASE WHEN PSA.Player_Left_Center_Shot_COUNT < TSA.Team_Allowed_Left_Center_Shot_COUNT THEN 1 ELSE 0 END  AS FLOAT) AS Left_Center_Count_Edge
,CAST(CASE WHEN PSA.Player_Center_Shot_COUNT < TSA.Team_Allowed_Center_Shot_COUNT THEN 1 ELSE 0 END AS FLOAT) AS Ceneter_Shot_Count_Edge					
,CAST(CASE WHEN PSA.Player_Back_Court_Shot_COUNT < TSA.Team_Allowed_Back_Court_Shot_COUNT THEN 1 ELSE 0 END  AS FLOAT) AS Back_Court_Shot_Count_Edge
,CAST(CASE WHEN PSA.Player_Right_Center_Shot_COUNT < TSA.Team_Allowed_Right_Center_Shot_COUNT THEN 1 ELSE 0 END AS FLOAT) AS Right_Center_Shot_Count_Edge
,psa.yearSeason
FROM [nba_game_data].[dbo].[playerShootingByShotZoneArea] psa

left outer join [nba_game_data].[dbo].[teamShootingAllowedByShotZoneArea] tsa
on 
psa.GAME_ID = tsa.GAME_ID
and psa.POSITION = tsa.POSITION
and psa.oppAbrv = tsa.TEAM_ABBREVIATION

left outer join [nba_game_data].[dbo].[PlayerGameLogs] pgl
on psa.GAME_ID = pgl.GAME_ID
and psa.PLAYER_ID = pgl.PLAYER_ID

WHERE psa.player_id = 1630169
and psa.yearSeason =2024

)
select 

case when PTS > 27.5 then 1 else 0 end as pts_thresh,
Right_Side_Pct_Edge,
Left_Side_Pct_Edge,
Left_Center_Pct_Edge,
Center_Shot_Pct_Edge,
Back_Court_Pct_Edge,
Right_Center_Pct_Edge,
Right_Side_Count_Edge,
Left_Side_Count_Edge,
Left_Center_Count_Edge,
Ceneter_Shot_Count_Edge,
Back_Court_Shot_Count_Edge,
Right_Center_Shot_Count_Edge,	
cast((Right_Side_Pct_Edge+
Left_Side_Pct_Edge+
Left_Center_Pct_Edge+
Center_Shot_Pct_Edge+
Back_Court_Pct_Edge+
Right_Center_Pct_Edge+
Right_Side_Count_Edge+
Left_Side_Count_Edge+
Left_Center_Count_Edge+
Ceneter_Shot_Count_Edge+
Back_Court_Shot_Count_Edge+
Right_Center_Shot_Count_Edge)/12 as float)
from base 
where avg_pts is not null