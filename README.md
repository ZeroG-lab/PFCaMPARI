# PFCaMPARI

Analysis of CaMPARI measurements taken during the 75th ESA Parabolic Flight Campaign 2021

# Overview

For this project, C28/I2 human chondrocytes were transfected with the calcium reporter CaMPARI2, which shows a shift in green to red fluorescence depending on cytosolic calcium concentration. The cells were exposed repeatedly to changing gravity conditions (0 g- 2 g) during parabolic flights on the 75th ESA parabolic flight campaign. Previous studies measured a small increase or decrease of cytosolic calcium concentrations during parabolic flight experiments, this study aimed to verify these results.
Therefore, a new hardware was designed to carry 96 well plates containing the transfected cells. Each individual well was able to be illuminated by 405 nm light which catalyses the conversion of green fluorescent CaMPARI2 into red fluorescent CaMPARI2 in a calcium concentration dependent manner.

# Contents

This repository contains the data and scripts that were used to analyse microscopic data gathered from imaging the C28/I2 human chondrocytes after the parabolic flights with an Sartorius IncuCyte high througput microscope.

## Extracted data

### Hardware data
Each hardware unit contained 2 96-well plates, 4 units were used in total. Each unit measured time, voltage, current, temperature, pressure, acceleration and illumination events.  These parameters were exported into Excel files, which then were parsed into a data frame using R-Studio.

### IncuCyte image fluorescent data
The 96-well plates used during the parabolic flight were imaged using an IncuCyte high-throughput microscope provided by Sartorius. In each well, a cross-pattern of 5 images was measured. These images were then analysed by the IncuCyte 2021A software. The fluorescence intensity and total number of green and red cells were analysed and exported into Excel to be parsed using R scripts.

## Scripts

The following scripts are available in this reposit.

### parserPFCaMPARI.R
This script reads raw data from the incucyte microscope and the hardware sensors and combines it into one unified data frame for use in subsequent analyses.

### KD-dependent_ConversionRate_parser.R
This script shows the conversion rate of five different CaMPARI2 constructs in relation to their respective Kd values towards Ca2+.

### TimeCourseConversion.R
This script plots the time-dependent conversion of the CaMPARI2F391W-G395D construct after treatment with histamine against increasing durations of illumination with 405 nm conversion light.

### Boxplot_all_Constructs.R
This script reads the accumulated PFC_Merged data frame and plots the conversion rate of all constructs over all flight phases during the four parabolas.

### Boxplot_All_Metrics_all_parabolas.R
This script reads the accumulated PFC_Merged data frame and plots different analysis metrics including statistics

### Boxplot_Conversion_rate_single_Parabolas.R
This script plots the average conversion rates in all treatments and phases over all four individual parabolas.

### Boxplot_Inhibitors_Conversion_rate_normalized_to_Pre-Parabola.R
This script plots the conversion rates of each inhibitor after post-flight histamine treatment. Conversion rates are normalized to the pre-parabola 1 flight phase.

### z-factor_Flight_specific.R
This script calculates and plots the Z'-factor for the conversion rate of cells with a histamine-induced calcium increase after either no treatment (positive control) or BAPTA treatment (negative control).
