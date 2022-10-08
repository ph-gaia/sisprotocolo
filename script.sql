-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema sisprotocolo
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema sisprotocolo
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `sisprotocolo` DEFAULT CHARACTER SET utf8 ;
-- -----------------------------------------------------
-- Schema sisprotocolo
-- -----------------------------------------------------

USE `sisprotocolo` ;

-- -----------------------------------------------------
-- Table `sisprotocolo`.`suppliers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sisprotocolo`.`suppliers` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `cnpj` VARCHAR(18) NULL,
  `details` VARCHAR(256) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'Fornecedores';


-- -----------------------------------------------------
-- Table `sisprotocolo`.`oms`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sisprotocolo`.`oms` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NULL DEFAULT NULL,
  `naval_indicative` VARCHAR(6) NULL DEFAULT NULL,
  `isActive` TINYINT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `sisprotocolo`.`modality`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sisprotocolo`.`modality` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `isActive` TINYINT NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `sisprotocolo`.`credit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sisprotocolo`.`credit` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `oms_id` int(11) NOT NULL,
  `credit_note` VARCHAR(50) NOT NULL,
  `value` FLOAT(9,2) NULL DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `isActive` TINYINT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_credit_oms_idx` (`oms_id` ASC) VISIBLE,
  CONSTRAINT `fk_credit_oms`
    FOREIGN KEY (`oms_id`)
    REFERENCES `sisprotocolo`.`oms` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `sisprotocolo`.`credit_historic`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sisprotocolo`.`credit_historic` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `operation_type` VARCHAR(20) NOT NULL DEFAULT 'CREDITO',
  `value` FLOAT(9,2) NOT NULL,
  `observation` VARCHAR(100) NULL,
  `created_at` DATETIME NOT NULL,
  `credit_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_credit_historic_credit1_idx` (`credit_id` ASC) VISIBLE,
  CONSTRAINT `fk_credit_historic_credit1`
    FOREIGN KEY (`credit_id`)
    REFERENCES `sisprotocolo`.`credit` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sisprotocolo`.`cnae`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sisprotocolo`.`cnae` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(60) NOT NULL,
  `description` VARCHAR(60) NOT NULL,
  `isActive` TINYINT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sisprotocolo`.`nature_expense`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sisprotocolo`.`nature_expense` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(60) NOT NULL,
  `isActive` TINYINT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `sisprotocolo`.`process_type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sisprotocolo`.`process_type` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(40) NOT NULL,
  `isActive` TINYINT NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `sisprotocolo`.`status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sisprotocolo`.`status` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(40) NOT NULL,
  `description` VARCHAR(60) NULL DEFAULT NULL,
  `isActive` TINYINT NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `sisprotocolo`.`registers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sisprotocolo`.`registers` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `document_number` VARCHAR(20) NOT NULL,
  `summary_object` VARCHAR(100) NOT NULL,
  `bidding_process_number` VARCHAR(10) NOT NULL,
  `document_value` FLOAT(9,4) NOT NULL,
  `oms_id` INT NOT NULL,
  `modality_id` INT NOT NULL,
  `credit_id` INT NOT NULL,
  `suppliers_id` INT NOT NULL,
  `biddings_id` int(11) NOT NULL,
  `cnae` VARCHAR(30) NOT NULL,
  `cnpj` VARCHAR(30) NOT NULL,
  `number_arp` VARCHAR(50) NOT NULL,
  `item_arp` VARCHAR(50) NOT NULL,
  `nature_expense_id` INT NOT NULL,
  `sub_item` INT NOT NULL,
  `article` INT NOT NULL,
  `incisive` INT NOT NULL,
  `status_id` INT NOT NULL,
  `created_at` DATETIME NULL,
  `updated_at` DATETIME NULL,
  `isActive` TINYINT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_registers_oms_idx` (`oms_id` ASC) VISIBLE,
  INDEX `fk_registers_modality1_idx` (`modality_id` ASC) VISIBLE,
  INDEX `fk_registers_credit1_idx` (`credit_id` ASC) VISIBLE,
  INDEX `fk_registers_suppliers1_idx` (`suppliers_id` ASC) VISIBLE,
  INDEX `fk_registers_nature_expense1_idx` (`nature_expense_id` ASC) VISIBLE,
  INDEX `fk_registers_status1_idx` (`status_id` ASC) VISIBLE,
  CONSTRAINT `fk_registers_oms`
    FOREIGN KEY (`oms_id`)
    REFERENCES `sisprotocolo`.`oms` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_registers_modality1`
    FOREIGN KEY (`modality_id`)
    REFERENCES `sisprotocolo`.`modality` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_registers_credit1`
    FOREIGN KEY (`credit_id`)
    REFERENCES `sisprotocolo`.`credit` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_registers_suppliers1`
    FOREIGN KEY (`suppliers_id`)
    REFERENCES `sisprotocolo`.`suppliers` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_registers_nature_expense1`
    FOREIGN KEY (`nature_expense_id`)
    REFERENCES `sisprotocolo`.`nature_expense` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_registers_status1`
    FOREIGN KEY (`status_id`)
    REFERENCES `sisprotocolo`.`status` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


CREATE TABLE `registers_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `registers_id` int(11) NOT NULL,
  `number` int(8) DEFAULT NULL,
  `name` varchar(256) NOT NULL,
  `uf` varchar(4) NOT NULL,
  `quantity` float(9,3) NOT NULL COMMENT 'Quantidade solicitada',
  `delivered` float(9,3) NOT NULL COMMENT 'Quantidade entregue',
  `value` float(9,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_requests_items_registers_idx` (`registers_id`),
  CONSTRAINT `fk_requests_items_registers` 
  FOREIGN KEY (`registers_id`) REFERENCES `registers` (`id`)
) DEFAULT CHARACTER SET = utf8 COMMENT='Items das solicitações';


-- -----------------------------------------------------
-- Table `sisprotocolo`.`users_login`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sisprotocolo`.`users_login` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(88) NOT NULL,
  `password` VARCHAR(60) NOT NULL,
  `name` VARCHAR(13) NOT NULL,
  `email` VARCHAR(108) NULL DEFAULT NULL,
  `level` TINYINT(4) NOT NULL,
  `change_password` TINYINT(4) NULL DEFAULT 1,
  `created_at` DATETIME NULL,
  `updated_at` DATETIME NULL,
  `isActive` TINYINT NULL DEFAULT NULL,
  `oms_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_users_login_oms_idx` (`oms_id` ASC) VISIBLE,
  CONSTRAINT `fk_users_login_oms`
    FOREIGN KEY (`oms_id`)
    REFERENCES `sisprotocolo`.`oms` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;



CREATE TABLE IF NOT EXISTS `historic_status_registers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `registers_id` int(11) NOT NULL,
  `users_id` int(11) NOT NULL,
  `status_id` int(11) NOT NULL,
  `resulting_document` varchar(30) NOT NULL,
  `user_name` varchar(50) NOT NULL,
  `date_action` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_historic_status_registers_1_idx` (`registers_id`),
  KEY `fk_historic_status_registers_2_idx` (`users_id`),
  CONSTRAINT `fk_historic_status_registers_1`
    FOREIGN KEY (`registers_id`)
    REFERENCES `registers` (`id`),
  CONSTRAINT `fk_historic_status_registers_2`
    FOREIGN KEY (`users_id`)
    REFERENCES `users_login` (`id`)
);


CREATE TABLE IF NOT EXISTS `biddings` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `number` VARCHAR(10) NOT NULL,
  `uasg` INT(6) NOT NULL,
  `uasg_name` VARCHAR(100) NOT NULL,
  `oms_id` int(11) NOT NULL,
  `description` VARCHAR(30) NULL,
  `validate` DATE NOT NULL,
  `created_at` DATE NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `number_UNIQUE` (`number` ASC),
  INDEX `fk_biddings_oms_idx` (`oms_id` ASC) VISIBLE,
  CONSTRAINT `fk_biddings_oms` FOREIGN KEY (`oms_id`) REFERENCES `oms` (`id`))
ENGINE = InnoDB
COMMENT = 'Licitações do sistema';


CREATE TABLE IF NOT EXISTS `biddings_items` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `biddings_id` INT NOT NULL,
  `suppliers_id` INT NOT NULL,
  `number` INT(5) NOT NULL,
  `name` VARCHAR(256) NOT NULL,
  `uf` VARCHAR(4) NOT NULL,
  `quantity` float(9,3) NOT NULL,
  `quantity_compromised` float(9,3) DEFAULT NULL,
  `quantity_committed` float(9,3) DEFAULT NULL,
  `quantity_available` float(9,3) DEFAULT NULL,
  `value` FLOAT(9,2) NOT NULL,
  `active` VARCHAR(3) NOT NULL DEFAULT 'yes',
  PRIMARY KEY (`id`),
  INDEX `fk_biddings_items_biddings1_idx` (`biddings_id` ASC),
  INDEX `fk_biddings_items_suppliers1_idx` (`suppliers_id` ASC),
  CONSTRAINT `fk_biddings_items_biddings1`
    FOREIGN KEY (`biddings_id`)
    REFERENCES `biddings` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_biddings_items_suppliers1`
    FOREIGN KEY (`suppliers_id`)
    REFERENCES `suppliers` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Itens das Licitações Registradas no Sistema';

CREATE TABLE IF NOT EXISTS `biddings_oms_lists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `biddings_id` int(11) NOT NULL,
  `oms_id` int(11) NOT NULL,
  PRIMARY KEY (`id`,`biddings_id`,`oms_id`),
    KEY `fk_biddings_has_oms_oms1_idx` (`oms_id`),
    KEY `fk_biddings_has_oms_biddings1_idx` (`biddings_id`),
  CONSTRAINT `fk_biddings_has_oms_biddings1`
    FOREIGN KEY (`biddings_id`)
    REFERENCES `biddings` (`id`)
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_biddings_has_oms_oms1` FOREIGN KEY (`oms_id`) REFERENCES `oms` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;


INSERT INTO `oms` VALUES (1,'OM PADRAO','OMPADR',1),(2,'Centro Intendência da Marinha em Niterói','CITNIT',1),(3,'NAVIO-AERÓDROMO MULTIPROPÓSITO ATLÂNTICO','NAMATL', 1),(4,'FRAGATA RADEMAKER','FRADEM',1),(5,'NAVIO-TANQUE ALMIRANTE GASTÃO MOTTA','NTGMTA',1),(6,'CORVETA BARROSO','CVBARR',1),(7,'NAVIO VELEIRO CISNE BRANCO','NVECBR',1),(8,'NAVIO-ESCOLA BRASIL','NEBRSL',1),(9,'FRAGATA LIBERAL','FLIBER',1),(10,'NAVIO DE DESEMBARQUE DE CARROS DE COMBATE ALMIRANTE SABOIA','NDCCSB',1),(11,'FRAGATA INDEPENDÊNCIA','FINDEP',1),(12,'NAVIO DE DESEMBARQUE DE CARROS DE COMBATE MATTOSO MAIA','NDCCMM',1),(13,'FRAGATA DEFENSORA','FDEFEN',1),(14,'FRAGATA UNIÃO','FUNIAO',1),(15,'CORVETA JULIO DE NORONHA','CVJULI',1),(16,'FRAGATA GREENHALHG ','FGREEN',1),(17,'FRAGATA CONSTITUIÇÃO ','FCONST',1),(18,'NAVIO DOCA MULTIPROPÓSITO BAHIA ','NDMPBA',1),(19,'SUBMARINO TUPI','SBTUPI',1),(20,'SUBMARINO TAMOIO','SBTMOI',1),(21,'SUBMARINO TIKUNA','SBKUNA',1),(22,'NAVIO DE SOCORRO SUBMARINO GUILLOBEL','NSSBEL',1),(23,'RbAMTritao','RTRTAO',1),(24,'CORVETA CABOCLO','CVCBCL',1);


INSERT INTO `users_login` (`username`, `password`, `name`, `email`, `level`, `change_password`, `created_at`, `updated_at`, `isActive`, `oms_id`) VALUES ('administrator', '$2y$11$gQNC3HGp7t5/Bd7xSY/D0.82OOaEUv2zxSoQeP5TMSNhySs1zAOf6', 'Administrator', 'admin@test.com', '1', '1', '2022-06-15', '2022-06-15', '1', '1');

INSERT INTO `sisprotocolo`.`nature_expense` (`name`, `isActive`) VALUES ('339030', '1');

INSERT INTO `process_type` (`name`, `isActive`) VALUES ('SOLEMP', '1');
INSERT INTO `process_type` (`name`, `isActive`) VALUES ('Dispensa Eletrônica', '1');

INSERT INTO `modality` (`name`, `isActive`) VALUES ('Dispensa de Licitação', '1');
INSERT INTO `modality` (`name`, `isActive`) VALUES ('Pregão Eletrônico', '1');
INSERT INTO `modality` (`name`, `isActive`) VALUES ('Concorrência', '1');
INSERT INTO `modality` (`name`, `isActive`) VALUES ('Tomada de Preços', '1');
INSERT INTO `modality` (`name`, `isActive`) VALUES ('TJDL', '1');
INSERT INTO `modality` (`name`, `isActive`) VALUES ('TJIL', '1');

INSERT INTO `credit` (`oms_id`, `credit_note`, `value`, `isActive`, `created_at`, `updated_at`) VALUES (1, 'Lei nº 8.666/1993', 17.600, '1', '2022-06-15', '2022-06-15');
INSERT INTO `credit` (`oms_id`, `credit_note`, `value`, `isActive`, `created_at`, `updated_at`) VALUES (1, 'Lei nº 14.133/2021', 50.000, '1', '2022-06-15', '2022-06-15');


