/* 
    Pre-Project
    Author: Eamon Howell
    
 */



/*
    Part 1: add tables as they are into basic tables
*/
DROP VIEW trade_info_2003;
DROP VIEW trade_information;
DROP TABLE IF EXISTS cites_trade;
DROP TABLE IF EXISTS sci_name_common_name;




CREATE TABLE sci_name_common_name (
    offical_name TEXT,
    common_name TEXT
);



CREATE TABLE cites_trade (
    id BIGINT,
    year INTEGER,
    appendix TEXT,
    taxon TEXT,
    class TEXT,
    trade_order TEXT,
    family TEXT,
    genus TEXT,
    term TEXT,
    quantity FLOAT,
    unit TEXT,
    importer TEXT,
    exporter TEXT,
    origin TEXT,
    purpose TEXT,
    source TEXT,
    reporter TEXT,
    import_id TEXT,
    export_id TEXT, 
    origin_id TEXT
);

\COPY sci_name_common_name FROM 'specList.csv' WITH CSV HEADER;

\COPY cites_trade FROM 'trade_db_18.csv' WITH CSV HEADER;






/*
    Part 2: Clean the data
*/

-- Uniprot
SELECT COUNT(*)
FROM sci_name_common_name
WHERE offical_name IS NULL;

SELECT COUNT(*)
FROM sci_name_common_name
WHERE common_name IS NULL;


-- Wildlife Trade Database
-- Remove columns about CITES data
CREATE VIEW trade_information AS
SELECT id, year, appendix, taxon, class, trade_order, family, genus, term, quantity, unit, importer, exporter
FROM cites_trade;



-- filter down to birth year, animal bird and fish
CREATE VIEW trade_info_2003 AS
SELECT * FROM trade_information
WHERE year = 2003 
AND (class IN ('Mammalia', 'Aves', 'Actinopteri'));





/*
    Part 3: Analyze
*/

-- question 1: When the U.S. is importing mammals, fish, and birds, from where are most of the animals coming from? (aggregation)

