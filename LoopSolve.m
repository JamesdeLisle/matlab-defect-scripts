function [] = LoopSolve()
    
 
    NVec = [25,50,14];
    NumBands = 10;

    GlobalDim = prod(NVec)*4;
	 
    valVar_vec = linspace(0,1.5,100);
    [m,nSteps] = size(valVar_vec)
    eSysStore = zeros(NumBands,GlobalDim+1,nSteps);
    disp(valVar_vec) 
    for tik = 1:nSteps
        valVar = valVar_vec(tik);
        [eSys] = Solve(valVar,NVec,NumBands);
        eSysStore(:,:,tik) = eSys;
    end
    
    assignin('base','eSysStore',eSysStore);  	
	gap = zeros(nSteps,1);
		
	for tik = 1:nSteps
        eValsTemp = eSysStore(:,1,tik); 
        eValsTemp = abs(eValsTemp);
        gap(tik) = 2 * min(eValsTemp);
		disp(2*min(eValsTemp))
	end
	
	fid = fopen(sprintf('%dx%dx%d_gaps.txt',NVec(1),NVec(2),NVec(3)),'w');
	
	for tik = 1:nSteps
		fprintf(fid,'%f %f\n',valVar_vec(tik),gap(tik));
	end

	fclose(fid);
	%}
    for tik = 1:nSteps
	    dlmwrite(sprintf('%dx%dx%d_eSys_By:%f.txt',NVec(1),NVec(2),NVec(3),valVar_vec(tik)) , eSysStore(:,:,tik),'delimiter',' ');
    end
	

end

