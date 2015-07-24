#Cleanup heartbeats shared memory
#Connor Imes (2015-01-15)

#Must run script with root priveledges
if [ `id -u` -ne 0 ]
then
    echo "Please run with root priveledges."
    exit 1
fi

MEMS=`ipcs | grep $USER | awk '{print $2}'`

for k in $MEMS
do
    echo Freeing $k
    ipcrm -m $k
done
