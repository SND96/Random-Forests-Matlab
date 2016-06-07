function [trainingSet, testSet, subAttr] = randomSampling(examples, attributes ,randEx, activeEx)

  rAttr = sort(randperm(numberAttr, variables));
  rEx = sort(randperm(numberEx, randEx);
  numberAttr = length(attributes);

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
      testSet( testcount, y) = examples (x, numberAttr+1);   
      testcount = testcount +1;
    end
  end

end
