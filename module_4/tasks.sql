/*
Задание 4.1
База данных содержит список аэропортов практически всех крупных городов России. В большинстве городов есть только один аэропорт. Исключение составляет:
*/
SELECT a.city,
       COUNT(a.airport_code) acount
FROM dst_project.airports a
GROUP BY a.city
HAVING COUNT(a.airport_code) > 1
ORDER BY acount DESC

/*
Задание 4.2
Вопрос 1. Таблица рейсов содержит всю информацию о прошлых, текущих и запланированных рейсах. Сколько всего статусов для рейсов определено в таблице?
*/
SELECT COUNT(DISTINCT f.status)
FROM dst_project.flights f

/*
Вопрос 2. Какое количество самолетов находятся в воздухе на момент среза в базе (статус рейса «самолёт уже вылетел и находится в воздухе»).
*/
SELECT COUNT(f.flight_id)
FROM dst_project.flights f
WHERE f.status='Departed'

/*
Вопрос 3. Места определяют схему салона каждой модели. Сколько мест имеет самолет модели (Boeing 777-300)?
*/
SELECT COUNT(s.*)
FROM dst_project.seats s
JOIN dst_project.aircrafts a ON s.aircraft_code=a.aircraft_code
WHERE a.aircraft_code = '773'

/*
Вопрос 4. Сколько состоявшихся (фактических) рейсов было совершено между 1 апреля 2017 года и 1 сентября 2017 года?
*/
SELECT COUNT(f.flight_id)
FROM dst_project.flights f
WHERE f.status='Arrived'
  AND f.scheduled_arrival BETWEEN '01 Apr 2017'::date AND '01 Sep 2017'::date

/*
Задание 4.3
Вопрос 1. Сколько всего рейсов было отменено по данным базы?
*/
SELECT COUNT(f.flight_id)
FROM dst_project.flights f
WHERE f.status='Cancelled'

/*
Вопрос 2. Сколько самолетов моделей типа Boeing, Sukhoi Superjet, Airbus находится в базе авиаперевозок?
*/
SELECT COUNT(*)
FROM dst_project.aircrafts a
WHERE a.model SIMILAR TO '%(Airbus|Boeing|Sukhoi)%'

SELECT COUNT(*)
FROM dst_project.aircrafts a
WHERE a.model LIKE '%Boeing%'

SELECT COUNT(*)
FROM dst_project.aircrafts a
WHERE a.model LIKE '%Airbus%'

SELECT COUNT(*)
FROM dst_project.aircrafts a
WHERE a.model LIKE '%Sukhoi%'

/*
Вопрос 3. В какой части (частях) света находится больше аэропортов?
*/
SELECT REGEXP_REPLACE(a.timezone, '\/.+', '') pw,
       COUNT(*) c
FROM dst_project.airports a
GROUP BY pw
ORDER BY c DESC

/*
У какого рейса была самая большая задержка прибытия за все время сбора данных? Введите id рейса (flight_id).
*/
SELECT f.flight_id
FROM dst_project.flights f
WHERE f.status='Arrived'
ORDER BY f.actual_arrival-f.scheduled_arrival DESC
LIMIT 1

/*
Задание 4.4
Вопрос 1. Когда был запланирован самый первый вылет, сохраненный в базе данных?
*/
SELECT f.scheduled_departure
FROM dst_project.flights f
ORDER BY f.scheduled_departure
LIMIT 1

/*
Вопрос 2. Сколько минут составляет запланированное время полета в самом длительном рейсе?
*/
SELECT EXTRACT(EPOCH
	               FROM f.scheduled_arrival-f.scheduled_departure)/60 delta
	FROM dst_project.flights f
	ORDER BY delta DESC
	LIMIT 1

/*
Вопрос 3. Между какими аэропортами пролегает самый длительный по времени запланированный рейс?
*/
SELECT f.departure_airport,
       f.arrival_airport
FROM dst_project.flights f
ORDER BY f.scheduled_arrival-f.scheduled_departure DESC
LIMIT 1

/*
Вопрос 4. Сколько составляет средняя дальность полета среди всех самолетов в минутах? Секунды округляются в меньшую сторону (отбрасываются до минут).
*/
SELECT ROUND(AVG(EXTRACT(EPOCH
                    FROM f.scheduled_arrival-f.scheduled_departure)/60))
	FROM dst_project.flights f
	WHERE f.status='Arrived'

/*
Задание 4.5
Вопрос 1. Мест какого класса у SU9 больше всего?
*/
SELECT s.fare_conditions,
       COUNT(s.*) cf
FROM dst_project.seats s
WHERE s.aircraft_code='SU9'
GROUP BY s.fare_conditions
ORDER BY cf DESC
LIMIT 1

/*
Вопрос 2. Какую самую минимальную стоимость составило бронирование за всю историю?
*/
SELECT MIN(b.total_amount)
FROM dst_project.bookings b

/*
Вопрос 3. Какой номер места был у пассажира с id = 4313 788533?
*/
SELECT bp.seat_no
FROM dst_project.tickets t
JOIN dst_project.boarding_passes bp ON t.ticket_no=bp.ticket_no
WHERE t.passenger_id='4313 788533'

/*
Задание 5.1
Вопрос 1. Анапа — курортный город на юге России. Сколько рейсов прибыло в Анапу за 2017 год?
*/
SELECT COUNT(f.flight_id)
FROM dst_project.flights f
JOIN dst_project.airports a ON f.arrival_airport=a.airport_code
WHERE a.city='Anapa'
  AND EXTRACT(YEAR FROM f.actual_arrival)=2017

/*
Вопрос 2. Сколько рейсов из Анапы вылетело зимой 2017 года?
*/
SELECT COUNT(f.flight_id)
FROM dst_project.flights f
JOIN dst_project.airports a ON f.departure_airport=a.airport_code
WHERE a.city='Anapa'
  AND EXTRACT(YEAR FROM f.actual_arrival)=2017
  AND EXTRACT(MONTH FROM f.actual_arrival) IN (1,2,12)

/*
Вопрос 3. Посчитайте количество отмененных рейсов из Анапы за все время.
*/
SELECT COUNT(f.flight_id)
FROM dst_project.flights f
JOIN dst_project.airports a ON f.departure_airport=a.airport_code
WHERE a.city='Anapa'
    AND f.status='Cancelled'

/*
Вопрос 4. Сколько рейсов из Анапы не летают в Москву?
*/
SELECT COUNT(f.flight_id)
FROM dst_project.flights f
JOIN dst_project.airports ad ON f.departure_airport=ad.airport_code
JOIN dst_project.airports aa ON f.arrival_airport=aa.airport_code
WHERE ad.city='Anapa'
  AND NOT aa.city='Moscow'

/*
Вопрос 5. Какая модель самолета летящего на рейсах из Анапы имеет больше всего мест?
*/
WITH ac AS
  (SELECT DISTINCT f.aircraft_code
	   FROM dst_project.flights f
	   JOIN dst_project.airports ad ON f.departure_airport=ad.airport_code
	   WHERE ad.city='Anapa' )
SELECT ac.aircraft_code,
       a.model,
       COUNT(s.*) seats
FROM dst_project.seats s
JOIN ac ON ac.aircraft_code=s.aircraft_code
JOIN dst_project.aircrafts a ON ac.aircraft_code=a.aircraft_code
GROUP BY ac.aircraft_code,
         a.model
ORDER BY seats DESC
LIMIT 1
