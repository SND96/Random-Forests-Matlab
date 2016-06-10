function [classifications] = ClassifyByTree(tree, attributes, instance)
    attr = categorical(attributes);
    if( sum(strcmp(tree.value,attr)) >0)
        index = find(ismember(attributes, tree.value) == 1);
        if (instance(1, index) <= tree.bound ); % attribute is true for this instance
        % Recur down the right side
        fprintf('lef');
        classifications = ClassifyByTree(tree.right, attributes, instance); 
        else
        % Recur down the left side
        
        fprintf('rig');
        classifications = ClassifyByTree(tree.left, attributes, instance);
        end
    else
        classifications =tree.value;
        return
    end    
end