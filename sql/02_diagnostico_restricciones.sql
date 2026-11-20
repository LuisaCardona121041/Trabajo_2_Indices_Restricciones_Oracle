
-- =====================================================
-- UNIVERSIDAD INTERNACIONAL DE LA RIOJA (UNIR)
-- ASIGNATURA: BASES DE DATOS AVANZADAS
-- ACTIVIDAD 2: INDICES Y RESTRICCIONES EN ORACLE
-- =====================================================
-- ARCHIVO: 02_diagnostico_restricciones.sql
-- DESCRIPCION:
-- Identificar las restricciones de integridad de las
-- tablas EMPLOYEES y DEPARTMENTS del esquema HR.
-- Consultar las claves foraneas que referencian
-- estas tablas para reconocer sus dependencias.
--
-- ENTORNO: Oracle Database 21c XE
-- CONEXION: HR_Local_XE
-- CONTENEDOR: XEPDB1
--
-- TIPO DE OPERACION: Solo lectura (SELECT).
-- =====================================================


-- =====================================================
-- PASO 1. VERIFICAR EL CONTEXTO DE CONEXION
-- =====================================================
-- Comprobar que las consultas se ejecutan con
-- el usuario HR en el contenedor XEPDB1.

SELECT
    USER AS usuario,
    SYS_CONTEXT('USERENV', 'CON_NAME') AS contenedor
FROM dual;


-- =====================================================
-- PASO 2. CONSULTAR LAS RESTRICCIONES EXISTENTES
-- =====================================================
-- Identificar las restricciones de las tablas
-- EMPLOYEES y DEPARTMENTS, incluyendo sus nombres,
-- tipos, estados, validacion y columnas asociadas.
--
-- USER_CONSTRAINTS:
-- Contiene informacion sobre las restricciones
-- definidas en las tablas del usuario.
--
-- USER_CONS_COLUMNS:
-- Identifica las columnas asociadas a cada
-- restriccion.
--
-- TIPOS DE RESTRICCIONES:
-- P: Clave primaria (PRIMARY KEY).
-- R: Clave foranea (FOREIGN KEY).
-- U: Restriccion de unicidad (UNIQUE).
-- C: Restriccion CHECK o NOT NULL.
--
-- IMPORTANTE:
-- Una restriccion que involucra varias columnas
-- puede aparecer en mas de una fila del resultado.

SELECT
    c.table_name AS tabla,
    c.constraint_name AS restriccion,
    c.constraint_type AS tipo,
    c.status AS estado,
    c.validated AS validacion,
    cc.column_name AS columna,
    cc.position AS posicion
FROM user_constraints c
LEFT JOIN user_cons_columns cc
    ON c.constraint_name = cc.constraint_name
    AND c.table_name = cc.table_name
WHERE c.table_name IN ('EMPLOYEES', 'DEPARTMENTS')
ORDER BY
    c.table_name,
    c.constraint_name,
    cc.position;


-- =====================================================
-- PASO 3. IDENTIFICAR CLAVES FORANEAS DEPENDIENTES
-- =====================================================
-- Consultar las claves foraneas que referencian
-- las tablas EMPLOYEES o DEPARTMENTS.
--
-- Esta consulta permite identificar relaciones
-- de dependencia con otras tablas del esquema HR.
--
-- La columna R_CONSTRAINT_NAME identifica la
-- restriccion primaria o unica referenciada.
--
-- IMPORTANTE:
-- Se consultan exclusivamente las claves foraneas
-- que referencian EMPLOYEES o DEPARTMENTS.
-- No se incluyen todas las claves foraneas del esquema.

SELECT
    c.table_name AS tabla_dependiente,
    c.constraint_name AS restriccion_fk,
    p.table_name AS tabla_referenciada,
    p.constraint_name AS restriccion_referenciada,
    c.status AS estado
FROM user_constraints c
INNER JOIN user_constraints p
    ON c.r_constraint_name = p.constraint_name
WHERE c.constraint_type = 'R'
  AND p.table_name IN ('EMPLOYEES', 'DEPARTMENTS')
ORDER BY
    p.table_name,
    c.table_name;


-- =====================================================
-- RESULTADO OBTENIDO EN EL LABORATORIO
-- =====================================================
-- Se identificaron 14 restricciones asociadas a
-- las tablas EMPLOYEES y DEPARTMENTS.
--
-- El diagnostico ampliado incluyo JOB_HISTORY,
-- con un total de 23 restricciones verificadas
-- durante el laboratorio.
--
-- Inicialmente, las restricciones verificadas
-- se encontraban en estado ENABLED VALIDATED.
--
-- Las dependencias identificadas permitieron
-- planificar la desactivacion controlada de
-- restricciones en los ejercicios posteriores.
--
-- Este procedimiento no modifica la base de datos.
-- =====================================================
-- FIN DEL ARCHIVO: 02_diagnostico_restricciones.sql
-- =====================================================

