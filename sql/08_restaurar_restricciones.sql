
-- =====================================================
-- UNIVERSIDAD INTERNACIONAL DE LA RIOJA (UNIR)
-- ASIGNATURA: BASES DE DATOS AVANZADAS
-- ACTIVIDAD 2: INDICES Y RESTRICCIONES EN ORACLE
-- =====================================================
-- ARCHIVO: 08_restaurar_restricciones.sql
-- DESCRIPCION:
-- Restaurar las restricciones de integridad
-- previamente desactivadas en las tablas
-- EMPLOYEES, DEPARTMENTS y JOB_HISTORY
-- del esquema HR.
--
-- Comprobar que todas las restricciones queden
-- habilitadas y validadas correctamente.
--
-- ENTORNO: Oracle Database 21c XE
-- CONEXION: HR_Local_XE
-- CONTENEDOR: XEPDB1
--
-- TIPO DE OPERACION:
-- Modificacion de restricciones (DDL) y
-- consultas de verificacion (SELECT).
--
-- REQUISITOS PREVIOS DE LA PRUEBA ORIGINAL:
-- Haber completado los procedimientos de
-- desactivacion de restricciones.
--
-- Haber eliminado o revertido los registros
-- invalidos utilizados durante el laboratorio.
--
-- Haber comprobado la integridad de los datos
-- mediante las tablas de respaldo.
--
-- IMPORTANTE:
-- Este archivo documenta operaciones ya realizadas.
--
-- NO ejecutar nuevamente las instrucciones
-- ALTER TABLE sobre el esquema restaurado.
--
-- Las operaciones DDL generan COMMIT implicitos
-- y no pueden revertirse mediante ROLLBACK.
--
-- Si una instruccion de restauracion produce
-- un error, detener el procedimiento y revisar
-- los datos y las restricciones involucradas.
-- =====================================================


-- =====================================================
-- PASO 1. VERIFICAR EL CONTEXTO DE CONEXION
-- =====================================================
-- Comprobar que las operaciones corresponden
-- al usuario HR y al contenedor XEPDB1.

SELECT
    USER AS usuario,
    SYS_CONTEXT('USERENV', 'CON_NAME') AS contenedor
FROM dual;


-- =====================================================
-- ETAPA 1. RESTAURAR RESTRICCIONES PRINCIPALES
-- =====================================================
-- OBJETIVO:
-- Habilitar y validar las claves primarias,
-- la restriccion UNIQUE y las condiciones
-- CHECK / NOT NULL previamente desactivadas.
--
-- IMPORTANTE:
-- Las siete claves foraneas dependientes deben
-- permanecer desactivadas durante esta etapa.
--
-- Estas instrucciones ya fueron ejecutadas.
-- No repetirlas en el entorno restaurado.
-- =====================================================


-- =====================================================
-- PASO 2. RESTAURAR RESTRICCIONES DE DEPARTMENTS
-- =====================================================
-- Habilitar y validar la clave primaria y
-- la restriccion NOT NULL del nombre.

-- Restaurar clave primaria.
ALTER TABLE departments
ENABLE VALIDATE CONSTRAINT DEPT_ID_PK;

-- Restaurar restriccion NOT NULL.
ALTER TABLE departments
ENABLE VALIDATE CONSTRAINT DEPT_NAME_NN;


-- =====================================================
-- PASO 3. RESTAURAR RESTRICCIONES DE EMPLOYEES
-- =====================================================
-- Habilitar y validar la clave primaria,
-- la restriccion de unicidad y las condiciones
-- NOT NULL y CHECK del salario.

-- Restaurar clave primaria.
ALTER TABLE employees
ENABLE VALIDATE CONSTRAINT EMP_EMP_ID_PK;

-- Restaurar restriccion de unicidad.
ALTER TABLE employees
ENABLE VALIDATE CONSTRAINT EMP_EMAIL_UK;

-- Restaurar restriccion NOT NULL del correo.
ALTER TABLE employees
ENABLE VALIDATE CONSTRAINT EMP_EMAIL_NN;

-- Restaurar restriccion NOT NULL de fecha.
ALTER TABLE employees
ENABLE VALIDATE CONSTRAINT EMP_HIRE_DATE_NN;

-- Restaurar restriccion NOT NULL del trabajo.
ALTER TABLE employees
ENABLE VALIDATE CONSTRAINT EMP_JOB_NN;

-- Restaurar restriccion NOT NULL del apellido.
ALTER TABLE employees
ENABLE VALIDATE CONSTRAINT EMP_LAST_NAME_NN;

-- Restaurar restriccion CHECK del salario.
ALTER TABLE employees
ENABLE VALIDATE CONSTRAINT EMP_SALARY_MIN;


-- =====================================================
-- PASO 4. VERIFICAR LA PRIMERA ETAPA
-- =====================================================
-- Consultar las restricciones de tipo P, U y C
-- correspondientes a EMPLOYEES y DEPARTMENTS.
--
-- RESULTADO ESPERADO EN ESTA ETAPA:
-- 9 restricciones en estado ENABLED VALIDATED.
--
-- OBSERVACION:
-- Las claves foraneas se restauran posteriormente.

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
  AND constraint_type IN ('P', 'U', 'C')
ORDER BY
    table_name,
    constraint_name;


-- =====================================================
-- PASO 5. CONSULTAR EL RESUMEN INTERMEDIO
-- =====================================================
-- Agrupar las restricciones de las tres tablas
-- por estado y condicion de validacion.
--
-- RESULTADO ESPERADO EN ESTA ETAPA:
-- 16 restricciones ENABLED.
-- 7 claves foraneas DISABLED.
--
-- IMPORTANTE:
-- El resultado corresponde al estado de la base
-- de datos en el momento de ejecutar la consulta.

