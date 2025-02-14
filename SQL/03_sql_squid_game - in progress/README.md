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
I have a new schema in this task<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/25_level_5_new_schema.png?raw=true)<br>

daily_interactions: [csv](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/data/daily_interactions.csv) or [xlsx](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/data/daily_interactions.xlsx)<br>

Step 1
```sql
-- Check #456 interactions
select *
from daily_interactions
WHERE player1_id = 456	OR player2_id = 456;
```
Result:
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/26_456_interactions.png?raw=true)

Step 2
```sql
-- count player 456 interactions with other players 
SELECT 
    CASE 
    WHEN d.player1_id = 456 THEN d.player2_id
    WHEN d.player2_id = 456 THEN d.player1_id
    END AS companion_id,
    COUNT(d.type) AS interactions
FROM daily_interactions d
WHERE d.player1_id = 456 OR d.player2_id = 456
GROUP BY companion_id
ORDER BY interactions DESC;
```
Result:
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/27_456_companions.png?raw=true)

Step 3. Level 5 - Solution
```sql
WITH interactions AS (
    SELECT 
        CASE 
            WHEN d.player1_id = 456 THEN d.player2_id
            WHEN d.player2_id = 456 THEN d.player1_id
        END AS companion_id,
        COUNT(d.type) AS interactions
    FROM daily_interactions d
    WHERE d.player1_id = 456 OR d.player2_id = 456
    GROUP BY companion_id
)
SELECT 
    p1.first_name AS player_456_first_name,
    p2.first_name AS companion_first_name,
    i.interactions
FROM interactions i
JOIN player p1 ON p1.id = 456
JOIN player p2 ON p2.id = i.companion_id
WHERE p2.status = 'alive'
ORDER BY i.interactions DESC
LIMIT 1;
```
Result:
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/28_level_5.png?raw=true)

## <u> Level 6. Game Equipment Quality Control </u>

<u>Task.</u> <br>
"The guards are investigating equipment durability across different game types, as some equipment has been breaking prematurely. Determine the game type with the highest number of equipment failures and identify the supplier responsible for the most failures within that game type. Finally, calculate the average lifespan until first failure, in whole years (using 365.2425 days per year), of all failed equipment supplied by this supplier for the most faulty game type."

I had a new schema in this level.<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/29_level_6_new_schema.png?raw=true)<br>

suppliers: [csv](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/data/suppliers.csv) or [xlsx](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/data/suppliers.xlsx)<br>
equipment: [csv](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/data/equipment.csv) or [xlsx](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/data/equipment.xlsx)<br>
failure_incidents: [csv](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/data/failure_incidents.csv) or [xlsx](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/data/failure_incidents.xlsx)<br>

Step 1
```sql
-- equipment failures and the amount of total failures of each type 
SELECT 
	DISTINCT(failure_type),
	COUNT(*) AS total_failures
FROM failure_incidents
GROUP BY failure_type
ORDER BY total_failures DESC;
```
Result:
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/30_failures.png?raw=true)

Step 2
```sql
-- total failures by game type and supplier id
SELECT 
	COUNT(f.*) AS total_failures,
	e.game_type,
	e.supplier_id
FROM failure_incidents f
JOIN equipment e ON f.failed_equipment_id=e.id
JOIN suppliers s ON s.id = e.supplier_id
GROUP BY e.game_type, e.supplier_id
ORDER BY total_failures DESC
LIMIT 10;
```
Result:
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/31_failures_game_supplier.png?raw=true)

So, after running these queries, I concluded that the highest number of equipment failures occurred during the "Red Light, Green Light" game, with equipment from supplier ID 29.

Step 3
```sql
-- check equipment ID from supplier 29 for the 'red light green light' game
SELECT *
FROM equipment
WHERE supplier_id = 29 AND game_type = 'red light green light';
```
Result:
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/32_supplier_29.png?raw=true)

Step 4
```sql
-- equipment 15, 104, 192 failure dates  
SELECT *
FROM failure_incidents
WHERE failed_equipment_id IN (15, 104, 192);
```
Result. 24 rows:
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/33_equipment_failure_dates.png?raw=true)

Step 5
```sql
-- the earliest equipment (15, 104, 192) failure 
SELECT
	failed_equipment_id,
	MIN(failure_date) as earliest_failure
FROM failure_incidents
WHERE failed_equipment_id IN (15, 104, 192)
GROUP BY failed_equipment_id
LIMIT 1;
```
Result:
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/34_earliest_failure.png?raw=true)

Step 6. Level 6 - Solution.
```sql
WITH first_failure AS (
    SELECT
        failed_equipment_id,
        MIN(failure_date) AS earliest_failure
    FROM failure_incidents
    WHERE failed_equipment_id IN (15, 104, 192)
    GROUP BY failed_equipment_id
)
SELECT 
    FLOOR(AVG((f.earliest_failure - e.installation_date) / 365.2425)) AS avg_lifespan_years
FROM first_failure f
JOIN equipment e ON e.id = f.failed_equipment_id;
```
Result:
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/35_level_6.png?raw=true)


