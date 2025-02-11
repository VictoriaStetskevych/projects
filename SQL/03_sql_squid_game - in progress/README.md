# SQL Squid Game - in progress

I did this project using tasks from the DataLemur's [SQL game](https://datalemur.com/sql-game) inspired by Netflix's Squid Game. <br>

The dataset for the game/project: [csv](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/data/player.csv) or [xlsx](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/data/player.xlsx)<br>

The Goal - to help the Front Men to analyze data. <br>

## <u>Initial Data Analysis</u>  <br>

So, before jumping into the game and answering the Front Man's questions, I decided to review the data I received.<br>

```sql
SELECT *
FROM player;
```
Result:<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/04_data.png?raw=true)<br>

- Check the total amount of players<br>
```sql
SELECT COUNT(DISTINCT id) AS unique_id_total
FROM player;    
```
Result:<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/05_unique_id_total.png?raw=true)<br>

- As a big fan of the Squid Game TV show, I couldn’t resist checking the player ID numbers from both seasons.<br>
```sql
-- season 1
SELECT *
FROM player
WHERE id IN (456, 67, 218, 199, 101);
-- season 2
SELECT *
FROM player
WHERE id IN (333, 388, 120, 7, 149, 390, 222);    
```
Result:<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/06_season_1.png?raw=true)
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/07_season_2.png?raw=true)<br>

- #001 in this dataset isn’t Oh Il-nam, In-ho, or Oh Young-il, but when I showed my husband who #001 was, he told me it’s a very well-known person. <br>
```sql
SELECT * 
FROM player 
WHERE id = 001;
```
Result:<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/08_player_001.png?raw=true)<br>

- I also checked MAX and MIN ages of players<br>
```sql
SELECT
	MAX (age) as max_age,
	MIN (age) as min_age
FROM player;
```
Result:<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/09_max_min_age.png?raw=true)<br>

- Then I thought, what if there wasn’t just one player who was 19 or 85? Plus, I knew that the first game, "Red Light, Green Light," was over, so I decided to count the players with the maximum and minimum ages who survived.<br>
```sql
SELECT 
    COUNT(CASE WHEN age = 19 THEN 1 END) AS count_age_19,
    COUNT(CASE WHEN age = 85 THEN 1 END) AS count_age_85
FROM player
WHERE status = 'alive';
```
Result:<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/10_max_min_age_alive.png?raw=true)<br>

- Additionally, I decided to check the number of players who survived/died after the first game.<br>
```sql
SELECT 
	COUNT(CASE WHEN status = 'alive' then 1 END) as alive_count,
	COUNT(CASE WHEN status = 'dead' then 1 END) as dead_count
FROM player;
```
Result:<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/11_first_game_survived_died.png?raw=true)<br>

- I also was curios to check people with biggest debt. I was really surprised to see such unexpected result and these players:<br>
```sql
SELECT * 
FROM player 
ORDER BY debt desc;
```
Result:<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/12_max_debt.png?raw=true)<br>

- And players with smallest debt<br>
```sql
SELECT * 
FROM player 
ORDER BY debt asc;
```
Result:<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/13_min_debt.png?raw=true)<br>

## <u>LEVEL 1. Red Light, Green Light</u>

<u>Task<br></u>
"The organizers want to identify vulnerable living players who might be easily manipulated for the next game. Find all players who are alive, in severe debt (debt > 400,000,000 won), and are either elderly (age > 65) OR have a vice of Gambling with no family connections."<br>

<u>Solution.<br></u>
I wanted to see who had the biggest debt among this group of players, so I added 'ORDER BY debt DESC' to my query.
```sql
SELECT *
FROM player
WHERE 
    status = 'alive'
    AND debt > 400000000
    AND (age > 65 OR (vice = 'Gambling' AND has_close_family = 'false'))
ORDER BY debt DESC;               
```
<u>Result:</u><br>
99 rows. Here a couple first players from this group of players<br>

![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/14_level_1.png?raw=true)

## <u>LEVEL 2. Rations</u>

<u>Task<br></u>
"The organizers need to calculate how many food portions to withhold to create the right amount of tension. In a table, calculate how many rations would feed 90% of the remaining(alive) non-insider players (rounded down), and in another column, indicate if the current rations supply is sufficient. (True or False)"
For this task I also had to use a new table 'rations':<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/15_new_schema.png?raw=true)<br>
New table 'rations': [csv](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/data/rations.csv) or [xlsx](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/data/rations.xlsx)<br>

<u>Solution:</u><br>
At first I checked a new table:
```sql
SELECT *
FROM rations;
```
<u>Result:<br></u>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/16_rations.png?raw=true)

