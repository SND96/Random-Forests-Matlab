function [oob] = outOfBoxError(tree, testSet, subAttr)

                    % 1 - Iris-setosa                 %
                    % 2 - Iris-versicolor             %
                    % 3 - Iris-virginica              %
                    
                    
  actual = testSet(:, size(testSet,2) );
  correct = 0;
  
  
  for i = 1:size(testSet,1)
    prediction = ClassifyByTree(tree, subAttr, testSet(i, :) );
    if( strcmp( prediction, actual(i) ) == 0 )
      correct = correct + 1;
    end
  end
  
  error = 1 - (correct / size(testSet,1));
end
