# SQL Squid Game - in progress

I did this project using tasks from the DataLemur's [SQL game](https://datalemur.com/sql-game) inspired by Netflix's Squid Game. <br>

The dataset for the game/project: [csv](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/02_sql_squid_game%20-%20in%20progress/02_squid_games_sql.csv) or [xlsx](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/02_sql_squid_game%20-%20in%20progress/02_squid_games_sql.xlsx)<br>

The Goal - to help the Front Men to analyze data. <br>

## <u>Initial Data Analysis</u>  <br>

So, before jumping into the game and answering the Front Man's questions, I decided to review the data I received.<br>

```sql
SELECT *
FROM player;
```
Result:<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/02_sql_squid_game%20-%20in%20progress/images/04_data.png?raw=true)<br>

- Check the total amount of players<br>
```sql
SELECT COUNT(DISTINCT id) AS unique_id_total
FROM player;    
```
Result:<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/02_sql_squid_game%20-%20in%20progress/images/05_unique_id_total.png?raw=true)<br>

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
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/02_sql_squid_game%20-%20in%20progress/images/06_season_1.png?raw=true)
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/02_sql_squid_game%20-%20in%20progress/images/07_season_2.png?raw=true)<br>

- #001 in this dataset isn’t Oh Il-nam, In-ho, or Oh Young-il, but when I showed my husband who #001 was, he told me it’s a very well-known person. <br>
```sql
SELECT * 
FROM player 
WHERE id = 001;
```
Result:<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/02_sql_squid_game%20-%20in%20progress/images/08_player_001.png?raw=true)<br>

- I also checked MAX and MIN ages of players<br>
```sql
SELECT
	MAX (age) as max_age,
	MIN (age) as min_age
FROM player;
```
Result:<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/02_sql_squid_game%20-%20in%20progress/images/09_max_min_age.png?raw=true)<br>

- Then I thought, what if there wasn’t just one player who was 19 or 85? Plus, I knew that the first game, "Red Light, Green Light," was over, so I decided to count the players with the maximum and minimum ages who survived.<br>
```sql
SELECT 
    COUNT(CASE WHEN age = 19 THEN 1 END) AS count_age_19,
    COUNT(CASE WHEN age = 85 THEN 1 END) AS count_age_85
FROM player
WHERE status = 'alive';
```
Result:<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/02_sql_squid_game%20-%20in%20progress/images/10_max_min_age_alive.png?raw=true)<br>

- Additionally, I decided to check the number of players who survived/died after the first game.<br>
```sql
SELECT 
	COUNT(CASE WHEN status = 'alive' then 1 END) as alive_count,
	COUNT(CASE WHEN status = 'dead' then 1 END) as dead_count
FROM player;
```
Result:<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/02_sql_squid_game%20-%20in%20progress/images/11_first_game_survived_died.png?raw=true)<br>

- I also was curios to check people with biggest debt. I was really surprised to see such unexpected result and these players:<br>
```sql
SELECT * 
FROM player 
ORDER BY debt desc;
```
Result:<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/02_sql_squid_game%20-%20in%20progress/images/12_max_debt.png?raw=true)<br>

- And players with smallest debt<br>
```sql
SELECT * 
FROM player 
ORDER BY debt asc;
```
Result:<br>
![](https://github.com/VictoriaStetskevych/projects/blob/main/SQL/02_sql_squid_game%20-%20in%20progress/images/13_min_debt.png?raw=true)<br>

## <u>LEVEL 1</u>


Resources:

DataLemur - https://datalemur.com/
SQL Squid Game - https://datalemur.com/sql-game
