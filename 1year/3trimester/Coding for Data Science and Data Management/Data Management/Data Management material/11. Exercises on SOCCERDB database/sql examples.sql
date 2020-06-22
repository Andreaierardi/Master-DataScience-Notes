-- SQL exercises

-- provide the SQL statement for creating appropriate db tables according to the following constraints:
--- a stadium has a name and it is associated with a city in a country. The name is unique in a city, but it is possible to have the same stadium name in different cities. The same city name can appear in different countries.
--- country is a reference to the db table "country".
--- a stadium has an address and a capacity, namely the number of available seats.
--- capacity cannot be less than 10000 which is also the default value
--- a stadium is associated with with one or more teams. For each associated team, the db provides the name of the  gallery where subscribed fans are seated.
--- if a team is deleted, the association with the stadium is deleted as well.
--- a stadium cannot be deleted if associated teams exist.
--- do not introduce serial id attributes. Use the above attributes to define keys.
CREATE TABLE stadium (
name varchar not null,
city varchar not null,
country integer not null REFERENCES country(id) ON DELETE NO ACTION on UPDATE CASCADE,
address varchar,
capacity integer DEFAULT 10000 CHECK (capacity >= 10000),
PRIMARY KEY(name, city, country)
);

-- if a team can have just one associated stadium
ALTER TABLE team ADD COLUMN stadium_name varchar;
ALTER TABLE team ADD COLUMN stadium_city varchar;
ALTER TABLE team ADD COLUMN stadium_country integer;
ALTER TABLE team ADD CONSTRAINT stadium_fk FOREIGN KEY (stadium_name, stadium_city, stadium_country) REFERENCES stadium(name, city, country) ON UPDATE CASCADE ON DELETE NO ACTION;

-- if a team can have more than one associated stadium 
CREATE TABLE stadium_team (
team integer NOT NULL REFERENCES team(id) ON UPDATE CASCADE ON DELETE CASCADE,
stadium_name varchar NOT NULL, 
stadium_city varchar NOT NULL, 
stadium_country integer NOT NULL,
gallery varchar NOT NULL,
PRIMARY KEY(team, stadium_name, stadium_city, stadium_country),
FOREIGN KEY (stadium_name, stadium_city, stadium_country) REFERENCES stadium(name, city, country) ON UPDATE CASCADE ON DELETE NO ACTION
);

-- retrieve name and birthday of players that have height = 180 
SELECT name, birthday
  FROM player
    WHERE height = 180;

-- retrieve players with left preferred foot 
SELECT *
  FROM player_attribute_survey
    WHERE preferred_foot = 'left';

-- retrieve players with left preferred foot and high attacking rate
SELECT player_id
  FROM player_attribute_survey
    WHERE preferred_foot = 'left'
      AND attacking_work_rate = 'high';

-- retrieve players with left preferred foot and high attacking rate or right preferred foot and crossing higher than 50
SELECT DISTINCT player_id, overall_rating
  FROM player_attribute_survey
    WHERE (preferred_foot = 'left' AND attacking_work_rate = 'high') 
      OR (preferred_foot = 'right' AND crossing > 50);

-- retrieve the league name and the corresponding country name
SELECT league.name AS lega, country.name AS paese
  FROM league, country
   WHERE country.id = league.country_id;

-- retrieve the league name and the corresponding country name for Italy and France
SELECT league.name AS lega, country.name AS paese
  FROM league, country
    WHERE (country.id = league.country_id)
      AND (country.name = 'Italy' OR country.name = 'France');
          
SELECT league.name AS lega, country.name AS paese
  FROM league INNER JOIN country ON country.id = league.country_id
    WHERE country.name = 'Italy' OR country.name = 'France';          

-- retrieve name and surname of players with left preferred foot and high attacking rate or right preferred foot and crossing higher than 50 (sort the result by name)
SELECT DISTINCT player_id AS "id player", player.name AS "player name", preferred_foot, attacking_work_rate, crossing
  FROM player_attribute_survey
    INNER JOIN player ON player_id = player.id
      WHERE (preferred_foot = 'left' AND attacking_work_rate = 'high') 
        OR (preferred_foot = 'right' AND crossing > 50);

-- retrieve name and surname of players with ball control between 0 and 50 and accelleration between 50 and 100
SELECT DISTINCT player_id AS "id player", player.name AS "player name"
  FROM player_attribute_survey
    INNER JOIN player ON player_id = player.id
      WHERE (ball_control between 0 AND 50) AND (acceleration between 50 AND 100);

-- retrieve teams that have "Real" in their name
SELECT *
  FROM team
    WHERE team_long_name like '%Real%';

-- retrieve bets where away_odds are higher than home_odds
SELECT *
  FROM bet
    WHERE away_odds > home_odds;

