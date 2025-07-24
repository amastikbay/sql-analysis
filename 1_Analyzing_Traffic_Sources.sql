--Traffic source analysis is about understanding where your customers are coming from and which channels are driving the highest quality traffic.

--Task1: 
--1(a) Breakdown of sessions by UTM source, campaign and referring domain and 
--1(b) Filter results up to sessions up to today so before '2012-04-12' and group results by utm_source, utm_campaign and http_referer

-- #1. Finding Top Traffic Source
SELECT 
	utm_source,
	utm_campaign,
	http_referer,
	COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions
WHERE created_at < '2012-04-12'
GROUP BY utm_source, utm_campaign, http_referer
ORDER BY sessions DESC

--Task2: 
--2(a) Calculate CVR from session(COUNT) to order(COUNT). If CVR < 4% need to reduce bids, otherwise if CVR >= 4% can increase bids to drive more volume
--2(b) Filter sessions < '2012-04-12', utm_source = 'gsearch' and utm_campaign = 'nonbrand'

-- #2. Traffic Conversion Rate
SELECT
	COUNT(DISTINCT w.website_session_id) AS sessions,
	COUNT(DISTINCT o.order_id) AS orders,
	COUNT(DISTINCT o.order_id)/COUNT(DISTINCT w.website_session_id) AS session_to_order_CVR
FROM website_sessions w
	LEFT JOIN orders o
		ON o.website_session_id = w.website_session_id
WHERE w.created_at < '2012-04-14'
	AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'

--Task3: 
--3(a) Calculate trend and impact on sessions for gsearch nonbrand campaign after bidding down on Apr 15, 2021, but also asking the session before bidding for comparision
--3(b) Filter to < '2012-05-10', utm_source = 'gsearch', utm_campaign = 'nonbrand'

-- 3. Traffic Source Trending
SELECT
	MIN(DATE(created_at)) AS week_start_date,
	COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions 
WHERE created_at < '2012-05-10'
	AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
GROUP BY YEAR(created_at), WEEK(created_at)

--Task4: 
--4 Calculate the conversion rate from session to order by device type

-- 4. Traffic Source Bid Optimization
SELECT
	w.device_type,
	COUNT(DISTINCT w.website_session_id) AS sessions,
	COUNT(DISTINCT o.order_id) AS orders,
	COUNT(DISTINCT o.order_id)/COUNT(DISTINCT w.website_session_id) AS session_to_order_CVR
FROM website_sessions w
	LEFT JOIN orders o
		ON o.website_session_id = w.website_session_id
WHERE w.created_at < '2012-05-11'
	AND w.utm_source = 'gsearch'
	AND w.utm_campaign = 'nonbrand'
GROUP BY w.device_type
ORDER BY session_to_order_CVR DESC

--Task5: 
--5(a) Calculate (with pivot) weekly session trends for both desktop and mobile after bidding up on the desktop channel on 2012-05-19
--5(b) Filter to between '2012-04-15' to '2012-06-19', utm_source = 'gsearch', utm_campaign = 'nonbrand'

-- 5. Traffic Source Segment Trending
SELECT
	MIN(DATE(created_at)) AS week_start_date,
	COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN website_session_id ELSE NULL END) AS dtop_session,
	COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) AS mob_session
FROM website_sessions
WHERE created_at < '2012-06-09'
	AND created_at > '2012-04-15'
	AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
GROUP BY YEAR(created_at), WEEK(created_at)
