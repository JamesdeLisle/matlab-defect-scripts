function [] = LoopSolveStatic()
    
    NVec = [25,40,14];
    NumBands = 10;
	
	eSys = Solve(0.75,NVec,NumBands);
    assignin('base','eSys',eSys);

    disp(eSys(:,1))
	PlotBands = NumBands;
	PlotLevel = 1;
	GlobalDim = 4*NVec(1)*NVec(2)*NVec(3);
	ModeArray = zeros(PlotBands,GlobalDim);
		
	for modeN = 1:PlotBands
		ModeArray(modeN,:) = eSys((NumBands/2)+(modeN - (PlotBands/2)),2:GlobalDim+1);
	end
	
	ProbArray = zeros(NVec(1),NVec(2),PlotBands);
	for modeN = 1:PlotBands
		for ctx = 1:NVec(1)
			for cty = 1:NVec(2)
				SiteEntry = (ctx-1)*4*NVec(3)*NVec(2) + (cty-1)*4*NVec(3) + (PlotLevel-1)*4;   
				ProbArray(ctx,cty,modeN) = abs(ModeArray(modeN,SiteEntry + 1))^2 + abs(ModeArray(modeN,SiteEntry + 3))^2;
			end
		end
	end
	
	nGS = 1;
	for tik1 = 1:NumBands
		if (eSys(tik1,1) > 0.0)
			nGS = tik1;
			break
		end
    end
    
	
	dlmwrite(sprintf('%dx%dx%d1D_By_1.5.txt',NVec(1),NVec(2),NVec(3)) ,ProbArray(:,:,nGS),'delimiter',' ');
end

