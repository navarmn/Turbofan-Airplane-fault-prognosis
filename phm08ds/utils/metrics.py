import numpy as np

def conf_mat_percentage(conf_mat):

    conf_mat_new = np.zeros(conf_mat.shape)

    for i in range(0, conf_mat.shape[0]):
        conf_mat_new[i,:] = 100*(conf_mat[i,:] / conf_mat[i,:].sum())

    return conf_mat_new