select 
    action_type.PLAYER_ID
,   action_type.GAME_ID
,	[PlayerGameLogs].TEAM_ID
,   [PlayerGameLogs].yearSeason
,	[PlayerGameLogs].oppAbrv
,	[PlayerGameLogs].GAME_DATE
,	Over_24_ft
,	Back_Court_Shot
,	Eight_to_Sixteen_ft
,	Sixteen_to_TwentyFour_ft
,	Less_Than_Eight_ft
,	Right_Side_R
,	Left_Side_L
,	Left_Side_Center_LC
,	Center_C
,	Back_Court_BC
,	Above_the_Break_3
,	Restricted_Area
,	Mid_Range
,	Left_Corner_3
,	Backcourt
,	In_The_Paint_Non_RA
,	Right_Corner_3
,	Driving_Bank_shot
,	Hook_Shot
,	Driving_Jump_shot
,	Running_Hook_Shot
,	Tip_Layup_Shot
,	Step_Back_Jump_shot
,	Running_Finger_Roll_Layup_Shot
,	Pullup_Bank_shot
,	Driving_Reverse_Layup_Shot
,	Running_Layup_Shot
,	Alley_Oop_Layup_shot
,	Driving_Hook_Shot
,	Alley_Oop_Dunk_Shot
,	Running_Alley_Oop_Dunk_Shot
,	Turnaround_Jump_Shot
,	Reverse_Dunk_Shot
,	Running_Pull_Up_Jump_Shot
,	Driving_Layup_Shot
,	Turnaround_Fadeaway_shot
,	Driving_Floating_Jump_Shot
,	Driving_Dunk_Shot
,	Cutting_Dunk_Shot
,	Running_Dunk_Shot
,	Running_Reverse_Dunk_Shot
,	Running_Jump_Shot
,	Driving_Reverse_Dunk_Shot
,	Putback_Layup_Shot
,	Fadeaway_Bank_shot
,	Hook_Bank_Shot
,	Tip_Dunk_Shot
,	Step_Back_Bank_Jump_Shot
,	No_Shot
,	Pullup_Jump_shot
,	Turnaround_Bank_shot
,	Running_Reverse_Layup_Shot
,	Turnaround_Fadeaway_Bank_Jump_Shot
,	Running_Alley_Oop_Layup_Shot
,	Finger_Roll_Layup_Shot
,	Cutting_Layup_Shot
,	Turnaround_Bank_Hook_Shot
,	Floating_Jump_shot
,	Layup_Shot
,	Dunk_Shot
,	Turnaround_Hook_Shot
,	Reverse_Layup_Shot
,	Cutting_Finger_Roll_Layup_Shot
,	Driving_Floating_Bank_Jump_Shot
,	Fadeaway_Jump_Shot
,	Jump_Bank_Shot
,	Driving_Finger_Roll_Layup_Shot
,	Putback_Dunk_Shot
,	Driving_Bank_Hook_Shot
,	Jump_Shot

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
