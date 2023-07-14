import pygrib
import mpl_toolkits
mpl_toolkits.__path__.append('/home/jean-francois/basemap-1.2.2rel/lib/mpl_toolkits/')
from mpl_toolkits.basemap import Basemap
from mpl_toolkits.basemap import shiftgrid
import matplotlib.pyplot as plt
import matplotlib.colors as colors
import numpy as np
import numpy.ma as ma

expid='EXP10'
exptype='BGU'

plt.figure(figsize=(12,8))
nx = 240
ny = 121
t_ana0 = np.zeros((nx*ny))
lsm0 = np.zeros((nx*ny))
lat_a,lon_a,zfield1 = np.loadtxt('../DATA/t850_ana_res150.dat',unpack=True)
lat_a,lon_a,zfield2 = np.loadtxt('../DATA/t850_guess_res150.dat',unpack=True)
lat_a,lon_a,lsm = np.loadtxt('../DATA/lsm_ana_res150.dat',unpack=True)

# put the origin at the lower left corner instead of upper left
for k in range(1,nx*ny+1):
	j = int((k - 1)/nx) + 1
	i = k - (j - 1)*nx
	kk = nx*(ny - j) + i
	t_ana0[kk-1] = zfield1[k-1] # - zfield2[k-1]
	lsm0[kk -1] = lsm[k-1]

t_fg0 = np.loadtxt('../OUTPUT/first_guess_'+exptype+'_'+expid+'.dat')
t_fg1 = t_fg0.reshape((ny,nx))
t_incr0 = np.loadtxt('../OUTPUT/analysis_increment_'+exptype+'_'+expid+'.dat')
t_incr1 = t_incr0.reshape((ny,nx))
t_var0 = np.loadtxt('../OUTPUT/analysis_error_'+exptype+'_'+expid+'.dat')
t_var1 = t_var0.reshape((ny,nx))
t_ana1 = t_ana0.reshape((ny,nx))
lsm1 = lsm0.reshape((ny,nx))

t_fg = np.zeros((ny,nx))
t_incr = np.zeros((ny,nx))
t_var = np.zeros((ny,nx))
t_ana = np.zeros((ny,nx))
lsm2 = np.zeros((ny,nx))

# shift longitudes by 180° (output fields from OI)
for i in range(nx):
	for j in range(ny):
		ii = int(nx/2) + i
		if ii > nx-1:
			ii = ii - int(nx)
		t_fg[j,ii] = t_fg1[j,i] 
		t_incr[j,ii] = t_incr1[j,i] 
		t_var[j,ii] = t_var1[j,i] 
		t_ana[j,ii] = t_ana1[j,i]
		if lsm1[j,i] > 0.5:
			lsm1[j,i] = 1.0
		else:
			lsm1[j,i] = 0.0
		lsm2[j,ii] = lsm1[j,i]

mse1 = np.square(t_fg - t_ana).mean()
rmse1 = np.sqrt(mse1)
print ('*************************************')
print ('RMSE guess - global ',rmse1)
mse2 = np.square(t_fg + t_incr - t_ana).mean()
rmse2 = np.sqrt(mse2)
print ('RMSE ana - global ',rmse2)
zz1 = ma.masked_array(t_fg - t_ana,mask=1-lsm2)
mse1 = np.square(zz1).mean()
rmse1 = np.sqrt(mse1)
print ('*************************************')
print ('RMSE guess over land ',rmse1)
zz2 = ma.masked_array(t_fg + t_incr - t_ana,mask=1-lsm2)
mse2 = np.square(zz2).mean()
rmse2 = np.sqrt(mse2)
print ('RMSE ana over land ',rmse2)
zz1 = ma.masked_array(t_fg - t_ana,mask=lsm2)
mse1 = np.square(zz1).mean()
rmse1 = np.sqrt(mse1)
print ('*************************************')
print ('RMSE guess over oceans ',rmse1)
zz2 = ma.masked_array(t_fg + t_incr - t_ana,mask=lsm2)
mse2 = np.square(zz2).mean()
rmse2 = np.sqrt(mse2)
print ('RMSE ana over oceans ',rmse2)
print ('*************************************')
		
# need to shift data grid longitudes from (0.,360) to (-180,180)
lon_i = 0.0
lon_f = 360.0
nb_lon = nx
lons = np.linspace(lon_i,lon_f,nb_lon)