-- retrieve the bets where the draw_odds are not provided
SELECT *
  FROM bet
    WHERE draw_odds IS NOT NULL;

-- retrieve bets on Italian matches where away_odds are higher than home_odds
SELECT bet.*
  FROM bet INNER JOIN match ON bet.match_id = match.id 
    INNER JOIN league ON match.league_id = league.id 
    INNER JOIN country ON league.country_id = country.id
      WHERE (away_odds > home_odds) AND (country.name = 'Italy');
      
-- retrieve the results of matches that are not quoted in bets
-- (all the matches have a quotation: find a better example of left join)
SELECT match.id, home_team_goal, away_team_goal
  FROM match LEFT JOIN bet ON match.id = bet.match_id
    WHERE bet.match_id IS NULL;

-- retrieve the matches played by players named "Cristiano" and the corresponding team
SELECT match_player.match_id, player.name, team.team_long_name
  FROM player INNER JOIN match_player ON player.id = match_player.player_id 
    INNER JOIN team ON match_player.team_id = team.id
      WHERE player.name like '%Cristiano%';

-- retrieve the players younger than Cristiano Ronaldo
SELECT p.*
  FROM player AS p, player AS pr
    WHERE pr.name = 'Cristiano Ronaldo'
      AND p.birthday > pr.birthday;

-- retrieve the name of players with (at least one survey of) dribbling higher than Cristiano Ronaldo
SELECT DISTINCT p.*
  FROM player AS p INNER JOIN player_attribute_survey AS ps ON p.id = ps.player_id,
    player AS pr INNER JOIN player_attribute_survey AS psr ON pr.id = psr.player_id
      WHERE pr.name = 'Cristiano Ronaldo' AND ps.dribbling >= psr.dribbling;
      
-- retrieve the max value of dribbling for Cristiano Ronaldo
SELECT max(dribbling)
  FROM player_attribute_survey INNER JOIN player
    ON player_attribute_survey.player_id = player.id;
      WHERE player.name = 'Cristiano Ronaldo';

-- retrieve the average home_odds for the match 1979836
SELECT avg(home_odds)
  FROM bet
    WHERE match_id = '1979836';

-- retrieve the number of bets where draw_odds are not provided
SELECT count(*)
  FROM bet
    WHERE draw_odds IS NULL;

-- retrieve the max number of goals scored by Real Madrid in any home match
SELECT max(home_team_goal)
  FROM match INNER JOIN team ON match.home_team_id = team.id
      WHERE team_long_name like '%Real Madrid%';
      
-- retrieve the total number of goals scored by Real Madrid in home matches in 2010/2011
SELECT sum(home_team_goal)
  FROM match INNER JOIN team ON match.home_team_id = team.id
      WHERE season ='2010/2011' AND team_long_name like '%Real Madrid%';
      
-- retrieve the number of surveys collected for each player during time (return the player name in the result)
SELECT name, count(*) AS "number of surveys"
  FROM player_attribute_survey INNER JOIN player ON player_attribute_survey.player_id = player.id
  GROUP BY player_id, name
	ORDER BY name;

-- retrieve the number of teams for each league and season 
SELECT league.name, season, count(distinct home_team_id)
  FROM match INNER JOIN league ON match.league_id = league.id
    GROUP BY league_id, league.name, season
UNION
SELECT league.name, season, count(distinct away_team_id)
  FROM match INNER JOIN league ON match.league_id = league.id
    GROUP BY league_id, league.name, season;

-- retrieve the average odds for any match of Spain Liga of 2010/2011
SELECT match.id, avg(home_odds) as "home odds", avg(draw_odds) AS "draw odds", avg(away_odds) as "away odds"
  FROM match INNER JOIN league ON match.league_id = league.id
    INNER JOIN bet ON match.id = bet.match_id
    WHERE league.name LIKE '%Spain LIGA%' AND season = '2010/2011'
		GROUP BY match.id

-- retrieve the average odds for any match of Spain Liga of 2010/2011 where the average home_odds are higher than 0.5
SELECT match.id, avg(home_odds) as "home odds", avg(draw_odds) AS "draw odds", avg(away_odds) as "away odds"
  FROM match INNER JOIN league ON match.league_id = league.id
    INNER JOIN bet ON match.id = bet.match_id
    WHERE league.name LIKE '%Spain LIGA%' AND season = '2010/2011'
		GROUP BY match.id
		HAVING avg(home_odds) > 0.5;

