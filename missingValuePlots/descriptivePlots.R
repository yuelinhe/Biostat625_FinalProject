library(naniar)

library(finalfit) 
adult20 <- read.csv('adult20.csv')

data_new_wNA <- adult20 %>% select(
  ##survey design
  HHX, WTFA_A, URBRRL, REGION, PSTRAT, PPSU,
  ## outcome
  MHRX_A, MHTHRPY_A, # mental health
  DEPEV_A, DEPFREQ_A, DEPMED_A, # depression
  ANXEV_A, ANXFREQ_A, ANXMED_A, # anxiety
  ##predictors
  CVDDIAG_A, COVIDTEST_A, # covid test
  DLYCARE_A, DNGCARE_A, VIRAPP12M_A, # access to care due to covid
  HOMECAREDG_A, FAMCARE12M_A, FAMCAREDNG_A, # family care due to covid
  ##confounders ## no NAs
  AGEP_A, SEX_A, EDUC_A, 
  HISPALLP_A # r/e
) 

dim(data_new_wNA)

explanatory <- c( 'CVDDIAG_A', 'COVIDTEST_A', # covid test
                  'DLYCARE_A', 'DNGCARE_A', 'VIRAPP12M_A', # access to care due to covid
                  'HOMECAREDG_A', 'FAMCARE12M_A', 'FAMCAREDNG_A', # family care due to covid
                  ##confounders ## no NAs
                  'AGEP_A', 'SEX_A', 'EDUC_A', 
                  'HISPALLP_A' )
dependent <- c( 'MHRX_A', 'MHTHRPY_A', # mental health
                'DEPEV_A', 'DEPFREQ_A', 'DEPMED_A', # depression
                'ANXEV_A', 'ANXFREQ_A', 'ANXMED_A')
#################
#recode data_new_wNA




#data_new_wNA %>% ff_glimpse(dependent, explanatory)
#data_new_wNA %>%missing_plot()

no_design_data <- data_new_wNA %>%select(
  ## outcome
  MHRX_A, MHTHRPY_A, # mental health
  DEPEV_A, DEPFREQ_A, DEPMED_A, # depression
  ANXEV_A, ANXFREQ_A, ANXMED_A, # anxiety
  ##predictors
  CVDDIAG_A, COVIDTEST_A, # covid test
  DLYCARE_A, DNGCARE_A, VIRAPP12M_A, # access to care due to covid
  HOMECAREDG_A, FAMCARE12M_A, FAMCAREDNG_A, # family care due to covid
  ##confounders ## no NAs
  AGEP_A, SEX_A, EDUC_A, 
  HISPALLP_A # r/e
  
)
#no_design_data %>%ff_glimpse(dependent, explanatory)
#missing observations plot
#no_design_data %>%missing_plot()


outcomes_missing <- c("MHRX_A", "CVDDIAG_A")
demo <- c('AGEP_A', 'SEX_A', 'EDUC_A', 'HISPALLP_A')

#do recoding for no_design_data
no_design_data$AGEP_A <- case_when(
  no_design_data$AGEP_A<=44 & no_design_data$AGEP_A>=18 ~ "18-44",
  no_design_data$AGEP_A<=64 & no_design_data$AGEP_A>=45 ~ "45-64",
  no_design_data$AGEP_A<=85 & no_design_data$AGEP_A>=65 ~ "65+",
  TRUE ~ "Unknown"
)

no_design_data[,'SEX_A'] <- dplyr::recode(as.character(no_design_data[,'SEX_A']),
                                        '1'='Male','2'='Female','7'='Refused or Unknown',
                                        '8'='Refused or Unknown','9'='Refused or Unknown')

no_design_data$EDUC_A <- ifelse(no_design_data$EDUC_A<=11&no_design_data$EDUC_A>=5,5,no_design_data$EDUC_A)
no_design_data$EDUC_A <- ifelse(no_design_data$EDUC_A<=4,0,no_design_data$EDUC_A)
no_design_data$EDUC_A <- ifelse(no_design_data$EDUC_A%in% c(0,5),no_design_data$EDUC_A,"Unknown")
no_design_data$EDUC_A <- dplyr::recode(as.character(no_design_data$EDUC_A),
                                     '0'='High School or Below','5'='College or Above')
no_design_data$EDUC_A <- relevel(as.factor(no_design_data$EDUC_A),ref='High School or Below')
no_design_data$HISPALLP_A <- dplyr::recode(as.character(no_design_data$HISPALLP_A),
                                         '1'='Hispanic','2'='NH White',
                                         '3'='Black/African American','4'='Asian',
                                         '5'='AIAN and any other group','6'='AIAN and any other group',
                                         '7'='Other single and multiple races',
                                         '97'='Refused','98'='Not ascertained','99'='unknown')
