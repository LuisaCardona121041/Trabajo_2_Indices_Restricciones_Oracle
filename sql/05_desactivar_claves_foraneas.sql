
-- =====================================================
-- UNIVERSIDAD INTERNACIONAL DE LA RIOJA (UNIR)
-- ASIGNATURA: BASES DE DATOS AVANZADAS
-- ACTIVIDAD 2: INDICES Y RESTRICCIONES EN ORACLE
-- =====================================================
-- ARCHIVO: 05_desactivar_claves_foraneas.sql
-- DESCRIPCION:
-- Desactivar temporalmente las claves foraneas
-- relacionadas con las tablas EMPLOYEES, DEPARTMENTS
-- y JOB_HISTORY del esquema HR.
--
-- ENTORNO: Oracle Database 21c XE
-- CONEXION: HR_Local_XE
-- CONTENEDOR: XEPDB1
--
-- TIPO DE OPERACION:
-- Modificacion de restricciones (DDL) y
-- consultas de verificacion (SELECT).
--
-- IMPORTANTE:
-- Este archivo documenta operaciones realizadas
-- durante el laboratorio.
--
-- NO ejecutar nuevamente las instrucciones
-- ALTER TABLE sobre el esquema restaurado.
--
-- La desactivacion de restricciones compromete
-- temporalmente la validacion de integridad.
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
-- PASO 2. DESACTIVAR CLAVES FORANEAS DE JOB_HISTORY
-- =====================================================
-- Desactivar las restricciones que relacionan
-- JOB_HISTORY con DEPARTMENTS y EMPLOYEES.
--
-- IMPORTANTE:
-- Estas instrucciones ya fueron ejecutadas.
-- No repetirlas en el entorno restaurado.

-- Relacion con DEPARTMENTS.
ALTER TABLE job_history
DISABLE CONSTRAINT JHIST_DEPT_FK;

-- Relacion con EMPLOYEES.
ALTER TABLE job_history
DISABLE CONSTRAINT JHIST_EMP_FK;


-- =====================================================
-- PASO 3. DESACTIVAR CLAVES FORANEAS DE EMPLOYEES
-- =====================================================
-- Desactivar las restricciones que relacionan
-- EMPLOYEES con DEPARTMENTS, la jerarquia entre
-- empleados y la tabla JOBS.
--
-- IMPORTANTE:
-- Estas instrucciones ya fueron ejecutadas.
-- No repetirlas en el entorno restaurado.

-- Relacion con DEPARTMENTS.
ALTER TABLE employees
DISABLE CONSTRAINT EMP_DEPT_FK;

-- Relacion jerarquica entre empleados.
ALTER TABLE employees
DISABLE CONSTRAINT EMP_MANAGER_FK;

-- Relacion con JOBS.
ALTER TABLE employees
DISABLE CONSTRAINT EMP_JOB_FK;


-- =====================================================
-- PASO 4. DESACTIVAR CLAVES FORANEAS DE DEPARTMENTS
-- =====================================================
-- Desactivar las restricciones que relacionan
-- DEPARTMENTS con EMPLOYEES y LOCATIONS.
--
-- IMPORTANTE:
-- Estas instrucciones ya fueron ejecutadas.
-- No repetirlas en el entorno restaurado.

-- Relacion con EMPLOYEES (gerente).
ALTER TABLE departments
DISABLE CONSTRAINT DEPT_MGR_FK;

-- Relacion con LOCATIONS.
ALTER TABLE departments
DISABLE CONSTRAINT DEPT_LOC_FK;


-- =====================================================
-- PASO 5. VERIFICAR LAS CLAVES FORANEAS
-- =====================================================
-- Consultar el estado actual de las siete claves
-- foraneas incluidas en este procedimiento.
--
-- RESULTADO ESPERADO DURANTE LA DESACTIVACION:
-- 7 restricciones en estado DISABLED.
--
-- OBSERVACION:
-- Si esta consulta se ejecuta despues de completar
-- la restauracion del laboratorio, las restricciones
-- deben aparecer nuevamente en estado ENABLED.

SELECT
    table_name AS tabla,
    constraint_name AS restriccion,
    constraint_type AS tipo,
    status AS estado
FROM user_constraints
WHERE constraint_name IN (
    'JHIST_DEPT_FK',
    'JHIST_EMP_FK',
    'EMP_DEPT_FK',
    'EMP_MANAGER_FK',
    'EMP_JOB_FK',
    'DEPT_MGR_FK',
    'DEPT_LOC_FK'
)
ORDER BY
    table_name,
    constraint_name;


-- =====================================================
-- PASO 6. CONSULTAR EL RESUMEN DE RESTRICCIONES
-- =====================================================
-- Agrupar las restricciones de EMPLOYEES,
-- DEPARTMENTS y JOB_HISTORY segun su estado
-- y condicion de validacion.
--
-- Esta consulta permite observar las restricciones
-- desactivadas y las que permanecen habilitadas.
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
-- RESULTADO OBTENIDO EN EL LABORATORIO
-- =====================================================
-- Se desactivaron temporalmente 7 claves foraneas:
--
-- JOB_HISTORY:
-- JHIST_DEPT_FK
-- JHIST_EMP_FK
--
-- EMPLOYEES:
-- EMP_DEPT_FK
-- EMP_MANAGER_FK
-- EMP_JOB_FK
--
-- DEPARTMENTS:
-- DEPT_MGR_FK
-- DEPT_LOC_FK
--
-- La consulta de verificacion confirmo que las
-- siete restricciones estaban en estado DISABLED
-- durante esta etapa del laboratorio.
--
-- Posteriormente, las claves foraneas fueron
-- restauradas mediante ENABLE VALIDATE.
--
-- ESTADO FINAL DEL LABORATORIO:
-- Las 23 restricciones verificadas quedaron
-- nuevamente en estado ENABLED VALIDATED.
--
-- ADVERTENCIA:
-- Para comprobar el estado actual de la base
-- de datos, ejecutar unicamente los SELECT
-- correspondientes a los pasos 1, 5 y 6.
--
-- No volver a ejecutar los pasos 2, 3 y 4.
-- =====================================================
-- FIN DEL ARCHIVO: 05_desactivar_claves_foraneas.sql
-- =====================================================

