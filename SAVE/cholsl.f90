subroutine cholsl(n,a,p,b,x)
 implicit none
 integer, intent(in) :: n
 real, dimension (n,n),  intent(in) :: a
 real, dimension (n),  intent(in)   :: p,b
 real, dimension (n), intent(inout) :: x
 integer :: i
 do i=1,n
   x(i) = (b(i) - dot_product(a(i,1:i-1),x(1:i-1)))/p(i)
 enddo
 do i=n,1,-1
   x(i) = (x(i) - dot_product(a(i+1:n,i),x(i+1:n)))/p(i)
 enddo
end subroutine cholsl
