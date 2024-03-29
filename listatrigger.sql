1)

--a)

CREATE TABLE DEPARTAMENTO(
	DEPTO INT PRIMARY KEY,
	ORCAMENTO BIGINT,
	ENDERECO VARCHAR(50)
	);

CREATE TABLE EMPREGADO (
	NOME VARCHAR(30) PRIMARY KEY,
	SAL INT,
	DEP INT,
	NOMEGERENTE VARCHAR(30),
	FOREIGN KEY(NOMEGERENTE) REFERENCES EMPREGADO(NOME),
	FOREIGN KEY(DEP) REFERENCES DEPARTAMENTO(DEPTO)
	);

DROP TABLE EMPREGADO

CREATE OR REPLACE FUNCTION inserir() RETURNS TRIGGER AS $$
	BEGIN
		
		IF (SELECT ORCAMENTO FROM DEPARTAMENTO WHERE DEPTO = NEW.DEP)  < (SELECT COALESCE(SUM(SAL),0) FROM EMPREGADO WHERE DEP = NEW.DEP) + NEW.SAL THEN
			RAISE EXCEPTION 'ORCAMENTO MAXÍMO DO DEPARTAMENTO % ULTRAPASSADO', NEW.DEP;
			RETURN NULL;
		END IF;
		RETURN NEW;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ISEN BEFORE INSERT ON EMPREGADO
FOR EACH ROW EXECUTE PROCEDURE inserir();
DROP TRIGGER ISEN ON EMPREGADO

insert into DEPARTAMENTO VALUES(1,10000,'Rua da UFC');

insert into EMPREGADO VALUES('Johnny',2000,1, 'Johnny')
insert into EMPREGADO VALUES('Johnny2',8000,1, 'Johnny')




DROP TABLE EMPREGADO

CREATE OR REPLACE FUNCTION atualizar() RETURNS TRIGGER AS $$
	BEGIN
		
		IF NEW.DEP  = OLD.DEP THEN
			IF (SELECT ORCAMENTO FROM DEPARTAMENTO WHERE DEPTO = NEW.DEP)  < (SELECT COALESCE(SUM(SAL),0) FROM EMPREGADO WHERE DEP = NEW.DEP) + NEW.SAL - OLD.SAL THEN
				RAISE EXCEPTION 'ORCAMENTO MAXÍMO DO DEPARTAMENTO % ULTRAPASSADO', NEW.DEP;
				RETURN NULL;
			END IF;
		ELSE 
			IF (SELECT ORCAMENTO FROM DEPARTAMENTO WHERE DEPTO = NEW.DEP)  < (SELECT COALESCE(SUM(SAL),0) FROM EMPREGADO WHERE DEP = NEW.DEP) + NEW.SAL THEN
				RAISE EXCEPTION 'ORCAMENTO MAXÍMO DO DEPARTAMENTO % ULTRAPASSADO', NEW.DEP;
				RETURN NULL;
			END IF;
		END IF;
		
		RETURN NEW;
	END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER ATT BEFORE UPDATE ON EMPREGADO
FOR EACH ROW EXECUTE PROCEDURE atualizar();

drop table empregado
select * from empregado
select * from DEPARTAMENTO

insert into EMPREGADO VALUES('Johnny3',10000,2, 'Johnny3')
UPDATE EMPREGADO SET SAL = 15000 WHERE NOME = 'Johnny';
UPDATE EMPREGADO SET SAL = 15000, DEP = 2 WHERE NOME = 'Johnny';


CREATE OR REPLACE FUNCTION ATT_DEP() RETURNS TRIGGER AS $$
	BEGIN
		IF NEW.ORCAMENTO < (SELECT SUM(SAL) FROM EMPREGADO WHERE DEP = NEW.DEPTO) THEN
			RAISE EXCEPTION 'O VALOR DO ORCAMENTO É MUITO BAIXO NO DEPARTAMENTO %',NEW.DEPTO;
			RETURN NULL;
		END IF;
		RETURN NEW;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER AT_DEP BEFORE UPDATE ON DEPARTAMENTO
FOR EACH ROW EXECUTE PROCEDURE ATT_DEP();

SELECT * FROM DEPARTAMENTO
SELECT * FROM EMPREGADO
UPDATE DEPARTAMENTO SET ORCAMENTO = 8000 WHERE DEPTO = 2;

-----------------------------------------------------------------------------------
--b)
CREATE OR REPLACE FUNCTION INSER_FUNC() RETURNS TRIGGER AS $$
	BEGIN
	
		IF (SELECT DISTINCT NOMEGERENTE FROM EMPREGADO WHERE DEP = NEW.DEP) IS NULL THEN
				RETURN NEW;
		ELSE
			IF NEW.NOMEGERENTE = (SELECT DISTINCT NOMEGERENTE FROM EMPREGADO WHERE DEP = NEW.DEP) THEN
				RETURN NEW;
			END IF;
		END IF;
		
		RAISE EXCEPTION 'NOME DO GERENTE DIFERENTE DO DEPARTAMENTO %', NEW.DEP;
		RETURN NULL;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER INSERT_FUNC_GERENTE BEFORE INSERT ON EMPREGADO
