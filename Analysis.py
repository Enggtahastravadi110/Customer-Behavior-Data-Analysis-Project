from operator import index

import pandas as pd

df = pd.read_csv('customer_shopping_behavior.csv')

# print(df.head())
# df.info()
# print(df.describe(include='all'))
# print(df.isnull().sum())
# print(df["Review Rating"].isnull().sum())

df['Review Rating'] = df.groupby('Category')['Review Rating'].transform(lambda x: x.fillna(x.median()))
# print(df["Review Rating"])
# print(df["Review Rating"].isnull().sum())

df.columns = df.columns.str.lower().str.replace(' ','_')
df = df.rename(columns={"purchase_amount_(usd)":"purchase_amount"})
# print(df.columns)

labels = ["Young Adult","Adult","Middle Aged","Senior"]
df['age_group'] = pd.qcut(df['age'],q=4,labels = labels)
# print(df[['age','age_group']].head(10))

frequency_mapping={
    'Fortnightly' : 14,
    'Weekly' : 7,
    'Annually' : 365,
    'Quarterly' : 90,
    'Bi-Weekly' : 14,
    'Monthly' : 30,
    'Every 3 Months' : 90,
}

df['purchase_frequency_days'] = df['frequency_of_purchases'].map(frequency_mapping)
# print(df[['frequency_of_purchases','purchase_frequency_days']].head(10))

# print(df[['discount_applied','promo_code_used']].head(10))
# print((df['discount_applied']==df['promo_code_used']).all())
df = df.drop('promo_code_used',axis=1)
# print(df.columns)

# from sqlalchemy import create_engine
# import pymysql

# username = "root"
# password = "root"
# host = "127.0.0.1"
# port = "3306"
# database = "customer_behavior"

# engine = create_engine(f"mysql+pymysql://{username}:{password}@{host}:{port}/{database}")

# table_name = "customer_table"
# df.to_sql(table_name,engine,if_exists="replace",index=False)
# # print(f"Data Successfully Loaded Into Table'{table_name}' in Database '{database}'.")
# pd.read_sql(f"SELECT * FROM {table_name}",engine).head(10)

print(df['purchase_amount'].count())