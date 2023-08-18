# Collection of phēnix Project Experiments

This is a curated collection of experiments I have developed for varying
different projects. I will continue to update it as time and testing permits.

## Current Projects

* [mad-emu-lab](mad-emu-lab) - lab component for Module 1 of the free Cybrary
  [MITRE ATT&CK Defender ATT&CK Adversary Emulation training
  course](https://app.cybrary.it/browse/course/mitre-attack-adversary-emulation-fundamentals).
* [sliver-training](sliver-training) - simple experiment to quickly spin up an
  environment for testing and learning the [Sliver Adversary Emulation
  Framework](https://github.com/BishopFox/sliver).
* [wind-turbine](wind-turbine) - experiment to deploy a model of a single wind
  turbine using [OT-sim](https://github.com/patsec/ot-sim).

## Getting Started

The following steps are required to use this repo:

1. Install and deploy phēnix and minimega
1. Clone this repo to `/phenix/projects`

### Install and Deploy phēnix and minimega

The easiest way to run phēnix and minimega is on a Linux host using Docker
Compose. The following commands can be issued to get it up and running.

```
git clone https://github.com/sandialabs/sceptre-phenix.git
cd phenix/docker
docker-compose up --build -d phenix
```

> Note that when Docker Compose is used to run phēnix and minimega, both
> containers have access to `/phenix` on the host.

Most of the Packer configurations present in this repo will require a recent
copy of `miniccc.exe` to be copied into their `apps` directory. The easiest way
to get the latest copy of `miniccc.exe` is to copy it directly from the minimega
Docker container deployed above.

```
docker cp minimega:/opt/minimega/bin/miniccc.exe path/to/apps/dir
```

The phēnix UI can now be accessed at http://localhost:3000.

### Clone this Repo to `/phenix/projects`

Some experiment configurations in this repo expect files to be located at
`/phenix/projects/<project name>/...`. For example, some experiment topology
configurations will include file injections with source files in this directory.

To make this work without modifications to configurations, this repo should be
cloned to `/phenix/projects` via the commands below.

```
mkdir -p /phenix
git clone https://github.com/activeshadow/phenix-projects.git /phenix/projects
```

This project uses git LFS to store some large configuration files. If you don't
have git LFS configured to automatically pull down files stored in git LFS,
you'll also need to run the following commands.

```
cd /phenix/projects
git lfs pull
```
