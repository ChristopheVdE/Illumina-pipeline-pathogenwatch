
############################################################################################################
#NAME SCRIPT: MultiQC.sh
#AUTHOR: Christophe van den Eynde
#RUNNING MultiQC
#USAGE: ./runMultiQC.sh
############################################################################################################

#SET VARIABLES----------------------------------------------------------------------------------------------
inputFolder=../00_dataset/QC_fastqc
outputFolder=../00_dataset/QC_MultiQC;
#-----------------------------------------------------------------------------------------------------------

#MultiQC PRE-START-------------------------------------------------------------------------------------------
#CREATE OUTPUTFOLDER IF NOT EXISTS
mkdir -p ${outputFolder};
#REDIRECT OUPUT COMMANDLINE (STDOUT) AND ERRORS (STDERR) INTO FILE
exec 2> ${outputFolder}/stdout_err.txt;

#-----------------------------------------------------------------------------------------------------------

#RUN MultiQC-------------------------------------------------------------------------------------------------
echo
echo "Starting MultiQC on: ${inputFolder}"
multiqc ${inputFolder} -o ${outputFolder}
echo "Done, output file can be found in: ${outputFolder}"
echo
#-----------------------------------------------------------------------------------------------------------


