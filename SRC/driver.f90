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
 real, allocatable, dimension (:) :: fg0, fg, an, field
 integer, allocatable, dimension (:) :: index
 real, allocatable, dimension (:,:) :: b, r
 real, allocatable, dimension (:) :: ph, zp, zx, zb, zy
 real :: background_covariance, var_a, zincr, zdummy
 real :: t0, t1, t2, t3
 integer :: m, i, j, k, i1, j1, i2, j2, nvar, nx, ny, nobs, ii, jj, kk
!
! Initialisation of constants
!
 call cpu_time(time=t0)
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
 allocate (fg0(nvar))
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
! open (unit=55,file='fort.55')
! read (55,*) (fg(k),k=1,nvar)
 !open (unit=55,file='../DATA/t850_guess.dat')
 open (unit=55,file='fort.55')
 read (55,*) ! skip header
 do k = 1,nvar
   read (55,*) zdummy,zdummy,fg0(k)
 enddo  
!
! Reorganize background array : origin "lower left" instead of "upper left"
! 
 do k = 1,nvar
   j = int((k - 1)/nx) + 1
   i = k - (j - 1)*nx
   kk = nx*(ny - j) + i
   fg(kk) = fg0(k)
 enddo  
 do k = 1,nvar
   fg(k) = 270.0
 enddo
!
! Read selected observations (within the domain)
!
! open (unit=20,file='../DATA/t850_obs2.dat')
 do i = 1, nobs
   read (21,*) lat(i), lon(i), val(i)
  enddo
 close (unit=21)
!
! Interpolation of model values at observation locations
!
 call cpu_time(time=t1)
 call interpol(nobs,nx,ny,lat,lon,fg,hx)
 call cpu_time(time=t2)
!
! Loop over model grid points
!
 do k = 1,nvar
   call select_nearest (nobs,nx,ny,lat,lon,k,m,index)
   !write (78,*) k,index
   do i = 1,m
     do j = 1,i
       b(j,i) = var_b*background_covariance (nobs,nx,ny,lat,lon,index(i),index(j),'o') ! only upper triangle (for choldc)
     enddo
     ph(i) =  var_b*background_covariance (nobs,nx,ny,lat,lon,k,index(i),'m')
   enddo
!
   do i = 1,m
     b(i,i) = b(i,i) + r(i,i)
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
 call cpu_time(time=t3)
!
! Print analysis results
!
 print *,'mean background field = ',sum(fg)/size(an)
 print *,'mean analysis field = ',sum(an)/size(an)
 print *,'total cpu time in sec =',t3-t0
!
! Write analysis results
!
 open (unit=90,file='fort.90')
 open (unit=91,file='fort.91')
 open (unit=92,file='fort.92')
! 
 write (90,*) fg
 write (91,*) an - fg
 write (92,*) field
!
 close (90)
 close (91)
 close (92)
!
! Deallocate arrays
! 
 deallocate (fg0)
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
