function [forests] = randomForest(examples, attributes)

numberAttr = length(attributes);
numberEx = length(examples(:,1));
variables = sqrt(numberAttr);
trees = 10; % Number of trees
struct forests[10] = ('tree', 'oob');  % oob is Out of Bag error for each tree 
randEx = (632/1000)*numberEx;  % Number of random examples          
subEx = [randEx, variables+1]; % Sub-matrix for examples

% Making the forest
for i=1:trees
    rAttr = randperm(numberAttr, variables);
    rEx = randperm(numberEx, randEx);
    activeEx = ones(numberEx - randEx); % Examples left  
    for x=1:randEx
        activeEx(rEx(x)) = 0; % Removing examples that have been used
        for y=1:variables
            subEx(x,y) = examples( rEx(x), rAttr(y));
            if(x==1)
                subAttr(y) = attributes(rAttr(y));
            end
        end
        subEx(x,variables+1) = examples(rEx(x) , numberAttr+1);
        tree = ID3(subEx, subAttr, ones(variables));
        forests(i).tree = tree; % Should return a pointer to the tree
        
        forests(i).oob = oob; % Calculate OOB for each tree
    end           
end    
end