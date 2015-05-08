library(caret)
library(doMC)

# Register 4 cores for parallel computing
registerDoMC(4)

# Read the data from csv file
data <- read.csv('Datasets/phising.csv', header = F, colClasses = "factor")

# Names list for the features
names <- c("has_ip", "long_url", "short_service", "has_at", "double_slash_redirect",
           "pref_suf", "has_sub_domain", "ssl_state", "long_domain", "favicon", "port",
           "https_token", "req_url", "url_of_anchor", "tag_links", "SFH", 
           "submit_to_email", "abnormal_url", "redirect", "mouseover", "right_click",
           "popup", "iframe", "domain_Age", "dns_record", "traffic", "page_rank",
           "google_index", "links_to_page", "stats_report", "target") 

# Add column names
names(data) <- names

# Set a random seed so we can reproduce the results
set.seed(1234)

# Create training and testing partitions
train_in <- createDataPartition(y = data$target, p = 0.75, list = FALSE)
training <- data[train_in,]
testing <- data[-train_in,]

####################### Boosted Logistic Regression ########################

# trainControl for Boosted Logisitic Regression
fitControl <- trainControl(method = 'repeatedcv', repeats = 5,
                           number = 5, verboseIter = T)

# Run a Boosted logisitic regression over the training set
log.fit <- train(target ~ .,  data = training, method = "LogitBoost",
                 trControl = fitControl, tuneLength = 5)

# Predict the testing target
log.predict <- predict(log.fit, testing[,-31])

confusionMatrix(log.predict, testing$target)

####################### SVM - RBF Kernel ########################

# trainControl for Radial SVM
fitControl = trainControl(method = "repeatedcv", repeats = 5, number = 5,
                          verboseIter = T)

# Run a logisitic regression over the training set
rbfsvm.fit <- train(target ~ .,  data = training, method = "svmRadial",
                       trControl = fitControl, tuneLength = 5)

# Predict the testing target
rbfsvm.predict <- predict(rbfsvm.fit, testing[,-31])

confusionMatrix(rbfsvm.predict, testing$target)

####################### TreeBag ########################

# trainControl for Treebag
fitControl = trainControl(method = "repeatedcv", repeats = 5, number = 5,
                          verboseIter = T)

# Run a Treebag classification over the training set
treebag.fit <- train(target ~ .,  data = training, method = "treebag",
                importance = T)

# Predict the testing target
treebag.predict <- predict(treebag.fit, testing[,-31])

confusionMatrix(treebag.predict, testing$target)

####################### Random Forest ########################

# trainControl for Random Forest
fitControl = trainControl(method = "repeatedcv", repeats = 5, number = 5,
                          verboseIter = T)

# Run a Treebag classification over the training set
rf.fit <- train(target ~ .,  data = training, method = "rf",
                     importance = T, trControl = fitControl, tuneLength = 5)

# Predict the testing target
rf.predict <- predict(rf.fit, testing[,-31])

confusionMatrix(rf.predict, testing$target)

plot(varImp(rf.fit))