create view shot_zone_basic as

WITH basic_stats AS (
  SELECT 
    PLAYER_ID,
    PLAYER_NAME,
    GAME_ID,
    [Above the Break 3] AS 'Above_the_Break_3',
    [Restricted Area] AS 'Restricted_Area',
    [Mid-Range] AS 'Mid_Range',
    [Left Corner 3] AS 'Left_Corner_3',
    [Backcourt] AS 'Backcourt',
    [In The Paint (Non-RA)] AS 'In_The_Paint_Non_RA',
    [Right Corner 3] AS 'Right_Corner_3'
FROM 
    (SELECT 
	   [GAME_ID]
      ,[PLAYER_ID]
      ,[PLAYER_NAME]
	  ,[SHOT_ZONE_BASIC]
	  ,AVG(CAST([SHOT_MADE_FLAG] as FLOAT)) as Shot_Pct
	  
  FROM [nba_game_data].[dbo].[ShotChartDetail]

  GROUP BY
	   [GAME_ID]
      ,[PLAYER_ID]
      ,[PLAYER_NAME]
	  ,[SHOT_ZONE_BASIC]) AS SourceTable
PIVOT 
    (
        AVG(Shot_Pct)
        FOR SHOT_ZONE_BASIC IN ([Above the Break 3], [Restricted Area], [Mid-Range], [Left Corner 3], [Backcourt], [In The Paint (Non-RA)], [Right Corner 3])
    ) AS PivotTable
	)
	SELECT 
	PLAYER_ID AS PLAYER_ID,
	PLAYER_NAME AS PLAYER_NAME,
	GAME_ID AS GAME_ID,
	COALESCE(Above_the_Break_3,0) AS Above_the_Break_3,
	COALESCE(Restricted_Area,0) AS Restricted_Area,
	COALESCE(Mid_Range,0) AS Mid_Range,
	COALESCE(Left_Corner_3,0) AS Left_Corner_3,
	COALESCE(Backcourt,0) AS Backcourt,
	COALESCE(In_The_Paint_Non_RA,0) AS In_The_Paint_Non_RA,
	COALESCE(Right_Corner_3,0) AS Right_Corner_3

	FROM basic_stats

