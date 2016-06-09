function [classifications] = ClassifyByTree(tree, attributes, instance)
    attr = categorical(attributes);
    if( sum(tree.value==attr) )
        index = find(ismember(attributes, tree.value) == 1);
        if (instance(1, index) <= tree.bound ); % attribute is true for this instance
        % Recur down the right side
        classifications = ClassifyByTree(tree.right, attributes, instance); 
        else
        % Recur down the left side
        classifications = ClassifyByTree(tree.left, attributes, instance);
        end
    else
        classifications =tree.value;
    end    
end
