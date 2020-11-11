# -*- coding: utf-8 -*-
"""
Created on Fri Nov  6 15:58:21 2020

@author: kkrao
"""


import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import os
from matplotlib.dates import DateFormatter
import seaborn as sns

sns.set(font_scale = 1.3, style = "ticks")
dateForm = DateFormatter("%H")

#%% radar
filename = r"H:\upwardradar\results\jrbp_5_nov_2020_0939.csv"

df = pd.read_csv(filename, header = None).T
start_time = "2020-10-31 09:25:00"
# index = pd.to_datetime(start_time, format = "%Y-%m-%d %H:%M:%S")
df.index = pd.date_range(start_time, periods = df.shape[0], freq = "H")

#%%psychrometer
dirPsy = r"D:\Krishna\projects\upward_radar\data\psychrometers"

psyC = pd.read_csv(os.path.join(dirPsy,"PSY1JC04.csv"), index_col = 0, skiprows = 60,\
                   usecols = [0,1,5], header = None, names = ["date","time","Mpa"])
psyC.index = pd.to_datetime(psyC.index.astype(str)+psyC.time.astype(str),format = "%d/%m/%Y%H:%M:%S")
# psyC = psyC.loc[(psyC.index>=df.index.min())&(psyC.index<=df.index.max())]

psyW = pd.read_csv(os.path.join(dirPsy,"PSY1JC05.csv"), index_col = 0, skiprows = 711,\
                    usecols = [0,1,5], header = None, names = ["date","time","Mpa"])
psyW.index = pd.to_datetime(psyW.index.astype(str)+psyW.time.astype(str),format = "%d/%m/%Y%H:%M:%S")
# psyW = psyW.loc[(psyW.index>=df.index.min())&(psyW.index<=df.index.max())]

psyE = pd.read_csv(os.path.join(dirPsy,"PSY1JC06.csv"), index_col = 0, skiprows = 39,\
                    usecols = [0,1,5], header = None, names = ["date","time","Mpa"])
psyE.index = pd.to_datetime(psyE.index.astype(str)+psyE.time.astype(str),format = "%d/%m/%Y%H:%M:%S")
# psyE = psyE.loc[(psyE.index>=df.index.min())&(psyE.index<=df.index.max())]


#%%plotting
fig, axs = plt.subplots(1,1,figsize = (12,3), sharex = True)


# ax = axs[0]
# df.mean(axis = 1).plot(ax = ax, color = "black", rot = 0, marker = "o",ms = 4)
# ax.errorbar(x=df.index, y = df.mean(axis = 1), yerr=df.std(axis =1), color = "grey", zorder =-1, )
# ax.xaxis.set_major_formatter(dateForm)
# ax.set_ylabel("Radar amplitude")
# ax.spines['right'].set_visible(False)
# ax.spines['top'].set_visible(False)
# # ax.set_xlabel("Time")
# ax.grid(b=True, which='major', color='lightgrey', linestyle='-', axis = "x")

dateForm = DateFormatter("%m-%d")
ax = axs
psyC.Mpa.plot(ax = ax, color = "rebeccapurple", rot = 0)
psyE.Mpa.plot(ax = ax, color = "darkcyan", rot = 0)
psyW.Mpa.plot(ax = ax, color = "orange", rot = 0)
ax.xaxis.set_major_formatter(dateForm)
ax.set_ylabel("Xylem water\npotential (Mpa)")
ax.set_xlabel("Date")
ax.spines['right'].set_visible(False)
ax.spines['top'].set_visible(False)
ax.grid(b=True, which='major', color='lightgrey', linestyle='-', axis = "x")
