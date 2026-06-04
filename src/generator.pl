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

% Simple Story Structure: setup -> complication -> resolution
story(Lang) --> setup(Lang), complication(Lang), resolution(Lang).

% English setup
setup(en) -->
    [once], space, subject(en, Subj), space,
    copula(en), space, location(en, Loc), ['.'],
    { record_entity(subject, Subj),
      record_entity(location, Loc) }.

% Spanish setup
setup(es) -->
    ['Érase'], space, subject(es, Subj), space,
    copula(es), space, location(es, Loc), ['.'],
    { record_entity(subject, Subj),
      record_entity(location, Loc) }.

% English complication
complication(en) -->
    [then], space, subject(en, Subj), space,
    action(en, Action), space, object(en, Obj), ['.'],
    { record_entity(action, Action),
      record_entity(object, Obj) }.

% Spanish complication
complication(es) -->
    [luego], space, subject(es, Subj), space,
    action(es, Action), space, object(es, Obj), ['.'],
    { record_entity(action, Action),
      record_entity(object, Obj) }.

% English resolution
resolution(en) -->
    [finally], space, subject(en, Subj), space,
    action(en, _), ['.'].

% Spanish resolution
resolution(es) -->
    [finalmente], space, subject(es, Subj), space,
    action(es, _), ['.'].

% Dialogue: speaker1 says something, speaker2 replies
dialogue(Lang) -->
    speaker(Lang, S1), [said, ':'], space,
    quote(Lang, Q1), nl, nl,
    speaker(Lang, S2), [said, ':'], space,
    quote(Lang, Q2),
    { record_entity(speaker, S1),
      record_entity(speaker, S2) }.

description(Lang) -->
    [There, is], space, adjective(Lang, Adj), space,
    noun(Lang, Noun), ['.'], space,
    [Its], space, adjective(Lang, Adj2), space,
    feature(Lang, Feature), ['.'],
    { record_entity(noun, Noun) }.

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
quote(en, Quote) -->
    ['"'],
    { random_select_word(statements_en, en, Statement) },
    [Statement],
    ['"'].

quote(es, Quote) -->
    ['"'],
    { random_select_word(statements_es, es, Statement) },
    [Statement],
    ['"'].

% Adjectives
adjective(Lang, Adj) -->
    { random_select_word(adjectives, Lang, Adj) },
    [Adj].

% Features
feature(en, Feature) -->
    { random_select_word(features, en, Feature) },
    [Feature].

feature(es, Feature) -->
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
