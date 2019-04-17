
SET SQL_SAFE_UPDATES = 0;

-- Creating bajaj1 table

UPDATE `bajaj auto`
   SET Date = STR_TO_DATE(`Date`,'%d-%M-%Y ');          -- updating date format 

CREATE TEMPORARY TABLE bajaj_1 AS
   SELECT ROW_NUMBER() OVER (ORDER BY Date ASC) as RowNumber,Date, `Close Price`,
     AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS 19 PRECEDING) AS '20 Day MA', 
	 AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS 49 PRECEDING) AS '50 Day MA'
	 FROM `bajaj auto`;          -- Creating temporary table to store  20 day MA and 50 day MA with Date and rownumber

CREATE TABLE bajaj1 AS
     SELECT Date,`Close Price`,
       IF(RowNumber > 19, `20 Day MA`, ' ') `20 Day MA`,
       IF(RowNumber > 49, `50 Day MA`, ' ') `50 Day MA`
       from bajaj_1;            -- Creating bajaj1 table to store Date, 20 day MA and 50 day MA
       


-- Creating eicher1 table

UPDATE `eicher motors`
   SET Date = STR_TO_DATE(`Date`,'%d-%M-%Y ');          -- updating date format 

CREATE TEMPORARY TABLE eicher_1 AS
   SELECT ROW_NUMBER() OVER (ORDER BY Date ASC) as RowNumber,Date, `Close Price`,
     AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS 19 PRECEDING) AS '20 Day MA', 
     AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS 49 PRECEDING) AS '50 Day MA'
     FROM `eicher motors`;       -- Creating temporary table to store  20 day MA and 50 day MA with Date and rownumber

CREATE TABLE eicher1 AS
   SELECT Date,`Close Price`,
	 IF(RowNumber > 19, `20 Day MA`, ' ') `20 Day MA`,
	 IF(RowNumber > 49, `50 Day MA`, ' ') `50 Day MA`
	 from eicher_1;             -- Creating eicher1 table to store Date, 20 day MA and 50 day MA
       


-- Creating hero1 table

UPDATE `hero motocorp`
   SET Date = STR_TO_DATE(`Date`,'%d-%M-%Y ');          -- updating date format 

CREATE TEMPORARY TABLE hero_1 AS
   SELECT ROW_NUMBER() OVER (ORDER BY Date ASC) as RowNumber,Date, `Close Price`,
     AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS 19 PRECEDING) AS '20 Day MA', 
     AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS 49 PRECEDING) AS '50 Day MA'
     FROM `hero motocorp`;       -- Creating temporary table to store  20 day MA and 50 day MA with Date and rownumber

CREATE TABLE hero1 AS
   SELECT Date,`Close Price`,
	 IF(RowNumber > 19, `20 Day MA`, ' ') `20 Day MA`,
	 IF(RowNumber > 49, `50 Day MA`, ' ') `50 Day MA`
	 from hero_1;               -- Creating hero1 table to store Date, 20 day MA and 50 day MA
       


-- Creating infosys1 table

UPDATE infosys
   SET Date = STR_TO_DATE(`Date`,'%d-%M-%Y ');          -- updating date format 

CREATE TEMPORARY TABLE infosys_1 AS
   SELECT ROW_NUMBER() OVER (ORDER BY Date ASC) as RowNumber,Date, `Close Price`,
     AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS 19 PRECEDING) AS '20 Day MA', 
     AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS 49 PRECEDING) AS '50 Day MA'
     FROM infosys;              -- Creating temporary table to store  20 day MA and 50 day MA with Date and rownumber

CREATE TABLE infosys1 AS
   SELECT Date,`Close Price`,
	 IF(RowNumber > 19, `20 Day MA`, ' ') `20 Day MA`,
	 IF(RowNumber > 49, `50 Day MA`, ' ') `50 Day MA`
	 from infosys_1;           -- Creating infosys1 table to store Date, 20 day MA and 50 day MA
       


-- Creating tcs1 table

UPDATE tcs
   SET Date = STR_TO_DATE(`Date`,'%d-%M-%Y ');          -- updating date format 

CREATE TEMPORARY TABLE tcs_1 AS
   SELECT ROW_NUMBER() OVER (ORDER BY Date ASC) as RowNumber,Date, `Close Price`, 
     AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS 19 PRECEDING) AS '20 Day MA', 
     AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS 49 PRECEDING) AS '50 Day MA'
     FROM tcs;                  -- Creating temporary table to store  20 day MA and 50 day MA with Date and rownumber

CREATE TABLE tcs1 AS
   SELECT Date,`Close Price`,
	 IF(RowNumber > 19, `20 Day MA`, ' ') `20 Day MA`,
	 IF(RowNumber > 49, `50 Day MA`, ' ') `50 Day MA`
	 from tcs_1;               -- Creating tcs1 table to store Date, 20 day MA and 50 day MA
       


