function [forests] = randomForest(examples, attributes, trees=10)
  
  numberAttr = length(attributes);
  numberEx = length(examples(:,1));
  variables = ceil(sqrt(numberAttr));
  randEx = floor((632/1000)*numberEx);  % Number of random examples 
  activeEx = numberEx - randEx; % Examples left
  struct forests[trees] = ('tree', 'oob');  % oob is Out of Bag error for each tree 
  subEx = zeros(randEx, variables+1); % Sub-matrix for examples
  testSet = zeros(activeEx, variables+1);
  
   % Making the forest
for i=1:trees
    [subEx, testSet, subAttr] = randomSamping(examples, attributes ,randEx, activeEx);
    tree = ID3(subEx, subAttr, ones(variables));
    forests(i).tree = tree; % Should return a pointer to the tree
    forests(i).oob = outOfBoxError(tree, testSet, subAttr); % Calculate OOB for each tree
end  
end
