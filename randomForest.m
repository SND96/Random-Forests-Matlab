function [forests] = randomForest(examples, attributes)

numberAttr = length(attributes);
numberEx = length(examples(:,1));
variables = ceil(sqrt(numberAttr));
randEx = floor((632/1000)*numberEx);  % Number of random examples 
activeEx = numberEx - randEx; % Examples left

trees = 10; % Number of trees
struct forests[10] = ('tree', 'oob');  % oob is Out of Bag error for each tree 

subEx = zeros(randEx, variables+1); % Sub-matrix for examples
testSet = zeros(activeEx, variables+1);


% Making the forest
for i=1:trees

    rAttr = sort(randperm(numberAttr, variables));
    rEx = sort(randperm(numberEx, randEx);
    
    for y = 1:variables
    subAttr(y) = attributes(rAttr(y));
    end
    
    Subcount = 1;
    testcount = 1;
    for x=1:numberEx
        if (any(find(x==rEx)) == 1)
            for y=1:variables
                subEx(Subcount ,y) = examples( x, rAttr(y));
            end
            subEx(Subcount ,variables+1) = examples( x , numberAttr+1);
            Subcount = Subcount + 1;
        
        else
            for y = 1:variables
                testSet(testcount, y) = examples (x, rAttr(y));
            end
            testSet( testcount, y) = examples (x,numberAttr+1);   
            testcount = testcount +1;
        end
    end
    
    tree = ID3(subEx, subAttr, ones(variables));
    forests(i).tree = tree; % Should return a pointer to the tree
        
    forests(i).oob = outOfBoxError( tree, testSet); % Calculate OOB for each tree
               
end    
end
