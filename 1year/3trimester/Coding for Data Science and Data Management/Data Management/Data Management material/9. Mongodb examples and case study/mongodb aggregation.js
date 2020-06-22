/* mongodb operators to study (aggregation framework):
-- $project
-- $match 
-- $group
-- $sum
-- $sort
-- $unwind

*/

/* retrieve the number of businesses in Nevada */
db.business.find(
{
	"country": "NV"
}, 
{
	"_id": 0, 
	"name": 1,
	"city": 1,
	"country": 1,
}).count();

db.business.aggregate( [
	{ "$match": { "country": "NV" } },
	{ "$group": { "_id": "$country", "businesses": {"$sum": 1} } }
] );


/* retrieve the number of businesses for each country */
/* the '$' before a field name indicates that the value of this field from incoming document will be considered in the operation. In this example, $country means group by the values of the country field. */
db.business.aggregate( [ 
    {"$group": {"_id": {"country": "$country"}, "businesses": {"$sum": 1} } },
    {"$sort": {"_id": 1} }
] );

/* in the previous example, to retrieve just the count for Nevada: */
/* note: this requires to compute the count for all the groups and to filter the result. For efficiency, it is better to match before the $group operator */
db.business.aggregate( [ 
    {"$group": {"_id": {"country": "$country"}, "businesses": {"$sum": 1} } },
    {"$match": { "_id": "NV" } }
] );


/* retrieve the average number of stars for businesses of each country */
db.business.aggregate( [ 
    {"$group": {"_id": {"country": "$country"}, "Average number of businesses": {"$avg": "$stars" } } },
    {"$sort": {"_id": 1} }
] );


/* retrieve the number of reviews for each business in Nevada */
db.business.aggregate( [
	{ "$match": { "country": "NV" } },
	{ "$project": { "_id": 0, "Business name": 1, "Number of reviews": { "$size": "$reviews" } } }
]);


/* retrieve the average number of businesses per country */
db.business.aggregate( [ 
	{"$group": {"_id": {"country": "$country"}, "businesses": {"$sum": 1} } },
    {"$group": {"_id": 1, "Average number of businesses": {"$avg": "$businesses"} } }
] );


/* retrieve the businesses that have been reviewed in Nov 2013 */
/* this is a wrong solution */
db.business.find(
{
	"$and": [
		{ "reviews.review_date": { "$gte": new Date("2013-11-01")} },
		{ "reviews.review_date": { "$lte": new Date("2013-11-30")} },
	]
});


/* this is a correct solution */
db.business.aggregate([
	{ "$unwind": "$reviews" },
	{ "$match": { "$and": [
		{ "reviews.review_date": { "$gte": new Date("2013-11-01")} },
		{ "reviews.review_date": { "$lte": new Date("2013-11-30")} },
		] } 
	},
	{ "$project": { "_id": 0, "name": 1, "reviews.review_date": 1 } }
]);


/* retrieve the average number of stars of each business according to the received reviews */
db.business.aggregate([
	{ "$unwind": "$reviews" },
	{ "$group": { "_id": {"id": "$_id", "name": "$name"}, "average stars per business": { "$avg": "$reviews.review_score" } } }
]);


/* retrieve the number of reviews provided by any reviewer */
db.business.aggregate([
	{ "$unwind": "$reviews" },
	{ "$group": { "_id": "$reviews.reviewer_id", "Number of reviews": { "$sum": 1 } } }
]);


/* retrieve the reviewers that provided more than 10 reviews */
db.business.aggregate([
	{ "$unwind": "$reviews" },
	{ "$group": { "_id": "$reviews.reviewer_id", "Number of reviews": { "$sum": 1 } } },
	{ "$match": { "Number of reviewers": { "$gt": 10 } } }
]);


/* retrieve the whole number of reviews provided in 2013 */
db.business.aggregate([
	{ "$unwind": "$reviews" },
	{ "$project": {"_id": 0, 
                   "year": {"$year": "$reviews.review_date"}
                 } },
    { "$match": { "year": 2013 } },
	{ "$group": { "_id": "$year", "Number of reviews": { "$sum": 1 } } }
]);

	
/* retrieve the whole number of reviews year by year */
db.business.aggregate([
	{ "$unwind": "$reviews" },
	{ "$project": {"_id": 0, 
                   "year": {"$year": "$reviews.review_date"}
                 } },
	{ "$group": { "_id": "$year", "Number of reviews": { "$sum": 1 } } },
	{ "$sort": { "_id": 1 } }
]);