no_design_data$HISPALLP_A <- relevel(as.factor(no_design_data$HISPALLP_A),ref="NH White")



#binary_var <- c("MHRX_A", "MHTHRPY_A", "DEPEV_A", "DEPMED_A", "ANXEV_A", "ANXMED_A", "CVDDIAG_A", "COVIDTEST_A", "DLYCARE_A", "DNGCARE_A", "VIRAPP12M_A", "HOMECAREDG_A", "FAMCARE12M_A", "FAMCAREDNG_A")
for (i in outcomes_missing){
  no_design_data[,i] <- ifelse(no_design_data[,i]>=7,NA,no_design_data[,i])
  #no_design_data[,i] <- ifelse(is.na(no_design_data[,i]),,no_design_data[,i])
  no_design_data[,i] <- dplyr::recode(as.character(no_design_data[,i]),
                                      '1'='Yes','2'='No')
  no_design_data[,i] <- factor(no_design_data[,i])
}


library(naniar)
library(dplyr)
no_design_data$'All' <- no_design_data$CVDDIAG_A
no_design_data$'med' <- no_design_data$MHRX_A
no_design_data$Age <- no_design_data$AGEP_A
no_design_data$Sex <- no_design_data$SEX_A
no_design_data$Education <- no_design_data$EDUC_A
no_design_data$Race <- no_design_data$HISPALLP_A


age_m <- gg_miss_fct(x = no_design_data %>% select('Took medicine for mental health', 'All COVID-related predictors',Age ) , fct = Age)
sex_m <- gg_miss_fct(x = no_design_data %>% select('Took medicine for mental health', 'All COVID-related predictors',Sex ) , fct = Sex)
educ_m <- gg_miss_fct(x = no_design_data %>% select('Took medicine for mental health', 'All COVID-related predictors',Education ) , fct = Education)
hisp_m <- gg_miss_fct(x = no_design_data %>% select('Took medicine for mental health', 'All COVID-related predictors',Race ) , fct = Race)

age_m <- gg_miss_fct(x = no_design_data %>% select('med', 'All',Age ) , fct = Age)
sex_m <- gg_miss_fct(x = no_design_data %>% select('med', 'All',Sex ) , fct = Sex)
educ_m <- gg_miss_fct(x = no_design_data %>% select('med', 'All',Education ) , fct = Education)
hisp_m <- gg_miss_fct(x = no_design_data %>% select('med', 'All',Race ) , fct = Race)


library(gridExtra)
grid.arrange(age_m, sex_m, educ_m, hisp_m, nrow = 1)

library(finalfit)
#######do missing values map
for_missing_map <- no_design_data
for_missing_map$Age <- ifelse(for_missing_map$Age=="Unknown", NA, for_missing_map$Age)
for_missing_map$Sex <- ifelse(for_missing_map$Sex=="Unknown", NA, for_missing_map$Sex)
for_missing_map$Education <- ifelse(for_missing_map$Education=="Unknown", NA, for_missing_map$Education)
for_missing_map$Race <- ifelse(for_missing_map$Race=="Other single and multiple races", NA, for_missing_map$Race)



binary_var <- c( "MHTHRPY_A", "DEPEV_A", "DEPMED_A", "ANXEV_A", "ANXMED_A", "COVIDTEST_A", "DLYCARE_A", "DNGCARE_A", "VIRAPP12M_A", "HOMECAREDG_A", "FAMCARE12M_A", "FAMCAREDNG_A")
for(i in 1:length(binary_var)){
  for_missing_map[,binary_var[i]] <- ifelse(for_missing_map[,binary_var[i]]>=7, NA, for_missing_map[,binary_var[i]])
}




for_missing_map %>% select(
  MHRX_A, MHTHRPY_A, # mental health
  DEPEV_A, DEPMED_A, # depression
  ANXEV_A,  ANXMED_A, # anxiety
  ##predictors
  CVDDIAG_A, COVIDTEST_A, # covid test
  DLYCARE_A, DNGCARE_A, VIRAPP12M_A, # access to care due to covid
  HOMECAREDG_A, FAMCARE12M_A, FAMCAREDNG_A, # family care due to covid
  ##confounders ## no NAs
  Age, Sex, Education, Race
) %>%missing_plot()

complete <- na.omit(for_missing_map)
complete <- complete[-which(complete$Sex=="Refused or Unknown"),]
complete_demo <- complete %>% select(Age, Sex, HISPALLP_A)

Race_lab <- c("Hispanic", "NH white", "Black/African American", "Asian","AIAN and any other group")
ggplot(complete, aes(x = Race)) +
  geom_histogram(fill="skyblue", colour="black") +
  facet_grid(Age ~ .)+theme_bw()+scale_x_continuous(breaks=0:4,labels= Race_lab)


