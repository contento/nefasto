# Generador de Discursos en Prolog - Wiki en Español

*Un generador de narrativas puro en Prolog que revive técnicas de Turbo Prolog de 1989 con SWI-Prolog moderno. Diseñado para compatibilidad con bóvedas de Obsidian.*

---

## Tabla de Contenidos

- [Descripción General](#descripción-general)
- [Primeros Pasos](#primeros-pasos)
- [Conceptos Básicos](#conceptos-básicos)
- [DCG y Gramática](#dcg-y-gramática)
- [Bancos de Palabras y Diccionarios](#bancos-de-palabras-y-diccionarios)
- [Ontología y Coherencia](#ontología-y-coherencia)
- [Seguimiento de Estado](#seguimiento-de-estado)
- [Configuración](#configuración)
- [Uso de la TUI](#uso-de-la-tui)
- [Ejemplos](#ejemplos)
- [Solución de Problemas](#solución-de-problemas)
- [Historia de Turbo Prolog](#historia-de-turbo-prolog)

---

## Descripción General

### ¿Qué Problema Resuelve?

La generación de narrativas tradicional depende de:
- Modelos de lenguaje estadísticos (cadenas de Markov, n-gramas)
- Modelos de lenguaje neurales (transformadores, LLMs)
- Plantillas de historias escritas a mano

Este proyecto pregunta: **¿Y si solo usáramos lógica pura?**

Sin redes neuronales. Sin aprendizaje automático. Sin API externas. Solo la unificación, retroceso y coincidencia de patrones de Prolog—las mismas técnicas disponibles en el Turbo Prolog de 1989.

### Características Clave

- **Lógica Pura**: Solo Prolog. Sin dependencias fuera de SWI-Prolog.
- **Salida Coherente**: Las ontologías y el seguimiento de estado previenen contradicciones.
- **Reproducible**: La misma semilla produce la misma narrativa cada vez.
- **Transparente**: Rastrea cada decisión, desde la elección de palabras hasta la estructura de oraciones.
- **Extensible**: Agrega palabras a diccionarios, nuevas reglas a la gramática, nuevas plantillas.
- **Bilingüe**: Inglés y español desde el principio.
- **Multiplataforma**: Funciona en Linux, macOS, Windows.

### Filosofía de Diseño

**Simplicidad sobre Sofisticación**

- Selección aleatoria de palabras, no predicción de n-gramas
- Reglas escritas a mano, no patrones aprendidos
- Diccionarios pequeños, crecidos intencionalmente
- Plantillas narrativas básicas, entendidas completamente

Este enfoque sacrifica fluidez bruta por claridad, reproducibilidad y valor educativo.

---

## Primeros Pasos

### Instalación

```bash
# 1. Instalar SWI-Prolog
# macOS: brew install swi-prolog
# Linux: sudo apt install swi-prolog
# Windows: Descargar de swi-prolog.org

# 2. Clonar o extraer este repositorio
cd prolog-discourse-gen

# 3. Ejecutar el menú interactivo
swipl -l src/main.pl
```

### Primer Uso

```bash
# Generar una historia aleatoria en inglés
swipl -l src/main.pl -- --lang en

# Generar una historia en español con semilla fija
swipl -l src/main.pl -- --lang es --seed 42

# Cargar configuración personalizada
swipl -l src/main.pl -- --config config/default.yaml
```

### Flujo de Trabajo Típico

1. Iniciar TUI: `swipl -l src/main.pl`
2. Seleccionar "Generar Discurso"
3. Elegir tipo de narrativa (Historia, Diálogo, Descripción)
4. Leer la salida
5. Ajustar idioma/semilla en configuración
6. Repetir

---

## Conceptos Básicos

### 1. DCG (Gramática de Cláusulas Definidas)

**Qué es**: La notación integrada de Prolog para escribir gramáticas.

**Cómo funciona**:
```prolog
historia(Lang) --> introducción(Lang), conflicto(Lang), resolución(Lang).
introducción(Lang) --> ['Érase una vez'], sujeto(Lang, S), cópula(Lang), ubicación(Lang, L), ['.'].
```

**Por qué la usamos**: Sintaxis natural para describir la estructura del lenguaje. Prolog maneja el análisis y retroceso automáticamente.

**Función clave**: `phrase/3`
```prolog
?- phrase(historia(es), Fichas).
% Genera: ['Érase una vez', mago, fue, bosque, ...]
```

### 2. Bancos de Palabras (Lexicones)

**Qué son**: Listas de palabras organizadas por categoría e idioma.

```prolog
word_bank(sustantivos, es, [mago, caballero, dragón, bosque, castillo, ...]).
word_bank(verbos, es, [caminó, voló, descubrió, habló, ...]).
word_bank(adjetivos, es, [antiguo, brillante, misterioso, ...]).
```

**Por qué se organizan así**: Hace la generación determinista y extensible. Agrega palabras editando listas.

**Selección aleatoria**:
```prolog
random_select_word(sustantivos, es, Palabra).  % Elige sustantivo aleatorio en español
```

### 3. Ontología (Reglas Semánticas)

**Qué es**: Definiciones de qué entidades pueden hacer y dónde.

```prolog
puede_realizar(personaje, hablar).
puede_realizar(criatura, deambular).
actividad_permite_ubicación(bosque, [deambular, cazar, encontrar]).
```

**Por qué importa**: Previene generar "el bosque habló" o "el personaje deambulaba como una bestia."

**Cómo la generación la usa**:
```prolog
% Antes de elegir una acción para el sujeto, verifica: puede_realizar(Sujeto, Acción)
```

### 4. Seguimiento de Estado (Memoria de Entidad)

**Qué hace**: Recuerda qué se ha dicho en la narrativa actual.

```prolog
registrar_entidad(sujeto, mago).         % Recordar: se mencionó al mago
obtener_última_entidad(sujeto, E).       % Obtener el sujeto más reciente
puede_usar_entidad(mago).                % Verificar: ¿podemos mencionar al mago de nuevo?
```

**Por qué importa**: Permite pronombres ("el mago... él...") y previene repetición.

### 5. Configuración

**Formatos soportados**: JSON, YAML, TOML

```json
{ "idioma": "es", "semilla": 42, "ritmo": "medio" }
```

```yaml
idioma: es
semilla: 42
ritmo: medio
```

```toml
[núcleo]
idioma = "es"
semilla = 42
```

**Por qué flexible**: Experimentos reproducibles, flujos de trabajo en equipo, automatización.

---

## DCG y Gramática

### Curso Acelerado de Sintaxis DCG

DCG es azúcar sintáctico para listas de diferencias. Esto:
```prolog
sustantivo --> [gato].
```

Es equivalente a:
```prolog
sustantivo(S0, S) :- S0 = [gato | S].
```

### Patrones Comunes

#### Terminal (palabras literales)
```prolog
oración --> [el], sustantivo, [corrió].
```
Salida: `[el, gato, corrió]` (si sustantivo = `[gato]`)

#### No-terminal (referencia a otra regla)
```prolog
oración --> sujeto, verbo, objeto.
sujeto --> [el], sustantivo.
```

#### Recursión
```prolog
lista --> [].                % Caso base
lista --> elemento, lista.   % Caso recursivo
```

#### Parametrización
```prolog
sustantivo(Lang) --> sustantivo_en(Lang) | sustantivo_es(Lang).
sustantivo_en(en) --> [cat] | [dog] | [mouse].
sustantivo_es(es) --> [gato] | [perro] | [ratón].
```

### Estructura de Nuestra Gramática

```
historia(Lang)
  ├── introducción(Lang)
  ├── conflicto(Lang)
  └── resolución(Lang)

introducción(Lang)
  ├── ['Érase una vez']
  ├── sujeto(Lang, S)
  ├── cópula(Lang)
  ├── ubicación(Lang, L)
  └── ['.']
```

### Phrase/3: La Función Mágica

```prolog
?- phrase(historia(es), Fichas).
Fichas = ['Érase una vez', mago, fue, bosque, Luego, mago, encontró, tesoro, ...]

?- phrase(historia(en), Fichas).
Fichas = [Once, wizard, was, forest, Then, wizard, found, treasure, ...]
```

Aquí es donde las reglas de gramática → salida real.

### Depuración de DCG

Si phrase/3 falla:
1. Verifica que word_bank/3 esté definido
2. Verifica que sustantivo/1 referencie palabras reales
3. Agrega traza: `trace.` luego `phrase(...)`
4. Busca categorías faltantes o mal escritas

---

## Bancos de Palabras y Diccionarios

### Estructura

```prolog
% archivo: data/dict_es.pl
word_bank(Categoría, Idioma, ListaPalabras).

word_bank(sustantivos, es, [mago, caballero, dragón, bosque, ...]).
word_bank(verbos, es, [caminó, voló, descubrió, ...]).
word_bank(adjetivos, es, [antiguo, brillante, misterioso, ...]).
```

### Categorías Definidas

| Categoría | Propósito | Ejemplo |
|-----------|----------|---------|
| sustantivos | Sujetos y objetos | mago, castillo, dragón |
| verbos | Acciones | caminó, descubrió, habló |
| adjetivos | Descripciones | antiguo, brillante, mágico |
| ubicaciones | Lugares | bosque, montaña, pueblo |
| personajes | Entidades nombradas | Arturo, Merlín, Leonor |
| características | Propiedades | color, textura, edad |

### Agregar Palabras

**Para inglés** (edita `data/dict_en.pl`):
```prolog
word_bank(nouns, en, [
    % Existentes...
    wizard, knight, dragon, forest, castle,
    % Nuevos...
    merchant, village, tower
]).
```

**Para español** (edita `data/dict_es.pl`):
```prolog
word_bank(sustantivos, es, [
    % Existentes...
    mago, caballero, dragón, bosque, castillo,
    % Nuevos...
    comerciante, pueblo, torre
]).
```

**Siempre actualiza ambos idiomas juntos.**

### Algoritmo de Selección de Palabras

```prolog
random_select_word(Categoría, Lang, Palabra) :-
    word_bank(Categoría, Lang, Palabras),
    length(Palabras, Len),
    random_between(1, Len, Idx),
    nth1(Idx, Palabras, Palabra).
```

Esto elige aleatoriamente con distribución uniforme (cada palabra igual de probable).

### Directrices de Tamaño

- **Mínimo**: 30 palabras por categoría
- **Bueno**: 100+ palabras por categoría
- **Excelente**: 300+ palabras por categoría

Estado actual: ~40 por categoría (intencionalmente pequeño para empezar).

---

## Ontología y Coherencia

### ¿Qué es la Ontología?

Una ontología define:
- Qué cosas existen (entidades)
- Qué propiedades tienen
- Qué acciones pueden realizar
- Qué restricciones aplican

### Nuestras Ontologías

#### Compatibilidad Actor-Acción
```prolog
puede_realizar(personaje, hablar).
puede_realizar(personaje, caminar).
puede_realizar(criatura, deambular).
puede_realizar(criatura, cazar).
puede_realizar(objeto, caer).
```

**Uso**: Antes de generar "X verbó", verifica `puede_realizar(X, verbo)`.

#### Compatibilidad Ubicación-Actividad
```prolog
actividad_permite_ubicación(castillo, [vivió, gobernó, defendió]).
actividad_permite_ubicación(bosque, [deambulaban, cazaban, encontraban]).
actividad_permite_ubicación(pueblo, [vivió, habló, visitó]).
```

**Uso**: Si la ubicación es bosque, solo genera acciones de [deambulaban, cazaban, encontraban].

#### Roles Semánticos
```prolog
rol_semántico(personaje, agente).      % Puede hacer cosas
rol_semántico(criatura, agente).       % Puede hacer cosas
rol_semántico(objeto, paciente).       % Las cosas se hacen a ello
rol_semántico(ubicación, ubicación).   % Dónde suceden las cosas
```

#### Causalidad Narrativa
```prolog
causa_consecuencia(encontró_tesoro, [feliz, rico, famoso]).
causa_consecuencia(perdió_objeto, [triste, desesperado, buscando]).
```

**Uso**: Rastrea qué acción sucedió, agrega consecuencias a la narrativa.

### Agregar Ontologías

1. **Identificar restricción**: "El personaje puede X pero la criatura no"
2. **Agregar regla a ontology.pl**:
   ```prolog
   puede_realizar(personaje, escribir).
   ```
3. **Usar en generator.pl**:
   ```prolog
   acción(Lang, Acción) -->
       { puede_realizar(TipoSujeto, Acción) },
       [Acción].
   ```

### Verificación de Coherencia

*Nota: Actualmente es un esbozo. La implementación es lo siguiente.*

```prolog
es_coherente(Narrativa) :-
    verificar_consistencia_entidad(Narrativa),
    verificar_consistencia_tiempo_verbal(Narrativa),
    verificar_enlaces_causales(Narrativa).
```

---

## Seguimiento de Estado

### ¿Por Qué Rastrear Estado?

Sin seguimiento de estado:
- "Mago caminó. Él se sentó." → "Él" podría ser cualquiera
- "Mago luchó dragón. Mago huyó." → La repetición se siente torpe
- "Voló al castillo. Nadó a través del río." → Ninguna entidad realiza acciones

Con seguimiento de estado:
- Se rastrea el mago más reciente → "Él" se resuelve correctamente
- Puede evitar repetir la misma entidad
- Puede rastrear el flujo narrativo

### Implementación

```prolog
% Registrar mención
registrar_entidad(Tipo, Entidad) :-
    assertz(entidad_mencionada(Tipo, Entidad)).

% Obtener todas las menciones
obtener_entidades_tipo(Tipo, Entidades) :-
    findall(E, entidad_mencionada(Tipo, E), Entidades).

% Obtener la más reciente
obtener_última_entidad(Entidad) :-
    entidad_mencionada(_, Entidad),
    \+ (entidad_mencionada(_, E2), E2 \== Entidad).

% Limpiar estado
limpiar_entidades_actuales :-
    retractall(entidad_mencionada(_, _)).
```

### Resolución de Anáfora

Los pronombres se refieren a la entidad mencionada más recientemente:

```prolog
obtener_antecedente_pronombre(él, Sujeto) :-
    obtener_última_entidad(Sujeto),
    historial_entidad(personaje, Sujeto, _).
```

**Ejemplo**:
1. Generar: "Mago caminó al bosque."
2. Registrar: entidad_mencionada(personaje, mago)
3. Generar: "Él descubrió tesoro."
4. Resolver "él" → mago (personaje más reciente)

---

## Configuración

### Formatos de Archivo

#### JSON (`config/default.json`)
```json
{
  "idioma": "es",
  "semilla": 42,
  "ritmo": "medio",
  "rastrear_estado": true,
  "verificar_coherencia": true
}
```

#### YAML (`config/default.yaml`)
```yaml
idioma: es
semilla: 42
ritmo: medio
rastrear_estado: true
verificar_coherencia: true
```

#### TOML (`config/default.toml`)
```toml
[núcleo]
idioma = "es"
semilla = 42
ritmo = "medio"

[características]
rastrear_estado = true
verificar_coherencia = true
```

### Cargar Configuración

```prolog
% Desde archivo
load_config('config/default.json').

% Vía CLI
swipl -l src/main.pl -- --config config/custom.yaml

% Vía código
get_config(idioma, Idioma).
```

### Precedencia de Configuración

1. **Argumentos CLI** (`--lang es --seed 123`)
2. **Archivo de configuración** (JSON/YAML/TOML)
3. **Valores incorporados** (alternativa en código)

---

## Uso de la TUI

### Menú Principal

```
╔════════════════════════════════════════════╗
║   Generador de Discursos en Prolog v0.1   ║
║   Resurrección de Turbo Prolog de 1989     ║
║   Simple. Lógica Pura. Narrativas Coherentes.
╚════════════════════════════════════════════╝

[1] Generar Discurso
[2] Configuración
[3] Acerca de
[s] Salir

Ingresa opción: _
```

### Generar Discurso

```
=== Generar Discurso ===

Selecciona tipo de narrativa:

[1] Historia Simple
[2] Diálogo
[3] Descripción
[v] Volver

Ingresa opción: _
```

Cada tipo de narrativa produce diferente salida:
- **Historia**: Arco de inicio-medio-fin
- **Diálogo**: Intercambio entre dos hablantes
- **Descripción**: Descripción atmosférica de lugar/persona

### Configuración

```
=== Configuración ===

Idioma Actual: es

[1] Cambiar Idioma
[2] Establecer Semilla Aleatoria
[v] Volver

Ingresa opción: _
```

**Cambiar Idioma**: Cambiar dinámicamente entre en y es.

**Establecer Semilla Aleatoria**: Cualquier entero 0-1000000 para generación reproducible.

### Ejemplo de Salida

```
--- Historia Generada ---

Érase una vez un mago estaba en el bosque.
Luego el mago descubrió la espada antigua.
Finalmente el mago fue famoso.

Presiona ENTER para continuar...
```

---

## Ejemplos

### Ejemplo 1: Historia Simple en Inglés

**Configuración**: en, semilla=42
**Salida**:
```
Once upon a time a knight was in the castle.
Then the knight found the precious ring.
Finally the knight was brave.
```

### Ejemplo 2: Diálogo en Español

**Configuración**: es, semilla=100
**Salida**:
```
Arturo said: "He viajado muy lejos"
Merlin said: "La verdad está a menudo oculta"
```

### Ejemplo 3: Descripción

**Configuración**: en, semilla=123
**Salida**:
```
There is a mysterious forest.
Its color is golden, its texture is soft.
To those who know it, it feels magical.
```

### Ejemplo 4: Reproducibilidad

Ejecuta dos veces con la misma semilla:
```bash
swipl -l src/main.pl -- --lang es --seed 42
# Salida A...

swipl -l src/main.pl -- --lang es --seed 42
# Salida A... (idéntica)
```

Diferente semilla:
```bash
swipl -l src/main.pl -- --lang es --seed 43
# Salida B (diferente)
```

---

## Solución de Problemas

### Problema: "No se encontró word_bank"

**Causa**: Los archivos de datos no se cargan.

**Solución**:
1. Verifica que existan `data/dict_en.pl` y `data/dict_es.pl`
2. Verifica que `src/main.pl` tenga `:- consult('../data/dict_en.pl').`
3. Verifica que no haya errores de sintaxis: `swipl -c src/main.pl`

### Problema: La generación no produce salida

**Causa**: phrase/3 fallando en DCG.

**Depuración**:
```prolog
?- phrase(historia(es), X).
% Debería producir lista de fichas
% Si falla, verifica definiciones de word_bank
```

### Problema: Los caracteres españoles aparecen como ???

**Causa**: Codificación UTF-8 no establecida.

**Solución**:
1. Asegúrate de que `:- encoding(utf8).` esté al inicio de cada archivo
2. La terminal debe soportar UTF-8 (la mayoría de las modernas lo hacen)
3. Prueba: `write('español'), nl.` debería imprimirse correctamente

### Problema: La semilla no produce el mismo resultado

**Causa**: Inicialización aleatoria no usa set_random/1.

**Depuración**:
```prolog
?- set_random(seed(42)), random_between(1, 100, X).
% Intenta de nuevo, debería obtener el mismo X
```

### Problema: El menú no responde a la entrada

**Causa**: read/1 esperando un punto.

**Nota**: El read/1 de Prolog espera un término de Prolog que termine con `.`
```
?- read(X).
hola.        % Debe terminar con punto
X = hola.
```

---

## Historia de Turbo Prolog

### 1989: Turbo Prolog

**Qué fue**: IDE y compilador comercial para Prolog, de Borland.

**Capacidades**:
- ✅ Unificación y retroceso (Prolog central)
- ✅ Gramáticas de Cláusulas Definidas (DCG)
- ✅ assert/retract (predicados dinámicos)
- ✅ Definiciones de operadores
- ✅ E/S de archivo (básico)
- ✅ Depuración: trace, spy, nospy

**Limitaciones**:
- ❌ Sin módulos (mantener predicados en un archivo o usar convenciones de nombres)
- ❌ Sin findall/bagof/setof (usar bucles de retroceso con assert/retract)
- ❌ Sin Unicode (solo ASCII; sin ñ española, acentos)
- ❌ Sin biblioteca estándar (todo codificado a mano)
- ❌ Sin strings (solo átomos; más difícil manipular texto)
- ❌ E/S lento
- ❌ assert/retract costoso (sin indexación)

### Cómo Lo Programarías

**Problema**: Necesitas recopilar todas las soluciones (Turbo Prolog no tiene findall)

**Solución Turbo Prolog**:
```prolog
recopilar_soluciones :-
    retractall(recopilado(_)),
    solución(X),
    assertz(recopilado(X)),
    fail.
recopilar_soluciones.
```

**SWI-Prolog Moderno**:
```prolog
findall(X, solución(X), Lista).
```

**Problema**: Necesitas manejar español (Turbo Prolog no tiene Unicode)

**Solución Turbo Prolog**:
```prolog
% Usar transliteración ASCII
sustantivo(castillo).     % castillo
sustantivo(bosque).       % bosque (sin ô)
% O usar páginas de códigos (complejo, frágil)
```

**SWI-Prolog Moderno**:
```prolog
:- encoding(utf8).
sustantivo(castillo).
sustantivo(bosque).        % Funciona perfectamente
```

### SWI-Prolog Moderno (2024+)

**Qué es**: Código abierto, mantenido activamente, ampliamente utilizado en educación e investigación.

**Ventajas**:
- ✅ Unicode completo (UTF-8 nativo)
- ✅ Módulos para organización
- ✅ Biblioteca estándar rica (300+ predicados)
- ✅ Tabling/memoización (rendimiento)
- ✅ Programación Lógica de Restricciones (CLP)
- ✅ Servidor web (pengines)
- ✅ Acceso a base de datos
- ✅ Documentación excelente
- ✅ Comunidad activa

**Estado Actual**: Las limitaciones de Turbo Prolog se convierten en oportunidades de aprendizaje. Entender qué fue difícil en 1989 te hace apreciar las ventajas modernas.

---

## Ver También

- **README.md** - Inicio rápido y descripción general de características
- **CLAUDE.md** - Arquitectura y decisiones de diseño
- **HANDOFF.md** - Guía para colaboradores
- **TODO.md** - Hoja de ruta de desarrollo y problemas conocidos
- **wiki_en.md** - Versión en inglés de este wiki

---

*Última actualización: 2026*
