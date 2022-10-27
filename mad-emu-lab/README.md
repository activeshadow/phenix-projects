# MAD ATT&CK Adversary Emulation Lab Environment

Module 1 of the free Cybrary [MITRE ATT&CK Defender ATT&CK Adversary Emulation
training course](https://app.cybrary.it/browse/course/mitre-attack-adversary-emulation-fundamentals)
includes a lab component that either requires students to setup their own lab
environment or have a Cybrary Insider Pro membership to use their hosted virtual
lab. This repo helps students setup their own lab using the
[phenix](https://github.com/sandia-minimega/phenix) orchestration tool.

## Getting Started

The following steps are required to use this project:

1. Build the lab Active Directory Controller VM using Packer
1. Build the lab Kali VM using phenix
1. Deploy the lab environment using phenix

### Build the Lab Active Directory Controller VM Using Packer

The `windows-server-2019` directory contains a [Packer](https://www.packer.io)
config to build the Windows Active Directory Controller VM image using QEMU.

Prior to running Packer to build the VM image, the Virtual I/O drivers for QEMU
need to be
[downloaded](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/)
and unarchived into the `drivers` directory. Depending on which version of the
drivers were downloaded, the `cd_files_list` variable may need to be updated to
reference the correct version.

As mentioned in the main [README](../README.md), a recent copy of `miniccc.exe`
needs to be placed in the `windows-10/apps` directory prior to running Packer.
The easiest way to do this is to run the following command from the current
directory:

```
docker cp minimega:/opt/minimega/bin/miniccc.exe windows-server-2019/apps/miniccc.exe
```

Once the drivers and `miniccc.exe` are in place, the VM image can be built using
the following command from the `windows-server-2019` directory:

```
packer build packer.json
```

> This step will take quite a while to complete.

Once built, run the following command to make sure the image is located where
phenix and minimega can access it.

```
sudo mv output-mad-emu-dc/mad-emu-dc /phenix/images/mad-emu-dc.qc2
```

### Build the Lab Kali VM Using phenix

The `kali` directory contains a phenix image config for building the Kali VM
image using phenix. To build the Kali VM image using the config, run the
following commands.

```
docker exec -it phenix phenix config create /phenix/projects/mad-emu-lab/kali/mad-emu-kali.yml
docker exec -it phenix phenix image build -x -c -o /phenix/vmdb mad-emu-kali
docker exec -it phenix phenix image inject-miniexe /opt/minimega/bin/miniccc /phenix/vmdb/mad-emu-kali.qc2
```

> This step will take quite a while to complete.

Once built, run the following command to make sure the image is located where
phenix and minimega can access it.

```
sudo mv /phenix/vmdb/mad-emu-kali.qc2 /phenix/images/mad-emu-kali.qc2
```

### Deploy the Lab Environment Using phenix

The root directory of this repo contains a phenix experiment config for
deploying the lab environment. To deploy, run the following commands.

```
docker exec -it phenix phenix config create /phenix/projects/mad-emu-lab/experiment.yml
docker exec -it phenix phenix experiment start mad-emu
```

Once deployed, you can access the experiment and VMs by browsing to
http://localhost:3000.
