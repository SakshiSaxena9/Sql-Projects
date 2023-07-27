create database public;
CREATE TABLE public.album (
    album_id character varying(50) NOT NULL,
    title character varying(120),
    artist_id character varying(30)
);
CREATE TABLE public.artist (
    artist_id character varying(50) NOT NULL,
    name character varying(120)
);
CREATE TABLE public.customer (
    customer_id integer NOT NULL,
    first_name character(50),
    last_name character(50),
    company character varying(120),
    address character varying(120),
    city character varying(50),
    state character varying(50),
    country character varying(50),
    postal_code character varying(50),
    phone character varying(50),
    fax character varying(50),
    email character varying(50),
    support_rep_id integer
);
CREATE TABLE public.employee (
    employee_id character varying(50) NOT NULL,
    last_name character(50),
    first_name character(50),
    title character varying(50),
    reports_to character varying(30),
    levels character varying(10),
    birthdate datetime,
    hire_date datetime,
    address character varying(120),
    city character varying(50),
    state character varying(50),
    country character varying(30),
    postal_code character varying(30),
    phone character varying(30),
    fax character varying(30),
    email character varying(30)
);
CREATE TABLE public.genre (
    genre_id character varying(50) NOT NULL,
    name character varying(120)
);
CREATE TABLE public.invoice (
    invoice_id integer NOT NULL,
    customer_id integer,
    invoice_date datetime,
    billing_address character varying(120),
    billing_city character varying(30),
    billing_state character varying(30),
    billing_country character varying(30),
    billing_postal character varying(30),
    total double precision
);
CREATE TABLE public.invoice_line (
    invoice_line_id character varying(50) NOT NULL,
    invoice_id integer,
    track_id integer,
    unit_price double precision,
    quantity double precision
);
CREATE TABLE public.media_type (
    media_type_id character varying(50) NOT NULL,
    name character varying(120)
);
CREATE TABLE public.playlist (
    playlist_id character varying(50) NOT NULL,
    name character varying(120)
);
CREATE TABLE public.playlist_track (
    playlist_id character varying(50),
    track_id integer
);
CREATE TABLE public.track (
    track_id integer NOT NULL,
    name character varying(150),
    album_id character varying(50),
    media_type_id character varying(50),
    genre_id character varying(50),
    composer character varying(190),
    milliseconds integer,
    bytes integer,
    unit_price double precision
);     
LOAD DATA INFILE  'C:/ProgramData/MySQL/album.csv'
INTO TABLE public.album
character set latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE  'C:/ProgramData/MySQL/track.csv'
INTO TABLE public.track
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from public.album;

* use public

Set 1 (Easy)

Q.1 Who is the senior most employee based on job title?

select * from public.employee
order by levels desc
limit 1

Q.2 Which country has the most invoices?

select count(*), billing_country as Country 
from invoice
group by Country
limit 1

Q.3 What are top 3 values of total invoice?

select total
from invoice
order by total desc
limit 3

Q.4. Which city has the best customers? We would like to throw a promotional Music 
Festival in the city we made the most money. Write a query that returns one city that 
has the highest sum of invoice totals. Return both the city name & sum of all invoice 
totals

select sum(total) as invoice_total , Billing_city as city
from invoice
group by city
order by invoice_total desc
limit 1

Q.5. Who is the best customer? The customer who has spent the most money will be 
declared the best customer. Write a query that returns the person who has spent the 
most money

select c.customer_id, c.first_name, c.last_name, sum(i.total) as total
from customer as c
join invoice as i on c.customer_id = i.customer_id
group by c.customer_id
order by total desc
limit 1

Set 2 (Moderate)

1. Write query to return the email, first name, last name, & Genre of all Rock Music 
listeners. Return your list ordered alphabetically by email starting with A

select first_name, last_name, email
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in (
select track_id from track
join genre on track.genre_id = genre.genre_id
where genre.name like 'Rock'
)
order by email

* set sql_mode = ' '

