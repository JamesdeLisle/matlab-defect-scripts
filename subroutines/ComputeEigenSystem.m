function [eSys] = ComputeEigenSystem(NVec, Ham, NumBands)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Hamiltonaian preparation
    disp('Diagonalisation Initialising...');
    %HamSparse = sparse(Ham);
    %[HamSparse] = ForcePHS(HamSparse, NVec);
    disp('Solving...');
    %pause;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Solve system.
    opts.p = 20;
    [V,D] = eigs(Ham, NumBands, 0.0, opts);
	eSys(:,:) = sortrows([diag(D)+2 00,V'],1);
	eSys(:,1) = eSys(:,1)-200;
    disp('Done!');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
end