-- Creating tvs1 table

UPDATE `tvs motors`
   SET Date = STR_TO_DATE(`Date`,'%d-%M-%Y ');          -- updating date format 

CREATE TEMPORARY TABLE tvs_1 AS
   SELECT ROW_NUMBER() OVER (ORDER BY Date ASC) as RowNumber,Date, `Close Price`,
     AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS 19 PRECEDING) AS '20 Day MA', 
     AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS 49 PRECEDING) AS '50 Day MA'
     FROM `tvs motors`;          -- Creating temporary table to store  20 day MA and 50 day MA with Date and rownumber

CREATE TABLE tvs1 AS
   SELECT Date,`Close Price`,
	 IF(RowNumber > 19, `20 Day MA`, ' ') `20 Day MA`,
	 IF(RowNumber > 49, `50 Day MA`, ' ') `50 Day MA`
	 from tvs_1;                -- Creating tvs1 table to store Date, 20 day MA and 50 day MA
       


-- Creating master data table using inner joint order by date

create table `master table` as
select b.Date, b.`Close Price` as Bajaj, t.`Close Price` as TCS, tv.`Close Price` as TVS,
     i.`Close Price` as Infosys, e.`Close Price` as Eicher, h.`Close Price` as Hero
 FROM bajaj1 b
 INNER JOIN eicher1 e
  ON b.Date = e.Date
  INNER JOIN hero1 h
  ON b.Date = h.Date
  INNER JOIN infosys1 i
  ON b.Date = i.Date
  INNER JOIN tcs1 t
  ON b.Date = t.Date
  INNER JOIN tvs1 tv
  ON b.Date = tv.Date
  order by Date;



-- Generating buy, sell and hold signal

CREATE TABLE bajaj2 AS
select Date,`Close Price`,
    (CASE WHEN RowNumber > 49 && `20 Day MA` > `50 Day MA` THEN "BUY"
          WHEN RowNumber > 49 && `20 Day MA` < `50 Day MA` THEN "SELL"
          ELSE "HOLD"
       END ) AS 'Signal'
    FROM bajaj_1
    ORDER BY Date;            -- Creating bajaj2 table to store Date, Close price and signal



CREATE TABLE eicher2 AS
select Date,`Close Price`,
    (CASE WHEN RowNumber > 49 && `20 Day MA` > `50 Day MA` THEN "BUY"
          WHEN RowNumber > 49 && `20 Day MA` < `50 Day MA` THEN "SELL"
          ELSE "HOLD"
       END ) AS 'Signal'
    FROM eicher_1
    ORDER BY Date;            -- Creating eicher2 table to store Date, Close price and signal



CREATE TABLE hero2 AS
select Date,`Close Price`,
    (CASE WHEN RowNumber > 49 && `20 Day MA` > `50 Day MA` THEN "BUY"
          WHEN RowNumber > 49 && `20 Day MA` < `50 Day MA` THEN "SELL"
          ELSE "HOLD"
       END ) AS 'Signal'
    FROM hero_1
    ORDER BY Date;            -- Creating hero2 table to store Date, Close price and signal


CREATE TABLE infosys2 AS
select Date,`Close Price`,
    (CASE WHEN RowNumber > 49 && `20 Day MA` > `50 Day MA` THEN "BUY"
          WHEN RowNumber > 49 && `20 Day MA` < `50 Day MA` THEN "SELL"
          ELSE "HOLD"
       END ) AS 'Signal'
    FROM infosys_1
    ORDER BY Date;            -- Creating infosys2 table to store Date, Close price and signal



CREATE TABLE tcs2 AS
select Date,`Close Price`,
    (CASE WHEN RowNumber > 49 && `20 Day MA` > `50 Day MA` THEN "BUY"
          WHEN RowNumber > 49 && `20 Day MA` < `50 Day MA` THEN "SELL"
          ELSE "HOLD"
       END ) AS 'Signal'
    FROM tcs_1
    ORDER BY Date;            -- Creating tcs2 table to store Date, Close price and signal



CREATE TABLE tvs2 AS
select Date,`Close Price`,
    (CASE WHEN RowNumber > 49 && `20 Day MA` > `50 Day MA` THEN "BUY"
          WHEN RowNumber > 49 && `20 Day MA` < `50 Day MA` THEN "SELL"
          ELSE "HOLD"
       END ) AS 'Signal'
    FROM tvs_1
    ORDER BY Date;            -- Creating tvs2 table to store Date, Close price and signal



-- User defined function to take date in format yyyy-mm-dd as input and return corresponding signal for bajaj 

DELIMITER $$
 create procedure bajaj_signal
   (in n char(20))
  begin
   SELECT `Signal`
   FROM bajaj2
   WHERE DATE(`date`) = n;
  end $$
DELIMITER ;        -- Store procedure

call bajaj_signal ('2015-11-3');  -- Input the date to check for the signal in format yyyy-mm-dd