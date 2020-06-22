/* mongodb operators to study:
-- $eq, $ne, $gt, $gte, $lt, $lte
-- $and, $or, 
-- $exists, $in, $nin
-- $expr

mongodb functions to study:
-- pretty()
-- count()
-- sort()
*/

/* insert example */
db.business.insert({
	"id": "dsdlillas",
	"name": "pizza seller", 
	"city": "Milan",
	"country": "Italy",
	"reviews": [
		{
			"reviewer_id": "skdljf",
			"reviewer_name": "John",
			"yelp_since": new Date("2016-11-02"),
			"review_score": 3
		}
	]
});


/* insert example with different structure */
db.business.insert({
	"code": "dsdlillas",
	"name": "pizza seller", 
	"place": "Milan, Italy",
	"review": 
		{
			"reviewer_id": "skdljf",
			"reviewer_name": "John",
			"yelp_since": new Date("2016-11-02"),
			"review_score": 1
		},
	"review": 
		{
			"reviewer_id": "ksdhg",
			"reviewer_name": "Edward",
			"yelp_since": new Date("2015-05-01"),
			"review_score": 2
		},	
});


/* delete a document according to the object id */
db.business.deleteOne(
{
	"_id": ObjectId("the id of the object to delete")
});


/* retrieve the businesses placed in Las Vegas */
db.business.find(
{
	"city": "Las Vegas"
}).pretty();


/* retrieve the number of businesses placed in Las Vegas */
db.business.find(
{
	"city": "Las Vegas"
}).count();


/* retrieve the businesses placed in Las Vegas (NV)*/
db.business.find(
{
	"city": "Las Vegas",
	"country": "NV"
});


/* retrieve the name of businesses placed in Las Vegas (NV) with evaluation higher than 4 stars */
db.business.find(
{
	"city": "Las Vegas",
	"country": "NV",
	"stars": { "$gt": 4}
}, 
{
	"_id": 0, 
	"name": 1
});


/* retrieve name, city, country of businesses with name about pizza */
db.business.find(
{
	"name": /.*pizza.*/i 
}, 
{
	"_id": 0, 
	"name": 1,
	"city": 1,
	"country": 1,
});


/* retrieve name, city, country of businesses that are rated between 1 and 2 */
db.business.find(
{
	"stars": {
		"$gte": 1,
		"$lte": 2
	}
}, 
{
	"_id": 0, 
	"name": 1,
	"city": 1,
	"country": 1,
	"stars": 1
});


db.business.find(
{
	"$and": [
		{ "stars": { "$gte": 1} },
		{ "stars": { "$lte": 2} }
	]
}, 
{
	"_id": 0, 
	"name": 1,
	"city": 1,
	"country": 1,
	"stars": 1
});


/* retrieve name, city, country of businesses placed in Nevada (NV) or Arizona (AZ) that are rated between 1 and 2 */
db.business.find(
{
	"stars": {
		"$gte": 1,
		"$lte": 2
	},
	"$or": [
		{ "country": "NV" },
		{ "country": "AZ" }
	]
}, 
{
	"_id": 0, 
	"name": 1,
	"city": 1,
	"country": 1,
	"stars": 1
});


/* retrieve the name of businesses that have been reviewed on Nov 1st 2013 and sort the result by name */
db.business.find(
{
	"reviews.review_date": new Date("2013-11-01")
}, 
{
	"_id": 0, 
	"name": 1,
	"reviews.review_date": 1
}).sort({ "name": 1 });


/* retrieve the name of businesses that have been reviewed with 5 stars on Nov 1st 2013 and sort the result by name in descending order */
db.business.find(
{
	"$and": [
		{ "reviews.review_date": new Date("2013-11-01") },
		{ "reviews.review_score": 5 }
	]
}, 
{
	"_id": 0, 
	"name": 1,
	"reviews.review_date": 1,
	"reviews.review_score": 1
}).sort({ "name": -1 });


/* retrieve the businesses that are categorized as "Restaurants" */
/* as a further exercise, retrieve the businesses that are NOT categorized as "Restaurants" */
db.business.find(
{
	"categories": { "$in": [ 'Restaurants' ] }
}, 
{
	"_id": 0, 
	"name": 1,
	"categories": 1
});


/* retrieve the businesses that have not received any review */
db.business.find(
{
	"reviews": { "$exists": false }
}).pretty();
