
-- =====================================================
-- UNIVERSIDAD INTERNACIONAL DE LA RIOJA (UNIR)
-- ASIGNATURA: BASES DE DATOS AVANZADAS
-- ACTIVIDAD 2: INDICES Y RESTRICCIONES EN ORACLE
-- =====================================================
-- ARCHIVO: 11_ejemplo_rollback.sql
-- DESCRIPCION:
-- Demostrar el funcionamiento de SAVEPOINT,
-- ROLLBACK TO SAVEPOINT y ROLLBACK mediante
-- modificaciones temporales de los departamentos
-- 9902 y 9903 de la tabla DEPARTMENTS2.
--
-- ENTORNO: Oracle Database 21c XE
-- CONEXION: HR_Local_XE
-- CONTENEDOR: XEPDB1
--
-- TIPO DE OPERACION:
-- Consultas SELECT, modificaciones UPDATE
-- y control transaccional.
--
-- REQUISITOS PREVIOS:
-- La tabla DEPARTMENTS2 debe existir.
-- Los departamentos 9902 y 9903 deben conservar
-- sus nombres originales.
--
-- IMPORTANTE:
-- Este archivo documenta una prueba ya realizada.
--
-- Ejecutar todos los pasos en la misma sesion.
-- Mantener desactivado Autocommit.
--
-- No ejecutar COMMIT ni instrucciones DDL
-- entre los puntos de restauracion.
--
-- No realizar la prueba si existen otras
-- modificaciones pendientes en la sesion.
--
-- ROLLBACK sin SAVEPOINT deshace todos los
-- cambios pendientes de la transaccion actual.
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
-- PASO 2. CONSULTAR LOS VALORES ORIGINALES
-- =====================================================
-- Verificar los nombres de los departamentos
-- antes de realizar las modificaciones.
--
-- RESULTADOS ORIGINALES:
-- 9902: Departamento Prueba 2.
-- 9903: Departamento Prueba 3.

SELECT
    department_id,
    department_name
FROM departments2
WHERE department_id IN (9902, 9903)
ORDER BY
    department_id;


-- =====================================================
-- PASO 3. CREAR EL PRIMER PUNTO DE RESTAURACION
-- =====================================================
-- Establecer un punto de restauracion previo
-- a las modificaciones temporales.
--
-- SAVEPOINT identifica una posicion dentro
-- de la transaccion actual.
--
-- IMPORTANTE:
-- El SAVEPOINT no confirma las operaciones
-- ni finaliza la transaccion.

SAVEPOINT inicio_prueba;


-- =====================================================
-- PASO 4. MODIFICAR EL PRIMER DEPARTAMENTO
-- =====================================================
-- Cambiar temporalmente el nombre del
-- departamento 9902.
--
-- VALOR ORIGINAL:
-- Departamento Prueba 2.
--
-- VALOR TEMPORAL:
-- Cambio Temporal A.
--
-- RESULTADO OBTENIDO:
-- 1 fila actualizada.

UPDATE departments2
SET department_name = 'Cambio Temporal A'
WHERE department_id = 9902;


-- =====================================================
-- PASO 5. CREAR EL SEGUNDO PUNTO DE RESTAURACION
-- =====================================================
-- Establecer un nuevo punto de restauracion
-- despues del primer UPDATE y antes del segundo.
--
-- Este SAVEPOINT permitira revertir solamente
-- los cambios realizados a partir de este punto.
--
-- La primera modificacion permanecera pendiente.

SAVEPOINT antes_segundo_cambio;


-- =====================================================
-- PASO 6. MODIFICAR EL SEGUNDO DEPARTAMENTO
-- =====================================================
-- Cambiar temporalmente el nombre del
-- departamento 9903.
--
-- VALOR ORIGINAL:
-- Departamento Prueba 3.
--
-- VALOR TEMPORAL:
-- Cambio Temporal B.
--
-- RESULTADO OBTENIDO:
-- 1 fila actualizada.

UPDATE departments2
SET department_name = 'Cambio Temporal B'
WHERE department_id = 9903;


