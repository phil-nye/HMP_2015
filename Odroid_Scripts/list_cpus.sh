#!/bin/bash

# Text Styles
norm="\e[0m"			# default bash text settings
bold="\e[38;5;227m\e[1m"	# bold and hex (color) code #227

numcores=$(cat /proc/cpuinfo | grep processor)	# command to get cpu information
#echo -n "String: ${numcores}"
cores=(${numcores})				# put cpu information into a list
#echo -e "Length: ${#cores[@]}\n"
numcores=$((${#cores[@]} / 3))			# number of cpus is size of list div by 3; removes the unneccessary "processor : " from the list and only accounts for the processor numbers
echo -e "Num Cores: ${bold}${numcores}${normal}\n"

cpupath="/sys/devices/system/cpu/cpu"

cpu="0"		# always start with cpu0
while [ ${cpu} -lt ${numcores} ]
do
    echo -e "${norm}CPU: ${bold}${cpu}"

    echo -en "${norm}CPUINFO_MAX_FREQ (kHz): ${bold}"
    cat ${cpupath}${cpu}/cpufreq/cpuinfo_max_freq

    echo -en "${norm}CPUINFO_MIN_FREQ (kHz): ${bold}"
    cat ${cpupath}${cpu}/cpufreq/cpuinfo_max_freq

    echo -en "${norm}CPUINFO_CUR_FREQ (kHz): ${bold}"
    cat ${cpupath}${cpu}/cpufreq/cpuinfo_cur_freq

    echo -en "${norm}AFFECTED_CPUS: ${bold}"
    cat ${cpupath}${cpu}/cpufreq/affected_cpus

    echo -en "${norm}RELATED_CPUS: ${bold}"
    cat ${cpupath}${cpu}/cpufreq/related_cpus

    echo -en "${norm}SCALING_GOVERNOR: ${bold}"
    cat ${cpupath}${cpu}/cpufreq/scaling_governor

    echo -en "${norm}SCALING_MAX_FREQ (kHz): ${bold}"
    cat ${cpupath}${cpu}/cpufreq/scaling_max_freq

    echo -en "${norm}SCALING_MIN_FREQ (kHz): ${bold}"
    cat ${cpupath}${cpu}/cpufreq/scaling_min_freq

    echo -en "${norm}SCALING_SETSPEED: ${bold}"
    cat ${cpupath}${cpu}/cpufreq/scaling_setspeed

    echo -en "${norm}SCALING_DRIVER: ${bold}"
    cat ${cpupath}${cpu}/cpufreq/scaling_driver

    echo -en "${norm}SCALING_AVAILABLE_GOVERNORS: ${bold}"
    cat ${cpupath}${cpu}/cpufreq/scaling_available_governors

    echo -en "${norm}SCALING_AVAILABLE_FREQUENCIES (kHz): ${bold}"
    cat ${cpupath}${cpu}/cpufreq/scaling_available_frequencies

    echo -en "${norm}CPUINFO_TRANSITION_LATENCY (us): ${bold}"
    cat ${cpupath}${cpu}/cpufreq/cpuinfo_transition_latency

    cpu=$((${cpu} + 1))

    echo
done
