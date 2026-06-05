% Dictionary Loader - loads word banks from YAML files
:- encoding(utf8).

:- multifile word_bank/3.
:- dynamic word_bank/3.
:- dynamic dict_loaded/1.

% Load all dictionaries for a language and profile
load_dictionaries(Lang, Profile) :-
    dict_loaded(Lang-Profile), !.

load_dictionaries(Lang, Profile) :-
    atomic_list_concat([Lang, '_', Profile], DictName),
    load_dictionary_file(DictName, Lang, Profile),
    assertz(dict_loaded(Lang-Profile)).

% Load a single dictionary file from YAML
load_dictionary_file(DictName, Lang, Profile) :-
    atomic_list_concat(['data/dictionaries/', DictName, '.yaml'], FilePath),
    (exists_file(FilePath) ->
        load_yaml_dictionary(FilePath, Lang, Profile)
    ;
        true
    ).

% Parse YAML and extract word banks
load_yaml_dictionary(FilePath, Lang, Profile) :-
    read_file_to_string(FilePath, Content, []),
    split_string(Content, "\n", "", Lines),
    parse_yaml(Lines, Lang, Profile).

% Parse YAML: iterate through lines and accumulate by category
parse_yaml(Lines, Lang, Profile) :-
    atom_concat(Lang, '_', Prefix),
    atom_concat(Prefix, Profile, LangProfile),
    parse_yaml_lines(Lines, LangProfile, undefined, []).

% End of file
parse_yaml_lines([], _, _, _).

% Category line (word_type:)
parse_yaml_lines([Line | Rest], LangProfile, PrevCategory, PrevWords) :-
    atom_string(Line, LineStr),
    atom_concat(Category, ':', LineStr),
    \+ atom_concat('  ', _, LineStr), !,
    % Save previous category first
    (PrevCategory \= undefined, PrevWords \= [] ->
        reverse(PrevWords, Words),
        assertz(word_bank(PrevCategory, LangProfile, Words))
    ;
        true
    ),
    % Continue with new category
    parse_yaml_lines(Rest, LangProfile, Category, []).

% Word item line (  - word)
parse_yaml_lines([Line | Rest], LangProfile, Category, Words) :-
    atom_string(Line, LineStr),
    atom_concat('  - ', Word, LineStr), !,
    parse_yaml_lines(Rest, LangProfile, Category, [Word | Words]).

% Skip comments and empty lines
parse_yaml_lines([Line | Rest], LangProfile, Category, Words) :-
    atom_string(Line, LineStr),
    (LineStr = '' ; atom_concat('#', _, LineStr)), !,
    parse_yaml_lines(Rest, LangProfile, Category, Words).

% Skip any other lines
parse_yaml_lines([_ | Rest], LangProfile, Category, Words) :-
    parse_yaml_lines(Rest, LangProfile, Category, Words).

% Helper: check if file exists
exists_file(Path) :-
    catch((open(Path, read, Stream), close(Stream)), _, fail).
