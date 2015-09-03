function [stateI, stateIstar] = ExtractEdgeStates(eSys, NVec, NumBands, DefectSign)
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Extracting states.
    disp('Extracting edge states...');
    GlobalDim = NVec(1)*NVec(2)*NVec(3)*4;
    for i = 1:NumBands
        if (eSys(i,1) > 0.0)
            break;
        end
        ZeroRef = i;
    end
    
    for i = 1:4
        states(i,:) = eSys((ZeroRef-2)+i,2:GlobalDim+1);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Removing global phase
    for i = 1:4
        for j = 1:GlobalDim
            if (states(i,j) > 1e-8)
                states(i,:) = states(i,:)/angle(states(i,j));
                %disp(sprintf('ElNum: %d, Phase: %f\n', j, angle(states(i,j))));
                break;
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Truncating states.
    cutoff = 1e-3;
    for i = 1:4
        for j = 1:GlobalDim
            if (abs(real(states(i,j))) < cutoff) && (abs(imag(states(i,j))) < cutoff)
                states(i,j) = 0.0;
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Creating unselected Hamiltonian terms. 
    for i = 1:4
        statesSparse(i,:) = sparse(states(i,:));
    end
    
    stateItemp = statesSparse(3,:)'*statesSparse(4,:);
    stateIstartemp = statesSparse(2,:)'*statesSparse(1,:);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Interaction selection.
    stateI = sparse(GlobalDim,GlobalDim);
    stateIstar = sparse(GlobalDim,GlobalDim);
    AllowPerX = 1;
    AllowPerY = 1;
    AllowPerZ = 0;
    Nx = NVec(1);
    Ny = NVec(2);
    Nz = NVec(3);
    MaxIntLengthX = 1;
    MaxIntLengthY = 1;
    MaxIntLengthZ = 5;
    strLen = 0;
    disp('Generating interaction terms...');
    for ctx = 1:Nx
        for cty = 1:Ny
            for ctz = 1:Nz
                msg = sprintf('Percentage done: %f', 100*((ctx-1)*Ny*Nz + (cty-1)*Nz + (ctz-1))/(Nx*Ny*Nz));
                fprintf(repmat('\b',1,strLen));
                fprintf(msg);
                strLen = numel(msg);
                ctxIntMin = (1-AllowPerX)*min(MaxIntLengthX, ctx-1) + AllowPerX*MaxIntLengthX;
                ctxIntMax = (1-AllowPerX)*min(MaxIntLengthX, Nx-ctx) + AllowPerX*MaxIntLengthX;
                ctyIntMin = (1-AllowPerY)*min(MaxIntLengthY, cty-1) + AllowPerY*MaxIntLengthY;
                ctyIntMax = (1-AllowPerY)*min(MaxIntLengthY, Ny-cty) + AllowPerY*MaxIntLengthY;
                ctzIntMin = (1-AllowPerZ)*min(MaxIntLengthZ, ctz-1) + AllowPerZ*MaxIntLengthZ;
                ctzIntMax = (1-AllowPerZ)*min(MaxIntLengthZ, Nz-ctz) + AllowPerZ*MaxIntLengthZ;
                for ctxInt = -ctxIntMin:ctxIntMax
                    for ctyInt = -ctyIntMin:ctyIntMax
                        for ctzInt = -ctzIntMin:ctzIntMax
                            for ct1 = 1:4
                                for ct2 = 1:4 
                                    
                                    StateIn = (ctx-1)*4*Nz*Ny + (cty-1)*4*Nz + (ctz-1)*4 + ct1;
                                    StateOut = mod(ctx+ctxInt-1,Nx)*4*Nz*Ny + mod(cty+ctyInt-1,Ny)*4*Nz + mod(ctz+ctzInt-1,Nz)*4 + ct2;
                                  
                                    if (ct1 + ct2 == 3) || (ct1 + ct2 == 7)
                                        if ( ctx > ceil(Nx/4) ) && ( ctx + ctxInt > ceil(Nx/4) ) && ( ctx < ceil(3*Nx/4)) && ( ctx + ctxInt < ceil(3*Nx/4))
                                            stateI(StateIn,StateOut) = stateItemp(StateIn,StateOut);
                                            stateIstar(StateIn,StateOut) = stateIstartemp(StateIn,StateOut);
                                        else
                                            stateI(StateIn,StateOut) = DefectSign * stateItemp(StateIn,StateOut);
                                            stateIstar(StateIn,StateOut) = DefectSign * stateIstartemp(StateIn,StateOut);
                                        end
                                    else
                                        stateI(StateIn,StateOut) = 0.0;
                                        stateIstar(StateIn,StateOut) = 0.0;
                                    end
                                    
                                    %{
                                    if (ctx + ctxInt == ceil(Nx/4)) || (ctx == ceil(Nx/4)) || (ctx + ctxInt == ceil(3*Nx/4)) || (ctx == ceil(3*Nx/4))
                                        stateI(StateIn,StateOut) = 0.0;
                                        stateIstar(StateIn,StateOut) = 0.0;
                                    end
                                    %}
                                    %{
                                    stateI(StateIn,StateOut) = stateItemp(StateIn,StateOut);
                                    stateIstar(StateIn,StateOut) = stateIstartemp(StateIn,StateOut);
                                    %}
                                    %disp(sprintf('x: %d, y: %d, z: %d; sx: %d, sy: %d, sz: %d; ct1: %d, ct2: %d', ctx, cty, ctz, ctxInt, ctyInt, ctzInt, ct1, ct2));
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    fprintf('\n');
    disp(sprintf('Approximate density of interactions: %f',nnz(stateI)));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end