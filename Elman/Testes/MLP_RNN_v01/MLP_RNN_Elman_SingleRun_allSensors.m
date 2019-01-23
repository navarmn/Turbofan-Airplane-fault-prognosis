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
DataRaw = load("/media/navar/Dados/Mestrado/Mestrado/MP-Safety ITA/Conjuntos de dados/PHM08 - NASA/train.txt");
DataRaw_teste = load("/media/navar/Dados/Mestrado/Mestrado/MP-Safety ITA/Conjuntos de dados/PHM08 - NASA/test.txt");
%% Separate data per unit:
% Each unit is a motor part
% collum 1 is the number of part
% collum 2 is the time
% collum 3,4 and 5 are operational settings
% collum 6 to 26 are different sensors measuments

A.unit = data_slicer(DataRaw, 1);
C.unit = data_slicer(DataRaw_teste, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Normalizar os dados
unitNum = 1;

B = [DataRaw(:,3:26) ones(length(DataRaw(:,3:26)),1)];

Teste = [DataRaw_teste(:,3:26) ones(length(DataRaw_teste(:,3:26)),1)];

[n_amostras, n_atributos, n_classes, n_amostras_c, pos] = info_dados(B)

% B = A;
B = normalize(B, n_atributos,1);

Teste = normalize(B, n_atributos,1);

%% MLP hyperparameteres:
%==========================================================================
mlp.inputs = n_atributos;
mlp.outputNeurons = 1;

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

mlp.hiddenBias = x0_h;

y0 = -1;

mlp.outputBias = y0;

mlp.dataNumAtributes = n_atributos;

mlp.dataNumClasses = n_classes;


%% Separar dados em conjunto de treinamento e teste

%[Treino, Teste] = data_div5(B, 0.8);

mlp.trainingData = B;

mlp

%% Fitting the model
                          
[mlp.predict.w, mlp.predict.m, mlp.predict.weights,...
    mlp.predict.e_treinamento] ...
              = mlpRNNElman_fit(mlp, 0);
         
%% Predictions (Classifications)

for k=1:1:mlp.hiddenLayers
   mlp.predict.w{1}{k} 
end

[matrizConf, rateAcerto, y] = mlpRNNElman_predict(mlp, Teste);

rateAcerto

%%
figure
plot(mlp.predict.e_treinamento{1}, 'r')

%%
%%%%%%%%%%%%%%%%%%%% Expurgo
figure
subplot(3,1,1)
plot(DataRaw(:,6))
title('Train')

subplot(3,1,2)
plot(DataRaw_teste(:,6))
title('Test')

subplot(3,1,3)
plot(y,'r')
title('Output')






    



    