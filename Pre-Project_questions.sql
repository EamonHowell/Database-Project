-- question 1: When the U.S. is importing mammals, fish, and birds, from where are most of the animals coming from? (aggregation)
SELECT exporter, COUNT(exporter)                       -- select exporter and the number of times it appears
FROM trade_info_2003
WHERE importer = 'US'                                  -- from table where the importer is the US
GROUP BY exporter                                      -- group by the exporter
HAVING COUNT(exporter) = (                             -- where the exporter count is equal to
    SELECT MAX(count_export)                           -- the max of 
    FROM (
            SELECT exporter, COUNT(exporter) AS count_export   -- the number of time the exporter appears when the importer is the US
            FROM trade_info_2003
            WHERE importer = 'US'
            GROUP BY exporter
    ) AS number_exports
);


-- question 2: Of all the traded mammals whose are threatened with extinction, who were traded as trophies, what is the animals name? (join)
SELECT common_name                        -- select the common name 
FROM sci_name_common_name
JOIN (                                   -- join the 
    SELECT taxon                        -- will select the taxon 
    FROM trade_info_2003
    WHERE class = 'Mammalia' AND appendix = 'I' AND term = 'trophies'
    GROUP BY taxon
    HAVING COUNT(taxon) = (     -- where it is mammal, is threatened with extinction and was a trophy and the count of the taxon 
        SELECT MAX(number_trade)
        FROM (
            SELECT taxon, COUNT(taxon) AS number_trade    -- is the max of the possible counts of all trades where it was a mammal, threatened with extinction and a trophy.
            FROM trade_info_2003
            WHERE class = 'Mammalia' AND appendix = 'I' AND term = 'trophies'
            GROUP BY taxon
        ) AS trades_threaten
    )
) AS sci_name 
ON sci_name.taxon = sci_name_common_name.offical_name;  -- join the taxon with the scientific name



-- Question 3: What is the most common type of import of the Common Minke Whale? 
WITH term_count AS (                                   -- common table expression 
    SELECT term, COUNT(term) as number_terms        -- select the type of trade and number of times it occurs 
    FROM trade_info_2003
    WHERE taxon = (                                 -- where the taxon is 
        SELECT offical_name
        FROM sci_name_common_name                   -- the official name, when the common name is the common minke whale
        WHERE common_name = 'Common minke whale'
    )
    GROUP BY term
)
SELECT term, number_terms                     -- select the type and count of trades
FROM term_count
WHERE number_terms = (                      -- where that count is the max possible count
    SELECT MAX(number_terms)
    FROM term_count
);


-- Question 4: Of all the types of animals (mammals, birds, fish), which has the most number of endangered species being traded?
WITH appendix_class AS (
    SELECT class, appendix, COUNT(appendix) as count_append   -- count th enumber of times each threatened number occurs by class of traded animal
    FROM trade_info_2003
    GROUP BY class, appendix
)
SELECT class                  -- select the class from 
FROM appendix_class
WHERE count_append = (         -- where the count of the appendix is
    SELECT MAX(count_append)     -- the max count when the appendix is most threatend (I)
    FROM appendix_class
    WHERE appendix = 'I'
);


