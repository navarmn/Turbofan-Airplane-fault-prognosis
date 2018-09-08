import pandas as pd 
import os

def load(type='train'):
    """ Load Data from PHM08 dataset.
        By default, train set would be loaded if non argument is passed.
        
        Parameters
        ----------
        type: str, default 'train'
            Type of set to be loaded: "train", "test" or "final_test"
    """
    data = pd.read_csv(os.path.dirname(os.path.abspath(__file__)) + '/files/' 
                        + type + '.txt', sep=' ', header=None)
    data.drop(axis=1, labels=[26,27], inplace=True)
    
    sensors_list = []
    for k in range(0,21):
        sensors_list.append('Sensor_' + str(k))

    headers = ['unit', 'time_step', 'operational_setting_1', 'operational_setting_2', 'operational_setting_3']

    headers = headers + sensors_list
    new_headers = dict(zip(range(0,data.shape[1]), headers))    

    data.rename(columns=new_headers, inplace=True)

    return data