FOR EACH ROW EXECUTE PROCEDURE INSER_FUNC();
DROP TRIGGER INSERT_FUNC_GERENTE ON EMPREGADO

SELECT * FROM EMPREGADO
SELECT * FROM DEPARTAMENTO
INSERT INTO DEPARTAMENTO VALUES(3,10000,'QUIXADÁ')
INSERT INTO EMPREGADO VALUES('Leticia',3000,3,'Leticia')
INSERT INTO EMPREGADO VALUES('Leticia2',3000,3,'null')
delete from  empregado where nome = 'Leticia'
INSERT INTO EMPREGADO VALUES('Leticia2',3000,3,'Leticia')

CREATE OR REPLACE FUNCTION INSER_FUNC() RETURNS TRIGGER AS $$
	BEGIN
	
		IF (SELECT DISTINCT NOMEGERENTE FROM EMPREGADO WHERE DEP = NEW.DEP) IS NULL THEN
				RETURN NEW;
		ELSE
			IF NEW.NOMEGERENTE = (SELECT DISTINCT NOMEGERENTE FROM EMPREGADO WHERE DEP = NEW.DEP) THEN
				RETURN NEW;
			END IF;
		END IF;
		
		RAISE EXCEPTION 'NOME DO GERENTE DIFERENTE DO DEPARTAMENTO %', NEW.DEP;
		RETURN NULL;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER INSERT_FUNC_GERENTE BEFORE INSERT ON EMPREGADO
FOR EACH ROW EXECUTE PROCEDURE INSER_FUNC();
DROP TRIGGER INSERT_FUNC_GERENTE ON EMPREGADO

SELECT * FROM EMPREGADO
SELECT * FROM DEPARTAMENTO
INSERT INTO DEPARTAMENTO VALUES(3,10000,'QUIXADÁ')
INSERT INTO EMPREGADO VALUES('Leticia',3000,3,'Leticia')
INSERT INTO EMPREGADO VALUES('Leticia2',3000,3,'null')
delete from  empregado where nome = 'Leticia2'
INSERT INTO EMPREGADO VALUES('Leticia2',3000,3,'Leticia')


CREATE OR REPLACE FUNCTION ATT_FUNC() RETURNS TRIGGER AS $$
	BEGIN
	
		IF (SELECT DISTINCT NOMEGERENTE FROM EMPREGADO WHERE DEP = NEW.DEP) IS NULL THEN
				RETURN NEW;
		ELSE
			IF NEW.NOMEGERENTE = (SELECT DISTINCT NOMEGERENTE FROM EMPREGADO WHERE DEP = NEW.DEP) THEN
				RETURN NEW;
			END IF;
		END IF;
		
		RAISE EXCEPTION 'NOME DO GERENTE DIFERENTE DO DEPARTAMENTO %', NEW.DEP;
		RETURN NULL;
	END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER ATT_FUNC_GERENTE BEFORE UPDATE ON EMPREGADO
FOR EACH ROW EXECUTE PROCEDURE ATT_FUNC();

UPDATE EMPREGADO SET NOME = 'Leticia2',SAL =10,DEP = 1, NOMEGERENTE = 'Leticia'
WHERE NOME = 'Leticia2';





--2)
--A)
CREATE TABLE R (A INT PRIMARY KEY, B INT);
INSERT INTO R VALUES(1,2);
INSERT INTO R VALUES(2,3);
INSERT INTO R VALUES(5,4);
INSERT INTO R VALUES(10,3);
INSERT INTO R VALUES (15,3);



CREATE OR REPLACE FUNCTION INS_2() RETURNS TRIGGER AS $$
	BEGIN
		IF NEW.A > 5 THEN
			INSERT INTO V VALUES(NEW.A, NEW.B);
		END IF;
	END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER VinsR AFTER INSERT ON R
FOR EACH ROW EXECUTE PROCEDURE INS_2();





CREATE OR REPLACE FUNCTION REM_2() RETURNS TRIGGER AS $$
	BEGIN
		IF OLD.A > 5 THEN
			DELETE FROM V WHERE A = OLD.A;
		END IF;
	END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER VdelR AFTER DELETE ON R
FOR EACH ROW EXECUTE PROCEDURE REM_2();


--B)
CREATE OR REPLACE FUNCTION ATT_2() RETURNS TRIGGER AS $$
	BEGIN
		IF NEW.A > 5 THEN
			UPDATE V SET A = NEW.A, B = NEW.B WHERE A = OLD.A;
		END IF;
	END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER  VupdR AFTER UPDATE ON R
