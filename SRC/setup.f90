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
 namelist/grid/lat_0, lon_0, dlat, dlon, nx, ny
 namelist/oi/sig_b, sig_o, l_scale, m, corr_model
!
! Physical constants
!
 R_earth = 6371598.0  ! earth radius
 conv = asin(1.)/90.0 ! for angle conversion (deg -> rad)
!
! Grid parameters
!
 lon_0 = 0.0   ! origin in longitude
 lat_0 = -90.0 ! origin in latitude
 dlon = 2.5    ! grid size in longitude
 dlat = 2.5    ! grid size in latitude
 nx = 144      ! number of points along x
 ny = 73       ! number of points along y
!
! Read namelist to change defaults
!
 read(8,nml=grid)
!
! standard deviation of background and observation errors
!
 sig_b = 5.0
 sig_o = 1.0
!
! Correlation length (in km)
!
 l_scale = 500.0
!        
! Number of obs around a model grid point 
!
 m = 10
!
! Choice of horizontal correlation model
! 
 corr_model = 'exp'
!
! Read namelist to change defaults
!
 read(8,nml=oi)
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
 print *,'* observation error = ',sqrt(var_o)
 print *,'* background  error = ',sqrt(var_b)
 print *,'* correlation lengh (km) = ',l_scale/1000.0
 print *,'* nb of obs around a model pt = ',m
 print *,'* choice of horizonal correlation model = ',corr_model
 print *,'*                                    '
 print *,'*******************************************************'
 return
end subroutine setup
