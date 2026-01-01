# 🏡 Airbnb End-to-End Data Engineering Project

**Repository:** `Airbnb_Snowflake_DBT_Data_Project`

---

## 📋 Overview

This project implements a complete **end-to-end data engineering pipeline** for Airbnb data using modern cloud technologies. It demonstrates best practices in **data warehousing, transformation, and analytics** using **Snowflake**, **dbt (Data Build Tool)**, and **AWS**.

The pipeline processes Airbnb **listings, bookings, and hosts** data through a **medallion architecture (Bronze → Silver → Gold)**, implementing **incremental loading**, **Slowly Changing Dimensions (SCD Type 2)**, and **analytics-ready datasets**.

---

## 🏗️ Architecture

### Data Flow

```
Source Data (CSV)
      ↓
AWS S3
      ↓
Snowflake (Staging)
      ↓
Bronze Layer ──→ Silver Layer ──→ Gold Layer
   (Raw)          (Cleaned)        (Analytics)
```

---

### Technology Stack

* **Cloud Data Warehouse:** Snowflake
* **Transformation Layer:** dbt (Data Build Tool)
* **Cloud Storage:** AWS S3 (implied)
* **Version Control:** Git
* **Python:** 3.12+

**Key dbt Features Used**

* Incremental models
* Snapshots (SCD Type 2)
* Custom macros
* Jinja templating
* Testing and documentation

---

## 📊 Data Model

### Medallion Architecture

#### 🥉 Bronze Layer (Raw Data)

Raw data ingested from staging with minimal transformations:

* `bronze_bookings` – Raw booking transactions
* `bronze_hosts` – Raw host information
* `bronze_listings` – Raw property listings

#### 🥈 Silver Layer (Cleaned Data)

Cleaned and standardized data:

* `silver_bookings` – Validated booking records
* `silver_hosts` – Enhanced host profiles with quality metrics
* `silver_listings` – Standardized listing information with price categorization

#### 🥇 Gold Layer (Analytics-Ready)

Business-ready datasets optimized for analytics:

* `obt` – One Big Table (denormalized bookings, listings, hosts)
* `fact` – Fact table for dimensional modeling
* Ephemeral models for intermediate transformations

---

### Snapshots (SCD Type 2)

Slowly Changing Dimensions used to track historical changes:

* `dim_bookings` – Historical booking changes
* `dim_hosts` – Historical host profile changes
* `dim_listings` – Historical listing changes

---

## 📁 Project Structure

```
AWS_DBT_Snowflake/
├── README.md                           # This file
├── pyproject.toml                      # Python dependencies
├── main.py                             # Main execution script
│
├── SourceData/                         # Raw CSV data files
│   ├── bookings.csv
│   ├── hosts.csv
│   └── listings.csv
│
├── DDL/                                # Database schema definitions
│   ├── ddl.sql                         # Table creation scripts
│   └── resources.sql
│
└── aws_dbt_snowflake_project/         # Main dbt project
    ├── dbt_project.yml                 # dbt project configuration
    ├── ExampleProfiles.yml             # Snowflake connection profile
    │
    ├── models/                         # dbt models
    │   ├── sources/
    │   │   └── sources.yml             # Source definitions
    │   ├── bronze/                     # Raw data layer
    │   │   ├── bronze_bookings.sql
    │   │   ├── bronze_hosts.sql
    │   │   └── bronze_listings.sql
    │   ├── silver/                     # Cleaned data layer
    │   │   ├── silver_bookings.sql
    │   │   ├── silver_hosts.sql
    │   │   └── silver_listings.sql
    │   └── gold/                       # Analytics layer
    │       ├── fact.sql
    │       ├── obt.sql
    │       └── ephemeral/              # Temporary models
    │           ├── bookings.sql
    │           ├── hosts.sql
    │           └── listings.sql
    │
    ├── macros/                         # Reusable SQL functions
    │   ├── generate_schema_name.sql    # Custom schema naming
    │   ├── multiply.sql                # Math operations
    │   ├── tag.sql                     # Categorization logic
    │   └── trimmer.sql                 # String utilities
    │
    ├── analyses/                       # Ad-hoc analysis queries
    │   ├── explore.sql
    │   ├── if_else.sql
    │   └── loop.sql
    │
    ├── snapshots/                      # SCD Type 2 configurations
    │   ├── dim_bookings.yml
    │   ├── dim_hosts.yml
    │   └── dim_listings.yml
    │
    ├── tests/                          # Data quality tests
    │   └── source_tests.sql
    │
    └── seeds/                          # Static reference data```

---

## 🎯 Key Features

### 1️⃣ Source Definitions

**What it does**

* Centralizes configuration of Snowflake source tables
* Validates schema before transformations run
* Enables freshness and volume monitoring

