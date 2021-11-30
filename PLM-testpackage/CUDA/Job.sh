#!/bin/bash -l
#SBATCH --time=00:15:00
#SBATCH --job-name=vlasigputest
#SBATCH --account=project_2004522
##SBATCH --account=project_2002873
#SBATCH --gres=gpu:a100:1
#SBATCH --partition=gputest
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --nodes=1

# set the number of threads based on --cpus-per-task
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
# Bind OpenMP threads to hardware threads
export OMP_PLACES=cores
export PHIPROF_PRINTS=compact,full


ht=2    #hyper threads per physical core
t=$OMP_NUM_THREADS     #threads per process
nodes=$SLURM_NNODES

#mahti has 2 x 64 cores
cores_per_node=128
total_units=$(echo $nodes $cores_per_node $ht | gawk '{print $1*$2*$3}')
units_per_node=$(echo $cores_per_node $ht | gawk '{print $1*$2}')
tasks=$(echo $total_units $t  | gawk '{print $1/$2}')
tasks_per_node=$(echo $units_per_node $t  | gawk '{print $1/$2}')

#export OMPI_MCA_coll=^hcoll

module purge
module load nvhpc/21.2
module load openmpi/4.0.5-cuda
module load cuda/11.2
module load nsight-systems/2021.1
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/projappl/project_2002873/libraries/clang/10.0.0/boost/lib

umask 007
ulimit -c unlimited

srun -n 1 -N 1 vlasiator --version
#srun --mpi=pmix vlasiator --run_config acctest_2_maxw_500k_100k_20kms_10deg_1.cfg
#nvidia-cuda-mps-control -d
#srun vlasiator --run_config acctest_2_maxw_500k_100k_20kms_10deg_1.cfg
#echo quit | nvidia-cuda-mps-control

nsys profile -y 5 -d 30 -w true -t nvtx,mpi,cuda -s none ./vlasiator --run_config acctest_2_maxw_500k_100k_20kms_10deg_1.cfg
#srun vlasiator --run_config acctest_2_maxw_500k_100k_20kms_10deg_1.cfg
