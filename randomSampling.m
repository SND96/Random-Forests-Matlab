function [trainingSet, testSet, subAttr] = randomSampling(examples, attributes ,randEx)

%takes in examples (stacked as a row, last column being the classification)
%         attributes- list of attributes -All attributes
%         randEx - number of random examples to be selected from examples- Assumed the user gives a values < = numberEx

%returns - training Set- row wise stacked randomly picked examples- last column is classification answer
%        - testSet- row wise stacked examples that are ommited from the training Set
%        - subAttr - column vector of attributes picked from the attributes vector.

  numberAttr = length(attributes);  %number of attributes total
  numberEx = size(examples,1);      %number of examples total
  variables = ceil(sqrt(numberAttr)); % number of variables to be picked
  rAttr = sort(randperm(numberAttr, variables)); % vector containing random numbers corresponding attributes to be picked
  rEx = sort(randperm(numberEx, randEx);%  vector containing random numbers corresponding examples to be picked into test set
  
  %the following variables are to be returned
  trainingSet = zeros(randEx,variables+1);
  tesetSet = zeros(numberEx-randEx, variables+1);
  subAttr = zeros(variables,1);
  
  
  for y = 1:variables
      subAttr(y) = attributes(rAttr(y));
  end
  
  Subcount = 1;
  testcount = 1;
  
  for x=1:numberEx  %go through all the examples
    
    if (any(find(x==rEx)) == 1)  %if index is in rEx
    
      for y=1:variables
        subEx(Subcount ,y) = examples(x, rAttr(y));
      end
      subEx(Subcount ,variables+1) = examples(x , numberAttr+1);
      Subcount = Subcount + 1;
  
    else %else add to testSet
  
      for y = 1:variables
        testSet(testcount, y) = examples (x, rAttr(y));
      end
      testSet( testcount, y) = examples (x, numberAttr+1);   
      testcount = testcount +1;
    end
  end

end
