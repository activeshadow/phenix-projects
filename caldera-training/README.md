# Caldera Training Lab Environment

This project can be used to test and learn the [MITRE Caldera Adversary
Emulation Platform](https://caldera.mitre.org). It spins up the following VMs:

1. Ubuntu VM with Caldera installed
1. Windows 10 VM (built with Packer configs in
   [sliver-training](../sliver-training) project.
1. OT-sim VM with Modbus and DNP3 outstations configured

## Getting Started

The following steps are required to use this project:

1. Download the Caldera and OT-sim VMs using Oras
1. Build the [sliver-training](../sliver-training) Windows 10 VM using Packer
1. Deploy the project experiment using phenix

### Download the Caldera and OT-sim VMs Using Oras

The [Oras](https://oras.land) CLI can be used to download pre-built images of
Caldera and OT-sim for use in this experiment.

```
cd /phenix/images
oras pull ghcr.io/activeshadow/phenix-experiments/caldera.qc2:main
oras pull ghcr.io/patsec/ot-sim/ot-sim.qc2:main
```

While not required, it is sometimes useful to have the minimega `miniccc` agent
running in the Caldera and OT-sim VMs. The following commands will ensure the
latest version of `miniccc` is installed in the VM images downloaded above.

```
ph image inject-miniexe /opt/minimega/bin/miniccc /phenix/images/caldera.qc2
ph image inject-miniexe /opt/minimega/bin/miniccc /phenix/images/ot-sim.qc2
```

### Build the sliver-training Windows 10 VM Using Packer

See the [sliver-training README](../sliver-training/README.md) for instructions
on how to build the Windows 10 VM.

### Deploy the Lab Environment Using phenix

This lab includes an Caldera adversary and fact source for the FrostyGoop
malware abilities present in the Caldera OT plugin that is part of the default
Caldera image in phenix. In order to use the FrostyGoop malware abilities, users
must manually download and add the `bustleberm.exe` payload to the `injects`
directory. This is the FrostyGoop malware sample that can be downloaded from
https://bazaar.abuse.ch. Be sure to download the sample with the following
signature.

`5d2e4fd08f81e3b2eb2f3eaae16eb32ae02e760afc36fa17f4649322f6da53fb`

The root directory of this repo contains a phenix experiment config for
deploying the lab environment. To deploy, run the following commands.

```
docker exec -it phenix phenix config create /phenix/projects/caldera-training/experiment.yml
docker exec -it phenix phenix experiment start caldera-training
```

Once deployed, you can access the experiment and VMs by browsing to
http://localhost:3000.
