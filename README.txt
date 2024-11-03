Author: Eamon Howell

DATASET

    For this project I am using two data sets. One is for the actual data, and the other is for the person using the data to have an easier time understanding it.
    NOTE: I am using the citations that were provided by the datasets in my documentation. 


    UniProt Controlled Vocabulary of Species:
        Info:
            The data set that was used for easier understanding was a text file which contains a list of the official scientific name, common name and synonym of any 
            organism as well as the taxonomic kingdom for that species. This data set was extremly helpful in being able to understand what which species of animal
            were being traded, as common names are easier to grasp than a scientific name. 
        First Rows:
            Official (scientific) name,Common name  
            Aedes albopictus densovirus (isolate Boublik/1994),AalDNV
            Adeno-associated virus 2,AAV-2

        Citation: 
            UniProt Knowledgebase:
            Swiss-Prot Protein Knowledgebase
            TrEMBL Protein Database
            SIB Swiss Institute of Bioinformatics; Geneva, Switzerland
            European Bioinformatics Institute (EBI); Hinxton, United Kingdom
            Protein Information Resource (PIR); Washington DC, USA
            https://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/docs/speclist.txt
        

    

    CITES WildLife Trade Database:
        Info:
            The data set which actually contains the data I want to understand is from the Convention on International Trade in Endangered Species of Wild Fauna and Flora
            (CITES) which monitors, reports and provides recomendations on international species trade. They track about 5000 animal species and 29000 plant species being 
            imported and exported in and out of countries which have been seperated into groups based on vunerability.
        First Rows:
            "Id","Year","Appendix","Taxon","Class","Order","Family","Genus","Term","Quantity","Unit","Importer","Exporter","Origin","Purpose","Source","Reporter.type","Import.permit.RandomID","Export.permit.RandomID","Origin.permit.RandomID"
            "1697622818",2003,"II","Acampe praemorsa","","Orchidales","Orchidaceae","Acampe","live",50,"","HK","TH","","T","A","E","","387fcd3c1d",""
            "6743519518",2003,"II","Acampe praemorsa","","Orchidales","Orchidaceae","Acampe","live",5,"","CZ","TH","","T","A","E","","b91012850c",""

        Citation:
            Full CITES Trade Database Download. Version 2023.1. Compiled by UNEP-WCMC, Cambridge, UK for the CITES Secretariat, Geneva, Switzerland. Available at: trade.cites.org


