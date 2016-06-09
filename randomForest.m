function [forests] = randomForest(examples, attributes, trees=10)
  
  %takes in examples, attributes returns a forests- two values- 1) trees- pointer to a tree structure
  %                                                             2) oob - out of box error for the specific tree
  numberAttr = length(attributes);
  numberEx = length(examples(:,1));
  variables = ceil(sqrt(numberAttr));
  randEx = floor((632/1000)*numberEx);  % Number of random examples 
  activeEx = numberEx - randEx; % Examples left
  
  %return the following data correctly
  struct forests[trees] = ('tree', 'oob');  % oob is Out of Bag error for each tree 
  
   % Making the forest
  for i=1:trees
      [subEx, testSet, subAttr] = randomSamping(examples, attributes ,randEx);
      tree = MV_ID3(subEx, subAttr, ones(variables));
      forests(i).tree = tree; % Should return a pointer to the tree
      forests(i).oob = outOfBoxError(tree, testSet, subAttr); % Calculate OOB for each tree
  end  
end
