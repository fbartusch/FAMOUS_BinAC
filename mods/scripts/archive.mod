*ID ARCHMOD
*/
*/ Allow archiving
*/
*DECLARE qsmain
*I qsmain.653 
  rm $PIPE
*/  /bin/mknod $PIPE p                 # Create named pipe
*/*D CJC1U404.90 
*/*D CJC1U404.99 
*DECLARE copy2dest
*D GLW1U401.390
  DEST_SYS_DIR=$ARCHIVE_DIR
  mkdir -p $DEST_SYS_DIR
*D GLW1U401.416

  # If saving old data, find the timestamp suffix for it
  # The global environment variable OVERWRITE_DATA is set in the
  # SCRIPT jobfile.
  # N means do not overwrite data i.e. save exixting output files with a timestamped name
  # Y means overwrite any existing output files
  if [[ $OVERWRITE_DATA = N ]]
  then   
    timestamp=d$(date +"%y%j").t$(date +"%H%M%S")
  fi

  if [[ $CURRENT_RQST_TYPE = DMP ]]
  then

    if [[ $OVERWRITE_DATA = N ]]
    then        
      mv ${DEST_DATA} ${DEST_DATA}.${timestamp}
    fi
          
    cp $MODEL_FILE $DEST_DATA
  else

        if [[ $OVERWRITE_DATA = N ]]
        then        
	  mv ${DEST_DATA}.pp ${DEST_DATA}.${timestamp}.pp
        else
          rm -f ${DEST_DATA}.pp
        fi
          
        ~jeff/bin/ff2pp $MODEL_FILE ${DEST_DATA}.tmp.pp > /dev/null
	bigend -32 ${DEST_DATA}.tmp.pp ${DEST_DATA}.pp
        /bin/rm -f ${DEST_DATA}.tmp.pp
  fi
*D GLW1U401.503
*D GLW1U401.509
*DECLARE qscasedisp
*D GLW1U401.606
*D GIE2U405.59,GLW1U401.631
*D GIE2U405.60,GLW1U401.658
*DECLARE qsserver
*D GCP1U400.199,GCP1U400.204
*DECLARE newpphist
*/
*I COPYRIGHT.643
#
*DECLARE autopp_tidyup
*/
*I COPYRIGHT.110
#
