# Data Warehouse and Analytics Project

Welcome to the Data Warehouse and Analytics Project repository!
This project demonstrates a comprehensive data warehousing and analytics solution , from building a data warehouse to generating actionable insights. Designed as a portfolio project highlights industry best practices in data engineering and analytics.

The goal of this project is to solve a real-world data fragmentation problem: consolidating sales, customer, and product data from two disparate source systems (CRM and ERP) into a single centralized Single Source of Truth (SSOT). The warehouse follows best engineering practices, adopting the Medallion Architecture (Bronze ➔ Silver ➔ Gold) and Dimensional Modeling (Star Schema) to support analytics, reporting, and executive decision-making.

--🎯 Business Problem & Requirements Before building the warehouse, the organization faced severe operational and reporting challenges:
Data Silos: Sales data was split across CRM and ERP CSV extracts, making cross-system reporting manual, error-prone, and slow. 
Poor Data Quality: Sources contained duplicate records, invalid dates, missing values, unstandardized codes, and inconsistent formatting. 
No Unified Model: Lack of a standardized dimensional schema forced analysts to perform ad-hoc data joining repeatedly. 

--Key Technical Requirements 

1.Source Integration: Ingest 6 CSV files across two source systems (CRM & ERP).                                              
2.Data Cleansing: Detect and resolve data quality issues prior to analytical exposure.
3.Unified Schema: Integrate disconnected entities into a single, user-friendly Star Schema.
4.Data Lineage & Traceability: Maintain auditability across all processing layers. 
5.Documentation & Quality Gates: Provide a complete data catalog, data flow visualizers, and data quality testing scripts. 

--🏗️ Data Architecture (Medallion Pattern) The data warehouse implements the Medallion Architecture, dividing data processing into three distinct layers to ensure clear
Separation of Concerns:
