create or alter view BackupPlayerPosition as
with base as (
SELECT 
	  [PLAYER_ID]
      ,[PLAYER]
      ,[POSITION]
	  ,count(PLAYER) as number_of_years_in_pos

  FROM [nba_game_data].[dbo].[CommonTeamRoster]

group by 
	   [PLAYER_ID]
      ,[PLAYER]
      ,[POSITION]
	  ), base2 as (
select 
*
,rank() over (partition by PLAYER_ID order by number_of_years_in_pos desc, POSITION desc) as ranking
from base
)
select * 
from base2 
where ranking=1
