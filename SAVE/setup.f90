subroutine setup(nx,ny,m)
!---------------------------------------------------------------------
!
! Define useful constants and OI parameters (changeables in namelist)
!
!                                             J.-F. Mahfouf (02/07)
!---------------------------------------------------------------------
 use consts
 implicit none
 integer, intent(out) :: nx, ny, m
 real :: sig_b, sig_o
! namelist/grid/lat_0, lon_0, dlat, dlon, nx, ny
! namelist/oi/sig_b, sig_o, l_scale, m
!
! Physical constants
!
 R_earth = 6371598.0        ! earth radius
 conv = asin(1.)/90.0 ! for angle conversion (deg -> rad)
!
! Grid parameters
!
 lon_0 = -6.0 ! origin in longitude
 lat_0 = 41.0 ! origin in latitude
 dlon = 0.025   ! grid size in longitude
 dlat = 0.025   ! grid size in latitude
 nx = 661      ! number of points along x
 ny = 421     ! number of points along y
!
! Read namelist to change defaults
!
! read(8,nml=grid)
!
! standard deviation of background and observation errors
!
 sig_b = 10.4
 sig_o = 1.6
!
! Correlation length (in km)
!
 l_scale = 85.0
!        
! Number of obs around a model grid point 
!
 m = 10
!
! Read namelist to change defaults
!
! read(8,nml=oi)
!
! Conversion of l_scale in meter
!
 l_scale = 1000.0*l_scale
!
! Variances
! 
 var_b = (sig_b)**2
 var_o = (sig_o)**2
!
! Print parameters of the OI
!
 print *,'*******************************************************'
 print *,'*               OPTIMUM INTERPOLATION                  '
 print *,'*               ---------------------'
 print *,'*'
 print *,'* observation error =',sqrt(var_o)
 print *,'* background  error =',sqrt(var_b)
 print *,'* correlation lengh (km) =',l_scale/1000.0
 print *,'* nb of obs around a model pt =',m
 print *,'*                                    '
 print *,'*******************************************************'
 return
end subroutine setup