INSERT INTO status VALUES(1,'PROT. OBT.','PROTOCOLADO NA OBTENÇÃO',1);
INSERT INTO status VALUES(2,'PROT. EXE.','PROTOCOLADO NA EXECUÇÃO',1);
INSERT INTO status VALUES(3,'ENV. EXE.','ENVIADO PARA EXECUÇÃO',1);
INSERT INTO status VALUES(4,'EMPENHADO','DATA EM QUE O DOCUMENTO FOI EMPENHADO',1);
INSERT INTO status VALUES(5,'DEV. OBT','DEVOLVIDO À OBTENÇÃO',1);
INSERT INTO status VALUES(6,'DEV. EXE.','DEVOLVIDO À EXECUÇÃO FINANCEIRA',1);
INSERT INTO status VALUES(7,'ASSINADO','DATA EM QUE O DOCUMENTO FOI ASSINADO',1);
INSERT INTO status VALUES(8,'ENV. NE OM','NOTA DE EMPENHO ENVIADO PARA A OM DE ORIGEM',1);
INSERT INTO status VALUES(9,'DEV. OM','DEVOLVIDO À OM DE ORIGEM',1);
INSERT INTO status VALUES(10,'NF ENT. EXE.','DATA DE ENTREGA DA NOTA FISCAL NA EXECUÇÃO FINANCEIRA',1);
INSERT INTO status VALUES(11,'NR DA NF','NÚMERO DA NOTA FISCAL',1);
INSERT INTO status VALUES(12,'NF LIQ.','NOTA FISCAL LIQUIDADA',1);
INSERT INTO status VALUES(13,'NF SOL. REC.','SOLICITAÇÃO DE RECURSO PARA PAGAMENTO',1);
INSERT INTO status VALUES(14,'NR DA PF','NÚMERO DA PROGRAMAÇÃO FINANCEIRA',1);
INSERT INTO status VALUES(15,'NF PAGA','NOTA FISCAL PAGA',1);
INSERT INTO status VALUES(16,'NR DA OB','NÚMERO DA ORDEM BANCÁRIA',1);
INSERT INTO status VALUES(17,'NR DA NE','NÚMERO DA NOTA DE EMPENHO',1);
INSERT INTO status VALUES(18,'ASS. CP.','DATA DA ASSINATURA DA CP',1);
INSERT INTO status VALUES(19,'ENT. SECOM','DATA DE ENTRADA NA SECOM - CeIMBe',1);
INSERT INTO status VALUES(20,'ENT. POSTAL','DATA DE ENTREGA NA POSTAL',1);
INSERT INTO status VALUES(21,'ENT. OPERADOR','DATA DE ENTREGA PARA O OPERADOR SIAFI',1);
INSERT INTO status VALUES(22,'PARA ASS.','DOCUMENTO ENVIADO PARA ASSINATURA',1);


