# Docker

Containerised analysis pipeline for Salmonella thypi using Docker containers and the Snakemake tool

Pipline steps:

  Done: 
  0) copying files for  original location to the current-analysis folder (data/)
  1) QC on raw data using FastQC
  WIP:
  2) QC on raw data using MultiQC
  2) Trimmomatic
  3) QC on trimmed data using FastQC
  4) QC on trimmed data usisg MultiQC
  4) Spades
  5) File renaming
  6) copy all results back to the original location (clean/ empty the current-analysis folder)
  7) Use results in Pathogenwatch.com (manual step)
  
usefull commands:
  - to build containers out of the image-files (dockerfiles): $docker build --tag "imagename":"version" .
  - to run the created image: $ docker run "imagename":"version"
