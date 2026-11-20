
-- =====================================================
-- UNIVERSIDAD INTERNACIONAL DE LA RIOJA (UNIR)
-- ASIGNATURA: BASES DE DATOS AVANZADAS
-- ACTIVIDAD 2: INDICES Y RESTRICCIONES EN ORACLE
-- =====================================================
-- ARCHIVO: 10_bloque_anonimo_transaccion.sql
-- DESCRIPCION:
-- Demostrar el control de una transaccion mediante
-- un bloque anonimo PL/SQL sobre DEPARTMENTS2.
--
-- Realizar una modificacion temporal, mostrar
-- mensajes de inicio y finalizacion y revertir
-- los cambios mediante ROLLBACK.
--
-- ENTORNO: Oracle Database 21c XE
-- CONEXION: HR_Local_XE
-- CONTENEDOR: XEPDB1
--
-- TIPO DE OPERACION:
-- Consultas SELECT, modificacion UPDATE,
-- bloque PL/SQL y control transaccional.
--
-- REQUISITOS PREVIOS:
-- La tabla DEPARTMENTS2 debe existir.
-- El departamento 9901 debe estar disponible.
--
-- IMPORTANTE:
-- Este archivo documenta una prueba ya realizada.
--
-- El ROLLBACK deshace todos los cambios pendientes
-- de la transaccion actual, no solamente el UPDATE
-- incluido en este procedimiento.
--
-- No ejecutar el bloque si existen otras
-- modificaciones pendientes en la sesion.
--
-- Los mensajes DBMS_OUTPUT son informativos;
-- no inician ni finalizan transacciones.
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
-- PASO 2. HABILITAR LA SALIDA DE MENSAJES
-- =====================================================
-- Permitir visualizar los mensajes generados
-- mediante DBMS_OUTPUT.PUT_LINE.
--
-- Ejecutar el archivo en modo script (F5)
-- para visualizar correctamente la salida.

SET SERVEROUTPUT ON;


-- =====================================================
-- PASO 3. CONSULTAR EL VALOR ORIGINAL
-- =====================================================
-- Verificar el nombre del departamento 9901
-- antes de ejecutar la modificacion temporal.
--
-- RESULTADO OBTENIDO:
-- Departamento Prueba 1.

SELECT
    department_id,
    department_name
FROM departments2
WHERE department_id = 9901;


-- =====================================================
-- PASO 4. EJECUTAR EL BLOQUE ANONIMO PL/SQL
-- =====================================================
-- OBJETIVO:
-- Actualizar temporalmente el departamento 9901,
-- consultar el valor modificado y revertir
-- los cambios pendientes mediante ROLLBACK.
--
-- DECLARE:
-- Define una variable para almacenar el nombre.
--
-- BEGIN:
-- Contiene las instrucciones del procedimiento.
--
-- EXCEPTION:
-- Gestiona posibles errores de ejecucion.
--
-- IMPORTANTE:
-- El ROLLBACK tambien revierte otras operaciones
-- no confirmadas de la transaccion actual.
--
-- La prueba ya fue ejecutada satisfactoriamente.
-- No es necesario repetirla.
-- =====================================================

DECLARE
    v_nombre VARCHAR2(100);

BEGIN

    -- Mostrar mensaje informativo de inicio.
    DBMS_OUTPUT.PUT_LINE(
        'INICIO DE LA TRANSACCION'
    );

    -- Modificar temporalmente el departamento.
    UPDATE departments2
    SET department_name = 'Departamento Temporal'
    WHERE department_id = 9901;

    -- Mostrar la cantidad de filas modificadas.
    DBMS_OUTPUT.PUT_LINE(
        'Filas modificadas: ' || SQL%ROWCOUNT
    );

    -- Consultar el valor durante la transaccion.
    SELECT
        department_name
    INTO
        v_nombre
    FROM departments2
    WHERE department_id = 9901;

    -- Mostrar el nombre temporal del departamento.
    DBMS_OUTPUT.PUT_LINE(
        'Valor temporal: ' || v_nombre
    );

    -- Revertir los cambios no confirmados.
    ROLLBACK;

    -- Confirmar mediante un mensaje la reversion.
    DBMS_OUTPUT.PUT_LINE(
        'ROLLBACK ejecutado correctamente'
    );

    -- Mostrar mensaje informativo de finalizacion.
    DBMS_OUTPUT.PUT_LINE(
        'FIN DE LA TRANSACCION'
    );

EXCEPTION

    WHEN OTHERS THEN

        -- Revertir cambios pendientes ante un error.
        ROLLBACK;

        -- Mostrar el mensaje de error correspondiente.
        DBMS_OUTPUT.PUT_LINE(
            'Error: ' || SQLERRM
        );

        -- Propagar el error para su identificacion.
        RAISE;

END;
/


-- =====================================================
-- PASO 5. COMPROBAR EL VALOR ORIGINAL
-- =====================================================
-- Consultar nuevamente el departamento 9901
-- para verificar que ROLLBACK deshizo el UPDATE.
--
-- RESULTADO ESPERADO:
-- DEPARTMENT_ID = 9901.
-- DEPARTMENT_NAME = Departamento Prueba 1.
--
-- Esta consulta es de solo lectura.

SELECT
    department_id,
    department_name
FROM departments2
WHERE department_id = 9901;


-- =====================================================
-- RESULTADO OBTENIDO EN EL LABORATORIO
-- =====================================================
-- El bloque PL/SQL se ejecuto correctamente.
--
-- Se visualizaron los siguientes mensajes:
--
-- INICIO DE LA TRANSACCION
-- Filas modificadas: 1
-- Valor temporal: Departamento Temporal
-- ROLLBACK ejecutado correctamente
-- FIN DE LA TRANSACCION
--
-- La modificacion temporal afecto una fila.
--
-- Posteriormente, ROLLBACK revirtio el cambio
-- y el departamento 9901 recupero su nombre:
-- Departamento Prueba 1.
--
-- La prueba permitio comprobar el control
-- transaccional mediante un bloque anonimo
-- PL/SQL y la instruccion ROLLBACK.
--
-- OBSERVACION:
-- DBMS_OUTPUT.PUT_LINE presenta mensajes,
-- pero no controla el inicio ni la finalizacion
-- tecnica de las transacciones.
--
-- ADVERTENCIA:
-- Para comprobar el estado actual de los datos,
-- ejecutar solamente los SELECT de los
-- pasos 1, 3 y 5.
--
-- No ejecutar nuevamente el bloque PL/SQL
-- si existen cambios pendientes en la sesion.
-- =====================================================
-- FIN DEL ARCHIVO: 10_bloque_anonimo_transaccion.sql
-- =====================================================

