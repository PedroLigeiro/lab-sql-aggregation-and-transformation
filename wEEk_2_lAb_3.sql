## Challenge 1
# 1. You need to use SQL built-in functions to gain insights relating to the duration of movies:
# 1.1 Determine the **shortest and longest movie durations** and name the values as `max_duration` and `min_duration`.
select max(length) as MAX_DURATION, min(length) as MIN_DURATION
from sakila.film;
 
# 1.2. Express the **average movie duration in hours and minutes**. Don't use decimals.
# *Hint: Look for floor and round functions.*
select sec_to_time(round(avg(length))*60) as AVERAGE_MOVIE_DURATION
from sakila.film;

# 2. You need to gain insights related to rental dates:
# 2.1 Calculate the **number of days that the company has been operating**.
# *Hint: To do this, use the `rental` table, and the `DATEDIFF()` function to subtract the earliest date in the `rental_date` column from the latest date.*
select datediff(max(last_update), min(rental_date)) as DAYS_IN_OPERATION
from sakila.rental;

# 2.2 Retrieve rental information and add two additional columns to show the **month and weekday of the rental**. Return 20 rows of results.
select *, extract(month from rental_date) as MONTH_OF_RENTAL, weekday(rental_date) as WEEKDAY_OF_RENTAL
from sakila.rental limit 20;

# 2.3 *Bonus: Retrieve rental information and add an additional column called `DAY_TYPE` with values **'weekend' or 'workday'**, depending on the day of the week.*
#*Hint: use a conditional expression.*
select *,
case
when weekday(rental_date) = "6" then "weekend"
when weekday(rental_date) = "7" then "weekend"
when weekday(rental_date) = "1" then "workday"
when weekday(rental_date) = "2" then "workday"
when weekday(rental_date) = "3" then "workday"
when weekday(rental_date) = "4" then "workday"
when weekday(rental_date) = "5" then "workday"
end as DAY_TYPE
from sakila.rental;

# 3. You need to ensure that customers can easily access information about the movie collection. To achieve this, retrieve the **film titles and their rental duration**. If any rental duration value is **NULL, replace** it with the string **'Not Available'**. Sort the results of the film title in ascending order.
# *Please note that even if there are currently no null values in the rental duration column, the query should still be written to handle such cases in the future.*
# *Hint: Look for the `IFNULL()` function.*
select title as FILM_TITLE,
case 
when rental_duration is null then "Not Available"
else rental_duration
end as RENTAL_DURATION
from sakila.film
order by title asc;

# 4. *Bonus: The marketing team for the movie rental company now needs to create a personalized email campaign for customers. To achieve this, you need to retrieve the **concatenated first and last names of customers**, along with the **first 3 characters of their email** address, so that you can address them by their first name and use their email address to send personalized recommendations. The results should be ordered by last name in ascending order to make it easier to use the data.*
select concat(last_name, first_name) as NAME, substring(email,1,3) as EMAIL
from sakila.customer
order by last_name asc;

## Challenge 2
# 1. Next, you need to analyze the films in the collection to gain some more insights. Using the `film` table, determine:
# 1.1 The **total number of films** that have been released.
select count(distinct(film_id)) as TOTAL_NUMBER_OF_FILMS
from sakila.film;

# 1.2 The **number of films for each rating**.
select count(distinct(film_id)) as NUMBER_OF_FILMS, rating as RATING
from sakila.film
group by rating;

# 1.3 The **number of films for each rating, sorting** the results in descending order of the number of films.
# This will help you to better understand the popularity of different film ratings and adjust purchasing decisions accordingly.
select count(distinct(film_id)) as NUMBER_OF_FILMS, rating as RATING
from sakila.film
group by rating
order by NUMBER_OF_FILMS desc;

# 2. Using the `film` table, determine:
# 2.1 The **mean film duration for each rating**, and sort the results in descending order of the mean duration. Round off the average lengths to two decimal places. This will help identify popular movie lengths for each category.
select round(avg(length), 2) as MEAN_FILM_DURATION, RATING
from sakila.film
group by rating
order by MEAN_FILM_DURATION desc;

# 2.2 Identify **which ratings have a mean duration of over two hours** in order to help select films for customers who prefer longer movies.
select RATING, round(avg(length), 2) as MEAN_FILM_DURATION
from sakila.film
group by rating
having round(avg(length), 2) > 120
order by MEAN_FILM_DURATION desc;

# 3. *Bonus: determine which last names are not repeated in the table `actor`.*
select distinct(last_name) as LAST_NAME
from sakila.actor;