## <u>Level 7. Suspicious Actions </u>

Task:
"Create a comprehensive report identifying guards who were missing from their sleeping quarters during off-duty hours. This report should include the following details for each missing guard, ordered by guard ID:<br>
Guard Number<br>
Code Name<br>
Status<br>
Last Seen in Room<br>
Spotted Outside Room Time<br>
Spotted Outside Room >Location<br>
Time Between Room and Outside<br>
Time Range from First to Last Detection of Any Guard"<br>

I had a new schema in this level.<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/36_level_7_new_schema.png?raw=true)<br>

room: [csv](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/data/room.csv) or [xlsx](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/data/room.xlsx)<br>
camera: [csv](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/data/camera.csv) or [xlsx](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/data/camera.xlsx)<br>
guard: [csv](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/data/guard.csv) or [xlsx](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/data/guard.xlsx)<br>

Step 1
```sql
-- find what rooms were vacant 
SELECT *
FROM room
WHERE isvacant = 'true';
```
Result:
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/37_room_vacant.png?raw=true)

Step 2
```sql
-- join guard table to add more data
SELECT
	r.id as room_id, 
	r.isvacant,
	r.last_check_time,
	g.id as guard_id,
	g.code_name,
	g.status
FROM room r
JOIN guard g ON g.assigned_room_id = r.id
WHERE isvacant = 'true'
ORDER BY g.id; 
```
Result:
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/38_room_and_guards.png?raw=true)

Step 3
```sql
-- join camera table and select only needed tables with specific names / order, as was requested in the Task
SELECT
	g.id as guard_number,
	g.code_name,
	g.status,
	r.last_check_time as last_seen_in_room,
	c.movement_detected_time as spotted_outside_room_time,
	c.location as spotted_outside_room_location
FROM room r
JOIN guard g ON g.assigned_room_id = r.id
JOIN camera c ON g.id = c.guard_spotted_id 
WHERE isvacant = 'true'
ORDER BY g.id; 
```
Result:
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/39_add_camera_data.png?raw=true)

Step 4
```sql
-- add between room and outside
SELECT
	g.id as guard_number,
	g.code_name,
	g.status,
	r.last_check_time as last_seen_in_room,
	c.movement_detected_time as spotted_outside_room_time,
	c.location as spotted_outside_room_location,
	c.movement_detected_time - r.last_check_time AS time_between_room_and_outside
FROM room r
JOIN guard g ON g.assigned_room_id = r.id
JOIN camera c ON g.id = c.guard_spotted_id 
WHERE isvacant = 'true' AND c.movement_detected = TRUE
ORDER BY g.id;
```
Result:
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/40_time_difference.png?raw=true)

Step 5. Level 7 - Solution
```sql
SELECT
	g.id as guard_number,
	g.code_name,
	g.status,
	r.last_check_time as last_seen_in_room,
	c.movement_detected_time as spotted_outside_room_time,
	c.location as spotted_outside_room_location,
	c.movement_detected_time - r.last_check_time AS time_between_room_and_outside,
	(SELECT MAX(c2.movement_detected_time) - MIN(c2.movement_detected_time)
    FROM camera c2
    WHERE c2.guard_spotted_id IS NOT NULL) AS time_range
FROM room r
JOIN guard g ON g.assigned_room_id = r.id
JOIN camera c ON g.id = c.guard_spotted_id 
WHERE isvacant = 'true' AND c.movement_detected = TRUE
ORDER BY g.id;
```
Result:
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/41_level_7_part_1.png?raw=true)

![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/42_level_7_part_2.png?raw=true)


## <u>Level 8. Glass Bridge</u>

Task.<br>
"Find and display the information for the player with the highest hesitation time among those who were pushed off in the game that has the highest average hesitation time before a push occurred.
For some advice, some of the inputs in this data were entered manually by inexperienced employees, so inconsistency is to be expected. "

I had a new schema in this level:
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/43_level_8_new_schema.png?raw=true)

player_level_8: [csv](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/data/player_level_8.csv) or [xlsx](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/data/player_level_8.xlsx)<br>
glass_bridge: [csv](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/data/glass_bridge.csv) or [xlsx](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/data/glass_bridge.xlsx)<br>

Step 1
```sql
-- check death_description column and to see if there are inconsistencies 
select DISTINCT(death_description)
from player;
```
Result: 
As a result, I ended up with four variations of the word "pushed," written in both uppercase and lowercase letters.
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/44_death_description.png?raw=true)


LIKE operator in SQL is case-sensitive so I had to combine LIKE '%push%' with the LOWER function.

