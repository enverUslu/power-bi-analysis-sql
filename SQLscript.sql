-- I have developed this project as a demonstration of my proficient SQL skills,
-- to serve as a valuable addition to my professional portfolio.
-- github.com/enverUslu


-- Retrieve top 10 games by global sales / note: Games in this dataset were already 
-- listed by their global sales yet I included the script as if it wasn't the case.
SELECT
    "Name",
    "Platform",
    "Year_of_release",
    "Genre",
    "Publisher",
    "Global_Sales"
FROM
    videoGameSales0
ORDER BY
    "Global_Sales" DESC
LIMIT 10;

-- Check distinct values in the "Publisher" column
SELECT DISTINCT "Publisher" 
FROM videoGameSales0;

-- Retrieve games with the highest critic scores
SELECT
    "Name",
    "Platform",
    TRIM("Critic_Score") AS "Critic_Score"
FROM
    videoGameSales0
WHERE
    "Critic_Score" IS NOT NULL
GROUP BY
    "Name",
    "Critic_Score"
ORDER BY
    "Critic_Score" DESC
LIMIT 10;

-- Retrieve games with the highest user scores
SELECT
    "Name",
    "Platform",
    TRIM("User_Score") AS "User_Score"
FROM
    videoGameSales0
WHERE
    "User_Score" IS NOT NULL
GROUP BY
    "Name",
    "User_Score"
ORDER BY
    "User_Score" DESC
LIMIT 10;

-- Retrieve publishers with the most games released
SELECT
    "Publisher",
    COUNT(*) AS game_count
FROM
    videoGameSales0
GROUP BY
    "Publisher"
ORDER BY
    game_count DESC
LIMIT 10;

-- Retrieve games by genre and their corresponding sales
SELECT
    "Genre",
    SUM("NA_Sales") AS total_na_sales,
    SUM("EU_Sales") AS total_eu_sales,
    SUM("JP_Sales") AS total_jp_sales,
    SUM("Other_Sales") AS total_other_sales,
    SUM("Global_Sales") AS total_global_sales
FROM
    videoGameSales0
GROUP BY
    "Genre";

-- Retrieve games released by year and their corresponding sales
SELECT
    "Year_of_release",
    COUNT(*) AS game_count,
    SUM("Global_Sales") AS total_global_sales
FROM
    videoGameSales0
GROUP BY
    "Year_of_release"
ORDER BY
    Year_of_Release ;

-- Retrieve games by rating and their corresponding sales
SELECT
    "Rating",
    COUNT(*) AS game_count,
    SUM("Global_Sales") AS total_global_sales
FROM
    videoGameSales0
GROUP BY
    "Rating";
   
-- Modify the unknown developer data as 'Unknown'
UPDATE videoGameSales0 
SET 
	Developer = "Unknown"
WHERE 
  	Developer IS NULL
	OR Developer IS '';

-- Calculate the total sales by platform and sort them in descending order
SELECT
    Platform,
    SUM(Global_Sales) AS total_sales
FROM
    videoGameSales0
GROUP BY
    Platform
ORDER BY
    total_sales DESC;
   
-- Identify the most popular genres based on total sales
SELECT
    Genre,
    SUM(Global_Sales) AS total_sales
FROM
    videoGameSales0
GROUP BY
    Genre
ORDER BY
    total_sales DESC;
   
--Retrieve games published by a publisher (in this case,Nintendo) and their sales by region
SELECT
    Name,
    NA_Sales,
    EU_Sales,
    JP_Sales,
    Other_Sales,
    Global_Sales
FROM
    videoGameSales0
WHERE
    Publisher = 'Nintendo';
   
-- Calculate the total sales percentage contribution of each region to the global sales
SELECT
    (SUM(NA_Sales) / SUM(Global_Sales)) * 100 AS NA_Sales_Percentage,
    (SUM(EU_Sales) / SUM(Global_Sales)) * 100 AS EU_Sales_Percentage,
    (SUM(JP_Sales) / SUM(Global_Sales)) * 100 AS JP_Sales_Percentage,
    (SUM(Other_Sales) / SUM(Global_Sales)) * 100 AS Other_Sales_Percentage
FROM
    videoGameSales0;
  
-- Calculate the cumulative global sales by year
SELECT
    Year_of_Release,
    SUM(Global_Sales) OVER (ORDER BY Year_of_Release ASC) AS cumulative_sales
FROM
    videoGameSales0
GROUP BY
    Year_of_Release
ORDER BY
    Year_of_Release;

-- Retrieve the names of titles with the highest sales in each region
WITH ranked_sales AS (
    SELECT
        Name,
        NA_Sales,
        EU_Sales,
        JP_Sales,
        Other_Sales,
        Global_Sales,
        ROW_NUMBER() OVER (ORDER BY NA_Sales DESC) AS rn_na,
        ROW_NUMBER() OVER (ORDER BY EU_Sales DESC) AS rn_eu,
        ROW_NUMBER() OVER (ORDER BY JP_Sales DESC) AS rn_jp,
        ROW_NUMBER() OVER (ORDER BY Other_Sales DESC) AS rn_other
    FROM
        videoGameSales0
)
SELECT
    Name,
    NA_Sales,
    EU_Sales,
    JP_Sales,
    Other_Sales,
    Global_Sales
FROM
    ranked_sales
WHERE
    rn_na = 1
    OR rn_eu = 1
    OR rn_jp = 1
    OR rn_other = 1;

-- Retrieve the top 10 developers with the highest average global sales per game, excluding games with low critic scores
SELECT
    Developer,
    (SUM(Global_Sales) / COUNT(*)) AS average_sales_per_game
FROM
    videoGameSales0
WHERE
    Critic_Score > 70
GROUP BY
    Developer
ORDER BY
    average_sales_per_game DESC
LIMIT 10;
--
