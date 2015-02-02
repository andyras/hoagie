#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -V
#$ -N hoagie_hoagie
#$ -m bae -M test@gmail.com
#$ -o /dev/null
#$ -e /dev/null
#$ -pe ortePE 1

function onKill {
echo "DANGER!"
echo "DANGER!"
echo "Job terminated unexpectedly!"
echo "JOB END TIME: $(date +"%F %T")"
echo "JOB DURATION: $(($(date +%s) - ${startTime})) s"
cd ${SGE_CWD_PATH}
exit
}

trap onKill 2 9 15

# Print debug info about job
echo "# Job information"
echo "HOSTNAME: $(hostname)"
echo "DIRECTORY: $(pwd)"
echo "JOB START TIME: $(date +"%F %T")"
startTime=$(date +%s)
echo ""

# create scratch directory
echo "create scratch directory"
SCRATCH_JOB_DIR=${TMPDIR}/$(basename ${SGE_CWD_PATH})
cp -rf ${SGE_CWD_PATH} ${SCRATCH_JOB_DIR}

# Go to SGE working directory
echo "Going to SGE working directory: ${SCRATCH_JOB_DIR}"
cd ${SCRATCH_JOB_DIR}

# Run program
echo "Running program"
echo ""

export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1

./total_dynamix

echo ""
echo "JOB END TIME: $(date +"%F %T")"
echo "JOB DURATION: $(($(date +%s) - ${startTime})) s"
cd ${OWD}

# copy job dir contents back to where they started
echo "copying from scratch to original directory"
cp -rf ${SCRATCH_JOB_DIR}/* ${SGE_CWD_PATH}/
cd $SGE_CWD_PATH

# deleting run script
echo "deleting run script"
rm -f /home/tap620/git/hoagie/hoagie.sh
