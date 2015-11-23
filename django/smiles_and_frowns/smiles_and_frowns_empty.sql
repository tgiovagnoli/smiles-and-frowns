/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 50612
 Source Host           : localhost
 Source Database       : smiles_and_frowns

 Target Server Type    : MySQL
 Target Server Version : 50612
 File Encoding         : utf-8

 Date: 11/23/2015 10:24:47 AM
*/

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `auth_group`
-- ----------------------------
DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Table structure for `auth_group_permissions`
-- ----------------------------
DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_id` (`group_id`,`permission_id`),
  KEY `auth_group__permission_id_1f49ccbbdc69d2fc_fk_auth_permission_id` (`permission_id`),
  CONSTRAINT `auth_group__permission_id_1f49ccbbdc69d2fc_fk_auth_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permission_group_id_689710a9a73b7457_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Table structure for `auth_permission`
-- ----------------------------
DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `content_type_id` (`content_type_id`,`codename`),
  CONSTRAINT `auth__content_type_id_508cf46651277a81_fk_django_content_type_id` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=latin1;

-- ----------------------------
--  Records of `auth_permission`
-- ----------------------------
BEGIN;
INSERT INTO `auth_permission` VALUES ('1', 'Can add log entry', '1', 'add_logentry'), ('2', 'Can change log entry', '1', 'change_logentry'), ('3', 'Can delete log entry', '1', 'delete_logentry'), ('4', 'Can add permission', '2', 'add_permission'), ('5', 'Can change permission', '2', 'change_permission'), ('6', 'Can delete permission', '2', 'delete_permission'), ('7', 'Can add group', '3', 'add_group'), ('8', 'Can change group', '3', 'change_group'), ('9', 'Can delete group', '3', 'delete_group'), ('10', 'Can add user', '4', 'add_user'), ('11', 'Can change user', '4', 'change_user'), ('12', 'Can delete user', '4', 'delete_user'), ('13', 'Can add content type', '5', 'add_contenttype'), ('14', 'Can change content type', '5', 'change_contenttype'), ('15', 'Can delete content type', '5', 'delete_contenttype'), ('16', 'Can add session', '6', 'add_session'), ('17', 'Can change session', '6', 'change_session'), ('18', 'Can delete session', '6', 'delete_session'), ('19', 'Can add user social auth', '7', 'add_usersocialauth'), ('20', 'Can change user social auth', '7', 'change_usersocialauth'), ('21', 'Can delete user social auth', '7', 'delete_usersocialauth'), ('22', 'Can add nonce', '8', 'add_nonce'), ('23', 'Can change nonce', '8', 'change_nonce'), ('24', 'Can delete nonce', '8', 'delete_nonce'), ('25', 'Can add association', '9', 'add_association'), ('26', 'Can change association', '9', 'change_association'), ('27', 'Can delete association', '9', 'delete_association'), ('28', 'Can add code', '10', 'add_code'), ('29', 'Can change code', '10', 'change_code'), ('30', 'Can delete code', '10', 'delete_code'), ('31', 'Can add profile', '11', 'add_profile'), ('32', 'Can change profile', '11', 'change_profile'), ('33', 'Can delete profile', '11', 'delete_profile'), ('34', 'Can add board', '12', 'add_board'), ('35', 'Can change board', '12', 'change_board'), ('36', 'Can delete board', '12', 'delete_board'), ('37', 'Can add user role', '13', 'add_userrole'), ('38', 'Can change user role', '13', 'change_userrole'), ('39', 'Can delete user role', '13', 'delete_userrole'), ('40', 'Can add behavior', '14', 'add_behavior'), ('41', 'Can change behavior', '14', 'change_behavior'), ('42', 'Can delete behavior', '14', 'delete_behavior'), ('43', 'Can add reward', '15', 'add_reward'), ('44', 'Can change reward', '15', 'change_reward'), ('45', 'Can delete reward', '15', 'delete_reward'), ('46', 'Can add smile', '16', 'add_smile'), ('47', 'Can change smile', '16', 'change_smile'), ('48', 'Can delete smile', '16', 'delete_smile'), ('49', 'Can add frown', '17', 'add_frown'), ('50', 'Can change frown', '17', 'change_frown'), ('51', 'Can delete frown', '17', 'delete_frown'), ('52', 'Can add invite', '18', 'add_invite'), ('53', 'Can change invite', '18', 'change_invite'), ('54', 'Can delete invite', '18', 'delete_invite'), ('55', 'Can add temp profile image', '19', 'add_tempprofileimage'), ('56', 'Can change temp profile image', '19', 'change_tempprofileimage'), ('57', 'Can delete temp profile image', '19', 'delete_tempprofileimage'), ('58', 'Can add predefined behavior', '20', 'add_predefinedbehavior'), ('59', 'Can change predefined behavior', '20', 'change_predefinedbehavior'), ('60', 'Can delete predefined behavior', '20', 'delete_predefinedbehavior'), ('61', 'Can add predefined board', '21', 'add_predefinedboard'), ('62', 'Can change predefined board', '21', 'change_predefinedboard'), ('63', 'Can delete predefined board', '21', 'delete_predefinedboard'), ('64', 'Can add predefined behavior group', '22', 'add_predefinedbehaviorgroup'), ('65', 'Can change predefined behavior group', '22', 'change_predefinedbehaviorgroup'), ('66', 'Can delete predefined behavior group', '22', 'delete_predefinedbehaviorgroup');
COMMIT;

