#from mpl_toolkits.mplot3d import Axes3D
#from matplotlib import cm
#from matplotlib.ticker import LinearLocator, FormatStrFormatter
#import matplotlib.pyplot as plt
#import numpy as np

from mpl_toolkits.mplot3d import Axes3D
from matplotlib import cm
import matplotlib.pyplot as plt
from matplotlib.mlab import griddata
import numpy as np
from matplotlib import rc
import matplotlib as mpl
import sys
import os
from pylab import *
import matplotlib.gridspec as gridspec
from mpl_toolkits.axes_grid1 import make_axes_locatable
import numpy as np
import matplotlib.pyplot as plt
import scipy.interpolate
import math
from matplotlib import ticker
import matplotlib.patheffects as PathEffects


rc('font',**{'family':'sans-serif','sans-serif':['Helvetica']})
rc('text', usetex=True)
plt.rcParams['text.usetex'] = True
mpl.rcParams.update({'font.size': 42})

fig = plt.figure()
ax = fig.gca(projection='3d')
inputfile = 'surfdata.txt'
outputfile = 'out.pdf'

Nx = 100
Ny = 100

def main():

    data = [ [] for x in xrange(Nx) ]
    
    inE = '100x100x70D_By_1.5.txt'
    data = np.loadtxt(inE,comments='#',delimiter=' ',unpack=False)	
    
    x = []
    y = []
    z = []
    
    for tik1 in range(Nx):
        for tik2 in range(Ny):

            x.append(tik1)
            y.append(tik2)
            z.append(1000*float(data[tik1][tik2]))
    
    xi, yi = np.linspace(min(x), max(x), Nx), np.linspace(min(y), max(y), Ny)
    xi, yi = np.meshgrid(xi, yi)
    zi = scipy.interpolate.griddata((x, y), z, (xi, yi), method='linear')
    #wire = ax.plot_wireframe(xi,yi,zi,rstride=5,cstride=5)
    surf = ax.plot_surface(xi,yi,zi,rstride=1,cstride=1,cmap=cm.summer,linewidth=0.1,antialiased=True,shade=True)
    ax.view_init(elev=25.,azim=-160.)
    
    ax.locator_params(axis='x',nbins=3)
    ax.locator_params(axis='y',nbins=3)
    ax.set_ylim([1,Ny])
    ax.set_xlim([1,Nx])
    ax.set_yticks([1,Ny/2,Ny])
    ax.set_xticks([1,Nx/2,Nx])

    ax.set_zlim3d(np.min(z),np.max(z))
    ax.tick_params(labelsize=18)

    ax.set_zlabel(r'$|\kappa_{j}|^{2}\,\,\,\,\,(10^{-3})$',rotation='vertical',fontsize=18)
    ax.set_xlabel(r'$x$',rotation='horizontal',fontsize=18)
    ax.set_ylabel(r'$y$',rotation='horizontal',fontsize=18)


main()
plt.show()
