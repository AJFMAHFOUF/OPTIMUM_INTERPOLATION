subroutine read_obs(nx,ny,nobs)
!----------------------------------------------------
!
! Read observations and select those within the
! model domain (some data outside the domain could
! be retained -> depends on length scale + number
! of observations kept (m value) in the OI
!
!                               J.-F. Mahfouf (02/07)
!-----------------------------------------------------
 use consts
 implicit none
 integer, intent(in)   :: nx, ny
 integer, intent (out) :: nobs
 real :: zlat, zlon, zval, zdum
 integer :: i, ii, ij, nrej
 character (4) :: statid
 open (unit=20,file='canari_t2m_2011091621')
 open (unit=21,file='obs2.dat')
 nobs = 0
 nrej = 0
 do
   read (20,*,end=440) zlon, zlat, zdum, zdum, zdum, zdum, zval  
!   if (zlon < 0.) zlon = zlon + 360.0
!   if (abs(zlon -lon_0) > 180.0) zdum = abs(zlon - lon_0) - 180.0
   ii = int((zlon - lon_0)/dlon) + 1
   ij = int((zlat - lat_0)/dlat) + 1
   print *, zlon, lon_0, zlat - lat_0,ii,ij
   if (ii > 0.0 .and. ii < nx .and. ij > 0.0 .and. ij < ny) then 
     nobs = nobs + 1
     write (21,*) zlat, zlon, zval
   else
     nrej = nrej + 1
   endif
 enddo
 440 continue
 close (unit=20)
 close (unit=21)
 print *,'first data selection after routine READ_OBS'
 print *
 print *,'number of observations retained',nobs
 print *,'number of observations rejected (bad location)',nrej
 print *
 return  
end subroutine read_obs
