# Building a Complete Docker Image for FreeSurfer R Package Testing

This guide provides step-by-step instructions to build a complete Docker image for testing the FreeSurfer R package. 
The image comprises two Docker files that are built in stages, starting from a FreeSurfer base image and extending it to include R and supporting tools.

---

## Docker Files Structure
1. **Stage 1: FreeSurfer Base**
   - Defined in `Dockerfile-fs`.
   - Sets up FreeSurfer in an Ubuntu 22.04 (jammy) environment.
2. **Stage 2: FreeSurfer + R**
   - Defined in `Dockerfile-r`.
   - Builds on top of the FreeSurfer base image, adding R and tools for R package testing.

---

## Building the Docker Image

### Step 1: Build FreeSurfer Base Image
The first stage involves building the FreeSurfer base image using `Dockerfile-fs`.

```bash
docker build -f Dockerfile-fs -t freesurfer-base:8.0.0 .
```

### Step 2: Build FreeSurfer + R Image
The second stage extends the FreeSurfer base with R tools and libraries using `Dockerfile-r`.

```bash
docker build -f Dockerfile-r -t freesurfer-r:fs_8.0.0-r_4.5.1 .
```

---

## Image Tagging Convention

- Format: `<language>-<framework>:<version>`
  - Example: `freesurfer-r:fs_8.0.0-r_4.5.1` where:
    - `r_4.5.1` is the R version.
    - `fs_8.0.0` indicates FreeSurfer version 8.0.0.

### Pushing to GitHub Container Registry
After building the Docker image, it is recommended to tag and push it to the GitHub Container Registry for easy access in CI/CD pipelines.
To push the built image to the GitHub Container Registry, use the following commands:

```bash
docker tag freesurfer-r:fs_7.4.1-r_4.5.1 ghcr.io/drmowinckels/freesurfer-r:fs_7.4.1-r_4.5.1

docker push ghcr.io/drmowinckels/freesurfer-r:fs_7.4.1-r_4.5.1
```
---

## Running the Image and Testing

Start the Docker container and run tests for the FreeSurfer R package.

```bash
docker run --rm \
    -v $(pwd):/workspace \
    freesurfer-r:fs_8.0.0-r_4.5.1 \
    bash -c "cd /workspace \
      && Rscript -e 'pak::local_install_deps(dependencies = TRUE)' \
      && Rscript -e 'devtools::check()'"
```

- `$(pwd)`: Mounts the current working directory to `/workspace` inside the container.
- Run two commands in the container:
  - Install dependencies with `pak`.
  - Perform an R CMD check with `devtools`.

---

## GitHub Actions CI Integration

This setup integrates with GitHub Actions to automate testing of the FreeSurfer R package across different operating systems and configurations.
Note that all the images with Freesurfer are too large to be run on the standard GitHub Actions runners, and would need to be run on runners with[ larger disk space](https://docs.github.com/en/actions/how-tos/manage-runners/larger-runners/manage-larger-runners#changing-the-image-of-a-larger-runner) or on self-hosted runners.

### Workflow File
The GitHub Actions workflow (`.github/workflows/R-CMD-check.yml`) is designed to:
1. Test R packages across multiple OS configurations.
2. Use Docker to run FreeSurfer-specific tests.

### Key CI Steps
#### Non-Docker Builds
- Runs jobs on MacOS, Windows, and Ubuntu using specific R versions.

#### Docker-Based Checks
- Leverages FreeSurfer-specific Docker images:
  1. Pulls the appropriate `freesurfer-r` image.
  2. Executes R CMD check inside the container.

---

## Troubleshooting

- **Docker Image Not Found**: Ensure the `freesurfer-base:8.0.0` and `freesurfer-r` images are built locally or available in the container registry.
  - Freesurfer is too large to be built in CI, so it must be built locally.
- **Package Not Found Errors**: Check the `Rscript` commands to ensure packages are being installed correctly.

---

This setup ensures a consistent and reproducible environment for developing and testing the FreeSurfer R package, supporting both local development and CI pipelines.
