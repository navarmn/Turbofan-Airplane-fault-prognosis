%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BLA BLA BLA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   Navar de Medeiros Mendon�a e Nascimento
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clear all
close all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

data = csvread('/mnt/Work/Mestrado/Mestrado/MP-Safety_ITA/Analyses_and_Experiments/PHM08_data_science/data/interim/data_preprocessed_cleaned.csv',1,1);
labels = csvread('/mnt/Work/Mestrado/Mestrado/MP-Safety_ITA/Analyses_and_Experiments/PHM08_data_science/data/interim/data_preprocessed_cleaned_labels.csv',0,1);

A = [data, labels];

%% Normalizar os dados

[n_amostras, n_atributos, n_classes, n_amostras_c, pos] = info_dados(A)

C = normalize(A,n_atributos,3);
%% Experiment params

experiment.data = C;
experiment.datasetName = 'PMH08-data_op_01_cleaned';
experiment.dataDivisionMethod = 'Holdout'
experiment.dataPercentage = 0.8;
experiment.numRuns = 3;
%experiment.clf.methods = {'Bayes', 'elman'};
experiment.clf.methods = {'Elman'};

%% Start simulations

% elman 01

elman{1}.inputs = n_atributos;
elman{1}.outputNeurons = n_classes;
elman{1}.hiddenLayers = 1;
elman{1}.hiddenSize = 50;

elman{1}.ActivationFunction = {'Tanh','Tanh'};

elman{1}.size = [elman{1}.inputs, elman{1}.hiddenSize, elman{1}.outputNeurons];

%elman.lossFunction = 'Cross-entropy';
elman{1}.lossFunction = 'MSE';
elman{1}.trainingType = 'Epochs';

elman{1}.learningRate = 0.10;
elman{1}.momentumRate = 0.00;

elman{1}.numTraining = 1;
elman{1}.numRecTraining = 5;

elman{1}.numEpochs = 200;

for n = 1:1:elman{1}.hiddenLayers
    x0_buff = -1;             % Valor da entrada do BIAS -1 ou +1
    x0_h{n} = x0_buff;
end

elman{1}.hiddenBias =  x0_h;

elman{1}.outputBias = -1;

elman{1}.dataNumAtributes = n_atributos;

elman{1}.dataNumClasses = n_classes;

%%

%experiment.clf.bayes = bayes;
experiment.clf.elman = elman;

%% Run experiment
exp_out = runExperiment(experiment);

%% Save results

results = perfExperiment(exp_out)

%results.avg.testing.elman{1}

%%

save(['workspace' '.mat'])


% 
% !shutdown -h +10


















