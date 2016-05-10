function [labels E Eafter] = calcMask(prediction,prediction_init,q_c_data,q_c_data_init,margins)

[numBounds numColumns] = size(prediction);
numNodes = prod(size(prediction));
unary = [zeros(1,numNodes); ones(1,numNodes)*3];
% evaluate the data term of the objective function
unary(1,:) = reshape(floor(((q_c_data - repmat(margins.mu(4,:),numColumns,1))./repmat(margins.sigma(4,:),numColumns,1))),1,[]);
% evaluate the difference between the initial segmentation and the final one
unary(1,:) = unary(1,:) + reshape(floor(abs(prediction-prediction_init)'),1,[])/2 - 2;


segclass = zeros(1,numNodes);
lambda = 8;
labelcost = [0 lambda; lambda 0];
% create edges of grid graph; matrix of dim numNodes x numNodes

counter = 1;
for i = 1:numBounds
    for j = 1:numColumns
        idx = (i-1)*numColumns + j;
        if j < numColumns
            I(counter) = idx;
            J(counter) = idx+1;
            counter = counter+1;
        end

        if j > 1
            I(counter) = idx;
            J(counter) = idx-1;
            counter = counter+1;
        end

        if i < numBounds
            I(counter) = idx;
            J(counter) = idx + numColumns;
            counter = counter+1;
        end

        if i > 1
            I(counter) = idx;
            J(counter) = idx - numColumns;
            counter = counter + 1;
        end
    end
end
addpath(genpath('/home/fabian/Documents/Arbeit/Code/MyCode/Libs/MRFSolve'));

S = ones(1,length(I));
pairwise = sparse(I,J,S,numNodes,numNodes);
[labels E Eafter] = GCMex(segclass, single(unary), pairwise, single(labelcost),0);
labels = reshape(labels,numColumns,numBounds)';

