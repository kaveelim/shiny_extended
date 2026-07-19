# shiny_extended

A Docker image based on `rocker/shiny-verse` with additional geospatial,
single-cell, genomics, visualization, and Shiny packages installed.

The current image uses R 4.2.1 and Bioconductor 3.16. GitHub-only dependencies
are pinned to immutable revisions so rebuilding the same commit is predictable.

## Build

```sh
docker build --tag shiny-extended:4.2.1 .
```

The build is large and compiles several R packages from source. To select a
different Bioconductor release, pass `BIOCONDUCTOR_VERSION`; make sure it is
compatible with the R version in the base image.

```sh
docker build \
  --build-arg BIOCONDUCTOR_VERSION=3.16 \
  --tag shiny-extended:4.2.1 .
```

## Run

```sh
docker run --rm --publish 3838:3838 shiny-extended:4.2.1
```

Open <http://localhost:3838> after the container becomes healthy.

To serve local Shiny applications, mount their directory read-only:

```sh
docker run --rm \
  --publish 3838:3838 \
  --volume "$PWD/apps:/srv/shiny-server:ro" \
  shiny-extended:4.2.1
```

## Maintenance

The R version, Bioconductor version, and pinned GitHub revisions should be
updated together. Pull requests are checked by building the image, loading the
installed R packages, and contacting Shiny Server in GitHub Actions.

After those checks pass, pushes to `master` publish the image to Docker Hub as:

- `kaveemd/shiny_extended:latest`
- `kaveemd/shiny_extended:4.2.1`

Publishing requires the `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` repository
secrets. Running the workflow manually from `master` also publishes both tags.
