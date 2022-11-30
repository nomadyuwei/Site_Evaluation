#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Sep 15 21:04:54 2021

@author: weiyu
"""


import numpy as np
import matplotlib.pyplot as plt


SMT_3D_2018_2021 = [2.30, 2.02, 2.44, 3.21, 3.55, 6.78, 16.21, 15.05, 8.49, 3.37, 3.14, 2.29]


SG_3D_2018_2021  = [1.05, 1.52, 2.25, 3.59, 5.73, 11.22, 15.39, 14.69, 11.94, 3.64, 1.80, 1.17];


GLT_3D_2018_2021 = [1.33, 1.24, 1.15, 2.36, 4.46, 7.13, 10.04, 10.42, 4.89, 4.32, 2.06, 1.96]






Month=[1,2,3,4,5,6,7,8,9,10,11,12]





plt.figure(1)
plt.ylabel('PWV (mm)')
plt.xlabel('Month')

plt.xticks(Month)
plt.plot(Month,SG_3D_2018_2021,'-*',label="SG", color="k")

plt.plot(Month,GLT_3D_2018_2021,'-*',label="GLT")

plt.plot(Month,SMT_3D_2018_2021,'-*',label="SMT")

plt.legend(loc="upper left")

plt.savefig('PWV_SG_Month.pdf')