-- ----------------------------
--  Table structure for `auth_user`
-- ----------------------------
DROP TABLE IF EXISTS `auth_user`;
CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(30) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- ----------------------------
--  Records of `auth_user`
-- ----------------------------
BEGIN;
INSERT INTO `auth_user` VALUES ('1', 'pbkdf2_sha256$20000$RPv6RPXnvBgi$sfqqAtAHR8e2kAHivudXUnxAZC25Voj2fC6QBvrrIRM=', '2015-11-23 18:23:24.852590', '1', 'admin', '', '', 'info@apptitude-digital.com', '1', '1', '2015-11-23 18:23:01.541822');
COMMIT;

-- ----------------------------
--  Table structure for `auth_user_groups`
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_groups`;
CREATE TABLE `auth_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_33ac548dcf5f8e37_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_33ac548dcf5f8e37_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_4b5ed4ffdb8fd9b0_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Table structure for `auth_user_user_permissions`
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_user_permissions`;
CREATE TABLE `auth_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`permission_id`),
  KEY `auth_user_u_permission_id_384b62483d7071f0_fk_auth_permission_id` (`permission_id`),
  CONSTRAINT `auth_user_u_permission_id_384b62483d7071f0_fk_auth_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissi_user_id_7f0938558328534a_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Table structure for `django_admin_log`
-- ----------------------------
DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `djang_content_type_id_697914295151027a_fk_django_content_type_id` (`content_type_id`),
  KEY `django_admin_log_user_id_52fdd58701c5f563_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_user_id_52fdd58701c5f563_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `djang_content_type_id_697914295151027a_fk_django_content_type_id` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Table structure for `django_content_type`
-- ----------------------------
DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_45f3b1d93ec8c61c_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1;

-- ----------------------------
--  Records of `django_content_type`
-- ----------------------------
BEGIN;
INSERT INTO `django_content_type` VALUES ('1', 'admin', 'logentry'), ('3', 'auth', 'group'), ('2', 'auth', 'permission'), ('4', 'auth', 'user'), ('5', 'contenttypes', 'contenttype'), ('9', 'default', 'association'), ('10', 'default', 'code'), ('8', 'default', 'nonce'), ('7', 'default', 'usersocialauth'), ('20', 'predefinedboards', 'predefinedbehavior'), ('22', 'predefinedboards', 'predefinedbehaviorgroup'), ('21', 'predefinedboards', 'predefinedboard'), ('14', 'services', 'behavior'), ('12', 'services', 'board'), ('17', 'services', 'frown'), ('18', 'services', 'invite'), ('11', 'services', 'profile'), ('15', 'services', 'reward'), ('16', 'services', 'smile'), ('19', 'services', 'tempprofileimage'), ('13', 'services', 'userrole'), ('6', 'sessions', 'session');
COMMIT;

