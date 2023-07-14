SOURCE	=	mod_consts.f90	\
driver.f90	distance.f90	interpol.f90	\
read_obs.f90	setup.f90	\
select_nearest.f90	sort.f90	sort2.f90	\
background_covariance.f90	\
cholsl.f90	choldc.f90 
#FC = g95
#FFLAGS = -r8
FC = gfortran
#FFLAGS = -fdefault-real-8	
FFLAGS = -O1

OBJECTS	=	$(SOURCE:.f90=.o)

.SUFFIXES:
.SUFFIXES:	.o .f90

.f90.o :
	$(FC)  $(FFLAGS) -c $*.f90

main:	$(OBJECTS)
	$(FC) -o main-oi ${OBJECTS} 

clean:
	 \rm -f $(OBJECTS) *~

fort:
	 \rm -f  fort.* *~

