CREATE TABLE fornecedor
(
  fnome varchar(20),
  cidade varchar(20),
  fid integer NOT NULL,
  CONSTRAINT id PRIMARY KEY (fid)
);


CREATE TABLE projeto
(
  jid integer NOT NULL,
  jnome varchar(20),
  cidade varchar(20),
  CONSTRAINT j_pkey PRIMARY KEY (jid)
);

CREATE TABLE peca
(
  pid integer NOT NULL,
  pnome varchar(20),
  cor varchar(20),
  CONSTRAINT p_pkey PRIMARY KEY (pid)
);

CREATE TABLE fpj
(
  fid integer NOT NULL,
  pid integer NOT NULL,
  jid integer NOT NULL,
qtd integer NOT NULL,
  CONSTRAINT p_pkey1 PRIMARY KEY (fid,pid,jid),
  constraint fk_1 foreign key(fid) references fornecedor(fid),
  constraint fk_2 foreign key(pid) references peca(pid),
  constraint fk_3 foreign key(jid) references projeto(jid) 
);

insert into fornecedor values ('Maria','Fortaleza',1);
insert into fornecedor values('Lucia','São Paulo',2);
insert into fornecedor values('João','Fortaleza',3);
insert into fornecedor values('Ana','Rio de Janeiro',4);
insert into fornecedor values('Pedro','Teresina',5);

insert into peca values (1,'peca1','preto');
insert into peca values(2,'peca2','branco');
insert into peca values(3,'peca3','preto');


insert into projeto values (1,'projeto1','Fortaleza');
insert into projeto values(2,'projeto2','São Paulo');
insert into projeto values(3,'projeto3','Teresina');
insert into projeto values (4,'projeto4','Fortaleza');
insert into projeto values(5,'projeto5','São Paulo');
insert into projeto values(6,'projeto6','Teresina');

insert into fpj values (3,3,3,300);
insert into fpj values(2,1,4,500);
insert into fpj values(2,1,5,450);
insert into fpj values (2,1,1,300);
insert into fpj values(3,2,5,200);
insert into fpj values(1,2,6,100);
insert into fpj values(3,1,3,200);

--1)
--A)
SELECT P.PNOME, MAX(FPJ.QTD), MIN(FPJ.QTD)
FROM PECA P, FPJ
WHERE P.PID = FPJ.PID AND FPJ.FID <> 1
GROUP BY P.PID;



--B)
SELECT FPJ.PID
FROM PECA P, FPJ
WHERE P.PID = FPJ.PID
GROUP BY FPJ.PID
HAVING COUNT(DISTINCT FPJ.FID) > 1;

--C)
SELECT F.FID
FROM FORNECEDOR F
WHERE F.FID <> 1 AND F.CIDADE = (SELECT F.CIDADE
				FROM FORNECEDOR F
				WHERE F.FID = 1)
				
				
--D)
SELECT COUNT(DISTINCT FPJ)
FROM FORNECEDOR F, FPJ, PROJETO P
WHERE FPJ.FID = F.FID AND FPJ.JID = P.JID AND FPJ.PID IN (
											SELECT FPJ.PID
											FROM FPJ
											WHERE FPJ.FID = 1);
											

--E)
SELECT FP.JID
FROM FPJ FP
GROUP BY FP.JID
HAVING NOT EXISTS (SELECT DISTINCT FF.JID FROM FPJ FF WHERE FF.FID <> 1 AND FF.JID = FP.JID)

--F)
SELECT f.fnome
FROM fornecedor
f WHERE NOT EXISTS(SELECT r.pid FROM fpj r GROUP BY r.pid HAVING NOT EXISTS
				   (SELECT r1.fid FROM fpj r1 WHERE (r1.fid = f.fid AND r1.pid = r.pid)))

--G)
SELECT FPJ.PID, MAX(FPJ.QTD), (SELECT P.COR FROM PECA P WHERE P.PID = FPJ.PID)
FROM FPJ
GROUP BY FPJ.PID
HAVING SUM(FPJ.QTD) > 400;


--H)
SELECT FP.FID
FROM FPJ FP
WHERE FP.QTD = (SELECT MAX(F.QTD)
				FROM FPJ F
				WHERE F.PID = 1)
				