-- ----------------------------
--  Table structure for `django_migrations`
-- ----------------------------
DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE `django_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=latin1;

-- ----------------------------
--  Records of `django_migrations`
-- ----------------------------
BEGIN;
INSERT INTO `django_migrations` VALUES ('1', 'contenttypes', '0001_initial', '2015-11-23 18:22:35.377698'), ('2', 'auth', '0001_initial', '2015-11-23 18:22:35.642468'), ('3', 'admin', '0001_initial', '2015-11-23 18:22:35.717582'), ('4', 'contenttypes', '0002_remove_content_type_name', '2015-11-23 18:22:35.815478'), ('5', 'auth', '0002_alter_permission_name_max_length', '2015-11-23 18:22:35.855335'), ('6', 'auth', '0003_alter_user_email_max_length', '2015-11-23 18:22:35.888835'), ('7', 'auth', '0004_alter_user_username_opts', '2015-11-23 18:22:35.905664'), ('8', 'auth', '0005_alter_user_last_login_null', '2015-11-23 18:22:35.956149'), ('9', 'auth', '0006_require_contenttypes_0002', '2015-11-23 18:22:35.957694'), ('10', 'default', '0001_initial', '2015-11-23 18:22:36.204817'), ('11', 'predefinedboards', '0001_initial', '2015-11-23 18:22:36.417998'), ('12', 'predefinedboards', '0002_auto_20151029_2301', '2015-11-23 18:22:36.572844'), ('13', 'predefinedboards', '0003_auto_20151102_1909', '2015-11-23 18:22:36.936956'), ('14', 'predefinedboards', '0004_predefinedbehavior_positive', '2015-11-23 18:22:36.998289'), ('15', 'services', '0001_initial', '2015-11-23 18:22:37.821216'), ('16', 'services', '0002_auto_20151021_2100', '2015-11-23 18:22:37.878512'), ('17', 'services', '0003_auto_20151021_2141', '2015-11-23 18:22:38.216692'), ('18', 'services', '0004_auto_20151021_2201', '2015-11-23 18:22:38.367400'), ('19', 'services', '0005_auto_20151021_2235', '2015-11-23 18:22:38.650375'), ('20', 'services', '0006_auto_20151021_2240', '2015-11-23 18:22:38.949908'), ('21', 'services', '0007_auto_20151022_0047', '2015-11-23 18:22:39.356602'), ('22', 'services', '0008_auto_20151022_1922', '2015-11-23 18:22:39.419730'), ('23', 'services', '0009_auto_20151022_2027', '2015-11-23 18:22:39.682179'), ('24', 'services', '0010_auto_20151023_2144', '2015-11-23 18:22:39.870048'), ('25', 'services', '0011_auto_20151023_2158', '2015-11-23 18:22:41.156774'), ('26', 'services', '0012_auto_20151028_0016', '2015-11-23 18:22:41.675559'), ('27', 'services', '0013_auto_20151028_0018', '2015-11-23 18:22:41.721118'), ('28', 'services', '0014_auto_20151028_2040', '2015-11-23 18:22:41.843818'), ('29', 'services', '0015_auto_20151028_2108', '2015-11-23 18:22:41.908653'), ('30', 'services', '0016_auto_20151028_2118', '2015-11-23 18:22:42.089514'), ('31', 'services', '0017_auto_20151029_2241', '2015-11-23 18:22:42.313166'), ('32', 'services', '0018_predefinedboard_behaviors', '2015-11-23 18:22:42.384710'), ('33', 'services', '0019_auto_20151029_2247', '2015-11-23 18:22:42.420523'), ('34', 'services', '0020_auto_20151030_1723', '2015-11-23 18:22:42.613224'), ('35', 'services', '0021_auto_20151030_2024', '2015-11-23 18:22:42.783098'), ('36', 'services', '0022_invite_sender', '2015-11-23 18:22:42.925141'), ('37', 'services', '0023_invite_uuid', '2015-11-23 18:22:43.016154'), ('38', 'services', '0024_auto_20151105_1525', '2015-11-23 18:22:43.460663'), ('39', 'services', '0025_auto_20151111_0206', '2015-11-23 18:22:43.647071'), ('40', 'services', '0026_auto_20151111_0218', '2015-11-23 18:22:43.933684'), ('41', 'services', '0027_behavior_positive', '2015-11-23 18:22:44.018517'), ('42', 'services', '0028_profile_image', '2015-11-23 18:22:44.072971'), ('43', 'services', '0029_auto_20151112_2351', '2015-11-23 18:22:44.272732'), ('44', 'services', '0030_tempprofileimage', '2015-11-23 18:22:44.301645'), ('45', 'services', '0031_auto_20151113_1847', '2015-11-23 18:22:44.384532'), ('46', 'sessions', '0001_initial', '2015-11-23 18:22:44.437926');
COMMIT;

-- ----------------------------
--  Table structure for `django_session`
-- ----------------------------
DROP TABLE IF EXISTS `django_session`;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_de54fa62` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Records of `django_session`
-- ----------------------------
BEGIN;
INSERT INTO `django_session` VALUES ('nvvgoddsia47jskbwzwtbriutfuo99kx', 'N2JhNmQxNWFlOTNmNTJkNjRiZDE3NjEyYTg4ZTg3ZmJiM2FlNGY0ODp7Il9hdXRoX3VzZXJfaGFzaCI6ImY3MmRjNzQ3NWEyNWJiMTNiYjc0ZTU3NjI4ZmM5MDI4YTkyOWRmYjUiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOiIxIn0=', '2016-11-23 00:12:36.854080');
COMMIT;

