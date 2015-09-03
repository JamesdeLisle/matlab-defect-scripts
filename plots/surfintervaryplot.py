import sys
import os
import numpy
from pylab import *
import matplotlib.gridspec as gridspec
from operator import add
from mpl_toolkits.axes_grid1.inset_locator import inset_axes
from matplotlib.patheffects import withStroke
from matplotlib import cm, colorbar
import matplotlib.pyplot as plt
from matplotlib.ticker import FuncFormatter
import numpy as np
from matplotlib import ticker

from matplotlib import rc
rc('font',**{'family':'sans-serif','sans-serif':['Helvetica']})
rc('text', usetex=True)
plt.rcParams['text.usetex'] = True
matplotlib.rcParams.update({'font.size': 26})
fig = figure(num=None, figsize=(20,6.45),dpi=80)
gs = gridspec.GridSpec(1,2,width_ratios=[1,1])
ax2 = plt.subplot(gs[0])
colors = cm.summer(np.linspace(0, 1, 75))

fs = 26

def main():


	data = []
	datafinal = []

	for i in range(101):
		data.append([])

	for i in range(100):
		datafinal.append([])

	inE = '15x50x14_By_0-2.txt'
	myfile = open(inE)
	
	for line in myfile:
		if line.startswith('#'):
		        continue
		else:
			line = line.strip() # like chomp in perl
			fields = line.split()
		
		for i in range(101):
			data[i].append(fields[i])
		 
	for tik in range(75):
		for tik2 in range(0,len(data[tik])):
			data[tik+1][tik2] = float(data[tik+1][tik2])
			datafinal[tik].append(1000*data[tik+1][tik2])

	for i, j in zip(range(75), colors):
		ax2.plot(data[0], datafinal[i], color=j, linewidth=1.0)

	
	ax2.locator_params(axis='x',nbins=5)
	ax2.locator_params(axis='y',nbins=5)
	ax2.set_xlim([1,50])
	ax2.set_ylim([0,4])
	ax2.tick_params(labelsize=fs)
	ax2.set_xlabel(r"$y$",fontsize=fs)
	ax2.set_ylabel('$|\kappa_{j}|^{2}$\n$(10^{-3})$',rotation='horizontal',fontsize=fs)
	ax2.yaxis.set_label_coords(-0.08,0.73)
	ax2.set_yticks([0,2,4]) 
        
def inset():

	data = []
	data2 = []
	inE = '15x50x14_By_0-2_gap.txt'
	myfile = open(inE)
	
	for line in myfile:
		if line.startswith('#'):
			continue
		else:
			line = line.strip()
			fields = line.split()
			data.append(fields[0])
			data2.append(fields[1])       
	
		for tik in range (0,len(data2)):
			data2[tik] = float(data2[tik])
		
	data2 = [x * 1000 for x in data2]

	ax3.plot(data, data2, color='black', linewidth=1.0)
	ax3.locator_params(axis='x',nbins=3)
	ax3.locator_params(axis='y',nbins=2)
	ax3.tick_params(labelsize=20)
	ax3.set_xlabel(r'$B_{y}$',fontsize=20)
	ax3.set_ylabel(r'$\Delta E\,\,\,\,\, (10^{-3})$',rotation='vertical',fontsize=20)
	ax3.set_ylim([0,6])
	ax3.set_yticks([0,2,4])
	ax3.xaxis.set_label_coords(0.78,-0.05) 
	ax3.yaxis.set_label_coords(-0.1,0.57)

main()
ax3 = inset_axes(ax2,width='35%',height='35%',loc=1,borderpad=0.15)
inset()
subplots_adjust(left=None, bottom=None, right=None, top=None, wspace=0.3, hspace=0.3)
cbar_ax = fig.add_axes([0.47,0.1,0.01,0.8])
cmap = cm.summer
norm = matplotlib.colors.Normalize(vmin=0,vmax=1.5)
cb = colorbar.ColorbarBase(cbar_ax,cmap=cmap,norm=norm,orientation='vertical')
tick_locator = ticker.MaxNLocator(nbins=3)
cb.locator = tick_locator
cb.update_ticks()
cb.set_ticks([0,0.75,1.5])
#cb.set_ticklabels([0,1,2])


grid(False)
plt.savefig('1DVaryBy.pdf', bbox_inches='tight')

