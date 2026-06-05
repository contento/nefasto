% Discourse Profiles - mutually exclusive narrative modes
:- encoding(utf8).

:- dynamic(current_profile/1).

current_profile(political).

% Profile registry
% Each profile has: name, description, word_bank modifier
profile(political, 'Political discourse - argumentative, persuasive, policy-focused').
profile(sales, 'Sales pitch - action-oriented, benefit-focused, persuasive').

% Validate profile
is_valid_profile(Profile) :-
    profile(Profile, _).

% Set profile (with validation)
set_profile(NewProfile) :-
    is_valid_profile(NewProfile), !,
    retractall(current_profile(_)),
    assertz(current_profile(NewProfile)).

set_profile(Invalid) :-
    format('ERROR: Unknown profile "~w". Valid profiles: political, sales~n', [Invalid]),
    fail.

% Get current profile
get_profile(Profile) :-
    current_profile(Profile).

% TODO: Future blending capability
% blend_profiles([Profile1, Profile2], BlendedProfile) :-
%     Enable mixing profiles with weighted influence
%     set_profile(BlendedProfile).

% List all profiles
list_profiles :-
    findall(Name-Desc, profile(Name, Desc), Profiles),
    format('Available discourse profiles:~n'),
    forall(member(Name-Desc, Profiles),
           format('  - ~w: ~w~n', [Name, Desc])).

% Profile-specific narrative structure (future extension point)
% narrative_structure(Profile, StructureType) :- ...