-- ----------------------------
--  Table structure for `predefinedboards_predefinedbehavior`
-- ----------------------------
DROP TABLE IF EXISTS `predefinedboards_predefinedbehavior`;
CREATE TABLE `predefinedboards_predefinedbehavior` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(128) NOT NULL,
  `uuid` varchar(64) NOT NULL,
  `positive` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Table structure for `predefinedboards_predefinedbehaviorgroup`
-- ----------------------------
DROP TABLE IF EXISTS `predefinedboards_predefinedbehaviorgroup`;
CREATE TABLE `predefinedboards_predefinedbehaviorgroup` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(128) NOT NULL,
  `uuid` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Table structure for `predefinedboards_predefinedbehaviorgroup_behaviors`
-- ----------------------------
DROP TABLE IF EXISTS `predefinedboards_predefinedbehaviorgroup_behaviors`;
CREATE TABLE `predefinedboards_predefinedbehaviorgroup_behaviors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `predefinedbehaviorgroup_id` int(11) NOT NULL,
  `predefinedbehavior_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `predefinedbehaviorgroup_id` (`predefinedbehaviorgroup_id`,`predefinedbehavior_id`),
  KEY `c414f723f5b159bb30c43f0d234267b9` (`predefinedbehavior_id`),
  CONSTRAINT `c414f723f5b159bb30c43f0d234267b9` FOREIGN KEY (`predefinedbehavior_id`) REFERENCES `predefinedboards_predefinedbehavior` (`id`),
  CONSTRAINT `D98ae8cbd0c2be86063581296ee47345` FOREIGN KEY (`predefinedbehaviorgroup_id`) REFERENCES `predefinedboards_predefinedbehaviorgroup` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Table structure for `predefinedboards_predefinedboard`
-- ----------------------------
DROP TABLE IF EXISTS `predefinedboards_predefinedboard`;
CREATE TABLE `predefinedboards_predefinedboard` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(128) NOT NULL,
  `uuid` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Table structure for `predefinedboards_predefinedboard_behaviors`
