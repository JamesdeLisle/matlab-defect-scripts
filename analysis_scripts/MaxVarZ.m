function [] = PlotDensityZ(ChooseIn)
    eSysFinal = evalin('base','eSys');
    NVec = evalin('base','NVec');
    NumBands = evalin('base','NumBands');
    GlobalDim = 4*NVec(1)*NVec(2)*NVec(3);
    PlotBands = NumBands;
    Choose = ChooseIn;
	ModeArray = zeros(PlotBands,GlobalDim);
    
    for modeN = 1:PlotBands
        ModeArray(modeN,:) = eSysFinal((NumBands/2)+(modeN - (PlotBands/2)),2:GlobalDim+1);
    end
    
    ProbArray = zeros(NVec(1),NVec(2),NVec(3));
    for Level = 1:NVec(3)
        for ctx = 1:NVec(1)
            for cty = 1:NVec(2)
                SiteEntry = (ctx-1)*4*NVec(3)*NVec(2) + (cty-1)*4*NVec(3) + (Level-1)*4;
                modeN = (PlotBands/2)+Choose;  
                ProbArray(ctx,cty,Level) = abs(ModeArray(modeN,SiteEntry + 1))^2 + abs(ModeArray(modeN,SiteEntry + 3))^2;
            end
        end
    end
    disp(sprintf('EVAL = %f',eSysFinal((PlotBands/2)+Choose,1)));
    
    
    for j = 1:NVec(3)
        MaxDens(j) = max(max(ProbArray(:,:,j)));
    end
    
    for i = 1:NVec(3)
        BandNVec(i) = i;
    end
    
	clf reset
    
    figure(1)
    hold on
    plot(BandNVec,MaxDens,'.');
    hold off
    
end