PACKS=('blackscholes' 'bodytrack' 'facesim' 'ferret' 'fluidanimate' 'freqmine' 'raytrace' 'swaptions' 'vips' 'x264')

for pack in ${PACKS[@]}
do
    parsecmgmt -a uninstall -c gcc-hooks-poet -p ${pack}
    sleep 5
    parsecmgmt -a clean -c gcc-hooks-poet -p ${pack}
    sleep 5
    parsecmgmt -a build -c gcc-hooks-poet -p ${pack}
    sleep 5m
    parsecmgmt -a run -c gcc-hooks-poet -p ${pack} -n test -i 1
    sleep 5
done
