create view shot_zone_range as
WITH basic_stats AS (
    SELECT 
        PLAYER_ID,
        PLAYER_NAME,
        GAME_ID,
        [24+ ft.],
        [Back Court Shot],
        [8-16 ft.],
        [16-24 ft.],
        [Less Than 8 ft.]
    FROM 
        (SELECT 
            [GAME_ID],
            [PLAYER_ID],
            [PLAYER_NAME],
            [SHOT_ZONE_RANGE],
            AVG(CAST([SHOT_MADE_FLAG] as FLOAT)) as Shot_Pct
        FROM [nba_game_data].[dbo].[ShotChartDetail]
        GROUP BY
            [GAME_ID],
            [PLAYER_ID],
            [PLAYER_NAME],
            [SHOT_ZONE_RANGE]) AS SourceTable
    PIVOT 
        (
            AVG(Shot_Pct)
            FOR SHOT_ZONE_RANGE IN (
                [24+ ft.],
                [Back Court Shot],
                [8-16 ft.],
                [16-24 ft.],
                [Less Than 8 ft.]
            )
        ) AS PivotTable
)
SELECT 
    PLAYER_ID AS PLAYER_ID,
    PLAYER_NAME AS PLAYER_NAME,
    GAME_ID AS GAME_ID,
    COALESCE([24+ ft.], 0) AS Over_24_ft,
    COALESCE([Back Court Shot], 0) AS Back_Court_Shot,
    COALESCE([8-16 ft.], 0) AS Eight_to_Sixteen_ft,
    COALESCE([16-24 ft.], 0) AS Sixteen_to_TwentyFour_ft,
    COALESCE([Less Than 8 ft.], 0) AS Less_Than_Eight_ft
FROM basic_stats

