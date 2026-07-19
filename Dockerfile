FROM rocker/shiny-verse:4.2.1

ARG BIOCONDUCTOR_VERSION=3.16

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      build-essential \
      libbz2-dev \
      libgdal-dev \
      libgeos-dev \
      libglpk-dev \
      libgsl-dev \
      libhdf5-dev \
      liblzma-dev \
      libproj-dev \
      libudunits2-dev \
 && rm -rf /var/lib/apt/lists/*

# Keep Bioconductor aligned with R 4.2 and avoid interactive package updates.
RUN R -e "install.packages('BiocManager'); BiocManager::install(version = '${BIOCONDUCTOR_VERSION}', ask = FALSE, update = FALSE)" \
 && install2.r --error \
      DT \
      Seurat \
      devtools \
      igraph \
      plotly \
      sf \
      shinycssloaders \
      shinyjs \
      waiter \
 && R -e "BiocManager::install(c( \
      'Biobase', 'BiocGenerics', 'DESeq2', 'GenomeInfoDb', 'GenomicRanges', \
      'IRanges', 'limma', 'MAST', 'monocle', 'multtest', 'rhdf5', 'Rhtslib', \
      'rtracklayer', 'S4Vectors', 'SingleCellExperiment', 'SummarizedExperiment' \
    ), ask = FALSE, update = FALSE)" \
 && R -e "remotes::install_github(c( \
      'hhoeflin/hdf5r@d38b053ea3dd4fd5137ccdd7e561070c98e9bd47', \
      'mojaveazure/loomR@1eca16a60f529944050e2a3419040cb811726699', \
      'pachterlab/sleuth@8bb7aa028c84d11499571059a1d8cd5af13d6295', \
      'thomasp85/patchwork@43253f41d2a19d74c507c60f38718039ad6d551f' \
    ), upgrade = 'never')" \
 && rm -rf /tmp/downloaded_packages /tmp/Rtmp*

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD curl --fail --silent http://localhost:3838/ >/dev/null || exit 1

EXPOSE 3838
