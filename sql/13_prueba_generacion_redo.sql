
-- =====================================================
-- UNIVERSIDAD INTERNACIONAL DE LA RIOJA (UNIR)
-- ASIGNATURA: BASES DE DATOS AVANZADAS
-- ACTIVIDAD 2: INDICES Y RESTRICCIONES EN ORACLE
-- =====================================================
-- ARCHIVO: 13_prueba_generacion_redo.sql
-- DESCRIPCION:
-- Comprobar experimentalmente la generacion de
-- informacion REDO mediante una modificacion
-- temporal de la tabla DEPARTMENTS2.
--
-- Medir el contador redo size antes y despues
-- de la modificacion y restaurar los datos
-- originales mediante ROLLBACK.
--
-- ENTORNO: Oracle Database 21c XE
-- CONEXION PRINCIPAL: HR_Local_XE
-- CONTENEDOR: XEPDB1
--
-- CONEXION DE DIAGNOSTICO: SYS_Admin_XE
-- USUARIO ADMINISTRATIVO: SYS
-- ROL: SYSDBA
-- CONTENEDOR ADMINISTRATIVO: CDB$ROOT
--
-- TIPO DE OPERACION:
-- Consultas SELECT, modificacion UPDATE,
-- control transaccional y medicion REDO.
--
-- REQUISITOS PREVIOS:
-- La tabla DEPARTMENTS2 debe existir.
-- El departamento 9901 debe conservar
-- el nombre Departamento Prueba 1.
--
-- IMPORTANTE:
-- Este archivo documenta una prueba ya realizada.
--
-- NO ejecutar todo el archivo con F5.
-- Los pasos deben realizarse individualmente.
--
-- Mantener desactivado Autocommit.
-- Mantener abierta la misma sesion HR.
-- No ejecutar COMMIT ni instrucciones DDL
-- durante el experimento.
--
-- No realizar la prueba si existen otras
-- modificaciones pendientes en la sesion.
--
-- La medicion administrativa debe realizarse
-- antes de ejecutar ROLLBACK.
-- =====================================================


-- =====================================================
-- PASO 1. VERIFICAR EL CONTEXTO DE CONEXION
-- =====================================================
-- Comprobar que se utiliza el usuario HR
-- en el contenedor XEPDB1.
--
-- Identificar el SID de la sesion.
--
-- RESULTADO OBTENIDO EN EL LABORATORIO:
-- USUARIO: HR.
-- CONTENEDOR: XEPDB1.
-- SID: 1467.
--
-- IMPORTANTE:
-- El SID puede cambiar al abrir una nueva sesion.

SELECT
    USER AS usuario,
    SYS_CONTEXT('USERENV', 'CON_NAME') AS contenedor,
    SYS_CONTEXT('USERENV', 'SID') AS sid_actual
FROM dual;


-- =====================================================
-- PASO 2. CONSULTAR EL DEPARTAMENTO ORIGINAL
-- =====================================================
-- Verificar el nombre del departamento 9901
-- antes de realizar la modificacion.
--
-- RESULTADO ORIGINAL:
-- DEPARTMENT_ID = 9901.
-- DEPARTMENT_NAME = Departamento Prueba 1.

SELECT
    department_id,
    department_name
FROM departments2
WHERE department_id = 9901;


-- =====================================================
-- PASO 3. REGISTRAR EL VALOR INICIAL DE REDO
-- =====================================================
-- OBJETIVO:
-- Consultar el contador redo size de la sesion HR
-- mediante las vistas dinamicas de Oracle.
--
-- CONEXION REQUERIDA:
-- SYS_Admin_XE.
--
-- V$SESSION:
-- Identifica las sesiones de Oracle.
--
-- V$SESSTAT:
-- Proporciona estadisticas por sesion.
--
-- V$STATNAME:
-- Identifica los nombres de las estadisticas.
--
-- IMPORTANTE:
-- La consulta siguiente permanece comentada
-- porque requiere una conexion administrativa.
--
-- Para reproducir la prueba, copiar la consulta
-- en una hoja de trabajo de SYS_Admin_XE.
--
-- Reemplazar el SID 1467 si la sesion HR cambia.
--
-- RESULTADO INICIAL DEL LABORATORIO:
-- REDO SIZE = 3692 bytes.

