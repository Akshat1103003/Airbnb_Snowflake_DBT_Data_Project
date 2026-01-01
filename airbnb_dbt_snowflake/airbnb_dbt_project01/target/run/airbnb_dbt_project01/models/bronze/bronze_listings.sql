
  
    

create or replace transient table AIRBNB_DB.dbt_schema_bronze.bronze_listings
    
    
    
    as (select * from airbnb_db.staging_schema.listings
    )
;


  