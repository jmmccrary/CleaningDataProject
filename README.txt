The run_Analysis.R file can be used to transform the SAMSUNG data set into a tidy set containing only mean and standard deviation data.

To do this, use the run_Analysis() function found in the run_Analysis.R file. No arguments are needed, however, 
it assumes data files can be found using the following relative path locations:
* y_train.txt  can be found in "train/y_train.txt"
* X_train.txt  can be found in "train/X_train.txt"
* y_test.txt   can be found in  "test/y_test.txt"
* X_test.txt   can be found in  "test/X_test.txt"
* features.txt can be found in "features.txt"

run_Analysis performs the following actions to produce the tidy data frame output:

1) call read_training_data, which is a function that loads in the training data set, 
	both the x and y data. The x data is given proper column names from "feature.txt".
2) call read_test_data, which is a function that loads in the test data set,
	both the x and y data. The x data is given proper column names from "feature.txt".
3) Join the two data sets together into a single data frame it calls master_df
4) Search through the names in "features.txt" to find those x data fields containing "mean" or "std".
	Columns with these names are kept, everything else from the x data is discarded and the new,
	smaller, data frame is called 'reduced_df'.
5) Replace the numbers (1-6) in the y data column, which is labeled 'activity' with the activities the
	numbers are representing. Specifically:
	1: Walking
	2: Walking_Upstairs
	3: Walking_Downstairs
	4: Sitting
	5: Standing
	6: Laying
6) call create_tidy_df, to make summarize the data with a single mean for each person/activity pair. 
	It does this by walking through the data frame, one row at a time, and summing each column as
	it goes. When it reaches the end of an activity (walking, walking_upstairs, etc) it divides the
	sum for each column by the number of rows counted to get the means, and adds a row of means to a
	new data frame called tidy_df. This is repeated through all the activities to fill out tidy_df,
	which is then returned.


