subroutine select_nearest (nobs,nx,ny,lat,lon,k,m,index)
 use consts
 implicit none
 integer, intent(in) :: nobs, k, m, nx, ny
 real,    dimension (nobs), intent(in) :: lat, lon
 integer, dimension (m),   intent(out) :: index
 integer :: i, j, i1, j1
 real :: distance, zlat1, zlon1, zlat2, zlon2 
 real, dimension (nobs) :: d, ds
!
! distance between a given model grid point and all observations
!
 j1 = (k - 1)/nx + 1
 i1 = k - nx*(j1 - 1)  
 zlon1 = (lon_0 + (i1-1)*dlon)
 zlat1 = (lat_0 + (j1-1)*dlat)
!
! compute distances 
!
 do i = 1,nobs
   zlon2 = lon(i)
   zlat2 = lat(i)
   d(i) = distance (zlat1,zlon1,zlat2,zlon2)
 enddo
 call sort (d,nobs,m,index) 
 write (100,*) zlat1,zlon1,sum(d(index))/(float(m)*1.0E3)
 write (101,*) zlat1,zlon1,minval(d(index))/1.E3
! alternative sorting (very slow - not useful with lot of observations)
! ds = d
! call sort_heap(nobs,d)
! do i = 1,m
!   do j = 1,nobs
!     if (ds (j) == d(i)) index(i) = j
!   enddo
! enddo
end subroutine select_nearest
