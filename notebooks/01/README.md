# Discussions about this experiment

This experiment was designed to access the performance of different classifiers in the NASA PHM08 dataset, to compare with other reports on literature.

## Experiment goal
Determine promising classifiers on PHM08 dataset.

## Experiments settings

### Dataset used:
```train.txt```

**Brief dataset description:**
	* Features: the values of sensors 2,3,4,7,11 and 12, according to Wang (2008);
	* Number of Features: 6;
	* Classes: Health states, according to Tamiselvan (2013);
	* Number of classes: 4;
	* Operational conditions are set according to Wang (2008);
	* Each operational conditions result in a different subset of data. Ideally, for one operational condition a classifiers would be responsible to identify health states.	


### Classifiers selected:
- KNN
- Random Forest
- Gaussian Naive-Bayes
- Gaussian Linear classifier
- Gaussian Quadratic classifier
- Gaussian Quadratic classifier
- Perceptron
- SGD

Default settings of ```scikit-learn``` are used. No hyperparameters tunning was performed, for now.


### Experiments setups:

- Cross-validation method: 10-fold;

### Performance assessment (metrics):

- Accuracy overall;
- Accuracy per-classes;
- Confusion matrix;

### Results:

**Table 01: Results from classifiers on dataset or regime 1.**

| Classifier        | Acc (%)            | Cool  |
| ------------- |:-------------:| -----:|
| col 3 is      |  $\pm$ | $1600 |
| col 2 is      | centered      |   $12 |
| zebra stripes | are neat      |    $1 |

### Conclusions:

No conclusions, either.


#### Aditional information:

The notebook runs on top of `experiment.py`. [Purge](./Purge/) are files not necessary, most like a separate place for trying stuff.
