# Laboratorio 5 — SQL (2/2): Andes Bike

**Asignatura:** ICN-292 — Sistemas de Información para la Gestión  
**Institución:** Universidad Técnica Federico Santa María  
**Estudiante:** Charles Piket Silva  
**Semestre:** 2026/02

## Descripción

Este repositorio contiene la solución del Laboratorio 5 de consultas SQL para la base de datos **Andes Bike**, una cadena de tiendas de bicicletas. Incluye el esquema relacional, la carga oficial de datos, diez consultas, sus resultados y el informe redactado en LaTeX.

La implementación y las capturas de ejecución se realizaron con **SQLite desde Visual Studio Code**.

## Archivos del repositorio

```text
ICN292-Lab5-Piket-Charles/
├── README.md
├── ICN292-Lab5-Piket-Charles.pdf
├── ICN292-Lab5-Piket-Charles.tex
├── ICN292-Lab5-Piket-Charles.sql
├── ICN292-Lab5-Piket-Charles-Modelo_ER.png
├── ICN292-Lab5-Piket-Charles.db
├── config.tex
├── Logos/
│   ├── header_utfsm.png
│   ├── Logo_industrias.png
│   └── logo_di.png
└── Evidencia_lab5/
    ├── Consulta_01.png
    ├── Consulta_02.png
    ├── ...
    └── Consulta_10.png
```

- **`.pdf`**: informe con las diez consultas, capturas y explicaciones solicitadas para las consultas 4, 8 y 10.
- **`.tex`, `config.tex`, `Logos/` y `Evidencia_lab5/`**: fuentes y recursos para compilar el informe.
- **`.sql`**: creación de las cuatro tablas, carga oficial y las diez consultas, en ese orden.
- **`-Modelo_ER.png`**: diagrama entidad-relación entregado como **archivo independiente** del informe.
- **`.db`**: copia de la base de datos SQLite con los datos cargados.

## Base de datos

El esquema contiene cuatro tablas: `tiendas`, `vendedores`, `bicicletas` y `ventas`. Las ventas se vinculan a vendedores y bicicletas; cada vendedor puede estar asociado a una tienda o no tener una asignación.

La carga oficial incluye **4 tiendas, 8 vendedores, 8 modelos de bicicletas y 18 ventas**, con **35 unidades** y un monto total de **$16.969.650**.

## Cómo ejecutar las consultas

1. Abrir `ICN292-Lab5-Piket-Charles.db` con una extensión SQLite de Visual Studio Code, o crear una base de datos SQLite vacía.
2. Abrir `ICN292-Lab5-Piket-Charles.sql`.
3. Si se creó una base vacía, ejecutar el archivo completo para crear y poblar las tablas. Si ya hay datos que se desean conservar, ejecutar **solo las sentencias `SELECT`** de la sección de consultas.
4. Ejecutar las consultas individualmente y comparar sus resultados con las imágenes de `Evidencia_lab5/`.

**Atención:** el script incluye instrucciones `DROP TABLE IF EXISTS`, por lo que ejecutarlo completo sobre una base existente **elimina las cuatro tablas y sus datos anteriores**.

**Compatibilidad:** el script utiliza la sintaxis de **SQLite 3**. El enunciado original solicita MySQL Workbench; por tanto, para ajustarse literalmente a ese requisito es necesario adaptar la ejecución y obtener las evidencias en MySQL Workbench.

## Cómo compilar el informe

Abrir la carpeta raíz del repositorio en un editor LaTeX y compilar `ICN292-Lab5-Piket-Charles.tex` con **pdfLaTeX**. Se necesitan `config.tex`, la carpeta `Logos/` y las diez capturas de `Evidencia_lab5/`, conservando sus rutas.

El diagrama E-R se mantiene fuera del PDF porque la pauta lo pide como archivo aparte.
