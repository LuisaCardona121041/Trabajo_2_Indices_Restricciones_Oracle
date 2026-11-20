
-- =====================================================
-- UNIVERSIDAD INTERNACIONAL DE LA RIOJA (UNIR)
-- ASIGNATURA: BASES DE DATOS AVANZADAS
-- ACTIVIDAD 2: INDICES Y RESTRICCIONES EN ORACLE
-- =====================================================
-- ARCHIVO: 06_desactivar_restricciones_restantes.sql
-- DESCRIPCION:
-- Desactivar temporalmente las restricciones
-- restantes de las tablas EMPLOYEES y DEPARTMENTS
-- del esquema HR, conservando los indices asociados
-- cuando corresponda mediante KEEP INDEX.
--
-- ENTORNO: Oracle Database 21c XE
-- CONEXION: HR_Local_XE
-- CONTENEDOR: XEPDB1
--
-- TIPO DE OPERACION:
-- Modificacion de restricciones (DDL) y
-- consultas de verificacion (SELECT).
--
-- REQUISITO PREVIO:
-- Las siete claves foraneas del procedimiento
-- 05_desactivar_claves_foraneas.sql deben
-- encontrarse previamente desactivadas.
--
-- IMPORTANTE:
-- Este archivo documenta operaciones realizadas
-- durante el laboratorio.
--
-- NO ejecutar nuevamente las instrucciones
-- ALTER TABLE sobre el esquema restaurado.
--
-- Las operaciones DDL generan COMMIT implicitos
-- y no pueden revertirse mediante ROLLBACK.
--
-- La restauracion se documenta en el archivo
-- 08_restaurar_restricciones.sql.
-- =====================================================


-- =====================================================
-- PASO 1. VERIFICAR EL CONTEXTO DE CONEXION
-- =====================================================
-- Comprobar que las operaciones se realizan con
-- el usuario HR en el contenedor XEPDB1.

SELECT
    USER AS usuario,
    SYS_CONTEXT('USERENV', 'CON_NAME') AS contenedor
FROM dual;


-- =====================================================
-- PASO 2. DESACTIVAR RESTRICCIONES DE DEPARTMENTS
-- =====================================================
-- Desactivar la clave primaria y la restriccion
-- NOT NULL correspondiente al nombre.
--
-- KEEP INDEX conserva el indice asociado a la
-- clave primaria.
--
-- IMPORTANTE:
-- Estas instrucciones ya fueron ejecutadas.
-- No repetirlas en el entorno restaurado.

-- Desactivar clave primaria.
ALTER TABLE departments
DISABLE CONSTRAINT DEPT_ID_PK KEEP INDEX;

-- Desactivar restriccion NOT NULL del nombre.
ALTER TABLE departments
DISABLE CONSTRAINT DEPT_NAME_NN;


-- =====================================================
-- PASO 3. DESACTIVAR RESTRICCIONES DE EMPLOYEES
-- =====================================================
-- Desactivar la clave primaria, la restriccion
-- de unicidad, las condiciones NOT NULL y
-- la restriccion CHECK del salario.
--
-- IMPORTANTE:
-- KEEP INDEX conserva los indices asociados a
-- EMP_EMP_ID_PK y EMP_EMAIL_UK.
--
-- Un indice unico conservado puede continuar
-- impidiendo la insercion de valores duplicados,
-- aunque la restriccion se encuentre desactivada.
--
-- Estas instrucciones ya fueron ejecutadas.
-- No repetirlas en el entorno restaurado.

-- Desactivar clave primaria.
ALTER TABLE employees
DISABLE CONSTRAINT EMP_EMP_ID_PK KEEP INDEX;

-- Desactivar restriccion de unicidad del correo.
ALTER TABLE employees
DISABLE CONSTRAINT EMP_EMAIL_UK KEEP INDEX;

-- Desactivar restriccion NOT NULL del correo.
ALTER TABLE employees
DISABLE CONSTRAINT EMP_EMAIL_NN;

-- Desactivar restriccion NOT NULL de fecha.
ALTER TABLE employees
DISABLE CONSTRAINT EMP_HIRE_DATE_NN;

