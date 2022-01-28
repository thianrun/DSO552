---Question 1---

SELECT   DISTINCT ON (class_count) categorydescription category_name
	   	,count(classid) class_count
FROM classes
INNER JOIN subjects USING (subjectid)
INNER JOIN categories USING (categoryid)
GROUP BY categorydescription
ORDER BY class_count DESC, category_name
LIMIT 5;

---Question 2---

SELECT   DISTINCT ON (class_count) stffirstname
		,stflastname
		,s.staffid
		,position
		,title
		,datehired
		,COUNT(DISTINCT classid) class_count
		,COUNT(DISTINCT subjectid) subject_count
FROM faculty_classes
RIGHT JOIN  staff s USING (staffid)
INNER JOIN faculty USING (staffid)
INNER JOIN faculty_subjects USING (staffid)
INNER JOIN subjects USING (subjectid)
GROUP BY stffirstname
		,stflastname
		,s.staffid
		,position
		,title
		,datehired
ORDER BY class_count,title,datehired desc
LIMIT 6;

---Question 3---

SELECT 	 DISTINCT ON (total_actors) first_name
		,last_name
		,COUNT(DISTINCT ma.movie_id) total_movies
		,COUNT(ma.actor_id) total_actors
		,SUM(revenues_domestic) dom_rev
FROM directors
INNER JOIN movies USING (director_id)
INNER JOIN movies_revenues USING (movie_id)
INNER JOIN movies_actors ma USING (movie_id)
GROUP BY first_name
		,last_name
HAVING COUNT(DISTINCT ma.movie_id) = 1
ORDER BY total_actors DESC, dom_rev DESC, last_name DESC;


---Question 4---

SELECT 	 d.first_name||', '||d.last_name director_name
		,a.first_name||', '||a.last_name actor_name
		,SUM(revenues_domestic + revenues_international) total_value
FROM directors d
INNER JOIN movies USING (director_id)
INNER JOIN movies_actors USING (movie_id)
INNER JOIN actors a USING (actor_id)
INNER JOIN movies_revenues USING (movie_id)
WHERE revenues_domestic is not NULL and revenues_international is not NULL
GROUP BY director_name
		,actor_name
ORDER BY total_value DESC, director_name DESC
LIMIT 4;

---Question 5---

SELECT 	 subjectname
		,COUNT(DISTINCT c.classid) class_count
		,COUNT(DISTINCT studentid) student_count
FROM subjects s
LEFT JOIN classes c USING (subjectid)
LEFT JOIN student_schedules USING (classid)
WHERE s.subjectid not in (SELECT subjectid FROM faculty_subjects)
GROUP BY subjectname;


---Question 6---

SELECT 	 subjectname
		,COUNT(*) class_count
FROM subjects
INNER JOIN classes USING (subjectid)
WHERE classid in (
			SELECT classid FROM student_schedules 
			INNER JOIN student_class_status USING (classstatus)
			WHERE classstatusdescription = 'Completed')
AND subjectname ILIKE '%fundamental%'
GROUP BY subjectname;


---Question 7---

SELECT 	 major
		,classstatusdescription
		,COUNT(*) student_count
FROM majors m
INNER JOIN students s
ON s.studmajor = m.majorid
INNER JOIN student_schedules USING (studentid)
INNER JOIN student_class_status USING (classstatus)
GROUP BY major
		,classstatusdescription
ORDER BY student_count DESC, major
LIMIT 4;


---Question 8---

SELECT 	 company_name
		,DATE_PART('year',order_date) order_year
		,SUM(quantity) total_quantity
		,COUNT(*) total_orders
FROM customers
INNER JOIN orders USING (customer_id)
INNER JOIN order_details USING (order_id)
WHERE country = 'UK'
GROUP BY company_name
		,order_year
HAVING COUNT(*) > 10
ORDER BY total_quantity DESC, total_orders DESC;

