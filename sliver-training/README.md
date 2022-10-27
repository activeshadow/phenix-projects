# Sliver Training Lab Environment

This project can be used to test and learn the [Sliver Adversary Emulation
Framework](https://github.com/BishopFox/sliver). It spins up the following VMs:

1. Kali VM with Sliver installed
1. Windows ADC VM using MAD.local domain
1. Windows 10 VM joined to the MAD.local domain and logged in as regular user

> Note that the Kali VM will not start the Sliver server at boot. To start it,
> simply run `systemctl start sliver` and then connect to the server by running
> the `sliver` command.

## Getting Started

The following steps are required to use this project:

1. Build the [mad-emu-lab](../mad-emu-lab) Active Directory Controller VM using
   Packer
1. Build the Windows 10 VM using Packer
1. Build the Sliver Kali VM using phenix
1. Deploy the project experiment using phenix

### Build the mad-emu-lab Active Directory Controller VM Using Packer

See the [mad-emu-lab README](../mad-emu-lab/README.md) for instructions on how
to build the ADC.

### Build the Windows 10 VM Using Packer

The `windows-10` directory contains a [Packer](https://www.packer.io) config to
build the Windows 10 VM image using QEMU.

Prior to running Packer to build the VM image, the Virtual I/O drivers for QEMU
need to be
[downloaded](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/)
and unarchived into the `drivers` directory. Depending on which version of the
drivers were downloaded, the `cd_files` variable may need to be updated to
reference the correct version.

As mentioned in the main [README](../README.md), a recent copy of `miniccc.exe`
needs to be placed in the `windows-10/apps` directory prior to running Packer.
The easiest way to do this is to run the following command from the current
directory:

```
docker cp minimega:/opt/minimega/bin/miniccc.exe windows-10/apps/miniccc.exe
```

Once the drivers and `miniccc.exe` are in place, the VM image can be built using
the following command from the `windows-10` directory:

```
packer build packer.json
```

> This step will take quite a while to complete.

Once built, run the following command to make sure the image is located where
phenix and minimega can access it.

```
sudo mv output-windows-10/windows-10 /phenix/images/win-10.qc2
```

### Build the Sliver Kali VM Using phenix

The `sliver` directory contains a phenix image config for building the Sliver
Kali VM image using phenix. To build the image using the config, run the
following commands.

```
docker exec -it phenix phenix config create /phenix/projects/sliver-training/sliver/sliver.yml
docker exec -it phenix phenix image build -x -c -o /phenix/vmdb sliver
docker exec -it phenix phenix image inject-miniexe /opt/minimega/bin/miniccc /phenix/vmdb/sliver.qc2
```

> This step will take quite a while to complete.

Once built, run the following command to make sure the image is located where
phenix and minimega can access it.

```
sudo mv /phenix/vmdb/sliver.qc2 /phenix/images/sliver.qc2
```

### Deploy the Lab Environment Using phenix

The root directory of this repo contains a phenix experiment config for
deploying the lab environment. To deploy, run the following commands.

```
docker exec -it phenix phenix config create /phenix/projects/sliver-training/experiment.yml
docker exec -it phenix phenix experiment start sliver-training
```

Once deployed, you can access the experiment and VMs by browsing to
http://localhost:3000.
