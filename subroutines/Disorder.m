function  [DisorderVal] = Disorder(ct1, ct2, DisorderToggle)
    Order = 1e-6;
    if (DisorderToggle == 1)
        if (ct1 == ct2) 
            DisorderVal = (-Order) + (Order + Order) * rand(1,1);
        else
            DisorderVal = 0.0;
        end
    else
        DisorderVal = 0.0;
    end
    
end
