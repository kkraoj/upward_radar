# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import scipy as sp
import numpy as np
import matplotlib.pyplot as plt
from sys import getsizeof
from scipy import signal


interpfactor = 8;

def interpft(y, interpfactor):
    
    padlen = (len(y))*(interpfactor - 1);
    padlen = 950851824
    # % Compute number of half points in FFT 
    zlen = np.int(np.ceil((len(y)+1)/2))
    # % Compute FFT
    z = np.fft.fft(y).astype(np.complex64);
    # % z = z.'; % for complex inputs
    # % Construct a new spectrum (row vector) by centering zeros
    zp = np.concatenate((z[0:zlen+1], np.zeros(padlen), z[zlen+1:])).astype(np.complex64);
    if  ~len(y)%2 : #% even number
        zp[zlen] = zp[zlen]/2;
        zp[zlen+padlen] = zp[zlen];
    # % Compute inverse FFT and scale by m
    yp = (np.fft.ifft(zp)*len(zp)/len(z)).astype(np.complex64);
    # yp = yp[0:np.int((len(y)-1)*(interpfactor))+1]
    # end
    
    return yp







filename = "/media/krishna/Seagate Backup Plus Drive/upwardradar/jrbp_31_oct_2020_0925/E312_TreeRadar_freq430_gain40_BW15_burst1_subBurst1_date010370_burstTime135553_callTime135631.dat"
data = np.fromfile(filename, dtype = np.short)
# data = data[range(0,len(data),2)]+1j*data[range(1,len(data),2)]
# data_upsampled = interpft(data, interpfactor)
# getsizeof(data)/1024/1024/1024
# getsizeof(zp)/1024/1024/1024
y = np.empty((int(len(data)/2),), dtype = np.complex64)
y.real = data[range(0,len(data),2)]
y.imag = data[range(1,len(data),2)]

# z = signal.resample(y, len(y)*interpfactor)[:(len(y)-1)*interpfactor+1]
getsizeof(yp)/1024/1024/1024
