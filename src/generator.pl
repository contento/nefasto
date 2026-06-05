% Discourse Generator using DCG
:- encoding(utf8).

% Generate a complete narrative
generate_narrative(simple_story, Lang, Narrative) :-
    retract_current_entities,
    phrase(story(Lang), Tokens),
    atomic_list_concat(Tokens, ' ', Narrative).

generate_narrative(dialogue, Lang, Narrative) :-
    retract_current_entities,
    phrase(dialogue(Lang), Tokens),
    atomic_list_concat(Tokens, ' ', Narrative).

generate_narrative(description, Lang, Narrative) :-
    retract_current_entities,
    phrase(description(Lang), Tokens),
    atomic_list_concat(Tokens, ' ', Narrative).

% --- DCG RULES ---

% Improved Story Structure: character-driven narrative with semantic coherence
story(Lang) --> setup(Lang, Char), complication(Lang, Char), resolution(Lang, Char).

% English setup: character arrives at location
setup(en, Char) -->
    [once], space,
    { random_select_word(characters, en, Char) },
    [Char], space, [arrived], space,
    location(en, Loc), ['.'],
    { record_entity(subject, Char),
      record_entity(location, Loc) }.

% Spanish setup: character arrives at location
setup(es, Char) -->
    ['Érase'], space, [una], space, [vez], space,
    { random_select_word(characters, es, Char) },
    [Char], space, [llegó], space,
    location(es, Loc), ['.'],
    { record_entity(subject, Char),
      record_entity(location, Loc) }.

% English complication: character takes meaningful action on object
complication(en, Char) -->
    [then], space, [Char], space,
    action(en, Action), space,
    [the], space, noun(en, Obj), ['.'],
    { record_entity(action, Action),
      record_entity(object, Obj) }.

% Spanish complication: character takes meaningful action on object
complication(es, Char) -->
    [luego], space, [Char], space,
    action(es, Action), space,
    [el], space, noun(es, Obj), ['.'],
    { record_entity(action, Action),
      record_entity(object, Obj) }.

% English resolution: character completes narrative arc
resolution(en, Char) -->
    [finally], space, [Char], space,
    action(en, Action), space,
    [with], space,
    adjective(en, Quality), ['.'],
    { record_entity(resolution, Action) }.

% Spanish resolution: character completes narrative arc
resolution(es, Char) -->
    [finalmente], space, [Char], space,
    action(es, Action), space,
    [con], space,
    adjective(es, Quality), ['.'],
    { record_entity(resolution, Action) }.

% Dialogue: speaker1 says something, speaker2 replies
dialogue(Lang) -->
    speaker(Lang, S1), dialogue_verb(Lang), space,
    quote(Lang, _), nl, nl,
    speaker(Lang, S2), dialogue_verb(Lang), space,
    quote(Lang, _),
    { record_entity(speaker, S1),
      record_entity(speaker, S2) }.

description(Lang) -->
    description_opening(Lang), space, adjective(Lang, _), space,
    noun(Lang, Noun), ['.'], space,
    description_possessive(Lang), space, adjective(Lang, _), space,
    feature(Lang, _), ['.'],
    { record_entity(noun, Noun) }.

% Dialogue verbs (language-aware)
dialogue_verb(en) --> [said, ':'].
dialogue_verb(es) --> [dijo, ':'].

% Description openings (language-aware)
description_opening(en) --> ['There', 'is'].
description_opening(es) --> ['Hay'].

% Description possessives (language-aware)
description_possessive(en) --> ['Its'].
description_possessive(es) --> ['Su'].

% --- GRAMMAR ELEMENTS ---

% Helpers
space --> [' '].
nl --> ['\n'].

% Subject selection (with state tracking)
subject(Lang, Subject) -->
    noun(Lang, Subject).

% Action verbs
action(en, Action) -->
    { random_select_word(verbs, en, Action) },
    [Action].

action(es, Action) -->
    { random_select_word(verbs, es, Action) },
    [Action].

% Objects
object(Lang, Object) -->
    [the], space, noun(Lang, Object).

% Locations
location(en, Loc) -->
    { random_select_word(locations, en, Loc) },
    [in, the, Loc].

location(es, Loc) -->
    { random_select_word(locations, es, Loc) },
    [en], space, [el, Loc].

% Speakers (for dialogue)
speaker(Lang, Speaker) -->
    { random_select_word(characters, Lang, Speaker) },
    [Speaker].

% Quotes
quote(en, _) -->
    ['"'],
    { random_select_word(statements_en, en, Statement) },
    [Statement],
    ['"'].

quote(es, _) -->
    ['"'],
    { random_select_word(statements_es, es, Statement) },
    [Statement],
    ['"'].

% Adjectives
adjective(Lang, Adj) -->
    { random_select_word(adjectives, Lang, Adj) },
    [Adj].

% Features
feature(en, _) -->
    { random_select_word(features, en, Feature) },
    [Feature].

feature(es, _) -->
    { random_select_word(features, es, Feature) },
    [Feature].

% Opening words - these come from phrase execution context
% They get instantiated when needed

% Punctuation helpers
opening(Lang, Opening) -->
    { opening_phrase(Lang, Opening) },
    [Opening].

opening_phrase(en, 'Once upon a time').
opening_phrase(es, 'Érase una vez').

next_phrase(en, 'Then').
next_phrase(es, 'Luego').

final_phrase(en, 'Finally').
final_phrase(es, 'Finalmente').

% Copula (to be)
copula(en) --> [was].
copula(es) --> [fue].

% Generic noun handler
noun(Lang, Noun) -->
    { random_select_word(nouns, Lang, Noun) },
    [Noun].

% --- UTILITIES FOR NARRATIVE COHERENCE ---

% Track entities we've mentioned
:- dynamic(mentioned_entity/2).

record_entity(Type, Entity) :-
    assertz(mentioned_entity(Type, Entity)).

retract_current_entities :-
    retractall(mentioned_entity(_, _)).

% Get most recent entity of a type (for anaphora)
get_last_entity(Type, Entity) :-
    mentioned_entity(Type, Entity),
    \+ (mentioned_entity(Type, E2), E2 \== Entity).

% Check consistency: don't repeat same entity too soon
can_use_entity(Entity) :-
    \+ mentioned_entity(_, Entity).

can_use_entity(Entity) :-
    mentioned_entity(_, Entity),
    count_mentions(Entity, Count),
    Count < 3.

count_mentions(Entity, Count) :-
    aggregate_all(count, mentioned_entity(_, Entity), Count).
