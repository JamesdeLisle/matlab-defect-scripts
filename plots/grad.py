import sys
import os
import numpy
from pylab import *

data = []
data2 = []

inE = 'Gap_By_No_Def.txt'
myfile = open(inE)
for line in myfile:
    if line.startswith('#'):
        continue
    else:
        line = line.strip()
        fields = line.split()
        data.append(fields[0])
        data2.append(fields[1])       

for tik in range(0,100):
    print((float(data2[tik+1])-float(data2[tik]))/(float(data[tik+1])-float(data[tik])))

