CREATE DATABASE  Hospital_Data
 USE Hospital_Data

 SELECT * FROM [dbo].[Hospital_Data]

 ---1.Total Number of Patients 
 ---Write an SQL query to find the total number of patients across all hospitals.

  SELECT Hospital_Name,SUM(Patients_Count) Hospital_Wise_Patients_Count
  FROM Hospital_Data 
  GROUP BY Hospital_Name

  ---2.Average Number of Doctors per Hospital
----Retrieve the average count of doctors available in each hospital.
           SELECT Hospital_Name,AVG(Doctors_Count) AS average_doctors
		   FROM Hospital_Data
		   GROUP BY Hospital_Name

---3.  Top 3 Departments with the Highest Number of Patients
----Find the top 3 hospital departments that have the highest number of patients.
   WITH  number_of_patients AS (     
                 SELECT  Hospital_Name,Department,
				 DENSE_RANK () OVER (PARTITION BY Hospital_Name ORDER BY  MAX(Patients_Count) DESC)highest_number_of_patients
				 FROM Hospital_Data
				 GROUP BY Hospital_Name,Department)
		SELECT TOP 3 *
		FROM number_of_patients
		WHERE highest_number_of_patients ='1'

---4.Hospital with the Maximum Medical Expenses
---Identify the hospital that recorded the highest medical expenses.
      WITH  hospital AS (
	                SELECT Hospital_Name,Medical_Expenses,
			   DENSE_RANK () OVER(PARTITION BY Hospital_Name ORDER BY Medical_Expenses DESC) AS highest_medical_expenses
			   FROM Hospital_Data )
    SELECT Hospital_Name,Medical_Expenses
	FROM hospital
	WHERE highest_medical_expenses ='1'

--5.Daily Average Medical Expenses
---Calculate the average medical expenses per day for each hospital.
    WITH Average_medical_expenses AS (       
	           SELECT Hospital_Name,
			   ROUND(SUM( Medical_Expenses),2)AS Total_expenses ,
			  SUM( DATEDIFF (DAY,Admission_Date,Discharge_Date)+1) AS Total_Day
			  FROM Hospital_Data
			  GROUP BY Hospital_Name)
			  SELECT Hospital_Name ,ROUND((Total_expenses/Total_Day),2) AS  per_day_expenses
			  FROM Average_medical_expenses
 ---6.Longest Hospital Stay
---Find the patient with the longest stay by calculating the difference between Discharge Date and Admission Date.        
     WITH longest_stay  AS (SELECT Hospital_Name,
	                       DENSE_RANK()OVER(ORDER BY  ( DATEDIFF(DAY,Admission_Date,Discharge_Date)+1) DESC )AS Total_Day_Stay
	                         FROM Hospital_Data)
                SELECT Hospital_Name,Total_Day_Stay
				FROM longest_stay
				WHERE Total_Day_Stay ='1'

---7.Total Patients Treated Per City
---Count the total number of patients treated in each city.
             SELECT Location , SUM (Patients_Count) AS Total_patients
			 FROM Hospital_Data
			 GROUP BY Location
---8.Average Length of Stay Per Department
---Calculate the average number of days patients spend in each department
                  SELECT Department,
				  AVG(DATEDIFF(DAY,Admission_Date,Discharge_Date)+1) AS patients_spend_Days
				  FROM Hospital_Data
				  GROUP BY Department
----9.Identify the Department with the Lowest Number of Patients
--Find the department with the least number of patients.
                SELECT TOP 1
				Department,SUM(Patients_Count) AS Total_patients
				FROM Hospital_Data
				GROUP BY Department
				ORDER BY SUM(Patients_Count) ASC
--10.Monthly Medical Expenses Report
--Group the data by month and calculate the total medical expenses for each month.
                SELECT FORMAT(Admission_Date,'MMMM')AS Month_Name,
				     ROUND( SUM(Medical_Expenses),2) AS Total_Expenses
				FROM Hospital_Data
				GROUP BY FORMAT(Admission_Date,'MMMM')

      SELECT * FROM [dbo].[Hospital_Data]








