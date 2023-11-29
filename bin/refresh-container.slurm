#!/usr/bin/env bash
#SBATCH -p day
#SBATCH -e psyc261.sif.%j.err
#SBATCH -o psyc261.sif.%j.log

cd ~

echo "Starting at ... $(date)"

CLASS_PREFIX="/gpfs/gibbs/project/psyc261/shared"

apptainer \
  pull \
  ${CLASS_PREFIX}/psyc261.sif \
  docker://ghcr.io/cnclgithub/algorithms-of-the-mind:latest

echo "Finished at ... $(date)"
