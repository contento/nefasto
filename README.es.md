# Generador de Discursos en Prolog

Un generador de narrativas puro en Prolog que revive técnicas de Turbo Prolog de 1989 con SWI-Prolog moderno. Genera historias coherentes, diálogos y descripciones en inglés y español—sin LLMs, sin redes neuronales, solo lógica pura.

**[English version](README.md)** | **Versión en Español** 🇪🇸

## Características

- **Lógica Pura**: Sin ML, sin LLMs, sin cajas negras. Solo Prolog.
- **Narrativas Coherentes**: Las ontologías y el seguimiento de estado previenen contradicciones
- **Simple y Extensible**: Bancos de palabras, gramáticas DCG, plantillas narrativas
- **Multilingüe**: Soporte completo para inglés y español desde el principio
- **Contexto Histórico**: Notas sobre Turbo Prolog (~1989) vs SWI-Prolog moderno
- **TUI Multiplataforma**: Funciona en Linux, macOS, Windows
- **Configuración Flexible**: JSON, YAML, TOML y argumentos de línea de comandos

## Inicio Rápido

### Dos Interfaces

Elige una:

#### **TUI Simple** (Terminal)
```bash
# Requisitos: Solo SWI-Prolog

swipl -l src/main.pl
```

#### **Interfaz Web Avanzada** (Navegador)
```bash
# Requisitos: Node.js + npm + SWI-Prolog

# Terminal 1: Inicia el servidor Prolog
swipl -f src/server.pl -t start_server

# Terminal 2: Inicia el frontend React
cd web && npm install && npm run dev
```

### Detalles Completos de Configuración

Ve a **[RUN.md](RUN.md)** para:
- Instrucciones paso a paso para ambas interfaces
- Argumentos CLI para TUI
- Configuración para la interfaz web
- Guía de solución de problemas
- Comparación de arquitecturas

