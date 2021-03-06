This repository cosists of the following files:
* README.md

* licence.txt

* actionable.md (list of __immediate__ to dos)

* .r_scripts: a folder of scripts for easy function load/reproduction from r.
  - 001_simulation_tools.r: this file contains tools to simulate 14C wmd and uniform bound sequence models and print them in a format readable by OxCal.
  - 002_project_simulations.r: contains the execution of all simulations carried out by the authors. Requires 001_simulation_tools.r to run, as well as the relevant input parameter files.
  - 003_parsing_tools.r: contains the tools used to parse the output of OxCal models from OxCal's .js files.
 
* .rmd_notebooks: a folder with more detailed function descriptions for inspection and review in .rmd format.
  - 001_singles_simulate_compare.rmd: contains scripts to reproduce the simulation of single calibrations and summarizes comparison to OxCal's native R_Simulate() function.
  - 002_describe_sim_tools.rmd: a more detailed look at the functions from 001_simulation_tools.r
  - 004_describe_parsing_tools.rmd: a more detailed look at the parsing functions from 003_parsing_tools.r

Results files, input files and raw OxCal output will be located in an accessible dropbox.

Future folders:
* shiny_app: building the 14C power and sensitivity Shiny app
