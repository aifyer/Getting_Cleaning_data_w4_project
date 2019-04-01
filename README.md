# Getting_Cleaning_data_w4_project

* 1. Download the file with download() function and unzip it. can skip this step if data exsits already.
* 2. Read the Subject & X tables with fread() function of data.table library. Read the y tables by read.table; add a groupset column to the Subject data, to keep the "test" & "train" group set information
* 3. Change the activity labelling of testy/trainy files from numbers of 1:6 to meaningful characters according to activity_labels.txt
* 4. Change the feature names from features.txt file: change all the symbols of [-(),] to [_] and keep only one [_] if there are more. Add the 561 feature names to the 561 variables of testx and trainx data.
* 5. Merge the all the data to one: cbind sub/x/y data of test and train separately, and then rbind test and train to form one whole data named "har".
* 6. Extract the mean and std values from the 561 variables by grepl, and subset the mean/std data to harExt
* 7. Group harExt by subjectID and activity. column "groupset" also included only to keep this infomation. As each subjectID has a unique groupset, add "groupset" here will not group the data any further. Calculate the mean value of each group by function "summarize_at" from "dplyr" package. 
* 8. Write the final tidy data out, and delete all the varialbes from memory.
