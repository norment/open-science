#!/bin/bash

#SBATCH --job-name=RunGWAS_submit
#SBATCH --account=p33_norment
#SBATCH --time=04:00:00
#SBATCH --mem-per-cpu=200M

sbatch --array=1-13 RunGWAS_worker.slurm

