#!/usr/bin/python3

import pandas as pd
from sqlalchemy import create_engine

try:
    engine = create_engine('postgresql+psycopg2://postgres:postgres@localhost/postgres')
    print('Connection to PostgreSQL Success')
except:
    print('Connection to PostgreSQL Failed')

try:
    pd.read_csv('application_record.csv').to_sql('application_record', con=engine, if_exists='replace', index=False)
    print('Load Data to PostgreSQL Success')
except:
    print('Load Data to PostgreSQL Failed')