#!/bin/bash

# Script to run multiple instances of parsecmgmt benchmarks and record whatever perf data possible.
# Created by Philip Ni

# Miscellaneous
# Note: Only 0, 1, and 2 currently have Heartbeats API installed.
packages=([0]='bodytrack' [1]='blackscholes' [2]='ferret' [3]='facesim' [4]='fluidanimates' [5]='freqmine' [6]='raytrace' [7]='swaptions' [8]='vips' [9]='x264')
sizes=([0]='test' [1]='simdev' [2]='simsmall' [3]='simmedium' [4]='simlarge' [5]='native')
ops=([0]='build' [1]='clean' [2]='uninstall' [3]='run')
pkgmods=([0]='' [1]='-c gcc-hooks-poet')

# Experiment Variables
op=${ops[3]}			# run, build, uninstall, clean (listed in $ops)
hooks=${pkgmods[1]}		# hooks settings (listed in $pkgmods)
input_size=${sizes[3]}		# size of benchmark input sample
numthd='1'			# number of threads
numruns='1'			# number of times we run a single benchmark to get average performance from the perf profiler

# Testing out multiple parsecmgmt instances using background tasks (&)
benchmarks=(${packages[0]} ${packages[1]})
ALLPROCS="$(ps -aux)"

{
    for benchmark in ${benchmarks[@]}
    do
	echo ${benchmark}
#	perf record -a -g -s sleep 20		# doesn't seem to work; supposed to record system process utilization to perf.data
	parsecmgmt -a ${op} ${hooks} -p ${benchmark} -i ${input_size} -n ${numthd} &	# running parsecmgmt without perf
#	perf stat -r ${numruns} parsecmgmt -a ${op} ${hooks} -p ${benchmark} -i ${input_size} -n ${numthd} &
    done
} &

PARSEC_ID="$(pgrep parsecmgmt)"		# get PIDs for all instances of parsecmgmt
PID_ARR=(${PARSEC_ID})			# put PIDs into an array

# DEBUGGING PIDs; comment out when running test
echo -e "\e[35m${ALLPROCS}\e[0m"	# print all running processes
echo -e "\e[32;1mPARSEC_ID\e[0m="${PARSEC_ID}"\e[0m"	# print PIDs
echo -e "\e[32;1mPID[0]=${PID_ARR[0]}\e[0m"		# print first PID to check array contents
echo -e "\e[32;1mPID[4]=${PID_ARR[4]}\e[0m"		# print fourth PID to check array contents
echo -e "\e[32;1mpid_entries=${#PID_ARR[@]}\e[0m"	# print the length of array

coreid="0"

for pid in ${PID_ARR[@]}
do
    echo -e ${coreid}
    if [ "${coreid}" -lt "1" ]	# first four parsec benchmarks assigned to big cores
    then
    	echo -e "\e[37;1mAssigning pid=${pid} to big...\e[0m"
#	taskset -cp ${coreid} ${pid}
    else			# last four parsec benchmarks assigned to LITTLE cores
	echo -e "\e[35;1mAssigning pid=${pid} to LITTLE...\e[0m"
#	taskset -cp ${coreid} ${pid}
    fi
    coreid=$((${coreid}+1))
done

exit 0
# END OF DOCUMENT
