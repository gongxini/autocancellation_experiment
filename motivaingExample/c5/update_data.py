#!/usr/bin/python3
import pandas as pd
  
# reading the csv file
df = pd.read_csv("~/software/mysql/dist/data/test/outfile.csv", header=None)
  
# updating the column value/data
df.iloc[:, 0] = df.iloc[:, 0]+100000 

df.to_csv("/home/yigonghu/software/mysql/dist/data/test/result.csv", header=None, index=False)
