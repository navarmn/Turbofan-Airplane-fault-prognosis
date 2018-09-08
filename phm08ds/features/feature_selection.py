import numpy as np 
import pandas as pd 
from sklearn.base import BaseEstimator, TransformerMixin

class SelectSensors(BaseEstimator, TransformerMixin):

    def __init__(self, kind='Wang2008'):
        self.kind = kind
        if type(self.kind) is str:
            if self.kind == 'Wang2008':
                self.sensors = [2,3,4,7,11,12,15]
        elif all(type(n) is int for n in self.kind):
            self.sensors = self.kind

    def fit(self, X):
        return self
    
    def transform(self, X):            
        sensor_headers = map(lambda x: 'Sensor_' + str(x), self.sensors)

        general_info = ['unit', 'time_step', 'operational_setting_1', 'operational_setting_2', 'operational_setting_3']
        important_info = ['Operational_condition', 'Health_state']

        return X.get(general_info + list(sensor_headers) + important_info)


class RemoveInfo(BaseEstimator, TransformerMixin):

    def fit(self, X):
        return self

    def transform(self, X):
        return X.drop(labels=['unit', 'time_step', 'operational_setting_1', 
                        'operational_setting_2', 'operational_setting_3', 
                        'Operational_condition'], axis=1)

class RemoveSensor(BaseEstimator, TransformerMixin):

    def __init__ (self, sensors):
        self.sensors = sensors

    def fit(self, X):
        return self

    def transform(self, X):
        sensor_headers = map(lambda x: 'Sensor_' + str(x), self.sensors)

        return X.drop(labels=sensor_headers, axis=1)
