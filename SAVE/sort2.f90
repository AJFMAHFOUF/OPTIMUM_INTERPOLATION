subroutine sort_heap(n,arr)
 implicit none
 integer, intent(in) :: n
 real, dimension (n), intent(inout) :: arr
 integer :: i
 do i = n/2,1,-1
   call sift_down(i,n)
 enddo
 do i = n,2,-1
   call swap(arr(1),arr(i))
   call sift_down(1,i-1)
 enddo
 contains
 subroutine sift_down(l,r)
  implicit none
  integer, intent(in) :: l,r
  integer :: j,jold
  real :: a
  a = arr(l)
  jold = l
  j = l + 1
  do
    if (j > r) exit
    if (j < r) then
      if (arr(j) < arr(j+1)) j = j + 1
    endif
    if (a >= arr(j)) exit
    arr(jold) = arr(j)
    jold = j
    j = j + 1
  enddo
  arr(jold) = a
  end subroutine sift_down
  subroutine swap(a,b)
  implicit none
  real, intent(inout) :: a, b
  real :: dum
  dum = a
  a = b
  b = dum
  end subroutine swap
end subroutine sort_heap
