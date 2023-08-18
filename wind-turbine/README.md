# Wind Turbine

> This is a (hard) fork taken from commit `6bf0b00` of the wind turbine topology
> available
> [here](https://github.com/sandialabs/sceptre-phenix-topologies/tree/6bf0b000cf8a9062d427c9c15ec58ffdeb7a62c4/renewables/wind/turbine)
> and refactored to work with predictable inject directories like the other
> projects in this repo.

## Background

This wind turbine model was created as part of the Department of Energy (DOE)
Wind Energy Technology Office (WETO) funded "Wind Reference Architecture"
project at DOE's National Renewable Energy Laboratory (NREL). It leverages
[OT-sim](https://github.com/patsec/ot-sim), and included the development of two
new OT-sim modules
([wind_turbine/anemometer](https://github.com/patsec/ot-sim/tree/main/src/python/otsim/wind_turbine/anemometer)
and
[wind_turbine/power_output](https://github.com/patsec/ot-sim/tree/main/src/python/otsim/wind_turbine/power_output))
and a new phēnix user app
([wind-turbine](https://github.com/sandialabs/sceptre-phenix-apps/tree/main/src/python/phenix_apps/apps/wind_turbine)).

## Deploying in phēnix

A wind turbine experiment has been designed to be deployed using
[phēnix](https://github.com/sandialabs/sceptre-phenix). The easiest way to
deploy phēnix is to use the Docker Compose configuration present in the `docker`
directory of the phēnix repository.

The phēnix experiment configuration for this project includes VM disk references
to `ot-sim.qc2` and `grafana.qc2`. phēnix image configurations for `ot-sim` and
`grafana` are included for this project and can be built with the `phenix image
build` command. First, add the image configurations to phēnix either via the
command line or the UI. Then, run the following commands to build the images.

The following commands assume that you have configured the following bash (or
zsh, or...) aliases.

```
alias ph="docker exec -it phenix phenix"
alias mm="docker exec -it minimega mm"
```

### Import Image Configurations

```
ph config create /phenix/projects/wind-turbine/grafana.yml
ph config create /phenix/projects/wind-turbine/ot-sim.yml
```

### Build VM Images

```
ph image build -x -c -o /phenix/vmdb grafana
ph image build -x -c -o /phenix/vmdb ot-sim
```

Once built, be sure to also configure the images to boot with minimega's
`miniccc` agent using the `phenix image inject-miniexe` command.

```
ph image inject-miniexe /opt/minimega/bin/miniccc /phenix/vmdb/grafana.qc2
ph image inject-miniexe /opt/minimega/bin/miniccc /phenix/vmdb/ot-sim.qc2
```

Then, move the image files to the `/phenix/images` directory so phēnix and
minimega know where to grab them from.

```
mv /phenix/vmdb/grafana.qc2 /phenix/images
mv /phenix/vmdb/ot-sim.qc2 /phenix/images
```

To create the experiment, add the experiment configuration file for this project
to the phēnix store either via the command line or the UI. This will create an
experiment named `wind-turbine` in the phēnix UI.

### Import Experiment Configuration

```
ph config create /phenix/projects/wind-turbine/experiment.yml
```

Once you start the experiment, you can verify it is operating as expected by
checking the Grafana dashboard. To access the Grafana dashboard, you will need
to use minimega's port forwarding capability since there are no VMs in this
experiment with operating systems that include a browser.

```
mm cc tunnel grafana 30000 localhost 3000
```

Then, from your local computer, browse to http://localhost:30000 to access the
Grafana UI. From there, browse to the `turbine` dashboard.
