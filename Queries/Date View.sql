create view BI.vw_Date as
select
    D.Date_Key,
    D.Full_Date,
    D.Day_Number,
    D.Day_Name,

    M.Month_Number,
    M.Month_Name,

    Q.Quarter_Number,
    Q.Quarter_Name,

    Y.Year_Number

from DimDate D
inner join DimMonth M on D.Month_Key = M.Month_Key
inner join DimQuarter Q on M.Quarter_Key = Q.Quarter_Key
inner join DimYear Y on Q.Year_Key = Y.Year_Key;
