% Configuration loader - supports JSON, YAML, TOML
:- encoding(utf8).

:- dynamic(config/2).

% Load configuration from file
load_config(File) :-
    file_extension(File, Ext),
    load_config_by_type(Ext, File).

file_extension(File, Ext) :-
    atom_string(File, FileStr),
    string_concat(_, Dot, FileStr),
    string_concat('.', Ext, Dot), !.
file_extension(_, 'json').

% JSON loader (basic)
load_config_by_type('json', File) :-
    read_file_to_string(File, Content, []),
    parse_json(Content, Config),
    store_config(Config).

% YAML loader (basic - simplified)
load_config_by_type('yaml', File) :-
    read_file_to_string(File, Content, []),
    parse_yaml(Content, Config),
    store_config(Config).

% TOML loader (basic - simplified)
load_config_by_type('toml', File) :-
    read_file_to_string(File, Content, []),
    parse_toml(Content, Config),
    store_config(Config).

% Fallback to JSON
load_config_by_type(_, File) :-
    load_config_by_type('json', File).

% Store loaded config
store_config(Config) :-
    retractall(config(_, _)),
    asserta_config(Config).

asserta_config([]) :- !.
asserta_config([Key-Value | Rest]) :-
    assertz(config(Key, Value)),
    asserta_config(Rest).

% --- JSON PARSER (simplified) ---
% For production, use library(http/json) or library(json)
parse_json(JsonStr, Config) :-
    % Extract key: "value" pairs from JSON (basic implementation)
    extract_json_pairs(JsonStr, Config).

extract_json_pairs(JsonStr, Pairs) :-
    split_string(JsonStr, ",", "\n\t{} ", Items),
    maplist(extract_json_pair, Items, FilteredPairs),
    exclude(==(empty), FilteredPairs, Pairs).

extract_json_pair(Item, Key-Value) :-
    split_string(Item, ":", " \"", [KeyStr, ValueStr]),
    atom_string(Key, KeyStr),
    atom_string(Value, ValueStr), !.
extract_json_pair(_, empty).

% --- YAML PARSER (simplified) ---
parse_yaml(YamlStr, Config) :-
    split_string(YamlStr, "\n", "", Lines),
    parse_yaml_lines(Lines, Config).

parse_yaml_lines([], []) :- !.
parse_yaml_lines([Line | Rest], [Key-Value | ConfigRest]) :-
    atom_string(Line, LineStr),
    split_string(LineStr, ":", "", [KeyStr, ValueStr]),
    atom_string(Key, KeyStr),
    atom_string(Value, ValueStr),
    parse_yaml_lines(Rest, ConfigRest).
parse_yaml_lines([_ | Rest], Config) :-
    parse_yaml_lines(Rest, Config).

% --- TOML PARSER (simplified) ---
parse_toml(TomlStr, Config) :-
    split_string(TomlStr, "\n", "", Lines),
    parse_toml_lines(Lines, Config).

parse_toml_lines([], []) :- !.
parse_toml_lines([Line | Rest], [Key-Value | ConfigRest]) :-
    atom_string(Line, LineStr),
    \+ atom_string('', LineStr),
    split_string(LineStr, "=", " ", [KeyStr, ValueStr]),
    atom_string(Key, KeyStr),
    atom_string(Value, ValueStr),
    parse_toml_lines(Rest, ConfigRest).
parse_toml_lines([_ | Rest], Config) :-
    parse_toml_lines(Rest, Config).

% Get config value
get_config(Key, Value) :-
    config(Key, Value), !.

get_config(language, en).
get_config(profile, political).
get_config(seed, 42).
get_config(pacing, medium).

% Default configurations
default_config_json :-
    write('{\n'),
    write('  "language": "en",\n'),
    write('  "seed": 42,\n'),
    write('  "pacing": "medium",\n'),
    write('  "narrative_type": "simple_story"\n'),
    write('}\n').

default_config_yaml :-
    write('language: en\n'),
    write('seed: 42\n'),
    write('pacing: medium\n'),
    write('narrative_type: simple_story\n').

default_config_toml :-
    write('language = "en"\n'),
    write('seed = 42\n'),
    write('pacing = "medium"\n'),
    write('narrative_type = "simple_story"\n').

% Prolog-specific note:
% Turbo Prolog (1989) had no file I/O beyond basic open/read/write
% Modern SWI-Prolog has full JSON support via library(http/json)
% For production, replace parse_json/parse_yaml/parse_toml with:
%
% :- use_module(library(http/json)).
% :- use_module(library(yaml)).  % if available
%
% Then use json_read_dict/json_write_dict instead of these stubs.
