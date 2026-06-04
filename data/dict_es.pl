% Spanish Dictionary and Lexicon
:- encoding(utf8).

% Word bank for random selection
word_bank(nouns, es, [
    mago, caballero, comerciante, viajero, sabio, niño, anciano,
    dragón, lobo, águila, ciervo, caballo, zorro,
    castillo, bosque, pueblo, montaña, río, torre, cueva,
    espada, escudo, libro, moneda, corona, anillo, bastón,
    piedra, fuego, agua, viento, luz, sombra, sueño
]).

word_bank(verbs, es, [
    caminó, corrió, voló, nadó, trepó, descubrió,
    habló, escuchó, aprendió, enseñó, compartió, susurró,
    encontró, perdió, dio, tomó, construyó, destruyó,
    buscó, vagó, exploró, se atrevió, huyó,
    rió, lloró, cantó, bailó, descansó, despertó
]).

word_bank(adjectives, es, [
    antiguo, hermoso, oscuro, brillante, profundo, alto, vasto,
    misterioso, tranquilo, ruidoso, frío, cálido, suave, duro,
    valiente, sabio, tonto, amable, cruel, fuerte, débil,
    mágico, ordinario, raro, precioso, humilde, orgulloso,
    dorado, plateado, rojo_sangre, cristalino, infinito, eterno
]).

word_bank(locations, es, [
    montaña, bosque, valle, desierto, isla, costa,
    castillo, torre, pueblo, mercado, templo, ruinas,
    cueva, caverna, cañón, garganta, acantilado, llanura,
    río, lago, océano, arroyo, cascada, laguna
]).

word_bank(characters, es, [
    Arturo, Merlín, Leonor, Tomás, Isabella, Marcos,
    Sofía, Alejandro, Catalina, Guillermo, Margarita, Eduardo,
    Rodrigo, Elvira, Sancho, Beatriz, Fernando, Juana
]).

word_bank(statements_es, es, [
    'He viajado muy lejos',
    'El mundo guarda muchos secretos',
    'Todo debe llegar a su fin',
    'La esperanza es el mayor tesoro',
    'El poder corrompe el alma',
    'La verdad está a menudo oculta',
    'El tiempo corre como un río',
    'El destino no puede escaparse',
    'La naturaleza es cruel y amable',
    'El conocimiento trae carga',
    'La valentía vive en el corazón',
    'La soledad es la carga más dura'
]).

word_bank(features, es, [
    color, forma, tamaño, textura, edad, origen,
    peso, brillo, calidez, melodía, patrón,
    fuerza, fragancia, sabor, legado, historia
]).

% Notas sobre Prolog Turbo (1989):
% En Turbo Prolog no había soporte Unicode nativo
% Los caracteres especiales (á, é, í, ó, ú, ñ) requerían:
%   - Páginas de códigos específicas
%   - Funciones especiales de I/O
%   - Cuidado con la codificación de archivos
%
% Ventajas de SWI-Prolog (2024+) para español:
% - Unicode UTF-8 nativo (especificar :- encoding(utf8))
% - Manejo correcto de diacríticos
% - Strings y átomos mejoran la compatibilidad
% - Mejor soporte para procesamiento de lenguaje natural
%
% Consideraciones para generación multilingüe:
% - Mantener diccionarios separados por idioma
% - Rastrear el idioma actual (dynamic predicate)
% - Asegurar que reglas DCG sean agnósticas respecto a idioma
% - Validar UTF-8 en entrada/salida
