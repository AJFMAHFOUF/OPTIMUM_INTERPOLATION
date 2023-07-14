function background_covariance (nobs,nx,ny,lat,lon,i,j,type)
 use consts
 implicit none
 real :: background_covariance, distance
 integer, intent(in) ::  i, j , nobs, nx, ny
 real, dimension (nobs), intent(in) :: lat, lon
 character*1, intent(in) :: type
 real :: zlon1, zlat1, zlon2, zlat2, zd
 real :: i1, i2, j1, j2
!
! location of the two points
! 
 if (type == 'o') then
   zlon1 = lon(i)
   zlat1 = lat(i)
 else
   j1 = (i - 1)/nx + 1
   i1 = i - nx*(j1 - 1) 
   zlon1 = (lon_0 + (i1 - 1)*dlon)
   zlat1 = (lat_0 + (j1 - 1)*dlat)
 endif
 zlon2 = lon(j)
 zlat2 = lat(j)
 zd = distance (zlat1,zlon1,zlat2,zlon2)/l_scale
!
! covariance model
!
! background_covariance = exp(-0.5*(zd**2))
 background_covariance = (1.0 + zd)*exp(-zd)
end function background_covariance
