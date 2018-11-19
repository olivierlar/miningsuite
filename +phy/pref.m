% PHY.PREF
%
% Copyright (C) 2018 Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function p = pref(varargin)

persistent phy_pref

if ~nargin
    if isempty(phy_pref)
        phy_pref.displayIndex = 1;
        phy_pref.dropFrame = 1;
    end    
else

    options = sig.Signal.signaloptions();
    
        displayIndex.key = 'DisplayIndex';
        displayIndex.type = 'Boolean';
        displayIndex.default = NaN;
    options.displayIndex = displayIndex;
    
        dropFrame.key = 'DropFrame';
        dropFrame.type = 'Boolean';
        dropFrame.default = NaN;
    options.dropFrame = dropFrame;
    
        default.key = 'Default';
        default.type = 'Boolean';
        default.default = 0;
    options.default = default;
    
    options = sig.options(options,[1,varargin],'phy.pref');
    
    if options.default
        phy_pref.displayIndex = 1;
        phy_pref.dropFrame = 1;
    else
        if ~isnan(options.displayIndex)
            phy_pref.displayIndex = options.displayIndex;
        end
        if ~isnan(options.dropFrame)
            phy_pref.dropFrame = options.dropFrame;
        end
    end
end

p = phy_pref;