#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# import os
import re
import pandas as pd
# import json

df1 = pd.read_csv(r"people_1.txt", engine='python', sep = '\t')
df2 = pd.read_csv(r"people_2.txt", engine='python', sep = '\t') 
for col in df1.columns:
    df1[col] = df1[col].apply(lambda x: x.strip().lower())
    df2[col] = df2[col].apply(lambda x: x.strip().lower())

df = pd.merge(df1, df2, how='outer', on='Email')
# df = pd.concat([df1,df2]) - alternatively simply stack up the two df

# gather the pure numbers, and format to 012-345-6789
df["Phone"] = df["Phone"].apply(lambda x: list(re.findall('\d{1}', x)))
df["Phone"].apply(lambda x: x.insert(6, '-'))
df["Phone"].apply(lambda x: x.insert(3, '-'))
df["Phone"] = df["Phone"].apply(lambda x: ''.join(x))

# format "Address" to "No.9999 some-street"
df["Address"] = df["Address"].apply(lambda x:'No.' + re.search('\d{1,8}',x).group() + x[(x.find(' ')):])

df = df.drop_duplicates().sort_values('Email')

# in case "Address" have more variations, simply pick the first record
df = df.groupby(["FirstName", "LastName", "Email", "Phone"], as_index=False).agg("first")

df.to_csv("people_cleansed.txt", sep = '\t', index=False)

