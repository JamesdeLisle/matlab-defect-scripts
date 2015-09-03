function [] = PlotDensityZ()
    eSysFinal = evalin('base','eSysFinal');
    NVec = evalin('base','NVec');
    NumBands = evalin('base','NumBands');
    
    PlotBands = NumBands;
    PlotLevel = ceil((NVec(2)/4));
    GlobalDim = 4*NVec(1)*NVec(2)*NVec(3);
    ModeArray = zeros(PlotBands,GlobalDim);
    
    for modeN = 1:PlotBands
        ModeArray(modeN,:) = eSysFinal((NumBands/2)+(modeN - (PlotBands/2)),2:GlobalDim+1);
    end
    
    ProbArray = zeros(NVec(1),NVec(3),PlotBands);
    for modeN = 1:PlotBands
        for ctx = 1:NVec(1)
            for ctz = 1:NVec(3)
                SiteEntry = (ctx-1)*4*NVec(3)*NVec(2) + (PlotLevel-1)*4*NVec(3) + (ctz-1)*4;   
                ProbArray(ctx,ctz,modeN) = abs(ModeArray(modeN,SiteEntry + 1))^2 + abs(ModeArray(modeN,SiteEntry + 3))^2;
            end
        end
    end
    
	for ctx = 1:NVec(1)
		ctxVec(ctx) = ctx;
    end
    
	for ctz = 1:NVec(3)
		ctzVec(ctz) = ctz;
    end

	clf reset
	
    for modeN = 1:PlotBands
        figure(modeN);
        hold on
        surf(ctzVec,ctxVec,ProbArray(:,:,modeN));
        hold off
    end
    
    for count = 1:NumBands
        numV(count) = count;
    end
    
    figure(PlotBands+1)
	hold on
	plot(numV,eSysFinal(:,1),'.')
	hold off
end