Cleaning:
    UniProt Controlled Vocabulary of Species:
        The first thing that I needed to do was seperate the data into something that I could use. Since the original text file contained the information on how to understand
        the data as well as the contributers and citations, I needed to seperate the data from the other information. To do this I used a python program that I wrote to seperate
        out the lines of scientific and common names from the rest of the file. Once I did that, I placed the lines into a csv file so that I would be able to add it to a table.

        Starting Table:
            CREATE TABLE sci_name_common_name (
                offical_name TEXT,
                common_name TEXT
            );

        Quality verification:

            The first thing that should be done, is to count the number of null exist in the offical_name column. In the event that any exist, then
            we will need to remove that row because without the scientific name, the common name will not be helpful in clarifying the animal that is
            traded in the main table.

            SELECT COUNT(*)
            FROM sci_name_common_name
            WHERE offical_name IS NULL;

             count 
            -------
                0
            (1 row)

            Since there were no null values in the offical_name, it means that each common name is linked to a scientific name and so we can take any 
            scientific name and find what it's common name is.


            Since we know that there are no null values in the scientific name, we need to see if there are any in the common names. If there are it
            means that the scientific name does link to a common name and that the row will need to be removed as just having the scientific name 
            will not help us to clarify the animal being traded.

            SELECT COUNT(*)
            FROM sci_name_common_name
            WHERE common_name IS NULL;

            count 
            -------
                0
            (1 row)

            Since there were no null values in the common_name, it means that each scientific name and common name has a match. This means that each time
            we try to figure out the species being traded on the main table, we can and that when we want to know if a species is being traded, we can take
            the common name and get the scientific name to track in the main table. 







    CITES WildLife Trade Database:
        The original data set was a series of csv files that seperated the data into pieces. The entire data set was approximetly 25 million data entries
        which was far more than I really wanted to deal with. So I only used one csv file (years ~2001-2004,. 500,000 entries) to help decrease the amount
        of data that I was going to go through. I then created my table and added the csv file to it. It contained a fair amount of information that I 
        wasnt really interested in or could really use as it was randomized to help with keeping things confidential. Since some of the columns would
        make no sense unless I worked for CITES, I removed them. This however still meant that there was still 500,000 entries in the table, so I chose to further
        limit the entries based on a few factors. First I only wanted to look at things for my birth year (2003). In the year 2003, I was only really interested
        in the trade that occured when the animal was a mammal, bird, or fish (when compared to plant, coral, etc). This further narrowed down the number
        of entries to a more manageable 64818.


        Starting Table:
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

        Quality verification:

            As stated above, the first thing that I needed to do, was remove the data that CITES had randomized to preserve confidentiality. This meant that 
            I needed to remove the columns on the puprose, source, reporter, import_id, export_id, and origin_id. This was done through a CREATE VIEW so that
            I would not be touching the original data that was collected. 


            CREATE VIEW trade_information AS
            SELECT id, year, appendix, taxon, class, trade_order, family, genus, term, quantity, unit, importer, exporter
            FROM cites_trade;

            csci403=> SELECT * FROM trade_information LIMIT 5;
                id     | year | appendix |      taxon       | class | trade_order |   family    | genus  |     term     | quantity | unit | importer | exporter 
            ------------+------+----------+------------------+-------+-------------+-------------+--------+--------------+----------+------+----------+----------
            1697622818 | 2003 | II       | Acampe praemorsa |       | Orchidales  | Orchidaceae | Acampe | live         |       50 |      | HK       | TH
            6743519518 | 2003 | II       | Acampe praemorsa |       | Orchidales  | Orchidaceae | Acampe | live         |        5 |      | CZ       | TH
            8493380918 | 2003 | II       | Acampe praemorsa |       | Orchidales  | Orchidaceae | Acampe | live         |        5 |      | CZ       | TH
            3668038718 | 2004 | II       | Acampe praemorsa |       | Orchidales  | Orchidaceae | Acampe | dried plants |        1 |      | FR       | KH
            5767271118 | 2003 | II       | Acampe rigida    |       | Orchidales  | Orchidaceae | Acampe | live         |        3 |      | DK       | TH
            (5 rows)


            As we can see in the View above, everything that was randomized by CITES was removed and the only data that is left is the information about the 
            acutal trade itself from the species in question, to the year, and where the trade was happening.


            Once that was completed I needed to further limit the information down to the year 2003, where the trade was an mammal, bird, or fish. This was 
            rather simple to do as all that I needed to do was grab the appropriate year and where the class of the traded animal was correct.


            CREATE VIEW trade_info_2003 AS
            SELECT * FROM trade_information
            WHERE year = 2003 
            AND (class IN ('Mammalia', 'Aves', 'Actinopteri'));

            csci403=> SELECT * FROM trade_info_2003 LIMIT 5;
                id     | year | appendix |         taxon         | class |  trade_order  |    family    |   genus   |   term    | quantity | unit | importer | exporter 
            ------------+------+----------+-----------------------+-------+---------------+--------------+-----------+-----------+----------+------+----------+----------
            1394302718 | 2003 | II       | Accipiter castanilius | Aves  | Falconiformes | Accipitridae | Accipiter | specimens |        1 |      | US       | GA
            3147895418 | 2003 | II       | Accipiter gentilis    | Aves  | Falconiformes | Accipitridae | Accipiter | bodies    |        1 |      | MX       | ES
            3444151018 | 2003 | II       | Accipiter gentilis    | Aves  | Falconiformes | Accipitridae | Accipiter | live      |        1 |      | DE       | CZ
            8000667918 | 2003 | II       | Accipiter gentilis    | Aves  | Falconiformes | Accipitridae | Accipiter | live      |        1 |      | CZ       | DE
            2559281318 | 2003 | II       | Accipiter gentilis    | Aves  | Falconiformes | Accipitridae | Accipiter | feathers  |       10 |      | DE       | SK
            (5 rows)

            With the added filtering of the above VIEW I was able to go from 500,000 rows to about 65,000 rows which makes things much more manageable. All of that being
            said, at this point the only null values that can exist in the table is in the unit column. Every other column needs some form of information because it is 
            needed. We need to know when the year was, the threatened status of the animal, the scientific name (taxon), the class through genus of the animal, the type 
            of trade (term), the quantity, the importer and exporter. Without any of these nothing really makes a whole lot of sense. The units can be a null value however
            because the units only make sense when the term is something that needs units. If the term is something like "bodies" then the quantity is already refering to 
            the number of bodies so no units are needed. But if the term was something like "eggs" then the weight of the eggs might be a good idea depending on the species
            laying the egg.

    
