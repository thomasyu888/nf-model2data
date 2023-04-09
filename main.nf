
// Find your tower s3 bucket and upload your input files into it
// The tower space is PHI safe
nextflow.enable.dsl = 2

params.input

process run_docker {
    debug true
    secret 'SYNAPSE_AUTH_TOKEN'
    
    input:
    path files

    output:
    path 'predictions.csv'

    script:
    """
    echo \$SYNAPSE_AUTH_TOKEN | docker login docker.synapse.org --username foo --password-stdin
    docker run -v $files:/input:ro -v \$PWD:/output:rw docker.synapse.org/syn4990358/challengeworkflowexample:valid
    """
}

workflow {
    // "s3://genie-bpc-project-tower-bucket/**"
    // How to log into private docker registry on nextflow tower
    input_files = Channel.fromPath("$params.input", type: 'dir')
    run_docker(input_files)
}