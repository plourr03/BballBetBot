create view shot_zone_area as

WITH basic_stats AS (
    SELECT 
        PLAYER_ID,
        PLAYER_NAME,
        GAME_ID,
        [Right Side(R)],
        [Left Side(L)],
        [Left Side Center(LC)],
        [Center(C)],
        [Back Court(BC)],
        [Right Side Center(RC)]
    FROM 
        (SELECT 
            [GAME_ID],
            [PLAYER_ID],
            [PLAYER_NAME],
            [SHOT_ZONE_AREA],
            AVG(CAST([SHOT_MADE_FLAG] as FLOAT)) as Shot_Pct
        FROM [nba_game_data].[dbo].[ShotChartDetail]
        GROUP BY
            [GAME_ID],
            [PLAYER_ID],
            [PLAYER_NAME],
            [SHOT_ZONE_AREA]) AS SourceTable
    PIVOT 
        (
            AVG(Shot_Pct)
            FOR [SHOT_ZONE_AREA] IN (
                [Right Side(R)],
                [Left Side(L)],
                [Left Side Center(LC)],
                [Center(C)],
                [Back Court(BC)],
                [Right Side Center(RC)]
            )
        ) AS PivotTable
)
SELECT 
    PLAYER_ID AS PLAYER_ID,
    PLAYER_NAME AS PLAYER_NAME,
    GAME_ID AS GAME_ID,
    COALESCE([Right Side(R)], 0) AS Right_Side_R,
    COALESCE([Left Side(L)], 0) AS Left_Side_L,
    COALESCE([Left Side Center(LC)], 0) AS Left_Side_Center_LC,
    COALESCE([Center(C)], 0) AS Center_C,
    COALESCE([Back Court(BC)], 0) AS Back_Court_BC,
    COALESCE([Right Side Center(RC)], 0) AS Right_Side_Center_RC
FROM basic_stats