And now the solution for the Level 2 task:
```sql
SELECT 
    FLOOR(COUNT(id) * 0.9) AS cut_food_portions,
    CASE
        WHEN (FLOOR(COUNT(id) * 0.9) <= (SELECT amount FROM rations)) THEN 'True'
        ELSE 'False'
    END AS rations_supply
FROM player
WHERE status = 'alive' AND isinsider = 'false';
```
<u>Result:</u><br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/17_level_2.png?raw=true)


## <u>Level 3. Scenario </u>

For the next level I got 2 new tables:<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/18_level_3_new_schema.png?raw=true)<br>
- monthly_temperatures: [cvs](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/data/monthly_temperatures.csv) or [xlsx](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/data/monthly_temperatures.xlsx)<br>
- honeycomb_game: [csv](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/data/honeycomb_game.csv) or [xlsx](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/data/honeycomb_game.xlsx)

<u>Task<br></u>
Analyze the average completion times for each shape in the honeycomb game during the hottest and coldest months, using data from the past 20 years only. Order the results by average completion time.<br>

<u>Solution:</u>
Step 1
```
-- find MAX/MIN temperatures from the monthly_temperatures table
SELECT 
	month,
	avg_temperature
FROM monthly_temperatures
WHERE 
	avg_temperature = (SELECT MAX(avg_temperature) FROM monthly_temperatures)
    OR avg_temperature = (SELECT MIN(avg_temperature) FROM monthly_temperatures)
```
Result:
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/19_max_min_temp.png?raw=true)

Step 2. Level 3 - Solution
```sql
WITH temp_max_min AS (
    -- Find the hottest and coldest months
    SELECT 
        month,
        avg_temperature
    FROM monthly_temperatures
    WHERE 
        avg_temperature = (SELECT MAX(avg_temperature) FROM monthly_temperatures)
        OR avg_temperature = (SELECT MIN(avg_temperature) FROM monthly_temperatures)
)
SELECT 
	-- Extract month from the date
    EXTRACT(MONTH FROM h.date) AS month,  
    h.shape,
	-- Find average time
    AVG(h.average_completion_time) AS avg_completion_time  
FROM honeycomb_game h
	-- Join table temp_max_min and honeycomb_game
JOIN temp_max_min t 
	ON EXTRACT(MONTH FROM h.date) = t.month 
	-- Count the last 20 years only
WHERE h.date >= CURRENT_DATE - INTERVAL '20 years'
	-- Group by month and shape
GROUP BY EXTRACT(MONTH FROM h.date), h.shape
ORDER BY avg_completion_time;
```
Result:
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/20_level_3.png?raw=true)

## Level 4. 

<u>Task.</u><br>
"The Front Man needs to analyze and rank the teams before the Tug of War game begins. For each team that has exactly 10 players, calculate their average player age. Additionally, categorize the teams based on their average player age into three age groups:

'Fit': Average age < 40
'Grizzled': Average age between 40 and 50 (inclusive)
'Elderly': Average age > 50

Show the team_id, average age, age group, and rank the teams based on their average player age (highest average age = rank 1)."

For this level I had a new schema
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/21_level_4_new_schema.png?raw=true)

<u>Solution</u><br>
Step 1. <br>
```sql
-- Count amount of unique teams 
SELECT 
	COUNT(DISTINCT(team_id)) as teams
FROM player;
```
Result: 36 teams <br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/22_unique_teams.png?raw=true)

 Step 2
 ```sql
 -- AVG age of each team
 SELECT 	
	COUNT(id) as total_players,
	team_id,
	AVG(age) as age_group
FROM player
GROUP BY team_id;
```     
Result (first 10 teams):
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/23_teams_avg_age.png?raw=true)

Step 3. Level 4 - Solution
 ```sql
 SELECT 
    team_id,
    AVG(age) AS avg_age,
    -- Divide teams into 3 age categories
    CASE 
        WHEN AVG(age) < 40 THEN 'Fit'
        WHEN AVG(age) BETWEEN 40 AND 50 THEN 'Grizzled'
        ELSE 'Elderly'
    END AS age_category,
    RANK() OVER (ORDER BY AVG(age) DESC) AS rank
FROM player
GROUP BY team_id
HAVING COUNT(id) = 10;
 ```        
Result:
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/24_level_4.png?raw=true)

## <u >Level 5 </u>

"For the Marbles game, the Front Man needs you to discover who Player 456's closest companion is. First, find the player who has interacted with Player 456 the most frequently in daily activities. Then, confirm this player is still alive and return a row with both players' first names, and the number of interactions they've had.
"
I have a new schema in this task
daily_interactions: csv or xlsx

![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/25_level_5_new_schema.png?raw=true)

Step 1
```sql
-- Check #456 interactions
select *
from daily_interactions
WHERE player1_id = 456	OR player2_id = 456;
```
Result:
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/26_456_interactions.png?raw=true)






## <u>Resources:</u>

DataLemur - https://datalemur.com/
SQL Squid Game - https://datalemur.com/sql-game

