DROP VIEW IF EXISTS GreenTaxiCleansed;
GO
CREATE VIEW GreenTaxiCleansed AS
SELECT 
TOP 10000
CASE WHEN t.VendorID = 2 THEN 'VeriFone Inc.' ELSE 'Creative Mobile Technologies' END as VendorName,
YEAR(t.lpep_pickup_datetime) yr,
MONTH(t.lpep_pickup_datetime) mo,
DAY(t.lpep_pickup_datetime) pdy,
DATEPART(HOUR,t.lpep_pickup_datetime) phr,
DAY(t.lpep_dropoff_datetime) ddy,
DATEPART(HOUR,t.lpep_dropoff_datetime) dhr,
CASE 
WHEN t.RatecodeID = 1 THEN 'Standard rate' 
WHEN t.RatecodeID = 2 THEN 'JFK' 
WHEN t.RatecodeID = 3 THEN 'Newark' 
WHEN t.RatecodeID = 4 THEN 'Nassau or WestChester' 
WHEN t.RatecodeID = 5 THEN 'Negotiatied Fare' 
ELSE 'Group Ride' END as RateCode,
CASE 
WHEN t.payment_type = 1 THEN 'Credit Card' 
WHEN t.payment_type = 2 THEN 'Cash' 
WHEN t.payment_type = 3 THEN 'No charge' 
WHEN t.payment_type = 4 THEN 'Dispute' 
WHEN t.payment_type = 5 THEN 'Unkown' 
ELSE 'Voided Trip' END as PaymentType,
CASE WHEN t.trip_type=1 THEN 'Street-hail' ELSE 'Dispatch' END as TripType ,
l.Borough as pickupborough, 
l.Zone as pickupzone, 
l.service_zone as pickupservicezone, 
l1.Borough as dropoffborough, 
l1.Zone dropoffzone, 
l1.service_zone dropoffservicezone,
t.passenger_count,
t.trip_distance ,
t.fare_amount	,
t.extra ,
t.mta_tax	,
t.tip_amount ,
t.total_amount
FROM
    dbo.taxidata t
    LEFT JOIN
    dbo.location l
    on t.PULocationID = l.LocationID
    LEFT JOIN
    dbo.location l1
    on t.DOLocationID = l1.LocationID;