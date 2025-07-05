use project1

-- Q1: What is the profit percentage for each month across all years?

SELECT 
arrival_date_year,
arrival_date_month,
 ROUND(
  100* SUM(
     (adr * (1-S.Discount) *(stays_in_weekend_nights + stays_in_week_nights)) + M.cost) 
	 / (
      SELECT 
        SUM(
          (adr * (stays_in_weekend_nights + stays_in_week_nights)) + MC2.cost)
      FROM HOTEL H2
      LEFT JOIN meal_cost MC2 ON H2.meal = MC2.meal), 2) AS revenue_percentage
FROM HOTEL H
LEFT JOIN meal_cost M ON H.meal = M.meal
LEFT JOIN market_segment S ON H.market_segment = S.market_segment
GROUP BY arrival_date_year, arrival_date_month
ORDER BY arrival_date_year, arrival_date_month;

-- Q2: Which meals and market segments (e.g., families, corporate clients, etc.) contribute the most to the total revenue for each hotel annually?
SELECT distinct meal,(adults+children+babies) as family,
    market_segment  , 
    ROUND(SUM((stays_in_weekend_nights + stays_in_week_nights) * adr), 0) AS revenue
FROM 
    hotels
 GROUP BY 

    market_segment,meal,adults,children,babies
ORDER  by  revenue desc
-- Q3: How does revenue compare between public holidays and regular days each year?
SELECT 
arrival_date_year,
 ROUND(
   SUM(
     adr * (1-S.Discount) * stays_in_week_nights + M.cost),2)  AS stays_in_week_nights
	 ,ROUND(
   SUM(
     adr * (1-S.Discount) * stays_in_weekend_nights + M.cost),2)  AS stays_in_weekend_nights

FROM HOTEL H
LEFT JOIN meal_cost M ON H.meal = M.meal
LEFT JOIN market_segment S ON H.market_segment = S.market_segment
GROUP BY arrival_date_year;

-- Q4: What are the key factors (e.g., hotel type, market type, meals offered, number of nights booked) significantly impact hotel revenue annually?
SELECT hotel,meal  ,(stays_in_weekend_nights + stays_in_week_nights) as total_night_booked ,
    market_segment  ,
    ROUND(SUM((stays_in_weekend_nights + stays_in_week_nights) * adr), 0) AS revenue
FROM 
    hotels
GROUP BY 
    market_segment,meal,hotel,stays_in_weekend_nights,stays_in_week_nights
ORDER BY 
    revenue DESC
	-- Q5: Based on stay data, what are the yearly trends in customer preferences for room types (e.g., family rooms vs. single rooms), and how do these preferences influence revenue?

	select sum(stays_in_weekend_nights +stays_in_week_nights) as revenue,arrival_date_year as year,
    reserved_room_type
	from hotels
		group by arrival_date_year,reserved_room_type
	order by year ,revenue desc




---new q1 Average price and meal price depending on the type of hotel and meal--
SELECT 
    h.hotel AS hotel,
    h.meal AS meal,
    ROUND(avg(h.adr), 0) AS cost,
    ROUND(avg(m.Cost), 0) AS meal_cost
FROM 
    hotels h
JOIN 
    meal_cost m ON h.meal = m.meal
GROUP BY 
    h.hotel, h.meal
ORDER BY 
    hotel, cost DESC;


	--q2 Total revenue by customer type and all reserved
SELECT 
    customer_type AS customer_type,
    COUNT(*) AS reserved,
    ROUND(SUM((stays_in_weekend_nights + stays_in_week_nights) * adr), 0) AS total_revenue
FROM 
    hotels
GROUP BY 
    customer_type
ORDER BY 
    total_revenue DESC;



	--- q3 All revenue for each hotel
	SELECT 
    arrival_date_year AS year,
    hotel AS hotel_type,
    ROUND(SUM((stays_in_weekend_nights + stays_in_week_nights) * adr), 0) AS revenues
FROM 
    hotels
GROUP BY 
    arrival_date_year, hotel
ORDER BY 
    year, revenues DESC;



	--q4 top 5 month of revenue
	SELECT top 5
    arrival_date_month ,
    ROUND(SUM((stays_in_weekend_nights + stays_in_week_nights) * adr), 0) AS total_revenue
FROM 
    hotels
GROUP BY 
    arrival_date_month
ORDER BY 
    total_revenue DESc


	--q5 Most requested meals with their cost
	SELECT 
    h.meal AS meal,
    m.Cost AS meal_cost,
    COUNT(*) AS all_reserved
FROM 
    hotels h
JOIN 
    meal_cost m ON h.meal = m.meal
GROUP BY 
    h.meal, m.Cost
ORDER BY 
    all_reserved DESC;


















