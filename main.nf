
// params.command
// params.synid
// params.synapseconfig
// params.inputfile
// params.parentid

def helpMessage() {
    log.info """
    Usage:
    nextflow run Sage-Bionetworks/synapse-nextflow --help
    """.stripIndent()
}

// Show help message
if (params.help) {
    helpMessage()
    exit 0
}

process get_submission {
    input:
    file synapseconfig from file(params.synapseconfig)

    output:
    file 'submission.json' into submission

    script:
    """
    challengeutils -c $synapseconfig download-submission 9695287 --output submission.json
    """
}

process run_docker {
    echo true

    input:
    file sub_info from submission

    output:
    file 'predictions.csv' into prediction

    script:
    """
    repo=`cat $sub_info | jq -r .docker_repository`
    digest=`cat $sub_info | jq -r .docker_digest`
    docker run -v /Users/tyu/sage/nf-model2data:/input:ro -v \$PWD:/output:rw \$repo@\$digest
    """
}

process validate {

    input:
    file pred from prediction
     
    output:
    val "done" into validated

    script:
    """
    #!/usr/bin/python

    with open("$pred", "r") as pred_f:
        text = pred_f.read()
    
    if not text:
        raise ValueError("Must have values")
    """
}

process score {
    echo true

    input:
    val valid from validated
    file pred from prediction

    when:
    valid == 'done'

    script:
    """
    echo 3
    """
}
