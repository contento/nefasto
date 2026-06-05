% Random utilities for discourse generation
:- encoding(utf8).

% Select a random word from a category (profile-aware)
% Profile-specific word banks only, no fallback
random_select_word(Category, Lang, Word) :-
    current_profile(Profile),
    atom_concat(Lang, '_', LangProfilePrefix),
    atom_concat(LangProfilePrefix, Profile, LangProfile),
    word_bank(Category, LangProfile, Words),
    length(Words, Len),
    Len > 0, !,
    random_between(1, Len, Idx),
    nth1(Idx, Words, Word).

random_select_word(Category, Lang, default) :-
    current_profile(Profile),
    format('ERROR: No words for category "~w" in profile "~w" (language: ~w)~n', [Category, Profile, Lang]),
    fail.

