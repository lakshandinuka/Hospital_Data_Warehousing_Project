use HospitalDW;

insert into DimYear select distinct YearValue from (select YEAR(Treatment_Start_Date) as YearValue from HospitalDB.dbo.Record union select YEAR(Treatment_End_Date) as YearValue from HospitalDB.dbo.Record) as Y
where not exists (select 1 from DimYear D where d.Year_Number = y.YearValue);

insert into DimQuarter (Quarter_Number, Quarter_Name, Year_Key)
select distinct DATEPART(QUARTER, R.TreatmentDate), 'Q' + CAST(DATEPART(QUARTER, R.TreatmentDate) as nvarchar(1)), Y.Year_Key
from (select Treatment_Start_Date as TreatmentDate from HospitalDB.dbo.Record union select Treatment_End_Date as TreatmentDate from HospitalDB.dbo.Record)R
inner join DimYear Y on Y.Year_Number = YEAR(R.TreatmentDate)
where not exists (select 1 from DimQuarter Q where Q.Quarter_Number = DATEPART(QUARTER, R.TreatmentDate) and Q.Quarter_Key = Y.Year_Key);

select * from DimQuarter;

insert into DimMonth (Month_Number, Month_Name, Quarter_Key)
select distinct MONTH(R.TreatmentDate), DATENAME(MONTH, R.TreatmentDate), Q.Quarter_Key
from (select Treatment_Start_Date as TreatmentDate from HospitalDB.dbo.Record union select Treatment_End_Date as TereatmentDate from HospitalDB.dbo.Record)R
inner join DimQuarter Q on Q.Quarter_Number = DATEPART(QUARTER, R.TreatmentDate)
inner join DimYear Y on Y.Year_Key = Q.Year_Key and Y.Year_Number = YEAR(R.TreatmentDate)
where not exists (select 1 from DimMonth M where M.Month_Number = MONTH(R.TreatmentDate) and M.Quarter_Key = Q.Quarter_Key);

select * from DimMonth;

insert into DimDate (Date_Key, Full_Date, Day_Number, Day_Name, Month_Key)
select distinct convert(int, convert(char(8), R.TreatmentDate, 112)), cast(R.TreatmentDate as date), day(R.TreatmentDate), datename(weekday, R.TreatmentDate), M.Month_Key
from (select Treatment_Start_Date as TreatmentDate from HospitalDB.dbo.Record union select Treatment_End_Date as TreatmentDate from HospitalDB.dbo.Record) R
inner join DimYear Y on Y.Year_Number = YEAR(R.TreatmentDate)
inner join DimQuarter Q on Q.Year_Key = Y.Year_Key and Q.Quarter_Number = DATEPART(QUARTER, R.TreatmentDate)
inner join DimMonth M on M.Quarter_Key = Q.Quarter_Key and M.Month_Number = MONTH(R.TreatmentDate)
where not exists (select 1 from DimDate D where D.Full_Date = cast(R.TreatmentDate as date));

select * from DimDate;

insert into DimCountry (Country_Name)
select distinct Country
from HospitalDB.dbo.PatientAddress
where not exists (select 1 from DimCountry c where c.Country_Name = PatientAddress.Country);

select * from DimCountry;

insert into DimCity (City_Name, Country_Key)
select distinct pa.City, c.Country_Key
from HospitalDB.dbo.PatientAddress pa
inner join DimCountry c on c.Country_Name = pa.Country
where not exists (select 1 from DimCity d where d.City_Name = pa.City and c.Country_Key = d.Country_Key);

select * from DimCity;

insert into DimPatientAddress (Address, City_Key)
select pa.Address, c.City_Key
from HospitalDB.dbo.PatientAddress pa
inner join DimCity c on c.City_Name = pa.City
inner join DimCountry co on co.Country_Key = c.Country_Key and co.Country_Name = pa.Country 
where not exists (select 1 from DimPatientAddress d where d.Address = pa.Address and d.City_Key = c.City_Key);

select * from DimPatientAddress;

select Patient_ID, count(*) from HospitalDB.dbo.PatientAddress group by Patient_ID having count(*)>1; 

insert into DimPatient (Patient_ID, Patient_Name, Gender, Phone_Number, Email, Location_Key)
select p.Patient_ID, p.Patient_Name, p.Gender, p.Phone_Number, p.Email, pa.Location_Key
from HospitalDB.dbo.Patient p
left join HospitalDB.dbo.PatientAddress a on p.Patient_ID = a.Patient_ID
left join DimPatientAddress pa on pa.Address = a.Address
where not exists (select 1 from DimPatient d where d.Patient_ID = p.Patient_ID);

select * from DimPatient;

insert into DimEmployeeRole (Role_Name)
select distinct Role
from HospitalDB.dbo.Employee
where Role is not null and not exists (select 1 from DimEmployeeRole r where r.Role_Name = Employee.Role);

select * from DimEmployeeRole;

