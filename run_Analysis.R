read_training_data <- function() {
	## creates and returns a 7352 x 562 data frame of training data

	## Read in the y_train data (7352 by 1)
	ydata <- read.table("train/y_train.txt")
	## Then change the name to something meaningful 
	colnames(ydata) <- "activity"

	## Read in the X_train data (7352 by 561)
	xdata <- read.table("train/X_train.txt")
	## Then change the column names to be the feature names found in features.txt
	features <- read.table("features.txt")
	colnames(xdata) <- t(features[2])

	##now form it into a single data frame
	data.frame(ydata, xdata)
}


read_testing_data <- function() {
	##creates and returns a 2947 x 562 data frame of test data

	## read in the y_test data (2947 by 1)
	ydata <- read.table("test/y_test.txt")
	## Then change the name to something meaningful 
	colnames(ydata) <- "activity"

	## Read in the X_test data (2947 by 561)
	xdata <- read.table("test/X_test.txt")
	## Then change the column names to be the feature names found in features.txt
	features <- read.table("features.txt")
	colnames(xdata) <- t(features[2])
	

	##now combine the two into a single data frame (2974 x 562)
	data.frame(ydata, xdata)
}


create_tidy_df <- function(reduced_df){

	##Takes our reduced data frame (reduced_df) with 80 columns, and 10299 rows. 
	## The first column specifies the activity (walking/laying/etc) and the other 79 are measurements
	##  taken durnings this activity. Groups by person and activity to average

	##initialize our tidy data frame, with the column names from reduced_df
	tidy_df <- t(data.frame(colnames(reduced_df)))
	
	##set inital values to begin looping through reduced_df and calculating means
	activity <- reduced_df[1,1] ##the first activity appearing in the data frame
	total <- reduced_df[1, 2:80]
	count <- 1
	for (row in 2:10299){
		if (reduced_df[row, 1] == activity){
			##still tallying the same activity, just add to total and increment count
			count <- count + 1
			total <- total + reduced_df[row, 2:80]
		}else{
			##reached a new activity

			##first finish up previous activity we had been counting
			##divide values in total by count to get the mean for each column
			total <- total / count
			##add this row of means to our tidy data frame we're forming
			tidy_df <- rbind(tidy_df, c(activity, total) )

			#now reset to start counting this new activity
			activity = reduced_df[row, 1]
			total <- reduced_df[row, 2:80]
			count = 1
		}

	}

	##return the tidy data frame
	tidy_df

}


run_Analysis <- function() {

	##First we load the two data sets
	train_df  <- read_training_data()
	test_df   <- read_testing_data()
	
	##join the two sets into one big data frame (10299 by 562)
	master_df <- rbind(train_df, test_df)
	
	##now grap a list of which features refer to mean or std-dev
	features <- read.table("features.txt")
	means <- sapply(features, grepl, patt="mean")[,2]
	stds  <- sapply(features, grepl, patt="std")[,2]
	keepers <- features[means|stds, 2]
	##at this point 'keepers' is holding a list of column names that contain 'mean' or 'std'


	##apply it to our master_df to reduce down to just these features
	##  This appends "activity" onto the front of the list of 'keepers' and pulls those fields from master_df
	reduced_df <- master_df[, c(factor("activity"), keepers)]

	
	## Now we must replace the numerical values in the "activity" column (column 1) with meaningful names
	reduced_df$activity[reduced_df$activity == "1"] <- "Walking"
	reduced_df$activity[reduced_df$activity == "2"] <- "Walking_Upstairs"
	reduced_df$activity[reduced_df$activity == "3"] <- "Walking_Downstairs"
	reduced_df$activity[reduced_df$activity == "4"] <- "Sitting"
	reduced_df$activity[reduced_df$activity == "5"] <- "Standing"
	reduced_df$activity[reduced_df$activity == "6"] <- "Laying"


	#make the tidy data frame
	create_tidy_df(reduced_df)
	

}