lat_i = -90.0
lat_f = 90.0
nb_lat = ny
lats = np.linspace(lat_i,lat_f,nb_lat)
# it shifts the longitudes but also the field
t_fg1, lons = shiftgrid(180.,t_fg1,lons,start=False,cyclic=360.0)

grid_lon, grid_lat = np.meshgrid(lons, lats) #regularly spaced 2D grid

m = Basemap(projection='cyl', llcrnrlon=-180, \
    urcrnrlon=180.,llcrnrlat=lats.min(),urcrnrlat=lats.max(), \
    resolution='l')
    
m = Basemap(projection='kav7',lon_0=0,resolution='c')    

#m = Basemap(projection='npstere',boundinglat=10,lon_0=270,resolution='l')
   
x, y = m(grid_lon, grid_lat)

cs = m.pcolormesh(x,y,t_fg + t_incr,shading='flat',vmin=240,vmax=300,cmap='jet')
#cs = m.pcolormesh(x,y,t_ana,shading='flat',vmin=-4,vmax=4,cmap='seismic')
#cs = m.contourf(x,y,data3,shading='flat',cmap='seismic')
#cs = m.pcolormesh(x,y,lsm2,shading='flat',cmap='jet')
 
m.drawcoastlines() 
m.drawmapboundary()
m.drawparallels(np.arange(-90.,120.,30.),labels=[1,0,0,0])
m.drawmeridians(np.arange(-180.,180.,60.),labels=[0,0,0,1])

plt.colorbar(cs,orientation='vertical', shrink=0.5)
#plt.title('Surface pressure TIGGE') # Set the name of the variable to plot
#plt.title("T2m @ 1000 hPa - ERA5 - 20080101")
plt.title('Temperature') # Set the name of the variable to plot
#plt.title("T @ 850 hPa -  ERA5 (ana) - 20200220 00 UTC "+exptype+"_"+expid)
plt.title("T @ 850 hPa -  OI (ana) - 20200220 00 UTC "+exptype+"_"+expid)

plt.savefig('../PLOTS/T850_ana_OI_'+exptype+'_'+expid+'.png')

plt.show()

plt.figure(figsize=(12,8))

error = t_fg + t_incr - t_ana 
cs = m.pcolormesh(x,y,error,shading='flat',vmin=-15,vmax=15,cmap='seismic')
#cs = m.contourf(x,y,data3,shading='flat',cmap='seismic')
#cs = m.contourf(x,y,data3,shading='flat',cmap=plt.cm.gist_rainbow_r)
 
m.drawcoastlines() 
m.drawmapboundary()
m.drawparallels(np.arange(-90.,120.,30.),labels=[1,0,0,0])
m.drawmeridians(np.arange(-180.,180.,60.),labels=[0,0,0,1])

plt.colorbar(cs,orientation='vertical', shrink=0.5)
#plt.title('Surface pressure TIGGE') # Set the name of the variable to plot
#plt.title("T2m @ 1000 hPa - ERA5 - 20080101")
plt.title('Temperature') # Set the name of the variable to plot
plt.title("T @ 850 hPa - Real analysis error - 20200220 00 UTC "+exptype+"_"+expid)

#plt.savefig(grib+'.png') # Set the output file name
plt.savefig('../PLOTS/T850_real_ana_error_'+exptype+'_'+expid+'.png')

plt.show()


plt.figure(figsize=(12,8))

cs = m.pcolormesh(x,y,np.sqrt(t_var),shading='flat',cmap='Blues')
#cs = m.contourf(x,y,data3,shading='flat',cmap='seismic')
#cs = m.contourf(x,y,data3,shading='flat',cmap=plt.cm.gist_rainbow_r)
 
m.drawcoastlines() 
m.drawmapboundary()
m.drawparallels(np.arange(-90.,120.,30.),labels=[1,0,0,0])
m.drawmeridians(np.arange(-180.,180.,60.),labels=[0,0,0,1])

plt.colorbar(cs,orientation='vertical', shrink=0.5)
#plt.title('Surface pressure TIGGE') # Set the name of the variable to plot
#plt.title("T2m @ 1000 hPa - ERA5 - 20080101")
plt.title('Temperature') # Set the name of the variable to plot
plt.title("T @ 850 hPa - OI analysis error - 20200220 00 UTC "+exptype+"_"+expid)

#plt.savefig(grib+'.png') # Set the output file name
plt.savefig('../PLOTS/T850_std_ana_'+exptype+'_'+expid+'.png')

plt.show()