-- ----------------------------
DROP TABLE IF EXISTS `predefinedboards_predefinedboard_behaviors`;
CREATE TABLE `predefinedboards_predefinedboard_behaviors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `predefinedboard_id` int(11) NOT NULL,
  `predefinedbehavior_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `predefinedboard_id` (`predefinedboard_id`,`predefinedbehavior_id`),
  KEY `D8ff4645264186e1bfd26c24f95b61b5` (`predefinedbehavior_id`),
  CONSTRAINT `D5aae6e68146d18268420fce8cb4e8db` FOREIGN KEY (`predefinedboard_id`) REFERENCES `predefinedboards_predefinedboard` (`id`),
  CONSTRAINT `D8ff4645264186e1bfd26c24f95b61b5` FOREIGN KEY (`predefinedbehavior_id`) REFERENCES `predefinedboards_predefinedbehavior` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Table structure for `services_behavior`
-- ----------------------------
DROP TABLE IF EXISTS `services_behavior`;
CREATE TABLE `services_behavior` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(64) NOT NULL,
  `created_date` datetime(6) NOT NULL,
  `updated_date` datetime(6) NOT NULL,
  `device_date` datetime(6) NOT NULL,
  `deleted` tinyint(1) NOT NULL,
  `title` varchar(128) NOT NULL,
  `note` varchar(256),
  `board_id` int(11) DEFAULT NULL,
  `positive` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `services_behavior_uuid_784cdcad5c070d28_uniq` (`uuid`),
  KEY `services_behavior_0047b239` (`board_id`),
  CONSTRAINT `services_behavior_board_id_21f5314ceae68c2f_fk_services_board_id` FOREIGN KEY (`board_id`) REFERENCES `services_board` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Table structure for `services_board`
-- ----------------------------
DROP TABLE IF EXISTS `services_board`;
CREATE TABLE `services_board` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(64) NOT NULL,
  `created_date` datetime(6) NOT NULL,
  `updated_date` datetime(6) NOT NULL,
  `device_date` datetime(6) NOT NULL,
  `deleted` tinyint(1) NOT NULL,
  `title` varchar(128) NOT NULL,
  `transaction_id` varchar(128) DEFAULT NULL,
  `owner_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `services_board_uuid_4f70405795c65acb_uniq` (`uuid`),
  KEY `services_board_5e7b1936` (`owner_id`),
  CONSTRAINT `services_board_owner_id_28b210ff2d087463_fk_auth_user_id` FOREIGN KEY (`owner_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Table structure for `services_frown`
