#!/usr/bin/env bash
################################################################################
# Gets a slice along latitudes with CDO seltimestep
################################################################################
# Entire thing just takes one line
# t1=$(((ni - 1)*ts/nsplit)) # e.g. nsplit=10, ts=200, goes
# t2=$((ni*ts/nsplit - 1)) # e.g. nsplit=10, ts=200, goes 1
filename=$1
nmax=$2 # 1-based indexing, endpoint inclusive
cdo -O -s -seltimestep,1/$nmax $filename out/slice_cdo.nc