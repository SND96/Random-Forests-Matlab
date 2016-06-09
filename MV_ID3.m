function [tree] = MV_ID3(examples, attributes, activeAttributes)

numberAttr= length(activeAttributes);
numberEx = length(examples(:,1));
tree = struct('value','null','bound' ,'null', 'left', 'null', 'right', 'null');
examples = sortrows(examples, numberAttr+1); % Sorts examples based on the last column
lastColumn = examples(:, numberAttr+1);  % Stores the outcomes column
un =unique(lastColumn);  % Finds all the unique elements in the outcomes column
ele = un(1);
num_outcome = length(un);  % Stores number of unique outcomes
if(num_outcome == 1)
    tree.value = ele;
    return
end    
occu = zeros(num_outcome);
if (sum(activeAttributes) == 0);
    % Counting outcome with highest frequency and assigning that as value
    for k=1:num_outcomes
        occu(k) = sum(un(k)==lastColumn); % Checks element equality
    end    
    [~, instance] = max(occu);    
    tree.value = un(instance);
end    
gainx = zeros(num_outcome);
gainind = zeros(num_outcome);
boundOut = zeros(num_outcome);

% Need to first iterate through all possible outcomes. Then using one vs
% all classification find the best attribute to split on. However since the
% data is continuous, need to use each different data point as a decision
% boundary and find the one which gives the lowest entropy.
for k=1:num_outcome
    ele = un(k); % Stores the current outcome element being tested with.
    gainAttr = zeros(numberAttr);
    boundValue = zeros(numberAttr);
    occ = sum(lastColumn == ele);
    % Initial entropy calculation
    p1 = occ/numberEx;
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
    gains = -1*ones(1,numberAttr);    
    for i=1:numberAttr
        if (activeAttributes~=0)
            examples = sortrows(examples, i);
            for l=1:numberEx
                % Finding decision boundary for iteration
                test = examples(l,i);        
                % Checking how many fall on each side of the boundary
                for j=1:numberEx
                    s1=0;
                    s1_true=0;
                    s0=0;
                    s0_true=0;
                    if(examples(j,i)>test)
                        s0=s0+1;
                        if(examples(j,numberAttr+1)==ele)
                            s0_true=s0_true+1;
                        end
                    else
                        s1=s1+1;
                        if(examples(j,numberAttr+1)==ele)
                            s1_true=s1_true+1;
                        end
                    end
                end
                % Entropy calculation
                % For false's
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
                % For true's
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
                gains(l)=currentEnt- ( ((s1/numberEx)*ent_1) - ((s0/numberEx)*ent_0) );
            end
            % Picking best attribute and corresponding decision attribute
            % for each OUTCOME seperately
            [gainAttr(i),boundInd] = max(gains);
            boundValue(i) = examples(boundInd,i);
        end
    end
    
    % Picking the attribute and corresponding boundary that maximizes gains
    [gainx(k), gainind(k)]=max(gainAttr);
    boundOut(k) = boundValue(gainind(k));
end
% Finding the max information gain index.
% This index allows us to access the corresponding outcome, attribute and
% decision boundary
[~, ind]  = max(gainx);
index = gainind(ind); % Required index
fBound = boundOut(ind); % Decision boundary
ele = un(index); % Outcome element being used in one vs all
tree.value = attributes(index);
tree.bound = fbound;
activeAttributes(index) = 0;
ex_1=[];
ex_0=[];
ex1_index=1;
ex0_index=1;
% Making the two sub-arrays based on the decision boundary for the best
% attribute
for j=1:numberEx
	if(examples(j,index)<=fBound)
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
if (isempty(ex_0));
    leaf = struct('value','null', 'left', 'null', 'right', 'null');
    % Counting outcome with highest frequency and assigning that as value
    for k=1:num_outcomes
        occu(k) = sum(un(k)==lastColumn);
    end    
    [~, instance] = max(occu);    
    leaf.value =  un(instance);
    tree.right = leaf;
else
    % Recurring here
    tree.left = MV_ID3(ex_0, attributes, activeAttributes);
end

if (isempty(ex_1));
    leaf = struct('value','null', 'left', 'null', 'right', 'null');
    % Counting outcome with highest frequency and assigning that as value
    for k=1:num_outcomes
        occu(k) = sum(un(k)==lastColumn);
    end    
    [~, instance] = max(occu);    
    leaf.value =  un(instance);
    tree.right = leaf;
else   
    % Recurring here
    tree.right = MV_ID3(ex_1, attributes, activeAttributes);
end

return
end
