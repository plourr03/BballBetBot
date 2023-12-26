with base as (
select 
   action_type.GAME_ID
,	[PlayerGameLogs].TEAM_ID
,   [PlayerGameLogs].yearSeason
,	[PlayerGameLogs].oppAbrv
,	[PlayerGameLogs].GAME_DATE
,   COALESCE(CASE WHEN ctr.[POSITION] = 'G-F' THEN 'G' ELSE
				 CASE WHEN ctr.[POSITION] = 'F-C' THEN 'F' ELSE
				 CASE WHEN ctr.[POSITION] = 'F-G' THEN 'F' ELSE
				 CASE WHEN ctr.[POSITION] = 'C-F' THEN 'C' ELSE
				 ctr.[POSITION] END END END END ,ctr2.POSITION,'NF') as POSITION
,	AVG(Over_24_ft) AS Over_24_ft
,	AVG(Back_Court_Shot) AS Back_Court_Shot
,	AVG(Eight_to_Sixteen_ft) AS Eight_to_Sixteen_ft
,	AVG(Sixteen_to_TwentyFour_ft)	AS Sixteen_to_TwentyFour_ft
,	AVG(Less_Than_Eight_ft)	AS Less_Than_Eight_ft
,	AVG(Right_Side_R) AS Right_Side_R
,	AVG(Left_Side_L) AS Left_Side_L
,	AVG(Left_Side_Center_LC) AS Left_Side_Center_LC
,	AVG(Center_C)	AS Center_C
,	AVG(Back_Court_BC)	AS Back_Court_BC
,	AVG(Above_the_Break_3)	AS Above_the_Break_3
,	AVG(Restricted_Area) AS Restricted_Area
,	AVG(Mid_Range)	AS Mid_Range
,	AVG(Left_Corner_3)	AS Left_Corner_3
,	AVG(Backcourt)	AS Backcourt
,	AVG(In_The_Paint_Non_RA) AS In_The_Paint_Non_RA
,	AVG(Right_Corner_3)	AS Right_Corner_3
,	AVG(Driving_Bank_shot)	AS Driving_Bank_shot
,	AVG(Hook_Shot)	AS Hook_Shot
,	AVG(Driving_Jump_shot) AS Driving_Jump_shot
,	AVG(Running_Hook_Shot) AS Running_Hook_Shot
,	AVG(Tip_Layup_Shot)	AS Tip_Layup_Shot
,	AVG(Step_Back_Jump_shot) AS Step_Back_Jump_shot
,	AVG(Running_Finger_Roll_Layup_Shot)	AS Running_Finger_Roll_Layup_Shot
,	AVG(Pullup_Bank_shot) AS Pullup_Bank_shot
,	AVG(Driving_Reverse_Layup_Shot) AS Driving_Reverse_Layup_Shot
,	AVG(Running_Layup_Shot)	AS Running_Layup_Shot
,	AVG(Alley_Oop_Layup_shot) AS Alley_Oop_Layup_shot
,	AVG(Driving_Hook_Shot)	AS Driving_Hook_Shot
,	AVG(Alley_Oop_Dunk_Shot) AS Alley_Oop_Dunk_Shot
,	AVG(Running_Alley_Oop_Dunk_Shot) AS Running_Alley_Oop_Dunk_Shot
,	AVG(Turnaround_Jump_Shot)	AS Turnaround_Jump_Shot
,	AVG(Reverse_Dunk_Shot)	AS Reverse_Dunk_Shot
,	AVG(Running_Pull_Up_Jump_Shot)	AS Running_Pull_Up_Jump_Shot
,	AVG(Driving_Layup_Shot)	AS Driving_Layup_Shot
,	AVG(Turnaround_Fadeaway_shot)	AS Turnaround_Fadeaway_shot
,	AVG(Driving_Floating_Jump_Shot)	AS Driving_Floating_Jump_Shot
,	AVG(Driving_Dunk_Shot)	AS Driving_Dunk_Shot
,	AVG(Cutting_Dunk_Shot)	AS Cutting_Dunk_Shot
,	AVG(Running_Dunk_Shot)	AS Running_Dunk_Shot
,	AVG(Running_Reverse_Dunk_Shot)	AS Running_Reverse_Dunk_Shot
,	AVG(Running_Jump_Shot)	AS Running_Jump_Shot
,	AVG(Driving_Reverse_Dunk_Shot)	AS Driving_Reverse_Dunk_Shot
,	AVG(Putback_Layup_Shot)	AS Putback_Layup_Shot
,	AVG(Fadeaway_Bank_shot)	AS Fadeaway_Bank_shot
,	AVG(Hook_Bank_Shot)	AS Hook_Bank_Shot
,	AVG(Tip_Dunk_Shot)	AS Tip_Dunk_Shot
,	AVG(Step_Back_Bank_Jump_Shot) AS Step_Back_Bank_Jump_Shot
,	AVG(No_Shot) AS No_Shot
,	AVG(Pullup_Jump_shot) AS Pullup_Jump_shot
,	AVG(Turnaround_Bank_shot) AS Turnaround_Bank_shot
,	AVG(Running_Reverse_Layup_Shot)	AS Running_Reverse_Layup_Shot
,	AVG(Turnaround_Fadeaway_Bank_Jump_Shot) AS Turnaround_Fadeaway_Bank_Jump_Shot
,	AVG(Running_Alley_Oop_Layup_Shot) AS Running_Alley_Oop_Layup_Shot
,	AVG(Finger_Roll_Layup_Shot) AS Finger_Roll_Layup_Shot
,	AVG(Cutting_Layup_Shot) AS Cutting_Layup_Shot
,	AVG(Turnaround_Bank_Hook_Shot) AS Turnaround_Bank_Hook_Shot
,	AVG(Floating_Jump_shot) AS Floating_Jump_shot
,	AVG(Layup_Shot) AS Layup_Shot
,	AVG(Dunk_Shot) AS Dunk_Shot
,	AVG(Turnaround_Hook_Shot) AS Turnaround_Hook_Shot
,	AVG(Reverse_Layup_Shot) AS Reverse_Layup_Shot
,	AVG(Cutting_Finger_Roll_Layup_Shot) AS Cutting_Finger_Roll_Layup_Shot
,	AVG(Driving_Floating_Bank_Jump_Shot) AS Driving_Floating_Bank_Jump_Shot
,	AVG(Fadeaway_Jump_Shot) AS Fadeaway_Jump_Shot
,	AVG(Jump_Bank_Shot) AS Jump_Bank_Shot
,	AVG(Driving_Finger_Roll_Layup_Shot) AS Driving_Finger_Roll_Layup_Shot
,	AVG(Putback_Dunk_Shot) AS Putback_Dunk_Shot
,	AVG(Driving_Bank_Hook_Shot) AS Driving_Bank_Hook_Shot
,	AVG(Jump_Shot) AS Jump_Shot

from [nba_game_data].[dbo].action_type

LEFT OUTER JOIN [nba_game_data].[dbo].shot_zone_area
ON 
action_type.PLAYER_ID = shot_zone_area.PLAYER_ID
and action_type.GAME_ID = shot_zone_area.GAME_ID

LEFT OUTER JOIN [nba_game_data].[dbo].shot_zone_basic
ON 
action_type.PLAYER_ID = shot_zone_basic.PLAYER_ID
and action_type.GAME_ID = shot_zone_basic.GAME_ID

LEFT OUTER JOIN [nba_game_data].[dbo].shot_zone_range
ON 
action_type.PLAYER_ID = shot_zone_range.PLAYER_ID
and action_type.GAME_ID = shot_zone_range.GAME_ID

LEFT OUTER JOIN [nba_game_data].[dbo].[PlayerGameLogs]
ON 
action_type.PLAYER_ID = [PlayerGameLogs].PLAYER_ID
and action_type.GAME_ID = [PlayerGameLogs].GAME_ID

LEFT OUTER JOIN [nba_game_data].[dbo].[CommonTeamRoster] ctr
ON
cast(action_type.PLAYER_ID as int) = cast(ctr.PLAYER_ID as int)
AND cast([PlayerGameLogs].TEAM_ID as int) = cast(ctr.TeamID as int)
AND cast([PlayerGameLogs].yearSeason as int) = cast(ctr.SEASON as int)

LEFT OUTER JOIN [nba_game_data].[dbo].[BackupPlayerPosition] ctr2
ON 
cast(action_type.PLAYER_ID as int) = cast(ctr2.PLAYER_ID as int)

GROUP BY action_type.GAME_ID
,	[PlayerGameLogs].TEAM_ID
,   [PlayerGameLogs].yearSeason
,	[PlayerGameLogs].oppAbrv
,	[PlayerGameLogs].GAME_DATE
,   COALESCE(CASE WHEN ctr.[POSITION] = 'G-F' THEN 'G' ELSE
				 CASE WHEN ctr.[POSITION] = 'F-C' THEN 'F' ELSE
				 CASE WHEN ctr.[POSITION] = 'F-G' THEN 'F' ELSE
				 CASE WHEN ctr.[POSITION] = 'C-F' THEN 'C' ELSE
				 ctr.[POSITION] END END END END ,ctr2.POSITION,'NF')

)

 SELECT 
    b.GAME_ID
,	lgl.TEAM_ID
,   b.yearSeason
,	lgl.TEAM_ABBREVIATION
,	b.GAME_DATE
,	Over_24_ft
,	POSITION
,	CASE WHEN TRIM(POSITION) = 'NF' THEN AVG(CAST(Over_24_ft AS FLOAT)) OVER ( PARTITION BY b.oppAbrv, b.yearSeason ORDER BY b.GAME_DATE ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING ) ELSE COALESCE(AVG(CAST(Over_24_ft AS FLOAT)) OVER ( PARTITION BY b.oppAbrv, b.yearSeason, b.[POSITION] ORDER BY b.GAME_DATE ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING ),AVG(CAST(Over_24_ft AS FLOAT)) OVER ( PARTITION BY b.oppAbrv, b.POSITION ORDER BY b.GAME_DATE ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING ),0) END  AS Team_Allowed_Over_24_ft


 FROM base b

 LEFT OUTER JOIN [nba_game_data].[dbo].[LeagueGameLog] lgl
 ON 
 b.oppAbrv = lgl.TEAM_ABBREVIATION
 and b.GAME_ID = lgl.GAME_ID