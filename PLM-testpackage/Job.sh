#!/bin/bash
SBATCH --job-name=vlasiator
SBATCH --account=<2002873>
SBATCH --partition=gpusmall
SBATCH --time=02:00:00
SBATCH --ntasks=1
SBATCH --cpus-per-task=32
SBATCH --gres=gpu:a100:1
## if local fast disk on a node is also needed, replace above line with:
#SBATCH --gres=gpu:a100:1,nvme:900

## Please remember to load the environment your application may need.
## And use the variable $LOCAL_SCRATCH in your batch job script
## to access the local fast storage on each node.

srun vlasiator <--run_config acctest_2_maxw_500k_100k_20kms_10deg_1.cfg>
