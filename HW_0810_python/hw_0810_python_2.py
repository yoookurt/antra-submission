#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
This script shuffles throughout the original json, and splits it to partitons.
"""

# import os
# import re
import pandas as pd
# import json

random_seed = 123
partition = 8

m = pd.read_json('movie.json')
length = len(m) # m.shape : (9995,1), 9995//8+1=1250
chunk = length//partition+1
m = m.sample(frac=1,random_state=random_seed).reset_index(drop=True)
for n in range(partition):
    m.iloc[(n-1)*chunk:n*chunk-1].to_json(f'movie_pt_{n}.json', orient = None)
