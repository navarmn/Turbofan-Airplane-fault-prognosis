import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn import preprocessing
from sklearn import metrics
from sklearn.model_selection import StratifiedKFold
from sklearn import metrics
from sklearn.preprocessing import OneHotEncoder
from sklearn.externals import joblib

import os
from itertools import cycle

#################################### Run classifiers: ##########################
def run_classifiers(X, y, classifiers, cv):
   
    skf = StratifiedKFold(n_splits=cv)
    
    # define local variables:
    y_train_pred = dict((k, []) for k in classifiers.keys())
    y_test_pred = dict((k, []) for k in classifiers.keys())
    y_train_true = dict((k, []) for k in classifiers.keys())
    y_test_true = dict((k, []) for k in classifiers.keys())

    output = {'train': {'true': {},
                        'pred': {}},
              'test': {'true': {},
                        'pred': {}}
             }
                
    # iterate over dataset
    for train_idx, test_idx in skf.split(X, y):
        # split data into kfolds:
        X_train, X_test = X[train_idx], X[test_idx]
        y_train, y_test = y[train_idx], y[test_idx]

        # Fit the model(s):
        # iterate over classifiers:
        for clf_name, clf in classifiers.items():
            clf.fit(X_train, y_train)

            # Append model(s) predictions:
            y_train_pred[clf_name].append(clf.predict(X_train))
            y_test_pred[clf_name].append(clf.predict(X_test))

            # Append model(s) labels:
            y_train_true[clf_name].append(y_train)
            y_test_true[clf_name].append(y_test) 
            
            classifiers[clf_name] = clf

    output['train']['true'] = y_train_true 
    output['train']['pred'] = y_train_pred
    output['test']['true'] = y_test_true 
    output['test']['pred'] = y_test_pred
    
    return output

#################################### Performance assessement: ##########################



def results_clf(n_classes, y_true, y_pred):

    metrics_keys =  {'confMat': [], 'acc': [], 'recall': [], 'precision': [], 
                     'f1': [], 'roc': {}, 'roc_auc': {},
                     'class': {}}

    results = dict((k, []) for k in y_true.keys())
    
    for key in y_true:
            ROC_buffer = {'roc':{'fpr': [], 'tpr': []},
                  'roc_auc': []}
            results[key] = dict((k, []) for k in metrics_keys.keys())
            
            for i in range(0,len(y_true[key])):
                results[key]['confMat'].append(metrics.confusion_matrix(y_true[key][i], y_pred[key][i]))
                results[key]['acc'].append(metrics.accuracy_score(y_true[key][i], y_pred[key][i]))
                results[key]['recall'].append(metrics.recall_score(y_true[key][i], y_pred[key][i], average='weighted'))
                results[key]['precision'].append(metrics.precision_score(y_true[key][i], y_pred[key][i], average='weighted'))
                results[key]['f1'].append(metrics.f1_score(y_true[key][i], y_pred[key][i], average='weighted'))

                # ROC curves for each class:
                fpr = dict()
                tpr = dict()
                roc_auc = dict()
                hot_1 = OneHotEncoder()
                hot_2 = OneHotEncoder()
                hot1_true = hot_1.fit_transform(y_true[key][i].reshape(-1,1)).toarray()
                hot1_pred = hot_2.fit_transform(y_pred[key][i].reshape(-1,1)).toarray()

                # check if hot1_true and hot1_pred have the same shape:
                if not hot1_pred.shape == hot1_true.shape:
                    value_target = hot1_true.shape[1]
                    value_current = hot1_pred.shape[1]
                    hot1_pred = np.append(hot1_pred, np.zeros((hot1_true.shape[0],value_target-value_current)), axis=1)
                for j in range(n_classes):
                    fpr[j], tpr[j], _ = metrics.roc_curve(hot1_true[:, j], hot1_pred[:, j])
                    roc_auc[j] = metrics.auc(fpr[j], tpr[j])

                ROC_buffer['roc']['fpr'].append(fpr)
                ROC_buffer['roc']['tpr'].append(tpr)
                
                ROC_buffer['roc_auc'].append(roc_auc)
                
                #results[key]['roc'][i] = ROC
                #results[key]['roc_auc'][i] = roc_auc
    
            results[key].update(ROC_buffer)
            results[key]['average'] = average_performance(results[key]) 
            
            metrics_confmat = metrics_confMat(results[key]['average']['confMat'])
            results[key]['class'] = metrics_confmat['class']
            
    return results

