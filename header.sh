#!/usr/bin/env bash
#------------------------------------------------------------------------------#
# Utilities used for all benchmarks
# NOTE: Sourcing this with no arguments is just as if you copied and pasted these
# lines in the original script, *unless* you also pass arguments in the source
# command and all the $@ are overwritten, but weirdly $0 still refers to the
# original script invoking source no matter what.
#------------------------------------------------------------------------------#
# Initial stuff
#------------------------------------------------------------------------------#
# Global variables
shopt -s nullglob
cwd="$(pwd)"
name="$0"
name="${name%.sh}"
dir="$1" # directories where data is stored
dir="${dir##*/}"
header="| nlat | size | name | real (s) | user (s) | sys (s) |\n| --- | --- | --- | --- | --- | --- |\n"
output="$cwd/logs/"$(echo "$name" | tr A-Z a-z)"_${dir}_${HOSTNAME%%.*}.log" # store here

# Check input directory
[ -z "$dir" ] && echo "Error: Usage is ./Benchmark <dir> where <dir> is the location of NetCDFs for globbing/testing." && exit 1
dir="$cwd/$dir"
! [ -d "$dir" ] && echo "Error: Directory \"$dir\" not found." && exit 1
# Check output directory
! [ -d "$name" ] && echo "Error: Directory \"$name\" not found." && exit 1
cd "$name" # into directory with all the files
! [ -d out ] && mkdir out # in same folder as project
# Get data list
datas=("$dir"/data*.nc)
[ ${#datas[@]} -eq 0 ] && echo "Error: Data directory \"$dir\" is empty." && exit 1

# Remove old stuff
rm "$output" 2>/dev/null
rm "$dir"/*-*.nc 2>/dev/null # remove parallel-produced files

#------------------------------------------------------------------------------#
# Functions
#------------------------------------------------------------------------------#
# Spit out a header onto logfile
# NOTE: Critical that 'size' and 'nlat' are global variables here
# NOTE: The 'disk usage' often very different from the 'apparent size'
# ls -l; former depends on internals of how data is stored, and on Cheyenne,
# ends up way bigger. See: https://unix.stackexchange.com/a/106278/112647
# Explanation of why this happens: https://serverfault.com/a/290091/427991
[[ "$OSTYPE" == "darwin"* ]] && _macos=true || _macos=false
if $_macos && ! type gdu &>/dev/null; then
  echo "Warning: gdu unavailable. Recommend installing it with brew install coreutils."
  cdu='du -h'
elif $_macos; then
  cdu='gdu --apparent-size -h'
else
  cdu='du --apparent-size -h'
fi
printhead() {
  size=$(command $cdu $1 | xargs | cut -d' ' -f1)
  nlat=${1#*N}
  nlat=$(printf '%.0f' ${nlat%T*})
  echo && echo "Dataset: $1 ($size)"
  echo "Logfile: $output"
  printf "\n$header" >>$output # add header for each new file
}
# Convert time command output to raw seconds
seconds() {
  t=$1
  m=${t%m*}
  s=${t#*m}
  s=${s%.*}
  d=${t#*.} # decimal
  echo $((m*60 + s)).${d%s} # converts e.g. 1m35.23s to 85.23s
}
# Run time command
bench() {
  # NOTE: Discard stderr, beause don't care about warnings; for debugging
  # you may need to play with this!
  # NOTE: Preserve stdout, because have Matlab print stuff after startup
  # is complete so we can get better estimate
  # res=$( (time "${@:2}") 2>&1 )
  local real user sys
  [ -z "$debug" ] && debug=false
  if $debug; then
    # Debug mode
    # res=$("${@:2}" 2>&1)
    echo "Debug mode: ${@:2}"
    echo "Result:"
    "${@:2}"
    echo "Exit: $?"
  else
    # Normal mode, time command
    res=$( (time "${@:2}" 2>/dev/null) 2>&1 )
    info="$(echo "${res%real*}" | xargs | tr -s ' ')"
    time="real ${res##*real}"
    array=($time)
    # Get result, tabulate it, add it to markdown file
    if [ -n "$info" ]; then # try to find the number, in seconds
      info="${info##*mathworks.com.}" # only way to remove startup....
      info="$(echo "$info" | sed 's/[^.0-9]//g')"
      real="$(seconds 0m${info%.1}s)" # weirdly, get extra '1' at end of string that is totally invisible before passing through sed
      printf "| $nlat | $size | $1 | **$real** | | |\n" >>$output
    else
      real=$(seconds ${array[1]})
      user=$(seconds ${array[3]})
      sys=$(seconds ${array[5]})
      printf "| $nlat | $size | $1 | **$real** | $user | $sys |\n" >>$output
    fi
    echo $1
    echo ${real}s
  fi
}
# Run NCL on files in parallel using hyperslabs
nclparallel() {
  local name1 name2 glob1 glob2 ts t
  name1="${1%.nc}"
  name2="${1%/*}"/isentropes_ncl
  np=0
  pmax=1000
  pmax=1 # NOTE: try without background parallelization!
  nsplit=10
  ts=$(command ncdump -h ${name1}.nc | grep 'UNLIMITED' | sed 's/[^0-9]//g') # number of timesteps
  for ni in $(seq 1 $nsplit); do
    let np+=1
    t1=$(((ni - 1)*ts/nsplit)) # e.g. nsplit=10, ts=200, goes 0, 20, 40, 60
    t2=$((ni*ts/nsplit - 1)) # e.g. nsplit=10, ts=200, goes 19, 39, 59
    {
    ncks -O -h --no-abc -d time,$t1,$t2 ${name1}.nc ${name1}-${ni}.nc
    ncl -Q -n "filename=\"${name1}-${ni}.nc\"" "outname=\"${name2}-${ni}.nc\"" ${name}.ncl
    } &
    [ $((np % pmax)) -eq 0 ] && wait
  done
  wait
  glob1="$name1"'-*.nc'
  glob2="$name2"'-*.nc'
  ncrcat -O $glob2 "${name2}_parallel.nc"
  rm $glob1 $glob2
}
