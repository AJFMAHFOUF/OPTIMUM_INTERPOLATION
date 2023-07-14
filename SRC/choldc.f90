subroutine choldc(n,a,p)
 implicit none
 integer, intent(in) :: n
 real, dimension(n,n), intent(inout) :: a
 real, dimension(n), intent(out) :: p
 integer :: i
 real :: summ
 do i=1,n
   summ = a(i,i) - dot_product(a(i,1:i-1),a(i,1:i-1))
   if (summ <= 0.0) then
     print*,'error in choldc',summ
     stop
   endif
   p(i) = sqrt(summ) 
   a(i+1:n,i) = (a(i,i+1:n) - matmul(a(i+1:n,1:i-1),a(i,1:i-1)))/p(i)
 enddo
end subroutine choldc 
