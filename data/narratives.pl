% Narrative Templates and Structures
:- encoding(utf8).

% Story templates
narrative_template(simple_story, [
    setup, complication, climax, resolution
]).

narrative_template(dialogue, [
    greeting, exchange1, exchange2, farewell
]).

narrative_template(description, [
    overall_impression, physical_features, emotional_quality, final_thought
]).

% Narrative beat definitions
beat(setup) :- write('A tale begins in a distant place.').
beat(complication) :- write('But then something changed.').
beat(climax) :- write('Everything came to a head.').
beat(resolution) :- write('And so the tale concludes.').

% Story structure patterns
% Hero's Journey simplified
heros_journey([
    'the call',
    'leaving home',
    'meeting allies',
    'facing trials',
    'the ordeal',
    'reward',
    'return'
]).

% Three act structure
three_act_structure([
    'act_one_exposition',
    'act_one_inciting_incident',
    'act_two_rising_action',
    'act_two_climax',
    'act_three_resolution',
    'act_three_denouement'
]).

% Dialogue patterns
dialogue_pattern(greeting) :- write('They met for the first time.').
dialogue_pattern(question) :- write('One asked something important.').
dialogue_pattern(revelation) :- write('Then came the truth.').
dialogue_pattern(farewell) :- write('And so they parted.').

% Description patterns
description_pattern(overview, '~w is a land of ~w and ~w.') :- !.
description_pattern(details, 'Its ~w are ~w, its ~w are ~w.') :- !.
description_pattern(emotion, 'To those who know it, ~w feels ~w.') :- !.

% Narrative conflict types (enable varied story generation)
conflict_type(person_vs_person).
conflict_type(person_vs_nature).
conflict_type(person_vs_self).
conflict_type(person_vs_society).
conflict_type(person_vs_fate).

% Resolution types
resolution_type(triumph, 'The hero prevailed at last.').
resolution_type(sacrifice, 'Someone had to give all.').
resolution_type(bittersweet, 'Victory came with a price.').
resolution_type(tragedy, 'Not all stories end well.').
resolution_type(mystery, 'Some questions remain unanswered.').

% Narrative mood/tone
mood(heroic, [brave, daring, noble, bold]).
mood(melancholic, [sad, lonely, wistful, sorrowful]).
mood(mysterious, [cryptic, hidden, shadowed, veiled]).
mood(whimsical, [playful, magical, unexpected, fantastical]).
mood(ominous, [dark, threatening, foreboding, sinister]).

% Turbo Prolog considerations (1989):
% Story generation would use basic recursion:
%   story(Narrative) :-
%       setup(S1),
%       complication(S2),
%       connect(S1, S2, Connected),
%       conclusion(C),
%       append(Connected, [C], Narrative).
%
% No findall/bagof, so you'd manually traverse solutions
% Assert/retract for tracking story state during generation
%
% Modern SWI-Prolog improvements:
% - Proper list handling (append, member, length)
% - findall/bagof/setof for collecting alternatives
% - Better string manipulation
% - Constraint solving (CLP) for ensuring narrative consistency
% - Tabling for caching narrative fragments
