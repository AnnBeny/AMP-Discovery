#!/bin/bash
# . activate AMP-ann
nextflow -C /mnt/hdd2/anna/AMP/src/nextflow.config run /mnt/hdd2/anna/AMP/src/project/annbeny/amp-nextflow_nf -profile high_mem -with-report -resume 

# . activate nextflow 
# nextflow run /mnt/hdd2/kristina/AMP-nextflow/src/project/xsvato01/amp-nextflow_nf -c nextflow.config -resume 

# ./nextflow-24.04.4-all  kuberun kamilareblova/amplikony -r main -head-image 'cerit.io/nextflow/nextflow:24.04.4' \
# -resume -with-report -c ./nextflow.config  --baseDir /cmbg/sequencing_results/primary_data/