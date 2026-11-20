
-- =====================================================
-- UNIVERSIDAD INTERNACIONAL DE LA RIOJA (UNIR)
-- ASIGNATURA: BASES DE DATOS AVANZADAS
-- ACTIVIDAD 2: INDICES Y RESTRICCIONES EN ORACLE
-- =====================================================
-- ARCHIVO: 07_inserciones_invalidas.sql
-- DESCRIPCION:
-- Comprobar el comportamiento de Oracle al insertar
-- registros que incumplen restricciones previamente
-- desactivadas en EMPLOYEES y DEPARTMENTS.
--
-- Documentar la reversión de cambios, el error
-- ORA-00001 y la verificacion de integridad de
-- los datos originales mediante respaldos.
--
-- ENTORNO: Oracle Database 21c XE
-- CONEXION: HR_Local_XE
-- CONTENEDOR: XEPDB1
--
-- TIPO DE OPERACION:
-- Consultas SELECT, inserciones INSERT,
-- eliminacion DELETE y control transaccional.
--
-- REQUISITOS PREVIOS DE LA PRUEBA ORIGINAL:
-- Ejecutar los procedimientos de los archivos
-- 05_desactivar_claves_foraneas.sql y
-- 06_desactivar_restricciones_restantes.sql.
--
-- Las tablas de respaldo deben existir.
--
-- IMPORTANTE:
-- Este archivo documenta pruebas ya realizadas.
-- NO ejecutarlo completo nuevamente con F5.
--
-- Los INSERT, DELETE, SAVEPOINT, ROLLBACK y COMMIT
-- deben conservarse como evidencia del ejercicio.
--
-- Para verificar el estado actual de los datos,
-- ejecutar solamente las consultas SELECT.
--
-- Las restricciones originales ya fueron
-- restauradas durante el laboratorio.
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
-- PRUEBA 1. INSERCION INVALIDA EN DEPARTMENTS
-- =====================================================
-- OBJETIVO:
-- Comprobar el efecto de desactivar DEPT_NAME_NN.
--
-- Se utilizo el identificador 9900 para insertar
-- temporalmente un departamento sin nombre.
--
-- IMPORTANTE:
-- Esta prueba ya fue ejecutada y revertida.
-- No repetir las operaciones de modificacion.


-- 1.1. Verificar la ausencia del identificador.

SELECT
    COUNT(*) AS registros_existentes
FROM departments
WHERE department_id = 9900;


-- 1.2. Crear un punto de restauracion.
-- Ejecutado durante la prueba original.

SAVEPOINT antes_prueba_departments;


-- 1.3. Insertar el departamento sin nombre.
-- EJECUTADO ANTERIORMENTE. NO REPETIR.

INSERT INTO departments (
    department_id,
    department_name,
    manager_id,
    location_id
)
VALUES (
    9900,
    NULL,
    NULL,
    NULL
);


-- 1.4. Verificar la insercion realizada.

SELECT
    department_id,
    department_name,
    manager_id,
    location_id
FROM departments
WHERE department_id = 9900;


-- RESULTADO OBSERVADO DURANTE LA PRUEBA:
-- DEPARTMENT_ID = 9900
-- DEPARTMENT_NAME = NULL
--
-- Oracle permitio la insercion temporal porque
-- la restriccion DEPT_NAME_NN estaba desactivada.


-- 1.5. Revertir la insercion.
-- EJECUTADO ANTERIORMENTE. NO REPETIR.
-- El SAVEPOINT debe existir en la misma sesion.

ROLLBACK TO antes_prueba_departments;


-- 1.6. Comprobar la ausencia del registro.

SELECT
    COUNT(*) AS registros_restantes
FROM departments
WHERE department_id = 9900;


-- RESULTADO OBTENIDO:
-- REGISTROS_RESTANTES = 0


-- =====================================================
-- PRUEBA 2. INSERCION INVALIDA EN EMPLOYEES
-- =====================================================
-- OBJETIVO:
-- Comprobar el efecto de desactivar las
-- restricciones EMP_SALARY_MIN y EMP_DEPT_FK.
--
-- El empleado de prueba contiene:
-- Salario negativo: -100.
-- Departamento inexistente: 9900.
--
-- IMPORTANTE:
-- El registro utilizado ya fue eliminado.
-- No repetir la insercion.


-- 2.1. Comprobar el identificador y correo.

SELECT
    employee_id,
    email
FROM employees
WHERE employee_id = 9900
   OR email = 'PRUEBA9900';


-- 2.2. Crear un punto de restauracion.
-- Ejecutado durante la prueba original.
-- La limpieza final se realizo mediante DELETE.

SAVEPOINT antes_prueba_employees;


