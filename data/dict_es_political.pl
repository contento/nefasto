% Spanish Political Profile Dictionary
:- encoding(utf8).

:- multifile word_bank/3.

% Political profile: argumentative, policy-focused, persuasive
% Nouns: positions, entities, institutions
word_bank(nouns, es_political, [
    senador, abogado, parlamento, legislador, política, enmienda, decreto,
    propuesta, facción, coalición, régimen, autoridad, consejo, asamblea,
    reforma, estatuto, convención, principio, doctrina, ideología,
    constituyente, votante, ciudadano, delegado, representante, ministro,
    tratado, alianza, disputa, campaña, elección, debate
]).

% Political verbs: persuade, debate, argue, propose, enact, oppose
word_bank(verbs, es_political, [
    persuadió, debatió, argumentó, propuso, promulgó, se opuso,
    abogó, desafió, reformó, cuestionó, declaró, proclamó,
    convocó, negoció, ratificó, objetó, afirmó, aseveró,
    disputó, hizo campaña, apeló, convenció, refutó, apoyó,
    influyó, decidió, gobernó, decretó, enmiendó, impugnó
]).

% Political adjectives: powerful, diplomatic, radical, conservative
word_bank(adjectives, es_political, [
    radical, conservador, moderado, progresista, tradicional,
    diplomático, pragmático, idealista, autoritario, dominante,
    influyente, controvertido, contencioso, divisivo, unificador,
    poderoso, débil, efectivo, inefectivo, estratégico, táctico,
    legítimo, ilegítimo, popular, impopular, estable, volátil
]).

% Political locations: parliament, capital, convention hall
word_bank(locations, es_political, [
    parlamento, senado, capital, cámara, tribunal, convención,
    asamblea, tribunales, cuartel general, ministerio, oficina, capitolio,
    distrito, región, circunscripción, territorio, jurisdicción, estado,
    foro, plaza, salón, edificio, recinto, plataforma
]).

% Political statements: policy positions, arguments
word_bank(statements_es_political, es_political, [
    'La ley debe servir a todos por igual',
    'La reforma requiere acciones audaces',
    'La tradición proporciona estabilidad',
    'La innovación exige coraje',
    'La autoridad debe ser cuestionada',
    'La unidad fortalece nuestra posición',
    'El pueblo exige representación',
    'El progreso viene del debate',
    'Los principios guían nuestras decisiones',
    'La justicia no puede ser postergada',
    'El cambio es inevitable',
    'El liderazgo requiere visión'
]).

% Political characters: leaders, activists
word_bank(characters, es_political, [
    Churchill, Roosevelt, Lincoln, Gandhi, Mandela, Jefferson,
    Cleopatra, Napoleón, Isabel, Catalina, Constantino, Augusto,
    Washington, Franklin, Adams, Madison, Hamilton, Jay,
    Thatcher, Kennedy, Eisenhower, Truman, Reagan, Carter
]).
