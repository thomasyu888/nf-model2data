
// Find your tower s3 bucket and upload your input files into it
// The tower space is PHI safe
nextflow.enable.dsl = 2

params.input_dir = "./"
params.input_docker = "docker.synapse.org/syn4990358/challengeworkflowexample:valid,docker.synapse.org/syn4990358/challengeworkflowexample:invalid"
input_docker_list = params.input_docker?.split(',') as List

process run_docker {
    debug true
    secret 'SYNAPSE_AUTH_TOKEN'
    
    input:
    path files
    val docker_image

    output:
    path 'predictions.csv'

    script:
    """
    echo \$SYNAPSE_AUTH_TOKEN | docker login docker.synapse.org --username foo --password-stdin
    docker run -v $files:/input:ro -v \$PWD:/output:rw $docker_image
    """
}

workflow {
    // "s3://genie-bpc-project-tower-bucket/**"
    // How to log into private docker registry on nextflow tower
    // Need to figure out how to add this as a channel
    // input_files = Channel.fromPath("$params.input", type: 'dir')
    input_files = params.input
    docker_images = Channel.fromList(input_docker_list)
    run_docker(input_files, docker_images)
}