2. Lets invite the artists who have written the most rock music in our dataset. Write a 
query that returns the Artist name and total track count of the top 10 rock bands

select artist.artist_id, artist.name, count(artist.artist_id) as total_songs
from track
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name like 'Rock'
group by artist.artist_id
order by total_songs desc
limit 10
select * from artist
select * from track

3. Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the 
longest songs listed first 

select name, milliseconds
from track 
where milliseconds > (
select avg(milliseconds) as average_length from track)
order by milliseconds desc

Set 3 (Hard)

1. Find how much amount spent by each customer on artists? Write a query to return 
customer name, artist name and total spent

with best_selling_artist as (
select  artist.artist_id as Artist_ID, Artist.name as Artist_Name, sum(invoice_line.unit_price*invoice_line.quantity) as totalsales
from invoice_line
join track on track.track_id = invoice_line.track_id
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
group by 1 
order by 3 desc
limit 1
)
select c.customer_id, c.first_name, c.last_name, bsa.artist_name, sum(il.unit_price*il.quantity) as amount_spent
from invoice i
join customer c on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id
join album alb on alb.album_id = t.album_id
join best_selling_artist bsa on bsa.artist_id = alb.artist_id
group by 1,2,3,4
order by 4 desc;

2. We want to find out the most popular music Genre for each country. We determine the 
most popular genre as the genre with the highest amount of purchases. Write a query 
that returns each country along with the top Genre. For countries where the maximum 
number of purchases is shared return all Genres 

with popular_genre as
(
select count(il.quantity) as Purchase, c.country as Country, g.name as Genre, g. genre_id,
row_number() over(partition by c.country order by count(il.quantity) desc) as RowNo
from invoice_line il
join invoice i on i.invoice_id = il.invoice_id
join customer c on c.customer_id = i.customer_id
join track t on t.track_id = il.track_id
join genre g on g.genre_id = t.genre_id
group by 2,3,4
order by 2 asc, 1 desc 
)
select * from popular_genre where RowNo <= 1

method 2

with recursive
sales_per_country as
(
select count(*) as purchase_per_genre, customer.country as country, genre.name as genre, genre.genre_id as genre_id
from invoice_line
join invoice on invoice.invoice_id = invoice_line.invoice_id
join customer on customer.customer_id = invoice.customer_id
join track on track.track_id = invoice_line.track_id
join genre on genre.genre_id = track.genre_id
group by 2,3,4
order by 2
),
max_genre_per_country as
(
select max(purchase_per_genre) as max_genre_number, country
from sales_per_country
group by 2 
order by 2
)
select sales_per_country. *
from sales_per_country
join max_genre_per_country on sales_per_country.country = max_genre_per_country.country
where sales_per_country.purchase_per_genre = max_genre_per_country.max_genre_number

3. Write a query that determines the customer that has spent the most on music for each 
country. Write a query that returns the country along with the top customer and how 
much they spent. For countries where the top amount spent is shared, provide all 
customers who spent this amount

with recursive
most_spent_customer as
(
select c.customer_id, c.first_name As first_name, c.last_name as last_name, c.country as country, sum(total) as Amount_spent
from customer c
join invoice i on i.customer_id = c.customer_id
group by 1,2,3,4
order by 4 asc, 5 desc
),
Most_Money_Spent as
(
select max(Amount_spent) as max_Amount_spent, country
from most_spent_customer
group by 2
order by 2
)
select most_spent_customer.*
from most_spent_customer
join Most_Money_Spent on Most_Money_Spent.country = most_spent_customer.country
where most_spent_customer.Amount_spent = Most_Money_Spent.max_Amount_spent

method 2

with customer_with_country as
(select c.customer_id as customer_id, c.first_name As first_name, c.last_name as last_name,
c.country as country, sum(total) as Amount_spent,
row_number() over(partition by c.country order by sum(total) desc) as RowNo
from customer c
join invoice i on i.customer_id = c.customer_id
group by 1,2,3,4
order by 4, 5 desc
)
select * from customer_with_country
where RowNo <= 1