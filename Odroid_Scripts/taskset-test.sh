#!/bin/bash

# Script to try and locate child PIDs in order to assign specific threads to cores using taskset.

# Colors for BASH
normal="\e[0m"		# normal/default text color
bldblu="\e[1;34m"	# bold blue
bldgrn="\e[1;32m"	# bold green
bldred="\e[1;31m"	# bold red
bldpur="\e[1;35m"	# bold purple

# Miscellaneous
# Note: Only 0, 1, and 2 currently have Heartbeats API installed.
packages=([0]='bodytrack' [1]='blackscholes' [2]='ferret' [3]='facesim' [4]='fluidanimates' [5]='freqmine' [6]='raytrace' [7]='swaptions' [8]='vips' [9]='x264')
sizes=([0]='test' [1]='simdev' [2]='simsmall' [3]='simmedium' [4]='simlarge' [5]='native')
ops=([0]='build' [1]='clean' [2]='uninstall' [3]='run')
pkgmods=([0]='' [1]='-c gcc-hooks-poet')

# Experiment Variables
op=${ops[3]}			# run, build, uninstall, clean (listed in $ops)
hooks=${pkgmods[1]}		# hooks settings (listed in $pkgmods)
package=${packages[0]}		# PARSEC Benchmark (listed in $packages)
input_size=${sizes[4]}		# size of benchmark input sample
numthd='4'			# number of threads

# Trying to get taskset to locate PIDs
{
    parsecmgmt -a $op $hooks -p $package -i $input_size -n $numthd
    sleep 5
    SCRIPTID=$$
    NEXTID=$(($$ + 1))
    echo -e "\nStopping PID: "${SCRIPTID}" "${NEXTID}
    pkill -SIGTERM $SCRIPTID && pkill -SIGTERM $NEXTID	#script terminates after some time
} &		# run as a background task to let pgrep get PID

#sudo perf record -a -g -s 20		# profile the system for 20 secs; currently doesn't work

# DEBUG info
OUTPUT="$(pgrep parsecmgmt)"	# get PID of parsecmgmt
#CHILD="$(pgrep -P ${OUTPUT})"
#PKG="$(pgrep $package)"		# get PID of package name if it exists in case missing a process
RUNNING="$(ps -aux)"		# get list of all running processes; for debug
#MYDIRS="$(find /proc/${OUTPUT}/task -type d)"	# get list of all child processes (directories) of parsecmgmt; for debug
MYFILES="$(find /proc/${OUTPUT}/task -type f)"	# get list of all child processes (files) of parsecmgmt; for debug
MYSTATUS="$(cat /proc/${OUTPUT}/status)"	# print the status of the parent in the shell

COUNTER="0"
# Print DEBUG info
while [ $COUNTER -lt "5" ]
do
    OUTPUT="$(pgrep parsecmgmt)"    # get PID of parsecmgmt
    OUTARR=(${OUTPUT[@]})
    RUNNING="$(ps -aux)"            # get list of all running processes; for debug
    MYFILES="$(find /proc/${OUTPUT}/task -type f)"  # get list of all child processes (files) of parsec$
    MYSTATUS="$(cat /proc/${OUTPUT}/status)"        # print the status of the parent in the shell
    echo -e "LENGTH: "${#OUTARR[@]}

#    echo -e "${bldgrn}OUTPUT${normal}=${bldpur}${OUTPUT}${normal}"
#    echo -e "${bldgrn}CHILD${normal}=${bldpur}${CHILD}${normal}"
#    echo -e "${bldpur}MYFILES${normal}=\n${bldgrn}${MYFILES}${normal}"
#    echo -e "${bldblu}MYSTATUS${normal}=\n${bldpur}${MYSTATUS}${normal}"


    for id in ${OUTARR[@]}
    do
	echo -e "ID=${id}"
	a="$(find /proc/${id}/task -type f)"
	b="$(cat /proc/${id}/status)"
	c="$(pgrep -P ${id})"
	clist="$(${c[@]})"
	d="$(ps -aux)"
        PROCTREE="$(pstree)"

	echo -e "${bldblu}DIRS=${a}${normal}"
	echo -e "${bldpur}STAT=${b}${normal}"
	echo -e "${bldgrn}CHILD=${c}${normal}"
	echo -e "CHILD_LENGTH=${#clist[@]}"
#	echo -e "${bldred}ALLPROCS=\n${d}${normal}"
        echo -e "${bldred}${PROCTREE}${normal}"

    done

    COUNTER=$((${COUNTER}+1))
    sleep 1				# Wait one second
done

#echo -e "${bldgrn}OUTPUT${normal}=${bldpur}${OUTPUT}${normal}"
#echo -e "${bldgrn}CHILD${normal}=${bldpur}${CHILD}${normal}"
#echo -e "${bldgrn}PKG${normal}=${bldpur}${PKG}${normal}"
#echo -e "${bldblu}MYDIRS${normal}=\n${bldgrn}${MYDIRS}${normal}"
#echo -e "${bldpur}MYFILES${normal}=\n$${bldblu}{MYFILES}${normal}"
#echo -e "${bldpur}MYSTATUS=${MYSTATUS}${normal}"
#echo -e "\n${bldred}RUNNING${normal}=\n${RUNNING}"

exit 0
# END OF DOCUMENT
