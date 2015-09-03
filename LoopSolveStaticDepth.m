function [] = LoopSolveStaticDepth()
    
    NVec = [25,25,10];
    NumBands = 10;
	
	eSys = Solve(1.5,NVec,NumBands);

	PlotBands = NumBands;
	PlotLevel = 1;
	GlobalDim = 4*NVec(1)*NVec(2)*NVec(3);
	ModeArray = zeros(PlotBands,GlobalDim);
	
	nGS = 1;
	for tik1 = 1:NumBands
		if (eSys(tik1,1) > 0.0)
			nGS = tik1;
			break
		end
	end	
	
	for modeN = 1:PlotBands
		ModeArray(modeN,:) = eSys((NumBands/2)+(modeN - (PlotBands/2)),2:GlobalDim+1);
	end
	
	ProbArray = zeros(NVec(1),NVec(2),NVec(3));
    for Level = 1:NVec(3)
        for ctx = 1:NVec(1)
            for cty = 1:NVec(2)
                SiteEntry = (ctx-1)*4*NVec(3)*NVec(2) + (cty-1)*4*NVec(3) + (Level-1)*4;
                modeN = nGS;  
                ProbArray(ctx,cty,Level) = abs(ModeArray(modeN,SiteEntry + 1))^2 + abs(ModeArray(modeN,SiteEntry + 3))^2;
            end
        end
    end
    disp(sprintf('EVAL = %f',eSys(nGS,1)));
    disp(eSys(:,1)) 

	for j = 1:NVec(3)
        MaxDens(j) = max(max(ProbArray(:,:,j)));
    end
    

	
	dlmwrite(sprintf('%dx%dx%d1D_By_1.5_Depth.txt',NVec(1),NVec(2),NVec(3)) ,MaxDens,'delimiter',' ');
end

