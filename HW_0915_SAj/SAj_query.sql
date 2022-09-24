with t as (
select
    AVG(uv) as AverageUV, 
    AVG(temperature) as AverageTemp,
    AVG(humidity) as AverageHumidity,
    DATEADD(s, AVG(DATEDIFF(second, '1970-01-01 00:00:00', timestamp)), '1970-01-01 00:00:00') as EstimatedTime
from
    [producer] TIMESTAMP BY timestamp
group by TumblingWindow(Duration(second, 5))
)
select *, (case when AverageHumidity>85 and AverageTemp>85 then 1 else 0 end) as IsSweaty into [consumer] from t
