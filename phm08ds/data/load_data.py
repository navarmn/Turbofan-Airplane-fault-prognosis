import pandas as pd 
import os

def load_data(type='train'):
    """ Load Data from PHM08 dataset.
        By default, train set would be loaded if non argument is passed.
        
        Parameters
        ----------
        type: str, default 'train'
            Type of set to be loaded: "train", "test" or "final_test"
        """
    data = pd.read_csv(os.path.dirname(os.path.abspath(__file__)) + '/files/' 
                        + type + '.txt', sep=' ', header=None, )
    data.drop(axis=1, labels=[26,27], inplace=True)
    return data
    