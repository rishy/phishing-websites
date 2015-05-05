# -*- coding: utf-8 -*-
# <nbformat>3.0</nbformat>

# <codecell>

import numpy as np
import pandas as pd
from bigml.api import BigML

# <codecell>

# Create a BigML instance
api = BigML()

# <codecell>

# Create source instance with train dataset
train_source = api.create_source('train.csv')

# <codecell>

# Create a BigML dataset from source instance
train_dataset = api.create_dataset(train_source)

# <codecell>

# Fit a model to the dataset
model = api.create_ensemble(train_dataset)

# <codecell>

# Read the test dataset
test_X = pd.read_csv('test.csv')
test_y = pd.read_csv('test_target.csv')
test_set = test_X.T.to_dict().values()

# <codecell>

# Holds predictions from all the samples in test set
prediction = []

for x in test_set:
    # Get predictions for complete test set
    predict = api.create_prediction(model, x)
    api.pprint(predict)
    # Append it to the prediction list
    prediction.append(predict['object'].get('output'))

# <codecell>

# Classification error
y = np.array(test_y.target)
yhat = np.array(prediction)

error = np.sum(y == yhat)/float(len(y))
print error