insert into DimEmployee (Employee_ID, Employee_Name, Email, Sex, Salary, ContactNo, Role_Key)
select e.Employee_ID, e.Employee_Name, e.Email, e.Sex, CAST(e.Salary AS DECIMAL(18,2)), e.ContactNo, r.Role_Key
from HospitalDB.dbo.Employee e
left join DimEmployeeRole r on r.Role_Name = e.Role
where not exists (select 1 from DimEmployee d where d.Employee_ID = e.Employee_ID);

select * from DimEmployee;

insert into DimRoomType (Room_Type)
select distinct Room_Type
from HospitalDB.dbo.Room
where not exists (select 1 from DimRoomType d where d.Room_Type = Room.Room_Type);

select * from DimRoomType;

insert into DimRoomLocation (Location)
select distinct Location
from HospitalDB.dbo.Room
where not exists (select 1 from DimRoomLocation d where d.Location = Room.Location);

select * from DimRoomLocation;

insert into DimRoom (Room_ID, Room_Type_Key, Room_Location_Key, No_Of_Beds, No_Of_Chairs, Ward_Charge)
select r.Room_ID, rt.Room_Type_Key, rl.Room_Location_Key, r.No_Of_Beds, r.No_Of_Chairs, CAST(R.Ward_Charge as decimal(18,2))
from HospitalDB.dbo.Room r
inner join DimRoomType rt on rt.Room_Type = r.Room_Type
inner join DimRoomLocation rl on rl.Location = r.Location
where not exists (select 1 from DimRoom d where d.Room_ID = r.Room_ID);

select * from DimRoom;

insert into DimMedicineCategory (Med_Catg_Code, BrandName, CompanyName, ModifiedDate)
select Med_Catg_Code, BrandName, CompanyName, ModifiedDate
from HospitalDB.dbo.MedicineCatg mc
where not exists (select 1 from DimMedicineCategory d where d.Med_Catg_Code = mc.Med_Catg_Code);

select * from DimMedicineCategory;

insert into DimMedicineSubCategory (Med_Sub_Ref_No, Medicine_Category_Key, Name, ManufactDate, ExpiryDate, ModifiedDate)
select ms.Med_Sub_Ref_No, mc.Medicine_Category_Key, ms.Name, ms.ManufactDate, ms.ExpiryDate, ms.ModifiedDate
from HospitalDB.dbo.MedicineSubCatg ms
inner join DimMedicineCategory mc on mc.Med_Catg_Code = ms.Med_Catg_Code
where not exists (select 1 from DimMedicineSubCategory d where d.Med_Sub_Ref_No = ms.Med_Sub_Ref_No);

select * from DimMedicineSubCategory;

insert into DimMedicine (Med_Code, Med_Name, Medicine_SubCategory_Key)
select m.Med_Code, m.Med_Name, ms.Medicine_SubCategory_Key
from HospitalDB.dbo.Medication m
inner join DimMedicineSubCategory ms on ms.Med_Sub_Ref_No = m.Med_Sub_Ref_No
where not exists (select 1 from DimMedicine d where d.Med_Code = m.Med_Code);

select * from DimMedicine;

insert into FactTreatment (Record_ID, Patient_Key, Employee_Key, Room_Key, Start_Date_Key, End_Date_Key, Patient_Age, Treatment_Duration_Days, Treatment_Count, Response, Description)
select r.Record_ID, p.Patient_Key, e.Employee_Key, rm.Room_Key, ds.Date_Key, de.Date_Key, r.Age, DATEDIFF(day, r.Treatment_Start_Date, r.Treatment_End_Date) as Treatment_Duration_Days, 1 as Treatment_Count, r.Response, r.Description
from HospitalDB.dbo.Record R
inner join DimPatient p on p.Patient_ID = r.Patient_ID
inner join DimEmployee e on e.Employee_ID = r.Employee_ID
inner join DimRoom rm on rm.Room_ID = r.Room_ID
inner join DimDate ds on ds.Full_Date = CAST(r.Treatment_Start_Date as date)
inner join DimDate de on de.Full_Date = CAST(r.Treatment_End_Date as date)
where not exists (select 1 from FactTreatment f where f.Record_ID = r.Record_ID);

select * from FactTreatment;

insert into FactMedication (Patient_Key, Medicine_Key, Quantity, Unit_Price, Medication_Cost, Medication_Count)
select dp.Patient_Key, dm.Medicine_Key, m.Quantity, CAST(M.Price as decimal(18,2)) as Unit_Price, CAST(m.Quantity * m.Price as decimal(18,2)) as Medication_Cost, 1 as Medication_Count
from HospitalDB.dbo.PatientMedication pm
inner join HospitalDB.dbo.Patient p on p.Patient_ID = pm.Patient_ID
inner join HospitalDB.dbo.Medication m on m.Med_Code = pm.Med_Code
inner join DimPatient dp on dp.Patient_ID = p.Patient_ID
inner join DimMedicine dm on dm.Med_Code = m.Med_Code
where not exists (select 1 from FactMedication f where f.Patient_Key = dp.Patient_Key and f.Medicine_Key = dm.Medicine_Key);

select * from FactMedication;




