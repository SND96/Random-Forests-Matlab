function [] = decisiontree(inputFileName)

    formatSpec = '%f%f%f%f%C';    %specifies the input file format
    ex = readtable(inputFileNamem 'Delimiter',',', 'Format',formatSpec); %opens the input file

    ex = table2cell(ex); 
    for i=1:150   % Outcomes as numbers
        if(strcmp('Iris-sentosa',ex{i,5}))
            ex{i,5} = 1;
        elseif(strcmp('Iris-virginica',ex(i,5)))
            ex{i,5} = 2;
        else
            ex{i,5} = 3;
        end        
    end    

    ex = cell2mat(ex);
    attributes = ['sepal length', 'sepal width','petal length','petal width'];
    numAttributes = 4;

    tree = MV_ID3(ex, attributes, ones(numAttributes))

    PrintTree(tree,*******);  %wtf?

    for i = 1:150
        outcome = ClassifyByTree(tree, attributes, ex(i,:));
        fprintf("%f", outcome);
    end
end
