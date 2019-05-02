
############################################################################################################
#NAME SCRIPT: multiqcTrimmomatic.sh
#AUTHOR: Christophe van den Eynde
#RUNNING MultiQC
#USAGE: ./runMultiQC.sh
############################################################################################################

#SET VARIABLES----------------------------------------------------------------------------------------------
inputFolder=/home/data/03_QC-Trimmomatic/QC_fastqc/
outputFolder=/home/data/03_QC-Trimmomatic/QC_MultiQC/;
#-----------------------------------------------------------------------------------------------------------

#MultiQC PRE-START-------------------------------------------------------------------------------------------
#CREATE OUTPUTFOLDER IF NOT EXISTS
mkdir -p ${outputFolder};
#REDIRECT OUPUT COMMANDLINE (STDOUT) AND ERRORS (STDERR) INTO FILE
exec 2>&1 | tee ${outputFolder}/stdout_err.txt;

#-----------------------------------------------------------------------------------------------------------

#RUN MultiQC-------------------------------------------------------------------------------------------------
echo
echo "Starting MultiQC on: ${inputFolder}"
echo "----------"
multiqc ${inputFolder} -o ${outputFolder}
echo "----------"
echo "Done, output file can be found in: ${outputFolder}"
echo
#-----------------------------------------------------------------------------------------------------------


