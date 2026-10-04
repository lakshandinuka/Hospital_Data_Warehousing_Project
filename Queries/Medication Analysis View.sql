create view BI.vw_MedicationAnalysis as
select
    F.Medication_Fact_Key,

    P.Patient_Key,
    P.Patient_ID,
    P.Patient_Name,
    P.Gender,

    C.City_Name,
    CO.Country_Name,

    M.Medicine_Key,
    M.Med_Code,
    M.Med_Name,

    MS.Medicine_SubCategory_Key,
    MS.Med_Sub_Ref_No,
    MS.Name AS Medicine_SubCategory,

    MC.Medicine_Category_Key,
    MC.Med_Catg_Code,
    MC.BrandName,
    MC.CompanyName,

    MS.ManufactDate,
    MS.ExpiryDate,
    MS.ModifiedDate,

    F.Quantity,
    F.Unit_Price,
    F.Medication_Cost,
    F.Medication_Count

from FactMedication F
inner join DimPatient P on F.Patient_Key = P.Patient_Key
left join DimPatientAddress PA on P.Location_Key = PA.Location_Key
left join DimCity C on PA.City_Key = C.City_Key
left join DimCountry CO on C.Country_Key = CO.Country_Key
inner join DimMedicine M on F.Medicine_Key = M.Medicine_Key
inner join DimMedicineSubCategory MS on M.Medicine_SubCategory_Key = MS.Medicine_SubCategory_Key
inner join DimMedicineCategory MC on MS.Medicine_Category_Key = MC.Medicine_Category_Key;