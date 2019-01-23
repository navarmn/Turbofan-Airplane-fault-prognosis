clc
close all
clear all
%%

load workspace.mat

%%

K = 5

model{1} = exp_out{1}.experiment.clf.elman{1};
model{2} = exp_out{2}.experiment.clf.elman{1};
model{3} = exp_out{3}.experiment.clf.elman{1};
model{4} = exp_out{4}.experiment.clf.elman{1};
model{5} = exp_out{5}.experiment.clf.elman{1};

y_true = experiment.data(:,end);

%%

for k = 1:1:K
    
    y_pred{k} = elmanClf_predict(model{k}, experiment.data);
    
    metrics{k} = clfMetrics(y_true, y_pred{k})

    disp(['Model #' num2str(k)])

    disp(metrics{k}.overall.confMat)
    disp(metrics{k}.overall)

end


% conf_mat average

confMat_avg = zeros(size(metrics{1}.overall.confMat))

for k = 1:1:K

    confMat_avg = (metrics{k}.overall.confMat + confMat_avg)./2;

end

confMat_percentage(confMat_avg)

%% Aggregating by the mode

disp('=======================')
disp('RESULTS WITH THE MODE')

window = 40

for k = 1:1:K
    
    y_mode_true = get_mode(y_true, window);
    y_mode_pred{k} = get_mode(y_pred{k}, window);

    metrics_mode{k} = clfMetrics(y_mode_true, y_mode_pred{k});
    
    disp(['Model with mode #' num2str(k)])
    
    disp(metrics_mode{k}.overall.confMat)
    disp(metrics_mode{k}.overall)

end

% conf_mat average

confMat_avg = zeros(size(metrics_mode{1}.overall.confMat));

for k = 1:1:K

    confMat_avg = (metrics_mode{k}.overall.confMat + confMat_avg)./2;

end

confMat_percentage(confMat_avg)

%% Aggregation classes 1,2 and 3


disp('=======================')
disp('RESULTS WITH THE AGGREGATION')

for k = 1:1:K
    
    y_agg_true = get_agg(y_true);
    y_agg_pred{k} = get_agg(y_pred{k});

    metrics_agg{k} = clfMetrics(y_agg_true, y_agg_pred{k});
    
    disp(['Model with mode #' num2str(k)])
    
    disp(metrics_agg{k}.overall.confMat)
    disp(metrics_agg{k}.overall)

end

% conf_mat average

confMat_avg = zeros(size(metrics_agg{1}.overall.confMat));

for k = 1:1:5

    confMat_avg = (metrics_agg{k}.overall.confMat + confMat_avg)./2;

end

confMat_percentage(confMat_avg)








































