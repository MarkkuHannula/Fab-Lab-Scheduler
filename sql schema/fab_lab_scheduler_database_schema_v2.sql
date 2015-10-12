-- MySQL Script generated by MySQL Workbench
-- 10/12/15 11:28:12
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema fablab_scheduler
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema fablab_scheduler
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `fablab_scheduler` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `fablab_scheduler` ;

-- -----------------------------------------------------
-- Table `fablab_scheduler`.`MachineGroup`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fablab_scheduler`.`MachineGroup` ;

CREATE TABLE IF NOT EXISTS `fablab_scheduler`.`MachineGroup` (
  `MachineGroupID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(50) NOT NULL,
  `Description` VARCHAR(50) NULL,
  PRIMARY KEY (`MachineGroupID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fablab_scheduler`.`Machine`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fablab_scheduler`.`Machine` ;

CREATE TABLE IF NOT EXISTS `fablab_scheduler`.`Machine` (
  `MachineID` INT NOT NULL AUTO_INCREMENT,
  `MachineGroupID` INT NOT NULL,
  `Manufacturer` VARCHAR(50) NOT NULL,
  `Model` VARCHAR(50) NOT NULL,
  `NeedSupervision` TINYINT(1) NOT NULL,
  `Description` VARCHAR(45) NULL,
  PRIMARY KEY (`MachineID`, `MachineGroupID`),
  INDEX `fk_Machines_Machinegroups_idx` (`MachineGroupID` ASC),
  CONSTRAINT `fk_Machines_Machinegroups`
    FOREIGN KEY (`MachineGroupID`)
    REFERENCES `fablab_scheduler`.`MachineGroup` (`MachineGroupID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fablab_scheduler`.`aauth_users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fablab_scheduler`.`aauth_users` ;

CREATE TABLE IF NOT EXISTS `fablab_scheduler`.`aauth_users` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(100) CHARACTER SET 'utf8' NOT NULL,
  `pass` VARCHAR(64) CHARACTER SET 'utf8' NOT NULL,
  `name` VARCHAR(100) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `banned` TINYINT(1) NULL DEFAULT '0',
  `last_login` DATETIME NULL DEFAULT NULL,
  `last_activity` DATETIME NULL DEFAULT NULL,
  `last_login_attempt` DATETIME NULL DEFAULT NULL,
  `forgot_exp` TEXT CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `remember_time` DATETIME NULL DEFAULT NULL,
  `remember_exp` TEXT CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `verification_code` TEXT CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `totp_secret` VARCHAR(16) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `ip_address` TEXT CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `login_attempts` INT(11) NULL DEFAULT '0',
  `surname` VARCHAR(512) NULL,
  `address_street` VARCHAR(512) NULL,
  `address_postal_code` VARCHAR(512) NULL,
  `phone_number` VARCHAR(30) NULL,
  `student_id` VARCHAR(20) NULL,
  `quota` DECIMAL NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `fablab_scheduler`.`UserLevel`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fablab_scheduler`.`UserLevel` ;

CREATE TABLE IF NOT EXISTS `fablab_scheduler`.`UserLevel` (
  `MachineID` INT NOT NULL,
  `aauth_usersID` INT(11) UNSIGNED NOT NULL,
  `Level` INT NOT NULL,
  PRIMARY KEY (`MachineID`, `aauth_usersID`),
  INDEX `fk_Userlevels_Machines1_idx` (`MachineID` ASC),
  INDEX `fk_Userlevels_aauth_users1_idx` (`aauth_usersID` ASC),
  CONSTRAINT `fk_Userlevels_Machines1`
    FOREIGN KEY (`MachineID`)
    REFERENCES `fablab_scheduler`.`Machine` (`MachineID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Userlevels_aauth_users1`
    FOREIGN KEY (`aauth_usersID`)
    REFERENCES `fablab_scheduler`.`aauth_users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fablab_scheduler`.`Reservation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fablab_scheduler`.`Reservation` ;

CREATE TABLE IF NOT EXISTS `fablab_scheduler`.`Reservation` (
  `ReservationID` INT NOT NULL AUTO_INCREMENT,
  `MachineID` INT NOT NULL,
  `aauth_usersID` INT(11) UNSIGNED NOT NULL,
  `StartTime` INT NOT NULL,
  `EndTime` INT NOT NULL,
  `QRCode` VARCHAR(256) NOT NULL,
  `PassCode` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`ReservationID`, `MachineID`, `aauth_usersID`),
  INDEX `fk_Reservations_Machines1_idx` (`MachineID` ASC),
  INDEX `fk_Reservations_aauth_users1_idx` (`aauth_usersID` ASC),
  CONSTRAINT `fk_Reservations_Machines1`
    FOREIGN KEY (`MachineID`)
    REFERENCES `fablab_scheduler`.`Machine` (`MachineID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Reservations_aauth_users1`
    FOREIGN KEY (`aauth_usersID`)
    REFERENCES `fablab_scheduler`.`aauth_users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fablab_scheduler`.`Supervision`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fablab_scheduler`.`Supervision` ;

CREATE TABLE IF NOT EXISTS `fablab_scheduler`.`Supervision` (
  `SupervisionID` INT NOT NULL AUTO_INCREMENT,
  `aauth_usersID` INT(11) UNSIGNED NOT NULL,
  `StartTime` VARCHAR(512) NOT NULL,
  `EndTime` VARCHAR(512) NOT NULL,
  PRIMARY KEY (`SupervisionID`, `aauth_usersID`),
  INDEX `fk_Supervisions_aauth_users1_idx` (`aauth_usersID` ASC),
  CONSTRAINT `fk_Supervisions_aauth_users1`
    FOREIGN KEY (`aauth_usersID`)
    REFERENCES `fablab_scheduler`.`aauth_users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fablab_scheduler`.`Setting`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fablab_scheduler`.`Setting` ;

CREATE TABLE IF NOT EXISTS `fablab_scheduler`.`Setting` (
  `SettingKey` VARCHAR(20) NOT NULL,
  `SettingValue` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`SettingKey`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fablab_scheduler`.`aauth_groups`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fablab_scheduler`.`aauth_groups` ;

CREATE TABLE IF NOT EXISTS `fablab_scheduler`.`aauth_groups` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NULL DEFAULT NULL,
  `definition` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `fablab_scheduler`.`aauth_perms`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fablab_scheduler`.`aauth_perms` ;

CREATE TABLE IF NOT EXISTS `fablab_scheduler`.`aauth_perms` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NULL DEFAULT NULL,
  `definition` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `fablab_scheduler`.`aauth_perm_to_group`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fablab_scheduler`.`aauth_perm_to_group` ;

CREATE TABLE IF NOT EXISTS `fablab_scheduler`.`aauth_perm_to_group` (
  `perm_id` INT(11) UNSIGNED NULL DEFAULT NULL,
  `group_id` INT(11) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`perm_id`, `group_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `fablab_scheduler`.`aauth_perm_to_user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fablab_scheduler`.`aauth_perm_to_user` ;

CREATE TABLE IF NOT EXISTS `fablab_scheduler`.`aauth_perm_to_user` (
  `perm_id` INT(11) UNSIGNED NULL DEFAULT NULL,
  `user_id` INT(11) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`perm_id`, `user_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `fablab_scheduler`.`aauth_pms`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fablab_scheduler`.`aauth_pms` ;

CREATE TABLE IF NOT EXISTS `fablab_scheduler`.`aauth_pms` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `sender_id` INT(11) UNSIGNED NOT NULL,
  `receiver_id` INT(11) UNSIGNED NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `message` TEXT NULL DEFAULT NULL,
  `date_sent` DATETIME NULL DEFAULT NULL,
  `date_read` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `full_index` (`id` ASC, `sender_id` ASC, `receiver_id` ASC, `date_read` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `fablab_scheduler`.`aauth_system_variables`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fablab_scheduler`.`aauth_system_variables` ;

CREATE TABLE IF NOT EXISTS `fablab_scheduler`.`aauth_system_variables` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `data_key` VARCHAR(100) NOT NULL,
  `value` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `fablab_scheduler`.`aauth_user_to_group`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fablab_scheduler`.`aauth_user_to_group` ;

CREATE TABLE IF NOT EXISTS `fablab_scheduler`.`aauth_user_to_group` (
  `user_id` INT(11) UNSIGNED NOT NULL DEFAULT '0',
  `group_id` INT(11) UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`, `group_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `fablab_scheduler`.`aauth_user_variables`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fablab_scheduler`.`aauth_user_variables` ;

CREATE TABLE IF NOT EXISTS `fablab_scheduler`.`aauth_user_variables` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT(11) UNSIGNED NOT NULL,
  `data_key` VARCHAR(100) NOT NULL,
  `value` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `user_id_index` (`user_id` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