-- ----------------------------
DROP TABLE IF EXISTS `services_frown`;
CREATE TABLE `services_frown` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(64) NOT NULL,
  `created_date` datetime(6) NOT NULL,
  `updated_date` datetime(6) NOT NULL,
  `device_date` datetime(6) NOT NULL,
  `deleted` tinyint(1) NOT NULL,
  `behavior_id` int(11) DEFAULT NULL,
  `board_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `note` varchar(256) NOT NULL,
  `creator_id` int(11),
  PRIMARY KEY (`id`),
  UNIQUE KEY `services_frown_uuid_465d1198c7117035_uniq` (`uuid`),
  KEY `services_frown_board_id_3faf3485b390f85c_fk_services_board_id` (`board_id`),
  KEY `services_fr_behavior_id_14485e1d1e7aab1d_fk_services_behavior_id` (`behavior_id`),
  KEY `services_frown_user_id_43cef0e81a4c3298_fk_auth_user_id` (`user_id`),
  KEY `services_frown_3700153c` (`creator_id`),
  CONSTRAINT `services_frown_creator_id_63bed8822f9843fa_fk_auth_user_id` FOREIGN KEY (`creator_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `services_frown_board_id_3faf3485b390f85c_fk_services_board_id` FOREIGN KEY (`board_id`) REFERENCES `services_board` (`id`),
  CONSTRAINT `services_frown_user_id_43cef0e81a4c3298_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `services_fr_behavior_id_14485e1d1e7aab1d_fk_services_behavior_id` FOREIGN KEY (`behavior_id`) REFERENCES `services_behavior` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Table structure for `services_invite`
-- ----------------------------
DROP TABLE IF EXISTS `services_invite`;
CREATE TABLE `services_invite` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(64) NOT NULL,
  `board_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `role` varchar(64) NOT NULL,
  `created_date` datetime(6),
  `updated_date` datetime(6),
  `sender_id` int(11),
  `uuid` varchar(64),
  `invitee_firstname` varchar(128) DEFAULT NULL,
  `invitee_lastname` varchar(128) DEFAULT NULL,
  `invitee_email` varchar(256),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uuid` (`uuid`),
  KEY `services_invite_board_id_143bda4a6f1a33cc_fk_services_board_id` (`board_id`),
  KEY `services_invite_user_id_392b597d3a78be40_fk_auth_user_id` (`user_id`),
  KEY `services_invite_924b1846` (`sender_id`),
  CONSTRAINT `services_invite_board_id_143bda4a6f1a33cc_fk_services_board_id` FOREIGN KEY (`board_id`) REFERENCES `services_board` (`id`),
  CONSTRAINT `services_invite_sender_id_615b241f74f417c8_fk_auth_user_id` FOREIGN KEY (`sender_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `services_invite_user_id_392b597d3a78be40_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Table structure for `services_profile`
-- ----------------------------
DROP TABLE IF EXISTS `services_profile`;
CREATE TABLE `services_profile` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gender` varchar(64) NOT NULL,
  `age` varchar(3) NOT NULL,
  `user_id` int(11) NOT NULL,
  `image` varchar(100) DEFAULT NULL,
  `image_height` int(10) unsigned,
  `image_width` int(10) unsigned,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `services_profile_user_id_1a92f8cb0fa6cec3_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- ----------------------------
--  Records of `services_profile`
-- ----------------------------
BEGIN;
INSERT INTO `services_profile` VALUES ('1', '', '', '1', '', '100', '100');
COMMIT;

-- ----------------------------
--  Table structure for `services_reward`
-- ----------------------------
DROP TABLE IF EXISTS `services_reward`;
CREATE TABLE `services_reward` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(64) NOT NULL,
  `created_date` datetime(6) NOT NULL,
  `updated_date` datetime(6) NOT NULL,
  `device_date` datetime(6) NOT NULL,
  `deleted` tinyint(1) NOT NULL,
  `title` varchar(128) DEFAULT NULL,
  `currency_amount` double NOT NULL,
  `smile_amount` double NOT NULL,
  `currency_type` varchar(64) NOT NULL,
  `board_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `services_reward_uuid_314d9789370a7697_uniq` (`uuid`),
  KEY `services_reward_board_id_2f0c808ffef50fee_fk_services_board_id` (`board_id`),
  CONSTRAINT `services_reward_board_id_2f0c808ffef50fee_fk_services_board_id` FOREIGN KEY (`board_id`) REFERENCES `services_board` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Table structure for `services_smile`