-- =====================================================
-- PASO 7. VERIFICAR LOS CAMBIOS TEMPORALES
-- =====================================================
-- Consultar los dos departamentos modificados.
--
-- RESULTADOS OBTENIDOS:
-- 9902: Cambio Temporal A.
-- 9903: Cambio Temporal B.
--
-- Ambos cambios permanecen sin confirmar.

SELECT
    department_id,
    department_name
FROM departments2
WHERE department_id IN (9902, 9903)
ORDER BY
    department_id;


-- =====================================================
-- PASO 8. REALIZAR UNA REVERSION PARCIAL
-- =====================================================
-- Deshacer los cambios posteriores al
-- SAVEPOINT antes_segundo_cambio.
--
-- Esta operacion revierte el segundo UPDATE,
-- correspondiente al departamento 9903.
--
-- El primer UPDATE permanece pendiente.
--
-- IMPORTANTE:
-- ROLLBACK TO no finaliza la transaccion.

ROLLBACK TO antes_segundo_cambio;


-- =====================================================
-- PASO 9. COMPROBAR LA REVERSION PARCIAL
-- =====================================================
-- Consultar los departamentos despues de
-- ejecutar ROLLBACK TO SAVEPOINT.
--
-- RESULTADOS OBTENIDOS:
-- 9902: Cambio Temporal A.
-- 9903: Departamento Prueba 3.
--
-- Se comprobo que solamente la segunda
-- modificacion fue revertida.

SELECT
    department_id,
    department_name
FROM departments2
WHERE department_id IN (9902, 9903)
ORDER BY
    department_id;


-- =====================================================
-- PASO 10. REALIZAR UNA REVERSION COMPLETA
-- =====================================================
-- Deshacer los cambios pendientes de la
-- transaccion mediante ROLLBACK.
--
-- Esta operacion revierte el primer UPDATE,
-- correspondiente al departamento 9902.
--
-- IMPORTANTE:
-- ROLLBACK finaliza la transaccion actual
-- y deshace todos sus cambios no confirmados.

ROLLBACK;


-- =====================================================
-- PASO 11. COMPROBAR LOS VALORES ORIGINALES
-- =====================================================
-- Consultar nuevamente los departamentos
-- para verificar que ambos recuperaron
-- sus nombres originales.
--
-- RESULTADOS OBTENIDOS:
-- 9902: Departamento Prueba 2.
-- 9903: Departamento Prueba 3.
--
-- Esta consulta confirma que la transaccion
-- fue revertida completamente.

SELECT
    department_id,
    department_name
FROM departments2
WHERE department_id IN (9902, 9903)
ORDER BY
    department_id;


-- =====================================================
-- RESULTADO OBTENIDO EN EL LABORATORIO
-- =====================================================
-- ETAPA 1. MODIFICACIONES TEMPORALES:
--
-- Departamento 9902:
-- Cambio Temporal A.
--
-- Departamento 9903:
-- Cambio Temporal B.
--
-- ETAPA 2. ROLLBACK TO SAVEPOINT:
--
-- Departamento 9902:
-- Cambio Temporal A.
--
-- Departamento 9903:
-- Departamento Prueba 3.
--
-- ETAPA 3. ROLLBACK COMPLETO:
--
-- Departamento 9902:
-- Departamento Prueba 2.
--
-- Departamento 9903:
-- Departamento Prueba 3.
--
-- CONCLUSION:
-- ROLLBACK TO SAVEPOINT permitio deshacer
-- parcialmente los cambios de la transaccion.
--
-- ROLLBACK sin especificar un SAVEPOINT
-- permitio revertir todos los cambios
-- pendientes y finalizar la transaccion.
--
-- Los departamentos recuperaron sus
-- nombres originales.
--
-- OBSERVACION:
-- SAVEPOINT no genera una transaccion
-- independiente ni confirma los datos.
--
-- ADVERTENCIA:
-- La prueba original ya fue completada.
--
-- Para consultar el estado actual de los
-- departamentos, ejecutar solamente los
-- SELECT de los pasos 1, 2 y 11.
--
-- No repetir los UPDATE ni las operaciones
-- transaccionales si existen otros cambios
-- pendientes en la sesion.
-- =====================================================
-- FIN DEL ARCHIVO: 11_ejemplo_rollback.sql
-- =====================================================