-- retrieve the number of home matches played in the Spain Liga of 2010/2011 by each team
SELECT team_long_name, count(DISTINCT match.id)
  FROM match INNER JOIN league ON match.league_id = league.id
    INNER JOIN team ON match.home_team_id = team.id
      WHERE season ='2010/2011' AND league.name ilike '%Spain Liga%'
        GROUP BY home_team_id, team_long_name
          ORDER BY team_long_name;
          
-- retrieve the players that played more than 10 matches in the Liga of 2010/2011
SELECT player.name, count(*) AS "played matches"
  FROM match_player INNER JOIN match ON match_player.match_id = match.id 
  INNER JOIN player ON match_player.player_id = player.id
  INNER JOIN league ON match.league_id = league.id
    WHERE league.name LIKE '%Spain LIGA%' AND season = '2010/2011'
  		GROUP BY player_id, player.name
  		HAVING count(*) > 10
			ORDER BY name;

-- retrieve the matches of 2010/2011 where Cristiano Ronaldo played with Sergio Ramos
SELECT ht.team_long_name, at.team_long_name
  FROM match INNER JOIN team AS at ON match.away_team_id = at.id 
  INNER JOIN team AS ht ON match.home_team_id = ht.id
	WHERE match.id in
    (SELECT match_id
  		FROM match_player INNER JOIN player ON match_player.player_id = player.id 
  		INNER JOIN match ON match_player.match_id = match.id
			WHERE name = 'Cristiano Ronaldo' AND season = '2010/2011'
	INTERSECT
	SELECT match_id
  		FROM match_player INNER JOIN player ON match_player.player_id = player.id
			WHERE name = 'Sergio Ramos');

SELECT ht.team_long_name, at.team_long_name
	FROM match_player AS rmp INNER JOIN player AS rp ON rmp.player_id = rp.id 
	INNER JOIN match rm ON rmp.match_id = rm.id INNER JOIN team AS at ON rm.away_team_id = at.id 
	INNER JOIN team AS ht ON rm.home_team_id = ht.id,
  	match_player AS smp INNER JOIN player AS sp ON smp.player_id = sp.id
		WHERE rp.name = 'Cristiano Ronaldo' AND rm.season = '2010/2011' AND 
		sp.name = 'Sergio Ramos' AND rmp.match_id = smp.match_id;

-- retrieve the matches played by players born in the 1990's
SELECT DISTINCT match_id
  FROM match_player
    WHERE player_id IN (SELECT id
      FROM player
        WHERE birthday BETWEEN '1990-01-01' AND '1999-12-31');

-- retrieve the name of players with dribbling higher than all the dribbling values of Sebastian Giovinco
SELECT DISTINCT name
  FROM player
    INNER JOIN player_attribute_survey ON player.id = player_attribute_survey.player_id
      WHERE dribbling > 
        (SELECT max(dribbling)
          FROM player INNER JOIN player_attribute_survey 
            ON player.id = player_attribute_survey.player_id
              WHERE name = 'Sebastian Giovinco');

-- retrieve the survey records where Sebastian Giovinco has a dribbling value higher than Cristiano Ronaldo
SELECT psg.survey_date, psg.dribbling, psr.dribbling
  FROM player pg INNER JOIN player_attribute_survey psg ON pg.id = psg.player_id, player pr
    INNER JOIN player_attribute_survey psr ON pr.id = psr.player_id
      WHERE psg.survey_date = psr.survey_date AND pg.name = 'Sebastian Giovinco' 
        AND pr.name = 'Cristiano Ronaldo' AND psg.dribbling > psr.dribbling;

-- retrieve the name of players that never played any match
SELECT name
  FROM player 
	WHERE id NOT IN
      (SELECT DISTINCT player_id
      FROM match_player);
      
-- (version with LEFT JOIN, even if not required)
SELECT name
  FROM player LEFT JOIN match_player ON player.id = match_player.player_id
	WHERE id NOT IN
      (SELECT DISTINCT player_id
      FROM match_player);

-- the previous query has an empty set of results. Delete a player to create a record in the result
DELETE FROM match_player WHERE player_id = 101042;

-- retrieve the record of matches where the home team won and the average home odds of that match were higher than average draw and away odds
SELECT id, home_team_goal, away_team_goal
  FROM match
  WHERE home_team_goal > away_team_goal AND id IN 
    (SELECT match_id
      FROM bet
        GROUP BY match_id
          HAVING (avg(home_odds) > avg(draw_odds)) AND (avg(home_odds) > avg(away_odds)));
          
-- retrieve the player name that played the highest number of matches
SELECT player_id, name, count(DISTINCT match_id) AS "played matches"
  FROM match_player INNER JOIN player ON match_player.player_id = player.id
    GROUP BY player_id, name
      HAVING count(DISTINCT match_id) >= ALL (
        SELECT count(DISTINCT match_id)
          FROM match_player
            GROUP BY player_id);
