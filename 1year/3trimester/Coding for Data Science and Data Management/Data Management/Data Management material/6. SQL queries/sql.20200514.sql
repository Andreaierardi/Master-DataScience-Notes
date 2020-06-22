-- retrieve the name of categories that are not associated to any business
-- HINT: use the LEFT JOIN operation (see slide n.44 of SQL slides)


-- HINT: this query can be solved also through the use of the EXCEPT operation:
SELECT name 
FROM category
EXCEPT
SELECT DISTINCT category
FROM incat;

-- HINT: this query can be solved also through a nested query:
SELECT name
FROM category
WHERE name NOT IN
(SELECT DISTINCT category
FROM incat);


-- retrieve the name of reviewers that are friend
-- HINT: use the TABLE ALIAS (see slide n.50 of SQL slides)
SELECT r1.name AS "reviewer name", 
r2.name AS "friend of the reviewer"
FROM friend INNER JOIN reviewer r1 ON reviewer_a = r1.id INNER JOIN reviewer AS r2 ON reviewer_b = r2.id;


-- retrieve the name of reviewers registered to yelp later than 'Alien' (name of a reviewer)
-- HINT: use the TABLE ALIAS (see slide n.50 of SQL slides)
SELECT r1.name, r1.yelp_since
FROM reviewer r1 INNER JOIN reviewer r2 ON r1.yelp_since > r2.yelp_since
WHERE r2.name = 'Alien'
ORDER BY r1.yelp_since;

-- alternative syntax:
SELECT r1.name, r1.yelp_since
FROM reviewer r1, reviewer r2 
WHERE (r2.name = 'Alien') AND (r1.yelp_since > r2.yelp_since)
ORDER BY r1.yelp_since;


-- retrieve the name of reviewers registered to yelp 
-- later than ALL the reviewers named 'Alien' 
SELECT name, yelp_since
FROM reviewer
WHERE yelp_since > 
(SELECT max(yelp_since) 
FROM reviewer
WHERE name = 'Alien');

-- please, solve this query through the use of join operations (without a nested query)


-- retrieve the overall number of available categories
SELECT count(*) AS "number of categories"
FROM category;


-- retrieve the number of categories used by at least one business
SELECT count(DISTINCT category)
FROM incat;


-- for each business, retrieve the number of associated reviews and the max number of stars received in a review
SELECT business, count(*) AS "number of reviews", 
       max(stars) AS "max stars"
FROM review
GROUP BY business;


-- for each business categorized as "Food", retrieve the number of reviews with less than 3 stars
SELECT business.id, business.name, count(*)
FROM review INNER JOIN business ON review.business = business.id
INNER JOIN incat ON business.id = incat.business
WHERE category = 'Food' AND review.stars < 3
GROUP BY business.id, business.name;


-- for each reviewer, retrieve the number of performed reviews. Return also the name of the reviewer in the result
SELECT reviewer.id, reviewer.name, count(*)
FROM review INNER JOIN reviewer ON review.reviewer = reviewer.id
GROUP BY reviewer.id;


-- for each category, retrieve the number of associated businesses


-- retrieve the businesses with more than 5 services offered


-- retrieve the name of reviewers that performed more than 10 reviews with at least 3 stars
SELECT reviewer.id, reviewer.name, count(*)
FROM review INNER JOIN reviewer ON review.reviewer = reviewer.id
WHERE stars >= 3
GROUP BY reviewer.id
HAVING count(*) > 10;


-- retrieve the name of reviewers that are unique in the database 
-- HINT: reviewers with unique name are those that have a group with just one record according to the name attribute




