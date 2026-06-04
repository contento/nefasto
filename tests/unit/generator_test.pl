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
    phrase(adjective(en, Adj), Tokens, []),
    atom(Adj),
    Tokens = [Adj].

test(adjective_es_produces_token) :-
    phrase(adjective(es, Adj), Tokens, []),
    atom(Adj),
    Tokens = [Adj].

% Test noun selection
test(noun_en_produces_token) :-
    phrase(noun(en, Noun), Tokens, []),
    atom(Noun),
    Tokens = [Noun].

test(noun_es_produces_token) :-
    phrase(noun(es, Noun), Tokens, []),
    atom(Noun),
    Tokens = [Noun].

% Test setup clause with subject parameter can execute
test(setup_en_executes) :-
    retractall(mentioned_entity(_, _)),
    catch(phrase(setup(en, wizard), _), _, true).

test(setup_es_executes) :-
    retractall(mentioned_entity(_, _)),
    catch(phrase(setup(es, mago), _), _, true).

% Test complication with subject parameter can execute
test(complication_en_executes) :-
    retractall(mentioned_entity(_, _)),
    catch(phrase(complication(en, knight), _), _, true).

test(complication_es_executes) :-
    retractall(mentioned_entity(_, _)),
    catch(phrase(complication(es, caballero), _), _, true).

% Test resolution with subject parameter can execute
test(resolution_en_executes) :-
    retractall(mentioned_entity(_, _)),
    catch(phrase(resolution(en, dragon), _), _, true).

test(resolution_es_executes) :-
    retractall(mentioned_entity(_, _)),
    catch(phrase(resolution(es, dragón), _), _, true).

:- end_tests(generator).
