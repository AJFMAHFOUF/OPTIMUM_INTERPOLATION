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
 real, intent(in), dimension (nobs)    :: lon, lat
 real, dimension (nx*ny),  intent(in)   :: f
 real, intent(out), dimension (nobs)   :: g
 integer :: i, j, k, k11, k12, k21, k22
 real :: lat1, lat2, lon1, lon2
!
 do k = 1, size(lon)
   i = int((lon(k) - lon_0)/dlon) + 1
   j = int((lat(k) - lat_0)/dlat) + 1
   lon1 = lon_0 + (i-1)*dlon
   lon2 = lon_0 + (i  )*dlon
   lat1 = lat_0 + (j-1)*dlat
   lat2 = lat_0 + (j  )*dlat
   k11 = i +     nx*(j - 1)
   k21 = i + 1 + nx*(j - 1)
   k12 = i     + nx* j
   k22 = i + 1 + nx* j
   g(k) = f(k11)*(lon2   - lon(k))*(lat2   - lat(k))  + &
&         f(k21)*(lon(k) - lon1  )*(lat2   - lat(k))  + &
&         f(k12)*(lon2   - lon(k))*(lat(k) -  lat1 )  + &
&         f(k22)*(lon(k) - lon1  )*(lat(k) -  lat1 ) 
   g(k) = g(k)/(dlat*dlon) 
  enddo
 return
end subroutine interpol
