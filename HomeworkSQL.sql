#Miriam Berkowitz - homework - Nov 27, 2017

#use the sakila database
use sakila;

#1a: display first and last name of all actors
select first_name, last_name
from actor

#1b: display first and last name in single column called Actor Name
select concat_ws(" ", first_name ,  last_name) as `Actor Name` 
from actor;

#2a: ID, first and last name of actor named "Joe"
select actor_id, first_name, last_name
from actor
where first_name = "JOE";

#2b: all actors whose last name contains "GEN"
select * from actor
where last_name like "%GEN%";

#2c: all actors whose last name contains "LI", ordered by last name, first name
select * from actor
where last_name like "%LI%"
order by last_name, first_name;

#2d: display country id and country for list of countries
select country_id, country from country
where country in ("Afghanistan", "Bangladesh", "China");

#3a: add middle name to actor table
alter table actor
add column middle_name varchar(45) null after first_name;

#3b: change middle_name type to blob
alter table actor
change column middle_name middle_name blob;

#3c: delete middle name column from actor table
alter table actor
drop column middle_name;


#4a: list last names of actors and how many actors have that last name
select last_name, count(*) as count_of_actors
from actor
group by last_name;

#4b: list last name of actors and number, but only for names shared by at least 2 actors
select last_name, count(*) as count_of_actors
from actor
group by last_name
having count_of_actors >= 2;

#4c: change GROUCHO WILLIAMS to HARPO WILLIAMS
update actor
set first_name = "HARPO"
where last_name = "WILLIAMS"
and first_name = "GROUCHO";


#4d: if first name = HARPO, change it to GROUCHO, otherwise change it to MUCHO GROUCHO
update actor
set first_name =
	if(first_name = "HARPO", "GROUCHO", "MUCHO GROUCHO")
where last_name = "WILLIAMS";

select * from actor
where last_name = "WILLIAMS";

#5a - display schema of address table
show create table address;

#6a: join to display first and last name and address of each staff member
select first_name, last_name, address
from staff 
left join address using(address_id);

#6b: join to display total amount rung up by each staff member in Aug 2005 using staff and payment
select first_name, last_name, sum(amount) 
from staff
join payment using(staff_id)
where payment_date between "2005-08-01" and "2005-08-31"
group by staff_id;

#6c: inner join to list each film and number of actors
select title, count(*) as num_actors
from film
join film_actor fa using (film_id)
group by film_id

#6d: how many copies of Hunchback Impossible in inventory
select title, count(*) from inventory
join film using(film_id)
where title = "HUNCHBACK IMPOSSIBLE";

#6e: join payment and customer; list total paid by each customer, list alphabetically by last name
select first_name, last_name, sum(amount) as "Total Amount Paid"
from customer
join payment using(customer_id)
group by customer_id
order by last_name, first_name;

#7a: display titles of movies beginning with K and Q whose language is English
### 7a using join
select title from film
join language using(language_id)
where name = "English"
and (title like "Q%" or title like "K%");

### 7a using subquery
select title from film
join language using(language_id)
where name = "English"
and title in
 (select title from film where title like "Q%" or title like "K%");
 
 #7b: display actors who appear in "Alone Trip" film
 select first_name, last_name
 from film_actor
 join film using(film_id)
 join actor using(actor_id)
 where title = "ALONE TRIP";
 
 #7c: name and email addresses of all Canadian customers
 select first_name, last_name, email
 from customer
 join address using(address_id)
 join city using(city_id)
 join country using(country_id)
 where country = "Canada";
 
 #7d List family films
 select title, description, rating from film_list
 where category = "Family";
 
 #7e Most freqently rented movies in descending order
 ### I decided to display movies that had more than 10 rentals
select title, count(*) as rental_count 
from film
join inventory using(film_id)
join rental using(inventory_id)
group by film_id
having rental_count > 10
order by rental_count desc;


#7f How much $ each store brought in; use the view from the schema
select * from sales_by_store;

#7g: display store ID, city and country
select store_id, city, country
from store
join address using(address_id)
join city using(city_id)
join country using(country_id);

#7h: top 5 genres in gross revenue in desc order; use the view that is in the schema
select * from sales_by_film_category
order by total_sales desc;


#8a: create a view of the top 5 genres by gross revenue
drop view if exists top_five_genres;
create view top_five_genres (category, total_sales)
as
select * from sales_by_film_category
order by total_sales desc
limit 5;


#8b: display the view just created
select * from top_five_genres;

#8c: 
drop view top_five_genres;



