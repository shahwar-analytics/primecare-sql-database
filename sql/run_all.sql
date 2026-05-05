
-- Create and select database
CREATE DATABASE IF NOT EXISTS primecaredb;
USE primecaredb;

-- Run all scripts in order
SOURCE sql/01_create_tables.sql;
SOURCE sql/02_insert_data.sql;
SOURCE sql/03_updates.sql;
SOURCE sql/04_basic_queries.sql;
SOURCE sql/05_advanced_queries.sql;