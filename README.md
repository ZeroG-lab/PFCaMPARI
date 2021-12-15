# PFCaMPARI

Analysis of CaMPARI measurements taken during the Parabolic Flight Campaign 2021

# Overview

For this project, C28/I2 human chondrocytes were transfected with the calcium reporter CaMPARI2, which shows a shift in green to red fluorescence depending on cytosolic calcium concentration. The cells were exposed repeatedly to changing gravity conditions (0 g- 2 g) during parabolic flights on the 75th ESA parabolic flight campaign. Previous studies measured a small increase or decrease of cytosolic calcium concentrations during parabolic flight experiments, this study aimed to verify these results.
Therefore, a new hardware was designed to carry 96 well plates containing the transfected cells. Each individual well was able to be illuminated by 405 nm light which catalyses the conversion of green fluorescent CaMPARI2 into red fluorescent CaMPARI2 in a calcium concentration dependent manner.

# Contents

This repository contains the data and scripts that were used to analyse microscopic data gathered from imaging the C28/I2 human chondrocytes after the parabolic flights with an Sartorius IncuCyte high througput microscope.

## Extracted data

Hardware data: Each hardware unit contained 2 96-well plates, 4 units were used in total. Each unit measured time, voltage, current, temperature, pressure, acceleration and illumination events.  These parameters were exported into excel files, which then were parsed into a data frame using R-Studio.

Exported IncuCyte image fluorescent data:
