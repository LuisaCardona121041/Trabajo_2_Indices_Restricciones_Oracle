
-- =====================================================
-- UNIVERSIDAD INTERNACIONAL DE LA RIOJA (UNIR)
-- ASIGNATURA: BASES DE DATOS AVANZADAS
-- ACTIVIDAD 2: INDICES Y RESTRICCIONES EN ORACLE
-- =====================================================
-- ARCHIVO: 03_respaldo_hr.sql
-- DESCRIPCION:
-- Crear copias preventivas de los datos originales
-- de las tablas EMPLOYEES y DEPARTMENTS del esquema
-- HR, antes de modificar sus restricciones.
--
-- ENTORNO: Oracle Database 21c XE
-- CONEXION: HR_Local_XE
-- CONTENEDOR: XEPDB1
--
-- TIPO DE OPERACION:
-- Consultas SELECT y creacion de tablas (DDL).
--
-- IMPORTANTE:
-- Las tablas de respaldo se crean una sola vez.
-- Verificar su existencia antes de ejecutar
-- las instrucciones CREATE TABLE.
--
-- No eliminar ni sobrescribir respaldos existentes.
-- =====================================================


-- =====================================================
-- PASO 1. VERIFICAR EL CONTEXTO DE CONEXION
-- =====================================================
-- Comprobar que el procedimiento se ejecuta con
-- el usuario HR en el contenedor XEPDB1.

SELECT
    USER AS usuario,
    SYS_CONTEXT('USERENV', 'CON_NAME') AS contenedor
FROM dual;


-- =====================================================
-- PASO 2. CONSULTAR LOS REGISTROS ORIGINALES
-- =====================================================
-- Identificar la cantidad inicial de registros
-- almacenados en EMPLOYEES y DEPARTMENTS.
--
-- Estos valores serviran como referencia para
-- comprobar los respaldos realizados.

SELECT
    'EMPLOYEES' AS tabla,
    COUNT(*) AS total
FROM employees
UNION ALL
SELECT
    'DEPARTMENTS',
    COUNT(*)
FROM departments;


-- =====================================================
-- PASO 3. VERIFICAR LA EXISTENCIA DE RESPALDOS
-- =====================================================
-- Consultar si las tablas de respaldo ya existen
-- en el esquema HR.
--
-- IMPORTANTE:
-- Si aparecen ambas tablas en el resultado,
-- NO ejecutar nuevamente los pasos 4 y 5.
--
-- Si solo existe una, no recrearla.
-- Crear unicamente el respaldo faltante, siempre
-- que corresponda a una ejecucion inicial segura.

SELECT
    table_name
FROM user_tables
WHERE table_name IN (
    'BDA2_BKP_EMPLOYEES',
    'BDA2_BKP_DEPARTMENTS'
);


-- =====================================================
-- PASO 4. CREAR RESPALDO DE EMPLOYEES
-- =====================================================
-- Crear una copia preventiva de los datos
-- existentes en la tabla EMPLOYEES.
--
-- IMPORTANTE:
-- Ejecutar unicamente si la tabla
-- BDA2_BKP_EMPLOYEES NO existe.
--
-- Esta instruccion no debe repetirse una vez
-- creado el respaldo.

CREATE TABLE BDA2_BKP_EMPLOYEES AS
SELECT *
FROM EMPLOYEES;


-- =====================================================
-- PASO 5. CREAR RESPALDO DE DEPARTMENTS
-- =====================================================
-- Crear una copia preventiva de los datos
-- existentes en la tabla DEPARTMENTS.
--
-- IMPORTANTE:
-- Ejecutar unicamente si la tabla
-- BDA2_BKP_DEPARTMENTS NO existe.
--
-- Esta instruccion no debe repetirse una vez
-- creado el respaldo.

CREATE TABLE BDA2_BKP_DEPARTMENTS AS
SELECT *
FROM DEPARTMENTS;


-- =====================================================
-- PASO 6. VERIFICAR LOS REGISTROS RESPALDADOS
-- =====================================================
-- Comprobar la cantidad de registros almacenados
-- en cada tabla de respaldo.
--
-- Este paso requiere que ambas tablas de
-- respaldo existan previamente.

SELECT
    'BDA2_BKP_EMPLOYEES' AS tabla,
    COUNT(*) AS total
FROM BDA2_BKP_EMPLOYEES
UNION ALL
SELECT
    'BDA2_BKP_DEPARTMENTS',
    COUNT(*)
FROM BDA2_BKP_DEPARTMENTS;


-- =====================================================
-- RESULTADO OBTENIDO EN EL LABORATORIO
-- =====================================================
-- Tabla original EMPLOYEES:
-- 107 registros.
--
-- Tabla original DEPARTMENTS:
-- 27 registros.
--
-- Respaldo BDA2_BKP_EMPLOYEES:
-- 107 registros.
--
-- Respaldo BDA2_BKP_DEPARTMENTS:
-- 27 registros.
--
-- Los respaldos se utilizaron posteriormente
-- para verificar la integridad de los datos
-- originales mediante consultas comparativas.
--
-- OBSERVACION:
-- CREATE TABLE AS SELECT copia los datos y
-- la estructura basica resultante de la consulta,
-- pero no constituye un respaldo integral de Oracle.
--
-- Las operaciones DDL producen confirmaciones
-- implicitas de transacciones en Oracle.
-- =====================================================
-- FIN DEL ARCHIVO: 03_respaldo_hr.sql
-- =====================================================
