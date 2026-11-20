
-- =====================================================
-- UNIVERSIDAD INTERNACIONAL DE LA RIOJA (UNIR)
-- ASIGNATURA: BASES DE DATOS AVANZADAS
-- ACTIVIDAD 2: INDICES Y RESTRICCIONES EN ORACLE
-- =====================================================
-- ARCHIVO: 09_creacion_departments2.sql
-- DESCRIPCION:
-- Crear la tabla DEPARTMENTS2 a partir de los
-- datos existentes en DEPARTMENTS.
--
-- Insertar tres departamentos adicionales,
-- confirmar las operaciones y comprobar
-- la persistencia de los registros despues
-- de cerrar y establecer una nueva sesion.
--
-- ENTORNO: Oracle Database 21c XE
-- CONEXION: HR_Local_XE
-- CONTENEDOR: XEPDB1
--
-- TIPO DE OPERACION:
-- Creacion de tabla (DDL), insercion de datos
-- (DML), control transaccional (COMMIT) y
-- consultas de verificacion (SELECT).
--
-- IMPORTANTE:
-- Este archivo documenta operaciones
-- realizadas durante el laboratorio.
--
-- La tabla DEPARTMENTS2 ya fue creada y
-- contiene los tres departamentos insertados.
--
-- NO ejecutar nuevamente CREATE TABLE,
-- INSERT ALL ni COMMIT.
--
-- Las operaciones DDL generan COMMIT implicitos.
-- Los registros insertados fueron confirmados
-- posteriormente mediante COMMIT explicito.
-- =====================================================


-- =====================================================
-- PASO 1. VERIFICAR EL CONTEXTO DE CONEXION
-- =====================================================
-- Comprobar que el procedimiento corresponde
-- al usuario HR y al contenedor XEPDB1.

SELECT
    USER AS usuario,
    SYS_CONTEXT('USERENV', 'CON_NAME') AS contenedor
FROM dual;


-- =====================================================
-- PASO 2. VERIFICAR LA EXISTENCIA DE DEPARTMENTS2
-- =====================================================
-- Consultar si la tabla DEPARTMENTS2 ya existe
-- en el esquema HR.
--
-- IMPORTANTE:
-- Durante la ejecucion inicial, esta consulta
-- devolvio cero filas.
--
-- Actualmente, la tabla ya existe.
-- No repetir su creacion.

SELECT
    table_name
FROM user_tables
WHERE table_name = 'DEPARTMENTS2';


-- =====================================================
-- PASO 3. CREAR LA TABLA DEPARTMENTS2
-- =====================================================
-- Crear una copia de los datos existentes
-- en la tabla DEPARTMENTS.
--
-- CREATE TABLE AS SELECT permite crear una
-- tabla a partir del resultado de una consulta.
--
-- IMPORTANTE:
-- Esta instruccion fue ejecutada anteriormente.
-- NO repetirla sobre el esquema actual.
--
-- La operacion no reproduce automaticamente
-- todas las restricciones ni los indices
-- asociados a la tabla original.

CREATE TABLE departments2 AS
SELECT *
FROM departments;


-- =====================================================
-- PASO 4. VERIFICAR LOS REGISTROS INICIALES
-- =====================================================
-- Consultar la cantidad de registros copiados
-- desde la tabla DEPARTMENTS.
--
-- RESULTADO OBTENIDO DURANTE LA CREACION:
-- TOTAL_INICIAL = 27.
--
-- OBSERVACION:
-- Actualmente, esta consulta devolvera 30
-- registros porque ya se realizaron las
-- inserciones adicionales.

SELECT
    COUNT(*) AS total_inicial
FROM departments2;


-- =====================================================
-- PASO 5. INSERTAR TRES DEPARTAMENTOS NUEVOS
-- =====================================================
-- Insertar tres registros mediante INSERT ALL.
--
-- DEPARTAMENTO 9901:
-- Departamento Prueba 1.
--
-- DEPARTAMENTO 9902:
-- Departamento Prueba 2.
--
-- DEPARTAMENTO 9903:
-- Departamento Prueba 3.
--
-- Los campos MANAGER_ID y LOCATION_ID
-- se establecieron con valores NULL.
--
-- IMPORTANTE:
-- Esta instruccion ya fue ejecutada.
-- NO repetirla, pues podria generar
-- registros duplicados en DEPARTMENTS2.

INSERT ALL
    INTO departments2 (
        department_id,
        department_name,
        manager_id,
        location_id
    )
    VALUES (
        9901,
        'Departamento Prueba 1',
        NULL,
        NULL
    )

    INTO departments2 (
        department_id,
        department_name,
        manager_id,
        location_id
    )
    VALUES (
        9902,
        'Departamento Prueba 2',
        NULL,
        NULL
    )

    INTO departments2 (
        department_id,
        department_name,
        manager_id,
        location_id
    )
    VALUES (
        9903,
        'Departamento Prueba 3',
        NULL,
        NULL
    )
