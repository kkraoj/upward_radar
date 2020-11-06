# -*- coding: utf-8 -*-
"""
Created on Sun Oct 25 21:02:04 2020

@author: kkrao
"""

import os
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.dates import DateFormatter


dirPsy = r"D:\Krishna\projects\upward_radar\data\psychrometers"
dirVsm = r"D:\Krishna\projects\upward_radar\data\vsm"


psyC = pd.read_csv(os.path.join(dirPsy,"PSY1JC04.csv"), index_col = 0, skiprows = 60,\
                   usecols = [0,1,5], header = None, names = ["date","time","Mpa"])
psyC.index = pd.to_datetime(psyC.index.astype(str)+psyC.time.astype(str),format = "%d/%m/%Y%H:%M:%S")

psyW = pd.read_csv(os.path.join(dirPsy,"PSY1JC05.csv"), index_col = 0, skiprows = 711,\
                    usecols = [0,1,5], header = None, names = ["date","time","Mpa"])
psyW.index = pd.to_datetime(psyW.index.astype(str)+psyW.time.astype(str),format = "%d/%m/%Y%H:%M:%S")

psyE = pd.read_csv(os.path.join(dirPsy,"PSY1JC06.csv"), index_col = 0, skiprows = 39,\
                    usecols = [0,1,5], header = None, names = ["date","time","Mpa"])
    
psyE.index = pd.to_datetime(psyE.index.astype(str)+psyE.time.astype(str),format = "%d/%m/%Y%H:%M:%S")

fig, ax = plt.subplots(figsize = (6,3))
dateForm = DateFormatter("%H")
psyC.Mpa.plot(ax = ax, color = "rebeccapurple", rot = 0)
psyE.Mpa.plot(ax = ax, color = "darkcyan", rot = 0)
psyW.Mpa.plot(ax = ax, color = "orange", rot = 0)


ax.xaxis.set_major_formatter(dateForm)
ax.set_ylabel("Mpa")
# ax.xaxis.ticks()

#%% cutshort just for graphical comparison

psyC = psyC.loc[(psyC.index<="2020-10-23 08:00:00")&(psyC.index>="2020-10-22 12:00:00")]
fig, ax = plt.subplots(figsize = (6,3))
dateForm = DateFormatter("%H")
psyC.Mpa.plot(ax = ax, color = "rebeccapurple", rot = 0)
ax.xaxis.set_major_formatter(dateForm)
ax.set_ylabel("Mpa")


#%% c=vsn


dirVsm = r"D:\Krishna\projects\upward_radar\data\vsm"

vsmE = pd.read_csv(os.path.join(dirVsm,"station2_minutes.dat"), index_col = 0, skiprows = 8,\
                   header = None, usecols = [0,4,5,6], names = ["time","vwc1","vwc2","vwc3"])

vsmW = pd.read_csv(os.path.join(dirVsm,"station1_minutes.dat"), index_col = 0, skiprows = 8,\
                   header = None, usecols = [0,4,5,6], names = ["time","vwc4","vwc5","vwc6"])

vsm = vsmW.join(vsmE)
vsm.index = pd.to_datetime(vsm.index,format = "%Y-%m-%d %H:%M:%S")


fig, ax = plt.subplots(figsize = (6,3))

vsm.plot(ax = ax, legend = True)
ax.set_ylabel("soil moisture (m$^3$/m$^3$)")
ax.set_xlabel("time")
# ax.xaxis.set_major_formatter(dateForm)




     
