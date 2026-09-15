# 📊 Data Warehouse & Analytics Project

Welcome to the **Data Warehouse & Analytics Project**. This project demonstrates an end-to-end Data Warehouse solution built using a Medallion Architecture (Bronze, Silver, Gold layers). The pipeline extracts raw source data (CRM & ERP), cleans and normalizes it, transforms it into a Star Schema, and serves presentation-ready datasets for business intelligence and analytics.

---

## 🎯 Project Objectives

* **Data Architecture**: Implement a structured multi-layer Data Warehouse (Bronze → Silver → Gold).
* **ETL Pipeline**: Extract, transform, and load data seamlessly while maintaining data integrity.
* **Data Quality**: Clean, deduplicate, and validate source data prior to reporting.
* **Dimensional Modeling**: Design a Star Schema optimized for analytical querying.
* **Business Insights**: Enable key business metrics, performance tracking, and KPI generation.

---

## 🔄 Project Workflow & Architecture

The project follows the **Medallion Architecture** pattern:

```text
+------------------+      +--------------------+      +----------------------+
|   Bronze Layer   | ---> |    Silver Layer    | ---> |      Gold Layer      |
|  (Raw Ingestion) |      | (Cleaned/Conformed)|      |     (Star Schema)    |
+------------------+      +--------------------+      +----------------------+
                                                                 |
                                                                 v
                                                      +----------------------+
                                                      | BI & Analytics Tools |
                                                      +----------------------+
```

### System & Architecture Diagrams

#### 1. Data Flow Diagram
[![Data Flow Diagram](docs/images/data-flow.png)](docs/images/data-flow.draw.io)

#### 2. Data Integration Diagram
[![Data Integration Diagram](docs/images/data-integration.png)](docs/images/data-integration.draw.io)

#### 3. Data Model Diagram (Star Schema)
[![Data Model Diagram](docs/images/data-model.png)](docs/images/data-model.draw.io)

---

## 📂 Repository Structure

```text
├── docs/
│   ├── images/
│   │   ├── data-flow.png
│   │   ├── data-flow.draw.io
│   │   ├── data-integration.png
│   │   ├── data-integration.draw.io
│   │   ├── data-model.png
│   │   └── data-model.draw.io
│   └── gold_layer_data_catalog.md
├── scripts/
│   ├── bronze/
│   │   └── data_quality_checks.sql
│   ├── silver/
│   │   └── ddl_silver_tables.sql
│   └── gold/
│       └── ddl_gold_views.sql
├── README.md
└── LICENSE
```

---

## 🛠️ Data Warehouse Layers

### 1. Bronze Layer (Raw Ingestion & Quality Control)
* **Purpose**: Ingests raw data directly from CRM and ERP systems.
* **Key Operations**: Automated SQL auditing scripts check for primary key duplicates, NULL values, string whitespace issues, and out-of-range dates.

### 2. Silver Layer (Cleansing & Transformation)
* **Purpose**: Standardizes data types, enforces schema constraints, and handles missing or inconsistent domain values.
* **Tables**:
  * `silver.crm_cust_info`
  * `silver.crm_prd_info`
  * `silver.crm_sales_details`
  * `silver.erp_loc_a101`
  * `silver.erp_cust_az12`
  * `silver.erp_px_cat_giv2`

### 3. Gold Layer (Presentation & Star Schema)
* **Purpose**: Delivers analytical views modeled into dimensions and facts for reporting.

#### Gold Data Catalog Overview

##### `gold.dim_cust`
* **Purpose**: Stores customer details enriched with demographic and geographic data.

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| **cust_key** | INT | Surrogate key uniquely identifying each customer record in the dimension table. |
| **cust_id** | INT | Unique numerical identifier assigned to each customer from the source system. |
| **cust_number** | NVARCHAR(80) | Alphanumeric identifier representing the customer, used for tracking and cross-system joins. |
| **first_name** | NVARCHAR(80) | The customer's first name. |
| **last_name** | NVARCHAR(80) | The customer's last name or family name. |
| **gender** | VARCHAR(20) | Standardized gender of the customer (e.g., 'Male', 'Female', 'UN'). |
| **country** | NVARCHAR(78) | The country of residence for the customer. |
| **marital_status** | VARCHAR(20) | The marital status of the customer. |
| **birth_date** | DATE | The date of birth of the customer. |

##### `gold.dim_prd`
* **Purpose**: Stores product details enriched with category hierarchy and maintenance details.

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| **product_key** | INT | Surrogate key uniquely identifying each active product record in the dimension table. |
| **product_id** | INT | Unique numerical identifier assigned to each product. |
| **categorie_id** | NVARCHAR(80) | Identifier representing the product category lookup reference. |
| **product_number** | NVARCHAR(80) | Alphanumeric code representing the product, used for linking to sales facts. |
| **product_name** | NVARCHAR(80) | The official name of the product. |
| **cost** | INT | The unit cost of the product. |
| **categorie** | NVARCHAR(80) | The main category to which the product belongs. |
| **sub_categorie** | NVARCHAR(40) | The sub-category detailing the product classification. |
| **product_line** | NVARCHAR(40) | The specific product line or segment. |
| **maintenance** | NVARCHAR(10) | Maintenance requirements or service code for the product. |
| **start_date** | DATE | The effective start date from when the product record became active. |
| **end_date** | DATE | The expiration date of the product record (NULL indicates an active product). |

##### `gold.fact_sales`
* **Purpose**: Stores sales transactions and links them to customer and product dimensions for analytical reporting.

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| **order_number** | NVARCHAR(80) | Alphanumeric identifier for the unique sales order line item. |
| **product_key** | INT | Foreign key referencing `gold.dim_prd` to identify the product purchased. |
| **cust_key** | INT | Foreign key referencing `gold.dim_cust` to identify the purchasing customer. |
| **order_date** | DATE | The date on which the order was placed. |
| **ship_date** | DATE | The date on which the order was shipped. |
| **due_date** | DATE | The date on which payment or delivery is due. |
| **sales** | INT | Total monetary value of the sales order line item. |
| **quantity** | INT | The number of product units purchased. |
| **price** | INT | The unit price of the product at the time of purchase. |

---

## 🛠️ Technologies Used

* **SQL (T-SQL)**: Data extraction, cleansing, transformation, view creation, and analytical modeling.
* **Draw.io**: System architecture, data flow, and dimensional modeling diagrams.
* **Data Warehouse**: Multi-tier Medallion Architecture (Bronze, Silver, Gold).
* **Git & GitHub**: Source control, documentation, and release management.

---

## 👨‍💼 About Me

I am an aspiring Business Analyst focused on leveraging data warehousing and analytics to solve complex business problems, define key metrics, and support data-driven decision-making. Through this project, I developed hands-on expertise in SQL-based ETL processing, data quality assurance, star schema modeling, and documentation standards.

---

## 📄 License

This project is licensed under the **MIT License**. See the `LICENSE` file for details.
