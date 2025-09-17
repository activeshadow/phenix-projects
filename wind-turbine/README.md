# Wind Turbine

> [!NOTE]
> This is a (hard) fork taken from commit `6bf0b00` of the wind turbine topology
> available
> [here](https://github.com/sandialabs/sceptre-phenix-topologies/tree/6bf0b000cf8a9062d427c9c15ec58ffdeb7a62c4/renewables/wind/turbine)
> and refactored to work with predictable inject directories like the other
> projects in this repo.

This project can be used to deploy a wind turbine model. It spins up the
following VMs:

1. Six OT-sim VMs representing different wind turbine controllers
1. Grafana VM to collect ground truth data

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

## Getting Started

The following steps are required to use this project:

1. Download the Grafana OT-sim VMs using Oras
1. Deploy the project experiment using phenix

### Download the Grafana and OT-sim VMs Using Oras

The [Oras](https://oras.land) CLI can be used to download pre-built images of
Grafana and OT-sim for use in this experiment.

```
cd /phenix/images
oras pull ghcr.io/activeshadow/phenix-experiments/grafana.qc2:main
oras pull ghcr.io/patsec/ot-sim/ot-sim.qc2:main
```

While not required, it is sometimes useful to have the minimega `miniccc` agent
running in the Grafana and OT-sim VMs. The following commands will ensure the
latest version of `miniccc` is installed in the VM images downloaded above.

```
ph image inject-miniexe /opt/minimega/bin/miniccc /phenix/images/grafana.qc2
ph image inject-miniexe /opt/minimega/bin/miniccc /phenix/images/ot-sim.qc2
```

### Deploy the Lab Environment Using phenix

The root directory of this repo contains a phenix experiment config for
deploying the lab environment. To deploy, run the following commands.

```
docker exec -it phenix phenix config create /phenix/projects/wind-turbine/experiment.yml
docker exec -it phenix phenix experiment start wind-turbine
```

Once deployed, you can access the experiment and VMs by browsing to
http://localhost:3000.

You can verify the wind turbine model is operating as expected by checking the
Grafana dashboard. To access the Grafana dashboard, you will need to use
minimega's port forwarding capability since there are no VMs in this experiment
with operating systems that include a browser.

```
mm cc tunnel grafana 30000 localhost 3000
```

Then, from your local computer, browse to http://localhost:30000 to access the
Grafana UI. From there, browse to the `turbine` dashboard.
