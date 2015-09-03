function [] = LoopSolve()
    
    ByValZ_max = 4.0;
    ByValZ_inc = 50;
    NVec = [25,25,14];
    NumBands = 10;
     
    GlobalDim = prod(NVec)*4;
	 
    ByValZ_vec = linspace(0.0,ByValZ_max,ByValZ_inc);
    eSysStore = zeros(NumBands,GlobalDim+1,ByValZ_inc);
	disp(ByValZ_vec)
    for tik = 1:ByValZ_inc
        ByValZ = ByValZ_vec(tik);
        [eSys] = Solve(ByValZ,NVec,NumBands);
        size(eSys)
        eSysStore(:,:,tik) = eSys;
    end
    
    assignin('base','eSysStore',eSysStore);  	
	gap = zeros(ByValZ_inc,1);
		
	for tik = 1:ByValZ_inc
        eValsTemp = eSysStore(:,1,tik); 
        eValsTemp = abs(eValsTemp);
        gap(tik) = 2 * min(eValsTemp);
		disp(2*min(eVallsTemp))
	end
	
	fid = fopen('zeegapdata.txt','w');
	
	for tik = 1:ByValZ_inc
		fprintf(fid,'%f %f\n',ByValZ_vec(tik),gap(tik));
	end

	fclose(fid);
	%}
	
	

end

