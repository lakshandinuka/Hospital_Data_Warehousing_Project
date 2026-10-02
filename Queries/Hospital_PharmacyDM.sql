insert into Hospital_PharmacyDM.dbo.DimPharmacyPatient(Patient_Key, Patient_ID, Patient_Name, Gender, City, Country)
select p.Patient_Key, p.Patient_ID, p.Patient_Name, p.Gender, c.City_Name, co.Country_Name
from HospitalDW.dbo.DimPatient p
left join HospitalDW.dbo.DimPatientAddress a on p.Location_Key = a.Location_Key
left join HospitalDW.dbo.DimCity c on a.City_Key = c.City_Key
left join HospitalDW.dbo.DimCountry co on c.Country_Key = co.Country_Key;

select * from DimPharmacyPatient;

insert into Hospital_PharmacyDM.dbo.DimPharmacyMedicine (Medicine_Key, Med_Code, Med_Name, SubCategory_Name, BrandName, CompanyName, ManufactDate, ExpiryDate)
select m.Medicine_Key, m.Med_Code, m.Med_Name, ms.Name, mc.BrandName, mc.CompanyName, ms.ManufactDate, ms.ExpiryDate
from HospitalDW.dbo.DimMedicine m
inner join HospitalDW.dbo.DimMedicineSubCategory ms on m.Medicine_SubCategory_Key = ms.Medicine_SubCategory_Key
inner join HospitalDW.dbo.DimMedicineCategory mc on ms.Medicine_Category_Key = mc.Medicine_Category_Key;

select * from DimPharmacyMedicine;

insert into Hospital_PharmacyDM.dbo.FactPharmacyMedication (Patient_Key, Medicine_Key, Quantity, Unit_Price, Medication_Cost, Medication_Count)
select Patient_Key, Medicine_Key, Quantity, Unit_Price, Medication_Cost, Medication_Count
from HospitalDW.dbo.FactMedication;

select  * from FactPharmacyMedication;