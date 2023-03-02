CREATE STATISTICS stat_payment_type ON dbo.taxidata(payment_type);

SELECT payment_type,count(*)
FROM
dbo.taxidata
group by 
payment_type;