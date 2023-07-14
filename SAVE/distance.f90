function distance(lat1,lon1,lat2,lon2)
!--------------------------------------------------------
! Compute the distance between two points on the earth 
! (Haversine formula) [result in meters]
!
!                             J.-F. Mahfouf (02/07)
!--------------------------------------------------------
 use consts
 implicit none
 real                :: distance
 real,   intent(in)  :: lat1, lon1, lat2, lon2
 real ::  za, zdlat, zdlon
!
 zdlat = (lat2 - lat1)*conv
 zdlon = (lon2 - lon1)*conv
! za = sin(0.5*zdlat)**2 + cos(lat1*conv)*cos(lat2*conv)*sin(0.5*zdlon)**2
! distance = 2.0*R_earth*atan2(sqrt(za),sqrt(1.- za))
 distance = R_earth*sqrt((zdlon*cos(lat1*conv))**2 + zdlat**2)
end function distance
