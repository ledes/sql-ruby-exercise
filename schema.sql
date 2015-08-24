-- If you want to run this schema repeatedly you'll need to drop
-- the table before re-creating it. Note that you'll lose any
-- data if you drop and add a table:

DROP TABLE IF EXISTS articles;

-- Define your schema here:

CREATE TABLE articles (
   title varchar(250),
   url varchar(250),  --UNIQUE WILL make sure there aren't users introducing the same url
   description varchar(500)
);


 --url varchar(250) UNIQUE,
