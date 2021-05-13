#!/usr/bin/env nextflow

params.help = 0
params.message_1 = "null"
params.message_2 = "null"
params.message_3 = "null"

message_1 = params.message_1
message_2 = params.message_2
message_3 = params.message_3

def helpMessage(message) {
    log.info"""
    ${message}

    Echo 3 custom messages to output files

    Usage:

    nextflow run jb-adams/echo-nf --message_1 \${MESSAGE_1} --message_2 \${MESSAGE_2} --message_3 \${MESSAGE_3}

    Mandatory arguments:
      --message_1    [str] first message
      --message_2    [str] second message
      --message_3    [str] third message
    
    Optional arguments:
      --help        [flag] display this help message and exit

    """.stripIndent()
}

if (params.help) exit 0, helpMessage("")

if (message_1 == "null") {
    exit 1, helpMessage("ERROR: No --message_1 specified")
}

if (message_2 == "null") {
    exit 1, helpMessage("ERROR: No --message_2 specified")
}

if (message_3 == "null") {
    exit 1, helpMessage("ERROR: No --message_3 specified")
}

process output_message_1 {

    output:
    stdout message_1_stdout
    file 'message_1.txt' into message_1_file

    script:
    """
    echo "STDOUT: writing message 1 to message_1.txt"
    echo "STDERR: writing message 1 to message_1.txt" >&2
    echo "Current message: ${message_1}" > message_1.txt
    """
}

process output_message_2 {

    input:
    file message_1_file

    output:
    stdout message_2_stdout
    file 'message_2.txt' into message_2_file

    script:
    """
    echo "STDOUT: writing message 2 to message_2.txt"
    echo "STDERR: writing message 2 to message_2.txt" >&2
    echo "Contents of previous message: `cat ${message_1_file}`"
    echo "Current message: ${message_2}" > message_2.txt
    """
}

process output_message_3 {

    input:
    file message_2_file

    output:
    stdout message_3_stdout
    file 'message_3.txt' into message_3_file

    script:
    """
    echo "STDOUT: writing message 3 to message_3.txt"
    echo "STDERR: writing message 3 to message_3.txt" >&2
    echo "Contents of previous message: `cat ${message_2_file}`"
    echo "Current message: ${message_3}" > message_3.txt
    """
}
