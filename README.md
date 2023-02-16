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
