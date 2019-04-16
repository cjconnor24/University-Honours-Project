#!/bin/bash

# CHRIS CONNOR
# S1715477
# CCONNO208@CALEDONIAN.AC.UK

# THIS TEST SCRIPT WILL RUN A SUITE OF COLD START TESTS AGAINST THE PURE
# LAMBDA FUNCTIONS. TEST RESULTS WILL BE LOGGED ACROSS THE THREE MEMORY TIERS
# AS OUTLINED IN THE EXECUTION SECTION OF THE REPORT. THE AIM OF THIS TEST IS
# TO BYPASS API GATEWAY COMPLETELY TO COMPARE THE OVERHEADS


# COMMANDLINE INPUT PARAMETERS ./filename.sh [url] [runtime]
# EXAMPLE USAGE: ./PURE_MEMORY_TEST.sh ./java-api JAVA
RUNTIME=$2
RUNTIME_FOLDER=$1

# FILENAME TO LOG RESULTS
RESULTS_FILENAME="results_${RUNTIME}_PURE_MEMORY_REGULAR_${HTTP_METHOD}_$(date +%d-%m-%Y_%H%M).txt"

# MINUTES TO PAUSE FOR COLD START
# MINUTES=30

# CHANGE DIRECTORY INTO THE SPECIFIED RUNTIME FOLDER
cd $RUNTIME_FOLDER

# CREATE COUNTER TO MANAGE ITERATIONS
COUNT=0

# DECLARE ARRAY OF MEMORY TIERS
declare -a MEMORY_TIERS=("512" "1024" "2048")

# LOOP FOR X
until [ $COUNT -gt 200 ]; do

    
    
    # LOOP FOR EACH MEMORY TIER
    for i in "${MEMORY_TIERS[@]}"
    do

        # INVOKE THE LAMBDA DIRECTLY BYPASSING API GATEWAY - PASS DUMMY DATA AND WRITE LOGS TO FILE
        sls invoke -f createTodo$i -l -p ../DUMMY_JSON_DATA.json | tee -a "${i}_${RESULTS_FILENAME}"

        # WAIT 1 SECOND BEFORE CALLING THE NEXT MEMORY TIER
        sleep 0.5s

        # echo "$RUNTIME $i: Sleeping for $MINUTES minutes $(date +%H:%M:%S)"
    done

    # INCREMENT THE COUNTER AND SLEEP FOR X
    let COUNT=COUNT+1
    # sleep $[$MINUTES * 60]
    
done

# RETURN TO CALLING FOLDER
cd ../

# OUTPUT TO CONSOLE TO SHOW THAT TESTS HAVE COMPLETE
echo "Tests complete at $(date)"