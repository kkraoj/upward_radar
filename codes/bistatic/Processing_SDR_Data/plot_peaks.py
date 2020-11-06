# -*- coding: utf-8 -*-
"""
Created on Mon Sep 16 12:38:59 2019

@author: kkrao
"""

import numpy as np 
import pandas as pd
import matplotlib.pyplot as plt


df1 = pd.read_csv(r'D:\Krishna\projects\upward_radar\codes\bistatic\Processing_SDR_Data\arboretum_10_sep_2019.csv', header = None)
df1.columns += 6
df1.columns = pd.to_datetime(df1.columns, format = '%H')
df2 = pd.read_csv(r'D:\Krishna\projects\upward_radar\codes\bistatic\Processing_SDR_Data\arboretum_14_sep_2019.csv', header = None)
df2.columns += 18
newcols = list(df2.columns[df2.columns<24]) + list(df2.columns[df2.columns>=24]-24)
df2.columns = pd.to_datetime(newcols, format = '%H').time

df = pd.concat([df1,df2], axis =1)
df.columns = [str(x.hour) for x in list(df.columns)]

mean = list(df.mean())
sd =  list(df.std())

#%% plotting
fig, ax = plt.subplots(figsize = (6,3))
# ax.plot(df.mean())
xticks = np.array(range(df.shape[1]))
xticks[13:] -= 1
ax.errorbar(xticks[:13],mean[:13] ,sd[:13],color = 'grey',fmt = '-s',ms = 3)
ax.errorbar(xticks[13:],mean[13:] ,sd[13:],color = 'k',fmt = '-s',ms = 3)
# ax.set_xticklabels(list(df.columns))
ax.set_xticks([0,6,12,18,24,30])
ax.set_xticklabels(['06','12','18','00','06','12'])
ax.set_xlabel('Time of day')
ax.set_ylabel('Amplitude')