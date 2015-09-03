function [] = CheckHermiticity(Ham, CheckHerm)
    if (CheckHerm == 1)
        Herm = Ham - Ham';
        HermMax = max(max(Herm));
        HermMin = min(min(Herm));
        if (HermMax ~= 0) || (HermMin ~= 0)
            disp('The Hamiltonian is not Hermitian');
            HermMax
            HermMin
        else
            disp('The Hamiltonian is Hermitian');
        end
    end
end