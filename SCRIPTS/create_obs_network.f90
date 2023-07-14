program create_obs_network
 integer, parameter :: nx=360*4, ny=180*4 + 1
 real, dimension (nx,ny) :: zfield
 open (unit=10,file='/home/jean-francois/SCRIPTS_FOR_ERA5/t850_obs_res025.dat',status='OLD')
 open (unit=20,file='/home/jean-francois/DATA/NOAA_CDR/location_weather_stations_global.txt',status='OLD')
 lat_0 = -90.0
 lon_0 = 0.0
 dlat = 0.25
 dlon = 0.25
 read (10, *) ! skip header
 do j=1,ny
   do i=1,nx
     jj = ny - j + 1
     read (10,*) zlat,zlon,zfield(i,jj)
   enddo
 enddo   
 ic = 0
 do 
   read (20,fmt=*,end=440) xlat,xlon
   ii = INT((xlon - lon_0)/dlon) + 1
   jj = INT((xlat - lat_0)/dlat) + 1
   xobs = zfield(ii,jj)
   write (21,*) xlat,xlon,xobs
   ic = ic + 1
 enddo
440 continue
print *,'number of weather station locations',ic
100 format(F7.3,A1,F8.3)
stop    
end program create_obs_network
