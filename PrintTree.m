function [] = PrintTree(tree, parent, bound)
% Prints the tree structure (preorder traversal)

% Print current node
if (tree.value == 1);
    fprintf('parent: setosa' );
    return
elseif (tree.value == 2);
    fprintf('parent: virginica' );
    return
elseif (tree.value == 3);
    fprintf('parent: something' );
    return    
else
    % Current node an attribute splitter
    fprintf('parent: %s\tattribute: %s\tfalseChild:%s\ttrueChild:%s\tBoundary:%s \n', ...
        parent, tree.value, tree.left.value, tree.right.value, bound);
end

% Recur the left subtree
PrintTree(tree.left, tree.value, tree.bound);

% Recur the right subtree
PrintTree(tree.right, tree.value, tree.bound);

end