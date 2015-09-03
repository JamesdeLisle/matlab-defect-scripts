function [HamSparseEnforced] = ForceTRS(HamSparse, NVec)
    disp('Now checking Time-Reversal symmetry');
    P = [0,0,-i,0;0,0,0,i;i,0,0,0;0,i,0,0];
    C = kron(eye(NVec(1)*NVec(2)*NVec(3)),P);
    CP = sparse(C);
    A = CP*conj(HamSparse)*CP - HamSparse;
    if (nnz(A) == 0)
        disp('Hamiltonian is already Time-Reversal symmetric');
        HamSparseEnforced = HamSparse;
    else
        disp('Hamiltonian is not Time-Reversal symmetric');
        disp('Now trying to enforce Time-Reversal symmetry...');
        HamSparseEnforced = (HamSparse + CP*conj(HamSparse)*CP)/2;
        disp('Checking again...');
        if (nnz(CP*conj(HamSparseEnforced)*CP - HamSparseEnforced) == 0)
            disp('Hamiltonian is now Time-Reversal symmetric');
        else
            disp('Hamiltonian is still not Time-Reversal symmetric');
            disp(sprintf('How bad is it: %d', nnz(CP*conj(HamSparseEnforced)*CP + HamSparseEnforced)));
        end
    end
end