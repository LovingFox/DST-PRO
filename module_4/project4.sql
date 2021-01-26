-- Временная функция для расчета расстояния между координатам lat/lag
CREATE OR REPLACE FUNCTION pg_temp.geodistance(
	alat double precision,
	alng double precision,
	blat double precision,
	blng double precision
) RETURNS double precision AS
$BODY$
SELECT ASIN(
  SQRT(
    SIN(RADIANS($3-$1)/2)^2 +
    SIN(RADIANS($4-$2)/2)^2 *
    COS(RADIANS($1)) *
    COS(RADIANS($3))
  )
) * 12742 AS distance;
$BODY$
LANGUAGE SQL IMMUTABLE;

-- Временная таблица с интересующими перелетами и связанными с ними заказами
DROP TABLE IF EXISTS books_flights_from_anapa_winter_2017;
CREATE TEMP TABLE books_flights_from_anapa_winter_2017 AS
SELECT DISTINCT
	b.book_ref,
	f.flight_id
FROM dst_project.bookings b
JOIN dst_project.tickets t ON t.book_ref = b.book_ref
JOIN dst_project.ticket_flights tf ON tf.ticket_no = t.ticket_no
JOIN dst_project.flights f ON f.flight_id = tf.flight_id
WHERE f.departure_airport='AAQ'
	AND f.status='Arrived'
	AND DATE_TRUNC('month', f.scheduled_departure) in ('01 Jan 2017','01 Feb 2017', '01 Dec 2017');
SELECT * FROM books_flights_from_anapa_winter_2017;


-- Временная таблица с данными, куда летают зимой из Анапы, и расстояния до аэропортов назначения
DROP TABLE IF EXISTS airports_from_anapa_winter_2017;
CREATE TEMP TABLE airports_from_anapa_winter_2017 AS
SELECT DISTINCT
    f.arrival_airport,
    aa.airport_name,
    aa.city,
    f.flight_no,
    pg_temp.geodistance(aa.latitude, aa.longitude, ad.latitude, ad.longitude) distance
FROM dst_project.flights f
JOIN dst_project.airports aa ON f.arrival_airport=aa.airport_code
JOIN dst_project.airports ad ON f.departure_airport=ad.airport_code
WHERE f.flight_id IN (
	SELECT flight_id
	FROM books_flights_from_anapa_winter_2017
);
SELECT * FROM airports_from_anapa_winter_2017;


-- Основной составной запрос, создающий итоговый датасет
WITH
flights AS(
/*
каркас таблицы датасета, с идентификаторами перелета, его длительностью,
проданнами билетами (эконом, бизнес), стоимостью (эконом, бизнес)   
*/
	SELECT
		f.flight_id,
		f.flight_no,
		f.arrival_airport,
		f.aircraft_code,
		f.scheduled_departure,
		COUNT(tf.ticket_no) numb_pass,
		COUNT(tf.ticket_no) FILTER (WHERE tf.fare_conditions = 'Economy') numb_eco,
		COUNT(tf.ticket_no) FILTER (WHERE NOT tf.fare_conditions = 'Economy') numb_biz,
		SUM(tf.amount) amount,
		SUM(tf.amount) FILTER (WHERE tf.fare_conditions = 'Economy') amount_eco,
		SUM(tf.amount) FILTER (WHERE NOT tf.fare_conditions = 'Economy') amount_biz,
		EXTRACT(EPOCH FROM f.scheduled_arrival-f.scheduled_departure)/60 ftime
	FROM dst_project.ticket_flights tf
	JOIN dst_project.flights f ON tf.flight_id=f.flight_id
	WHERE f.flight_id IN (
		SELECT flight_id
		FROM books_flights_from_anapa_winter_2017
	)
	GROUP BY
		f.flight_no,
		f.flight_id
),
tamount AS (
/*
Стоимость всех перелетов заказа, где участвует перелет из Анапы
*/
	SELECT
		bf.flight_id,
		SUM(b.total_amount) total_amount_per_books
	FROM books_flights_from_anapa_winter_2017 bf
	JOIN dst_project.bookings b ON b.book_ref = bf.book_ref
	GROUP BY bf.flight_id
),
tfligths AS (
/*
Число всех перелетов заказа, где участвует перелет из Анапы
*/
	SELECT
		bf.flight_id,
		COUNT(tf.flight_id) total_fligths_per_books
	FROM books_flights_from_anapa_winter_2017 bf
	JOIN dst_project.tickets t ON t.book_ref = bf.book_ref
	JOIN dst_project.ticket_flights tf ON tf.ticket_no = t.ticket_no
	GROUP BY bf.flight_id
),
seats AS (
/*
Информация по местам в воздушных судах
*/
	SELECT
		a.aircraft_code,
		a.range,
		COUNT(s.seat_no) seats,
		COUNT(s.seat_no) FILTER (WHERE s.fare_conditions = 'Economy') seats_eco,
		COUNT(s.seat_no) FILTER (WHERE NOT s.fare_conditions = 'Economy') seats_biz
	FROM
		dst_project.aircrafts a
	JOIN
		dst_project.seats s ON s.aircraft_code = a.aircraft_code
	GROUP BY
		a.aircraft_code
)
SELECT
	f.*,
	aa.distance,
	ta.total_amount_per_books,
	tf.total_fligths_per_books,
	s.range,
	s.seats,
	s.seats_eco,
	s.seats_biz
FROM
	flights f
JOIN tamount ta ON ta.flight_id=f.flight_id
JOIN tfligths tf ON tf.flight_id=f.flight_id
JOIN seats s ON s.aircraft_code=f.aircraft_code
JOIN airports_from_anapa_winter_2017 aa ON aa.arrival_airport=f.arrival_airport
