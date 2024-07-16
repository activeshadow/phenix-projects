# Packer Docker Image

Docker can be used to run Packer for this Windows 10 build in order to avoid
having to install Packer, the Packer QEMU plugin, and all of the QEMU/KVM
dependencies on your host machine.

Run the following command from this directory to build a minimal Docker image
for Packer.

```
docker build -t packer .
```

Run the following command to add an alias to simplify running Packer using a
Docker container.

```
alias packer='docker run -it --rm -v `pwd`:/workspace -w /workspace --network host --name packer --privileged --cap-add ALL -e PACKER_CACHE_DIR=packer_cache -e PACKER_PLUGIN_PATH=.plugins packer'
```

Run the following command from this directory to build the Windows 10 VM image.

```
packer build packer.json
```
```
```