-- Desactivar restriccion NOT NULL del trabajo.
ALTER TABLE employees
DISABLE CONSTRAINT EMP_JOB_NN;

-- Desactivar restriccion NOT NULL del apellido.
ALTER TABLE employees
DISABLE CONSTRAINT EMP_LAST_NAME_NN;

-- Desactivar restriccion CHECK del salario.
ALTER TABLE employees
DISABLE CONSTRAINT EMP_SALARY_MIN;


-- =====================================================
-- PASO 4. VERIFICAR EL ESTADO DE LAS RESTRICCIONES
-- =====================================================
-- Consultar el estado y la validacion de las
-- restricciones de EMPLOYEES y DEPARTMENTS.
--
-- RESULTADO ESPERADO DURANTE LA DESACTIVACION:
-- 14 restricciones en estado DISABLED, al incluir
-- las claves foraneas desactivadas previamente.
--
-- OBSERVACION:
-- Si esta consulta se ejecuta despues de completar
-- la restauracion del laboratorio, las restricciones
-- deben aparecer nuevamente en estado ENABLED.

SELECT
    table_name AS tabla,
    constraint_name AS restriccion,
    constraint_type AS tipo,
    status AS estado,
    validated AS validacion
FROM user_constraints
WHERE table_name IN (
    'EMPLOYEES',
    'DEPARTMENTS'
)
ORDER BY
    table_name,
    constraint_name;


-- =====================================================
-- PASO 5. CONSULTAR EL RESUMEN GENERAL
-- =====================================================
-- Agrupar las restricciones de EMPLOYEES,
-- DEPARTMENTS y JOB_HISTORY segun su estado
-- y condicion de validacion.
--
-- RESULTADO ESPERADO DURANTE LA DESACTIVACION:
-- 16 restricciones DISABLED en total.
-- 7 restricciones ENABLED de JOB_HISTORY.
--
-- IMPORTANTE:
-- El resultado corresponde al estado de la base
-- de datos en el momento de ejecutar la consulta.

SELECT
    table_name AS tabla,
    status AS estado,
    validated AS validacion,
    COUNT(*) AS cantidad
FROM user_constraints
WHERE table_name IN (
    'EMPLOYEES',
    'DEPARTMENTS',
    'JOB_HISTORY'
)
GROUP BY
    table_name,
    status,
    validated
ORDER BY
    table_name,
    status;


-- =====================================================
-- RESULTADO OBTENIDO EN EL LABORATORIO
-- =====================================================
-- Se desactivaron 9 restricciones adicionales:
--
-- DEPARTMENTS:
-- DEPT_ID_PK
-- DEPT_NAME_NN
--
-- EMPLOYEES:
-- EMP_EMP_ID_PK
-- EMP_EMAIL_UK
-- EMP_EMAIL_NN
-- EMP_HIRE_DATE_NN
-- EMP_JOB_NN
-- EMP_LAST_NAME_NN
-- EMP_SALARY_MIN
--
-- RESULTADO ACUMULADO:
-- 7 claves foraneas desactivadas en el archivo 05.
-- 9 restricciones desactivadas en este archivo.
-- Total: 16 restricciones desactivadas.
--
-- Permanecieron habilitadas 7 restricciones
-- de la tabla JOB_HISTORY.
--
-- OBSERVACION:
-- La conservacion del indice unico asociado
-- a EMP_EMAIL_UK explica que una insercion
-- duplicada produjera el error ORA-00001
-- durante las pruebas posteriores.
--
-- ESTADO FINAL DEL LABORATORIO:
-- Todas las restricciones fueron restauradas
-- posteriormente mediante ENABLE VALIDATE.
--
-- Las 23 restricciones verificadas quedaron
-- nuevamente en estado ENABLED VALIDATED.
--
-- ADVERTENCIA:
-- Para consultar el estado actual, ejecutar
-- unicamente los SELECT de los pasos 1, 4 y 5.
--
-- No volver a ejecutar los pasos 2 y 3.
-- =====================================================
-- FIN DEL ARCHIVO: 06_desactivar_restricciones_restantes.sql
-- =====================================================

