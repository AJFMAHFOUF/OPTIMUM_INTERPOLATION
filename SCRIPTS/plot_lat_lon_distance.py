import pygrib
import mpl_toolkits
mpl_toolkits.__path__.append('/home/jean-francois/basemap-1.2.2rel/lib/mpl_toolkits/')
from mpl_toolkits.basemap import Basemap
from mpl_toolkits.basemap import shiftgrid
import matplotlib.pyplot as plt
import matplotlib.colors as colors
import numpy as np

plt.figure(figsize=(12,8))

# open ASCII file

lat1,lon1,field1 = np.loadtxt('../SRC/fort.101',unpack=True)
lat2,lon2,field2 = np.loadtxt('../SRC/fort.100',unpack=True)
field1 = np.log10(1 + field1)
i = 0
while i < np.size(lon1):
	if lon1[i] > 180.0:
		lon1[i] = lon1[i] - 360.0	
	i = i + 1

#m = Basemap(projection='cyl', llcrnrlon=-180., \
#    urcrnrlon=180.,llcrnrlat=-90.0,urcrnrlat=90.0, \
#    resolution='l')
    
m = Basemap(projection='kav7',lon_0=0,resolution='c')    

#m = Basemap(projection='npstere',boundinglat=10,lon_0=270,resolution='l')
   
x1, y1 = m(lon1, lat1)
x2, y2 = m(lon2, lat2)

#cs = m.scatter(x2,y2,4,marker='o',color='black')
cs = m.scatter(x1,y1,s=4,c=field1,marker='s',vmin=0.5,vmax=np.max(field1),cmap='RdYlBu')
plt.colorbar(cs,orientation='vertical', shrink=0.5)
#cs = m.scatter(x1,y1,3,marker='s',vmin=200.0,vmax=300.0,cmap='jet')
#plt.colorbar(cs,orientation='vertical', shrink=0.5)

m.drawcoastlines() 
m.drawmapboundary()
m.drawparallels(np.arange(-90.,120.,30.),labels=[1,0,0,0])
m.drawmeridians(np.arange(-180.,180.,60.),labels=[0,0,0,1])

#plt.title("T850 @ Weather stations")
plt.title("Minimum distance from observations (km - log10)")
plt.savefig('../PLOTS/mindistance_from_stations.png')
plt.show()




