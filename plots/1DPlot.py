import sys
import os
import numpy
from pylab import *
import matplotlib.gridspec as gridspec
from operator import add
from mpl_toolkits.axes_grid1.inset_locator import inset_axes
from matplotlib.patheffects import withStroke

from matplotlib import rc
rc('font',**{'family':'sans-serif','sans-serif':['Helvetica']})
rc('text', usetex=True)
matplotlib.rcParams.update({'font.size': 42})
fig = figure(num=None, figsize=(17,6.45),dpi=80)
gs = gridspec.GridSpec(1,2,width_ratios=[1,1])
ax1 = plt.subplot(gs[0])

def gapdensity():

	data = []
	data2 = []

	inE = 'surfinterdata.txt'
	myfile = open(inE)
	for line in myfile:
	    if line.startswith('#'):
		continue
	    else:
		line = line.strip()
		fields = line.split()
		data.append(fields[0])
		data2.append(fields[1])       
	
	ax1.plot(data, data2, color='blue')
	ax1.locator_params(axis='x',nbins=5)
	ax1.locator_params(axis='y',nbins=5)	
	ax1.tick_params(labelsize=22)
	ax1.set_xlabel(r'$B_{y}$',fontsize=25)
	ax1.set_ylabel(r'$\Delta E$',rotation='horizontal',fontsize=25)
	ax1.set_xlim([0,20])
	#a = float(min(data2))
	#b = float(max(data2))
	#ax1.set_ylim([0,b])
	ax1.yaxis.set_label_coords(-0.07, 0.8)

gapdensity()
subplots_adjust(left=None, bottom=None, right=None, top=None, wspace=0.3, hspace=0.3)

grid(False)

plt.savefig('surfinter.pdf', bbox_inches='tight')
#show()

