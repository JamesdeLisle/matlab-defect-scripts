function [] = LoopSolve1DVaryBy()
    
    ByValZ_max = 8.0;
    ByValZ_inc = 800;
    NVec = [15,50,14];
    NumBands = 10;
	
    
	ProbArrayAll = zeros(101,NVec(2));
	gaps = zeros(2,100);

	for tik = 1:NVec(2)
		ProbArrayAll(1,tik) = tik;
	end

	for tik = 1:100
			
		By = (tik-1)/50;
		disp(sprintf('By = %f',By));	
		eSys = Solve(By,NVec,NumBands);
		PlotBands = NumBands;
		PlotLevel = 1;
		GlobalDim = 4*NVec(1)*NVec(2)*NVec(3);
		ModeArray = zeros(PlotBands,GlobalDim);
		eSys(:,1)	
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
	
		gaps(1,tik) = By;
		gaps(2,tik) = eSys(nGS,1);		

		for tik1 = 1:NVec(2)
			ProbArrayAll(tik+1,tik1) = ProbArray(3,tik1,nGS);
		end

	end
	
	fid = fopen('gapvarydata.txt','w');
	for tik1 = 1:100
		fprintf(fid,'%f %f\n',gaps(:,tik1));
	end
	fclose(fid)

	fid = fopen('surfintervarydata.txt','w');
	for tik1 = 1:NVec(2)
		fprintf(fid,'%d %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n',ProbArrayAll(:,tik1));
	end
	fclose(fid);

end

