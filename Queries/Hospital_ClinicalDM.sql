insert into Hospital_ClinicalDM.dbo.DimClinicalPatient (Patient_Key, Patient_ID, Patient_Name, Gender, City, Country)
select p.Patient_Key, p.Patient_ID, p.Patient_Name, p.Gender, c.City_Name, co.Country_Name
from HospitalDW.dbo.DimPatient p
left join HospitalDW.dbo.DimPatientAddress a on p.Location_Key = a.Location_Key
left join HospitalDW.dbo.DimCity c on a.City_Key = c.City_Key
left join HospitalDW.dbo.DimCountry co on c.Country_Key = co.Country_Key;

insert into Hospital_ClinicalDM.dbo.DimClinicalEmployee (Employee_Key, Employee_ID, Employee_Name, Sex, Role_Name, Salary)
select E.Employee_Key, E.Employee_ID, E.Employee_Name, E.Sex, R.Role_Name, E.Salary 
from HospitalDW.dbo.DimEmployee E 
left join HospitalDW.dbo.DimEmployeeRole R on E.Role_Key = R.Role_Key;

insert into Hospital_ClinicalDM.dbo.DimClinicalRoom (Room_Key, Room_ID, Room_Type, Location, No_Of_Beds, No_Of_Chairs, Ward_Charge)
select R.Room_Key, R.Room_ID, RT.Room_Type, RL.Location, R.No_Of_Beds, R.No_Of_Chairs, R.Ward_Charge 
from HospitalDW.dbo.DimRoom R 
inner join HospitalDW.dbo.DimRoomType RT on R.Room_Type_Key = RT.Room_Type_Key 
inner join HospitalDW.dbo.DimRoomLocation RL on R.Room_Location_Key = RL.Room_Location_Key;

insert into Hospital_ClinicalDM.dbo.DimClinicalDate (Date_Key, Full_Date, Day_Number, Day_Name, Month_Number, Month_Name, Quarter_Number, Year_Number)
select D.Date_Key, D.Full_Date, D.Day_Number, D.Day_Name, M.Month_Number, M.Month_Name, Q.Quarter_Number, Y.Year_Number 
from HospitalDW.dbo.DimDate D 
inner join HospitalDW.dbo.DimMonth M on D.Month_Key = M.Month_Key 
inner join HospitalDW.dbo.DimQuarter Q on M.Quarter_Key = Q.Quarter_Key 
inner join HospitalDW.dbo.DimYear Y on Q.Year_Key = Y.Year_Key;

insert into Hospital_ClinicalDM.dbo.FactClinicalTreatment (Record_ID, Patient_Key, Employee_Key, Room_Key, Start_Date_Key, End_Date_Key, Patient_Age, Treatment_Duration_Days, Treatment_Count, Response, Description)
select Record_ID, Patient_Key, Employee_Key, Room_Key, Start_Date_Key, End_Date_Key, Patient_Age, Treatment_Duration_Days, Treatment_Count, Response, Description 
from HospitalDW.dbo.FactTreatment;