Analyze:
    Question 1: When the U.S. is importing mammals, fish, and birds, from where are most of the animals coming from?

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

         exporter | count 
        ----------+-------
         CA       | 21055

        The query above is to try and find the country who is doing the most exporting to the US, when talking about mammals, birds, or fish in 2003. As we can see above,
        the country doing the most exporting of animals to the US is CA (Canada). The query counts the number of times each exporter appears while selecting the count that
        equals the maximum value of all the exporter counts. This question is interesting because it is nice to know where things are coming from. If some new disease that
        is carried by some traded species that we dont know, then it makes sense to start from where most of the traded species come from and go from there.


    Question 2: Of all the traded mammals whose are threatened with extinction, who were traded as trophies, what is the animals name?

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

     common_name 
     -------------
     Cheetah

     The query above is to try and find the name of the mammal species who are threatened with extinction and are the most common trophy animal in 2003. As we can see above,
     that animal is the Cheetah. This query counts the number of times each species occures with the criteria, picks the max count, uses that to find the animal name, and 
     then joins that name to the sci_name_common_name table to put the animal name into one that we can understand. This query is interesting because it shows just how 
     strange people are. Even if the animal is threatened with extinction, people still want to hunt it, not for some necesity but instead for a trophy.


    Question 3: What is the most common type of import of the Common Minke Whale? 

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

       term   | number_terms 
    ----------+--------------
     carvings |           82

     The query above is trying to find the most common type of sale/ trade when the animal in question is a Common Minke Whale. As we can see above the 
     most common type of trade is of a carving involving the animal itself. The query makes a common table expression where we grab the scientific name
     of the Common Minke Whale, and then select the types of trade as well as the number of times it occurs where the taxon is the official name that was 
     found. This query is interseting because for people who want to help the Common Minke Whale they can see what most trades are of and then try to limit
     or find alternatives to using the Common Minke Whale.


    Question 4: Of all the types of animals (mammals, birds, fish), which has the most number of endangered species being traded? 

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

      class   
    ----------
    Mammalia

    The query above is trying to examine which class of animal, mammal, bird, or fish has the most trades occuring with an endangered species. As we can
    see above, the most common class of animal with the most number of endangered animal trades is the Mammal.  The query uses a common table expression 
    to group the appendix and classes together while counting the number of times each appendix occurs. We then select the class from this CTE where the
    count is equal to the MAX appendix count when the appendix is of type I (endangered). This question is interesting because it is important to know 
    where one should focus their efforts in trying to help endangered species. If you have a limited budget then you would want to make the most impact
    with what you have so it would be nice to know the class of animal that would need the most help in preventing trade. 