### Requisitos
- **SWI-Prolog 8.0+** ([descargar](https://www.swi-prolog.org/download/stable))
- **Node.js 14+** (solo para interfaz web) ([descargar](https://nodejs.org/))
- Soporte UTF-8 en terminal (estándar en sistemas modernos)

### Instalación
```bash
git clone https://github.com/yourusername/prolog-discourse-gen
cd prolog-discourse-gen

# Para interfaz web, también:
cd web && npm install
```

## Estructura del Proyecto

```
nefasto/
├── src/                    # Módulos Prolog principales
│   ├── main.pl            # Punto de entrada CLI
│   ├── tui.pl             # Interfaz de terminal
│   ├── server.pl          # Servidor HTTP
│   ├── generator.pl       # Generación con DCG
│   ├── ontology.pl        # Reglas semánticas
│   ├── state.pl           # Seguimiento de entidades
│   ├── config.pl          # Cargador de configuración
│   └── random_utils.pl    # Utilidades de selección aleatoria
├── web/                   # Frontend React
│   ├── src/
│   │   ├── App.jsx
│   │   ├── App.css
│   │   └── main.jsx
│   ├── index.html
│   ├── package.json
│   └── vite.config.js
├── data/                  # Lexicones y plantillas
│   ├── dict_en.pl         # Banco de palabras en inglés
│   ├── dict_es.pl         # Banco de palabras en español
│   └── narratives.pl      # Plantillas de historias
├── config/                # Archivos de configuración
│   ├── default.json
│   ├── default.yaml
│   └── default.toml
├── docs/                  # Documentación
│   ├── wiki_en.md         # Wiki en inglés
│   └── wiki_es.md         # Wiki en español
├── README.md              # Descripción general (inglés)
├── README.es.md           # Descripción general (español)
├── RUN.md                 # Cómo ejecutar ambas interfaces
├── CLAUDE.md              # Decisiones arquitectónicas
├── HANDOFF.md             # Guía de colaboración
├── TODO.md                # Hoja de ruta de desarrollo
└── .graphifyignore        # Configuración de gráfico de conocimiento
```

## ¿Cómo Funciona?

### 1. Generación de Discursos con DCG
Las narrativas se generan usando Gramáticas de Cláusulas Definidas de Prolog (phrase/3):

```prolog
historia(Lang) --> introducción(Lang), conflicto(Lang), resolución(Lang).
introducción(Lang) --> ['Érase una vez'], sujeto(Lang, S), copula(Lang), ubicación(Lang, L), ['.'].
```

### 2. Selección de Palabras desde Diccionarios
Bancos de palabras simples proporcionan vocabulario:

```prolog
word_bank(sustantivos, es, [mago, caballero, dragón, bosque, castillo, ...]).
word_bank(verbos, es, [caminó, voló, descubrió, habló, ...]).
```

Selección aleatoria:
```prolog
random_select_word(sustantivos, es, Palabra).  % Elige sustantivo aleatorio
```

### 3. Restricciones Ontológicas
Las reglas semánticas aseguran coherencia:

```prolog
puede_realizar(personaje, hablar).
puede_realizar(criatura, deambular).
actividad_permite_ubicación(bosque, [deambulaban, cazaban, encontraban]).
```

### 4. Seguimiento de Estado
El rastreo de entidades previene contradicciones:

```prolog
registrar_entidad(sujeto, mago).        % Recordar: se mencionó el mago
obtener_última_entidad(sujeto, E).      % Obtener el sujeto más reciente
puede_usar_entidad(mago).               % Verificar: ¿podemos mencionar el mago nuevamente?
```

## Configuración

### Formatos Soportados

#### JSON
```json
{
  "idioma": "es",
  "semilla": 42,
  "ritmo": "medio"
}
```

#### YAML
```yaml
idioma: es
semilla: 42
ritmo: medio
```

#### TOML
```toml
[núcleo]
idioma = "es"
semilla = 42
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

## Uso de la Interfaz Web

### Menú Principal
- **Seleccionar Idioma**: Cambiar entre inglés y español
- **Tipo de Narrativa**: Elegir entre Historia Simple, Diálogo o Descripción
- **Semilla Aleatoria**: Controlar reproducibilidad o generar narrativas aleatorias
- **Copiar al Portapapeles**: Botón rápido para copiar texto generado

### Ejemplo de Salida
```
Érase una vez un mago estaba en el bosque.
Luego el mago descubrió la espada antigua.
Finalmente el mago se volvió famoso.
```

## Solución de Problemas

### Problema: "No se encontró word_bank"
**Causa**: Los archivos de datos no se cargan.
**Solución**:
1. Verifica que existan `data/dict_en.pl` y `data/dict_es.pl`
2. Verifica que `src/main.pl` tenga `:- consult('../data/dict_en.pl').`
3. Verifica errores de sintaxis: `swipl -c src/main.pl`

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
2. Tu terminal debe soportar UTF-8 (modernas lo hacen)
3. Prueba: `write('español'), nl.` debería imprimirse correctamente

### Problema: La interfaz web no se conecta
**Causa**: El servidor Prolog no está corriendo.
**Solución**:
1. ¿Está ejecutándose el servidor? `swipl -f src/server.pl -t start_server`
2. ¿Está en puerto 3001? Verifica los logs
3. ¿`VITE_API_URL` es correcto? Verifica `.env`

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
- ❌ Sin módulos
- ❌ Sin findall/bagof/setof
- ❌ Sin Unicode (solo ASCII)
- ❌ Sin biblioteca estándar
- ❌ E/S lento
- ❌ assert/retract costoso

### SWI-Prolog Moderno (2024+)

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

## Ejemplos

### Generar una Historia en Español
```bash
swipl -l src/main.pl -- --lang es --seed 42
```

### Generar un Diálogo
```bash
swipl -l src/main.pl -- --lang es --type dialogue --seed 100
```

### Cargar Configuración Personalizada
```bash
swipl -l src/main.pl -- --config config/custom.yaml
```

### Usar la Interfaz Web
```bash
# Terminal 1
swipl -f src/server.pl -t start_server

# Terminal 2
cd web && npm run dev
# Abre http://localhost:3000
```

## Desarrollo

### Agregar Palabras Nuevas

**Para inglés** (edita `data/dict_en.pl`):
```prolog
word_bank(sustantivos, es, [
    % Existentes...
    mago, caballero, dragón, bosque, castillo,
    % Nuevos...
    comerciante, pueblo, torre
]).
```

### Agregar Tipos de Narrativa Nuevos

1. Agrega regla DCG a `src/generator.pl`
2. Agrega tipo a validación en `src/server.pl`
3. Agrega a opciones React en `web/src/App.jsx`
4. Actualiza `data/narratives.pl`

## Estado del Proyecto

**Desarrollo Temprano** – La generación de narrativas básica funciona. Siguiente: expandir bancos de palabras, fijar problemas de integración DCG, agregar más plantillas.

## Documentación

- **CLAUDE.md** - Decisiones arquitectónicas
- **wiki_en.md** - Wiki completo en inglés (Obsidian-compatible)
- **wiki_es.md** - Wiki completo en español (Obsidian-compatible)
- **TODO.md** - Hoja de ruta de desarrollo
- **HANDOFF.md** - Notas para el próximo desarrollador
- **RUN.md** - Cómo ejecutar ambas interfaces

## ¿Preguntas?

Consulta:
- `CLAUDE.md` para decisiones arquitectónicas
- `wiki_es.md` para explicaciones detalladas
- `HANDOFF.md` para guía de colaboración
- `TODO.md` para tareas pendientes

---

**¿Listo para generar narrativas?** Elige tu interfaz arriba y ¡comienza! 🚀
