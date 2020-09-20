FROM rocker/shiny-verse

RUN install2.r --error \
 --deps TRUE \
 shinyjs \
 plotly \
 DT \
 && rm -rf /tmp/downloaded_packages
