
-- =====================================================
-- UNIVERSIDAD INTERNACIONAL DE LA RIOJA (UNIR)
-- ASIGNATURA: BASES DE DATOS AVANZADAS
-- ACTIVIDAD 2: INDICES Y RESTRICCIONES EN ORACLE
-- =====================================================
-- ARCHIVO: 04_estado_original_restricciones.sql
-- DESCRIPCION:
-- Registrar el estado de las restricciones de
-- integridad de las tablas EMPLOYEES, DEPARTMENTS
-- y JOB_HISTORY del esquema HR, antes de realizar
-- las pruebas de desactivacion.
--
-- ENTORNO: Oracle Database 21c XE
-- CONEXION: HR_Local_XE
-- CONTENEDOR: XEPDB1
--
-- TIPO DE OPERACION: Solo lectura (SELECT).
--
-- IMPORTANTE:
-- Conservar los resultados iniciales como evidencia
-- para comparar el estado de las restricciones
-- despues de completar su restauracion.
-- =====================================================


-- =====================================================
-- PASO 1. VERIFICAR EL CONTEXTO DE CONEXION
-- =====================================================
-- Comprobar que la consulta se ejecuta con
-- el usuario HR en el contenedor XEPDB1.

SELECT
    USER AS usuario,
    SYS_CONTEXT('USERENV', 'CON_NAME') AS contenedor
FROM dual;


-- =====================================================
-- PASO 2. REGISTRAR EL ESTADO DE LAS RESTRICCIONES
-- =====================================================
-- Consultar las restricciones correspondientes
-- a EMPLOYEES, DEPARTMENTS y JOB_HISTORY.
--
-- USER_CONSTRAINTS:
-- Contiene informacion sobre las restricciones
-- de integridad definidas en el esquema.
--
-- CAMPOS CONSULTADOS:
-- TABLE_NAME:
-- Tabla a la que pertenece la restriccion.
--
-- CONSTRAINT_NAME:
-- Nombre de la restriccion.
--
-- CONSTRAINT_TYPE:
-- Tipo de restriccion (P, R, U, C, entre otros).
--
-- STATUS:
-- Indica si esta ENABLED o DISABLED.
--
-- VALIDATED:
-- Indica el estado de validacion de los datos.
--
-- INDEX_NAME:
-- Nombre del indice asociado, cuando corresponde.
--
-- R_CONSTRAINT_NAME:
-- Nombre de la restriccion primaria o unica
-- referenciada por una clave foranea.
--
-- IMPORTANTE:
-- Algunos campos pueden contener valores NULL
-- dependiendo del tipo de restriccion.

SELECT
    table_name AS tabla,
    constraint_name AS restriccion,
    constraint_type AS tipo,
    status AS estado,
    validated AS validacion,
    index_name AS indice_asociado,
    r_constraint_name AS clave_referenciada
FROM user_constraints
WHERE table_name IN (
    'EMPLOYEES',
    'DEPARTMENTS',
    'JOB_HISTORY'
)
ORDER BY
    table_name,
    constraint_name;


-- =====================================================
-- RESULTADO OBTENIDO EN EL LABORATORIO
-- =====================================================
-- Se registraron 23 restricciones correspondientes
-- a las tablas EMPLOYEES, DEPARTMENTS y JOB_HISTORY.
--
-- Distribucion de las restricciones:
-- EMPLOYEES y DEPARTMENTS: 14 restricciones.
-- JOB_HISTORY: 9 restricciones.
--
-- En el diagnostico inicial, todas las restricciones
-- se encontraban en estado ENABLED VALIDATED.
--
-- Este registro sirvio como referencia para
-- comprobar la restauracion posterior de las
-- restricciones de integridad.
--
-- OBSERVACION:
-- La consulta muestra el estado de las restricciones
-- en el momento de su ejecucion.
-- No conserva automaticamente un historial.
--
-- Este procedimiento no modifica la base de datos.
-- =====================================================
-- FIN DEL ARCHIVO: 04_estado_original_restricciones.sql
-- =====================================================

