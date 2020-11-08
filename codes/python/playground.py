# -*- coding: utf-8 -*-
"""
Spyder Editor
This is a temporary script file.
"""

import scipy as sp
import numpy as np
import matplotlib.pyplot as plt
from scipy import signal

N = 31

dx = 3*np.pi/30;
x = np.linspace(0,3*np.pi,N);
y = np.sin(x)**2*(np.cos(x));


interpfactor = 8;


# def interpft(y, interpfactor):
    
#     padlen = (len(y))*(interpfactor - 1);
#     # % Compute number of half points in FFT 
#     zlen = np.int(np.ceil((len(y)+1)/2))
#     # % Compute FFT
#     z = np.fft.fft(y);
#     # % z = z.'; % for complex inputs
#     # % Construct a new spectrum (row vector) by centering zeros
#     zp = np.concatenate((z[0:zlen+1], np.zeros(padlen), z[zlen+1:]));
#     if  ~len(y)%2 : #% even number
#         zp[zlen] = zp[zlen]/2;
#         zp[zlen+padlen] = zp[zlen];
#     # % Compute inverse FFT and scale by m
#     yp = np.fft.ifft(zp)*interpfactor;
#     yp = yp[0:np.int((len(y)-1)*(interpfactor))+1]
#     # end
    
#     return yp

def interpft(y, interpfactor):
    padlen = (len(y))*(interpfactor - 1);
    gg = len(y)+padlen
    gg = 1<<(gg-1).bit_length()
    padlen = gg - len(y)
    # % Compute number of half points in FFT 
    zlen = np.int(np.ceil((len(y)+1)/2))
    # % Compute FFT
    z = np.fft.fft(y)
    # % z = z.'; % for complex inputs
    # % Construct a new spectrum (row vector) by centering zeros
    zp = np.concatenate((z[0:zlen+1], np.zeros(padlen), z[zlen+1:]))
    if  ~len(y)%2 : #% even number
        zp[zlen] = zp[zlen]/2;
        zp[zlen+padlen] = zp[zlen];
    # % Compute inverse FFT and scale by m
    yp = (np.fft.ifft(zp)*len(zp)/len(z))
    # yp = yp[0:np.int((len(y)-1)*(interpfactor))+1]
    # end
    
    return yp



y2 = interpft(y,interpfactor);
x2 = np.linspace(0,3*np.pi,len(y2));
# y2 = signal.resample(y, len(y)*interpfactor)[:(len(y)-1)*interpfactor+1]


fig, ax = plt.subplots(figsize = (3,3))
ax.plot(x,y,'o')
ax.plot(x2,y2,'.', ms=2)