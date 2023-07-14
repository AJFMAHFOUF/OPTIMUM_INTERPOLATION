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

lat1,lon1,field1 = np.loadtxt('../DATA/t850_obs_weather_stations.dat',unpack=True)
lat2,lon2,field2 = np.loadtxt('../DATA/t850_guess_res150.dat',unpack=True)
i = 0
while i < np.size(lon1):
	if lon2[i] > 180.0:
		lon2[i] = lon2[i] - 360.0	
	i = i + 1

#m = Basemap(projection='cyl', llcrnrlon=-20., \
#    urcrnrlon=20.,llcrnrlat=35.0,urcrnrlat=70.0, \
#    resolution='l')
    
m = Basemap(projection='kav7',lon_0=0,resolution='c')    

#m = Basemap(projection='npstere',boundinglat=10,lon_0=270,resolution='l')
   
x1, y1 = m(lon1, lat1)
x2, y2 = m(lon2, lat2)

#cs = m.scatter(x2,y2,4,marker='o',color='black')
#cs = m.scatter(x2,y2,s=1,c=field2,marker='s',vmin=np.min(field2),vmax=np.max(field2),cmap='jet')
#plt.colorbar(cs,orientation='vertical', shrink=0.5)
cs = m.scatter(x1,y1,1,c=field1,marker='s',vmin=field1.min(),vmax=field1.max(),cmap='jet')
plt.colorbar(cs,orientation='vertical', shrink=0.5)

m.drawcoastlines() 
m.drawmapboundary()
m.drawparallels(np.arange(-90.,120.,30.),labels=[1,0,0,0])
m.drawmeridians(np.arange(-180.,180.,60.),labels=[0,0,0,1])

plt.title("T 850hPa @ surface weather stations")
#plt.title("T 850 hPa - ERA5 - first guess - resol 1.5°")
plt.savefig('../PLOTS/weather_stations_with_t850.png')
plt.show()