INSERT INTO `suppliers` VALUES (1,'PADARIA e CONFEITARIA FLOR DO BRASIL LTDA','42.509.174/0001-24','ENDEREÇO: Av. Dom Helder Câmara no. 35-F – Benfica - Rio de Janeiro - RJ&#10;CEP: 20911-290&#10;CNPJ: 42.509.174/0001-24&#10;REPRESENTANTE: Sr. Henrique Loureiro Monteiro&#10;TELEFONE: 3890-2390 e 3890-4506&#10;E-MAIL: adm@flordobrasil.com.br'),(2,'DISTRIBUIDORA KARDU DE ALIMENTOS LTDA','30.806.616/0001-15','ENDEREÇO: R. Capitão Félix, 110, Rua 03, Lojas 18 a 22, CADEG, São Cristóvão, Rio de&#10;Janeiro/RJ&#10;CEP: 20.920-310&#10;REPRESENTANTE: Sr. Carlos Alberto de Jesus Araripe Pereira&#10;TELEFONE: 2428-3640&#10;E-MAIL: kardu.atendimento@terra.com.br '),(3,'KRAFT ALIMENTOS LTDA','97.413.058/0001-07','ENDEREÇO: Rua d0 Arroz, 71, Mercado S. Sebastião, Rio de Janeiro - RJ.&#10;CEP: 21.011-100&#10;REPRESENTANTE: Sr. Maurício&#10;TELEFONE: . 2584-0088&#10;E-MAIL: kraftcmw@ig.com.br'),(4,'ERMAR ALIMENTOS LTDA','27.051.838/0001-60','ENDEREÇO: Av. Brasil, 19.001 Pav. 13 – Boxes 05 a 10, 12 e 14 - Ceasa - Coelho Neto, Rio de&#10;Janeiro – RJ&#10;TELEFAX: 3014-7500&#10;CEP: 21.530-001&#10;REPRESENTANTE: Sr. José Fernando&#10;E-MAIL: ermar@uol.com.br'),(5,'LAMIR RIO COMERCIO DISTRIBUIÇÃO E SERVIÇOS LTDA','04.658.138/0001-33','ENDEREÇO: Rua: Fernandes Pinheiro, 10 – Penha, Rio de Janeiro – RJ&#10;CEP: 21.020-030&#10;REPRESENTANTE: Sra. Ana Maria&#10;TELEFONE.: 3888-4568&#10;E-MAIL: lamirio@bol.com.br'),(6,'LC COMERCIAL LTDA','72.649.486/0001-02','ENDEREÇO: Rua do Arroz, 90 - sala 460 - Mercado São Sebastião - Rio de janeiro - RJ&#10;CEP: 21019-900.&#10;REPRESENTANTE: Sra. Francelle&#10;Celular: 9808790&#10;TELEFAX: 2584-6487&#10;E-MAIL: lc02@uol.com.br&#10;'),(7,'INDUSTRIA DE PÃO SÃO VICTOR DE LUCAS LTDA','04.084.316/0001-60','ENDEREÇO: Rua Aguapé, no 07 Parada de Lucas - RJ&#10;CEP: 21010-080&#10;REPRESENTANTE: Sr. Gilmar Pires&#10;TEL: 9246-1462&#10;TELEFAX: 3137-0476/3341-5848/3137-0792&#10;E-MAIL: pirese@ig.com.br'),(8,'MARILANGE COM. E DIST. DE PRODUTOS ALIM. LTDA','03.367.904/0001-48','ENDEREÇO: Av. Brasil, 19001 PAV 14 Box 32 a 34 Irajá Rio de Janeiro - RJ&#10;CEP: 21530-000&#10;REPRESENTANTE: Sra Aline dos Santos Kamaroff&#10;TELEFAX: 3371-0366 / 2473-2170 / 3014-7476 / 2471-8402&#10;E-MAIL: marilange@veloxmail.com.br'),(9,'HORTIFRUTI POMAR VERDE DA ROÇA LTDA','05.128.409/0001-01','ENDEREÇO: Rua Andrade Figueira, 64 Loja A – Madureira - RJ&#10;CEP: 21.060.100&#10;REPRESENTANTE: Sr. Paulo Henrique&#10;TEL: 3186-5898&#10;'),(10,'BOTA NO PÃO COMÉRCIO LTDA','02.320.241/0001-43','ENDEREÇO: Rua Adolfo Bergamini, 90-A Engenho de Dentro - RJ&#10;CEP: 20730-000&#10;REPRESENTANTE: Sr. Wallace Ferreira de Oliveira&#10;TELEFAX: 021-3376.5643/3371.4430&#10;E-MAIL: botanopao@zipmak.com.br'),(11,'NETOPAN IND/COM DE PRODUTOS ALIMENTÍCIOS LTDA','01.529.978/0001-08','ENDEREÇO: Estrada Nilo Peçanha, 895 _ Olinda - Nilopolis - RJ&#10;CEP: 26.545-200&#10;REPRESENTANTE: Sr. Ana Lúcia&#10;TELEFAX: 2791-5790 2691-6409 3761-1616&#10;E-MAIL: contato@sorvetesnetinho.com.br analucia@sorvetesnetinho.com.br'),(12,'CITRAL ALIMENTOS LTDA','02.333.688/0001-57','ENDEREÇO: Rua da Batata, 102 e 104 - Boxes - 43 e 44 - Penha - RJ&#10;CEP: 21011-020&#10;REPRESENTANTE: Sr. Madson Seixas Ferreira&#10;TELEFAX: 2584-3859&#10;FAX: 2584-3058/2880/1873&#10;E-MAIL: citral@bol.com.br'),(13,'MAR DO SUL ALIMENTOS LTDA','01.157.519/0001-40','ENDEREÇO: Rua Cap. Felix, 110 R - 02 LJ. 08 - Benfica - Rio de Janeiro - RJ.&#10;CEP: 20920-900&#10;REPRESENTANTE: Eliane Fontes de Mattos&#10;TELEFONE: 3860-8848&#10;FAX: 3860-8848 / 3860-4904&#10;E-MAIL: mardosul.alimentos@gmail.com'),(14,'COMERCIAL FRUTISFRU LTDA','01.854.951/0001-90','ENDEREÇO: Av. Brasil, 19.001 - Pavilhão 42 - Box 18 D Irajá - CEASA - RJ -&#10;CEP: 21530-000&#10;REPRESENTANTE: Sr. Luiz Ferreira - Celular - 9911 - 8452&#10;TEL: 3371-4366&#10;FAX: 3371-2133&#10;'),(15,'FORNECEDORA DE PRODUTO ALIMENTÍCIOS BEM FORTE LTDA','03.214.578/0001-39','ENDEREÇO: Rua Domingos Lopes, 508 Loja - 101 Madureira RJ&#10;CEP: 21310-120&#10;REPRESENTANTE: Sr. Eloy João Damicollor Sherner&#10;TELEFAX: 3018-7393'),(16,'FORNECEDORA THORI DE GÊNEROS ALIM. LTDA','28.863.843/0001-30','ENDEREÇO: Av. Brasil, no 19.001 = Pav - 72 Box - 03 Irajá - RJ&#10;CEP: 21539-900&#10;REPRESENTANTE: Sr. João Roberto Candido&#10;TELE: 3371-0288&#10;FAX: 2471-7625&#10;E-MAIL: thori@terra.com.br'),(17,'FRIGOCARNES CENTRAL DE PRODUTOS ALIMENTÍCIOS LTDA','39.630.496/0001-12','ENDEREÇO: Rodovia José Sette, Km 13 - Porto de Cariacica - Cariacica - ES&#10;CEP: 29156-650&#10;REPRESENTANTE: Sr. Elson Corrêa Dias&#10;TELEFAX: (27) 3254-9000&#10;E-MAIL: frigocarnes@terra.com.br'),(18,'DISTRIBUIDORA DE GÊNEROS ALIMENTICIOS VEREDA GRANDE RIO LTDA','04.750.594/0001-09','ENDEREÇO: Rua Capitão Felix, nr 110 - Rua 2 - loja 21 - Cadeg - Benfica - RJ&#10;CEP: 2090310&#10;REPRESENTANTE: Sr. Anderson da Silva&#10;TELEFAX: (21) 3860-0713 , 3860 0989 e 3860-0450'),(19,'IDÉIA VITAL COMÉRCIO DE ALIMENTOS LTDA','00.104.767/0001-60','ENDEREÇO: Rua: Capitão Félix, 110 – sala 334 – Benfica, Rio de Janeiro – RJ&#10;CEP: 20.920-310&#10;REPRESENTANTE: Ana Maria Passos de Oliveira&#10;TELEFAX: 21-3860-5293 - 21-3860-5253&#10;E-MAIL: ideiavital@ig.com.br'),(20,'DISTRIBUIDORA DE ALIMENTOS AMFER LTDA','02.522.915/0001-92','ENDEREÇO: R. Rolândia, 34 - A Higienópolis - Rio de Janeiro&#10;CEP- 21061-060&#10;REPRESENTANTE: Sr. Amilton Stryk - Tel.: 7834-3945TELEFAX: 3868-0377 3866-4587 3866-4759 FAX 3866-4828'),(21,'ALIFORTE ALIMENTOS LTDA','01.147.385/0001-87','ENDEREÇO: Rua do arroz, 71/71 A - Penha - RJ&#10;CEP: 21011-070&#10;REPRESENTANTE: Sr Mauricio&#10;TEL: 2584-1424&#10;FAX: 2676-8730'),(22,'MASAN COMERCIAL DISTRIBUIDORA LTDA','00.801.512/0001-57','ENDEREÇO: Rua Projetada A Lote 4 Quadra 7 - Figueira -Duque De Caxias - RJ&#10;CEP: 25240-130&#10;REPRESENTANTE: Sr Francisco Mantuano de Luca&#10;TEL: 2676-8730&#10;FAX: 2676-1286/4352'),(23,'PROSADI COMERCIAL EIRELI','05.007.267/0001-24','ENDEREÇO: Rua Capitão Félix, 110 - R - 02 L - 19 Benfica Rio de Janeiro RJ&#10;CEP: 20920-310&#10;REPRESENTANTE: Sra Maurício&#10;TELEFAX: 3890-0499 / 3860-0376/8404 / 2434 / 3580-0421&#10;E-MAIL: prosadi@veloxmail.com.br'),(24,'EXPRESS FOOD RIO LTDA','00.788.856/0001-73','ENDEREÇO: Rua Olimpia Esteves No 89 - Galpão - Padre Miguel -RJ&#10;CEP: 21775-000&#10;REPRESENTANTE: Sr Darlan Thebas&#10;TEL: 3332-7516&#10;FAX: 3337-0739'),(25,'MAMY COMERCIO ALIMENTOS LTDA','28.091.858/0001-28','ENDEREÇO: Capitão Félix 110 Rua 5 Loja 9 - São Cristóvão&#10;CEP: 20920-900&#10;CNPJ: 28.091.858/0001-28&#10;REPRESENTANTE: Sra Sônia&#10;TEL: 3473-0377 / 9978-2559&#10;FAX: 3860-4033'),(26,'SOGEL RIO COMÉRCIO DE ALIMENTOS LTDA','32.034.845/0001-94','ENDEREÇO: Rua Lopes Trovão, n° 42 Benfica Rio de Janeiro - RJ&#10;CEP: 20 920 340&#10;REPRESENTANTE: Sr. Lenílson Marques da Silveira CEL: 99879822&#10;TELEFONE: 2589-1542&#10;FAX: 2585-2919&#10;'),(27,'JÚ DISTRIBUIDORA DE GENEROS LTDA','68.575.018/0001-55','ENDEREÇO: Rua Capitão Felix 110 Rua 5 Loja 4 - São Cristóvão -RJ&#10;CEP: 20920-310&#10;REPRESENTANTE: Sr. Abelardo Ricardo de O. Filho&#10;TEL: 3860-6133'),(28,'CEAZZA DIST. DE FRUTAS, VERDURAS E LEGUMES LTDA','65.941.775/0004-50','ENDEREÇO: Rua São Ciro, 200 Jardim América - Rio de Janeiro - RJ&#10;CEP: 21240-130&#10;REPRESENTANTE: Sr. Marcos Paulo Santos de Oliveira&#10;TELEFONE: 2471-1474&#10;E-MAIL: ceazzarj@ig.com.br'),(29,'FM DEODORO DE CEREAIS LTDA','39.067.921/0001-07','ENDEREÇO: Estrada São Pedro de Alcântara, 214 - Galpão - B - Deodoro - RJ&#10;CEP: 21615-310&#10;REPRESENTANTE: Sr. Maurício Cel: 9627-6267&#10;TELEFONE: 3838-0735'),(30,'COMERCIAL MILANO BRASIL LTDA','01.920.177/0001-79','ENDEREÇO: Est: Velha de Pilar, no 1083 Bairro - Chácara, Rio Petrópolis Duque de Caxias-RJ&#10;CEP: 25.243-260&#10;REPRESENTANTE: Sra Mônica Rodrigues – Cel – 21-99126-9412&#10;TELEFONE: 3527 8797( RAMAL 1015)&#10;E-MAIL: digitacao@milanobrasil.com.br'),(31,'DISTRIBUIDORA DE AGUAS MINERAIS FONTE DE DAVI LTDA','03.037.209/0001-18','ENDEREÇO: Av. Bras de Pina No 05 Loja D -Penha -RJ&#10;CEP: 21940-120&#10;REPRESENTANTE: Sra Magna do Nascimento e Silva&#10;TEL: 2560-6186 / 2269-8863 / 2560-1094'),(32,'VIC VINNI FORNECEDORA DE ALIMENTOS LTDA','03.633.181/0001-81','ENDEREÇO: Capitão Felix 110 - Rua 2 Loja 20 - Benfica - RJ&#10;CEP: 20920-310&#10;REPRESENTANTE: Sr Ulysses&#10;TEL: 2580-4791'),(33,'WIMAGI COMÉRCIO E DISTRIBUIÇÃO LTDA','02.726.452/0001-80','ENDEREÇO: Rua Capitão Félix, 110 – Sl – 406 – CADEG - Benfica – Rio de Janeiro -RJ&#10;CEP: 20920-310&#10;REPRESENTANTE: Max Milson&#10;TELEFAX: (21) 2580-2853 / (21) 99477-3186&#10;EMAIL : vendas.wimagi@hotmail.com'),(34,'NEONUTRI COMÉRCIO DESENVOLVIMENTO DE ALIMENTOS LTDA','04.322.638/0001-08','ENDEREÇO: Rua Capitão Félix, 110 - Gal - 4 lj - 19 - Benfica - RJ&#10;CEP: 20920-310&#10;REPRESENTANTE: Ana Lúcia&#10;TEL: 3878-5362&#10;E-MAIL: neonutri@neonutri.com.br'),(35,'INDUSTRIA ALIM. M. CLARO DE MERITI LTDA','28.996.338/0001-64','ENDEREÇO: Av. Nossa Senhora de Fátima -3276 - Villar dos Teles - São João do Meriti -RJ&#10;CEP: 25.000-000&#10;REPRESENTANTE: Sr. Carlos Tel: 2751-4544&#10;E-MAIL: gelomonteclaro@ig.com.br'),(36,'PROGRESSO ALIMENTOS IMPORTAÇÃO E EXPORTAÇÃO LTDA','05.305.068/0001-00','ENDEREÇO: Rua Salomão Camargos - 64 - Jardinópolis – Belo Horizonte -MG&#10;CEP: 30.512.640&#10;REPRESENTANTE: Sr. Aridalton&#10;TELEFAX: 0xx (031) – 3333-0920'),(37,'H. R. COMÉRCIO E IND. DE PESCADOS LTDA','31.585.821/0001-60','ENDEREÇO: Rodovia Amaral Peixoto KM -15 - Inoã - Maricá - RJ&#10;CEP: 24910-000&#10;REPRESENTANTE: Sr. Luciano da Silva Cardoso&#10;Cel.: 9994-0969&#10;TELEFONE: 0xx (21) - 2636-5145 2636-5316'),(38,'LIESYNIL COMERCIAL LTDA','03.215.350/0001-63','ENDEREÇO: Rua José Francisco Zeca , 250 Sala 01 –Lote Jardim Vista Mar S. Pedro da Aldeia, RJ.&#10;CEP.: 28940000&#10;REPRESENTANTE: Sr. José Luiz Pimenta Soares&#10;E-MAIL: flasco@uol.com.br'),(39,'TRIVETTER COMERCIO DE ALIMENTOS LTDA','05.218.434/0001-86','ENDEREÇO: Rua Nacional, 155 - loja – B , Taquara - Jacarepaguá - RJ&#10;CEP: 22710-091&#10;REPRESENTANTE: Sr. Mauro José&#10;TELE: 2443-2164'),(40,'RUMO DA LUA ALIMENTOS LTDA','42.425.389/0001-67','ENDEREÇO: Rua Capitão Félix, 110 – Térreo – Galeria 5 loja 02 BENFICA - RJ&#10;CEP: 20920-310&#10;REPRESENTANTE: Sr. Viviane Cristine Brito Jacinto&#10;TELEFAX: 3878-4800 - 3878-4848&#10;E-MAIL: rumodalua.alimentos@gmail.com'),(41,'MASGOVI COMÉRCIO IMP. E EXP. LTDA','01.859.823/0001-30','ENDEREÇO: Rua Montevideo, 1122 Penha - RJ&#10;CEP: 21020290&#10;REPRESENTANTE: Sr. Luiz Antonio&#10;TEL: 3888-1591&#10;FAX: 3888-1590 2290-5892&#10;E-MAIL: licita@masgovi.com.br'),(42,'CAPITANIA DO PEIXE COMÉRCIO DE ALIMENTOS LTDA','03.833.398/0001-35','ENDEREÇO: Rua Capitão Félix, 110 lojas 6e 7 Galeria 6 Benfica RJ&#10;CEP: 20920310&#10;REPRESENTANTE: Sr. José Magalhães Ferreira&#10;TELEFAX: 3890-8002&#10;E-MAIL: capitania@capitaniadopeixe.com.br'),(43,'AGRIGEL COMÉRCIO LTDA','02.552.893/0001-03','ENDEREÇO: Rua Caruna, 692 – Parada de Lucas - RJ&#10;CEP: 21010-070&#10;REPRESENTANTE: Sra. Eliza&#10;TEL: 3464-0475&#10;FAX: 2485-6736'),(44,'DISTRIBUIDORA DE ALIMENTOS SOL DA TRAVESSA LTDA','04.285.914/0001-05','ENDEREÇO: Est. Rio São Paulo, 1581 Campo Grande RJ&#10;CEP: 23087-005&#10;REPRESENTANTE: Sr. Jair Renato&#10;TEL: 3403-2601&#10;FAX; 2413-1275'),(45,'CITRO CARDILLI COMÉRCIO IMPORTAÇÃO E EXPORTAÇÃO LTDA','02.115.482/0001-50','ENDEREÇO: Rua Mergenthaler, 1.069 Vila Leopoldina São Paulo - SP&#10;CEP: 05311-030&#10;REPRESENTANTE: Sra. Camila&#10;TEL: 0XX (11) 3835-8203&#10;FAX: 0XX (11) 3831-1311&#10;E-MAIL: citrocardlli@citrocardilli.com.br'),(46,'MULTIFRIGO COMÉRCIO E IMPORTAÇÃO LTDA','04.200.446/0001-10','ENDEREÇO: Est. de Jacarepaguá, 7655 Sala 621 – Freguesia – Rio de Janeiro - RJ&#10;CEP: 22753-045&#10;REPRESENTANTE: Sr. André Monteiro&#10;TEL: 2456-2193&#10;FAX: 3413-3554&#10;E-MAIL multifrigo@rjnet.com.br'),(47,'PADARIA E CONFEITARIA COSTA BASTOS','33.858.663/0001-09','ENDEREÇO: Rua Riachuelo, 263 – Centro – Rio de Janeiro, RJ&#10;CEP: 20230-011&#10;REPRESENTANTE: Sr. José Severiano Câmara&#10;TEL: 2232-9371/2242-4744&#10;FAX: 2232-1776&#10;E-MAIL cbastos2012@gmail.com'),(48,'EDBRÁS COMERCIO DE ALIMENTOS LTDA-ME','06.032.711/0001-24','ENDEREÇO: Rua Tomas Lopes, 782, loja “F”, Vila da Penha – Rio de Janeiro, RJ&#10;CEP: 21221-210&#10;REPRESENTANTE: Sr. Edilson Pereira Pedrosa&#10;TEL: 3457-2525/3457-4331/8894-4331&#10;FAX: 3457-2525'),(49,'J. SODRE PRODUTOS ALIMENTICIOS EM GERAL-ME','02.134.603/0001-01','ENDEREÇO: Av. Sta Catarina 47, sala 207, Jardim Catarina – São Gonçalo, RJ&#10;CEP: 24717-140&#10;TEL: 2603-1067/2614-1151&#10;E-MAIL jdsodre@uol.com.br'),(50,'JCP DISTRIBUIDORA E REPRESENTAÇÕES LTDA','01.906.466/0001-13','ENDEREÇO: Rua Cacequí, 74, Brás de Pina – Rio de Janeiro, RJ&#10;CEP: 21.210-760&#10;TEL: 2560-2559 / 2560-2913&#10;FAX: 2560-2559 / 2560-2913'),(51,'RCL COMERCIAL LTDA','05.421.892/0001-18','ENDEREÇO: SCN QUADRA I BL. F SALA 1003 Brasília , DF&#10;CEP: 70.771-905&#10;REPRESENTANTE: Sr. Luiz Fernando /Sra. Roberta&#10;TEL: (21) 2584-3580&#10;FAX: (21) 2584-6487&#10;E-MAIL: gjacobsen@uol.com.br'),(52,'MARPES COMERCIO DE PESCADO LTDA','03.550.055/0001-63','ENDEREÇO: Rua Merval de Gouveia, 435, Cascadura – Rio de Janeiro, RJ&#10;CEP: 21311-110&#10;REPRESENTANTE: Sr. José Mauricio Ferreira Telles&#10;TEL: 2290 4438&#10;FAX: 3866-3473&#10;E-MAIL: marpespescados@ig.com.br'),(53,'BAZAR ROSÁRIO BENTO DA VOVÓ LTDA','04.878.597/0001-22','ENDEREÇO: Rua Capitão Félix, 110, Galeria 02, loja 11 Benfica – Rio de Janeiro, RJ&#10;CEP: 20928-900&#10;REPRESENTANTE: Srta. Cintia Lima de Arruda&#10;TEL: 3878-8434&#10;FAX: 3878-8434 / 3890-2418&#10;E-MAIL brbento@bol.com.br'),(54,'PADARIA MARIA FARINHA LTDA','04.390.887/0001-22','ENDEREÇO: Rua: Dr. Agenor de Almeida Loyola, No 50 – Bancários – Ilha do Governador- RJ.&#10;CEP: 21.911-310&#10;REPRESENTANTE: Sra. Kelly Cristina dos Santos Ferreira&#10;TEL/ FAX: (21) 2467-3436&#10;E-MAIL padariamariafarinha@yahoo.com.br'),(55,'FRIGOALPHA COM. DE GÊNEROS ALIMENTÍCIOS LTDA','02.394.368/0001-07','ENDEREÇO: Granja Modelo do Torto s/n GM 03 – Frigorífico – Brasília - DF.&#10;CEP: 70.620-200&#10;REPRESENTANTE: Sr. Cléber Moraes (Celular: (21) 8206 0447)&#10;TEL: *(61) 3468 7474&#10;E-MAIL www.frigoalpha.com.br'),(56,'TAVARES COMESTÍVEIS LTDA','29.653.086/0001-33','ENDEREÇO: R. Capitão Félix, 110 Rua 1 – Lj. 17 e 18 – Benfica – Rio de Janeiro - RJ.&#10;CEP: 20.928-900&#10;REPRESENTANTE: Sr. Raimundo Luiz Pussente&#10;TEL: (21) 3890 1493 / 3890 1080 / 3860 8873'),(57,'PREMIAR COM. DIST. E REP. LTDA','00.771.306/0001-41','ENDEREÇO: Rua Herval de Gouveia, 437 – Cascadura - RJ.&#10;CEP: 21.311-110&#10;REPRESENTANTE: Sr. Antônio José Ferreira Telles&#10;TEL: (21) 3555-0190'),(58,'G.A. BARBOSA COMERCIAL LTDA','05.200.675/0001-06','ENDEREÇO: Estrada do Pau Ferro, 94 sala 216 – Jacarepaguá - RJ&#10;CEP: 22.743-051&#10;REPRESENTANTE: Sr. José Luiz do Nascimento Mendes&#10;TEL: (21) 2269 7045 / 3178-4408&#10;FAX: (21) 2595 2256&#10;E-MAIL: gabarbosacomercial@ig.com.br'),(59,'PROSPERITY DIST. PROD. ALIMENTÍCIOS LTDA','07.416.412/0001-56','ENDEREÇO: Rua Olga Hermont, 1193 – parte – Centro - Nilopoles - RJ&#10;CEP: 25.540-150&#10;REPRESENTANTE: Sr. Jailton da Silva Robaina&#10;TEL: (21) 2692 5570/2482 3652&#10;CEL: 97585820'),(60,'JC VALENTE – FRUTAS E LEGUMES LTDA','28.864.726/0001-91','ENDEREÇO: Rua Suez, 155 – Fundos – Bangu - RJ&#10;CEP: 21.820-250&#10;REPRESENTANTE: Sr. Severino TAVARES da Silva tel: 7837 3559&#10;TEL: (21) 3332 1588&#10;FAX: (21) 3332 3256&#10;E-MAIL: jcvalente3@ig.com.br'),(61,'RIOMAR 2001 DISTR. ALIM. E DESCARTÁVEIS LTDA','05.057.706/0001-03','ENDEREÇO: Av Pastor Martins Luther King Júnior, 10789 – Coelho Neto - RJ&#10;CEP: 21.530-015&#10;REPRESENTANTE: Sr. Noé Carneiro dos Santos&#10;TEL: (21) 3837-0076&#10;FAX: (21) 3837-0076&#10;E-MAIL: riomar01bp@yahoo.com.br'),(62,'CELEIRO DO RIO FRIO ALIMENTOS LTDA','29.998.838/0001-06','ENDEREÇO: R – Capitão Félix, 110, PAV 02 – LJ 60 – Benfica - RJ&#10;CEP: 20.920-310&#10;REPRESENTANTE: Sr. David . Moreira&#10;TEL: (21) 3890 4710'),(63,'MATMALAP REPRESENTAÇÃO E COM. IMP. E EXPORTAÇÃO LTDA','00.429.972/0001-04','ENDEREÇO: R Montevidéu, 1297, LJ K – Penha - RJ&#10;CEP: 21.020-290&#10;REPRESENTANTE: Sr. Antônio Domingos Neto&#10;TEL: (21) 3888 1590&#10;E-MAIL: matmalap@veloxmail.com'),(64,'RICARDO SÁ COM. DE FRUTAS CONGELADAS E DERIVADOS LTDA/EPP','00.549.785/0001-56','ENDEREÇO: R Lopes da Cruz, 332 – Méier - RJ&#10;CEP: 20.720-170&#10;REPRESENTANTE: Sr. Ricardo de Sá&#10;TEL: (21) 2591 2019&#10;FAX: (21) 3271 1876'),(65,'STAR FOOD FORNECEDORA DE ALIMENTOS LTDA','06.347.714/0001-57','ENDEREÇO: R – Capitão Félix, 110, GAL 04 – LJ 11 – Benfica - RJ&#10;CEP: 20.920-310&#10;REPRESENTANTE: Sr. Ulyses Delia&#10;TEL: (21) 2589 9176&#10;FAX: (21) 2589 9176'),(66,'PAN VITAL IND. E COM. DE GÊNEROS ALIMENTÍCIOS LTDA','07.258.389/0001-19','ENDEREÇO: R – Carlos Souza Fernandes, 74 – Olinda – Nilópolis - RJ&#10;CEP: 26.545-000&#10;REPRESENTANTE: Sr. Walter Alexandre Maia&#10;TEL: (21) 2792 9606&#10;FAX: (21) 2792 9747'),(67,'GN ALIMENTOS LTDA','03.948.499/0001-51','ENDEREÇO: Rodovia BR 262, 4.700 – Bairro: Eymard - MG&#10;CEP: 31.910-585&#10;REPRESENTANTE: Ramiro&#10;TEL: (31) 2692-8140 (31) 3505-2800 (31) 3019-6998'),(68,'DISTRIBUIDORA DE OVOS AGUIAR','28.202.018/0001-95','ENDEREÇO: Estrada Henrique de Melo, 750/760 e Rua Araraquara, 25 Oswaldo Cruz&#10;CEP: 21.340-190&#10;REPRESENTANTE: Áquilas Monteiro/ Paulo Roberto&#10;TEL: (21) 3390-8149&#10;FAX: (21) 3390-8149&#10;E-MAIL: ovosaguiar@uol.com.br'),(69,'BIG NETH LANCHEREFEIÇÕES LTDA','72.399.140/0001-95','ENDEREÇO: Av. Brigadeiro Trompowisk s/n° Ilha do Governador&#10;CEP: 21.044-020&#10;TEL: (21) 2590 6827&#10;FAX: (21) 2590 6827'),(70,'GESTAL COMÉRCIO DE PRODUTOS ALLIMENTÍCIOS LTDA','07.600.038/0001-44','ENDEREÇO: Rua Igarapé no 319 – Bairro Periquitos - Duque de Caxias - RJ&#10;CEP: 25.025-340&#10;REPRESENTANTE: Rosinaldo Silva Monteiro&#10;TEL: (21) 2776-4366 3654-4514'),(71,'CCS VALENTE COMÉRCIO DE GÊNEROS ALIMENTÍCIOS','09.031.962/0001-82','ENDEREÇO: Rua Suez no 160 – Bangu – Rio de Janeiro&#10;CEP: 21.820-250&#10;REPRESENTANTE: Sa Cláudia Cristina&#10;TEL: (21) 3332 1588 – 2404-2766&#10;E-MAIL: licitacao@ccsvalente.com.br'),(72,'SOLAMARIS DO RIO FORNECEDORA DE FRUTAS E LEGUMES LTDA','40.326.381/0001-18','ENDEREÇO: Av. Brasil, 19001- Pav. 44 Box 18 (Ceasa)– IRAJÁ - RJ&#10;CEP: 21.530-000&#10;REPRESENTANTE: Mário Francisco Toscano&#10;TEL: (21) 3014 7476&#10;E-MAIL: atendimento@solamarisrj.com.br'),(73,'LAMAS &#38; NOVAES LTDA','02.720.905/0001-61','ENDEREÇO: Caminho Velho de São Lourenço –São Lourenço Niteroi RJ&#10;CEP: 24060-008&#10;TEL: (21) 3604 8510&#10;FAX:3604-8510&#10;E-MAIL: lamasenovas@ig.com.br'),(74,'M B CALEDÔNIA GÊNEROS ALIMENTICIOS LTDA','07.042.664/0001-62','ENDEREÇO: Dezessete de Fevereiro 219 Bonsucesso -RJ&#10;TEL: (21)3104-2937&#10;FAX:3104-2937&#10;E-MAIL: mbcaledonia@hotmail.com'),(75,'F. FIRMINO','04.718.601/0001-95','ENDEREÇO: Rua Elias Lobo , 553 Campo Grande – Rio de Janeiro&#10;CEP: 23.052-170&#10;TEL: (21) 3394-3051 / 33948676&#10;FAX: 3394-3051&#10;E-MAIL: domfirmino@click21.com.br / domfirmino.pf@gmail.com'),(76,'REFISERVI REFEIÇÕES INDUSTRIAIS LTDA','73.373.243/0001-49','ENDEREÇO: Nerval de Gouveia 431, Cascadura – Rio de Janeiro/RJ&#10;CEP: 21.311-110&#10;REPRESENTANTE: Gabriela Telles&#10;TEL: (21) 2229-5990 / 2596-9458 / 2596-9458 / 2596-9458&#10;E-MAIL: refiservi@uol.com.br'),(77,'PONTUAL RIO 2010 COMERCIO LTDA','03.985.518/0001-10','ENDEREÇO: R Capitão Felix 110 Galeria 2 loja 06 BL F Benfica -RJ&#10;CEP: 20.920-310&#10;REPRESENTANTE:Carlos Alberto&#10;TEL: (21) 3526-5770&#10;FAX:2580-0575&#10;E-MAIL: pontualrio2010@gmail.com'),(78,'RIO MILÃO 5070','08.909.092/0001-39','ENDEREÇO: Bernardo de Vasconcelo N 2085 Realengo&#10;REPRESENTANTE: Rosangela&#10;TEL: (21) 3468-3403 7940-5990 7940-5991&#10;FAX:2457-0232'),(79,'LANAI COMERCIAL IMPORTADORA E EXPORTADORA LTDA','40.436.149/0001-32','ENDEREÇO: Rua Capitão Felix, 110 - Av. Central loja 60 – CADEG - RJ&#10;CEP:20.920-310&#10;REPRESENTANTE: Cesar Monteiro&#10;TEL: (21) 3890-4710&#10;FAX:3890-0393'),(80,'FICA BEM ALIMENTOS LTDA','72.388.465/0001-72','ENDEREÇO: Rua Capitão Félix, 110 - Rua 03 – lojas 03 e 05, Benfica – Rio de Janeiro/RJ&#10;CEP: 20.928-900&#10;REPRESENTANTE: Sr. José Diógenes Fontes de Matos&#10;TELEFAX: 3860-6441&#10;E-MAIL: ficabem.alimentos@gmail.com'),(81,'NAVEGART INFORMÁTICA.COM. MANUT. E SERV. LTDA','07.162.814/0001-71','ENDEREÇO: Av Automóvel Clube, 55 – Santa Cruz da Serra, Duque de Caxias - RJ&#10;CEP: 25260-000&#10;REPRESENTANTE: Sr. Ricardo Duarte da Silva&#10;TELEFAX: (21) 3658-6022'),(82,'J L REFRIGERAÇÃO E COMERCIO E DISTRIBUIDORA DE ÁGUA MINERAL LDTA-ME','28.024.610/0001-44','ENDEREÇO: Rua Costa Ferreira, 55 Centro Rio de Janeiro&#10;CEP: 20221-240&#10;REPRESENTANTE: Sr(a) Carla Cardoso&#10;TELEFAX: (21) 3285-4045 / 2516-1168/2233-5544'),(83,'HORTO CENTRAL MARATAIZES LTDA','39.818.737/0001-51','ENDEREÇO: Rodovia ES-490, Safra x Marataízes, s/no, Muritiba, Candeus e Duas Barras, Itapemirim/ES&#10;CEP: 29.330-000&#10;REPRESENTANTE: Sr(a) Ademar / Juliana&#10;E-MAIL: FATURAMENTO: juliana@hortisul.com&#10;PEDIDOS: maria@hortisul.com'),(84,'COMERCIO E INDUSTRIA DE ALIMENTOS SÃO JUDAS TADEU LTDA','04.595.185/0001-85','ENDEREÇO: Av Brasil 19001 pavilhão 72 Loja 03 CEASA Irajá RJ&#10;CEP: 21.530-001&#10;REPRESENTANTE: Sr(a) Vanessa / Luiz Carlos&#10;TELEFAX: (21) 2471-2899&#10;E-MAIL: saojudastadeu.rj@bol.com.br'),(85,'LIDERANÇA DISTRIBUIDORA DE ALIMENTOS LTDA','04.578.046/0001-43','ENDEREÇO: Rodovia José Sette S/N Porto de Cariacica ES&#10;CEP:29.156-700&#10;REPRESENTANTE: Sr(a) Flávia /Kênia&#10;TEL: (27) 3254-9000 3254-9029/3254-9009 FAX: 3254-9016'),(86,'AJURDY DISTRIBUIDORA DE PRODUTOS LTDA','09.102.265/0001-75','ENDEREÇO: AV Nossa Senhora de Copacabana 709 SI 1205&#10;CEP: 22.050-002&#10;REPRESENTANTE: Sr(a) André Monteiro Amin&#10;TEL: (21) 2547-5640&#10;E-MAIL: ajurdydistribuidora@gmail.com'),(87,'ALPES RIO COMERCIAL LTDA - ME','07.564.451/0001-09','ENDEREÇO: Rua Carmela Dutra, 2638, Centro – Nilópolis/RJ&#10;CEP: 26530-020&#10;REPRESENTANTE: Sr(a) Diego René Martinez&#10;TEL/FAX: (21) 2791-0885'),(88,'CRISTALFRIGO INDÚSTRIA, COMÉRCIO, IMPORTAÇÃO E EXPORTAÇÃO LTDA','04.613.751/0004-87','ENDEREÇO: Av. dos Andradas, 2229, Santa Efigênia – Belo Horizonte/MG&#10;CEP: 30120-010&#10;REPRESENTANTE: Sr(a) Ivan Costa Sander&#10;TEL/FAX: (31) 2101-1719'),(89,'DETONI DISTRIBUIDORA DE ALIMENTOS LTDA - ME','07.997.527/0001-81','ENDEREÇO: Av. Álvaro Marconde de Matos, 480 – São Gonçalo – Taubaté/SP&#10;CEP: 12092-500&#10;REPRESENTANTE: Sr(a) Carlos Valério Gaspar Sobral&#10;TEL: (12) 3682-3289&#10;FAX: (12) 3682-3297'),(90,'INDÚSTRIA E COMÉRCIO DE ALIMENTOS SUPREMO LTDA','03.080.479/0001-01','ENDEREÇO: Rua Raimundo de Freitas, 111, Centro – Ibirité/MG&#10;CEP: 32400-0000&#10;REPRESENTANTE: Sr(a) Daniel Clarindo de Oliveira&#10;TEL: (31) 3521-8000&#10;FAX: 3521-8037'),(91,'MAP RIO INDÚSTRIA, COMÉRCIO E SERVIÇOS LTDA - ME','03.720.798/0001-34','ENDEREÇO: Rua Haia, 244, Tauá, Ilha do Governador – Rio de Janeiro/RJ&#10;CEP: 21920-180&#10;REPRESENTANTE: Sr(a) Anna Paula Nunes Alves da Silva&#10;TEL/FAX: (21) 3353-0670'),(92,'MERCEARIA E BAZAR NOSSA SENHORA DA LUZ LTDA - ME','00.887.566/0001-87','ENDEREÇO: Rua do Viaduto, 85, Acari – Rio de Janeiro/RJ&#10;CEP: 21531-700&#10;REPRESENTANTE: Sr(a) Noé Carneiro dos Santos&#10;TEL/FAX: (21) 2471-6984 ou (21) 3835-3446&#10;E-MAIL: nossasenhoraluz@yahoo.com.br'),(93,'ODEBRECHT COMÉRCIO E INDÚSTRIA DE CAFÉ LTDA','78.597.150/0018-60','ENDEREÇO: QN-122, Conj. 4, Lote 5, Loja I – Samambaia, Brasília/DF&#10;REPRESENTANTE: Sr(a) Ana Paula Baptista Graco Dias&#10;TEL: (43) 3377-4141 ou 3377-4101&#10;FAX: (43) 3377-4151'),(94,'PASTIFÍCIO SANTA AMÁLIA S/A','22.229.207/0001-75','ENDEREÇO: Rod. BR 267, KM 2, Distrito Industrial – Machado/MG&#10;CEP: 37750-000&#10;REPRESENTANTE: Sr(a) Jorge Roman&#10;TEL/FAX: (35) 3295-9000'),(95,'TANGARÁ IMPORTADORA E EXPORTADORA S/A','39.787.056/0001-73','ENDEREÇO: Rod. Darly Santos, 2500, Bairro Araçás, Vila Velha/ES&#10;CEP: 29103-091&#10;REPRESENTANTE: Sr(a) Eduardo Leite&#10;TEL: (27) 2123-9271&#10;FAX: (27) 2123-9237'),(96,'JBS S/A','02.916.265/0011-31','ENDEREÇO: Av. Marginal Direita do Tiete, 500. Vila Jaguara - SP&#10;CEP: 05118-100&#10;REPRESENTANTE: Sr(a) Jessica Gonçalves Alves&#10;TEL/FAX: (011) 3144-4000 - 3144-4343 - 3144-4410'),(97,'PROV 110 COMERCIAL EIRELI','10.511.098/0001-03','ENDEREÇO: Rua Capitão Felix, 110 – Rua 2 loja 22 – Benfica - RJ&#10;CEP: 20.920-310&#10;REPRESENTANTE: Márcia Maria Almeida Gonçalves&#10;TEL: (21) 3860-0376&#10;E-MAIL: prov110comercial@gmail.com'),(98,'D A H M DOS SANTOS COMERCIO E SERVIÇOS DE ALIMENTOS ME','03.077.654/0001-01','ENDEREÇO:Av Pelotas, No 648, Quadra 41, Lotes 31 e 32, Jardim Gramacho, Duque de Caxias, RJ.&#10;CEP: 25.055-192&#10;REPRESENTANTE: David Antonio Henrique Mendes Dos Santos&#10;TEL.: 21- 3659-7176'),(99,'D. I. D. COMÉRCIO DE FRIOS E CONGELADOS LTDA','09.550.402/0001-34','ENDEREÇO: Av. Martinho Almeida, No 100, Lj D – Rio Bonito&#10;CEP: 28.800-000&#10;REPRESENTANTE: Daniela Soares Machado da Silva&#10;TEL: (021) 21 2734-6201 /88204776&#10;FAX: (021) 21 2734-6201'),(100,'LS COMÉRCIO DE DESCARTÁVEIS E COMESTÍVEIS LTDA','10.636.608/0001-60','ENDEREÇO: Rua Flavia Farnese, 164 – Bonsucesso – RJ.&#10;CEP:21. 042-262&#10;REPRESENTANTE: Luciano de Moraes&#10;TEL: (21) 3866-3473&#10;FAX: (21) 3105-8170&#10;E-MAIL: comestiveis@ig.com.br'),(101,'GRANÁ 298 DISTRIBUIDORA DE ALIMENTOS LTDA','02.768.278/0001-39','ENDEREÇO: RUA GRANÁ No 298 , ILHA DO GOVERNADOR - RIO DE JANEIRO-RJ.&#10;CEP: 21921-010&#10;TEL.: (21) 2466-7416&#10;REPRESENTANTE: MARIÁ ROSSETTO&#10;E-MAIL: grana298@hotmail.com'),(102,'M.L. MARTINS DISTRIBUIDORA DE ALIMENTOS LTDA','06.136.346/0001-06','ENDEREÇO: Avenida dos trabalhadores No 311 loja - Centro- Nova Iguaçu – RJ.&#10;CEP:25520-001&#10;REPRESENTANTE: MARCIO LUIZ MARTINS &#10;TEL: (21) 7812-4136&#10;E-MAIL:mlmartinsdistribuidora@ig.com.br'),(103,'ESPAÇO R2 – COMÉRCIO VAREJISTA, REPRESENTAÇÃO E SERVIÇOS LTDA – ME','11.229.966/0001-11','ENDEREÇO: Rua Capitão Felix,110 Pavimento Térreo, Loja 11 – Galeria 6–Bloco E, Benfica - Rio de Janeiro – RJ.&#10;CEP:20.920-310&#10;REPRESENTANTE: BÁRBARA MARIA G RODRIGUES&#10;TEL: (21)2585-0982 / 3253-3940 &#10;FAX: (21)2585-0982 / 3253-3940'),(104,'NEKY ELETROELETRONICOS COM. E DISTRIBUIDORA LTDA -ME','09.426.787/0001-22','ENDEREÇO: Rua Rio Bonito, 1.101, Sala-201 – Gramacho - Duque de Caxias. - Rio de Janeiro – RJ.&#10;CEP:25.035-230&#10;REPRESENTANTE: VIVIANE FARIA TEL: 21- 3652-6487/2674-9663 FAX: (21)3651-5701&#10;E-MAIL: neky@neky.com.br'),(105,'WINNER COMÉRCIO E REPRESENTAÇÃO LTDA','09.114.326/0001-14','ENDEREÇO: Rua Dona Vitalina, 327 Loja –Engenho pequeno- Nova Iguaçú - Rio de Janeiro – RJ.&#10;CEP:26.011-590&#10;REPRESENTANTE:EDSO FERNANDES LIMA&#10;TEL: (21)2698-9052/ 9392-5848&#10;E-MAIL: w.iguacu@yahoo.com.br'),(106,'SÃO BRÁS 34 PESCADOS COMERCIAL LTDA','10.392.981/0001-13','ENDEREÇO: Rua da regeneração, 65 – Parte- Bonsucesso, - Rio de Janeiro – RJ.&#10;CEP: 21.040-170&#10;REPRESENTANTE: FRANCISCO JOSÉ MAGALHÃES&#10;TEL: (21)3283-9610&#10;E-MAIL: saobraspescado@hotmail.com / saobras@saobraspescados.com.br'),(107,'TFM RIO COMÉRCIO DE GENEROS ALIMENTICIOS LTDA-ME','10.988.435/0001-40','ENDEREÇO: Rua Ipiaba, 273 - Ilha do Governador - Rio de Janeiro – RJ.&#10;CEP: 21937-247&#10;REPRESENTANTE: FLAVIA MACEDO / THIAGO MACEDO&#10;TEL: (21) 2465-2505 / (21) 8101-6210 / 7897-9376&#10;E-MAIL: flaviamacedo@tfmrio.com.br'),(108,'RIOSUPPLY ALIMENTOS LTDA – EPP','14.417.272/0001-04','ENDEREÇO: Rua: Dr. Agenor de Almeida Loyola, No 50 – Bancários – Ilha do Governador- RJ.&#10;CEP: 21.911-310&#10;REPRESENTANTE: Sr. ALEXANDRE ASSIS&#10;TEL: (21) 3268-7078&#10;E-MAIL: eagraa@yahoo.com.br / pedidospadaria@yahoo.com.br'),(109,'MAR E TERRA DE NILOPOLIS COMERCIO DE ALIMENTOS LTDA','11.490.410/0001-84','ENDEREÇO: Rua: Coronel José Muniz, 93 Galpão – Olinda - Nilópolis.&#10;CEP:26545.060&#10;REPRESENTANTE: FLAVIO MOURA SANTOS&#10;TEL: (21) 2693-4550 / (21) 3760-6667&#10;E-MAIL: mareterradenilopolis@yahoo.com.br'),(110,'BOSCATTI ATACADISTA LTDA-EPP','14.144.135/0001-35','ENDEREÇO: Rodovia BR 040,KM 526, sno, Galpão 06 – Faz Perobas – Contagem - MG.CEP:32145-480&#10;REPRESENTANTE: ANDRÉ SCALER FERRI AMARAL&#10;TEL: (31) 2129-8544 / 2129-8500 /&#10;E-MAIL: boscattiatacadista@gmail.com'),(111,'DELTA RIO COMÉRCIO SERVIÇOS E REPRESENTAÇÕES LTDA-ME','10.942.801/0001-20','ENDEREÇO: Rua Pedro Elifas,No 18-Loja-Heliópolis Belford Roxo-RJ.&#10;CEP:26120-260&#10;REPRESENTANTE: LETICIA DA CONCEIÇÃO FELICIO&#10;TEL: (21)2662-3816 / 2779-6948/7734-6352&#10;E-MAIL: deltario@bol.com.br/deltario@ymail.com'),(112,'BELA ISCHIA ALIMENTOS LTDA','01.130.631/0001-98','ENDEREÇO: Rodovia MG 285, km 77 Astolfo Dutra / MG&#10;CEP: 36.780-000&#10;REPRESENTANTE: Jorge Martins / Edmilson&#10;TEL: (21) 2589-0070 / (21) 3565-5658&#10;E-MAIL: jorgemartins5@yahoo.com.br'),(113,'J.B.C. ARAÚJO DISTRIBUIDORA LTDA','04.310.628/0001-44','ENDEREÇO: Rua General Aurélio Vieira no45 – Madureira – Rio de Janeiro – RJ&#10;CEP: 21351-250&#10;REPRESENTANTE: JOSÉ COSME FERREIRA DE ARAÚJO&#10;TEL: 2452-7826/3045-2910/9763-1975/7831-3323&#10;FAX: 2452-7826&#10;E-MAIL: jbcaraujo@oi.com.br'),(114,'CARISMA COMÉRCIO DE ALIMENTOS E DESCARTÁVEIS LTDA-ME','12.385.132/0001-68','ENDEREÇO: Av. Brasil 18504 – Rua do Viaduto, 73 – Acari - Rio de Janeiro&#10;CEP: 21531-700&#10;REPRESENTANTE: Noé Carneiro&#10;TEL: (21) 3837-0076- 3835-3446&#10;E-MAIL: carisma_2011@yahoo.com.br'),(115,'TENEDOR-RIO COMÉRCIO E SERVIÇOS DE ALIMENTAÇÃO LTDA','07.146.067/0001-88','ENDEREÇO: Av. do Contorno, 4002 - Barreto – Niterói/RJ&#10;CEP: 24110-205&#10;REPRESENTANTE: Marcos José Correa dos Santos&#10;TEL: (21) 2624-0676&#10;E-MAIL: tenedoralimentos@hotmail.com'),(116,'FRANCISCO SEBASTIÃO DE BRITO RESENDE - EPP','62.873.054/0001-19','ENDEREÇO: Rodovia Geraldo Scabone, 2730, Vila Branca – Jacareí/SP (Rua Três, no 310)&#10;CEP: 12305-490&#10;REPRESENTANTE: Cristiano&#10;TEL: (0**12) 3958-3127&#10;E-MAIL: cristiano@grupodasabor.com.br'),(117,'FRIGORÍFICO VALE DO SAPUCAÍ LTDA (FRIVASA)','01.702.122/0001-92','ENDEREÇO: Av. Wagner Lemos Machado, 1100, Açude – Itajubá/MG&#10;CEP: 37.504-326&#10;E-MAIL: jorgemartins5@yahoo.com.br'),(118,'COMÉRCIO E SERVIÇOS LOBÃO LTDA','06.698.962/0001-42','ENDEREÇO: Rua da Abolição, 537, Abolição –Rio de Janeiro/RJ&#10;CEP: 20.755-170&#10;REPRESENTANTE: Vladimir Calixto Borges da Silva&#10;TEL: (0**21) 3016-0499 ou (0**21) 3251-5558&#10;E-MAIL: c.slobao@hotmail.com'),(119,'ECCAGIO COMÉRCIO DE ALIMENTOS LTDA-ME','10.511.650/0001-55','ENDEREÇO: Rua Teixeira de Freitas, 170, Loja - 02 - Fonseca – Niterói/RJ&#10;CEP: 24.130-610&#10;REPRESENTANTE: Rodrigo Mendes&#10;TEL: (0**21) 2705-9544&#10;E-MAIL: eccagioltda@yahoo.com.br'),(120,'RDL DISTRIBUIDORA DE ALIMENTOS LTDA-ME','11.619.789/0001-80','ENDEREÇO: Rua São Dionísio, 62, Loja B - Penha – Rio de Janeiro/RJ&#10;CEP: 21.070-046&#10;REPRESENTANTE: Rodrigo Diogo Moreira&#10;TEL: (0**21) 3977-7813&#10;E-MAIL: rdlalimentos01@yahoo.com'),(121,'LIELO COMÉRCIO DE GÊNEROS ALIMENTÍCIOS E DESCARTÁVEIS LTDA','13.836.047/0001-31','ENDEREÇO: Rua Sainá, 3, Loja A - Bangú – Rio de Janeiro/RJ&#10;CEP: 21.862-040&#10;REPRESENTANTE: Liliana (0**21) 9364-1029&#10;TEL: (0**21) 3086-9431&#10;E-MAIL: lielo2011@hotmail.com'),(122,'FRESH FOOD COMÉRCIO DE GÊNEROS ALIMENTÍCIOS LTDA - EPP','14.263.869/0001-33','ENDEREÇO: Rua Suez, 155 BAIRRO - Bangu – Rio de Janeiro/RJ&#10;CEP: 21.820-250&#10;REPRESENTANTE: Marianne Elisabeth&#10;TEL: (0**21) 3332-1588 / 2404-2766 - Fax: (0**21) 3291-3084&#10;E-MAIL: licitacao@freshfoodalimento.com.br'),(123,'MUNDIAL COMÉRCIO DE PESCADOS E ALIMENTOS LTDA','15.287.314/0001-94','ENDEREÇO: Rua Franklin máximo pereira, 78-202, Centro - Itajaí – Santa Catarina/SC&#10;CEP: 88.302-020&#10;REPRESENTANTE: Danielle Luciane de Oliveira &#10;TEL: (0**47) 4105-0928 &#10;E-MAIL: mundialpescados@gmail.com / Igor.mundialpescados@gmail.com'),(124,'H2L COMÉRCIO DE ÁGUAS E BEBIDAS LTDA','10.680.953/0001-00','ENDEREÇO: Av. Senador Pompeu, no 14 A, Centro, Rio de Janeiro - RJ&#10;CEP: 20.080-102&#10;REPRESENTANTE: Lauri da Silva (0**21) 7590-8564&#10;TEL: (0**21) 2223-3361 / 2223-0308&#10;E-MAIL: contato@h2lagua.com.br'),(125,'OPÇÃO DA VILA PADARIA E MERCEARIA LTDA - ME','02.542.890/0001-99','ENDEREÇO: Rua Elizario de Souza, 972 – Vila Norma – São João de Meriti - RJ&#10;CEP: 25.535-360&#10;REPRESENTANTE: Hélio Domingues Claro&#10;TEL: (0**21) 2656-8603&#10;E-MAIL: opcaodavilapadaria@bol.com.br'),(126,'GIOMEN COMÉRCIO DE ALIMENTOS LTDA - ME','07.830.252/0001-97','ENDEREÇO: Rua Andrade de Pinto, 180, Loja 02, Bairro de Fátima, Niterói - Rio de Janeiro - RJ&#10;REPRESENTANTE: GIOMEN - (0**21) 9972-6680&#10;TEL: (0**21) 2719-1564 / 2719-1523/9972-6680&#10;E-MAIL: giomenltda@yahoo.com.br'),(127,'SANTO TIRSO IND. COM. E TRANSP. LTDA - ME','30.372.403/0001-22','ENDEREÇO: Av. Automóvel Clube no1. 440 – Vilar dos Teles – São João de Meriti - RJ&#10;CEP: 25.565-172&#10;REPRESENTANTE: José Francisco Kronemberger&#10;TEL: (0**21) 3029-4494 / Fax – 2751-1302&#10;E-MAIL: licita@belong.com.br'),(128,'CON-NEXCOMÉRCIO E SERVIÇOS LTDA - ME','17.050.144/0001-55','ENDEREÇO: Rua Guineza 483 – ENGENHO DE DENTRO – Rio de Janeiro - RJ&#10;CEP: 20.755-330&#10;REPRESENTANTE: CRISTIANE SOARES&#10;TEL: (0**21) 3178-4408 / 3228-3868 / 3178-4408&#10;E-MAIL: connexcomercio@yahoo.com.br'),(129,'REDFLAECH DISTRIBUIDORA DE ALIMENTOS LTDA','04.246.902/0001-63','ENDEREÇO: Rua João Manoel Melro, s/n - Lote 52 - Quadra 03 - Bairro Largo da Idéia&#10;CIDADE: São Gonçalo - RJ&#10;CEP.: 24421-170&#10;REPRESENTANTE: Sr. Lopes&#10;FAX: (21) 3715-5718&#10;TEL.: (21) 2603-6290&#10;E-MAIL: redflaeche@terra.com.br'),(130,'FRISMAR LTDA ME','10.863.930/0001-22','ENDEREÇO: Rua Capitão Felix, 110 – loja 22 – Bloco Nobre CADEG - BenficaCIDADE: Rio de Janeiro - RJ&#10;CEP.: 20.920-310&#10;REPRESENTANTE: Sr. Hudson Gouveia&#10;TEL. FAX: (21) 2589-4277&#10;E-MAIL: frismarltda@gmail.com'),(131,'FORÇA TOTAL DISTRIBUIDORA DE ALIMENTOS LTDA','11.203.563/0001-01','ENDEREÇO: Rua da Cevada no 115, Penha – Rio de Janeiro&#10;CIDADE: Rio de Janeiro - RJ&#10;CEP.: 21.011-080&#10;REPRESENTANTE: Sra Ana Cristina / Sr. Jorge&#10;TEL. FAX: (21) 3890-1557&#10;TEL.: (21) 3890-1557&#10;E-MAIL: jorgemartins5@yahoo.com.br'),(132,'PARADISO AQUA FRESH IND COM MINERAÇÃO E DISTRI LTDA','00.604.434/0001-09','ENDEREÇO: Estrada do Catonho, 04 – A – Jardim Sulacap&#10;CIDADE: Rio de Janeiro - RJ&#10;CEP.: 22.725-000&#10;REPRESENTANTE: Sr. Daniel Cardoso Pereira&#10;TEL. FAX: (21) 2423-3627 / 1014 / 3473-8371&#10;E-MAIL: daniel.aquafresh@hotmail.com'),(133,'APR INDÚSTRIA E COMÉRCIO DE PRODUTOS ALIMENTICIOS LTDA-ME','18.548.457/0001-09','ENDEREÇO: Estrada Nilo Peçanha, 893 Olinda - Nilópolis&#10;CIDADE: Rio de Janeiro - RJ&#10;CEP.: 26.545-201&#10;REPRESENTANTE: Ana Lúcia Cardoso Ferreira&#10;TEL. FAX: (21) 3761-1616 / 2791-5790&#10;E-MAIL : contato@sorvetesnetinho.com.br'),(134,'FÊNIX INDUSTRIAL E COMÉRCIO DE ALIMENTOS LTDA','61.714.994/0001-00','ENDEREÇO: R. Dr. Laurindo Minhoto, no 16 – V.Alpina&#10;CIDADE: São Paulo – SP&#10;CEP.: 03.240-060&#10;REPRESENTANTE: Sra. Ana Ramos&#10;TEL: (21) 9 6898-8823&#10;E-MAIL: fênix.rjvendas@gmail.com'),(135,'SANES BRASIL AGROINDUSTRIAL S/A','03.718.276/0001-06','ENDEREÇO: Av. de Acesso s/n – Lt-03 – Qd – 10 Distrito Industrial&#10;CIDADE: Queimados – RJ&#10;CEP.: 26.315-020&#10;REPRESENTANTE: Sr. Joacy Carvalho&#10;TEL: (21) 2663-9300&#10;E-MAIL: sanesbr@sanesbr.com.br'),(136,'EG MARTINS COMÉRCIO E REPRESENTAÇÕES DE ALIMENTOS LTDA - ME','12.753.310/0001-66','ENDEREÇO: Rua Capitão Felix, 110 Sl – 402 – Benfica - Rio de Janeiro&#10;CIDADE: Rio de Janeiro – RJ&#10;CEP.: 20.920-310&#10;REPRESENTANTE: Sr. Jorge Martins&#10;TEL: (21) 2589-0070 / 3890-1557&#10;E-MAIL: jmartinsrepresentacao@gmail.com'),(137,'COMSUP COMECIAL DE ALIMENTOS LTDA - ME','10.626.575/0001-78','ENDEREÇO: Rua Jacobina, s/n Vila Militar - Deodoro&#10;CIDADE: Rio de Janeiro – RJ&#10;CEP.: 21.670-640&#10;REPRESENTANTE: Sr. Willian Telemaco&#10;TEL: (21) 3011-7994 &#10;E-MAIL: broucom@gmail.com'),(138,'WS DISTRIBUIDORA DEALIMENTOS LTDA - EPP','01.220.638/0001-09','ENDEREÇO: Rua Capitão Félix, 110 – Rua 03 - Benfica&#10;CIDADE: Rio de Janeiro – RJ&#10;CEP.: 20.920-310&#10;REPRESENTANTE: Sr. VIVIAN CRSITINE BRITO JACINTO&#10;TEL: (21) 3890-1060&#10;E-MAIL: wsdistribuidora.alimentos@gmail.com'),(139,'IMEDIATA COMÉRCIO DISTRIBUIÇÃO E SERVIÇOS LTDA','13.936.544/0001-01','ENDEREÇO: Rua Galvão, 148 – Bl – 2 – Lj – 112 – Barreto&#10;CIDADE: Niterói – RJ&#10;CEP.: 24.110-260&#10;REPRESENTANTE: Sro. RENAN GUTTERRES&#10;TEL: (21) 3587-2568 &#10;E-MAIL: imediatadistribuicao@yahoo.com.br'),(140,'SABOR CARIOCA COMÉRCIO DE ALIMENTOS LTDA - ME','14.184.366/0001-72','ENDEREÇO: Rua Bento Lisboa, 257 – Lt – 14 –Qd – 8 – Jardim Meritir&#10;CIDADE: São João de Meriti – RJ&#10;CEP.: 25.510-301&#10;REPRESENTANTE: Sra. CLAUDIA &#10;TEL: (21) 3141-9697 / (21) 2757-1124&#10;E-MAIL: sabor.carioca.adm@gmail.com'),(141,'MM DISTRIBUIDORA DE ALIMENTOS E PRESTAÇÃO DE SERVIÇOS LTDA - ME','16.938.521/0001-24','ENDEREÇO: Rua Aguiar, no 12 ( frente) - Jardim Meritir&#10;CIDADE: São João de Meriti – RJ&#10;CEP.: 25.655-451&#10;REPRESENTANTE: Sr. MAURÍCIO FERREIRA&#10;TEL. FAX: (21) 2586-5643 / (21) 3755-8711&#10;E-MAIL: mmalimentoseservicos@yahoo.com.br'),(142,'KOALLA ASSESSORIA DE EVENTOS LTDA','10.500.772/0001-46','ENDEREÇO: Rua Cinco, no 300 – Bairro Marapicu –&#10;CIDADE: Nova Iguaçú - RJ&#10;CEP.: 26.295-117&#10;REPRESENTANTE: Sra. ROSILENE DE AGUIAR DOS SANTOS&#10;TEL: (21) 2881-6130&#10;E-MAIL: sebast.teixeira@gmail.com'),(143,'BAP DISTRIBUIDORA DE PRODUTOS ALIMENTÍCIOS LTDA','14.455.551/0001-54','ENDEREÇO: Rua Capitão Félix, 110 – Pavimento 02 Lj – 08, Rua 05 – Bl – “C” - Benfica&#10;CIDADE: Rio de Janeiro – RJ&#10;CEP.: 20.920-310&#10;REPRESENTANTE: Sro. BRUNO DIAS DE OLIVEIRA&#10;TEL: (21) 2589-7109&#10;E-MAIL: bapalimentos@globo.com'),(144,'SPL COMÉRCIO E SRVIÇOS EIRELE - ME','21.099.971/0001-00','ENDEREÇO: Rua Cosmorama, 600 – Sl 17 – Cosmorama – Mesquita&#10;CIDADE: Mesquita – RJ&#10;CEP.: 26.582-020&#10;REPRESENTANTE: Sr. PAULO ROBERTO VIANA DA ROCHA&#10;TEL: (21) 3589-3837 / (21) 96664-9210&#10;E-MAIL: fhvp@bol.com.br'),(145,'BH FOODS COMÉRCIO E INDÚSTRIA LTDA','02.973.358/0001-26','ENDEREÇO: RUA DO SOLDADO, No 730, GALPÃO 05, BAIRRO PEROBAS. CIDADE: Contagem&#10;ESTADO : Minas Gerais&#10;CEP.: 32.040-027&#10;REPRESENTANTE: Sro Carlos Lopes Carvente&#10;TEL: (31) 2129-8500 &#10;E-MAIL: pedidos.licitacao@gmail.cm'),(146,'MF2 COMPERCIO DE GÊNEROS ALIMENTÍCIOS LTDA','21.334.192/0001-42','ENDEREÇO: Rua Ipiaba 273 – Ilha do Governador– Rio de Janeiro - RJ CIDADE: Rio de Janeiro&#10;CEP.: 21.931-247&#10;REPRESENTANTE: Sr THIAGO MACEDO / FLÁVIA MACEDO&#10;TEL: (21) 2465-2505&#10;E-MAIL: comercial@mf2comercial.com.br'),(147,'COOPERATIVA DE LATICÍNIOS SELITA','27.178.359/0001-00','ENDEREÇO: Av. Aristides Campos 158 – Nova Brasília - ES&#10;CIDADE: Cachoeiro de Itapemirim&#10;CEP.: 29.300-903&#10;REPRESENTANTE: Sro ANA CRSITINA&#10;TEL. FAX: (21) 3565-5658&#10;E-MAIL: selitapedidos@gmail.com'),(148,'PACK COMÉRCIO DE PRODUTOS E SERVIÇOS EIRELI','00.424.684/0001-59','ENDEREÇO: Est. São Lourenço, 37 sala – 203 – Chácaras – Rio Petrópolis&#10;CIDADE: Duque de Caxias&#10;CEP.: 25.243-150&#10;REPRESENTANTE: Sra CÁSSIA FERNANDES&#10;TEL. FAX: (21) 2589-7926 / (21) 96417-0161&#10;E-MAIL: Pack.comercio@gmail.com'),(149,'BOÊLHE PESCADOS COMERCIAL LTDA','08.244.781/0001-71','ENDEREÇO: Rua da Regeneração no- 65 - Bonsucesso – Rio de Janeiro - RJ CIDADE: Rio de Janeiro&#10;CEP.: 21.040-170&#10;REPRESENTANTE: Sr José&#10;TEL: (21) 2270-1791&#10;E-MAIL: boelhe@boelhepescados.com.br'),(150,'ALIMENTARES SERVIÇOS DE TRANSPORTES COMERCIAL EIRELI','07.523.398/0001-90','ENDEREÇO: Rua Capitão Felix 110 – Rua 2 Loja 16 parte - Benfica&#10;CIDADE: Rio de Janeiro&#10;CEP: 20.920-310&#10;REPRESENTANTE: Sr Mario e Sra Márcia&#10;TEL: (21) 3860-2434&#10;E-MAIL: alimentares@veloxmail.com.br'),(151,'PHÊNIX COMÉRCIO E SERVIÇOS EM GERAL EIRELI - EPP','17.464.362/0001-36','ENDEREÇO: Rua Capitão Felix 110 – Rua 5 Loja 15A - Benfica&#10;CIDADE: Rio de Janeiro&#10;CEP.: 20.920-310&#10;REPRESENTANTE: Sra Jocélia Assumpção de Freitas&#10;TEL: (21) 3860-1983&#10;E-MAIL: phenixcomserv@gmail.com'),(152,'MAVE COMERCIO E SERVICOS EM GERAL LTDA','14.426.255/0001-25','RUA CAPITAO FELIX 101 - PAVILHAO 2 LOJA 06 RUA 05 BLOCO C - BENFICA - RIO DE JANEIRO - RJ - 20920-310, (21) 38600982 &#10;&#10;'),(153,'NOGUEIRA E RESENDE INDÚSTRIA DE LATICÍNIOS LTDA','04.892.455/0001-10','ENDEREÇO: Rodovia BR-040 – KM – 480 – S/No&#10;CIDADE: Sete Lagoas - MG&#10;CEP.: 35.702-372&#10;REPRESENTANTE: Sr Jorge Martins&#10;TEL: (21) 3565-5658&#10;E-MAIL: jmartinsrepresentacao@gmail.com'),(154,'NEO GIO COMÉRCIO DE ALIMENTOS LTDA - ME','24.567.499/0001-81','ENDEREÇO: Rua Teixeira de Freitas, 170 – loja – 01 - Fonseca&#10;CIDADE: Niterói - RJ&#10;CEP.: 24.130-616&#10;REPRESENTANTE: Sr Rodrigo Giovanini&#10;TEL: (21) 2705-9544&#10;E-MAIL: neogioltda@yahoo.com'),(155,'PREDILECTA ALIMENTOS LTDA','62.546.387/0001-33','ENDEREÇO: Vila Predilecta, no 50 – São Lourenço do Turvo -&#10;CIDADE: Matão - SP&#10;CEP.: 15.999-800&#10;REPRESENTANTE: Sr Luiz Antônio&#10;TEL: (16) 3383-2168&#10;E-MAIL: luiz@predilecta.com.br'),(156,'AS PALERMO SANTOS MATERIAL DE LIMPEZA ATACADO E VAREJO','14.404.282/0001-05','ENDEREÇO: Rua Rio de Janeiro, no 07 – Cabo Frio - RJ&#10;CIDADE: - Cabo Frio - RJ&#10;CEP.: 28.911-240&#10;REPRESENTANTE: Sr KATO&#10;TEL: (21) 98429-3639&#10;E-MAIL: kfruit@hotmail.com'),(157,'NACIONAL ALIMENTOS COMERCIO ATACADISTA LTDA - ME','16.885.541/0001-84','ENDEREÇO: RUA CARLOS SOUZA FERNANDES, 74 A&#10;CIDADE: - NILÓPOLIS - RJ&#10;CEP.: 26.545-000&#10;REPRESENTANTE: Sr DECIO DENIS&#10;TEL. FAX: (21) 3760-6667 / 2692-0462 &#10;E-MAIL: nacional.alimentos@yahoo.com'),(158,'COMERCIAL DREAN EIRELI - EPP','17.393.685/0001-86','ENDEREÇO: RUA DA SOJA, 67 A – PENHA CIRCULAR – MERCADO SÃO SEBASTIÃO&#10;CIDADE: - RIO DE JANEIRO - RJ&#10;CEP.: 21.011-100&#10;REPRESENTANTE: Sr ALAN SANTOS&#10;TEL. FAX: (21) 2584-3023&#10;E-MAIL: dreandistribuidora@gmail.com'),(159,'CLEAN INDÚSTRIA E COMÉCIO DE GELO LTDA','10.902.889/0001-56','ENDEREÇO: RUA CASTELO BRACO, 242 – PENHA CIRCULAR –&#10;CIDADE: - RIO DE JANEIRO - RJ&#10;CEP.: 21.012-100&#10;REPRESENTANTE: Sro MARCUS WELBY&#10;TEL. FAX: (21) 3836-3461 / 3570-3404&#10;E-MAIL: gelo.clean@gmail.com'),(160,'MC RIO COMÉRCIO DE ALIMENTOS LTDA','20.239.479/0001-20','ENDEREÇO: RUA MINISTRO MAVIGNIER 180 DEL CASTILHO&#10;CIDADE: - RIO DE JANEIRO - RJ&#10;CEP.: 20.760-070&#10;REPRESENTANTE: Sra ANA CRISTINA&#10;TEL. FAX: (21) 3145-6249&#10;E-MAIL: pedidosmcrio.marinha@gmail.com'),(161,'M.B. MARTINS AGROPECUÁRIA EPP','04.541.813/0001-40','ENDEREÇO: RUA CAPITÃO FÉLIX 110 - RUA&#10;CIDADE: - VOLTA REDONDA - RJ&#10;CEP.: 27.285412&#10;REPRESENTANTE: Sr HUMBERTO SÁVIO&#10;TEL. FAX: (24) 3212-2365&#10;E-MAIL: mblicita@outlook.com'),(162,'FORÇA UNIDA COMÉRCIO DE ALIMENTOS E DESCARTÁVEIS LTDA','13.024.866/0001-84','ENDEREÇO: RUA DESMONS, 59, COELHO NETO - RJ&#10;CIDADE: - Rio de Janeiro - RJ&#10;CEP.: 21.252-310&#10;TEL. FAX: (21) 3795-1520&#10;E-MAIL: forcaunida2011@yahoo.com.br'),(163,'EXITUS COMERCIAL PRODUTOS E SERVIÇOS LTDA - EPP','14.163.479/0001-91','ENDEREÇO: RUA CELSO EGÍDIO SOUSA SANTOS, 805, SALA 01 – Jd. Chapadão CIDADE: CAMPINAS – SÃO PAULO&#10;CEP.: 13070-057&#10;REPRESENTANTE: Sra CARMEN REGINA SPADACCIA&#10;TEL. FAX: (19) 3395-3580&#10;E-MAIL: exitus@exituscomercial.com'),(164,'ROJÃO COMERCIAL DE ALIMENTOS LTDA EPP','17.471.773/0001-59','ENDEREÇO: RUA GENERAL JACQUES OURIQUE, 548, PADRE MIGUEL CIDADE: Rio de Janeiro - RJ&#10;CEP.: 21720-540&#10;TEL. FAX: (21) 3228-3606 / 96961-6087&#10;E-MAIL: comrojao@gmail.com'),(165,'MARISOL COM. ATACADISTA DE ALIM. EM GERAL EIRELI - EPP','26.788.865/0001-58','ENDEREÇO: AVENIDA BRASIL, 19.001, PAVILHÃO 44, BOX 18, CEASA - IRAJÁ&#10;CIDADE: Rio de Janeiro - RJ&#10;CEP.: 21530-000&#10;REPRESENTANTE: ALINE DOS SANTOS KAMAROFF&#10;TEL. FAX: (21) 2473-2170&#10;E-MAIL: atendimento@marisolrj.com.br'),(166,'BRS COMÉRCIO E SERVIÇOS EIRELI-ME','26.957.841/0001-85','ENDEREÇO: AVENIDA DOS ITALIANOS, 282, Sala 09 – ROCHA MIRANDA&#10;CIDADE: Rio de Janeiro - RJ&#10;CEP.: 21.510-103&#10;REPRESENTANTE: BENEDITO RUFINO DOS SANTOS&#10;TEL. FAX: (21) 2241-4657&#10;E-MAIL: suprimixalimentos@gmail.com'),(167,'AREIA BRANCA COMÉRCIO E SERVIÇOS LTDA - EPP','11.924.595/0001-98','ENDEREÇO: Rua Capitão Félix 110, No 306 - BENFICA&#10;CIDADE: Rio de Janeiro - RJ&#10;CEP.: 20.920-310&#10;REPRESENTANTE: Sr. Carlos Alberto Pereira&#10;TEL. FAX: (21) 4109-6094&#10;E-MAIL: areiabranca.cs@gmail.com'),(168,'ISUPRY COMERCIAL E SERVIÇOS EIRELI - EPP','27.621.519/0001-43','ENDEREÇO: Rua Nicarágua, No 370 sala 104 - PENHA&#10;CIDADE: Rio de Janeiro - RJ CEP.: 21020-050&#10;REPRESENTANTE: THIAGO ROXO GOUVEIA&#10;TEL. FAX: (21) 2086-4851 / (21) 97043-2951&#10;E-MAIL: isupry.comercio@gmail.com'),(169,'SM DOS SANTOS OLIVEIRA HORTIFRUTI EIRELI - EPP','09.413.115/0001-82','ENDEREÇO: AV GOVERNADOR JANIO QUADROS 941 – VILA BATISTA&#10;CIDADE: CRUZEIRO - SP&#10;CEP.: 12720-000&#10;TEL. FAX: (12) 3145-3109&#10;E-MAIL: licitacao@grupovaleserv.com.br'),(170,'ANISA 2012 COMERCIO E SERVICOS LTDA - EPP','17.386.935/0001-50','ENDEREÇO: RUA ERASTOTENES FRAZÃO, No 73 LT 08 QD PA 33113 PARTE IRAJÁ&#10;CIDADE: RIO DE JANEIRO - RJ&#10;CEP.: 21231-140&#10;TEL. FAX: (21) 3253-0240&#10;E-MAIL: anisa2012comercio@outlook.com'),(171,'G.F.M COMÉRCIO E SERVIÇO EIRELI - ME','27.157.340/0001-87','ENDEREÇO: RUA FRANCISCO EUGÊNIO, 268, SALA 427 – SÃO CRISTOVÃO&#10;CIDADE: RIO DE JANEIRO - RJ&#10;CEP.: 20.941-120&#10;REPRESENTANTE: Sr. Eduardo Moreira&#10;TEL. FAX: (21) 9 8293-4332&#10;E-MAIL: gfmcomserv@gmail.com'),(172,'FABIO LIMA CLAUDIANO','20.644.744/0001-56','ENDEREÇO: RUA PROJETADA “C” S/N LOTE 05 QUADRA 03 – SANTA CRUZ DA SERRA&#10;CIDADE: DUQUE DE CAXIAS - RJ&#10;CEP.: 25.255-080&#10;REPRESENTANTE: Sr. Fábio Lima&#10;TEL. FAX: (21) 97959-8974 / 4128 - 1363&#10;E-MAIL: fabio.claudiano@hotmail.com'),(173,'EMPÓRIO ATACADISTA EG COMÉRCIO E REPRESENTAÇÕES - ELIRELI - EPP','25.331.743/0001-75','ENDEREÇO: Rua Capitão Felix no 110 - sala 409 - Benfica&#10;CIDADE: Rio de Janeiro - RJ&#10;CEP: 20.920-310&#10;REPRESENTANTE: Sra Marilene Muniz&#10;TEL. FAX: (21) 3145-6249&#10;E-MAIL: emporioatacvendas@gmail.com'),(174,'REAL CARNES INDÚSTRIA E COMÉRCIO DE CARNES LTDA','10.436.655/0001-60','ENDEREÇO: Rua da farinha no 985- Penha Circular&#10;CIDADE: Rio de Janeiro - RJ&#10;CEP.: 21.011-040&#10;REPRESENTANTE: Sra Marilene Muniz&#10;TEL. FAX: (21) 2589-0070 / (21) 3565-5658 / (21) 3145-6249&#10;E-MAIL: : jmartinsrepresentacao@gmail.com'),(175,'WIN DISTRIBUIDORA DE MATERIAIS E SEVIÇOS EIRELI','16.926.282/0001-92','ENDEREÇO: Av. das Américas, no 19.005 , torre 1 sala 828 – Recreio dos Bandeirantes&#10;CIDADE: Rio de Janeiro - RJ&#10;CEP.: 22.790-703&#10;REPRESENTANTE: Sra Ana Paula&#10;TEL. FAX: (21) 3420-2995 / (21) 9 9249-1722&#10;E-MAIL: : WINDISTRISERV@GMAIL.COM'),(176,'D.J RIO DISTRIBUIDORA DE ALIMENTOS E BEBIDAS LTDA','17.456.498/0001-02','ENDEREÇO: Estrada do Quafá no 39 - Bangu&#10;CIDADE: Rio de Janeiro - RJ&#10;CEP.: 21.853-050&#10;REPRESENTANTE: Sra Juliana Sabino&#10;TEL. FAX: (21) 3331-2075 / (21) 3399-5524&#10;E-MAIL: : pedidos@djrio.com.br / djriodistribuidora@globo.com'),(177,'CW SETE PAES EIRELE - ME','29.739.335/0001-08','ENDEREÇO: Avenida Dom Helder Câmara, no 25 - Benfica&#10;CIDADE: Rio de Janeiro - RJ&#10;CEP.: 20.911-290&#10;REPRESENTANTE: Sr. Washington Luiz Ramos Fraga&#10;TEL. FAX: (21) 3860-5382 / (21) 97217-4641&#10;E-MAIL: : cwsetepaes@gamil.com'),(178,'IRMÃOS SANTOS DIAS FRUTAS E LEGUMES LTDA','04.714.121/0001-56','ENDEREÇO: Rua Capitão Félix, 110 Rua 13, Loja 01 - Benfica&#10;CIDADE: Rio de Janeiro - RJ&#10;CEP.: 20.911-290&#10;REPRESENTANTE: Sr. José Paulo Dias dos Santos&#10;TEL. FAX: (21) 3860-7383&#10;E-MAIL: : irmaos.santosdias@bol.com.br'),(179,'COMERCIAL GULLES COMERCIO EIRELI','10.890.635/0001-65','ENDEREÇO: Rua Galvão, 148, Bloco 3 - Loja 106 - Barreto&#10;CIDADE: Niterói - RJ&#10;CEP.: 24.110-260&#10;REPRESENTANTE: Sr. Renan Guterres&#10;TEL. FAX: (21) 2628-0177&#10;E-MAIL: : gullesfinanceiro@gmail.com&#10;'),(180,'PROMEAL INDUSTRIA DE ALIMENTOS LTDA','33.613.727/0001-01','ENDEREÇO: AV NOSSA SENHORA DE COPACABANA 330, SAL 608, COPACABANA, RIO&#10;DE JANEIRO&#10;CIDADE: Rio de Janeiro - RJ&#10;CEP: 22.020-001&#10;REPRESENTANTE: Sra. CLAUDIA CANDIDO GOMES&#10;TEL. FAX: (21) 97007-4111&#10;E-MAIL: : contato@promeal.com.br'),(181,'SEMOG DISTRIBUIDORA DE ALIMENTOS LTDA','34.057.175/0001-57','ENDEREÇO: Rua Samin, 250 – Irajá - Rio De Janeiro&#10;CIDADE: Rio de Janeiro - RJ&#10;CEP.: 21.235-210&#10;REPRESENTANTE: Sra. SIMONE CUNHA DE SOUZA&#10;TEL. FAX: (21) 964271002 (21) 98680-9899&#10;E-MAIL: : semogdistribuidora@gmail.com'),(182,'FRANCINE GIANA GUIDO E CIA LTDA','28.094.497/0001-73','ENDEREÇO: Avenida Brasil 1085 CENTRO SfnfÃO - RS&#10;CIDADE: Rio de Janeiro - RJ&#10;CEP.: 21.235-210&#10;REPRESENTANTE: Sra. Francine Giana Guido&#10;TEL. FAX (54) 3345 -1796 ou (54) 3345-1830&#10;E-MAIL: cultivafinanceiro@hotmail.com'),(183,'NUTRE PLUS COMERCIAL ALIMENTOS EIRELI','11.428.542/0001-86','ENDEREÇO: Rua Capitão Félix, 110, Sl – 404 - BENFICA&#10;CIDADE: Rio de Janeiro - RJ&#10;CEP.: 20.920-310&#10;REPRESENTANTE: Sr Marcos Vinícius&#10;E-MAIL: marcus@nutre-plus.com.br'),(184,'LACTALIS DO BRASIL COM. IMP.EXP DE LATICÍNIOS LTDA','14.049.467/0027-70','ENDEREÇO: Rua Erno Dahmer no 687, bairro - Alegust, 110&#10;CIDADE: Teotônia - RS&#10;CEP: 95.890-000&#10;REPRESENTANTE: Sr Milton José Schuch&#10;E-MAIL: schuch.licitacoes@yahoo.com.br'),(185,'DISTRIBUIDORA DE GELO E BEBIDAS BOTAFOGO LTDA -ME','29.039.136/0001-97','ENDEREÇO: Rua Real grandeza nº 308 –Loja -C, bairro -Botafogo-Rio de Janeiro-RJ&#10;CEP.:22.281-036&#10;REPRESENTANTE: Srª  Aline Alves das Oliveiras &#10;TEL. (21) 98366-0003 &#10;E-MAIL: botafogoegelo@gmail.com'),(186,'FIEIS DA TERRA ATACADISTA LTDA','04.906.377/0001-65','Telefone: (21) 2450-2800/ (21) 2450-2786, R Nerval de Gouveia nº431, Cascadura, Rio de Janeiro, RJ'),(187,'CG COMERCIO ATACADISTA','36.245.543/0001-16','Telefone: (21) 9336-8049/ (21) 2665-7438, R ALVARO DE MAGALHAES Nº 325, JARDIM AMERICA, RIO DE JANEIRO, RJ '),(188,'PEIXE GOURMET IMPORTACAO E EXPORTACAO LTDA','14.798.308/0001-39','RUA DONA AMELIA LEUCHTENBERG, 87 - PONTA DA PRAIA - SANTOS -SP CEP: 11030-020'),(189,'Y V DOS SANTOS','26.605.589/0001-45','RUA URURAI, n 444, LOJA, BAIRRO COELHO NETO 21511-000 RJ&#10;Tel : (21) 7033-0312'),(190,'SUPPLY VITAL','12.762.591/0001-13','TEL: (21)3256-5878, ENDEREÇO: Rua Catanduva, 79 - Coelho Neto, RJ CEP: 21545-420'),(191,'SUPPLY VITAL LTDA','37.539.851/0001-17','Rua Catanduva, nº 79, Coelho Neto - Rio de Janeiro, RJ, (21) 3256-5878'),(192,'COMAX COMERCIO DE ALIMENTOS LTDA','74.116.898/0001-02','R. Dias Raposo, 77 - Ramos, Rio de Janeiro - RJ, 21031-140&#10;RAMOS, RIO DE JANEIRO, RJ&#10;&#10;Telefone&#10;21 2580-2853&#10;E-MAIL&#10;maxvila2004@yahoo.com.br'),(193,'MK POLPAS E SUCOS LTDA.','35.841.682/0001-40','Endereço&#10;Estrada de Sao Vicente&#10;CEP: 28.970-000&#10;Número: 1120&#10;Bairro: Monteiros&#10;Município: Araruama&#10;UF: RJ&#10; (21) 9643-7795&#10;baldezkato@gmail.com&#10;'),(194,'MARIZA INDUSTRIA E COMERCIO DE ALIMENTOS LTDA','01.773.117/0001-70','Logradouro: ROD br 316&#10;Número: S/N&#10; Complemento: KM 62&#10;Bairro: Titanlandia&#10;Município: Castanhal&#10;UF: PA&#10;CEP: 68.741-740&#10;Telefone: (91) 3412-2100&#10;contabil@marizafoods.com.br'),(195,'SUPRY OFFICE DISTRIBUIDORA DE MATERIAIS E SERVIÇOS LTDA','18.593.064/0640-00','Av. Gomes Freire, 647 - Santa Teresa, Rio de Janeiro - RJ, 20231-014&#10;Telefone: (21) 2224-8175/ (21) 2531-7690&#10; E-mail: supryoffice@gmail.com'),(196,'N S APARECIDA DISTRIBUIDORA DE PRODUTOS ALIMENTICIOS','35.385.417/0001-02','Rua Cruz e Souza - Encantado - Rio de Janeiro - RJ - 25966-055, email - thiagooliveirarj84@gmail.com, (21)964029210'),(197,'ATL COMERCIO E SERVICOS EIRELI','32.457.007/0001-23','Logradouro: Estrada Pau Ferro, 01218&#10;Complemento: Sal 0605&#10;Bairro: Freguesia (Jacarepagua)&#10;CEP: 22745-056&#10;Município: Rio de Janeiro&#10;Estado: Rio de Janeiro&#10;&#10;Email: atlempresa@gmail.com&#10;Tel: (21) 96411-0641'),(198,'FERMENTO GOOD INSTANT LTDA','03.644.180/0001-32','RODOVIA ERS 130, 5500&#10;JARDIM DO CEDRO&#10;LAJEADO | RS&#10;CEP 95900-010&#10;&#10;EMAIL: bruxel@itrs.com.br&#10;TEL: (51) 3714-1258&#10;'),(199,'SVB COMERCIO DE PRODUTOS EM GERAL EIRELI','33.025.449/0001-63','Logradouro: Alberico Diniz, 01555&#10;Bairro: Jardim Sulacap&#10;CEP: 21741-110&#10;Município: Rio de Janeiro&#10;Estado: Rio de Janeiro&#10;&#10;E-mail: niserg@hotmail.com&#10;Telefone(s):&#10;(21) 98474-3113 &#10;(21) 3358-3114'),(200,'FORTE AFONSOS DISTRIBUIDORA DE ALIMENTOS EIRELI','26.361.172/0001-84','RUA CAPITAO FELIX, 110&#10;PAVLH 2 LOJ 17 RUA 5 BLC D - BENFICA&#10;CEP: 20920-310&#10;&#10;TEL:(21) 2585-6363'),(201,'LOY COMERCIO DE ALIMENTOS HORTIFRUTI EIRELI','22.923.443/0001-97','Logradouro: Ana Neri, 01009&#10;Bairro: Rocha&#10;CEP: 20960-006&#10;Município: Rio de Janeiro&#10;Estado: Rio de Janeiro&#10;&#10;Tel: (21) 3040-0026'),(202,'VISIONARIA COMERCIO E SERVICOS EM GERAL LTDA','09.211.999/0001-92','RUA CAPITAO FELIX, 00110&#10;PAV 2 LOJ 20 RUA 3 BLC D - BENFICA&#10;CEP: 20920-900&#10;&#10;Tel: (21) 4101-6916 | (21) 4101-6916&#10;'),(203,'COMERCIAL DELLA COSTA 110 LTDA','04.325.483/0001-55','Logradouro: Capitao Felix, 110&#10;Complemento: Rua 3, Lojas 7 e 9&#10;Bairro: Benfica&#10;CEP: 20920-310&#10;Município: Rio de Janeiro&#10;Estado: Rio de Janeiro&#10;&#10;Tel:(21) 3860-4921&#10;      (21) 3878-2237&#10;'),(204,'MR ALIMENTOS SAUDAVEIS LTDA','22.077.561/0001-21','Logradouro: Francisco Xavier da Silva, 1092&#10;Complemento: Slj Sobreloja&#10;Bairro: Jardim Silvino&#10;CEP: 86188-040&#10;Município: Cambé&#10;Estado: Paraná&#10;&#10;Tel:(43) 3154-7133'),(205,'P G B GOMES','14.612.989/0001-07','Logradouro: Segunda, S/n&#10;Complemento: Quadra I Lote 20&#10;Bairro: Santa Lidia&#10;CEP: 68740-005&#10;Município: Castanhal&#10;Estado: Pará&#10;&#10;E-mail: nutrinpolpas@outlook.com &#10;Telefone(s):&#10;(91) 99149-8900 '),(206,'RIOFRIO ','27.538.635/0001-01','Riofrio Mais Alimentos Importacao Eireli&#10;Arthur Antonio Sendas S/n Lote 33 Quadra14&#10;Parque Analandia&#10;São João de Meriti RJ&#10;25585-000&#10;&#10;Telefone:&#10;(21) 2757-5710'),(207,'SUPERMERCADOS CELEIRO LTDA','07.678.203/0001-80','Estrada do Caminho n° 04105, CEP: 23068-033, Cosmo, Rio de Janeiro, RJ. &#10;TEL: (21) 31086715&#10;E-mail: dp1.redeconomia@hotmail.com'),(208,'NUTRI ALIMENTOS DE NILOPOLIS COMERCIO ATACADISTA EIRELI','11.074.537/0001-12','Rua Carlos de Sousa Fernandes N:74 &#10;CEP: 26.545-000 &#10;TEL: (21) 26692522 e (21) 97217-7392&#10;Bairro: Olinda &#10;Município: Nilópolis&#10; '),(209,'COSTA SUL PESCADO ','81.599.359/0001-29','Rua Prefeito Manoel Evaldo Muller, 2827 / Machados CEP: 88371-600, Navegantes, Santa Catarina.&#10;E-mail: contato@alfaconcontabilidade.com.br&#10;&#10;(47) 2103-3000&#10;(47) 3424-422&#10;(47) 2122-7748');

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


