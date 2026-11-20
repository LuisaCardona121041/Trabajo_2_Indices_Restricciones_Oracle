
-- =====================================================
-- UNIVERSIDAD INTERNACIONAL DE LA RIOJA (UNIR)
-- ASIGNATURA: BASES DE DATOS AVANZADAS
-- ACTIVIDAD 2: INDICES Y RESTRICCIONES EN ORACLE
-- =====================================================
-- ARCHIVO: 01_consulta_indices.sql
-- DESCRIPCION:
-- Identificar los indices existentes en las tablas
-- EMPLOYEES y DEPARTMENTS del esquema HR.
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
-- PASO 2. CONSULTAR LOS INDICES EXISTENTES
-- =====================================================
-- Identificar los indices de EMPLOYEES y DEPARTMENTS,
-- incluyendo su tipo, unicidad, columnas y posicion.
--
-- USER_INDEXES:
-- Contiene informacion sobre los indices del usuario.
--
-- USER_IND_COLUMNS:
-- Identifica las columnas que integran cada indice.
--
-- IMPORTANTE:
-- Un indice compuesto puede aparecer en varias filas,
-- una por cada columna que lo conforma.

SELECT
    i.table_name AS tabla,
    i.index_name AS indice,
    i.index_type AS tipo,
    i.uniqueness AS unicidad,
    ic.column_name AS columna,
    ic.column_position AS posicion
FROM user_indexes i
INNER JOIN user_ind_columns ic
    ON i.index_name = ic.index_name
    AND i.table_name = ic.table_name
WHERE i.table_name IN ('EMPLOYEES', 'DEPARTMENTS')
ORDER BY
    i.table_name,
    i.index_name,
    ic.column_position;


-- =====================================================
-- RESULTADO OBTENIDO EN EL LABORATORIO
-- =====================================================
-- Se identificaron 8 indices.
-- La consulta devolvio 9 registros porque el indice
-- EMP_NAME_IX contiene dos columnas:
-- LAST_NAME y FIRST_NAME.
--
-- Este procedimiento no modifica la base de datos.
-- =====================================================
-- FIN DEL ARCHIVO: 01_consulta_indices.sql
-- =====================================================
