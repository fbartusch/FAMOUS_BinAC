export UMDIR=/beegfs/work/tu_iioba01/FAMOUS
export DATA_DIR=/beegfs/work/tu_iioba01/tickets/famous/output
export UMUI_RUNS=$DATA_DIR
source /usr/share/Modules/init/ksh
export PATH=/beegfs/work/tu_iioba01/mpich/bin:$PATH
export MPICH_DIR=/beegfs/work/tu_iioba01/mpich/
export MPI_DIR=/beegfs/work/tu_iioba01/mpich/

export UM_SED=sed
export UM_GREP=grep
export UM_AWK=awk
export PATH=$UMDIR/bin:$PATH
export MPIF90_UM=mpifort