-- 2.3. Insertar el empleado con valores invalidos.
-- EJECUTADO ANTERIORMENTE. NO REPETIR.

INSERT INTO employees (
    employee_id,
    first_name,
    last_name,
    email,
    hire_date,
    job_id,
    salary,
    department_id
)
VALUES (
    9900,
    'Prueba',
    'Laboratorio',
    'PRUEBA9900',
    DATE '2026-11-19',
    'IT_PROG',
    -100,
    9900
);


-- 2.4. Verificar el empleado insertado.

SELECT
    employee_id,
    first_name,
    last_name,
    email,
    salary,
    department_id
FROM employees
WHERE employee_id = 9900;


-- RESULTADO OBSERVADO DURANTE LA PRUEBA:
-- EMPLOYEE_ID   = 9900
-- FIRST_NAME    = Prueba
-- LAST_NAME     = Laboratorio
-- EMAIL         = PRUEBA9900
-- SALARY        = -100
-- DEPARTMENT_ID = 9900
--
-- La insercion fue posible porque las
-- restricciones correspondientes estaban
-- desactivadas temporalmente.


-- =====================================================
-- PRUEBA 3. ANALISIS DEL ERROR ORA-00001
-- =====================================================
-- OBJETIVO:
-- Examinar la violacion de unicidad observada
-- al intentar repetir la insercion del empleado.
--
-- RESULTADO OBSERVADO:
-- ORA-00001: restriccion unica
-- (HR.EMP_EMAIL_UK) violada.
--
-- El indice unico asociado a EMP_EMAIL_UK
-- se conservo mediante KEEP INDEX.
--
-- Por ello, el correo duplicado fue rechazado
-- aunque la restriccion estuviera desactivada.
--
-- IMPORTANTE:
-- No repetir la insercion para provocar el error.


-- 3.1. Consultar el indice asociado.

SELECT
    index_name,
    uniqueness,
    status
FROM user_indexes
WHERE index_name = 'EMP_EMAIL_UK';


-- 3.2. Consultar las restricciones relacionadas.

SELECT
    constraint_name,
    status,
    validated
FROM user_constraints
WHERE constraint_name IN (
    'EMP_EMAIL_UK',
    'EMP_EMAIL_NN',
    'EMP_SALARY_MIN',
    'EMP_DEPT_FK'
);


-- 3.3. Comprobar la existencia del empleado.

SELECT
    employee_id,
    first_name,
    last_name,
    email,
    salary,
    department_id
FROM employees
WHERE employee_id = 9900
   OR email = 'PRUEBA9900';


-- OBSERVACION:
-- Actualmente, las restricciones consultadas
-- deben aparecer nuevamente habilitadas.
--
-- El registro de prueba ya fue eliminado.


-- =====================================================
-- PRUEBA 4. ELIMINACION DEL EMPLEADO DE PRUEBA
-- =====================================================
-- OBJETIVO:
-- Retirar el registro temporal y recuperar
-- la cantidad original de empleados.
--
-- IMPORTANTE:
-- Esta limpieza ya fue realizada y confirmada.
-- NO repetir el DELETE ni el COMMIT.
--
-- El DELETE incluye varias condiciones para
-- identificar exclusivamente el registro
-- utilizado durante el laboratorio.


-- 4.1. Consultar la cantidad de empleados.

SELECT
    COUNT(*) AS total_actual
FROM employees;


-- 4.2. Eliminar exclusivamente el registro.
-- EJECUTADO ANTERIORMENTE. NO REPETIR.

DELETE FROM employees
WHERE employee_id = 9900
  AND email = 'PRUEBA9900'
  AND first_name = 'Prueba'
  AND last_name = 'Laboratorio'
  AND salary = -100
  AND department_id = 9900;


-- 4.3. Verificar la ausencia del empleado.

SELECT
    COUNT(*) AS registros_restantes
FROM employees
WHERE employee_id = 9900;


-- 4.4. Comprobar la cantidad original.

SELECT
    COUNT(*) AS total_empleados
FROM employees;


-- RESULTADOS OBTENIDOS EN EL LABORATORIO:
-- 1 fila eliminada.
-- REGISTROS_RESTANTES = 0
-- TOTAL_EMPLEADOS = 107
--
-- Antes de confirmar la limpieza se verifico
-- que no existieran cambios ajenos pendientes.
--
-- IMPORTANTE:
-- El siguiente COMMIT ya fue ejecutado.
-- No repetirlo en la sesion actual.

COMMIT;


-- =====================================================
-- PRUEBA 5. COMPROBACION FINAL DE LAS TABLAS
-- =====================================================
-- OBJETIVO:
-- Verificar las cantidades originales y
-- confirmar la ausencia de registros de prueba.
--
-- Estas consultas son de solo lectura.