/*
SELECT
    s.sid,
    s.username AS usuario,
    n.name AS estadistica,
    st.value AS bytes_redo
FROM v$session s
INNER JOIN v$sesstat st
    ON s.sid = st.sid
INNER JOIN v$statname n
    ON st.statistic# = n.statistic#
WHERE s.sid = 1467
  AND s.username = 'HR'
  AND n.name = 'redo size';
*/


-- =====================================================
-- PASO 4. CREAR EL PUNTO DE RESTAURACION
-- =====================================================
-- Establecer un SAVEPOINT antes de realizar
-- la modificacion temporal.
--
-- Este punto permite deshacer posteriormente
-- el cambio sin conservar modificaciones
-- permanentes en DEPARTMENTS2.
--
-- IMPORTANTE:
-- El SAVEPOINT pertenece a la sesion actual.
-- Se pierde al finalizar la transaccion.

SAVEPOINT antes_prueba_redo;


-- =====================================================
-- PASO 5. REALIZAR UNA MODIFICACION TEMPORAL
-- =====================================================
-- Actualizar el nombre del departamento 9901.
--
-- VALOR ORIGINAL:
-- Departamento Prueba 1.
--
-- VALOR TEMPORAL:
-- Prueba Generacion REDO.
--
-- La condicion adicional del WHERE evita
-- modificar el registro si su nombre original
-- no coincide con el valor esperado.
--
-- RESULTADO OBTENIDO:
-- 1 fila actualizada.
--
-- IMPORTANTE:
-- Esta instruccion ya fue ejecutada.
-- No es necesario repetirla.

UPDATE departments2
SET department_name = 'Prueba Generacion REDO'
WHERE department_id = 9901
  AND department_name = 'Departamento Prueba 1';


-- =====================================================
-- PASO 6. VERIFICAR LA MODIFICACION
-- =====================================================
-- Comprobar que el departamento presenta
-- temporalmente el nuevo nombre.
--
-- RESULTADO OBTENIDO DURANTE LA PRUEBA:
-- DEPARTMENT_ID = 9901.
-- DEPARTMENT_NAME = Prueba Generacion REDO.
--
-- IMPORTANTE:
-- La modificacion permanecio sin confirmar.

SELECT
    department_id,
    department_name
FROM departments2
WHERE department_id = 9901;


-- =====================================================
-- PASO 7. MEDIR EL REDO DESPUES DEL UPDATE
-- =====================================================
-- OBJETIVO:
-- Comparar el contador redo size antes y
-- despues de la modificacion temporal.
--
-- CONEXION REQUERIDA:
-- SYS_Admin_XE.
--
-- IMPORTANTE:
-- Mantener abierta la sesion HR.
--
-- No ejecutar COMMIT ni ROLLBACK antes
-- de registrar esta segunda medicion.
--
-- La consulta administrativa permanece
-- comentada para evitar su ejecucion
-- accidental desde HR_Local_XE.
--
-- Los valores SID = 1467 y 3692 bytes
-- corresponden exclusivamente a la prueba
-- realizada durante este laboratorio.
--
-- En una nueva prueba deben sustituirse
-- por el SID y la medicion inicial reales.

/*
SELECT
    s.sid,
    s.username AS usuario,
    n.name AS estadistica,
    3692 AS bytes_antes,
    st.value AS bytes_despues,
    st.value - 3692 AS diferencia_bytes
FROM v$session s
INNER JOIN v$sesstat st
    ON s.sid = st.sid
INNER JOIN v$statname n
    ON st.statistic# = n.statistic#
WHERE s.sid = 1467
  AND s.username = 'HR'
  AND n.name = 'redo size';
*/