def average_performance(results):
    metrics_keys = {'confMat': [], 'acc': [], 'recall': [], 'precision': [], 
                    'f1': []}
    results_avg = {}
    
    results_avg = metrics_keys 
    results_avg['confMat'] =  np.mean(results['confMat'], axis=0)
    results_avg['confMat_std'] =  np.std(results['confMat'], axis=0)
    results_avg['acc'] =  np.mean(results['acc'])
    results_avg['recall'] =  np.mean(results['recall'])
    results_avg['precision'] =  np.mean(results['precision'])
    results_avg['f1'] =  np.mean(results['f1'])

    return results_avg
    

def metrics_confMat(confMat):
    metrics = {'overall': [], 'class': {'spe': [], 'sen': [], 'ppv': [], 'fsc': [], 'hm': [], 'acc': []}}
    #confMat = np.transpose(confMat)

    metrics_class = np.zeros((confMat.shape[0], 6))
    for i in range(0,confMat.shape[0]):
        TP = confMat[i,i]
        TN = np.trace(confMat) - TP;
        FP = confMat[:,i].sum() - TP;
        FN = confMat[i,:].sum() - TP;

        # SPECIFICITY
        metrics_class[i,0] = TN / (TN + FP) 
        # SENSITIVITY
        metrics_class[i,1] = TP / (TP + FN) 
        # PPV
        metrics_class[i,2] = TP / (TP + FP) 
        # Fscore:
        metrics_class[i,3] = (2*metrics_class[i,2]*metrics_class[i,1])/(metrics_class[i,2] + metrics_class[i,1])
        # HM:
        metrics_class[i,4] = (2*metrics_class[i,1]*metrics_class[i,0])/(metrics_class[i,1] + metrics_class[i,0])
        # ACC:
        metrics_class[i,5] = TP/(confMat[i,:].sum());

    metrics_class[np.isnan(metrics_class)] = 0

    metrics_overall = metrics_class.sum(axis=0)/metrics_class.shape[0]
    
    metrics['overall'] = metrics_overall
    metrics['class']['spe'] = metrics_class[:,0]
    metrics['class']['sen'] = metrics_class[:,1]
    metrics['class']['ppv'] = metrics_class[:,2]
    metrics['class']['fsc'] = metrics_class[:,3]
    metrics['class']['hm'] = metrics_class[:,4]
    metrics['class']['acc'] = metrics_class[:,5]
    
    return metrics   

#################################### Save models: ##########################


def save_models(classifiers, name='classifiers'):
    foldertree = 'Results'
    foldername = 'models'
    
    check_folder(foldertree, foldername)
        
    joblib.dump(classifiers, os.path.join(foldertree, foldername, name + '.pkl')) 
    
def save_pipeline(pipeline):
    foldertree = 'Results'
    foldername = 'models'
    
    check_folder(foldertree, foldername)
        
    joblib.dump(pipeline, os.path.join(foldertree, foldername, 'pipeline.pkl')) 

    
#################################### Export_results: ##########################


def export_results(results, foldername):
    import os
    cwd = os.getcwd()
    print(cwd)
    
    results_to_csv(results, foldername)  
    ROC_curves(results, foldername)
    return None
    
