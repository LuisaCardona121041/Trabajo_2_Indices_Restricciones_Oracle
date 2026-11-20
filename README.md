
# Trabajo 2. Índices y restricciones en Oracle

**Universidad:** Universidad Internacional de La Rioja (UNIR)  
**Asignatura:** Bases de Datos Avanzadas  
**Actividad:** Trabajo 2. Índices y restricciones en Oracle  
**Base de datos:** Oracle Database 21c Express Edition (XE)  
**Herramienta:** Oracle SQL Developer  

## 1. Descripción del proyecto

Este repositorio contiene los archivos SQL y las evidencias
correspondientes al desarrollo de la actividad sobre índices,
restricciones de integridad y control de transacciones en Oracle.

Los ejercicios se desarrollaron utilizando las tablas EMPLOYEES,
DEPARTMENTS y JOB_HISTORY del esquema de ejemplo HR.

La actividad comprende la identificación de índices, el diagnóstico
y la desactivación temporal de restricciones, pruebas de inserción
de datos inválidos, restauración de la integridad, creación de una
tabla derivada y comprobación de la persistencia de los datos.

También se incluyen ejercicios de control transaccional mediante
PL/SQL, SAVEPOINT y ROLLBACK, así como el diagnóstico de archivos
REDO y una prueba experimental de generación de registros REDO.

## 2. Entorno de trabajo

Se utilizó la siguiente configuración:

- Oracle Database 21c Express Edition (XE).
- Oracle SQL Developer.
- Esquema de trabajo: HR.
- Contenedor de trabajo: XEPDB1.
- Conexión de trabajo: HR_Local_XE.
- Conexión administrativa: SYS_Admin_XE.
- Contenedor administrativo: CDB$ROOT.

La conexión administrativa se utilizó exclusivamente para
consultar las vistas dinámicas relacionadas con los archivos
REDO y las estadísticas de sesión.

Los nombres de las conexiones corresponden a la configuración
local del laboratorio y pueden variar en otras instalaciones.

## 3. Estructura del repositorio

El proyecto se organiza en las siguientes carpetas:

- **sql/**: archivos SQL correspondientes a los procedimientos.
- **evidencias/**: capturas de pantalla de los ejercicios.
- **documentacion/**: memoria explicativa de la actividad en PDF.
- **respaldo/**: archivos auxiliares de respaldo y verificación,
  cuando corresponda.
- **README.md**: descripción y guía de consulta del proyecto.

## 4. Archivos SQL

Los procedimientos se organizaron en 13 archivos, siguiendo
la secuencia de desarrollo del laboratorio.

| Archivo | Descripción |
|---|---|
| 01_consulta_indices.sql | Identificación de índices en EMPLOYEES y DEPARTMENTS. |
| 02_diagnostico_restricciones.sql | Consulta de restricciones y claves foráneas dependientes. |
| 03_respaldo_hr.sql | Creación de copias preventivas de los datos originales. |
| 04_estado_original_restricciones.sql | Registro del estado inicial de las restricciones. |
| 05_desactivar_claves_foraneas.sql | Desactivación temporal de siete claves foráneas. |
| 06_desactivar_restricciones_restantes.sql | Desactivación de nueve restricciones adicionales. |
| 07_inserciones_invalidas.sql | Pruebas de inserción, limpieza y verificación de integridad. |
| 08_restaurar_restricciones.sql | Restauración y validación de las restricciones originales. |
| 09_creacion_departments2.sql | Creación de DEPARTMENTS2 y comprobación de persistencia. |
| 10_bloque_anonimo_transaccion.sql | Ejemplo de control transaccional mediante PL/SQL. |
| 11_ejemplo_rollback.sql | Demostración de ROLLBACK parcial y completo. |
| 12_diagnostico_archivos_redo.sql | Consulta del modo de archivado y archivos REDO. |
| 13_prueba_generacion_redo.sql | Medición experimental del incremento de REDO. |

## 5. Consideraciones de ejecución

**IMPORTANTE:** los archivos documentan procedimientos que ya
fueron ejecutados y verificados durante el laboratorio.

No se recomienda ejecutar todos los scripts de manera automática
ni repetir las instrucciones que modifican la estructura o los
datos de la base de datos.

### Archivos de consulta

Los archivos 01, 02 y 04 contienen consultas de diagnóstico
que no modifican la información.

El archivo 12 también contiene consultas de solo lectura,
pero requiere privilegios administrativos para acceder
a las vistas dinámicas de Oracle.

### Archivos que modifican datos o restricciones

Los archivos 03, 05, 06, 07, 08 y 09 contienen instrucciones
DDL o DML que deben ejecutarse únicamente en un entorno
de laboratorio preparado para este propósito.

Es necesario verificar los requisitos previos y respetar
el orden de los procedimientos.

Las tablas de respaldo y DEPARTMENTS2 ya fueron creadas
durante la ejecución original.

### Ejercicios transaccionales

Los archivos 10 y 11 contienen operaciones temporales
que utilizan ROLLBACK para deshacer modificaciones.

El archivo 13 requiere dos conexiones:

- HR_Local_XE: ejecución de la modificación temporal.
- SYS_Admin_XE: consulta de las estadísticas REDO.

Durante la prueba del archivo 13 debe mantenerse abierta
la misma sesión HR y realizarse la medición antes de
ejecutar ROLLBACK.

## 6. Resultados obtenidos

Durante el desarrollo de la actividad se obtuvieron
los siguientes resultados:

- Identificación de 8 índices en EMPLOYEES y DEPARTMENTS.
- Consulta de 9 filas correspondientes a sus columnas indexadas.
- Diagnóstico de 23 restricciones de integridad.
- Desactivación temporal de 16 restricciones.
- Restauración de las 23 restricciones al estado
  ENABLED VALIDATED.
- Verificación de 107 empleados y 27 departamentos originales.
- Comparación con los respaldos sin diferencias detectadas.
- Creación de DEPARTMENTS2 con 27 registros iniciales.
- Inserción de 3 departamentos adicionales.
- Comprobación de 30 registros después de reconectar.
- Demostración de ROLLBACK parcial y completo.
- Identificación de la base de datos en modo NOARCHIVELOG.
- Identificación de 3 grupos REDO de 200 MB cada uno.
- Incremento observado de 816 bytes en la estadística
  redo size durante la prueba experimental.

Los cambios temporales realizados durante las pruebas
fueron revertidos o retirados, y se comprobó la
restauración de la integridad de las tablas originales.

## 7. Evidencias y documentación

La carpeta **evidencias/** contiene las capturas obtenidas
durante la ejecución de los procedimientos en Oracle
SQL Developer.

La carpeta **documentacion/** contiene la memoria explicativa
del trabajo, en la cual se describen los procedimientos,
se analizan los resultados y se presentan las evidencias
más representativas.

Los archivos SQL constituyen el soporte técnico de los
ejercicios documentados en el informe académico.

## 8. Observaciones finales

Las pruebas se realizaron exclusivamente con fines
académicos, utilizando el esquema de ejemplo HR.

Las instrucciones de desactivación de restricciones y
modificación de datos no deben ejecutarse sobre
entornos productivos sin autorización y sin medidas
adecuadas de protección.

No se incluyen contraseñas ni credenciales de acceso
a la base de datos.

Los resultados administrativos y las estadísticas REDO
corresponden al momento en que se realizaron las pruebas
y pueden variar en otras instalaciones de Oracle.

---

**Universidad Internacional de La Rioja (UNIR)**  
**Bases de Datos Avanzadas — Trabajo 2**
