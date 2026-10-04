create view BI.vw_TreatmentAnalysis as
select
    F.Treatment_Key,
    F.Record_ID,

    P.Patient_Key,
    P.Patient_ID,
    P.Patient_Name,
    P.Gender,
    P.Phone_Number,
    P.Email,

    C.City_Name,
    CO.Country_Name,

    E.Employee_Key,
    E.Employee_ID,
    E.Employee_Name,
    E.Sex as Employee_Sex,
    ER.Role_Name,

    R.Room_Key,
    R.Room_ID,
    RT.Room_Type,
    RL.Location as Room_Location,
    R.No_Of_Beds,
    R.No_Of_Chairs,
    R.Ward_Charge,

    DS.Date_Key as Start_Date_Key,
    DS.Full_Date as Treatment_Start_Date,
    MS.Month_Number as Start_Month_Number,
    MS.Month_Name as Start_Month_Name,
    QS.Quarter_Number as Start_Quarter_Number,
    YS.Year_Number as Start_Year,

    DE.Date_Key as End_Date_Key,
    DE.Full_Date as Treatment_End_Date,
    ME.Month_Number as End_Month_Number,
    ME.Month_Name as End_Month_Name,
    QE.Quarter_Number as End_Quarter_Number,
    YE.Year_Number as End_Year,

    F.Patient_Age,
    F.Treatment_Duration_Days,
    F.Treatment_Count,

    F.Response,
    F.Description

from FactTreatment F

inner join DimPatient P on F.Patient_Key = P.Patient_Key
left join DimPatientAddress PA on P.Location_Key = PA.Location_Key
left join DimCity C on PA.City_Key = C.City_Key
left join DimCountry CO on C.Country_Key = CO.Country_Key
inner join DimEmployee E on F.Employee_Key = E.Employee_Key
left join DimEmployeeRole ER on E.Role_Key = ER.Role_Key
inner join DimRoom R on F.Room_Key = R.Room_Key
left join DimRoomType RT on R.Room_Type_Key = RT.Room_Type_Key
left join DimRoomLocation RL on R.Room_Location_Key = RL.Room_Location_Key
inner join DimDate DS on F.Start_Date_Key = DS.Date_Key
left join DimMonth MS on DS.Month_Key = MS.Month_Key
left join DimQuarter QS on MS.Quarter_Key = QS.Quarter_Key
left join DimYear YS on QS.Year_Key = YS.Year_Key
inner join DimDate DE on F.End_Date_Key = DE.Date_Key
left join DimMonth ME on DE.Month_Key = ME.Month_Key
left join DimQuarter QE on ME.Quarter_Key = QE.Quarter_Key
left join DimYear YE on QE.Year_Key = YE.Year_Key;





