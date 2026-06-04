% Unit tests for generator.pl DCG rules
:- use_module(library(plunit)).

:- begin_tests(generator).

% Test basic DCG helpers
test(space_rule) :-
    phrase(space, [' ']).

test(space_rule_empty, [fail]) :-
    phrase(space, []).

test(copula_en) :-
    phrase(copula(en), [was]).

test(copula_es) :-
    phrase(copula(es), [fue]).

% Test language-aware dialogue verbs
test(dialogue_verb_en) :-
    phrase(dialogue_verb(en), [said, ':']).

test(dialogue_verb_es) :-
    phrase(dialogue_verb(es), [dijo, ':']).

% Test language-aware description opening
test(description_opening_en) :-
    phrase(description_opening(en), ['There', 'is']).

test(description_opening_es) :-
    phrase(description_opening(es), ['Hay']).

% Test language-aware description possessive
test(description_possessive_en) :-
    phrase(description_possessive(en), ['Its']).

test(description_possessive_es) :-
    phrase(description_possessive(es), ['Su']).

% Test adjective selection (produces tokens)
test(adjective_en_produces_token) :-
    phrase(adjective(en, Adj), Tokens),
    atom(Adj),
    Tokens = [Adj].

test(adjective_es_produces_token) :-
    phrase(adjective(es, Adj), Tokens),
    atom(Adj),
    Tokens = [Adj].

% Test noun selection
test(noun_en_produces_token) :-
    phrase(noun(en, Noun), Tokens),
    atom(Noun),
    Tokens = [Noun].

test(noun_es_produces_token) :-
    phrase(noun(es, Noun), Tokens),
    atom(Noun),
    Tokens = [Noun].

% Test setup clause with subject parameter
test(setup_en_with_subject) :-
    retractall(mentioned_entity(_, _)),
    phrase(setup(en, wizard), Tokens),
    length(Tokens, Len),
    Len > 0,
    member(wizard, Tokens).

test(setup_es_with_subject) :-
    retractall(mentioned_entity(_, _)),
    phrase(setup(es, mago), Tokens),
    length(Tokens, Len),
    Len > 0,
    member(mago, Tokens).

% Test that setup records entities
test(setup_records_entity) :-
    retractall(mentioned_entity(_, _)),
    phrase(setup(en, wizard), _),
    mentioned_entity(subject, wizard).

% Test complication with subject parameter
test(complication_en_with_subject) :-
    retractall(mentioned_entity(_, _)),
    phrase(complication(en, knight), Tokens),
    length(Tokens, Len),
    Len > 0,
    member(knight, Tokens).

test(complication_es_with_subject) :-
    retractall(mentioned_entity(_, _)),
    phrase(complication(es, caballero), Tokens),
    length(Tokens, Len),
    Len > 0,
    member(caballero, Tokens).

% Test resolution with subject parameter
test(resolution_en_with_subject) :-
    retractall(mentioned_entity(_, _)),
    phrase(resolution(en, dragon), Tokens),
    length(Tokens, Len),
    Len > 0,
    member(dragon, Tokens).

test(resolution_es_with_subject) :-
    retractall(mentioned_entity(_, _)),
    phrase(resolution(es, dragón), Tokens),
    length(Tokens, Len),
    Len > 0,
    member(dragón, Tokens).

:- end_tests(generator).
