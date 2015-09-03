function [HamSparse] = OpenX(HamSparse, NVec, ZeeFlag)
    

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
    disp('Opening the X direction...');
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
                                    
                                    if (ctx == 1) || (ctx == Nx)
                                        if (ctx + ctxInt > Nx) || (ctx + ctxInt < 1)
                                            StateIn = (ctx-1)*4*Nz*Ny + (cty-1)*4*Nz + (ctz-1)*4 + ct1;
                                            StateOut = mod(ctx+ctxInt-1,Nx)*4*Nz*Ny + mod(cty+ctyInt-1,Ny)*4*Nz + mod(ctz+ctzInt-1,Nz)*4 + ct2;
                                            HamSparse(StateIn,StateOut) = 0.0;
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    fprintf('\n');
    if ZeeFlag
        BTopVec(3,2) = 0.5;
        BBotVec(3,2) = 0.5;
        BFieldTopX = BTopVec(1,2)*kron([[1,0];[0,-1]],eye(2)) + BTopVec(2,2)*kron([[0,1];[1,0]],eye(2)) + BTopVec(3,2)*kron([[0,-1i];[1i,0]],eye(2));
        BFieldBotX = BBotVec(1,2)*kron([[1,0];[0,-1]],eye(2)) + BBotVec(2,2)*kron([[0,1];[1,0]],eye(2)) + BBotVec(3,2)*kron([[0,-1i];[1i,0]],eye(2));
        for cty = 1:Ny
            for ctz = 1:Nz
                for ct1 = 1:4
                    for ct2 = 1:4
                        StateIn = (1-1)*4*Nz*Ny + (cty-1)*4*Nz + (ctz-1)*4 + ct1;
                        StateOut = (1-1)*4*Nz*Ny + (cty-1)*4*Nz + (ctz-1)*4 + ct2;
                        if (ctz <= Nz/2)
                            HamSparse(StateOut,StateIn) = HamSparse(StateOut,StateIn) + BFieldTopX(ct1,ct2);
                        else
                            HamSparse(StateOut,StateIn) = HamSparse(StateOut,StateIn) + BFieldTopX(ct1,ct2);
                        end

                        StateIn = (Nx-1)*4*Nz*Ny + (cty-1)*4*Nz + (ctz-1)*4 + ct1;
                        StateOut = (Nx-1)*4*Nz*Ny + (cty-1)*4*Nz + (ctz-1)*4 + ct2;
                        if (ctz <= Nz/2)
                            HamSparse(StateOut,StateIn) = HamSparse(StateOut,StateIn) + BFieldTopX(ct1,ct2);
                        else
                            HamSparse(StateOut,StateIn) = HamSparse(StateOut,StateIn) + BFieldTopX(ct1,ct2);
                        end

                    end
                end
            end
        end
    end









end