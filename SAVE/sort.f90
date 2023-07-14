subroutine sort (d,nobs,m,panier)
 implicit none
 real, intent(in) :: d(nobs)
 integer, intent(in) :: m, nobs
 integer, intent(out) :: panier (m)
 integer :: i, max_panier(m)
!
 do i = 1,m
   panier(i) = i
 enddo
!
 max_panier = maxloc(d(panier))
!
 do i = m+1,size(d)
  if (d(i) < d(panier(max_panier(1)))) then
    panier(max_panier(1)) = i
    max_panier = maxloc(d(panier))
  endif
 enddo
!
end subroutine sort
