
// Find your tower s3 bucket and upload your input files into it
// The tower space is PHI safe
nextflow.enable.dsl = 2

params.input_dir = "/example_model/data"
params.output_dir = "/output"
params.username = "bwmac"
params.container = "docker.synapse.org/dpe-testing/example_model:v1"

process run_docker {
    debug true
    
    input:
    path input_dir
    path output_dir
    val username
    val auth_token
    val container

    output:
    path 'predictions.csv'

    script:
    """
    echo $auth_token | docker login docker.synapse.org --username $username --password-stdin
    docker run -v $input_dir:/input:ro -v $output_dir:/output:rw $container
    """
}

workflow {
    // "s3://genie-bpc-project-tower-bucket/**"
    // How to log into private docker registry on nextflow tower
    // Need to figure out how to add this as a channel
    // input_files = Channel.fromPath("$params.input", type: 'dir')
    // input_files = params.input
    // docker_images = Channel.fromList(input_docker_list)
    // challenge_channel = Channel.from(params.input_dir, params.output_dir, params.container, params.username, params.auth_token, params.container)
    run_docker(params.input_dir, params.output_dir, params.username, params.auth_token, params.container)
}
