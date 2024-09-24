# archgab

[![build-archgab](https://github.com/elgabo86/archgab/actions/workflows/build.yml/badge.svg)](https://github.com/elgabo86/archgab/actions/workflows/build.yml) 

These images are not meant to be used as a host operating system. Please see [gablue](https://github.com/elgabo86/gablue/) for more information.

## Usage

If you use distrobox:

    distrobox create -i ghcr.io/elgabo86/archgab -n archgab
    distrobox enter archgab

If you use toolbx:

    toolbox create -i ghcr.io/elgabo86/archgab -c archgab
    toolbox enter archgab

## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/elgabo86/gablue
