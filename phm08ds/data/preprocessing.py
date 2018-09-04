import numpy as np 
import pandas as pd 
from sklearn.base import BaseEstimator, TransformerMixin
from sklearn.cluster import KMeans

class Data_per_unit(TransformerMixin):
    """ Recieves a pandas dataframe containg data and returns a dataframe with the data for the specified unit.

    Parameters
    ----------
    unit: int, default 1
        Unit selection.
        - A number from 1 to 357 in 'train';
        - A number from 1 to 364 in 'test';
        - A number from 1 to 298 in 'final_test'.

    """

    def __init__(self, unit=1):
        """ Return the object with the unit to select from data """
        self.unit = unit

    def fit_transform(self, X):
        """ aueuhae """
        return X[X[0] == self.unit]

    def transform(self, X):
        """ auheuhaeh """
        return X[X[0] == self.unit]

class Data_per_sensor(TransformerMixin):
    """ Recieves a pandas dataframe containg data and returns a dataframe with the data for the specified unit.

    Parameters
    ----------
    sensor: int, default 1
        Sensor varies from 1 to 19.

    """

    def __init__(self, sensor=1):
        """ Return the object with the unit to select from data """
        self.sensor = sensor

    def fit_transform(self, X):
        """ aueuhae """
        return X[self.sensor + 5]

    def transform(self, X):
        """ auheuhaeh """
        return X[self.sensor]


class OperationalCondition(BaseEstimator, TransformerMixin):
    """ Recieves a pandas dataframe containg data and returns a dataframe with the data clustered and labeled
        to operational conditions.

    Parameters
    ----------
    None
    """

    def __init__(self):
        """ Return the object with the unit to select from data """
        self.sensors = 26
        self.op_centers = np.array([[ 3.50030533e+01,  8.40489284e-01,  6.00000000e+01],
                                    [ 1.00029627e+01,  2.50502528e-01,  2.00000000e+01],
                                    [ 1.51675295e-03,  4.97670406e-04,  1.00000000e+02],
                                    [ 4.20030440e+01,  8.40510423e-01,  4.00000000e+01],
                                    [ 2.50030126e+01,  6.20516407e-01,  8.00000000e+01],
                                    [ 2.00029465e+01,  7.00497164e-01, -7.13384907e-12]])

    def fit(self, X, y=None):
        return self

    def transform(self, X):
        """ Cluster the operational conditons of PHM08 dataset according to Wang et al (2008).
        
        Parameters
        ----------
        X: data.

        Reference
        ----------
        Wang, Tianyi, et al. "A similarity-based prognostics approach for remaining useful life
        estimation of engineered systems." Prognostics and Health Management, 2008.
        PHM 2008. International Conference on. IEEE, 2008.
        """
        kmeans = KMeans(n_clusters=6)
        kmeans.cluster_centers_ = self.op_centers
        operational_conditions = kmeans.predict(X.iloc[:,2:5])
        # X.insert(26, 'operational_condition', operational_conditions)

        return operational_conditions

class Data_per_op_cond(BaseEstimator, TransformerMixin):

    def __init__(self, X):
        return self
        
    def fit(self, X):
        return self

    def transform(self, X):
        return self


        