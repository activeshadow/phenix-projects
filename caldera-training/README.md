# Caldera Training Lab Environment

This project can be used to test and learn the [MITRE Caldera Adversary
Emulation Platform](https://caldera.mitre.org). It spins up the following VMs:

1. Ubuntu VM with Caldera installed
1. Windows 10 VM (built with Packer configs in
   [sliver-training](../sliver-training) project.
1. OT-sim VM with Modbus and DNP3 outstations configured

## Getting Started

The following steps are required to use this project:

1. Build the Caldera VM using phenix
1. Build the [sliver-training](../sliver-training) Windows 10 VM using Packer
1. Build the [wind-turbine](../wind-turbine) OT-sim VM using phenix
1. Deploy the project experiment using phenix

### Build the Caldera VM Using phenix

phenix includes a default image config that can be used for building the Caldera
VM image. To build the image using the config, run the following commands.

```
docker exec -it phenix phenix image build -x -c -o /phenix/vmdb caldera
docker exec -it phenix phenix image inject-miniexe /opt/minimega/bin/miniccc /phenix/vmdb/caldera.qc2
```

> This step will take quite a while to complete.

Once built, run the following command to make sure the image is located where
phenix and minimega can access it.

```
sudo mv /phenix/vmdb/caldera.qc2 /phenix/images/caldera.qc2
```

### Build the sliver-training Windows 10 VM Using Packer

See the [sliver-training README](../sliver-training/README.md) for instructions
on how to build the Windows 10 VM.

### Build the wind-turbine OT-sim VM Using phenix

The [wind-turbine](../wind-turbine) project includes a phenix image config for
building the OT-sim VM image using phenix. To build the image using the config,
run the following commands.

```
docker exec -it phenix phenix config create /phenix/projects/wind-turbine/ot-sim.yml
docker exec -it phenix phenix image build -x -c -o /phenix/vmdb ot-sim
docker exec -it phenix phenix image inject-miniexe /opt/minimega/bin/miniccc /phenix/vmdb/ot-sim.qc2
```

> This step will take quite a while to complete.

Once built, run the following command to make sure the image is located where
phenix and minimega can access it.

```
sudo mv /phenix/vmdb/ot-sim.qc2 /phenix/images/ot-sim.qc2
```

### Deploy the Lab Environment Using phenix

The root directory of this repo contains a phenix experiment config for
deploying the lab environment. To deploy, run the following commands.

```
docker exec -it phenix phenix config create /phenix/projects/caldera-training/experiment.yml
docker exec -it phenix phenix experiment start caldera-training
```

Once deployed, you can access the experiment and VMs by browsing to
http://localhost:3000.
