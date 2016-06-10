function [tree] = MV_ID3(examples, attributes, activeAttributes)

numberAttr= length(activeAttributes);
numberEx = length(examples(:,1));
tree = struct('value','null','bound' ,'null', 'left', 'null', 'right', 'null');

lastColumn = examples(:, numberAttr+1);  % Stores the outcomes column
un =unique(lastColumn);  % Finds all the unique elements in the outcomes column

 
num_outcome = length(un);  % Stores number of unique outcomes

if(num_outcome == 1)
    tree.value = un;
    return
end    
occu = zeros(1,num_outcome);
if (sum(activeAttributes) == 0);
    % Counting outcome with highest frequency and assigning that as value
    for k=1:num_outcome
        occu(k) = sum(un(k)==lastColumn); % Checks element equality
    end    
    [~, instance] = max(occu);    
    tree.value = un(instance);
    return
end

gainx = zeros(1,num_outcome);
gainind = zeros(1,num_outcome);
boundOut = zeros(1,num_outcome);

% Need to first iterate through all possible outcomes. Then using one vs
% all classification find the best attribute to split on. However since the
% data is continuous, need to use each different data point as a decision
% boundary and find the one which gives the lowest entropy.
for k=1:num_outcome
    ele = un(k); % Stores the current outcome element being tested with.
    gainAttr = zeros(1,numberAttr+1);
    boundValue = zeros(1,numberAttr+1);
    occ = sum(lastColumn == ele);
    % Initial entropy calculation
    p1 = occ/numberEx;
    p0=1-p1;
    if(p1==0)
        p_ent1=0;
    else
        p_ent1=-p1*log2(p1);
    end
    if(p0==0)
        p_ent0=0;
    else
        p_ent0=-p0*log2(p0);
    end
    currentEnt = p_ent1+p_ent0;
    gains = -1*ones(1,numberAttr+1);    
    for i=1:numberAttr
        if (activeAttributes(i)~=0)
            examples=sortrows(examples,i);        
            for l=1:(numberEx-1)
                if( examples(l,i)==examples(l+1,i))
                    continue;
                end
                % Finding decision boundary for iteration
                test =( examples(l,i)+examples(l+1,i))/2;
                    s1=0;
                    s1_true=0;
                    s0=0;
                    s0_true=0;
                % Checking how many fall on each side of the boundary
                for j=1:numberEx
                    
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
                if(p0==0)
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
                    p_ent1=-1*p1*log2(p1);
                end
                if(p0==0)
                    p_ent0=0;
                else
                    p_ent0=-1*p0*log2(p0);
                end
                ent_1=p_ent1+p_ent0;
                
                gains(l)=currentEnt- ( ((s1/numberEx)*ent_1) + ((s0/numberEx)*ent_0) );
                
            end
            % Picking best attribute and corresponding decision attribute
            % for each OUTCOME seperately
            [gainAttr(i),boundInd] = max(gains);
            
            boundValue(i) = (examples(boundInd,i)+examples(boundInd+1,i))/2;
        end
    end
    
    % Picking the attribute and corresponding boundary that maximizes gains
    [gainx(k), gainind(k)]=max(gainAttr);
    
    
       
    boundOut(k) = boundValue(gainind(k));
end
% Finding the max information gain index.
% This index allows us to access the corresponding outcome, attribute and
% decision boundary
[m, ind]  = max(gainx);
index = gainind(ind); % Required index
fBound = boundOut(ind); % Decision boundary
tree.value = attributes{index};
tree.bound = fBound;
if(m==0)
    return
end
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
			ex_1(ex1_index,i) = examples(j,i);
		end
		ex1_index = ex1_index+1;
	else
		for i=1:numberAttr+1
			ex_0(ex0_index,i) = examples(j,i);
		end
		ex0_index = ex0_index+1;
	end
end
if (isempty(ex_0));
    leaf = struct('value','null', 'left', 'null', 'right', 'null');
    % Counting outcome with highest frequency and assigning that as value
    for k=1:num_outcome
        occu(k) = sum(un(k)==lastColumn);
    end
    [~, instance] = max(occu);    
    leaf.value =  un(instance);
    tree.left = leaf;
    return;
    
else
    active = activeAttributes;
       lastColumn = ex_0(:, numberAttr+1);  % Stores the outcomes column
       un =unique(lastColumn);  % Finds all the unique elements in the outcomes column
       if(length(un)<num_outcome )
           active = ones(1,numberAttr);  % Resetting the attributes for classification for greater accuracy
      end
   % Recurring here
   
    tree.left = MV_ID3(ex_0, attributes, active);
end
if (isempty(ex_1));
    leaf = struct('value','null', 'left', 'null', 'right', 'null');
    % Counting outcome with highest frequency and assigning that as value
     
    for k=1:num_outcome
        occu(k) = sum(un(k)==lastColumn);
    end    
    [~, instance] = max(occu);    
    leaf.value =  un(instance);
    tree.right = leaf;
    return
else
     active = activeAttributes;
       lastColumn = ex_1(:, numberAttr+1);  % Stores the outcomes column
       un =unique(lastColumn);  % Finds all the unique elements in the outcomes column
       if(length(un)<num_outcome)
           active = ones(1,numberAttr);  % Resetting the attributes for classification for greater accuracy
       
      end
     % Recurring here
     
    tree.right = MV_ID3(ex_1, attributes, active);
end

return
end