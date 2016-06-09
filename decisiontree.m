function [] = decisiontree()

ex = load('irisdata.txt');

attributes = ['sepal length', 'sepal width','petal length','petal width'];
numAttributes = 4;

tree = ID3(ex, attributes, ones(numAttributes))

PrintTree(tree,null,null);  %wtf?

for i = 1:150
outcome = ClassifyByTree(tree, attributes, ex(i,:));
fprintf(outcome);
end
end
