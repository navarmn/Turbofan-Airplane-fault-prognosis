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

load fisheriris.mat

targets = zeros(150,1)
targets(1:50) = 1;
targets(51:100) = 2;
targets(101:150) = 3;

A = [meas, targets]
%%
n_atributos = 4;

B = normalize(A, n_atributos,4);

Teste = normalize(A, n_atributos,4);

%% MLP hyperparameteres:
%==========================================================================
mlp.inputs = n_atributos;
mlp.outputNeurons = 3;

mlp.hiddenLayers = 1;
mlp.hiddenSize = [5];

mlp.ActivationFunction = {'Tanh', 'Tanh'};

mlp.size = [mlp.inputs, mlp.hiddenSize, mlp.outputNeurons];

%mlp.lossFunction = 'Cross-entropy';
mlp.lossFunction = 'MSE';

mlp.learningRate = 0.3;
mlp.momentumRate = 0.5;

mlp.numTraining = 1;

mlp.numEpochs = 1;

for n = 1:1:mlp.hiddenLayers
    x0_buff = -1;             % Valor da entrada do BIAS -1 ou +1
    x0_h{n} = x0_buff;
end

mlp.hiddenBias =  x0_h;

y0 = -1;

mlp.outputBias = y0;

mlp.dataNumAtributes = n_atributos;

mlp.dataNumClasses = 3;

mlp

%% Separar dados em conjunto de treinamento e teste

%[Treino, Teste] = data_div5(B, 0.8);

mlp.trainingData = B;

%% Fitting the model
                          
[mlp.predict.w, mlp.predict.m, mlp.predict.weights,...
    mlp.predict.e_treinamento] ...
              = elmanClf_fit(mlp, 0);
         
%% Predictions (Classifications)

output_elman = elmanClf_predict(mlp, Teste);

% 
% rateAcerto
% 
% %%
% %figure
% %%plot(mlp.predict.e_g_treinamento{1}, 'r')
% 
% a = min(Teste(:,1));
% b = max(Teste(:,1));
% 
% %%y_gain = y.* (y'./(Teste(:,1)))
% %y_gain = (y - min(Teste(:,1)) )./ gain
% %y_gain = y ./ length(y)
% Teste_gain = normalize(Teste,1,2);
% 
% y_gain = [y' ones(length(y),1)]
% y_gain = normalize(y_gain,1,2)
% 
% figure
% hold on
% plot(Teste_gain(:,1), 'k', 'LineWidth', 2)
% plot(y_gain(:,1), 'r--', 'LineWidth', 2)
        
        
    
    
















    



    