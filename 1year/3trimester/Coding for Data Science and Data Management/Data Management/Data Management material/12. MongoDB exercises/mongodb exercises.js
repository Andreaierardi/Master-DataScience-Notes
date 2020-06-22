/* query the "bets" collection when not diversely specified */

/* retrieve the matches played in France Ligue 1*/
db.bets.find({ 
	"league": 'France Ligue 1' 
}).pretty()

/* count the number of documents in the result */
db.bets.find({ 
	"league": 'France Ligue 1' 
}).count()

/* retrieve the matches played in France Ligue 1 by FC Nantes as home team */
db.bets.find({ 
	"league": 'France Ligue 1', 
	"home_team_name": 'FC Nantes' 
})
	
/* the same query as the previous one with the use of regular expression for matching the name of the Nantes team */
db.bets.find({ 
	"league": 'France Ligue 1', 
	"home_team_name": /.*Nantes.*/ 
})

/* retrieve the matches played in France Ligue 1 by Nantes */
db.bets.find({ 
	"league": 'France Ligue 1', 
	"$or": [
		{ "home_team_name": /.*Nantes.*/ }, 
		{ "away_team_name": /.*Nantes.*/ }
	]
})

/* retrieve the matches played in France Ligue 1 by Nantes in 2008 */
db.bets.find({ 
	"league": 'France Ligue 1', 
	"$and": [
		{ "match_date": { "$gte": new ISODate('2008-01-01') } }, 
		{ "match_date": { "$lte": new ISODate('2008-31-12') } }
	],
	"$or": [
		{ "home_team_name": /.*Nantes.*/ }, 
		{ "away_team_name": /.*Nantes.*/ }
	]
})

/* retrieve the matches played in France Ligue 1 by FC Nantes and AJ Auxerre */
db.bets.find({ 
	"league": 'France Ligue 1', 
	"$or": [
		{ "home_team_name": {"$in": ['FC Nantes','AJ Auxerre']} }, 
		{ "away_team_name": {"$in": ['FC Nantes','AJ Auxerre']} }
	] 
})

/* retrieve the matches played in France Ligue 1 by FC Nantes that have been quoted by Bet365  */
db.bets.find({ 
	"league": 'France Ligue 1', 
	"bet.Bet365": { '$exists': true } , 
	"$or": [
		{ "home_team_name": /.*Nantes.*/ }, 
		{ "away_team_name": /.*Nantes.*/ }
	]
})

/* retrieve the matches played in France Ligue 1 by FC Nantes that have been quoted by Bet365  and return only the team names and the result */
db.bets.find({ 
	"league": 'France Ligue 1', 
	"bet.Bet365": { '$exists': true }, 
	"$or": [
		{ "home_team_name": /.*Nantes.*/ }, 
		{ "away_team_name": /.*Nantes.*/ }
	]
}, {
	"_id": 0, 
	"home_team_name": 1, 
	"away_team_name": 1, 
	"home_team_goal": 1, 
	"away_team_goal": 1
})

/* retrieve the matches played in France Ligue 1 by FC Nantes that have been quoted by Bet365  and return only the team names and the result and sort the result by match date */
db.bets.find({ 
	"league": 'France Ligue 1', 
	"bet.Bet365": { "$exists": true }, 
	"$or": [
		{ "home_team_name": /.*Nantes.*/ }, 
		{ "away_team_name": /.*Nantes.*/ }
	]
}, { 
	"_id": 0, 
	"home_team_name": 1, 
	"away_team_name": 1, 
	"home_team_goal": 1, 
	"away_team_goal": 1 
}).sort({ "match_date": 1 })

/* retrieve the matches played in France Ligue 1 by FC Nantes as home team where the quotation of Bet365 for Nantes as the winner is higher than 3 */
db.bets.find({ 
	"league": 'France Ligue 1', 
	"home_team_name": /.*Nantes.*/, 
	"bet.Bet365.H": { "$gt": 3 } 
}, 
{ 
	"_id": 0, 
	"home_team_name": 1, 
	"away_team_name": 1, 
	"bet.Bet365.H": 1
}).sort({ "match_date": 1 })

