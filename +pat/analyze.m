% Copyright (C) 2022, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function analyze(inputSequence)

options.fuserepeat = false;

% Definition of the parametrical space. Here just one dimension.
ps = seq.paramstruct('mystruct',{'dimension'},1);
dimension = seq.paramtype('dimension');
ps = ps.setfield('dimension',dimension);

% Creating the root of the pattern tree
root = pat.pattern([],[],[],ps);

% Creating the "occurrence" of the root. All pattern occurrences will
% extend from that "root occurrence".
occ0 = root.occurrence([],[]);

% The sequence progressively created, starts empty
currentSequence = seq.Sequence;

previous = [];
for s = inputSequence
    % Each event successively considered in the sequence
    s

    % The parametrical description of the new event
    p = ps.type2val; % Defined from the parametrical space ps
    % ... by associating a value to each parameter (here just one, the
    % "dimension")
    p = p.setfield('dimension',seq.paramval(ps.getfield('dimension'),s));

    % The event is then instantiated as a pat.event object
    event = pat.event(currentSequence,p);

    % ... integrated into the sequence under creation.
    currentSequence = currentSequence.integrate(event);

    % Now the two core mechanisms for pattern analysis:
    if ~isempty(previous)
        % First trying to extent any pattern occurrence ending at the
        % previous event
        previous.syntagm(event,root,1,options);
        % Calling pat.event.syntagm which itself calls pat.syntagm
        % Check pat.syntagm to see how this works.
        % In particular, it looks at all pattern occurrence ending at
        % previous event, and tries to extend these occurrence by calling
        % pat.occurrence.memorize
    end

    % Then checking if the new event can be the start of a new pattern
    % occurrence (i.e., by extending the "root occurrence" occ0)
    occ0.memorize(event,root,[],[],1);
    % And here also, it consists in calling pat.occurrence.memorize, where
    % the occurrence to extend is the "root occurrence".
    
    previous = event;
end