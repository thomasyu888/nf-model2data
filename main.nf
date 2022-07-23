
// Find your tower s3 bucket and upload your input files into it
// The tower space is PHI safe

// How to log into private docker registry on nextflow tower
files = Channel.fromPath("s3://genie-bpc-project-tower-bucket/**", type: 'any')

process run_docker {
    echo true
    secret 'SYNAPSE_AUTH_TOKEN'
    
    input:
    path files

    output:
    file 'predictions.csv' into prediction

    script:
    """
    echo \$SYNAPSE_AUTH_TOKEN | docker login docker.synapse.org --username foo --password-stdin
    docker run -v $input:/input:ro -v \$PWD:/output:rw docker.synapse.org/syn4990358/challengeworkflowexample:valid
    """
}