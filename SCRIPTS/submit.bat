#!/bin/bash
set -evx
#
# Define working directories
# --------------------------
#
dir=/home/jean-francois/OPTIMUM_INTERPOLATION
path1=${dir}/SCRIPTS
path2=${dir}/SRC
path3=${dir}/DATA
path4=${dir}/OUTPUT
path5=${dir}/PLOTS
WORKDIR=/tmp/workdir
cd $WORKDIR

expid=$2
exptype=$1
#
#  Get first-guess file
#  --------------------
#
cp ${path3}/t850_guess_res150.dat fort.55
#
#  Get observation file
#  --------------------
#
cp ${path3}/t850_obs_weather_stations.dat fort.20
#
#  Execute Optimum Interpolation
#  -----------------------------
#
cp ${path2}/namelist fort.8 
#
${path2}/main-oi > ${path4}/listing_${exptype}_${expid}.txt
#
#  Store results
#  -------------
#
mv fort.90 ${path4}/first_guess_${exptype}_${expid}.dat
mv fort.91 ${path4}/analysis_increment_${exptype}_${expid}.dat
mv fort.92 ${path4}/analysis_error_${exptype}_${expid}.dat
#
#  Remove useless files
#  --------------------
#
rm -f fort.* t850_obs2.dat