-- =====================================================
-- RESULTADO DE LA MEDICION REDO
-- =====================================================
-- SID: 1467.
--
-- ESTADISTICA:
-- redo size.
--
-- BYTES_ANTES:
-- 3692.
--
-- BYTES_DESPUES:
-- 4508.
--
-- DIFERENCIA_BYTES:
-- 816.
--
-- INTERPRETACION:
-- Se observo un incremento de 816 bytes
-- en el contador REDO de la sesion HR.
--
-- Esta medicion representa el incremento
-- acumulado durante el intervalo observado.
--
-- No permite atribuir necesariamente todos
-- los bytes a una unica instruccion UPDATE.
--
-- La estadistica no representa el tamano
-- total de los archivos fisicos REDO.
-- =====================================================


-- =====================================================
-- PASO 8. REVERTIR LA MODIFICACION TEMPORAL
-- =====================================================
-- Regresar a la misma conexion HR_Local_XE.
--
-- Ejecutar ROLLBACK TO para deshacer los
-- cambios posteriores al SAVEPOINT.
--
-- IMPORTANTE:
-- Esta instruccion debe ejecutarse despues
-- de registrar la segunda medicion REDO.
--
-- ROLLBACK TO no finaliza la transaccion.
--
-- Esta operacion ya fue realizada durante
-- el laboratorio.

ROLLBACK TO antes_prueba_redo;


-- =====================================================
-- PASO 9. FINALIZAR LA TRANSACCION
-- =====================================================
-- Ejecutar ROLLBACK para finalizar la
-- transaccion actual.
--
-- IMPORTANTE:
-- ROLLBACK sin SAVEPOINT deshace todos los
-- cambios pendientes de la transaccion.
--
-- No ejecutar si existen modificaciones
-- ajenas al laboratorio sin confirmar.
--
-- La operacion ya fue realizada.

ROLLBACK;


-- =====================================================
-- PASO 10. VERIFICAR EL VALOR ORIGINAL
-- =====================================================
-- Consultar nuevamente el departamento 9901.
--
-- RESULTADO FINAL OBTENIDO:
-- DEPARTMENT_ID = 9901.
-- DEPARTMENT_NAME = Departamento Prueba 1.
--
-- La consulta confirma que el cambio temporal
-- fue revertido correctamente.

SELECT
    department_id,
    department_name
FROM departments2
WHERE department_id = 9901;


-- =====================================================
-- RESULTADO OBTENIDO EN EL LABORATORIO
-- =====================================================
-- CONEXION DE MODIFICACION:
-- HR_Local_XE.
--
-- CONEXION ADMINISTRATIVA:
-- SYS_Admin_XE.
--
-- SESION HR:
-- SID 1467.
--
-- VALOR INICIAL DE REDO:
-- 3692 bytes.
--
-- VALOR POSTERIOR DE REDO:
-- 4508 bytes.
--
-- INCREMENTO OBSERVADO:
-- 816 bytes.
--
-- MODIFICACION REALIZADA:
-- Departamento 9901.
-- Nombre temporal: Prueba Generacion REDO.
--
-- REVERSION:
-- ROLLBACK TO antes_prueba_redo.
-- ROLLBACK.
--
-- VALOR FINAL:
-- Departamento Prueba 1.
--
-- CONCLUSION:
-- La prueba permitio observar un incremento
-- en la estadistica redo size durante una
-- modificacion de datos.
--
-- Posteriormente, ROLLBACK permitio recuperar
-- el nombre original del departamento.
--
-- Los registros REDO previamente generados
-- no se eliminan al ejecutar ROLLBACK.
--
-- OBSERVACION:
-- Las consultas administrativas de medicion
-- se documentaron como bloques comentados.
--
-- Deben ejecutarse separadamente desde
-- SYS_Admin_XE cuando se reproduzca la prueba.
--
-- ADVERTENCIA:
-- El experimento ya fue completado.
--
-- Para comprobar el estado actual, ejecutar
-- solamente los SELECT de los pasos 1, 2 y 10.
--
-- No repetir UPDATE, SAVEPOINT ni ROLLBACK
-- si existen otros cambios pendientes.
-- =====================================================
-- FIN DEL ARCHIVO: 13_prueba_generacion_redo.sql
-- =====================================================

