ALTER SESSION SET NLS_DATE_FORMAT='DD-MON-YYYY HH:MI:SS AM';
ALTER session set NLS_TIMESTAMP_TZ_FORMAT = 'DD-MON-YYYY HH:MI:SS AM TZR';

CREATE TABLE TestDateTimeTable (
       PK                           NUMBER GENERATED ALWAYS AS IDENTITY,
       COL_DATE                     DATE,
       COL_DATE_ONLY                DATE,
       COL_TIME_ONLY                INTERVAL DAY(0) TO SECOND,
       COL_TIMESTAMP                TIMESTAMP (9),
       COL_TIMESTAMPTZ              TIMESTAMP (9) WITH TIME ZONE,
       COL_TIMESTAMPTZL             TIMESTAMP (9) WITH LOCAL TIME ZONE,
       COL_INTERVAL_YEAR_TO_MONTH   INTERVAL YEAR TO MONTH,
       COL_INTERVAL_DAY_TO_SECOND   INTERVAL DAY(9) TO SECOND(9),
       PRIMARY KEY(PK)
);

CREATE TABLE TestIntervalTable (
       ID                   NUMBER,
       COL_YEAR3_TO_MONTH   INTERVAL YEAR(3) TO MONTH,
       COL_YEAR3            INTERVAL YEAR(3) TO MONTH,
       COL_MONTH3           INTERVAL YEAR(3) TO MONTH,
       COL_DAY_TO_SECOND3   INTERVAL DAY TO SECOND(3),
       COL_DAY_TO_MINUTE    INTERVAL DAY TO SECOND,
       COL_DAY_TO_HOUR      INTERVAL DAY(3) TO SECOND,
       COL_DAY3             INTERVAL DAY(3) TO SECOND,
       COL_HOUR_TO_SECOND7  INTERVAL DAY TO SECOND(7),
       COL_HOUR_TO_MINUTE   INTERVAL DAY TO SECOND,
       COL_HOUR             INTERVAL DAY TO SECOND,
       COL_MINUTE_TO_SECOND INTERVAL DAY TO SECOND,
       COL_MINUTE           INTERVAL DAY TO SECOND,
       COL_HOUR3            INTERVAL DAY TO SECOND,
       COL_SECOND2_3        INTERVAL DAY TO SECOND(3),
       PRIMARY KEY(ID)
);

INSERT INTO TestIntervalTable(ID, COL_YEAR3_TO_MONTH, COL_YEAR3, COL_MONTH3,
            COL_DAY_TO_SECOND3, COL_DAY_TO_MINUTE, COL_DAY_TO_HOUR, COL_DAY3, COL_HOUR_TO_SECOND7, COL_HOUR_TO_MINUTE,
            COL_HOUR, COL_MINUTE_TO_SECOND, COL_MINUTE, COL_HOUR3, COL_SECOND2_3)
        VALUES (1, INTERVAL '120-3' YEAR(3) TO MONTH, INTERVAL '105' YEAR(3), INTERVAL '500' MONTH(3),
            INTERVAL '11 10:09:08.555' DAY TO SECOND(3), INTERVAL '11 10:09' DAY TO MINUTE, INTERVAL '100 10' DAY(3) TO HOUR,
            INTERVAL '999' DAY(3), INTERVAL '09:08:07.6666666' HOUR TO SECOND(7), INTERVAL '09:30' HOUR TO MINUTE, INTERVAL '40' HOUR,
            INTERVAL '15:30' MINUTE TO SECOND, INTERVAL '30' MINUTE, INTERVAL '250' HOUR(3), INTERVAL '15.6789' SECOND(2,3));

CREATE OR REPLACE TYPE OBJECT_TYPE OID '19A57209ECB73F91E03400400B40BB23' AS OBJECT (
         STRING_ATTR    VARCHAR(20),
         INT_ATTR       NUMBER,
         FLOAT_ATTR     FLOAT,
         DECIMAL_ATTR   FLOAT
);

CREATE TABLE TestObjectTypeTable (
        PK          NUMBER GENERATED ALWAYS AS IDENTITY,
        COL_OBJECT  OBJECT_TYPE,
        PRIMARY KEY(PK)
);

CREATE OR REPLACE TYPE NESTED_TYPE OID '19A57209ECB73F91E03400400B40BB25' AS OBJECT (
         STRING_ATTR VARCHAR2(20),
         OBJECT_ATTR OBJECT_TYPE,
         MAP MEMBER FUNCTION GET_ATTR1 RETURN NUMBER
);

CREATE TABLE TestNestedObjectTypeTable (
        PK                  NUMBER GENERATED ALWAYS AS IDENTITY,
        COL_NESTED_OBJECT   NESTED_TYPE,
        PRIMARY KEY(PK)
);

CREATE OR REPLACE TYPE CharArrayType AS VARRAY(6) OF VARCHAR(100);
CREATE OR REPLACE TYPE ByteArrayType AS VARRAY(6) OF RAW(100);
CREATE OR REPLACE TYPE IntArrayType AS VARRAY(6) OF NUMBER;
CREATE OR REPLACE TYPE BoolArrayType AS VARRAY(6) OF NUMBER;
CREATE OR REPLACE TYPE FloatArrayType AS VARRAY(6) OF FLOAT;
CREATE OR REPLACE TYPE DecimalArrayType AS VARRAY(6) OF NUMBER;

CREATE TABLE TestVarrayTable(
       PK               NUMBER GENERATED ALWAYS AS IDENTITY,
       COL_CHARARR      CharArrayType,
       COL_BYTEARR      ByteArrayType,
       COL_INTARR       IntArrayType,
       COL_BOOLARR      BoolArrayType,
       COL_FLOATARR     FloatArrayType,
       COL_DECIMALARR   DecimalArrayType,
       PRIMARY KEY(PK)
       )
