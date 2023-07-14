program oi
!-----------------------------------------------------------------
!
! Performs an optimum interpolation analysis 
! ------------------------------------------
!
! inputs : field over a geographical domain (lat/lon coordinates)
!          observations (lat,lon,value)
! outputs : analysis and error over the same geographical domain
!
! OI parameters defined in subroutine : setup.f90
!
! External routines : none, but sorting technique and
! matrix inversion (Cholesky decomposition) are coded from NR.
!
!                                           J.-F. Mahfouf (02/07)
!----------------------------------------------------------------
 use consts
 implicit none
 real, allocatable, dimension (:) :: lat, lon, hx, val
 real, allocatable, dimension (:) :: fg, an, field
 integer, allocatable, dimension (:) :: index
 real, allocatable, dimension (:,:) :: b, r
 real, allocatable, dimension (:) :: ph, zp, zx, zb, zy
 real :: background_covariance, var_a, zincr
 integer :: m, i, j, k, i1, j1, i2, j2, nvar, nx, ny, nobs
!
! Initialisation of constants
!
 call setup (nx,ny,m)
!
! Read observation file
!
 call read_obs(nx,ny,nobs)
!
 nvar = nx*ny
!
! Allocate gridded fields
!
 allocate (fg(nvar))
 allocate (an(nvar))
 allocate (field(nvar))
!
! Allocate observation fields
!
 allocate (lat(nobs))
 allocate (lon(nobs))
 allocate (val(nobs))
 allocate (hx(nobs))
!
! Allocate fields with reduced number of obs 
! to solve the analysis problem
!
 allocate (index(m))
 allocate (ph(m))
 allocate (zp(m))
 allocate (zx(m))
 allocate (zb(m))
 allocate (zy(m))
 allocate (r(m,m))
 allocate (b(m,m))
!
! Initialise covariance matrices :
! b = background errors (in obs space)
! r = observation errors
!
 r = 0.
 b = 0. 
 do i = 1, m
   r(i,i) = var_o
 enddo
!
! Background field 
!
 open (unit=55,file='fort.55')
 read (55,*) (fg(k),k=1,nvar)
! do k = 1,nvar
!   fg(k) = 0.0
! enddo
!
! Read selected observations (within the domain)
!
 open (unit=20,file='obs2.dat')
 do i = 1, nobs
   read (20,*) lat(i), lon(i), val(i)
  enddo
 close (unit=20)
!
! Interpolation of model values at observation locations
!
 call interpol(nobs,nx,ny,lat,lon,fg,hx)
!
! Loop over model grid points
!
 do k = 1,nvar
   call select_nearest (nobs,nx,ny,lat,lon,k,m,index)
   write (78,*) k,index
   do i = 1,m
     do j = 1,i
       b(j,i) = var_b*background_covariance (nobs,nx,ny,lat,lon,index(i),index(j),'o') 
     enddo
     ph(i) =  var_b*background_covariance (nobs,nx,ny,lat,lon,k,index(i),'m')
   enddo
!
   do i = 1,m
     b(i,i) = b(i,i)  + r(i,i)
   enddo
!
! Inversion of (B+O) using Cholesky decomposition A=LL^T
!
   call choldc(m,b,zp)
   do i = 1, m 
     zb(i) = val(index(i)) - hx(index(i))
   enddo
! for analysis increments
   call cholsl(m,b,zp,zb,zx)
! for analysis variance
   call cholsl(m,b,zp,ph,zy)
!
!  Analysis with associated variances
!
   zincr = dot_product(ph,zx)
   an(k) = fg(k) + zincr
   var_a = var_b - dot_product(ph,zy)
!
   field(k) = var_a 
!   
 enddo
!
! Print analysis results
!
 print *,'mean background field',sum(fg)/size(an)
 print *,'mean analysis field',sum(an)/size(an)
!
! Write analysis results
!
 WRITE (100,"(A9)")  "#LLMATRIX"
 WRITE (100,"(A13)") "SOUTH = 41.00"
 WRITE (100,"(A12)") "WEST = -6.00"
 WRITE (100,"(A10)") "NLAT = 421"
 WRITE (100,"(A10)") "NLON = 661"
 WRITE (100,"(A18)") "GRID = 0.025/0.025"
 WRITE (100,"(A10)") "HSCAN = WE"
 WRITE (100,"(A10)") "VSCAN = NS"
 WRITE (100,"(A11)") "PARAM = 171"
 WRITE (100,"(A18)") "DATE = 20110807.18"
 WRITE (100,"(A10)") "FCAST = 00"
 WRITE (100,"(A5)") "#DATA"
 AN = AN - FG
 WRITE (100,*) AN
 write (92) field
 write (91) an - fg
!
! Deallocate arrays
! 
 deallocate (fg)
 deallocate (an)
 deallocate (field)
 deallocate (lat)
 deallocate (lon)
 deallocate (val)
 deallocate (hx)
 deallocate (index)
 deallocate (ph)
 deallocate (zp)
 deallocate (zx)
 deallocate (zb)
 deallocate (zy)
 deallocate (r)
 deallocate (b)
!
end program oi
