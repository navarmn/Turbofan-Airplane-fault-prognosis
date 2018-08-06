import numpy as np 
import pandas as pd 
from sklearn.base import TransformerMixin

class data_per_unit(TransformerMixin):
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

class data_per_sensor(TransformerMixin):
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





        