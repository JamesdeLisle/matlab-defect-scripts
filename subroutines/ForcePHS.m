function [HamSparseEnforced] = ForcePHS(HamSparse, NVec)
    disp('Now checking Particle-Hole symmetry');
    P = [0,1,0,0;1,0,0,0;0,0,0,1;0,0,1,0];
    C = kron(eye(NVec(1)*NVec(2)*NVec(3)),P);
    CP = sparse(C);
    A = CP*conj(HamSparse)*CP + HamSparse;
    if (nnz(A) == 0)
        disp('Hamiltonian is already Particle-Hole symmetric');
        HamSparseEnforced = HamSparse;
    else
        disp('Hamiltonian is not Particle-Hole symmetric');
        disp('Now trying to enforce Particle-Hole symmetry...');
        HamSparseEnforced = (HamSparse - CP*conj(HamSparse)*CP)/2;
        disp('Checking again...');
        if (nnz(CP*conj(HamSparseEnforced)*CP + HamSparseEnforced) == 0)
            disp('Hamiltonian is now Particle-Hole symmetric');
        else
            disp('Hamiltonian is still not Particle-Hole symmetric');
            disp(sprintf('How bad is it: %d', nnz(CP*conj(HamSparseEnforced)*CP + HamSparseEnforced)));
        end
    end
end