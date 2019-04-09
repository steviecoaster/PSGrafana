<p align="center"><img src="https://github.com/steviecoaster/PSGrafana/wiki/Assets/PSGrafana.png" width=100></p>
# PSGrafana

The PSGrafana module is a PowerShell wrapper around the Grafana API. Grafana uses this API internally for everything you do in the web interface. It made sense to create a wrapper such that you could bolt Grafana tasks to any automation pipelines one might have in their organizations.

## Status

The module is currently in development, and as such expect rapid changes, specifically on the `develop` branch. The master branch will only contain code that has been deemed "working" and triggers the pipeline to publish new module versions.

---

## Contributing

If you would like to help out, please target the `develop` branch when creating pull requests, otherwise the pipeline will have a bad time and we'll end up with stuff hitting the gallery too early.

---

## Currently available functions include:

- Get-GrafanaConfig
- Set-GrafanaConfig
- Get-GrafanaDashboard
- New-GrafanaDashboard
- Set-GrafanaDashboard
- Remove-GrafanaDashboard
- Get-GrafanaServerHealth
- Get-GrafanaApiKey
- Get-GrafanaDatasource
- Remove-GrafanaDatasource
- Remove-GrafanaApiKey
- New-GrafanaApiKey
- New-GrafanaSnapshot
- Get-GrafanaSnapshot
- Remove-GrafanaSnapshot
- Get-GrafanaAlert
- Suspend-GrafanaAlert
- New-GrafanaFolder
- Get-GrafanaFolder
- Remove-GrafanaFolder

---

## Installation

#### Github:

Option 1:

Clone this repository. Import the psd1 file from the directory with `Import-module ./PSGrafana.psd1` or the full path to the psd1 file if outside the cloned directory.

Option 2:

Clone the repository somewhere in your $PSModulePath, and then run `Import-Module PSGrafana`

Option 3: 

Download the zip archive and extract it on your machine and reference Option 1 or 2 above based on where you extract it too.

#### Powershell Gallery

This module is available via the Powershell Gallery. The latest released version is v0.0.4. 

To install simply run `Install-Module PSGrafana`

_IMPORTANT NOTE REGARDING INSTALLATION:_

Upon first run, a configuration file will be generated for you by asking a series of questions. Namely:

- What is your Grafana instance URL?
- What is your Grafana instance API key?

Once provided a Grafana.json file will be generated and placed in the Config directory of the module. All functions pull in this configuration in their `begin {}` blocks to reference the global $configuration variable.

Currently, this config file does not survive updates from the Powershell Gallery. There is an issue created and I am working hard to resolve this in the most appropriate manner.

---

## Issues?

Did you find a bug? Awesome! I wanna know about it. Please file an issue providing as much information as possible.
Did you find a bug, _and_ fix the bug? Awesome! Thanks so much! Please file the detailed issue, and submit a PR for review. Be sure to add 'Fixes _issue\_number_' at the bottom of the PR notes so the Issue can be closed automatically upon merge, and the history shows in both.
