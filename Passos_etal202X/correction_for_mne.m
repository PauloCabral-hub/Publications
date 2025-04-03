% DESCRIPTION: EEGlab can exchange fields code and type of EEG.event and
% EEG.urevent. This routine checks if this is the case and corrects it.

% Checking
events = EEG.event;

% Checking the types

set_types = {};
b = 1;
for a = 1:length(events)
    add_type = 1;
    cur_type = events(a).type;
    if ~isempty(set_types)
       for c = 1:length(set_types)
          alt_type = set_types{c,1};
          if isequal(cur_type, alt_type)
             add_type = 0;
          end    
       end
    end
    if add_type == 1
       set_types{b,1} = cur_type;
       b = b+1;
    end
end

% Checking the codes

set_codes = {};
b = 1;
for a = 1:length(events)
    add_code = 1;
    cur_code = events(a).code;
    if ~isempty(set_codes)
       for c = 1:length(set_codes)
          alt_code = set_codes{c,1};
          if isequal(cur_code, alt_code)
             add_code = 0;
          end    
       end
    end
    if add_code == 1
       set_codes{b,1} = cur_code;
       b = b+1;
    end
end

% Switching in case of exchange

if length(set_types) < length(set_codes)
   disp('Candidate to correction')
   for a = 1:length(EEG.event)
      aux = EEG.event(a).code;
      uraux = aux;
      EEG.event(a).code = EEG.event(a).type;
      EEG.urevent(a).code = EEG.urevent(a).type;
      EEG.event(a).type = aux;
      EEG.urevent(a).type = uraux;
   end
else 
   disp('No correction is needed')
end
