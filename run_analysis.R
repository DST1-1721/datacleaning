# Code for course project: Getting and Cleaning Data
# This code requires the data.table library
#
run_analysis <- function(data_dir=".") {

  if (endsWith(data_dir, '/')) {
    dir <- substr(data_dir,1,nchar(data_dir)-1)
  } else {
    dir <- data_dir
  }
  
  # Format target column heads more readably
  col_heads <- read.table(paste0(dir,'/features.txt'), sep=' ',header=FALSE)[,2]
  mod_col_heads <- tolower(
        sub('_$','',
            sub("^([a-zA-Z]*)-(std|mean)\\(\\)(|.*[^XYZ]([XYZ]{0,1}))$",
                "\\2_\\1_\\4",
                col_heads)))  
  
  # read averaged sensor data
  training_set_dt <- fread(paste0(dir,"/X_train.txt"), col.names=mod_col_heads)
  test_set_dt <- fread(paste0(dir,"/X_test.txt"), col.names=mod_col_heads)

  # Merge training and test sets to create unified dataset:
  full_set_dt <- rbind(training_set_dt, test_set_dt)

  # Extract only mean and std for each measure in the data set
  mean_and_std_col_names <- grep("^(mean|std)", colnames(full_set_dt), value=TRUE)
  mean_and_std_measures_dt <- full_set_dt[, ..mean_and_std_col_names]

  # Associate activity name with each data point
  labels <- read.table(paste0(dir, "/activity_labels.txt"))
  training_activities_dt <- fread(paste0(dir,"/y_train.txt"))
  test_activities_dt <- fread(paste0(dir,"/y_test.txt"))
  activity_labels <- labels[,2][rbind(training_activities_dt,test_activities_dt)[,V1]]
  
  training_subjects_dt <- fread(paste0(dir,"/subject_train.txt"))
  test_subjects_dt <- fread(paste0(dir,"/subject_test.txt"))
  subjects <- rbind(training_subjects_dt, test_subjects_dt)
  colnames(subjects) <- 'subjects'
  
  activity_and_measure_stats_dt <- cbind(activity_labels, subjects, mean_and_std_measures_dt)

  averages <- activity_and_measure_stats_dt[,lapply(.SD,mean), by=.(activity_labels, subjects)]

  tidy_set <- melt(averages,
                   id.vars=colnames(averages)[1:2],
                   measure.vars=colnames(averages)[c(-1,-2)])
  colnames(tidy_set) <- c("activity","subject","measure","averagevalue")
  tidy_set
}