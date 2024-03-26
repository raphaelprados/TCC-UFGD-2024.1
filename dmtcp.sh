#!/bin/bash
#SBATCH --job-name=my_dmtcp_job
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=4
#SBATCH --time=1:00:00

# Load DMTCP module
module load dmtcp

# Start DMTCP coordinator
dmtcp_coordinator --daemon --port 7779 &

# Wait for coordinator to start
sleep 5

# Launch your application with DMTCP
srun dmtcp_launch --join-coordinator -i 3600 --rm mpirun -np 4 ./NPB3.4.2/NPB3.4-MPI/bin/lu.C.x
