-- CRIACAO DO BANCO: cria caronas_db apenas se ainda nao existir.
-- utf8mb4 permite armazenar acentos e outros caracteres Unicode.
CREATE DATABASE  IF NOT EXISTS `caronas_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
-- Seleciona o banco em que os proximos comandos serao executados.
USE `caronas_db`;
-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: caronas_db
-- ------------------------------------------------------
-- Server version	8.0.46

-- CONFIGURACOES DO DUMP: guarda configuracoes da conexao para restaura-las no final.
-- Os comandos /*!...*/ sao diretivas condicionais reconhecidas pelo MySQL.
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- MODULO DE AVALIACOES: armazena notas de motoristas e passageiros.


DROP TABLE IF EXISTS `avaliacoes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
-- Cada registro representa uma avaliacao feita por um participante da carona.
-- carona_id: viagem avaliada; avaliador_id: quem deu a nota; avaliado_id: quem recebeu.
-- nota: inteiro de 1 a 5; comentario: texto opcional; criado_em: data do registro.
CREATE TABLE `avaliacoes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `carona_id` int NOT NULL,
  `avaliador_id` int NOT NULL,
  `avaliado_id` int NOT NULL,
  `nota` int NOT NULL,
  `comentario` varchar(500) DEFAULT NULL,
  `criado_em` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
-- Chave primaria: identifica cada registro sem repeticao.
  PRIMARY KEY (`id`),
-- Impede que o mesmo avaliador avalie a mesma pessoa duas vezes na mesma carona.
  UNIQUE KEY `carona_id` (`carona_id`,`avaliador_id`,`avaliado_id`),
  KEY `avaliador_id` (`avaliador_id`),
  KEY `avaliado_id` (`avaliado_id`),
-- Chaves estrangeiras ligam a avaliacao a uma carona e a usuarios existentes.
  CONSTRAINT `avaliacoes_ibfk_1` FOREIGN KEY (`carona_id`) REFERENCES `caronas` (`id`),
  CONSTRAINT `avaliacoes_ibfk_2` FOREIGN KEY (`avaliador_id`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `avaliacoes_ibfk_3` FOREIGN KEY (`avaliado_id`) REFERENCES `usuarios` (`id`),
-- Regras de validacao: nota de 1 a 5 e proibicao de autoavaliacao.
  CONSTRAINT `chk_nota` CHECK ((`nota` between 1 and 5)),
  CONSTRAINT `chk_usuarios_diferentes` CHECK ((`avaliador_id` <> `avaliado_id`))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- DADOS DE EXEMPLO: INSERT restaura avaliacoes registradas na exportacao.
-- Para publicar somente a estrutura, exporte Dump Structure Only no Workbench.
-- Dumping data for table `avaliacoes`
--

-- Bloqueia temporariamente a tabela durante a importacao dos dados.
LOCK TABLES `avaliacoes` WRITE;
/*!40000 ALTER TABLE `avaliacoes` DISABLE KEYS */;
INSERT INTO `avaliacoes` VALUES (1,1,2,1,5,'Motorista pontual e educado.','2026-11-20 04:54:52'),(2,1,1,2,5,'Passageiro é top.','2026-11-20 04:57:04');
/*!40000 ALTER TABLE `avaliacoes` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
-- TRIGGER validar_avaliacao: antes de inserir uma nota, confirma que a
-- carona foi concluida, que existe solicitacao aceita e que os participantes
-- sao motorista e passageiro da mesma viagem (em qualquer direcao).
-- SIGNAL impede o INSERT caso a regra nao seja atendida.