Step 2
```sql
-- find a game with a highest average hesitation time
SELECT
	AVG(p.last_moved_time_seconds) AS avg_hesitation_time,
	gb.id AS game_id
FROM player p
JOIN glass_bridge gb ON gb.id = p.game_id
WHERE LOWER(p.death_description) LIKE '%push%'
GROUP BY gb.id
ORDER BY avg_hesitation_time DESC
LIMIT 10;
```
Result: 
Game # 26 had the highest average hesitation time
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/45_avg_hesitation.png?raw=true)

Step 3. Level 8 - Solution
```sql
SELECT
    id AS player_id,
    first_name,
    last_name,
    MAX(last_moved_time_seconds) AS max_hesitation_time
FROM player 
WHERE LOWER(death_description) LIKE '%push%' AND game_id = 26
GROUP BY id, first_name, last_name
ORDER BY max_hesitation_time DESC 
LIMIT 1;
```
Result:
"Really unexpected result"
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/46_max_hesitation.png?raw=true)


## <u> Level 9. SQL Game </u>

Task
"Identify who deviated from their assigned position during the Squid Game, and then output a list of guard IDs and access times of any OTHER guards who visited the same location during the disappearance time frame."

I had a new schema in this level:
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/47_level_9_new_schema.png?raw=true)

Step 1.
```sql
-- check a list of games to make sure we have a 'Squid Game' in this data 
SELECT DISTINCT(type)
FROM game_schedule;
```
Result:
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/48_games.png?raw=true)


Step 2
```sql
-- find the last game and the exact time when it was played
SELECT 
	date, 
	start_time, 
	end_time
FROM game_schedule
WHERE type = 'Squid Game'
ORDER BY date DESC
LIMIT 1;
```
Result:
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/49_last_squid_game.png?raw=true)

Step 3.
In this step, I found one guard(#31) who wasn’t at his post during my time frame, but when I checked access at a different location, it was much earlier than when the Squid Game was played.
```sql
WITH disappearance_time_frame AS (
  	SELECT 
  		date, 
  		start_time, 
  		end_time
    FROM game_schedule
    WHERE type = 'Squid Game'
    ORDER BY date DESC
    LIMIT 1
)
SELECT
	g.id AS guard_id,
	g.assigned_post,
	g.shift_start,
	g.shift_end,
	ddal.door_location AS wrong_access,
	ddal.access_time
FROM guard g
JOIN disappearance_time_frame dtf 
	ON g.shift_start < dtf.start_time AND g.shift_end > dtf.end_time
JOIN daily_door_access_logs ddal
	ON ddal.guard_id = g.id
WHERE g.assigned_post != ddal.door_location;
```
Result:
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/50_guard_31.png?raw=true)

Step 4
I decided to run another query to check the list of guards who were spotted in my data frame in the same location. <br>
So I deleted  this condition from my query<br>
"g.assigned_post != ddal.door_location"<br>
and added the following condition<br>
"WHERE ddal.access_time BETWEEN dtf.start_time AND dtf.end_time":
```sql
WITH disappearance_time_frame AS (
  	SELECT 
  		date, 
  		start_time, 
  		end_time
    FROM game_schedule
    WHERE type = 'Squid Game'
    ORDER BY date DESC
    LIMIT 1
)
SELECT
	g.id AS guard_id,
	g.assigned_post,
	g.shift_start,
	g.shift_end,
	ddal.door_location AS wrong_access,
	ddal.access_time
FROM guard g
JOIN disappearance_time_frame dtf 
	ON g.shift_start < dtf.start_time AND g.shift_end > dtf.end_time
JOIN daily_door_access_logs ddal
	ON ddal.guard_id = g.id
WHERE ddal.access_time BETWEEN dtf.start_time AND dtf.end_time;            
```
Result:
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/51_guards_access.png?raw=true)

Step 5. Level 9 - Solution
After previous step my conclusion was that I need to find a guard who had an access to the "Upper Management" during my time frame
```sql
WITH disappearance_time_frame AS (
  	SELECT 
  		date, 
  		start_time, 
  		end_time
    FROM game_schedule
    WHERE type = 'Squid Game'
    ORDER BY date DESC
    LIMIT 1
)
SELECT
	g.id AS guard_id,
	ddal.access_time
FROM guard g
JOIN disappearance_time_frame dtf 
	ON g.shift_start < dtf.start_time AND g.shift_end > dtf.end_time
JOIN daily_door_access_logs ddal
	ON ddal.guard_id = g.id
WHERE ddal.access_time BETWEEN dtf.start_time AND dtf.end_time
AND ddal.door_location = 'Upper Management';            
```
Result:
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/03_sql_squid_game%20-%20in%20progress/images/52_level_9.png?raw=true)

# THE END!
Wow! That was an amazing, exciting game, and incredible SQL practice!

## <u>Resources:</u>

DataLemur - https://datalemur.com/
SQL Squid Game - https://datalemur.com/sql-game

