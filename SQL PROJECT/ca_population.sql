CREATE SCHEMA ca_population;

USE ca_population;

CREATE TABLE pop_proj(
	county_code VARCHAR(45) NOT NULL,
    county_name VARCHAR(45) NOT NULL,
    date_year INT NOT NULL,
    race_code INT NOT NULL,
    race TEXT NOT NULL,
    gender VARCHAR(6) NOT NULL,
    age INT NOT NULL,
    population INT NOT NULL
);

/* Load Data */
/* ignore first header line, delimiter setting, etc*/
LOAD DATA LOCAL INFILE 'C:\\Users\\User\\CA_DRU_proj_2010-2060.csv'
INTO TABLE pop_proj
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

/* check the loaded data */
SELECT * FROM pop_proj
LIMIT 10;




/* To increase performance, index on county name */
CREATE INDEX county_name
ON pop_proj(county_name);

/* Inital list of male and female populations per county for 2014 */
SELECT county_name, gender, SUM(population) As total_population
FROM pop_proj
WHERE date_year = 2014
GROUP BY county_name, gender
ORDER BY county_name;

/* return information in specially formatted table */
/* list of male and female populations per county for 2014 */
SELECT p.county_name, 
	SUM(p.population) AS Male, 
    female_pop.Female FROM 
		(SELECT county_name, SUM(population) AS Female
		FROM pop_proj
		WHERE date_year = 2014 and gender = 'Female'
		GROUP BY county_name
		ORDER BY county_name) AS female_pop
JOIN pop_proj p
ON p.county_name = female_pop.county_name
WHERE p.date_year = 2014 AND p.gender = 'Male'
GROUP BY p.county_name
ORDER BY p.county_name;