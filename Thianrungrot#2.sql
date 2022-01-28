-- QUESTION 1
-- In the customers table, group by country and contact_title fields 
-- where the contact_title field does not have the word 'sales' (CI) in it 
-- and return the count of items in the grouping as "total". 
-- Return groupings with a total greater than 2 
-- and sort the result by the country and contact_title fields descending.

SELECT country
		,contact_title
		,COUNT(contact_title) total
FROM customers
WHERE contact_title NOT ILIKE '%sales%' 
GROUP BY country, contact_title
HAVING COUNT(contact_title) > 2
ORDER BY country DESC, contact_title DESC;


-- QUESTION 2
-- In the order_details table, group on the order_id and discount fields. 
-- Compute the following: 
-- average of the quantity field as “avg_quantity” & round it to two decimal places; 
-- the sum of the unit_price field as “sum_price”, 
-- and the count of the number of items in the grouping as “total”. 
-- Filter on rows where the total field is greater than four and the discount is greater than zero. 
-- Sort by the total and discount fields both descending.

SELECT order_id
		,discount
		,ROUND(AVG(quantity),2) avg_quantity
		,sum(unit_price) sum_price
		,COUNT(order_id) total
FROM order_details
WHERE discount > 0
GROUP BY order_id, discount
HAVING COUNT(*) > 4
ORDER BY total DESC, discount DESC;


-- QUESTION 3
-- In the products table, write a query that achieves the following:
-- (1) Group by stock_order, which is a calculated field with the following condition based values: 
-- 		(a) when units_in_stock  field is greater than the units_on_order field, label it 'More Units in Stock'  
-- 		(b) when units_in_stock field is less than the units_on_order field, label it 'More Units on Order'  
-- 		(c) when units_in_stock field equals 0 and the units_on_order field equals 0, label it 'Increase Reorder level'  
-- 		(d) else label everything else as 'Other'
-- (2) The count per grouping as "total"
-- (3) The maximum amount of units_in_stock field as max_stock and the maximum amount of units_on_order field as max_order 
-- (4) Keep rows where the units_in_stock field plus the units_on_order field is less than or equal to the reorder_level
-- (5) Sort by total descending and limit to 2 results

SELECT  CASE
			WHEN units_in_stock > units_on_order THEN 'More Units in Stock'
			WHEN units_in_stock < units_on_order THEN 'More Units on Order'
			WHEN units_in_stock = units_on_order THEN 'Increase Reorder level'
			ELSE 'Other'
		 END stock_order
		,COUNT(*) total
		,MAX(units_in_stock) max_stock
		,MAX(units_on_order) max_order
FROM products
WHERE units_in_stock <= reorder_level
GROUP BY stock_order
ORDER BY total DESC
LIMIT 2;


-- QUESTION 4
-- In the employees table, group on the country, firstname and lastname field 
-- and return the count of the number items in each grouping. 
-- To derive the firstname and last name field, do the following:
-- 		(a) check and see if the last_name ends in an a, b, or c then label it 'A,B,C end' 
-- 			else label it ‘Other’. This is a case sensitive search.
-- 		(b) check and see if the firstname field starts with a,b, or c then label it 'A,B,C start’ 
-- 			else label it ‘Other’. This is a case sensitive search.
-- Sort by total descending and only return results where the grouping total is greater than one.

SELECT   CASE
			WHEN last_name LIKE ANY(ARRAY['%a', '%b', '%c']) THEN 'A,B,C end'
			ELSE 'Other'
		 END lastname
		,CASE
			WHEN first_name LIKE ANY(ARRAY['a%', 'b%', 'c%']) THEN 'A,B,C start'
			ELSE 'Other'
		 END firstname
		,country
		,COUNT(*) total
FROM employees
GROUP BY country, firstname, lastname
HAVING COUNT(*) > 1
ORDER BY total DESC;


-- QUESTION 5
-- In the orders table, group by ship_via, employee_id, ship_country fields, 
-- where the ship_via is less than the employee_id 
-- and (condtion 1) the ship_country does not end in the letter 'y' or 'L' (CI) or (condition 2) the employee_id is 4. 
-- For each grouping, return the count of the number of items as total and the average freight as avg_fr. 
-- Return groupings with avg_fr greater than 30, a total greater than 7, 
-- and sort the results by total descending.

SELECT	 ship_country
		,ship_via
		,employee_id
		,COUNT(*) total
		,AVG(freight) avg_fr
FROM orders
WHERE ship_via < employee_id
		AND ( 
			  ( NOT ship_country ILIKE ANY(ARRAY['%y', '%L']) ) 
			 	OR employee_id = 4 
			)
GROUP BY ship_via, employee_id, ship_country
HAVING AVG(freight) > 30 AND COUNT(*) > 7
ORDER BY total DESC;
