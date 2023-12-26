/****** Script for SelectTopNRows command from SSMS  ******/
WITH base1 as(
  SELECT 
  [PLAYER_ID],
  [POSITION],
      
  rank() over (partition by [PLAYER_ID] order by [SEASON] desc, AGE desc, TeamID desc) as ranking 
  FROM [nba_game_data].[dbo].[CommonTeamRoster]
  ), backup_position as(
  select  
  [PLAYER_ID],
  [POSITION]
      
  from base1 
  where ranking = 1),
  base AS (
SELECT 
	   lgl.[GAME_ID]
      ,scd.[TEAM_ID]
	  ,coalesce(ctr.POSITION,bp.POSITION,'NF') as POSITION
	  ,scd.PLAYER_ID
	  ,scd.PLAYER_NAME
	  ,lgl.TEAM_ABBREVIATION
	  ,lgl.oppAbrv
	  ,cast(lgl.GAME_DATE as date) as GAME_DATE
	  ,[PERIOD]
      ,(abs(5-[PERIOD])*12)-(12-[MINUTES_REMAINING]) as MINUTES_REMAINING_IN_GAME
      ,[MINUTES_REMAINING] as MINUTES_REMAINING_IN_PERIOD
	  ,(abs(5-[PERIOD])*720)-(720-[SECONDS_REMAINING]) AS SECONDS_REMAINING_IN_GAME
      ,[SECONDS_REMAINING] AS SECONDS_REMAINING_IN_PERIOD
	  ,[ACTION_TYPE]
      ,[EVENT_TYPE]
	  ,SHOT_ZONE_AREA
	  ,SHOT_TYPE
	  ,SHOT_ZONE_BASIC
	  ,SHOT_ZONE_RANGE
      ,CASE WHEN TRIM([EVENT_TYPE]) = 'Made Shot' THEN 1 ELSE 0 END AS SHOT_MADE
	  , lgl.yearSeason

  FROM [nba_game_data].[dbo].[ShotChartDetail] scd
  LEFT OUTER JOIN nba_game_data.dbo.LeagueGameLog lgl
  on 
  scd.GAME_ID = lgl.GAME_ID
  and scd.TEAM_ID = lgl.TEAM_ID

  left outer join [nba_game_data].[dbo].[CommonTeamRoster] ctr
  on scd.PLAYER_ID = ctr.PLAYER_ID
  and lgl.yearSeason = ctr.SEASON
  and lgl.TEAM_ID = ctr.TeamID

  left outer join backup_position bp
on
scd.PLAYER_ID = bp.PLAYER_ID

  ), opponate_join as(
  SELECT 
	   [GAME_ID]
      ,[TEAM_ID]
	  ,POSITION
	  ,TEAM_ABBREVIATION
	  ,oppAbrv
	  ,GAME_DATE
	  ,[ACTION_TYPE]
      ,[EVENT_TYPE]
	  ,SHOT_ZONE_AREA
	  ,SHOT_TYPE
	  ,SHOT_ZONE_BASIC
	  ,SHOT_ZONE_RANGE
      ,cast(SHOT_MADE as float) as SHOT_MADE
	  , yearSeason
	  ,rank() over (PARTITION BY [TEAM_ID], GAME_ID, ACTION_TYPE, POSITION order by SECONDS_REMAINING_IN_GAME ) AS RANKING


  FROM base 

  ),  the_meat as (
	SELECT 
    GAME_ID,
    TEAM_ID,
	POSITION,
	TEAM_ABBREVIATION,
    oppAbrv,
    GAME_DATE,
    yearSeason,

	AVG(CASE WHEN SHOT_ZONE_AREA = 'Right Side(R)' THEN SHOT_MADE ELSE NULL END) AS Right_Side_Shot_PCT,
	AVG(CASE WHEN SHOT_ZONE_AREA = 'Left Side(L)' THEN SHOT_MADE ELSE NULL END) AS Left_Side_Shot_PCT,
	AVG(CASE WHEN SHOT_ZONE_AREA = 'Left Side Center(LC)' THEN SHOT_MADE ELSE NULL END) AS Left_Center_Shot_PCT,
	AVG(CASE WHEN SHOT_ZONE_AREA = 'Center(C)' THEN SHOT_MADE ELSE NULL END) AS Center_Shot_PCT,
	AVG(CASE WHEN SHOT_ZONE_AREA = 'Back Court(BC)' THEN SHOT_MADE ELSE null END) AS Back_Court_Shot_PCT,
	AVG(CASE WHEN SHOT_ZONE_AREA = 'Right Side Center(RC)' THEN SHOT_MADE ELSE NULL END) AS Right_Center_Shot_PCT,

	COUNT(CASE WHEN SHOT_ZONE_AREA = 'Right Side(R)' THEN SHOT_MADE ELSE NULL END) AS Right_Side_Shot_COUNT,
	COUNT(CASE WHEN SHOT_ZONE_AREA = 'Left Side(L)' THEN SHOT_MADE ELSE NULL END) AS Left_Side_Shot_COUNT,
	COUNT(CASE WHEN SHOT_ZONE_AREA = 'Left Side Center(LC)' THEN SHOT_MADE ELSE NULL END) AS Left_Center_Shot_COUNT,
	COUNT(CASE WHEN SHOT_ZONE_AREA = 'Center(C)' THEN SHOT_MADE ELSE NULL END) AS Center_Shot_COUNT,
	COUNT(CASE WHEN SHOT_ZONE_AREA = 'Back Court(BC)' THEN SHOT_MADE ELSE null END) AS Back_Court_Shot_COUNT,
	COUNT(CASE WHEN SHOT_ZONE_AREA = 'Right Side Center(RC)' THEN SHOT_MADE ELSE NULL END) AS Right_Center_Shot_COUNT

  FROM opponate_join

GROUP BY GAME_ID, TEAM_ID, oppAbrv, GAME_DATE, yearSeason,TEAM_ABBREVIATION,POSITION
)
select 
the_meat.GAME_ID
,the_meat.TEAM_ID
,the_meat.POSITION
,the_meat.TEAM_ABBREVIATION
,the_meat.oppAbrv
,the_meat.GAME_DATE
,the_meat.yearSeason
,coalesce(AVG(opp_meat.Right_Side_Shot_PCT) OVER (PARTITION BY the_meat.TEAM_ID, the_meat.yearSeason,the_meat.POSITION ORDER BY the_meat.GAME_DATE ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING),0) AS Team_Allowed_Right_Side_Shot_PCT
,coalesce(AVG(opp_meat.Left_Side_Shot_PCT) OVER (PARTITION BY the_meat.TEAM_ID, the_meat.yearSeason,the_meat.POSITION ORDER BY the_meat.GAME_DATE ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING),0) as Team_Allowed_Left_Side_Shot_PCT
,coalesce(AVG(opp_meat.Left_Center_Shot_PCT) OVER (PARTITION BY the_meat.TEAM_ID, the_meat.yearSeason,the_meat.POSITION ORDER BY the_meat.GAME_DATE ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING),0) as Team_Allowed_Left_Center_Shot_PCT
,coalesce(AVG(opp_meat.Center_Shot_PCT) OVER (PARTITION BY the_meat.TEAM_ID, the_meat.yearSeason,the_meat.POSITION ORDER BY the_meat.GAME_DATE ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING),0) as Team_Allowed_Center_Shot_PCT
,coalesce(AVG(opp_meat.Back_Court_Shot_PCT) OVER (PARTITION BY the_meat.TEAM_ID, the_meat.yearSeason,the_meat.POSITION ORDER BY the_meat.GAME_DATE ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING),0) as Team_Allowed_Back_Court_Shot_PCT
,coalesce(AVG(opp_meat.Right_Center_Shot_PCT) OVER (PARTITION BY the_meat.TEAM_ID, the_meat.yearSeason,the_meat.POSITION ORDER BY the_meat.GAME_DATE ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING),0) as Team_Allowed_Right_Center_Shot_PCT