SELECT
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
    status,
    validated
ORDER BY
    status;


-- =====================================================
-- ETAPA 2. RESTAURAR LAS CLAVES FORANEAS
-- =====================================================
-- OBJETIVO:
-- Habilitar y validar las siete claves foraneas
-- desactivadas al comienzo del laboratorio.
--
-- REQUISITO:
-- Las claves primarias, la restriccion UNIQUE
-- y las condiciones CHECK / NOT NULL deben
-- estar restauradas y validadas previamente.
--
-- IMPORTANTE:
-- Estas instrucciones ya fueron ejecutadas.
-- No repetirlas en el entorno restaurado.
-- =====================================================


-- =====================================================
-- PASO 6. RESTAURAR CLAVES FORANEAS DE DEPARTMENTS
-- =====================================================
-- Habilitar las relaciones con LOCATIONS
-- y EMPLOYEES.

-- Restaurar relacion con LOCATIONS.
ALTER TABLE departments
ENABLE VALIDATE CONSTRAINT DEPT_LOC_FK;

-- Restaurar relacion con EMPLOYEES.
ALTER TABLE departments
ENABLE VALIDATE CONSTRAINT DEPT_MGR_FK;


-- =====================================================
-- PASO 7. RESTAURAR CLAVES FORANEAS DE EMPLOYEES
-- =====================================================
-- Habilitar las relaciones con DEPARTMENTS,
-- JOBS y la jerarquia entre empleados.

-- Restaurar relacion con DEPARTMENTS.
ALTER TABLE employees
ENABLE VALIDATE CONSTRAINT EMP_DEPT_FK;

-- Restaurar relacion con JOBS.
ALTER TABLE employees
ENABLE VALIDATE CONSTRAINT EMP_JOB_FK;

-- Restaurar relacion jerarquica entre empleados.
ALTER TABLE employees
ENABLE VALIDATE CONSTRAINT EMP_MANAGER_FK;


-- =====================================================
-- PASO 8. RESTAURAR CLAVES FORANEAS DE JOB_HISTORY
-- =====================================================
-- Habilitar las relaciones con DEPARTMENTS
-- y EMPLOYEES.

-- Restaurar relacion con DEPARTMENTS.
ALTER TABLE job_history
ENABLE VALIDATE CONSTRAINT JHIST_DEPT_FK;

-- Restaurar relacion con EMPLOYEES.
ALTER TABLE job_history
ENABLE VALIDATE CONSTRAINT JHIST_EMP_FK;


-- =====================================================
-- PASO 9. VERIFICAR TODAS LAS RESTRICCIONES
-- =====================================================
-- Consultar el estado y la validacion de las
-- restricciones de las tres tablas involucradas.
--
-- RESULTADO ESPERADO AL FINAL DEL LABORATORIO:
-- 23 restricciones ENABLED VALIDATED.

SELECT
    table_name AS tabla,
    constraint_name AS restriccion,
    constraint_type AS tipo,
    status AS estado,
    validated AS validacion
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
-- PASO 10. CONSULTAR EL RESUMEN FINAL
-- =====================================================
-- Agrupar las restricciones segun su estado
-- y condicion de validacion.
--
-- RESULTADO OBTENIDO EN EL LABORATORIO:
-- ESTADO: ENABLED
-- VALIDACION: VALIDATED
-- CANTIDAD: 23

SELECT
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
    status,
    validated
ORDER BY
    status;


-- =====================================================
-- PASO 11. COMPROBAR RESTRICCIONES PENDIENTES
-- =====================================================
-- Identificar restricciones que no se encuentren
-- habilitadas o validadas correctamente.
--
-- RESULTADO ESPERADO:
-- RESTRICCIONES_PENDIENTES = 0.
--
-- Esta consulta permite comprobar que no
-- quedan restricciones por restaurar.

SELECT
    COUNT(*) AS restricciones_pendientes
FROM user_constraints
WHERE table_name IN (
    'EMPLOYEES',
    'DEPARTMENTS',
    'JOB_HISTORY'
)
AND (
    status <> 'ENABLED'
    OR validated <> 'VALIDATED'
);


-- =====================================================
-- RESULTADO OBTENIDO EN EL LABORATORIO
-- =====================================================
-- ETAPA 1:
-- Se restauraron 9 restricciones principales
-- correspondientes a EMPLOYEES y DEPARTMENTS.
--
-- ETAPA 2:
-- Se restauraron 7 claves foraneas asociadas
-- a DEPARTMENTS, EMPLOYEES y JOB_HISTORY.
--
-- RESULTADO ACUMULADO:
-- 16 restricciones restauradas durante
-- el procedimiento.
--
-- VERIFICACION FINAL:
-- 23 restricciones en estado ENABLED VALIDATED.
-- 0 restricciones pendientes de restauracion.
--
-- Las tablas originales conservaron su
-- configuracion de integridad.
--
-- OBSERVACION:
-- La restauracion se completo despues de
-- eliminar los registros temporales invalidos
-- y verificar los datos frente a los respaldos.
--
-- ADVERTENCIA:
-- Para consultar el estado actual de Oracle,
-- ejecutar solamente los SELECT de los
-- pasos 1, 9, 10 y 11.
--
-- No volver a ejecutar los ALTER TABLE
-- correspondientes a los pasos 2, 3, 6, 7 y 8.
-- =====================================================
-- FIN DEL ARCHIVO: 08_restaurar_restricciones.sql
-- =====================================================
