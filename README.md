# BuildingDWH.SSIS

This project invovles using Microsoft SQL Server Management Studio and SSIS to build a pipeline using ETL mapping from Staging to DWH. 
I performed this project in two parts, first I loaded the available data to SSMS, staged them and further loaded them to SSIS. Next, I worked on making the necessary transformation based on ETL mapping and loaded from the staging source to the datawarehouse. Once the datawarehouse was built and running successfully, I further modified the pipeline by adding incremental loading which would monitor for changes and updates to prevent duplicate information from being re-loaded. 


