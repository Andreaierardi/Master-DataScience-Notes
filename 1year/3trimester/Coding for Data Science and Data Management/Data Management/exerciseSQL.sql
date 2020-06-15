/*EXERCISE lecture 15-06-2020 */

CREATE TABLE  stadium
(
  city varchar NOT NULL, /*To be sure we specify NOT NULL
                          but is implicity implemented
                          using primary key*/
  name varchar NOT NULL,
  country integer NOT NULL REFERENCES country(id) ON UPDATE CASCADE ON DELETE NO ACTION,
  /* what happen to stadium when we update the country?
     CASCADE, ON DELETE or NO ACTION
     since in this case there is not specification, we will leave NO ACTION
  */
  address varchar,
  capacity integer DEFAULT 10000 CHECK (capacity > 10000 ),
  PRIMARY KEY(name,city,country)

/* we need a vector since we need multiple teams in a stadium but in a RELATIONAL
   DB is incorrect. We need a table called team

   team vector(?)
  */

);

-- 1)
-- consider that a team has just one associated stadium_city
-- modify the structure of the team table
ALTER TABLE team ADD COLUMN stadium_name varchar;
ALTER TABLE team ADD COLUMN stadium_city varchar;
ALTER TABLE team ADD COLUMN stadium_country integer;
ALTER TABLE team ADD CONSTRAINT fk_stadium FOREIGN KEY (stadium_name, stadium_city, stadium_country)
REFERENCES stadium(name, city, country) ON UPDATE CASCADE ON DELETE NO ACTION;

ALTER TABLE team ADD COLUMN gallery varchar;

-- 2)
-- Consider that a team can have more than one associated stadium
-- We need to create a new table
CREATE TABLE team_stadium
(
  /*If team deleted the association with the stadium needs to be deleted*/
  team integer REFERENCES team(id) ON UPDATE CASCADE ON DELETE CASCADE,
  stadium_name varchar,
  stadium_city varchar,
  stadium_country integer,
  gallery varchar,
  FOREIGN KEY (stadium name,stadium_city, stadium_country)
  REFERENCES  stadium(name, city, country) ON UPDATE CASCADE ON DELETE NO ACTION,
  PRIMARY KEY(team, stadium_name, stadium_city, stadium_country)
);


-- ================ QUERIES EXERCISES =================
-- retrieve the league name and the
-- corresponding country name for Italy and France

-- league
-- id
-- country
-- name

/* We need to JOIN the league with country table*/
SELECT league.name AS "league name", league.country AS "country name"
FROM league INNER JOIN country ON country.id = league.country_id
WHERE country.name = "Italy" OR country.name = "France"


-- retrieve teams that have "Real" in their name
SELECT *
FROM team
WHERE team_long_name ilike "%real%"
-- ilike is insensitive (we do not know if is upper or lower case)



-- retrieve bets where away_odds are higher than home_odds
SELECT *
FROM bets
WHERE bets.away_odds > bets.home_odds


-- retrieve the bets where the draw_odds are not provided
SELECT *
FROM bets
WHERE draw_odds IS NULL
-- IS NOT NULL if we want to check NOT NULL

-- retrieve the total number of goals scored by Real Madrid
-- in hoem meatches in 2010/2011
SELECT SUM(home_team_goal)
FROM team INNER JOIN match ON match.home_team_id = team.id
WHERE team_long_name ilike "%real madrid%"
AND match.season = "2010/2011"
-- >> 61 is the result.
-- Real Madrid gives NULL since the real name of Real Madrid CF

-- ===== aggregate OPERATORS: SUM, MAX, MIN, AVG, COUNT



-- ===== group by
-- retrieve the average odds
-- for any match of Spain Liga of 2010/2011
SELECT match.id AS "match" AVG(home_odds) AS "home odds",
AVG(draw_odds) AS "draw odds",
AVG(away_odds) AS "away odds"
FROM match
INNER JOIN league ON match.league_id = league.id
INNER JOIN country ON country.id = league.country_id
INNER JOIN bet ON match.id = bet.match_id
WHERE country.name = "Spain" AND league.name = "Liga" AND match.season = "2010/2011"
GROUP BY match.id;


-- retrieve the average odds
-- for any match of Spain Liga of 2010/2011
-- where the average home_odds are higher than 0.5
SELECT match.id AS "match" AVG(home_odds) AS "home odds",
AVG(draw_odds) AS "draw odds",
AVG(away_odds) AS "away odds"
FROM match
INNER JOIN league ON match.league_id = league.id
INNER JOIN country ON country.id = league.country_id
INNER JOIN bet ON match.id = bet.match_id
WHERE country.name = "Spain" AND league.name = "Liga"
AND match.season = "2010/2011"
GROUP BY match.id
HAVING AVG(home_odds) > 0.5;
-- WHERE filter the record of the TABLE
-- HAVING filter record of the GROUP BY