-- ----------------------------
DROP TABLE IF EXISTS `services_smile`;
CREATE TABLE `services_smile` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(64) NOT NULL,
  `created_date` datetime(6) NOT NULL,
  `updated_date` datetime(6) NOT NULL,
  `device_date` datetime(6) NOT NULL,
  `deleted` tinyint(1) NOT NULL,
  `collected` tinyint(1) NOT NULL,
  `behavior_id` int(11) DEFAULT NULL,
  `board_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `note` varchar(256) NOT NULL,
  `creator_id` int(11),
  PRIMARY KEY (`id`),
  UNIQUE KEY `services_smile_uuid_79177d907c96f64f_uniq` (`uuid`),
  KEY `services_smile_board_id_1bedd71f407e8c08_fk_services_board_id` (`board_id`),
  KEY `services_sm_behavior_id_683b004589bb4f07_fk_services_behavior_id` (`behavior_id`),
  KEY `services_smile_user_id_4fca178b40826dec_fk_auth_user_id` (`user_id`),
  KEY `services_smile_3700153c` (`creator_id`),
  CONSTRAINT `services_smile_creator_id_68c5e2b16e08bd3e_fk_auth_user_id` FOREIGN KEY (`creator_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `services_smile_board_id_1bedd71f407e8c08_fk_services_board_id` FOREIGN KEY (`board_id`) REFERENCES `services_board` (`id`),
  CONSTRAINT `services_smile_user_id_4fca178b40826dec_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `services_sm_behavior_id_683b004589bb4f07_fk_services_behavior_id` FOREIGN KEY (`behavior_id`) REFERENCES `services_behavior` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Table structure for `services_tempprofileimage`
-- ----------------------------
DROP TABLE IF EXISTS `services_tempprofileimage`;
CREATE TABLE `services_tempprofileimage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(64) DEFAULT NULL,
  `created_date` datetime(6) DEFAULT NULL,
  `updated_date` datetime(6) DEFAULT NULL,
  `image` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uuid` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Table structure for `services_userrole`
-- ----------------------------
DROP TABLE IF EXISTS `services_userrole`;
CREATE TABLE `services_userrole` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role` varchar(64) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `board_id` int(11) DEFAULT NULL,
  `created_date` datetime(6) NOT NULL,
  `deleted` tinyint(1) NOT NULL,
  `device_date` datetime(6) NOT NULL,
  `updated_date` datetime(6) NOT NULL,
  `uuid` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uuid` (`uuid`),
  KEY `services_userrole_0047b239` (`board_id`),
  KEY `services_userrole_user_id_7ebd3b7e13354018_fk_auth_user_id` (`user_id`),
  CONSTRAINT `services_userrole_board_id_2fbee0a5156ac5dc_fk_services_board_id` FOREIGN KEY (`board_id`) REFERENCES `services_board` (`id`),
  CONSTRAINT `services_userrole_user_id_7ebd3b7e13354018_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Table structure for `social_auth_association`
-- ----------------------------
DROP TABLE IF EXISTS `social_auth_association`;
CREATE TABLE `social_auth_association` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `server_url` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `secret` varchar(255) NOT NULL,
  `issued` int(11) NOT NULL,
  `lifetime` int(11) NOT NULL,
  `assoc_type` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Table structure for `social_auth_code`
-- ----------------------------
DROP TABLE IF EXISTS `social_auth_code`;
CREATE TABLE `social_auth_code` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(254) NOT NULL,
  `code` varchar(32) NOT NULL,
  `verified` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `social_auth_code_email_75f27066d057e3b6_uniq` (`email`,`code`),
  KEY `social_auth_code_c1336794` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Table structure for `social_auth_nonce`
-- ----------------------------
DROP TABLE IF EXISTS `social_auth_nonce`;
CREATE TABLE `social_auth_nonce` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `server_url` varchar(255) NOT NULL,
  `timestamp` int(11) NOT NULL,
  `salt` varchar(65) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `social_auth_nonce_server_url_36601f978463b4_uniq` (`server_url`,`timestamp`,`salt`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
--  Table structure for `social_auth_usersocialauth`
-- ----------------------------
DROP TABLE IF EXISTS `social_auth_usersocialauth`;
CREATE TABLE `social_auth_usersocialauth` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `provider` varchar(32) NOT NULL,
  `uid` varchar(255) NOT NULL,
  `extra_data` longtext NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `social_auth_usersocialauth_provider_2f763109e2c4a1fb_uniq` (`provider`,`uid`),
  KEY `social_auth_usersociala_user_id_193b2d80880502b2_fk_auth_user_id` (`user_id`),
  CONSTRAINT `social_auth_usersociala_user_id_193b2d80880502b2_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

SET FOREIGN_KEY_CHECKS = 1;
