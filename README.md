# Biostat 625 Final Project - Group 1

### Author Contributions:

Yuelin He: cleaned the data; generated missing data analysis table; ran logistic regression and generated forest plots; for the report, wrote part of background section, part of methods section.

Jiaxin Qian: imputed missing values using Hmisc; for the report, wrote part of methods section, and all the results section.

Yijing He: tried missing data imputations using MissForest; for the report, wrote the conclusions section.

Yiwen Chen: tried missing data imputations using mice; generated visualizations for missing data analysis; for the report, wrote part of methods section.

### Project description

This is the repository for the project *Impact of COVID-19 and other factors on self-reported mental health in the United States (2020)*, and it contains the work we have done for the final project of the course Biostatistics 625, including code, output, and the report.

The project used 2020 National Health Interview Survey (NHIS) data to investigate the associated factors of mental health illness during 2020 in the United States and, with a specific focus on COVID-19 related health status. This repository does not contain our source data because of its large sample size. To replicate our work or run our code, please download the data from the CSV data file link under the "Sample Adult Interview" section in [this](https://www.cdc.gov/nchs/nhis/2020nhis.htm) link. Dataset codebook can be found in [this](https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Dataset_Documentation/NHIS/2020/adult-codebook.pdf) link. 

### Repository description

Our work was splitted into several folders in this repo. 

1. The missing data analysis conducted was in the [missingValuePlots](/missingValuePlots) and [MissingDataAnalysesResults](/MissingDataAnalysesResults) folders, including both code and resulted output.
2. The Missing value imputations were then performed. In the [Missing Value Imputations](/Missing Value Imputations) folder, there are several methods that we tried, although we finally settled on using Hmisc. The resulted imputed dataset were saved in a separate folder [imputed dataset](/imputed dataset).
3. The code and output for both unadjusted and adjusted logistic regression (a.k.a. our main analysis) was located in the [LogisticRegressionResults][/LogisticRegressionResults] folder.
4. Finally, the folder called [report](/report) contains our Rmd used to generate our report, along with all the source plots and tables in the reports.


### Credits:

In addition to those we refered to in our reference list of the report, We would like to thank Dr. Hui Jiang for the feedback on our project and for the useful tips in the class, and Jingyi Zhai for the advice along the way.

