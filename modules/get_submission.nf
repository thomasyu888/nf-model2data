process get_submission {
    debug true
    secret 'SYNAPSE_AUTH_TOKEN'
    container 'sagebionetworks/challengeutils'

    input:
    val subid

    output:
    file 'submission.json'

    script:
    """
    challengeutils download-submission $subid --output submission.json
    """
}
