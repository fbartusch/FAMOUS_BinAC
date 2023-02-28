FAMOUS. A portable version of the FAMOUS climate model based on HadCM3
from the Met Office. It comes complete with pre-compile executables
and can be used out of the box. It is also fully compatible with
UM vn4.5 and be can used to build any UM vn4.5 configuration.

Access to puma.nerc.ac.uk is required. The Intel fortran compiler is required
for any new model builds.

Please see: http://cms.ncas.ac.uk/wiki/UmFamous

# Get it run on BinAC

! This README is currently under development, thus not complete and things may also change !

## Prerequisities

1. Clone this repository

2. Unpack data dumps
```
cd FAMOUS_BinAC/data/dumps
gunzip xfhcra#da000009244c1+_d.gz 
gunzip xfhcro#da000009244c1+_d.gz 
gunzip xfxwba#da000005001c1+.gz 
gunzip xfxwbo#da000005001c1+.gz 
```

3. Compile MPICH
To my knowledge gcom was works with MPICH.
It could maybe work with other MPI implementations, but I didn't try it.
This should be a module on BinAC, but at the current state of try&error I just installed it in my own workspace.
I followed this guide: https://www.mpich.org/static/downloads/4.0.2/mpich-4.0.2-installguide.pdf

```
# Added to jobscript:
module load compiler/intel/17.0

cd /beegfs/work/tu_iioba01/tickets/famous
wget https://www.mpich.org/static/downloads/3.2.1/mpich-3.2.1.tar.gz
tar xzf mpich-3.2.1.tar.gz
module load compiler/intel/17.0
cd mpich-3.2.1
mkdir /beegfs/work/tu_iioba01/mpich
mkdir -p /tmp/iioba01/mpich_build
cd /tmp/iioba01/mpich_build
unset F90
unset F90FLAGS
/beegfs/work/tu_iioba01/tickets/famous/mpich-3.2.1/configure \
  --prefix=/beegfs/work/tu_iioba01/mpich \
  --enable-fortran=yes |& tee c.txt
make -j 14 2>&1 | tee m.txt
make install 2>&1 | tee mi.txt
```

4. Compile gcom</br>
Reference: https://cms.ncas.ac.uk/miscellaneous/um-famous/#intel-fortran-mpi-and-gcom
Afterwards the file `$UMDIR/gcom3.8/gcom/lib/libgcom_buffered_mpi.a` should now exist.

```
module load compiler/intel/17.0
export CXX=/opt/bwhpc/common/compiler/intel/2017/bin/icc
export C=/opt/bwhpc/common/compiler/intel/2017/bin/icc
export MPIF90_UM=${MPICH_DIR}/bin/mpif90
export UMDIR=/beegfs/work/tu_iioba01/FAMOUS
export MPICH_DIR=/beegfs/work/tu_iioba01/mpich/

cd $UMDIR/gcom3.8/gcom
make
```

I had the problem that some system libraries at `/usr/lib64` were not found by the linker. If I copied them to the gcom directory they were found:

```
cp libpthread.a librt.a libm.a libc.a libdl.a /beegfs/work/tu_iioba01/FAMOUS/gcom3.8/gcom/lib
[tu_iioba01@login03 lib64]$ ll /beegfs/work/tu_iioba01/FAMOUS/gcom3.8/gcom/lib
total 180
-rw-r--r-- 1 tu_iioba01 tu_tu 5105516 Feb 28 12:37 libc.a
-rw-r--r-- 1 tu_iioba01 tu_tu   13138 Feb 28 12:37 libdl.a
-rw-r--r-- 1 tu_iioba01 tu_tu  611586 Oct 13 14:42 libgcom_buffered_mpi.a
-rw-r--r-- 1 tu_iioba01 tu_tu 2157820 Feb 28 12:37 libm.a
-rw-r--r-- 1 tu_iioba01 tu_tu  152194 Feb 28 12:37 libpthread.a
-rw-r--r-- 1 tu_iioba01 tu_tu   75902 Feb 28 12:37 librt.a
```

## How to compile new model

There are many options and commands in the scripts that only run on a special cluster.
We have to change and adopt these things in order to get it running on BinAC.

0. Get the required files from UMUI and copy it to the BinAC.
TODO: Document which options to tick on UMUI.
The example used here is called `xpkch`

1. Patch SUBMIT for BinAC
Changes some values in SUBMIT, such that it works with BinAC's batch system
Input: `~/$exp_id/SUBMIT`
Output: modified `modified ~/$exp_id/SUBMIT`
Adjustments made:
 - remove ". /etc/profile" on line 4
 - QUEUE_NRUN=normal -> QUEUE_NRUN=long (line 39)
 - QUEUE_CRUN=normal -> QUEUE_CRUN=long (line 43)
 - MEMORY=500Mw -> MEMORY=50gb (line 48)
 - ACCOUNT=n02-qesm -> ACCOUNT=$USER (line 56)
 - $qsubCmd1 -> #$qsubCmd1 (line 360)
 Notes: The original SUBMIT script gets a backup. Don't run the command two times before restoring the original SUBMIT first!
 
 ```
 /beegfs/work/tu_iioba01/FAMOUS/bin/patch_submit xpnca
 ```
 
 2. Edit "Hand edit section" in SUBMIT if required
 
 3. Run umsubmit_binac
 Creates directory structure. It expects that `~/$exp_id` exists and is already patched
 Input: `$exp_id`
 Prerequesite: `$exp_id` directory exists in home (for example: ~/xpkch). This comes directly from the UMUI
 Output: 
 - Directory structure under $DATA_DIR
 - $DATA_DIR/umui_runs/xpkch-<runid>
 - $DATA_DIR/umui_jobs/xpkc
 - adjustes SUBMIT with submitid changed
 Note: Later this should run the adjusted SUBMIT automatically, but this is disabled as it's not automated yet.
 
 ```
 /beegfs/work/tu_iioba01/FAMOUS/bin/umsubmit_binac xpnca
 ```
 
 4. Run adjusted SUBMIT
 Input: nothing
 Output: Jobscript called `qsubmit.login01.binac.uni-tuebingen.de`
 
 ```
 cd /beegfs/work/tu_iioba01/tickets/famous/output/umui_runs/xpnca-<runid>
./SUBMIT
 ```
 
 5. Patch the jobscript
 The jobscript is not compatible with BinAC's Moab/Torque. So change the whole header:
 
 ```
 #!/bin/ksh

#PBS -l nodes=1:ppn=1
#PBS -l mem=20gb
#PBS -l walltime=10:00:00
#PBS -q short
#PBS -S /bin/ksh
#PBS -e /beegfs/work/tu_iioba01/tickets/famous/xpnca_run4_e.out
#PBS -o /beegfs/work/tu_iioba01/tickets/famous/xpnca_run4_o.out

# Make sure module commands are availabe
source ~/.profile
module load compiler/intel/17.0

export UMDIR=/beegfs/work/tu_iioba01/FAMOUS
export DATA_DIR=/beegfs/work/tu_iioba01/tickets/famous/output
export UMUI_RUNS=$DATA_DIR
export PATH=/beegfs/work/tu_iioba01/mpich/bin:$PATH
export MPICH_DIR=/beegfs/work/tu_iioba01/mpich/
export MPI_DIR=/beegfs/work/tu_iioba01/mpich/
export UM_SED=sed
export UM_GREP=grep
export UM_AWK=awk
export MPIF90_UM=mpifort
```

 6. Run the job
 There is now a submittable jobscript. But there are some problems when compiling/linking the new model:
 
 ```
 qsub qsubmit.login01.binac.uni-tuebingen.de
 ```

