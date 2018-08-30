## Loading required packages
library(dplyr)
library(plyr)

## Loading data
df_train_data <- read.table('train/X_train.txt')
df_train_labels <- read.table('train/y_train.txt')
df_train_subject <- read.table('train/subject_train.txt')
df_test_data <- read.table('test/X_test.txt')
df_test_labels <- read.table('test/y_test.txt')
df_test_subject <- read.table('test/subject_test.txt')
features <- read.table('features.txt')

## Merging data
df_train <- cbind(df_train_data, df_train_subject)
df_train <- cbind(df_train, df_train_labels)
df_test <- cbind(df_test_data, df_test_subject)
df_test <- cbind(df_test, df_test_labels)
df <- rbind(df_train, df_test)

## Adding column names
# Adding column names for the features
features_vector <- unlist(features['V2'])
colnames(df) <- features_vector
# Adding column names for the subjects and labels
colnames(df)[562] <- 'subject'
colnames(df)[563] <- 'activity_labels'

## Converting labels to activities
df$activity_labels <- as.character(df$activity_labels)
df$activity_labels <- revalue(df$activity_labels,
                             c('1'="WALKING", '2'="WALKING_UPSTAIRS", '3'= "WALKING_DOWNSTAIRS",
                               '4'="SITTING", '5'="STANDING", '6'="LAYING"))

## Extracting only mean and std measurements per measurement but keeping the subject IDs and labels.
df_meanstd <- df[grepl("mean()", colnames(df)) | grepl("std()", colnames(df)) | 
                   grepl("activity_labels", colnames(df)) | grepl("subject", colnames(df))]

## Calculating average measurements per subject and activity
df_average <- df_meanstd %>% 
  group_by(subject, activity_labels) %>% 
  summarise_all(funs(mean))