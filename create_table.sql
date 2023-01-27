CREATE TABLE final_table AS
  SELECT
    ID                    AS client_id,
    CODE_GENDER           AS gender,
    MAX(AMT_INCOME_TOTAL) AS annual_income,
    NAME_INCOME_TYPE      AS income_source,
    NAME_EDUCATION_TYPE   AS education_level,
    NAME_FAMILY_STATUS    AS marriage_status
  FROM stream_table
  GROUP BY ID, CODE_GENDER, NAME_INCOME_TYPE, NAME_EDUCATION_TYPE, NAME_FAMILY_STATUS
  EMIT CHANGES;