,coalesce(AVG(CAST(opp_meat.Right_Side_Shot_COUNT AS FLOAT)) OVER (PARTITION BY the_meat.TEAM_ID, the_meat.yearSeason,the_meat.POSITION ORDER BY the_meat.GAME_DATE ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING),0) AS Team_Allowed_Right_Side_Shot_COUNT
,coalesce(AVG(CAST(opp_meat.Left_Side_Shot_COUNT AS FLOAT)) OVER (PARTITION BY the_meat.TEAM_ID, the_meat.yearSeason,the_meat.POSITION ORDER BY the_meat.GAME_DATE ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING),0) as Team_Allowed_Left_Side_Shot_COUNT
,coalesce(AVG(CAST(opp_meat.Left_Center_Shot_COUNT AS FLOAT)) OVER (PARTITION BY the_meat.TEAM_ID, the_meat.yearSeason,the_meat.POSITION ORDER BY the_meat.GAME_DATE ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING),0) as Team_Allowed_Left_Center_Shot_COUNT
,coalesce(AVG(CAST(opp_meat.Center_Shot_COUNT AS FLOAT)) OVER (PARTITION BY the_meat.TEAM_ID, the_meat.yearSeason,the_meat.POSITION ORDER BY the_meat.GAME_DATE ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING),0) as Team_Allowed_Center_Shot_COUNT
,coalesce(AVG(CAST(opp_meat.Back_Court_Shot_COUNT AS FLOAT)) OVER (PARTITION BY the_meat.TEAM_ID, the_meat.yearSeason,the_meat.POSITION ORDER BY the_meat.GAME_DATE ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING),0) as Team_Allowed_Back_Court_Shot_COUNT
,coalesce(AVG(CAST(opp_meat.Right_Center_Shot_COUNT AS FLOAT)) OVER (PARTITION BY the_meat.TEAM_ID, the_meat.yearSeason,the_meat.POSITION ORDER BY the_meat.GAME_DATE ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING),0) as Team_Allowed_Right_Center_Shot_COUNT

from the_meat 

left outer join the_meat opp_meat 
on 
the_meat.oppAbrv = opp_meat.TEAM_ABBREVIATION
and the_meat.GAME_ID = opp_meat.GAME_ID
and the_meat.POSITION = opp_meat.POSITION


order by TEAM_ABBREVIATION,POSITION,GAME_DATE