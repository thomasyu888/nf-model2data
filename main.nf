
// Find your tower s3 bucket and upload your input files into it
// The tower space is PHI safe
nextflow.enable.dsl = 2

params.input_dir = "${projectDir}/example_model/data"
params.container = "docker.synapse.org/syn51317219/example_model:v1"
params.cpus = "4"
params.memory = "16"

process run_docker {
    debug true
    secret 'SYNAPSE_AUTH_TOKEN'
    cpus "${cpus}"
    memory "${memory}"
    container "ghcr.io/sage-bionetworks-workflows/nf-model2data/dind_image:1.0"
    

    input:
    val input_dir
    val container
    val cpus
    val memory

    output:
    path 'predictions.csv'

    script:
    """
    echo \$SYNAPSE_AUTH_TOKEN | docker login docker.synapse.org --username foo --password-stdin
    docker run -v $input_dir:/input:ro -v  \$PWD:/output:rw $container
    """
}

workflow {
    // "s3://genie-bpc-project-tower-bucket/**"
    // How to log into private docker registry on nextflow tower
    // Need to figure out how to add this as a channel
    // input_files = Channel.fromPath("$params.input", type: 'dir')
    // input_files = params.input
    // docker_images = Channel.fromList(input_docker_list)
    run_docker(params.input_dir, params.container, params.cpus, params.memory)
}