def ROC_curves(results, foldername):
    foldertree = 'Results'
    # local defs:
    # plt.style.use('../utils/seaborn-poster__navar.mplstyle')
    #colors = cycle(['aqua', 'darkorange', 'cornflowerblue', 'deeppink', 'navy'])
    lw = 5
    
    # iterate over classifiers:
    for clf in results: 
        # iterate over each fold:
        for folds in range(len(results[clf]['roc']['fpr'])):
            fpr = results[clf]['roc']['fpr'][folds]
            tpr = results[clf]['roc']['tpr'][folds]
            roc_auc = results[clf]['roc_auc'][folds]
            # iterate over each class:
            plt.figure()
            for i in range(len(fpr)):
                plt.plot(fpr[i], tpr[i], lw=lw,
                         label='ROC curve of class {0} (area = {1:0.2f})'
                         ''.format(i, roc_auc[i]))
            
            plt.plot([0, 1], [0, 1], 'k--', lw=lw)
            plt.xlim([0.0, 1.0])
            plt.ylim([0.0, 1.05])
            plt.xlabel('False Positive Rate')
            plt.ylabel('True Positive Rate')
            #plt.title('Some extension of Receiver operating characteristic to multi-class')
            plt.legend(loc="lower right")
            
            full_path = os.path.join(foldertree, foldername, 'ROC')
            check_folder(os.path.join(foldertree, foldername),'ROC')
            figName = os.path.join(full_path, 'ROC__' + clf + 'Fold_' + str(folds) + '.pdf')
            plt.savefig(figName, dpi=600, format='pdf')
            plt.close()
            #plt.show
    return None


def results_to_csv(results, foldername):
    
    # create a results folder:
    
    foldertree = 'Results'
    
    check_folder(foldertree, foldername)

    # Save results variable
    joblib.dump(results, os.path.join(foldertree, foldername, 'results.pkl'))        
    
 
    # for each classifier:
    others = {}
    for clf in results.keys():
        print(clf)
        for metric in results[clf]['average']:
            if 'confMat' in results[clf]['average']:
                # AVG confusion matrix
                pd.DataFrame(results[clf]['average']['confMat']).to_csv(os.path.join(foldertree, 
                                                                                     foldername,
                                                                                    'Result_' + clf + '_' + 'AVG_' + 'confMat' + '.csv'))
                confMat_buffer = percentage_confMat(results[clf]['average']['confMat'])
                pd.DataFrame(confMat_buffer).to_csv(os.path.join(foldertree, 
                                                                foldername,
                                                                'Result_' + clf + '_' + 'AVG_%%_' + 'confMat' + '.csv'))
                # STD confusion matrix
                pd.DataFrame(results[clf]['average']['confMat_std']).to_csv(os.path.join(foldertree, 
                                                                                     foldername,
                                                                                     'Result_' + clf + '_' + 'STD_' + 'confMat' + '.csv'))
                confMat_buffer = percentage_confMat(results[clf]['average']['confMat_std'])
                pd.DataFrame(confMat_buffer).to_csv(os.path.join(foldertree, 
                                                                foldername,
                                                                'Result_' + clf + '_' + 'STD_%%_' + 'confMat' + '.csv'))
                
            if not (metric == 'confMat' or metric == 'confMat_std'):
                others[metric] = results[clf][metric]

        output = pd.DataFrame(others)
        output.loc['average'] = output.mean()
        output.loc['std'] = output.std()
        output.to_csv(os.path.join(foldertree, foldername, 'Result_' + clf + '_' + 'metrics.csv'))
        
        output_class = pd.DataFrame(results[clf]['class'])
        output_class.to_csv(os.path.join(foldertree, foldername, 'Result_' + clf + '_AVG_Class_' + 'metrics.csv'))

        
def percentage_confMat(confMat):
    return np.around((confMat / np.sum(confMat,axis=1)[:,None])*100,2)

def check_folder(foldertree, foldername):
    #foldertree = 'Results'
    if os.path.isdir(os.path.join(foldertree, foldername)):
        return True
    else:
        if os.path.isdir(foldertree):
            os.mkdir(os.path.join(foldertree, foldername))
        else:
            os.mkdir(foldertree)
            os.mkdir(os.path.join(foldertree, foldername))
        return False




