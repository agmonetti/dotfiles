# Micro Configuration & Database Syntax Highlighting

Configuración del editor de texto **Micro** para los dotfiles, incluyendo temas sincronizados con Kitty (Catppuccin) y soporte avanzado de **syntax highlighting automático para bases de datos**.

## Estructura

```
micro/
└── .config/
    └── micro/
        ├── bindings.json        # Keybindings personalizados
        ├── settings.json        # Opciones generales (tema kitty-sync, etc.)
        ├── colorschemes/        # Temas de color (kitty-dark, kitty-light, kitty-sync)
        └── syntax/              # Definiciones de sintaxis adicionales
            ├── cql.yaml         # Cassandra / ScyllaDB Query Language (.cql)
            ├── mongodb.yaml     # MongoDB Shell & Query DSL (.mongodb.js, .mongosh, etc.)
            ├── redis.yaml       # Redis Commands & CLI scripts (.redis, .redis-cli, .acl)
            ├── cypher.yaml      # Neo4j Cypher & openCypher (.cypher, .cyp)
            ├── surrealql.yaml   # SurrealDB SurrealQL (.surql, .surrealql)
            ├── promql.yaml      # Prometheus PromQL (.promql, .prom)
            ├── influxql.yaml    # InfluxDB InfluxQL (.influxql)
            ├── flux.yaml        # InfluxDB Flux Scripting (.flux)
            └── n1ql.yaml        # Couchbase N1QL / SQL++ (.n1ql, .sqlpp)
```

## Detección Automática de Lenguajes

| Base de Datos / Lenguaje | Extensiones reconocidas | Detección por encabezado / directiva |
|---|---|---|
| **Cassandra / CQL** | `.cql` | `-- cql`, `// cql` |
| **MongoDB / Mongo Shell** | `.mongodb.js`, `.mongo.js`, `.mongosh.js`, `.mongorc.js`, `.mongodb`, `.mongosh` | `//!mongosh`, `//mongosh`, `#!/usr/bin/env mongosh`, `use <db>`, `db.<colección>` |
| **Redis** | `.redis`, `.rediscli`, `.redis-cli`, `.acl` | `# redis`, `#!/usr/bin/env redis-cli` |
| **Neo4j / Cypher** | `.cypher`, `.cyp` | `// cypher`, `#!/usr/bin/env cypher-shell` |
| **SurrealDB / SurrealQL** | `.surql`, `.surrealql` | — |
| **Prometheus PromQL** | `.promql`, `.prom` | — |
| **InfluxDB InfluxQL** | `.influxql` | — |
| **InfluxDB Flux** | `.flux` | — |
| **Couchbase N1QL** | `.n1ql`, `.sqlpp` | — |

> **Nota sobre JavaScript estándar**: Los archivos `.js` convencionales siguen usando el motor nativo de JavaScript (`filetype: javascript`). MongoDB solo se activa para archivos `.js` si contienen directivas explícitas de mongosh o nombres de archivo específicos.

## Sincronización con Stow

Al ejecutar `./setup.sh` desde la raíz de los dotfiles, GNU Stow enlaza automáticamente `micro/.config/micro` con `~/.config/micro`, dejando todas las sintaxis disponibles de forma inmediata en cualquier máquina.
