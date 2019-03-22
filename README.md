# PSGrafana

The PSGrafana module is a Powershell wrapper around the Grafana API. Grafana uses this API internally for everything you do in the web interface. It made sense to create a wrapper such that you could bolt Grafana tasks to any automation pipelines one might have in their organizations.

## Status

The module is currently in development, and as such expect rapid changes, specifically on the Dev branch. The master branch will only contain code that has been deemed "working"

## Currently available functions include:

- Get-GrafanaConfig
- Set-GrafanaConfig
- Get-GrafanaDashboard
- Get-GrafanaServerHealth
- Get-GrafanaApiKey
- Get-GrafanaDatasource
- Remove-GrafanaDatasource
- Remove-GrafanaApiKey
- New-GrafanaApiKey
- New-GrafanaSnapshot

## Installation

At present, this module is only available by cloning this repository. Upon first run, a configuration file will be generated for you by asking a series of questions. Namely:

- What is your Grafana instance URL?
- What is your Grafana instance API key?

Once provided a Grafana.json file will be generated and placed in the Config directory of the module. All functions pull in this configuration in their `begin {}` blocks to reference the global $configuration variable.

## Issues?

Did you find a bug? Awesome! I wanna know about it. Please file an issue providing as much information as possible.
Did you find a bug, _and_ fix the bug? Awesome! Thanks so much! Please file the detailed issue, and submit a PR for review. Be sure to add 'Fixes _issue\_number_' at the bottom of the PR notes so the Issue can be closed automatically upon merge, and the history shows in both.