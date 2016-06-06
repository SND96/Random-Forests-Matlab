function [tree] = ID3(examples, attributes, activeAttributes)
% ID3   Runs the ID3 algorithm on the matrix of examples and attributes
% args:
%       examples            - matrix of 1s and 0s for trues and falses, the
%                             last value in each row being the value of the
%                             classifying attribute
%       attributes          - cell array of attribute strings (no CLASS)
%       activeAttributes    - vector of 1s and 0s, 1 if corresponding attr.
%                             active (no CLASS)
% return:
%       tree                - the root node of a decision tree
% tree struct:
%       value               - will be the string for the splitting
%                             attribute, or 'true' or 'false' for leaf
%       left                - left pointer to another tree node (left means
%                             the splitting attribute was false)
%       right               - right pointer to another tree node (right
%                             means the splitting attribute was true)

numberAttr= length(activeAttributes);
numberEx = length(examples(:,1));
struct tree=('value','left','right')
lastColumn=sum(examples(:,numberAttr+1));
if(lastColumn==numberEx)
	tree.value='true';
	return
elseif(lastColumn==0)
	tree.value='false';
	return
end

if (sum(activeAttributes) == 0);
    if (lastColumnSum >= numberExamples / 2);
        tree.value = 'true';
    else
        tree.value = 'false';
    end
    return
end

p1=lastColumn/numberEx;
p0=1-p1;
if(p1==0)
	p_ent1=0;
else
	p_ent1=-p1*log2(p1);
end
if(p2==0)
	p_ent0=0;
else
	p_ent0=-p0*log2(p0);
end
currentEnt = p_ent1+p_ent0;
gains=-1*ones(1,numberAttr);

for i=1:numberAttr
	if (activeAttributes~=0)
		for j=1:numberEx
		s1=0;
		s1_true=0;
		s0=0;
		s0_true=0;
			if(examples(j,i)==0)
				s0=s0+1;
				if(examples(j,numberAttr+1)==1)
					s0_true=s0_true+1;
				end
			else
				s1=s1+1;
				if(examples(j,numberAttr+1)==1)
					s1_true=s1_true+1;
				end
			end
		end
		%For 0s
		p1=s0_true/s0;
		p0=1-p1;
		if(p1==0)
			p_ent1=0;
		else
			p_ent1=-p1*log2(p1);
		end
		if(p2==0)
			p_ent0=0;
		else
			p_ent0=-p0*log2(p0);
		end
		ent_0=p_ent1+p_ent0;
		%For 1s
		p1=s1_true/s1;
		p0=1-p1;
		if(p1==0)
			p_ent1=0;
		else
			p_ent1=-p1*log2(p1);
		end
		if(p2==0)
			p_ent0=0;
		else
			p_ent0=-p0*log2(p0);
		end
		ent_1=p_ent1+p_ent0;
		gains(i)=currentEnt- ( ((s1/numberEx)*ent_1) - ((s0/numberEx)*ent_0) );
	end
end

%Picking the attribute that maximizes gains
[~, index]=max(gains);
tree.value=attributes(index);
activeAttributes(index) = 0;
ex_1=[];
ex_0=[];
ex1_index=1;
ex0_index=1;
for j=1:numberEx
	if(examples(j,index)==1)
		for i=1:numberAttr+1
			ex_1(ex1_index,i) = examples(ex1_index,i);
		end
		ex1_index = ex1_index+1;
	else
		for i=1:numberAttr+1
			ex_0(ex0_index,i) = examples(ex0_index,i);
		end
		ex0_index = ex0_index+1;
	end
end
if (isempty(examples_0));
    leaf = struct('value',  'left', 'right');
    if (lastColumnSum >= numberExamples / 2); % for matrix examples
        leaf.value = 'true';
    else
        leaf.value = 'false';
    end
    tree.left = leaf;
else
    % Here is were we can recur
    tree.left = ID3(examples_0, attributes, activeAttributes);
end
% For value = true or 1, corresponds to right branch
% If examples_1 is empty, add leaf node to the right with relevant label
if (isempty(examples_1));
    leaf = struct('value', 'left', 'right');
    if (lastColumnSum >= numberExamples / 2); % for matrix examples
        leaf.value = 'true';
    else
        leaf.value = 'false';
    end
    tree.right = leaf;
else
    % Here is were we can recur
    tree.right = ID3(examples_1, attributes, activeAttributes);
end

% Now we can return tree
return
end
