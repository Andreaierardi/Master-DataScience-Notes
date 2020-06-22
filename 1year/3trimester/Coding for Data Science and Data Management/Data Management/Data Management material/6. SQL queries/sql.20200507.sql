-- query examples

-- retrieve the name of reviewers registered from 2016
SELECT name
FROM reviewer
WHERE yelp_since >= '2016-01-01';

-- retrieve the name of reviewers with more than 10 reviews and average stars higher than 3
SELECT name, review_count, average_stars
FROM reviewer
WHERE (review_count > 10) AND (average_stars > 3);

-- retrieve the name of reviewers with less fans than reviews
SELECT name, fans, review_count
FROM reviewer
WHERE fans < review_count;

-- retrieve the name of businesses with at least 3 stars
SELECT name
FROM business 
WHERE stars >= 3;

-- retrieve name, city, country of businesses with at least 3 stars
SELECT business.name, city.name, country
FROM business INNER JOIN city ON business.city = city.id
WHERE stars >= 3

-- retrieve name, city of businesses in Nevada (NV) with at least 3 stars
SELECT business.name, city.name
FROM business INNER JOIN city ON business.city = city.id
WHERE (stars >= 3) AND (country = 'NV');

-- retrieve name, city of businesses in Nevada (NV) or Arizona (AZ) with at least 3 stars
SELECT business.name AS "business name", city.name AS city, stars, country
FROM business INNER JOIN city ON business.city = city.id
WHERE (stars >= 3) AND ((country = 'NV') OR (country = 'AZ'));

-- retrieve name, city of businesses in Nevada (NV) with at least 3 stars OR businesses in Arizona (AZ) with at least 4 stars
SELECT business.name AS "business name", city.name AS city, stars, country
FROM business INNER JOIN city ON business.city = city.id
WHERE ((stars >= 3) AND (country = 'NV')) OR 
((country = 'AZ') AND (stars >= 4));

-- retrieve the city names where businesses of Nevada 
-- with at least 3 stars are placed
SELECT DISTINCT city.name AS city
FROM business INNER JOIN city ON business.city = city.id
WHERE country = 'NV' AND stars >=3 ;

-- retrieve the features without a description
SELECT * 
FROM feature
WHERE description IS  NULL;

-- retrieve the name of businesses with corresponding services
SELECT id, name AS business, feature AS service
FROM business INNER JOIN services 
ON services.business = business.id
ORDER BY name;

-- retrieve the services of business with id = 't2GtB-aiOzrNnuGxZV190g'
SELECT name AS business, feature AS service
FROM business INNER JOIN services 
ON services.business = business.id
WHERE id = 't2GtB-aiOzrNnuGxZV190g'
ORDER BY name;

-- retrieve the name of businesses with corresponding services (including businesses without services)
SELECT id, name AS business, feature AS service
FROM business LEFT JOIN services 
ON services.business = business.id
ORDER BY name;

-- retrieve the data about businesses that are not associated with any service
SELECT id, name AS business
FROM business LEFT JOIN services 
ON services.business = business.id
WHERE feature IS NULL
ORDER BY name;

-- retrieve the businesses whose name is about Pizza
SELECT *
FROM business 
WHERE name like '%Pizza%';

-- retrieve the number of businesses about Pizza Hut
SELECT count(*)
FROM business 
WHERE name = 'Pizza Hut';

-- retrieve the overall amount of reviews given to all the Pizza Hut
SELECT sum(review_count)
FROM business 
WHERE name = 'Pizza Hut';

-- retrieve the stars of the worst/best Pizza Hut(lower/higher stars) 
SELECT MIN(stars)
FROM business 
WHERE name = 'Pizza Hut';

SELECT MAX(stars)
FROM business 
WHERE name = 'Pizza Hut';

-- retrieve the average stars of all the Pizza Hut
SELECT AVG(stars)
FROM business 
WHERE name = 'Pizza Hut';
