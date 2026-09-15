# 📖 Data Catalog — Gold Layer

## Overview
The Gold layer represents the final presentation and analytical layer of the data warehouse. It transforms cleaned data into a **Star Schema** model, consisting of dimensional tables and fact tables designed for business intelligence, ad-hoc querying, and reporting. 

The primary goal of this layer is to simplify data structures, enforce consistent business logic, provide surrogate keys for relationship mapping, and deliver optimized performance for reporting tools.

---

### 1. gold.dim_cust

* **Purpose**: Stores customer details enriched with demographic and geographic data.
* **Columns**:

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| **cust_key** | INT | Surrogate key uniquely identifying each customer record in the dimension table. |
| **cust_id** | INT | Unique numerical identifier assigned to each customer from the source system. |
| **cust_number** | NVARCHAR(80) | Alphanumeric identifier representing the customer, used for tracking and cross-system joins. |
| **first_name** | NVARCHAR(80) | The customer's first name. |
| **last_name** | NVARCHAR(80) | The customer's last name or family name. |
| **gender** | VARCHAR(20) | Standardized gender of the customer (e.g., 'Male', 'Female', 'UN'). |
| **country** | NVARCHAR(78) | The country of residence for the customer. |
| **martial_status** | VARCHAR(20) | The marital status of the customer. |
| **birth_date** | DATE | The date of birth of the customer. |

---

### 2. gold.dim_prd

* **Purpose**: Stores product details enriched with category hierarchy and maintenance details.
* **Columns**:

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

---

### 3. gold.fact_sales

* **Purpose**: Stores sales transactions and links them to customer and product dimensions for analytical reporting.
* **Columns**:

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
