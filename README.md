# 14C-power-sensitivity
How wrong is wrong and how good can it get? 14C chronological model power and sensitivity analyses with OxCal and R.

## Description
This project is concerned with two questions:
1.	How much systematic offsets and error underestimation can happen to 14C samples before chronological model results become unsatisfactory
2.	Providing quick ballpark estimates for precision of wiggle-match data and uniform bound sequence models.
The project consists of a set of functions for 1) setting up and running mass simulations in OxCal; 2) parsing OxCal .js output files; 3) pipeline for EDA and maximum permissible offset (MPE) evaluation; 4) pipeline for modelling sensitivity to offsets; 5) pipeline for modelling power analysis; 6) the result tables and input parameters for the original project simulations; 7) code for building the project Shiny app.
This project is in collaboration with Richard Staff


## Table of contents
* Table of contents
* Motivation
* Objectives
* Outcomes
* Method
* Technology
* Install
* Use
* Contribute
* LICENCE
* References

## Motivation
The number of academic papers beginning with the phrase “Radiocarbon is one the most important methods in geochronology” is legion. For a good reason too; radiocarbon is one of the few methods in geochronology, archaeology, forensic science and a number of other medical and Earth Science disciplines that can provide (relatively) high precision results at a (relatively) affordable cost on samples that are (relatively) abundant. Other methods might be better for any one of these factors, but, to date, radiocarbon alone delivers the balance of precision, affordability and sample availability on a global scale. 
While the technique has substantial use in applications such as tracing the global carbon cycle, its best known application is in chronology. The details of how this works are discussed e.g. <https://c14.arch.ox.ac.uk/dating.html>, but for our purposes the two key points are:
1. Radiocarbon measurements alone are not chronological data. To become chronological data they need calibrating against a calibration curve built of measurements of samples whose age has been determined through other means (for example dendrochronology).
2. The resulting calibration curve is non-monotonous (indeed it is notorious for its wiggliness), while radiocarbon measurements are normal distributions rather than point data. To overcome this, radiocarbon calibration uses a Bayesian approach (Stuiver and Reimer 1986; see Buck et al. 1996 for the mathematical detail) the calibrated dates themselves are non-standard distributions.
These two points lead to a number of consequences for how deal with groups of calibrated radiocarbon dates. While in a few instances where an individual item is being dated (such as the famous case of the Tourin shroud, see Damon et al. 1989) the date of the item itself is of interest, in most applications we are interested in making inferences about the dates of onset and termination of some past process, alongside inferring its duration and pace.
These questions require further modelling of radiocarbon dates, again conducted most often within a Bayesian framework (Bayliss 2009), though alternatives exist (e.g. Weninger and Edinborough 2020). The dominance of the Bayesian framework, combined with relative complexity of the chronological models deployed means that much of the model construction is black boxed within purpose built programs, the most popular of which, at least in the English-speaking world, is OxCal (Bronk Ramsey 2009).
What is less well-established is:
a) methods of power analysis for building chronological models (but see e.g. Buck and Christen 1998)
b) robustness of the different chronological models to offsets in the underpinning radiocarbon measurements, be it due to systematic offsets in the measurements, underreporting measurement uncertainties, or limitations of the radiocarbon calibration curve. 

This project provides the tools to address these questions within a simulation-based framework.

## Objectives
This project aims to provide the radiocarbon community with tools for power and sensitivity analysis of Bayesian chronological models built on radiocarbon data using a simulation framework. As such it aims to:
1. Provide a set of tools for model construction and model result parsing that can be applied across a range of contexts. [core coding complete; script optimization and bug fixes ongoing]
2. It carries out its own general evaluations of chronological model robustness in general and how it varies depending on the shape of the (wiggly) calibration curve. [in progress]
3. Provide a visualization of these results through a Shiny app [in progress]
4. Provide detailed power analysis case studies for the mid-first millennium cal BC and the Final millennia of the Pleistocene. [in progress]
5. The long-term objective is to package the relevant functions to provide a straightforward means of power and sensitivity analysis for the 14C community.

## Outcomes
Project simulations: 467,500/473,500+ completed <To be provided via a read-only dropbox link>.
Project simulation results: <Add to the folder here> (FIGURE)
EDA: ongoing
MPE analysis: ongoing
Modelling: ongoing
Shiny Package: ongoing
Packaging: ongoing.