**Why it matters**

Instead of hardcoding references:

```sql
FROM AIRBNB.STAGING.BOOKINGS  -- ❌ fragile
```

dbt sources provide a single source of truth:

```sql
FROM {{ source('staging', 'bookings') }}  -- ✅ traceable
```

**Production value**

* Protects downstream models from upstream schema changes
* Enables full end-to-end lineage
* Supports automated freshness checks

---

### 2️⃣ Medallion Architecture (Bronze / Silver / Gold)

**What it does**

* Bronze: Immutable raw history
* Silver: Cleaned and validated business data
* Gold: Analytics-ready datasets

**Why it matters**

| Challenge                      | Solution                           |
| ------------------------------ | ---------------------------------- |
| Raw data changes break reports | Bronze preserves original state    |
| Business logic inconsistency   | Silver centralizes transformations |
| Complex joins slow BI          | Gold provides optimized views      |

**Production value**

* Safe reprocessing at any layer
* Easier debugging and backfills
* Prevents logic changes from corrupting history

---

### 3️⃣ Incremental Models

```sql
{{ config(materialized='incremental') }}

SELECT *
FROM {{ source('staging', 'bookings') }}

{% if is_incremental() %}
WHERE created_at > (SELECT MAX(created_at) FROM {{ this }})
{% endif %}
```

**Why it matters**

| Full Refresh       | Incremental             |
| ------------------ | ----------------------- |
| Processes all rows | Processes only new data |
| High cost          | Cost-efficient          |
| Long runtimes      | Predictable, fast       |

**Production value**

* Scales from millions to billions of rows
* Reduces Snowflake compute usage by 90%+

---

### 4️⃣ Custom Macros

```sql
{% macro tag(column_name, low=30, medium=70) %}
CASE
    WHEN {{ column_name }} < {{ low }} THEN 'low'
    WHEN {{ column_name }} < {{ medium }} THEN 'medium'
    ELSE 'high'
END
{% endmacro %}
```

**Why it matters**

* Change business logic once, propagate everywhere
* Prevents inconsistent definitions across models

**Production value**

* Centralized logic
* Safer changes
* Cleaner SQL

---

### 5️⃣ Ephemeral Models

```sql
{{ config(materialized='ephemeral') }}

SELECT
    booking_id,
    listing_id,
    UPPER(guest_name) AS guest_name
FROM {{ ref('bronze_bookings') }}
```

**Why it matters**

| Table Model   | Ephemeral Model |
| ------------- | --------------- |
| Creates table | Compiled as CTE |
| Uses storage  | Zero storage    |
| Slower        | Faster          |

**Production value**

* No warehouse clutter
* Modular, readable transformations

---

### 6️⃣ Snapshots (SCD Type 2)

```sql
{% snapshot dim_listings %}
{{
    config(
        target_schema='snapshots',
        unique_key='listing_id',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}
SELECT * FROM {{ ref('silver_listings') }}
{% endsnapshot %}
```

**Why it matters**

Without snapshots:

```
Booking shows updated price ❌
```

With snapshots:

```
Booking joins correct historical price ✅
```

**Production value**

* Accurate “as-of” reporting
* Full audit trail

---

### 7️⃣ Temporal (Point-in-Time) Joins

```sql
SELECT *
FROM fact_bookings fb
JOIN dim_listings dl
  ON fb.listing_id = dl.listing_id
 AND fb.booking_date >= dl.dbt_valid_from
 AND fb.booking_date < COALESCE(dl.dbt_valid_to, '9999-12-31')
```

**Production value**

* Prevents cartesian explosions
* Ensures accurate KPIs

---

### 8️⃣ One Big Table (OBT)

**Why it matters**

* Eliminates complex joins for BI users
* Optimized for dashboards and ad-hoc analysis

**Production value**

* Faster analytics
* Self-service friendly

---

## 📈 Data Quality

* Source validation tests
* Unique & not-null constraints
* Referential integrity tests
* Business rule validations

**Lineage**

* Full DAG visibility from source to analytics

---

## 🔐 Security & Best Practices

* Credentials never committed
* Environment-based secrets
* RBAC in Snowflake
* SQL formatting with `sqlfmt`

---

## 📚 Additional Resources

* dbt Docs: [https://docs.getdbt.com/](https://docs.getdbt.com/)
* Snowflake Docs: [https://docs.snowflake.com/](https://docs.snowflake.com/)
* dbt Best Practices: [https://docs.getdbt.com/guides/best-practices](https://docs.getdbt.com/guides/best-practices)

---
---

## 👤 Author
### Created by : Akshat Jain  
Linkedin Profile : https://www.linkedin.com/in/akshatjainds03/

**Airbnb Data Engineering Pipeline**
Tech: Snowflake, dbt, AWS, Python

---
