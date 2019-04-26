# Docker

Containerised analysis pipeline for Salmonella thypi using Docker containers

Pipline steps:
  0) creating soft links
  1) QC on raw data using FastQC and MultiQC
  2) Trimmomatic
  3) QC on trimmed data using FastQC and MultiQC
  4) Spades
  5) File renaming
  6) Use results in Pathogenwatch.com (manual step)
  
usefull commands:
  - to build containers out of the image-files (dockerfiles): $docker build --tag "imagename":"version" .
  - to run the created image: $ docker run "imagename":"version"
