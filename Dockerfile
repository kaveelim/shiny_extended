FROM rocker/shiny-verse:4.2

RUN sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y install libhdf5-dev

RUN sudo apt-get -y install libbz2-dev liblzma-dev build-essential libglpk-dev libgsl-dev

RUN sudo R -e 'install.packages(c("BiocManager","MASS","mgcv","nlme"))' \
 && install2.r --error --deps TRUE devtools \
 && R -e 'devtools::install_github(repo = "hhoeflin/hdf5r")' \
 && R -e 'devtools::install_github(repo = "mojaveazure/loomR", ref = "develop")'

RUN R -e 'BiocManager::install("Rhtslib")'

RUN R -e 'install.packages("igraph")'


RUN R -e 'BiocManager::install(c( "S4Vectors", "SummarizedExperiment", "SingleCellExperiment", "MAST", "DESeq2", "BiocGenerics", "GenomicRanges", "GenomeInfoDb", "IRanges", "rtracklayer", "monocle", "Biobase", "limma", "multtest"))'

# Fix gdal-config not found
RUN sudo apt-get -y install libgdal-dev libudunits2-dev

RUN install2.r --error \
 --deps TRUE \
 sf

RUN install2.r --error \
 --deps TRUE \
 shinyjs \
 Seurat \
 devtools \
 plotly \
 DT \
 && R -e 'BiocManager::install("rhdf5")' \
 && R -e 'devtools::install_github("pachterlab/sleuth")' \
 && R -e 'devtools::install_github("thomasp85/patchwork")' \
 && rm -rf /tmp/downloaded_packages

# Additional R packages
RUN install2.r --error \
 --deps TRUE \
 shinycssloaders \
 waiter \
&& rm -rf /tmp/downloaded_packages