SELECT 1
FROM dual;


-- =====================================================
-- PASO 6. VERIFICAR LOS DEPARTAMENTOS INSERTADOS
-- =====================================================
-- Consultar los tres departamentos adicionales
-- identificados con los codigos 9901, 9902 y 9903.
--
-- RESULTADO ESPERADO:
-- Tres registros con los nombres asignados
-- durante la insercion original.

SELECT
    department_id,
    department_name,
    manager_id,
    location_id
FROM departments2
WHERE department_id IN (9901, 9902, 9903)
ORDER BY
    department_id;


-- =====================================================
-- PASO 7. COMPROBAR EL TOTAL DE REGISTROS
-- =====================================================
-- Verificar la cantidad de registros despues
-- de incorporar los tres departamentos.
--
-- RESULTADO OBTENIDO:
-- TOTAL_DEPARTMENTS2 = 30.

SELECT
    COUNT(*) AS total_departments2
FROM departments2;


-- =====================================================
-- PASO 8. CONFIRMAR LAS INSERCIONES
-- =====================================================
-- Confirmar los tres registros insertados
-- durante la ejecucion original del laboratorio.
--
-- COMMIT hace permanentes los cambios pendientes
-- de la transaccion.
--
-- IMPORTANTE:
-- Este COMMIT ya fue ejecutado.
-- NO repetirlo en la sesion actual, porque
-- podria confirmar otros cambios pendientes.

COMMIT;


-- =====================================================
-- PASO 9. CERRAR Y RESTABLECER LA SESION
-- =====================================================
-- OBJETIVO:
-- Comprobar la permanencia de los registros
-- confirmados despues de finalizar la sesion.
--
-- PROCEDIMIENTO REALIZADO:
--
-- 1. Desconectar HR_Local_XE desde SQL Developer.
-- 2. Establecer nuevamente la conexion HR_Local_XE.
-- 3. Abrir una nueva hoja de trabajo SQL.
-- 4. Ejecutar las consultas de los pasos 10 y 11.
--
-- IMPORTANTE:
-- El cierre y la nueva conexion se realizan
-- manualmente desde Oracle SQL Developer.
--
-- No se utiliza ninguna instruccion SQL
-- adicional para finalizar la sesion.
-- =====================================================


-- =====================================================
-- PASO 10. CONSULTAR LOS DATOS EN LA NUEVA SESION
-- =====================================================
-- Verificar que los departamentos 9901,
-- 9902 y 9903 permanecen almacenados
-- despues de establecer una nueva conexion.
--
-- RESULTADO OBTENIDO:
-- Los tres departamentos conservaron
-- sus identificadores y nombres originales.

SELECT
    department_id,
    department_name
FROM departments2
WHERE department_id IN (9901, 9902, 9903)
ORDER BY
    department_id;


-- =====================================================
-- PASO 11. COMPROBAR LA PERSISTENCIA
-- =====================================================
-- Consultar nuevamente el total de registros
-- almacenados en DEPARTMENTS2.
--
-- RESULTADO OBTENIDO:
-- TOTAL_FINAL = 30.

SELECT
    COUNT(*) AS total_final
FROM departments2;


-- =====================================================
-- RESULTADO OBTENIDO EN EL LABORATORIO
-- =====================================================
-- Se creo la tabla DEPARTMENTS2 a partir
-- de los datos existentes en DEPARTMENTS.
--
-- REGISTROS ORIGINALES:
-- 27 departamentos.
--
-- REGISTROS ADICIONALES:
-- Departamento 9901: Departamento Prueba 1.
-- Departamento 9902: Departamento Prueba 2.
-- Departamento 9903: Departamento Prueba 3.
--
-- TOTAL FINAL:
-- 30 registros.
--
-- Los tres departamentos adicionales fueron
-- confirmados mediante COMMIT.
--
-- Posteriormente, se desconecto la sesion HR
-- y se establecio una nueva conexion.
--
-- La consulta realizada en la nueva sesion
-- confirmo que los tres registros persistian
-- y que DEPARTMENTS2 conservaba 30 registros.
--
-- CONCLUSION:
-- La prueba permitio comprobar que los cambios
-- confirmados mediante COMMIT permanecen
-- disponibles despues de finalizar la sesion.
--
-- OBSERVACION:
-- CREATE TABLE AS SELECT no reproduce
-- automaticamente todos los indices y
-- restricciones de la tabla original.
--
-- ADVERTENCIA:
-- Para verificar el estado actual, ejecutar
-- solamente las consultas SELECT de los
-- pasos 1, 2, 4, 6, 7, 10 y 11.
--
-- No volver a ejecutar los pasos 3, 5 y 8.
-- =====================================================
-- FIN DEL ARCHIVO: 09_creacion_departments2.sql
-- =====================================================

