-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema forumsdb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema forumsdb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `forumsdb` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
USE `forumsdb` ;

-- -----------------------------------------------------
-- Table `forumsdb`.`forum`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `forumsdb`.`forum` (
  `forum_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL DEFAULT '',
  PRIMARY KEY (`forum_id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `forumsdb`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `forumsdb`.`user` (
  `user_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL DEFAULT 'username',
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `forumsdb`.`topic`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `forumsdb`.`topic` (
  `topic_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `forum_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(45) NOT NULL DEFAULT '',
  `creation_date` TIMESTAMP(0) NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (`topic_id`, `user_id`, `forum_id`),
  INDEX `fk_topic_forum_idx` (`forum_id` ASC),
  INDEX `fk_topic_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_topic_forum`
    FOREIGN KEY (`forum_id`)
    REFERENCES `forumsdb`.`forum` (`forum_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_topic_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `forumsdb`.`user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `forumsdb`.`message`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `forumsdb`.`message` (
  `message_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `topic_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  `text` TEXT(10000) NOT NULL,
  `creation_date` TIMESTAMP(0) NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (`message_id`, `topic_id`, `user_id`),
  INDEX `fk_message_topic1_idx` (`topic_id` ASC),
  INDEX `fk_message_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_message_topic1`
    FOREIGN KEY (`topic_id`)
    REFERENCES `forumsdb`.`topic` (`topic_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_message_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `forumsdb`.`user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