## Method
This project relies on simulating radiocarbon-based chronological models with:
- known target dates;
- known model structure (number of dates and their order);
- known measurement uncertainty of the underpinning simulated measurements;
- known magnitude and variability of simulated systematic offset.

Simulation scripts provided generate input files that can be passed onto OxCal (thank you Richard Telford: https://quantpalaeo.wordpress.com/2016/11/19/oxcal-and-r/). We choose to use OxCal for simulation due to its high dergee of optimization (allowing efficient model running, including MCMC) as well an easy to automate input syntax. Another reason is the ubiquity of OxCal in the field of radiocarbon analysis, making our results consistent with the work of other researchers. For more complex model structures a more individualized approach might be required.
OxCal stores its outputs in .js files. These are parsed for the particular information of interest and re-assembled using the collection of parsing scripts <NAMES>.
The project also contains our sensitivity and power analyses pipeline, consistent with the results tables generated by the parsing scripts. These cover:
- EDA scripts
- Maximum Permissable Error (MPE) estimation: this is an approach that evaluates how often a given group of radiocarbon models is off-target by more than an arbitraty value (the maximum permissable error).
- Modelling scripts exploring the general relationships between the different input parameters and model accuracy.
- Regression-based power analysis.
All the simulations are generated using the IntCal20 calibration curve (Reimer et al. 2020), with the semi-decadal data interpolated using the algorithm of OxCal 4.3 Almost all the simulations are calibrated against IntCal20 using OxCal 4.4 except wmds_022 and seqs_032, which were calibrated against IntCal13 (Reiemr et al. 2013) using OxCal 4.3.


## Technology
The project uses R (with the core Tidyverse packages, as well as Broom and Purr for time-depednant modelling).
Bayesian estimation of chronological models is performed in OxCal (a free closed-source program developed by Chris Bronk Ramsey of the Oxford Radiocarbon Accelerator Unit: https://c14.arch.ox.ac.uk/oxcal.html).


## Install
The relevant scripts can be downloaded and sourced from R.

## Use
For ease of use the simulation and parsing scripts are provided in two formats. 
For detailed description consult the .html files produced using R notebooks.
For source-ready format use the .R scripts.
Analyses are carried out within R notebooks.
The Shiny app that explores our results will be put online once elements are ready.
Our simulations and results tables can be downloaded from READ ONLY DROP BOX


## Contribute
There are many spaces for improvement that I have spotted throughout (see the comments on the code).
There are infinitely more more spaces for improvement that I have not commented on (extension to a broader range of models, extension to simulations with programs other than OxCal, etc.). 


## LICENCE
This project is made available under the GNU General Public License v3.0 (see license.txt). 


## References
Bayliss, A. 2009. Rolling Out Revolution: Using Radiocarbon Dating in Archaeology. Radiocarbon 51.1: 123-147.
Bronk Ramsey, C. 2009 Bayesian analysis of radiocarbon dates. Radiocarbon 51.1: 337-360.
Buck, C. E., Cavanagh, W. G. and Litton C. E. 1996 Bayesian Approach to interpreting Archaeological Data. Chichester: Wiley.
Buck, C.E. and Christen, J.A. 1998. A Novel Approach to Selecting Samples for Radiocarbon Dating. 
Damon, P.E., Donhaue, D.J., Gore, B.H., et al. 1989 Radiocarbon dating of the Shroud of Turin. Nature 337: 611-615.
Reimer, P.L., Bard, E., Bayliss, A., et al. 2013. IntCal13 and Marine13 Radiocarbon Age Calibration Curves 0 – 50,000 Years cal BP. Radiocarbon 55.4: 1869-1887.
Reimer, P.L., Austin, W.E.N, Bard, E., et al. 2020. The IntCal20 Northern Hemisphere Radiocarbon Age Calibration Curve (0-55 cal kBP). Radiocarbon 62.4: 725-757.
Stuiver, M. and Reimer, P. 1986. A computer program for radiocarbon age calibration. Radiocarbon 28.2B: 1022-1030.
Weninger, B. and Edinborough, K. 2020. Bayesian 14C-rationality, Heisenberg uncertainty, and Fourier transform: the beauty of radiocarbon calibration. Documenta Praehistorica 47: 536-559.