/* retrieve the matches played in France Ligue 1 by FC Nantes as home team where the quotation of Bet365 for Nantes as the winner is higher than the away_team as the winner */
/* see the use of $expr operator for comparing the value of two property values:
https://docs.mongodb.com/manual/reference/operator/query/expr/ */
db.bets.find({ 
	"league": 'France Ligue 1', 
	"home_team_name": /.*Nantes.*/, 
	"$expr": { "$gt": ["$bet.Bet365.H", "$bet.Bet365.A"] } }, 
{ 
	"_id": 0, 
	"home_team_name": 1, 
	"away_team_name": 1, 
	"bet.Bet365.H": 1, 
	"bet.Bet365.A": 1
}).sort({ "match_date": 1 })

/* retrieve the matches played in France Ligue 1 by FC Nantes as home team where the quotation of Bet365 for Nantes as the winner is highest among the available quotations */
db.bets.find({ 
	"league": 'France Ligue 1', 
	"home_team_name": /.*Nantes.*/, 
	"$and": [
		{ "$expr": { "$gt": ["$bet.Bet365.H", "$bet.Bet365.A"] } }, 
		{ "$expr": { "$gt": ["$bet.Bet365.H", "$bet.Bet365.D"] } }
	] 
}, { 
	"_id": 0, 
	"home_team_name": 1, 
	"away_team_name": 1, 
	"bet.Bet365.H": 1, 
	"bet.Bet365.D": 1, 
	"bet.Bet365.A": 1
}).sort({ "match_date": 1 })

/* retrieve the team (names) for which home Bet365 odds are better than away odds in the Italian football league */
db.bets.find({ 
	"league": "Italy Serie A",
	"$expr": { "$gt": ["$bet.Bet365.H", "$bet.Bet365.A"] } 
}, {
	'home_team_name': 1, 
	'away_team_name': 1, 
	'_id': 0
})

/* retrieve the matches where the home team scored more than 3 goals (rosters collection) */
db.rosters.find({
	"outcome.0": { "$gt": 3 } 
}, {
	"_id": 0, 
	"match_date": 1, 
	"outcome": 1 
})


/* retrieve the matches won by the home team */
db.bets.find(
	{"$expr": { "$gt": [ "$home_team_goal", "$away_team_goal" ] } }, 
	{
	"_id": 0, 
	"match_date": 1, 
	"home_team_goal": 1,
	"away_team_goal": 1 
})

/* retrieve the matches of 2008 as well as the quotations of Bet365 for those matches */
db.bets.aggregate([
	{ "$project": { "_id": 0, "bet.Bet365": 1, "match_date": 1, "match_year": { "$year": "$match_date" } } },
	{ "$match": { "bet.Bet365": { "$exists": true }, "match_year": 2008 } }
])

/* retrieve the number of matches played in the Serie A for each available year */
db.bets.aggregate( [ 
	{ "$match": {"league": "Italy Serie A"} },
	{ "$project": {"_id": 0, 
                   "year": {"$year": "$match_date"}
                 } },
    {"$group": {"_id": "$year", "matches": {"$sum": 1} } },
    {"$sort": {"_id": 1} }
] )

/* retrieve the sum of goals scored in 2009 in the Serie A */
db.bets.aggregate( [ 
	{ "$project": {"_id": 0,
				   "league": 1, 
                   "year": {"$year": "$match_date"},
                   "match_goals": {"$sum": ["$home_team_goal", "$away_team_goal" ] } } },
	{ "$match": {
	"league": 'Italy Serie A',
	"year": 2009 } },
    {"$group": {"_id": "$year", "goals": {"$sum": "$match_goals" } } }, 
] )

/* retrieve league that scored more than 1000 goals in a year */
db.bets.aggregate( [ 
	{ "$project": {"_id": 0,
				   "league": 1, 
                   "year": {"$year": "$match_date"},
                   "match_goals": {"$sum": ["$home_team_goal", "$away_team_goal" ] } } },
	{ "$match": {
	"league": 'Italy Serie A' } },
    {"$group": {"_id": "$year", "goals": {"$sum": "$match_goals" } } },  
    { "$match": {"goals": { "$gt": 1000 } } }
] )

/* retrieve the number of home matches played by each player in each year (rosters collection, use of $unwind) */
db.rosters.aggregate( [ 
	{ "$project": {"_id": 0, 
				   "home": 1,
                   "year": {"$year": "$match_date"}
                 } },
    {'$unwind': '$home'},
    {"$group": {"_id": {"year": "$year", "player": "$home.name"}, "matches": {"$sum": 1} } }, 
] )