-- 5.1. Consultar totales de las tablas originales.

SELECT
    'EMPLOYEES' AS tabla,
    COUNT(*) AS total
FROM employees
UNION ALL
SELECT
    'DEPARTMENTS',
    COUNT(*)
FROM departments;


-- 5.2. Comprobar ausencia de registros de prueba.

SELECT
    'EMPLOYEES' AS tabla,
    COUNT(*) AS registros_prueba
FROM employees
WHERE employee_id = 9900

UNION ALL

SELECT
    'DEPARTMENTS',
    COUNT(*)
FROM departments
WHERE department_id = 9900;


-- RESULTADOS OBTENIDOS:
-- EMPLOYEES: 107 registros.
-- DEPARTMENTS: 27 registros.
--
-- Registros de prueba restantes: 0.
--
-- Las tablas originales conservaron
-- sus cantidades iniciales.


-- =====================================================
-- PASO 6. VERIFICAR LA INTEGRIDAD DE LOS DATOS
-- =====================================================
-- OBJETIVO:
-- Comparar las tablas originales con sus
-- respaldos mediante el operador MINUS.
--
-- Se realizan comparaciones en ambos sentidos
-- para identificar posibles diferencias.
--
-- REQUISITO:
-- Deben existir las tablas BDA2_BKP_EMPLOYEES
-- y BDA2_BKP_DEPARTMENTS.
--
-- IMPORTANTE:
-- Estas consultas son de solo lectura.


-- 6.1. Diferencias de EMPLOYEES frente al respaldo.

SELECT
    COUNT(*) AS diferencias_employees
FROM (
    SELECT *
    FROM employees

    MINUS

    SELECT *
    FROM bda2_bkp_employees
);


-- 6.2. Diferencias del respaldo frente a EMPLOYEES.

SELECT
    COUNT(*) AS diferencias_respaldo_employees
FROM (
    SELECT *
    FROM bda2_bkp_employees

    MINUS

    SELECT *
    FROM employees
);


-- 6.3. Diferencias de DEPARTMENTS frente al respaldo.

SELECT
    COUNT(*) AS diferencias_departments
FROM (
    SELECT *
    FROM departments

    MINUS

    SELECT *
    FROM bda2_bkp_departments
);


-- 6.4. Diferencias del respaldo frente a DEPARTMENTS.

SELECT
    COUNT(*) AS diferencias_respaldo_departments
FROM (
    SELECT *
    FROM bda2_bkp_departments

    MINUS

    SELECT *
    FROM departments
);


-- =====================================================
-- RESULTADO OBTENIDO EN EL LABORATORIO
-- =====================================================
-- PRUEBA 1:
-- Insercion de un departamento sin nombre.
-- Reversion mediante ROLLBACK TO SAVEPOINT.
--
-- PRUEBA 2:
-- Insercion temporal de un empleado con
-- salario negativo y departamento inexistente.
--
-- PRUEBA 3:
-- Error ORA-00001 por correo duplicado.
-- El indice unico se conservo con KEEP INDEX.
--
-- PRUEBA 4:
-- Eliminacion del empleado de prueba.
-- Confirmacion de la limpieza con COMMIT.
--
-- PRUEBA 5:
-- EMPLOYEES: 107 registros originales.
-- DEPARTMENTS: 27 registros originales.
-- Registros temporales restantes: 0.
--
-- VERIFICACION DE INTEGRIDAD:
-- Diferencias EMPLOYEES - respaldo: 0.
-- Diferencias respaldo - EMPLOYEES: 0.
-- Diferencias DEPARTMENTS - respaldo: 0.
-- Diferencias respaldo - DEPARTMENTS: 0.
--
-- Las comparaciones no evidenciaron diferencias
-- entre las tablas originales y sus respaldos.
--
-- OBSERVACION:
-- MINUS compara conjuntos de filas y elimina
-- duplicados en su resultado. En este laboratorio,
-- la comprobacion se complemento con los conteos
-- y la restauracion de las restricciones.
--
-- ESTADO FINAL DEL LABORATORIO:
-- Los registros de prueba fueron retirados.
-- Las restricciones fueron restauradas
-- posteriormente mediante ENABLE VALIDATE.
--
-- ADVERTENCIA:
-- Para comprobar el estado actual, ejecutar
-- solamente las instrucciones SELECT.
--
-- NO volver a ejecutar INSERT, DELETE, COMMIT,
-- SAVEPOINT ni ROLLBACK del procedimiento.
-- =====================================================
-- FIN DEL ARCHIVO: 07_inserciones_invalidas.sql
-- =====================================================

