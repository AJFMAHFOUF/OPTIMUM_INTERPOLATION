subroutine interpol(nobs,nx,ny,lat,lon,f,g)
!--------------------------------------------------------
! Bilinear interpolation of the field "f" (background)
! at observation locations provided in their 
! latitude/longitude (lat/lon values)
! Result in field "g"
!                                  J.-F. Mahfouf (02/07)
!--------------------------------------------------------
 use consts
 implicit none
 integer,                intent(in)    :: nobs, nx, ny
 real, intent(in),  dimension (nobs)   :: lon, lat
 real, intent(in),  dimension (nx*ny)  :: f
 real, intent(out), dimension (nobs)   :: g
 integer :: i, j, k, k11, k12, k21, k22
 integer :: im, ip, jm, jp
 real :: lat1, lat2, lon1, lon2, dlat2
 real :: zlat1, zlat2, zlon1, zlon2
!
 do k = 1, size(lon)
   i = int((lon(k) - lon_0)/dlon) + 1
   j = int((lat(k) - lat_0)/dlat) + 1
   lon1 = lon_0 + (i-1)*dlon
   lon2 = lon_0 + (i  )*dlon
   lat1 = lat_0 + (j-1)*dlat
   lat2 = lat_0 + (j  )*dlat
! keep original lat/lon for bilinear interpolation    
   zlon1 = lon1
   zlon2 = lon2
   zlat1 = lat1
   zlat2 = lat2
! check if surrounding points are outside lat/lon domain
! go beyond North pole if necessary and then modify longitude
   if (lat1 > 90.0) then
      dlat2 = lat1 - 90.0
      lat1 = 90.0 - dlat2
      lon1 = lon1 + 180.0
      if (lon1 > 360.) lon1 = lon1 - 180.
   endif 
   if (lat2 > 90.0) then
      dlat2 = lat2 - 90.0
      lat2 = 90.0 - dlat2
      lon2 = lon2 + 180.0
      if (lon2 > 360.) lon2 = lon2 - 180.
   endif   
!  redefine surrounding points
   ip = (lon2 - lon_0)/dlon + 1
   im = (lon1 - lon_0)/dlon + 1
   jp = (lat2 - lat_0)/dlat 
   jm = (lat1 - lat_0)/dlat
!
   k11 = im + nx*jm
   k21 = ip + nx*jm
   k12 = im + nx*jp
   k22 = ip + nx*jp
!  
   g(k) = f(k11)*(zlon2  - lon(k))*(zlat2  - lat(k))  + &
&         f(k21)*(lon(k) - zlon1 )*(zlat2  - lat(k))  + &
&         f(k12)*(zlon2  - lon(k))*(lat(k) - lat1 )  + &
&         f(k22)*(lon(k) - zlon1 )*(lat(k) - zlat1 ) 
   g(k) = g(k)/(dlat*dlon) 
  enddo
 return
end subroutine interpol