FOR EACH ROW EXECUTE PROCEDURE ATT_2();

--C)
CREATE MATERIALIZED VIEW V AS
SELECT A,B FROM R;

CREATE OR REPLACE FUNCTION INS_2() RETURNS TRIGGER AS $$
	BEGIN
		INSERT INTO V VALUE(NEW.A, NEW.B);
	END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER VinsR AFTER INSERT ON R
FOR EACH ROW EXECUTE PROCEDURE INS_2();


CREATE OR REPLACE FUNCTION REM_2() RETURNS TRIGGER AS $$
	BEGIN
		DELETE FROM V WHERE A = OLD.A;
	END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER VdelR AFTER DELETE ON R
FOR EACH ROW EXECUTE PROCEDURE REM_2();


CREATE OR REPLACE FUNCTION ATT_2() RETURNS TRIGGER AS $$
	BEGIN
		UPDATE V SET A = NEW.A, B = NEW.B WHERE A = OLD.A;
	END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER  VupdR AFTER UPDATE ON R
FOR EACH ROW EXECUTE PROCEDURE ATT_2();

--2)
--D)

CREATE TABLE S(B INT, C INT PRIMARY KEY);
INSERT INTO S VALUES(1,2);
INSERT INTO S VALUES(2,3);
INSERT INTO S VALUES(5,9);
INSERT INTO S VALUES(2,4);
INSERT INTO S VALUES (2,5);

DROP MATERIALIZED VIEW V
CREATE MATERIALIZED VIEW V AS
SELECT R.A,R.B,S.C FROM R,S 
WHERE R.B = S.B;

CREATE OR REPLACE FUNCTION INS_2R() RETURNS TRIGGER AS $$
	BEGIN
		IF NEW.B = ANY(SELECT B FROM S) THEN
		
			INSERT INTO V (VALUEA, VALUEB, VALUEC) SELECT NEW.A AS VALUEA, NEW.B AS VALUEB, S.C AS VALUEC FROM S WHERE S.B= NEW.B ;
		END IF;
	END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION INS_2S() RETURNS TRIGGER AS $$
	BEGIN
		IF NEW.B = ANY(SELECT B FROM R) THEN
		
			INSERT INTO V (VALUEA, VALUEB, VALUEC) SELECT R.A AS VALUEA, NEW.B AS VALUEB, NEW.C AS VALUEC FROM R WHERE R.B= NEW.B ;
		END IF;
	END;
$$ LANGUAGE PLPGSQL;





CREATE TRIGGER VinsR AFTER INSERT ON R
FOR EACH ROW EXECUTE PROCEDURE INS_2R();

CREATE TRIGGER VinsS AFTER INSERT ON S
FOR EACH ROW EXECUTE PROCEDURE INS_2S();


CREATE OR REPLACE FUNCTION REM_2R() RETURNS TRIGGER AS $$
	BEGIN
		IF OLD.B = ANY(SELECT B FROM S) THEN
		
			DELETE FROM  V WHERE V.A = OLD.A;
		END IF;
	END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION REM_2S() RETURNS TRIGGER AS $$
	BEGIN
		IF OLD.B = ANY(SELECT B FROM R) THEN
		
			DELETE FROM  V WHERE V.C = OLD.C;
		END IF;
	END;
$$ LANGUAGE PLPGSQL;





CREATE TRIGGER VAdelR AFTER DELETE ON R
FOR EACH ROW EXECUTE PROCEDURE REM_2R();

CREATE TRIGGER VAdelS AFTER DELETE ON S
FOR EACH ROW EXECUTE PROCEDURE REM_2S();


CREATE OR REPLACE FUNCTION ATT_2R() RETURNS TRIGGER AS $$
	BEGIN
		IF NEW.B = ANY(SELECT B FROM S) THEN
			DELETE FROM  V WHERE V.A = OLD.A;
			INSERT INTO V (VALUEA, VALUEB, VALUEC) SELECT NEW.A AS VALUEA, NEW.B AS VALUEB, S.C AS VALUEC FROM S WHERE S.B= NEW.B ;

		END IF;
	END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION ATT_2S() RETURNS TRIGGER AS $$
	BEGIN
		IF NEW.B = ANY(SELECT B FROM S) THEN
			DELETE FROM  V WHERE V.C = OLD.C;
			INSERT INTO V (VALUEA, VALUEB, VALUEC) SELECT R.A AS VALUEA, NEW.B AS VALUEB, NEW.C AS VALUEC FROM R WHERE R.B= NEW.B ;
		END IF;
	END;
$$ LANGUAGE PLPGSQL;


CREATE TRIGGER  VAupdR AFTER UPDATE ON R
FOR EACH ROW EXECUTE PROCEDURE ATT_2R();


CREATE TRIGGER  VAupdS AFTER UPDATE ON S
FOR EACH ROW EXECUTE PROCEDURE ATT_2S();


		












	
