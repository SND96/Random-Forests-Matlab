function [classifications] = ClassifyByTree(tree, attributes, instance)

    if( strcmp(tree.value, 'Iris-setosa') )
        classifications = 'Iris-setosa';
        return
    end

    if( strcmp(tree.value, 'Iris-versicolor') )
        classifications = 'Iris-versicolor';
        return
    end

    if( strcmp(tree.value, 'Iris-virginica') )
        classifications = 'Iris-virginica';
        return
    end

    index = find(ismember(attributes, tree.value) == 1)

    % picking branch- need the ID3 coder to complete this file%

end
