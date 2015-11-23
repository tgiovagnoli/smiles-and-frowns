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

 Date: 11/23/2015 12:33:54 PM
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
  `username` varchar(64) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- ----------------------------
--  Records of `auth_user`
-- ----------------------------
BEGIN;
INSERT INTO `auth_user` VALUES ('1', 'pbkdf2_sha256$20000$RPv6RPXnvBgi$sfqqAtAHR8e2kAHivudXUnxAZC25Voj2fC6QBvrrIRM=', '2015-11-23 18:23:24.852590', '1', 'admin', '', '', 'info@apptitude-digital.com', '1', '1', '2015-11-23 18:23:01.541822'), ('2', 'pbkdf2_sha256$20000$y1jVX787ubFo$n9QUX3N/nbK4lIgqMb/KlSUDLCGE87k9+OJk5I8rk70=', '2015-11-23 18:46:11.061828', '0', '9c62dea4-552c-41c9-9185-f52431312ab6', 'Aaron', 'Smith', 'gngrwzrd@gmail.com', '0', '1', '2015-11-23 18:46:10.865953');
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
) ENGINE=InnoDB AUTO_INCREMENT=285 DEFAULT CHARSET=latin1;

-- ----------------------------
--  Records of `django_admin_log`
-- ----------------------------
BEGIN;
INSERT INTO `django_admin_log` VALUES ('1', '2015-11-23 20:21:29.014671', '17', 'Custom', '3', '', '22', '1'), ('2', '2015-11-23 20:29:53.340897', '277', '', '3', '', '20', '1'), ('3', '2015-11-23 20:29:53.343081', '276', '', '3', '', '20', '1'), ('4', '2015-11-23 20:29:53.343683', '275', '', '3', '', '20', '1'), ('5', '2015-11-23 20:29:53.344286', '274', '', '3', '', '20', '1'), ('6', '2015-11-23 20:29:53.345078', '273', '', '3', '', '20', '1'), ('7', '2015-11-23 20:29:53.345871', '272', '', '3', '', '20', '1'), ('8', '2015-11-23 20:29:53.346657', '271', '', '3', '', '20', '1'), ('9', '2015-11-23 20:29:53.347441', '270', '', '3', '', '20', '1'), ('10', '2015-11-23 20:29:53.348484', '269', '', '3', '', '20', '1'), ('11', '2015-11-23 20:29:53.349124', '268', '', '3', '', '20', '1'), ('12', '2015-11-23 20:29:53.349714', '267', '', '3', '', '20', '1'), ('13', '2015-11-23 20:29:53.350298', '266', '', '3', '', '20', '1'), ('14', '2015-11-23 20:29:53.350879', '265', '', '3', '', '20', '1'), ('15', '2015-11-23 20:29:53.351445', '264', '', '3', '', '20', '1'), ('16', '2015-11-23 20:29:53.352032', '263', '', '3', '', '20', '1'), ('17', '2015-11-23 20:29:53.352718', '262', '', '3', '', '20', '1'), ('18', '2015-11-23 20:29:53.353316', '261', '', '3', '', '20', '1'), ('19', '2015-11-23 20:29:53.353883', '260', '', '3', '', '20', '1'), ('20', '2015-11-23 20:29:53.354462', '259', '', '3', '', '20', '1'), ('21', '2015-11-23 20:29:53.355040', '258', '', '3', '', '20', '1'), ('22', '2015-11-23 20:29:53.355616', '257', '', '3', '', '20', '1'), ('23', '2015-11-23 20:29:53.356190', '256', '', '3', '', '20', '1'), ('24', '2015-11-23 20:29:53.356773', '255', '', '3', '', '20', '1'), ('25', '2015-11-23 20:29:53.357334', '254', 'Completing team responsibilities', '3', '', '20', '1'), ('26', '2015-11-23 20:29:53.357884', '253', 'Using time wisely', '3', '', '20', '1'), ('27', '2015-11-23 20:29:53.358436', '252', 'Showing focus and effort', '3', '', '20', '1'), ('28', '2015-11-23 20:29:53.359000', '251', 'Being persistent', '3', '', '20', '1'), ('29', '2015-11-23 20:29:53.359554', '250', 'Being self-directed', '3', '', '20', '1'), ('30', '2015-11-23 20:29:53.360112', '249', 'Using study planner', '3', '', '20', '1'), ('31', '2015-11-23 20:29:53.360671', '248', 'Keeping binder organzied', '3', '', '20', '1'), ('32', '2015-11-23 20:29:53.361568', '247', 'Doing assigned classroom jobs', '3', '', '20', '1'), ('33', '2015-11-23 20:29:53.362190', '246', 'Getting parents signatures', '3', '', '20', '1'), ('34', '2015-11-23 20:29:53.362765', '245', 'Bringing take-home folder', '3', '', '20', '1'), ('35', '2015-11-23 20:29:53.363330', '244', 'Putting name on assignments', '3', '', '20', '1'), ('36', '2015-11-23 20:29:53.363899', '243', 'Turning in daily assignments', '3', '', '20', '1'), ('37', '2015-11-23 20:29:53.364462', '242', 'Completing check-ins without reminders', '3', '', '20', '1'), ('38', '2015-11-23 20:29:53.365029', '241', 'Obeying cafeteria rules and routines', '3', '', '20', '1'), ('39', '2015-11-23 20:29:53.365595', '240', 'Following restroom rules', '3', '', '20', '1'), ('40', '2015-11-23 20:29:53.366142', '239', 'Playing by recess rules', '3', '', '20', '1'), ('41', '2015-11-23 20:29:53.366717', '238', 'Walking quietly in hallways', '3', '', '20', '1'), ('42', '2015-11-23 20:29:53.367406', '237', 'Respecting classroom rules', '3', '', '20', '1'), ('43', '2015-11-23 20:29:53.368058', '236', 'Being respectful to adults', '3', '', '20', '1'), ('44', '2015-11-23 20:29:53.368667', '235', 'Taking responsiblity for actions', '3', '', '20', '1'), ('45', '2015-11-23 20:29:53.369257', '234', 'Following directions the first time', '3', '', '20', '1'), ('46', '2015-11-23 20:29:53.369824', '233', 'Using good manners', '3', '', '20', '1'), ('47', '2015-11-23 20:29:53.370437', '232', 'Using signals and cues', '3', '', '20', '1'), ('48', '2015-11-23 20:29:53.371040', '231', 'Using conversatin skills', '3', '', '20', '1'), ('49', '2015-11-23 20:29:53.371634', '230', 'Being kind and helpful', '3', '', '20', '1'), ('50', '2015-11-23 20:29:53.372510', '229', 'Being honest', '3', '', '20', '1'), ('51', '2015-11-23 20:29:53.373090', '228', '', '3', '', '20', '1'), ('52', '2015-11-23 20:29:53.373663', '227', '', '3', '', '20', '1'), ('53', '2015-11-23 20:29:53.374268', '226', '', '3', '', '20', '1'), ('54', '2015-11-23 20:29:53.374883', '225', '', '3', '', '20', '1'), ('55', '2015-11-23 20:29:53.375445', '224', '', '3', '', '20', '1'), ('56', '2015-11-23 20:29:53.376010', '223', '', '3', '', '20', '1'), ('57', '2015-11-23 20:29:53.376572', '222', '', '3', '', '20', '1'), ('58', '2015-11-23 20:29:53.377375', '221', '', '3', '', '20', '1'), ('59', '2015-11-23 20:29:53.377947', '220', '', '3', '', '20', '1'), ('60', '2015-11-23 20:29:53.378518', '219', '', '3', '', '20', '1'), ('61', '2015-11-23 20:29:53.379090', '218', '', '3', '', '20', '1'), ('62', '2015-11-23 20:29:53.379659', '217', '', '3', '', '20', '1'), ('63', '2015-11-23 20:29:53.380217', '216', '', '3', '', '20', '1'), ('64', '2015-11-23 20:29:53.380849', '215', '', '3', '', '20', '1'), ('65', '2015-11-23 20:29:53.381585', '214', '', '3', '', '20', '1'), ('66', '2015-11-23 20:29:53.382173', '213', '', '3', '', '20', '1'), ('67', '2015-11-23 20:29:53.382728', '212', '', '3', '', '20', '1'), ('68', '2015-11-23 20:29:53.383290', '211', '', '3', '', '20', '1'), ('69', '2015-11-23 20:29:53.383923', '210', 'Planning ahead for big projects', '3', '', '20', '1'), ('70', '2015-11-23 20:29:53.384623', '209', 'Prioritizing work', '3', '', '20', '1'), ('71', '2015-11-23 20:29:53.385523', '208', 'Breaking down big assignments', '3', '', '20', '1'), ('72', '2015-11-23 20:29:53.386156', '207', 'Estimating time for each step', '3', '', '20', '1'), ('73', '2015-11-23 20:29:53.386768', '206', 'Creating to do lists', '3', '', '20', '1'), ('74', '2015-11-23 20:29:53.387374', '205', 'Knowing deadlines', '3', '', '20', '1'), ('75', '2015-11-23 20:29:53.387993', '204', 'Figuring our what works', '3', '', '20', '1'), ('76', '2015-11-23 20:29:53.388597', '203', 'Having good body posture', '3', '', '20', '1'), ('77', '2015-11-23 20:29:53.389226', '202', 'Eliminating disctractions', '3', '', '20', '1'), ('78', '2015-11-23 20:29:53.389810', '201', 'Completing homework', '3', '', '20', '1'), ('79', '2015-11-23 20:29:53.390416', '200', 'Sticking to a routine', '3', '', '20', '1'), ('80', '2015-11-23 20:29:53.391203', '199', 'Creating flash cards', '3', '', '20', '1'), ('81', '2015-11-23 20:29:53.391831', '198', 'Ready all material', '3', '', '20', '1'), ('82', '2015-11-23 20:29:53.392423', '197', 'Having resources ready', '3', '', '20', '1'), ('83', '2015-11-23 20:29:53.393013', '196', 'Asking for help', '3', '', '20', '1'), ('84', '2015-11-23 20:29:53.393604', '195', 'Knowing expectations', '3', '', '20', '1'), ('85', '2015-11-23 20:29:53.394180', '194', 'Preparing work space', '3', '', '20', '1'), ('86', '2015-11-23 20:29:53.394756', '193', 'Having materials for assignments', '3', '', '20', '1'), ('87', '2015-11-23 20:29:53.395349', '192', 'Using study planner', '3', '', '20', '1'), ('88', '2015-11-23 20:29:53.395928', '191', 'Having notes ready', '3', '', '20', '1'), ('89', '2015-11-23 20:29:53.396521', '190', 'Keeping binder organized', '3', '', '20', '1'), ('90', '2015-11-23 20:29:53.397261', '189', 'Having needed school supplies', '3', '', '20', '1'), ('91', '2015-11-23 20:29:53.397816', '188', '', '3', '', '20', '1'), ('92', '2015-11-23 20:29:53.398362', '187', '', '3', '', '20', '1'), ('93', '2015-11-23 20:29:53.398918', '186', '', '3', '', '20', '1'), ('94', '2015-11-23 20:29:53.399464', '185', '', '3', '', '20', '1'), ('95', '2015-11-23 20:29:53.400022', '184', '', '3', '', '20', '1'), ('96', '2015-11-23 20:29:53.400646', '183', '', '3', '', '20', '1'), ('97', '2015-11-23 20:29:53.401360', '182', '', '3', '', '20', '1'), ('98', '2015-11-23 20:29:53.402005', '181', '', '3', '', '20', '1'), ('99', '2015-11-23 20:29:53.402606', '180', '', '3', '', '20', '1'), ('100', '2015-11-23 20:29:53.403186', '179', '', '3', '', '20', '1'), ('101', '2015-11-23 20:29:53.403804', '178', '', '3', '', '20', '1'), ('102', '2015-11-23 20:29:57.923657', '177', '', '3', '', '20', '1'), ('103', '2015-11-23 20:29:57.925680', '176', '', '3', '', '20', '1'), ('104', '2015-11-23 20:29:57.926644', '175', '', '3', '', '20', '1'), ('105', '2015-11-23 20:29:57.927256', '174', '', '3', '', '20', '1'), ('106', '2015-11-23 20:29:57.927844', '173', '', '3', '', '20', '1'), ('107', '2015-11-23 20:29:57.928428', '172', '', '3', '', '20', '1'), ('108', '2015-11-23 20:29:57.929013', '171', '', '3', '', '20', '1'), ('109', '2015-11-23 20:29:57.929664', '170', '', '3', '', '20', '1'), ('110', '2015-11-23 20:29:57.930399', '169', 'Keeping things organized', '3', '', '20', '1'), ('111', '2015-11-23 20:29:57.931022', '168', 'Keeping a routine', '3', '', '20', '1'), ('112', '2015-11-23 20:29:57.931610', '167', 'Taking baths', '3', '', '20', '1'), ('113', '2015-11-23 20:29:57.932193', '166', 'Going to bed on time', '3', '', '20', '1'), ('114', '2015-11-23 20:29:57.932775', '165', 'Brushing teeth', '3', '', '20', '1'), ('115', '2015-11-23 20:29:57.933432', '164', 'Using proper table manners', '3', '', '20', '1'), ('116', '2015-11-23 20:29:57.935838', '163', 'Respecting adults', '3', '', '20', '1'), ('117', '2015-11-23 20:29:57.936441', '162', 'Thanking our hosts', '3', '', '20', '1'), ('118', '2015-11-23 20:29:57.937023', '161', 'Using polite language', '3', '', '20', '1'), ('119', '2015-11-23 20:29:57.937604', '160', 'Holding doors for people', '3', '', '20', '1'), ('120', '2015-11-23 20:29:57.938509', '159', 'Greeting people nicely', '3', '', '20', '1'), ('121', '2015-11-23 20:29:57.939093', '158', 'Eating properly', '3', '', '20', '1'), ('122', '2015-11-23 20:29:57.939658', '157', 'Cooperating', '3', '', '20', '1'), ('123', '2015-11-23 20:29:57.940225', '156', 'Following instructions', '3', '', '20', '1'), ('124', '2015-11-23 20:29:57.940983', '155', 'Being ready to go', '3', '', '20', '1'), ('125', '2015-11-23 20:29:57.941705', '154', 'Using social voices', '3', '', '20', '1'), ('126', '2015-11-23 20:29:57.942481', '153', 'Not running', '3', '', '20', '1'), ('127', '2015-11-23 20:29:57.943139', '152', 'Listening to others', '3', '', '20', '1'), ('128', '2015-11-23 20:29:57.943846', '151', 'Staying calm and close by', '3', '', '20', '1'), ('129', '2015-11-23 20:29:57.944571', '150', 'Being open to new things', '3', '', '20', '1'), ('130', '2015-11-23 20:29:57.945344', '149', 'Respecting different rules', '3', '', '20', '1'), ('131', '2015-11-23 20:29:57.946063', '148', 'Behaving in public', '3', '', '20', '1'), ('132', '2015-11-23 20:29:57.946805', '147', 'Behaving while traveling', '3', '', '20', '1'), ('133', '2015-11-23 20:29:57.947505', '146', '', '3', '', '20', '1'), ('134', '2015-11-23 20:29:57.948171', '145', '', '3', '', '20', '1'), ('135', '2015-11-23 20:29:57.948844', '144', '', '3', '', '20', '1'), ('136', '2015-11-23 20:29:57.949464', '143', '', '3', '', '20', '1'), ('137', '2015-11-23 20:29:57.950069', '142', '', '3', '', '20', '1'), ('138', '2015-11-23 20:29:57.950715', '141', '', '3', '', '20', '1'), ('139', '2015-11-23 20:29:57.951774', '140', '', '3', '', '20', '1'), ('140', '2015-11-23 20:29:57.952517', '139', '', '3', '', '20', '1'), ('141', '2015-11-23 20:29:57.953177', '138', '', '3', '', '20', '1'), ('142', '2015-11-23 20:29:57.953938', '137', '', '3', '', '20', '1'), ('143', '2015-11-23 20:29:57.954639', '136', '', '3', '', '20', '1'), ('144', '2015-11-23 20:29:57.955416', '135', '', '3', '', '20', '1'), ('145', '2015-11-23 20:29:57.956127', '134', '', '3', '', '20', '1'), ('146', '2015-11-23 20:29:57.956782', '133', '', '3', '', '20', '1'), ('147', '2015-11-23 20:29:57.957480', '132', '', '3', '', '20', '1'), ('148', '2015-11-23 20:29:57.958193', '131', '', '3', '', '20', '1'), ('149', '2015-11-23 20:29:57.958854', '130', '', '3', '', '20', '1'), ('150', '2015-11-23 20:29:57.959602', '129', '', '3', '', '20', '1'), ('151', '2015-11-23 20:29:57.960375', '128', '', '3', '', '20', '1'), ('152', '2015-11-23 20:29:57.961050', '127', '', '3', '', '20', '1'), ('153', '2015-11-23 20:29:57.961714', '126', '', '3', '', '20', '1'), ('154', '2015-11-23 20:29:57.962512', '125', '', '3', '', '20', '1'), ('155', '2015-11-23 20:29:57.963265', '124', 'Asking instead of reaching', '3', '', '20', '1'), ('156', '2015-11-23 20:29:57.964031', '123', 'Eathing everything on plate', '3', '', '20', '1'), ('157', '2015-11-23 20:29:57.964837', '122', 'Using napkin', '3', '', '20', '1'), ('158', '2015-11-23 20:29:57.965527', '121', 'Chewing with mouth closed', '3', '', '20', '1'), ('159', '2015-11-23 20:29:57.966303', '120', 'Using utensils properly', '3', '', '20', '1'), ('160', '2015-11-23 20:29:57.967074', '119', 'Sitting properly at table', '3', '', '20', '1'), ('161', '2015-11-23 20:29:57.967893', '118', 'Covering mouth when coughing', '3', '', '20', '1'), ('162', '2015-11-23 20:29:57.968624', '117', 'Not leaving a mess for others', '3', '', '20', '1'), ('163', '2015-11-23 20:29:57.969399', '116', 'Giving compliments', '3', '', '20', '1'), ('164', '2015-11-23 20:29:57.970158', '115', 'Showing appreciation', '3', '', '20', '1'), ('165', '2015-11-23 20:29:57.970929', '114', 'Letting others go first', '3', '', '20', '1'), ('166', '2015-11-23 20:29:57.971672', '113', 'Respecting the space of others', '3', '', '20', '1'), ('167', '2015-11-23 20:29:57.972315', '112', 'Thinking about how others feel', '3', '', '20', '1'), ('168', '2015-11-23 20:29:57.972985', '111', 'Greeting someone nicely', '3', '', '20', '1'), ('169', '2015-11-23 20:29:57.973644', '110', 'Wishing \"Good morniing or night\"', '3', '', '20', '1'), ('170', '2015-11-23 20:29:57.974272', '109', 'Asking \"How are you?\"', '3', '', '20', '1'), ('171', '2015-11-23 20:29:57.974931', '108', 'Saying \"Excuse Me!\"', '3', '', '20', '1'), ('172', '2015-11-23 20:29:57.975583', '107', 'Saying \"You\'re Welcome!\"', '3', '', '20', '1'), ('173', '2015-11-23 20:29:57.976191', '106', 'Saying \"Thank You!\"', '3', '', '20', '1'), ('174', '2015-11-23 20:29:57.976782', '105', 'Saying \"Please!\"', '3', '', '20', '1'), ('175', '2015-11-23 20:29:57.977366', '104', 'Showing good sportsmanship', '3', '', '20', '1'), ('176', '2015-11-23 20:29:57.977945', '103', 'Behaving in public', '3', '', '20', '1'), ('177', '2015-11-23 20:29:57.978560', '102', 'Practicing eye contact', '3', '', '20', '1'), ('178', '2015-11-23 20:29:57.979150', '101', 'Offering to help', '3', '', '20', '1'), ('179', '2015-11-23 20:29:57.980071', '100', 'Sharing or taking turns', '3', '', '20', '1'), ('180', '2015-11-23 20:29:57.980729', '99', 'Asking for permission', '3', '', '20', '1'), ('181', '2015-11-23 20:29:57.981382', '98', 'Using inside voice', '3', '', '20', '1'), ('182', '2015-11-23 20:29:57.982008', '97', '', '3', '', '20', '1'), ('183', '2015-11-23 20:29:57.982602', '96', '', '3', '', '20', '1'), ('184', '2015-11-23 20:29:57.983198', '95', '', '3', '', '20', '1'), ('185', '2015-11-23 20:29:57.983785', '94', '', '3', '', '20', '1'), ('186', '2015-11-23 20:29:57.984372', '93', '', '3', '', '20', '1'), ('187', '2015-11-23 20:29:57.984960', '92', '', '3', '', '20', '1'), ('188', '2015-11-23 20:29:57.985534', '91', '', '3', '', '20', '1'), ('189', '2015-11-23 20:29:57.986093', '90', '', '3', '', '20', '1'), ('190', '2015-11-23 20:29:57.986732', '89', '', '3', '', '20', '1'), ('191', '2015-11-23 20:29:57.987337', '88', '', '3', '', '20', '1'), ('192', '2015-11-23 20:29:57.987907', '87', '', '3', '', '20', '1'), ('193', '2015-11-23 20:29:57.988469', '86', '', '3', '', '20', '1'), ('194', '2015-11-23 20:29:57.989034', '85', '', '3', '', '20', '1'), ('195', '2015-11-23 20:29:57.989592', '84', '', '3', '', '20', '1'), ('196', '2015-11-23 20:29:57.990135', '83', '', '3', '', '20', '1'), ('197', '2015-11-23 20:29:57.990694', '82', '', '3', '', '20', '1'), ('198', '2015-11-23 20:29:57.991483', '81', '', '3', '', '20', '1'), ('199', '2015-11-23 20:29:57.992111', '80', '', '3', '', '20', '1'), ('200', '2015-11-23 20:29:57.992713', '79', '', '3', '', '20', '1'), ('201', '2015-11-23 20:29:57.993425', '78', 'Washing pet', '3', '', '20', '1'), ('202', '2015-11-23 20:30:02.442761', '77', 'Walking pet', '3', '', '20', '1'), ('203', '2015-11-23 20:30:02.444732', '76', 'Clipping nails', '3', '', '20', '1'), ('204', '2015-11-23 20:30:02.445637', '75', 'Grooming pet', '3', '', '20', '1'), ('205', '2015-11-23 20:30:02.446456', '74', 'Cleaning litter box or droppings', '3', '', '20', '1'), ('206', '2015-11-23 20:30:02.447265', '73', 'Giving water to pet', '3', '', '20', '1'), ('207', '2015-11-23 20:30:02.448055', '72', 'Feeding pet', '3', '', '20', '1'), ('208', '2015-11-23 20:30:02.448855', '71', 'Putting away dishes', '3', '', '20', '1'), ('209', '2015-11-23 20:30:02.449651', '70', 'Washing/Drying dishes', '3', '', '20', '1'), ('210', '2015-11-23 20:30:02.450440', '69', 'Clearing the table', '3', '', '20', '1'), ('211', '2015-11-23 20:30:02.451228', '68', 'Setting the table', '3', '', '20', '1'), ('212', '2015-11-23 20:30:02.452012', '67', 'Making dinner', '3', '', '20', '1'), ('213', '2015-11-23 20:30:02.452796', '66', 'Making lunch', '3', '', '20', '1'), ('214', '2015-11-23 20:30:02.453604', '65', 'Making breakfast', '3', '', '20', '1'), ('215', '2015-11-23 20:30:02.454378', '64', 'Shoveling snow', '3', '', '20', '1'), ('216', '2015-11-23 20:30:02.455152', '63', 'Watering plants', '3', '', '20', '1'), ('217', '2015-11-23 20:30:02.455935', '62', 'Sweeping up', '3', '', '20', '1'), ('218', '2015-11-23 20:30:02.456708', '61', 'Cleaning up yard', '3', '', '20', '1'), ('219', '2015-11-23 20:30:02.457547', '60', 'Raking leaves', '3', '', '20', '1'), ('220', '2015-11-23 20:30:02.458385', '59', 'Mowing lawn', '3', '', '20', '1'), ('221', '2015-11-23 20:30:02.459465', '58', 'Taking out trash', '3', '', '20', '1'), ('222', '2015-11-23 20:30:02.460120', '57', 'Vacuuming', '3', '', '20', '1'), ('223', '2015-11-23 20:30:02.460745', '56', 'Putting away clothes', '3', '', '20', '1'), ('224', '2015-11-23 20:30:02.461338', '55', 'Doing laundry', '3', '', '20', '1'), ('225', '2015-11-23 20:30:02.461925', '54', 'Cleaning up a room', '3', '', '20', '1'), ('226', '2015-11-23 20:30:02.462507', '53', 'Making bed', '3', '', '20', '1'), ('227', '2015-11-23 20:30:02.463094', '52', '', '3', '', '20', '1'), ('228', '2015-11-23 20:30:02.463824', '51', '', '3', '', '20', '1'), ('229', '2015-11-23 20:30:02.464427', '50', '', '3', '', '20', '1'), ('230', '2015-11-23 20:30:02.465002', '49', '', '3', '', '20', '1'), ('231', '2015-11-23 20:30:02.465571', '48', '', '3', '', '20', '1'), ('232', '2015-11-23 20:30:02.466136', '47', '', '3', '', '20', '1'), ('233', '2015-11-23 20:30:02.466690', '46', '', '3', '', '20', '1'), ('234', '2015-11-23 20:30:02.467254', '45', '', '3', '', '20', '1'), ('235', '2015-11-23 20:30:02.467803', '44', '', '3', '', '20', '1'), ('236', '2015-11-23 20:30:02.468368', '43', '', '3', '', '20', '1'), ('237', '2015-11-23 20:30:02.468928', '42', '', '3', '', '20', '1'), ('238', '2015-11-23 20:30:02.469466', '41', '', '3', '', '20', '1'), ('239', '2015-11-23 20:30:02.470026', '40', '', '3', '', '20', '1'), ('240', '2015-11-23 20:30:02.470586', '39', '', '3', '', '20', '1'), ('241', '2015-11-23 20:30:02.471146', '38', '', '3', '', '20', '1'), ('242', '2015-11-23 20:30:02.472042', '37', '', '3', '', '20', '1'), ('243', '2015-11-23 20:30:02.472600', '36', '', '3', '', '20', '1'), ('244', '2015-11-23 20:30:02.473158', '35', '', '3', '', '20', '1'), ('245', '2015-11-23 20:30:02.473762', '34', '', '3', '', '20', '1'), ('246', '2015-11-23 20:30:02.474321', '33', '', '3', '', '20', '1'), ('247', '2015-11-23 20:30:02.474880', '32', '', '3', '', '20', '1'), ('248', '2015-11-23 20:30:02.475436', '31', '', '3', '', '20', '1'), ('249', '2015-11-23 20:30:02.475994', '30', '', '3', '', '20', '1'), ('250', '2015-11-23 20:30:02.476540', '29', 'Conserving resources', '3', '', '20', '1'), ('251', '2015-11-23 20:30:02.477086', '28', 'Washing up or bathing', '3', '', '20', '1'), ('252', '2015-11-23 20:30:02.477651', '27', 'Combing hair', '3', '', '20', '1'), ('253', '2015-11-23 20:30:02.478403', '26', 'Brushing teeth', '3', '', '20', '1'), ('254', '2015-11-23 20:30:02.479017', '25', 'Picking up or putting away', '3', '', '20', '1'), ('255', '2015-11-23 20:30:02.479606', '24', 'Making bed', '3', '', '20', '1'), ('256', '2015-11-23 20:30:02.480187', '23', 'Clearing table', '3', '', '20', '1'), ('257', '2015-11-23 20:30:02.480766', '22', 'Doing chores', '3', '', '20', '1'), ('258', '2015-11-23 20:30:02.481339', '21', 'Doing homework', '3', '', '20', '1'), ('259', '2015-11-23 20:30:02.481911', '20', 'Using good table manners', '3', '', '20', '1'), ('260', '2015-11-23 20:30:02.482469', '19', 'Behaving in public', '3', '', '20', '1'), ('261', '2015-11-23 20:30:02.483045', '18', 'Greeting someone nicely', '3', '', '20', '1'), ('262', '2015-11-23 20:30:02.483906', '17', 'Using polite language', '3', '', '20', '1'), ('263', '2015-11-23 20:30:02.484468', '16', 'Saying \"Please\" or \"Thank You!\"', '3', '', '20', '1'), ('264', '2015-11-23 20:30:02.485524', '15', 'Eating well', '3', '', '20', '1'), ('265', '2015-11-23 20:30:02.486071', '14', 'Encouraging others', '3', '', '20', '1'), ('266', '2015-11-23 20:30:02.486628', '13', 'Using juicy words', '3', '', '20', '1'), ('267', '2015-11-23 20:30:02.487189', '12', 'Being persistent', '3', '', '20', '1'), ('268', '2015-11-23 20:30:02.487745', '11', 'Trying something new', '3', '', '20', '1'), ('269', '2015-11-23 20:30:02.488299', '10', 'Ready to go', '3', '', '20', '1'), ('270', '2015-11-23 20:30:02.488857', '9', 'Self-starting', '3', '', '20', '1'), ('271', '2015-11-23 20:30:02.489416', '8', 'Making good choices', '3', '', '20', '1'), ('272', '2015-11-23 20:30:02.489969', '7', 'Being brave', '3', '', '20', '1'), ('273', '2015-11-23 20:30:02.490526', '6', 'Using indoor voice', '3', '', '20', '1'), ('274', '2015-11-23 20:30:02.491343', '5', 'Cooperating', '3', '', '20', '1'), ('275', '2015-11-23 20:30:02.491886', '4', 'Sharing', '3', '', '20', '1'), ('276', '2015-11-23 20:30:02.492444', '3', 'Following directions ', '3', '', '20', '1'), ('277', '2015-11-23 20:30:02.492999', '2', 'First-time listening', '3', '', '20', '1'), ('278', '2015-11-23 20:30:02.493792', '1', 'Being helpful', '3', '', '20', '1'), ('279', '2015-11-23 20:30:10.394988', '6', 'Teacher\'s Helper', '3', '', '21', '1'), ('280', '2015-11-23 20:30:10.397210', '5', 'Study Time', '3', '', '21', '1'), ('281', '2015-11-23 20:30:10.397833', '4', 'On the Road', '3', '', '21', '1'), ('282', '2015-11-23 20:30:10.398415', '3', 'Manners, Please', '3', '', '21', '1'), ('283', '2015-11-23 20:30:10.398988', '2', 'Chores & More', '3', '', '21', '1'), ('284', '2015-11-23 20:30:10.399559', '1', 'Around the House', '3', '', '21', '1');
COMMIT;

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
INSERT INTO `django_session` VALUES ('59a2rn87jfr7i8nik0y862d34tocmslq', 'YTk3NDBlNWRjYTIwODY1ODI0YzRjZjZiMzcwN2NhNmY1YjVhNTMxMzp7Il9hdXRoX3VzZXJfaGFzaCI6IjY5ZWE0NDA3NTc2YmFkMTFmMTBlOGUyZTEwMWQ4MDc1Yjg1MDEwMDEiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOiIyIn0=', '2016-11-23 00:35:23.064209'), ('nvvgoddsia47jskbwzwtbriutfuo99kx', 'N2JhNmQxNWFlOTNmNTJkNjRiZDE3NjEyYTg4ZTg3ZmJiM2FlNGY0ODp7Il9hdXRoX3VzZXJfaGFzaCI6ImY3MmRjNzQ3NWEyNWJiMTNiYjc0ZTU3NjI4ZmM5MDI4YTkyOWRmYjUiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOiIxIn0=', '2016-11-23 00:12:36.854080');
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
) ENGINE=InnoDB AUTO_INCREMENT=555 DEFAULT CHARSET=latin1;

-- ----------------------------
--  Records of `predefinedboards_predefinedbehavior`
-- ----------------------------
BEGIN;
INSERT INTO `predefinedboards_predefinedbehavior` VALUES ('278', 'Being helpful', '1588537a-0b09-4462-aa84-4248c9cbc3f3', '1'), ('279', 'First-time listening', '8897efda-eaff-4548-a8b2-7cf49b14f770', '1'), ('280', 'Following directions ', '88a258ae-9b4e-4d85-9026-3247ce9e0493', '1'), ('281', 'Sharing', 'b313bd01-97d3-4cfa-aeb1-054fb7e6ad58', '1'), ('282', 'Cooperating', 'f3e5d899-f877-4a4b-9c8f-7eb653157b54', '1'), ('283', 'Using indoor voice', '56c857f9-5b95-4517-9763-76bb35e9f672', '1'), ('284', 'Being brave', 'd37d01d0-2743-4693-8cb1-84595d813c09', '1'), ('285', 'Making good choices', 'f8533863-8eed-40fa-bc7a-58b4cb4a651e', '1'), ('286', 'Self-starting', 'ba3010d9-8a45-45af-8c6c-ae39f3bb262c', '1'), ('287', 'Ready to go', 'a65ab840-1fd0-4093-b2b1-ebaa0cd0b7d3', '1'), ('288', 'Trying something new', 'ca39c344-eb77-4923-98f0-8cb3c5b77b4a', '1'), ('289', 'Being persistent', 'fb3ba83d-48b5-45ad-b2dc-f2b9efe2902e', '1'), ('290', 'Using juicy words', '5c34b16a-8a9d-49eb-abc0-355a405d89f2', '1'), ('291', 'Encouraging others', 'c119978a-dcd9-4ce5-9afb-7b241ee098fc', '1'), ('292', 'Eating well', 'd51c03cb-2b77-40a2-bc12-71cab6683329', '1'), ('293', 'Saying \"Please\" or \"Thank You!\"', '2e3bacd7-e2e8-4661-9101-1b0e9c0b111a', '1'), ('294', 'Using polite language', 'f10d64eb-ad73-4d39-8e48-b050bd4b98ac', '1'), ('295', 'Greeting someone nicely', '74b01264-f27d-491b-8370-dcda9149e559', '1'), ('296', 'Behaving in public', '3241d645-6867-4423-9643-25e6b8da6872', '1'), ('297', 'Using good table manners', 'e36b79f0-3f95-4b1e-a0d5-f311df909609', '1'), ('298', 'Doing homework', '9cc85494-d168-4e80-b90d-0b788393e30b', '1'), ('299', 'Doing chores', 'f10678f8-c663-4209-9fe7-557a644dcf91', '1'), ('300', 'Clearing table', 'e9e72a67-2e9d-4ef6-bef2-baf2fc67e254', '1'), ('301', 'Making bed', 'fcc580a8-aad8-47c1-8e8e-12e8bbde0e4e', '1'), ('302', 'Picking up or putting away', '7ff41ac6-e2ac-458f-96a4-a0557cdeadcf', '1'), ('303', 'Brushing teeth', 'a4595ab4-e72b-41ee-a13e-281103e66357', '1'), ('304', 'Combing hair', 'ae5ac17b-fd72-4b9f-a7d9-9cb5906a8ea9', '1'), ('305', 'Washing up or bathing', '66cf2f97-0c42-4c13-a8dc-e1456c6ecdea', '1'), ('306', 'Conserving resources', 'f5936b75-8f00-420e-ba03-b813156e2ff5', '1'), ('307', 'Disobeying', '09d9b828-d146-437f-b5af-5a4f4dea5661', '0'), ('308', 'Throwing a fit', '8d7c2469-4549-4016-bf99-aaab9c62035e', '0'), ('309', 'Kicking or hitting', '9dfd34c5-e7ce-4dea-8a3d-1693605fd203', '0'), ('310', 'Hurting someone', 'bd2856d2-969e-40e0-b69f-2fcd3ee355d3', '0'), ('311', 'Yelling or screaming', 'c360fb27-ed65-46b9-b1ab-e866590acdfe', '0'), ('312', 'Not thinking it through', 'e796daeb-8983-4ef6-85d3-21be8607a9a7', '0'), ('313', 'Being dishonest', '36b4dcc7-88f7-4efb-bab5-77b216b97010', '0'), ('314', 'Being mean', '2103ea08-54c6-46c7-987c-9250adce37c4', '0'), ('315', 'Name calling', 'df306b6a-a338-4b1e-a2ed-86cc8ab36e89', '0'), ('316', 'Teasing', '5141d081-b742-4ce7-ab96-ca6499702ae2', '0'), ('317', 'Being disrespectful', 'fe7f1907-6747-4bc0-adbf-ecb0a30fb90b', '0'), ('318', 'Discouraging someone', 'cee01ebc-fb67-4164-9bfa-36fa6118e3d4', '0'), ('319', 'Refusing to eat properly', '24e050fe-0d14-4f56-95d9-ccfa120fd3df', '0'), ('320', 'Being rude', 'd8c6ca7d-d717-4300-97f4-55e14f95aa0b', '0'), ('321', 'Interrupting', 'cc144880-aa70-40b4-a0a5-49a0a3ad283b', '0'), ('322', 'Behaving poorly at the table', '3cf89a79-014b-4a6b-af39-3e3ad77eb485', '0'), ('323', 'Cursing', 'dd709e43-8a5d-44aa-ae36-0b07a0937559', '0'), ('324', 'Talking back', '64e9de9e-3e00-42e3-a52f-d67a898a442e', '0'), ('325', 'Not doing homework', '5bf407f9-6383-49ae-b45f-412800caf74e', '0'), ('326', 'Leaving a mess', 'b925a33a-7294-480a-8304-c87691bd4ddb', '0'), ('327', 'Not being ready on time', '329fcfab-dfcd-47b6-87c9-6b579326541b', '0'), ('328', 'Not washing or brushing teeth', 'cdd16fa3-4c27-4783-b290-e300111cefc4', '0'), ('329', 'Wasting resources', '025bdca6-5236-4c20-bb8b-ca5d11968637', '0'), ('330', 'Making bed', '25f7fa15-15bc-4b45-82b0-c152915dcf9e', '1'), ('331', 'Cleaning up a room', '4e46fef1-94e5-45a9-923d-da8605cd67d7', '1'), ('332', 'Doing laundry', '2147ddf8-3f61-4751-8547-bfea155a6c46', '1'), ('333', 'Putting away clothes', 'e6da9f79-988a-4aac-b13a-9b1ebeca2548', '1'), ('334', 'Vacuuming', '22f34d16-f471-4ac1-a75d-f8d3c4b60682', '1'), ('335', 'Taking out trash', '8645fdbe-0c23-4d99-93e4-e8b37f4cd13e', '1'), ('336', 'Mowing lawn', '60c763d7-a50a-4543-a3f6-fd5342386c8d', '1'), ('337', 'Raking leaves', '0c9eb553-fe21-4dbb-8585-6f59961b95cb', '1'), ('338', 'Cleaning up yard', 'c9a87107-0b39-4790-a32d-f42373d79c5d', '1'), ('339', 'Sweeping up', 'e0e212b3-6f0d-45f9-8632-36b8a9c85f61', '1'), ('340', 'Watering plants', '92c2c516-2584-4835-80ea-51a65c5c4986', '1'), ('341', 'Shoveling snow', 'f725873b-9a42-4178-a8b5-be0fccf229c8', '1'), ('342', 'Making breakfast', '6597618a-4ba6-4ec9-8ee2-fde622b88633', '1'), ('343', 'Making lunch', '66b835a9-e4aa-4fab-878d-c5211a5209a4', '1'), ('344', 'Making dinner', '813d156c-5db7-4a01-90a5-0f40186e13e8', '1'), ('345', 'Setting the table', '5ad38f7a-b53f-4270-a5b0-f42044607c49', '1'), ('346', 'Clearing the table', '12a5e6b6-b9e2-4199-bd84-9f17275b6c19', '1'), ('347', 'Washing/Drying dishes', 'f545d779-5f4c-4b83-a6e2-a0ad89142581', '1'), ('348', 'Putting away dishes', 'bf9c3e50-b14f-428c-810c-14e29f774439', '1'), ('349', 'Feeding pet', '1987a9d4-27b6-4af6-bcc8-6924a50feae8', '1'), ('350', 'Giving water to pet', '6fd53d10-6daa-4f8d-b3e5-7f5be4bf9d7f', '1'), ('351', 'Cleaning litter box or droppings', '05331b42-7c19-4bae-a4a0-cd324406a307', '1'), ('352', 'Grooming pet', '0eeb3cb7-4677-4db6-825c-394ff05b5008', '1'), ('353', 'Clipping nails', 'ddade519-b966-419a-8d89-7cf7d012a259', '1'), ('354', 'Walking pet', '597c17f7-7f8c-4e16-9db7-2ac90f1f6074', '1'), ('355', 'Washing pet', '4af6cc5e-76e7-4229-8406-d9e1fcba0914', '1'), ('356', 'Refusing to make bed', 'f0aaece9-e2b4-4e3a-9866-26ee9ac7c957', '0'), ('357', 'Letting room be a mess', '7f552a06-058c-4d01-b42d-ce32f7f55a18', '0'), ('358', 'Leaving laundry for others', '8d894548-befb-4c5a-8178-891a51763338', '0'), ('359', 'Throwing clothes on the floor', 'eb3a773a-bf28-4eb8-b70d-d8b996bc9787', '0'), ('360', 'Letting trash pile up', '8ead6a09-8dbf-4e53-93c0-b92fe8fcf312', '0'), ('361', 'Skipping yard chores', '4d412573-4939-403c-8a0f-568a100fec70', '0'), ('362', 'Leaving a mess outside', '92039f09-9697-4c18-a672-deb02a974073', '0'), ('363', 'Letting leaves pile up', 'd88fa4c7-fa00-4956-bf28-fb5df41846b4', '0'), ('364', 'Letting plants wilt', '0a7376ee-071b-4891-adc3-fd6b5244a2e6', '0'), ('365', 'Not helping with assigned meals', '3a8201dd-a56a-4b98-91ae-49335656e6a3', '0'), ('366', 'Refusing to help set table', '0d6f283f-aa0f-433d-8c44-9fe022799f11', '0'), ('367', 'Leaving plates on the table', '1730bb61-f9a6-4bff-91e9-b657a59c1836', '0'), ('368', 'Leaving dishes in the sink', 'a66c5d26-33d4-4edd-b4f0-f5d90ca7a63b', '0'), ('369', 'Leaving dishes in dishwasher', 'f773e162-eb17-4910-a86a-9542d733d190', '0'), ('370', 'Forgetting to feed pet', '06dcc190-647b-4dde-ae37-3dcd2d5133bc', '0'), ('371', 'Letting water get dirty or empty', '99cfa3b0-789c-463c-83e9-56eb425288a1', '0'), ('372', 'Ignoring dirty litter box or droppings', '560fe211-e47a-402a-a671-93f76dec4136', '0'), ('373', 'Letting pet get dirty or smelly', '4443270b-4337-425f-b23d-a81adca6ab05', '0'), ('374', 'Not playing with or exercising pet', '22a762df-af3f-49fc-a751-fb7bfff566d3', '0'), ('375', 'Using inside voice', '5a21f900-0273-4aa9-8725-530994d40ae9', '1'), ('376', 'Asking for permission', 'a0f14f60-752e-4ebc-a4ad-c40f11634f8c', '1'), ('377', 'Sharing or taking turns', 'eb522230-9170-4046-82f4-5e6b017c995f', '1'), ('378', 'Offering to help', '95cbaf41-7a50-4644-8dd9-56f3b07eb228', '1'), ('379', 'Practicing eye contact', '58d7162d-4f96-45ad-8aa0-87db8e38548f', '1'), ('380', 'Behaving in public', '32c03bb0-9bcf-429a-8235-44dfef9f5a37', '1'), ('381', 'Showing good sportsmanship', '45970f69-9165-4bc7-83f0-8b8c59b9aa22', '1'), ('382', 'Saying \"Please!\"', '960fa1c9-2678-40a8-b2b2-6556ec4d0484', '1'), ('383', 'Saying \"Thank You!\"', 'cf9a9519-b404-4ef6-a972-1b2ad5959c46', '1'), ('384', 'Saying \"You\'re Welcome!\"', 'caf57504-1753-4e22-a9c1-e2ee3ef062af', '1'), ('385', 'Saying \"Excuse Me!\"', '36cbff3b-f5ff-4c6c-aa6f-8dfbd9b9eda5', '1'), ('386', 'Asking \"How are you?\"', '11df87fc-dbdb-4b8e-a078-7dce37488822', '1'), ('387', 'Wishing \"Good morniing or night\"', 'b2e3e5d6-8e88-42bb-8342-3eadba7e742c', '1'), ('388', 'Greeting someone nicely', 'fb499cdd-a0ee-4eef-9656-7580390c691a', '1'), ('389', 'Thinking about how others feel', '4a6970b4-b4e0-481a-8e6b-00d3d2a5babb', '1'), ('390', 'Respecting the space of others', '249186fb-ecbe-4c49-95fd-d9dd98ee022a', '1'), ('391', 'Letting others go first', 'd86e589d-c7f9-4a11-8086-2ca81ba95f58', '1'), ('392', 'Showing appreciation', 'ef610e5d-6bc9-4842-bfa2-de8800deaec4', '1'), ('393', 'Giving compliments', 'a1ddd058-4a9b-4646-8cd9-af65a7ce14af', '1'), ('394', 'Not leaving a mess for others', '318b2046-bf09-46c5-a191-be254a4662f8', '1'), ('395', 'Covering mouth when coughing', '6855f040-7275-4cda-92d7-fc6402cc899f', '1'), ('396', 'Sitting properly at table', '7d78e868-4952-411c-81e0-ea5f873c7cb3', '1'), ('397', 'Using utensils properly', '7f2b9c21-575f-4203-8eeb-f082d51ece7f', '1'), ('398', 'Chewing with mouth closed', '8ed8cd61-0bce-4077-afac-6dba03aade1f', '1'), ('399', 'Using napkin', '178b42f0-13d3-48c7-9056-da7d1f1dc512', '1'), ('400', 'Eathing everything on plate', '14591204-76e3-4f81-aadb-f361b68a23a5', '1'), ('401', 'Asking instead of reaching', '7eb4ed4e-8de9-4c0d-a4c9-a08ff6c7643b', '1'), ('402', 'Yelling, screaming or whining', '8f5c6055-d2e3-44f5-b377-d4319a0cc294', '0'), ('403', 'Grabbing or taking', 'd654971b-c0e5-4a4f-b8be-f85b8cdb8aff', '0'), ('404', 'Being selfish', '87fc6e60-1467-41d4-a2e7-36faf768e917', '0'), ('405', 'Refusing to help', '660f2bef-6b69-4dcf-89e9-6ac7700003f1', '0'), ('406', 'Being rude', '337408c2-ad26-410d-89be-e63b07d922bc', '0'), ('407', 'Behaving poorly in public', 'e6fa950b-607b-4bdb-9c03-8a2e1b25977a', '0'), ('408', 'Cursing', 'ce40bbca-0a48-4044-9cf1-67d5708cf299', '0'), ('409', 'Name calling', '92d3875b-4192-4552-a122-066c24026cf5', '0'), ('410', 'Using put downs', '12e7c354-9852-4165-8efd-40ef33be3cc1', '0'), ('411', 'Interrupting', '7b67c014-22ce-4489-a9e9-b112d2110dfe', '0'), ('412', 'Talking back', '722dcb88-615e-425b-8d30-7427b12157c8', '0'), ('413', 'Being disrespectful', 'd742793a-c1ae-4dac-ac2c-d3ea066fd23b', '0'), ('414', 'Spreading rumors or gossip', '2ce1b1a5-0bf5-42de-95ac-a4696f3a2b45', '0'), ('415', 'Coughing on someone', '358e32c0-8add-4643-83e7-fbfbb659feb0', '0'), ('416', 'Putting feet on seats', '1dbf6e00-9906-4949-a77f-6d5f4f33fe4a', '0'), ('417', 'Littering', '1e0bc74c-2642-4c40-9fbf-061213878b32', '0'), ('418', 'Eating with fingers', '2d347f91-fc66-477a-a2d8-11bae64880a3', '0'), ('419', 'Playing with food or drink', '69175bd0-3a8e-4739-b55e-e2dad10610c0', '0'), ('420', 'Reaching', '343b0ead-1158-4083-9730-0c21b917af38', '0'), ('421', 'Being too loud', 'd0dafa95-8c8d-40f6-8d46-0650329a0648', '0'), ('422', 'Not staying in seat', '0a418015-326c-4611-ae61-4ab4d745e754', '0'), ('423', 'Using gadgets at table', '00b24cde-f980-4c4f-bba8-09c477353bef', '0'), ('424', 'Behaving while traveling', '7bc698fb-0bd0-4cf2-9f63-126cc64c1b8f', '1'), ('425', 'Behaving in public', 'f26b3baa-5c57-469d-bf9e-499315caed32', '1'), ('426', 'Respecting different rules', 'cd3b2478-5272-4c18-ae2a-2143ed4d5395', '1'), ('427', 'Being open to new things', 'cd7bc25d-a7e0-47bd-aa7a-bedc6b9390eb', '1'), ('428', 'Staying calm and close by', '25cc9d34-e34c-44e9-a242-6a28b0eb808d', '1'), ('429', 'Listening to others', '4eb49dc8-9dfc-4b47-a93a-be8bc5b866ee', '1'), ('430', 'Not running', '43d93b27-cb30-4e1c-af5b-1d9dfd23971d', '1'), ('431', 'Using social voices', 'f12ef247-cdde-4f91-af95-d64b05149af6', '1'), ('432', 'Being ready to go', 'e560027c-7db4-479c-9918-82156cfa9e51', '1'), ('433', 'Following instructions', '9fd52b4f-d9e0-4ca6-9e02-ffdba74b6088', '1'), ('434', 'Cooperating', '4323d4b2-21e6-4385-b29d-5bea6c4d409c', '1'), ('435', 'Eating properly', 'c0e5ae14-bfa8-420a-b6a2-bfa4d5ad5750', '1'), ('436', 'Greeting people nicely', 'c0828ccd-738f-4cae-8c3e-3749a026c228', '1'), ('437', 'Holding doors for people', 'df7fb26c-2055-4b21-8652-b374ed3c7cf5', '1'), ('438', 'Using polite language', '54081ba7-06c5-4d76-a56b-7551666bb7fe', '1'), ('439', 'Thanking our hosts', '4175e8e9-65b6-4869-b8dc-7feabf974e87', '1'), ('440', 'Respecting adults', '6f8b6c6c-120c-4802-a25f-b622e583f982', '1'), ('441', 'Using proper table manners', '01551faf-4d55-4e09-8ad3-b607227a50b7', '1'), ('442', 'Brushing teeth', '7729d514-8546-4f30-a3f4-45ec8c026fe7', '1'), ('443', 'Going to bed on time', '646b9621-5eb1-4a6f-8137-b26003904aa8', '1'), ('444', 'Taking baths', '6908c5ea-a422-402b-98c5-87017f474a3f', '1'), ('445', 'Keeping a routine', 'fb0976c6-2b55-43c2-b280-1e1744d7bd77', '1'), ('446', 'Keeping things organized', '7b1021ee-bf5b-484d-8206-e6f289f12853', '1'), ('447', 'Not respecting different rules', '84661461-4af0-4133-a1d1-d54e6e861e02', '0'), ('448', 'Yelling, screaming or whining', '390f20d8-3b5c-495f-b8a8-86c8050e1d17', '0'), ('449', 'Arguing about plans', '26bc9bbd-759d-4d9d-b310-1addf87b9663', '0'), ('450', 'Running in public places', 'ca46183a-05f0-468a-8157-36a9b3d7fc44', '0'), ('451', 'Disobeying instructions', '704831e9-6bbf-4f22-870b-e5a9255f3a24', '0'), ('452', 'Wandering off', 'f483151b-0ec6-49d1-85aa-bfa4164b4f1f', '0'), ('453', 'Fighting', '36640ce7-9a6b-4532-9a57-4ce814ea90ae', '0'), ('454', 'Throwing tantrums', '33ca1b2d-8c7c-4871-a6a6-d0f6a79d03df', '0'), ('455', 'Causing group to be late', 'ae903a4b-2ed3-4504-b089-26f773b2922d', '0'), ('456', 'Refusing to eat properly', '1fc96b31-ab28-459b-91f5-8d5d6e66a14f', '0'), ('457', 'Being rude to hosts', '5bd7e341-b03f-49ea-aecd-bf70beb9df1f', '0'), ('458', 'Using poor table manners', 'd89a2b2f-f8cd-451e-b0c6-8f15f95a7616', '0'), ('459', 'Cursing', '20e14f93-3745-4a0e-9537-60f13ca8f7ec', '0'), ('460', 'Being disrespectful', '52008875-1529-4660-aab6-cf7285dca03e', '0'), ('461', 'Being careless with others\' things', 'fe2988cf-1dd3-4f8c-b5a6-c35aa13e7d4f', '0'), ('462', 'Staying up past bedtime', 'b6085217-4be3-4395-95bb-010159de4cba', '0'), ('463', 'Leaving a mess', 'fd18fe45-93b3-402d-8ddb-0a5f2745e692', '0'), ('464', 'Skipping baths or showers', 'b95fd488-6a28-4123-b7ac-53da8589c015', '0'), ('465', 'Not brushing teeth', '9d0695cc-dfbc-4b6b-93c1-2f6024097859', '0'), ('466', 'Having needed school supplies', 'de26ae0b-eed6-41aa-9013-b0f202c3def8', '1'), ('467', 'Keeping binder organized', '7a119d3a-d747-4846-910f-a689726a102a', '1'), ('468', 'Having notes ready', '5c2fb217-5413-4a6f-ae70-de4d56d6be61', '1'), ('469', 'Using study planner', 'cf808bd4-225b-451b-8755-de3a74455542', '1'), ('470', 'Having materials for assignments', 'e2fb4f4a-48b4-439c-b676-a9b271b8b42c', '1'), ('471', 'Preparing work space', '586c7ea4-4521-45b9-b74d-05373f54c743', '1'), ('472', 'Knowing expectations', 'ea5a1fc1-a389-4026-a55d-a1fa8122a497', '1'), ('473', 'Asking for help', '3fcd4367-106b-4b57-95c7-4a533599a2f6', '1'), ('474', 'Having resources ready', '5d98bd23-cd17-4151-a3d6-cc7b61b4c799', '1'), ('475', 'Ready all material', 'cd3e65f4-fa3d-490a-974b-c14e897bc5bd', '1'), ('476', 'Creating flash cards', '47280686-20c6-4d64-a047-33d820071e2d', '1'), ('477', 'Sticking to a routine', 'f0478b26-7ead-4baa-8c6d-ffd3528aee7d', '1'), ('478', 'Completing homework', 'dcf06376-7801-4f6a-9dcf-6d493a713f24', '1'), ('479', 'Eliminating disctractions', 'e4440b75-7a05-4919-a572-8cbb9d83f12c', '1'), ('480', 'Having good body posture', '8530d14a-afcf-466e-8cb6-680e1d5a6a16', '1'), ('481', 'Figuring our what works', '4be6ee9c-c778-4fe3-a9ea-c24487c8731b', '1'), ('482', 'Knowing deadlines', 'f9135eea-c3d5-4e81-9a1c-81f2831c0511', '1'), ('483', 'Creating to do lists', '3a49d515-39e9-4b20-ae6b-90530fc7d5cc', '1'), ('484', 'Estimating time for each step', '2ba41711-b067-4e19-b144-1a3f0faa6693', '1'), ('485', 'Breaking down big assignments', 'fcd3dc6f-f7a3-4746-8a54-76f9f1e3786a', '1'), ('486', 'Prioritizing work', '10c81bb6-5852-4cd5-8334-8a94dcf6f640', '1'), ('487', 'Planning ahead for big projects', '6aa289a9-82de-4e10-aad0-0eb111501e48', '1'), ('488', 'Being unprepared', '5eb64142-84ef-4df7-ba47-9a7045251936', '0'), ('489', 'Not having proper notes', 'e1b6093e-981a-43ce-8ba0-8fb7f68dc1b3', '0'), ('490', 'Being disorganized', 'e4b3f1c6-6e70-4e71-bcc3-591ecb235170', '0'), ('491', 'Not using study planner', '4b5d07a3-bf82-433b-8768-974e2cc002e6', '0'), ('492', 'Forgetting key materials', 'c9550b97-49c0-47e5-afaa-9d9d851418a1', '0'), ('493', 'Forgetting instructions', 'e78f9860-8ec5-4ba9-b852-b2dfcb1d8fa4', '0'), ('494', 'Not reading all materials', 'ebfebaf2-d736-428b-a166-8528927391c1', '0'), ('495', 'Misplacing work', '83eb84bd-1e30-4173-ada6-dc07758eaa08', '0'), ('496', 'Letting gadgets distract', '0b2d3009-12cf-4362-8dd8-da5158e6f38c', '0'), ('497', 'Making excuses', 'a64c9f97-0382-43d0-9047-1ab5b3ba8c55', '0'), ('498', 'Slouching or bad posture', '105bff42-25b3-435c-8361-bff15b90a5f8', '0'), ('499', 'Not completing work', '41f4f986-caa8-4da1-9068-1f23954f9708', '0'), ('500', 'Rushing or sloppy with work', '19ce591f-247e-4aa4-84cc-c90c08190600', '0'), ('501', 'Complaining', 'b8a97eff-eb49-4a69-9adc-628f205118f9', '0'), ('502', 'Procastinating', '87ef55c9-a41a-497a-8cce-75ee36443ca3', '0'), ('503', 'Waiting until the last second', 'a0a06727-16be-4e30-8041-20791766f249', '0'), ('504', 'Not planning ahead', 'a84fc824-cd28-4007-b428-2e852648d04b', '0'), ('505', 'Not budgeting enough time', 'de0d9134-2a01-49cd-b5b4-856cba62d5ac', '0'), ('506', 'Being honest', '8225cdd1-4f3e-42f9-aa47-7c43a5e6bc2f', '1'), ('507', 'Being kind and helpful', 'e0281e96-64a4-48cf-a813-e9ab1a01f8b2', '1'), ('508', 'Using conversatin skills', '084dc516-b8c0-46fc-a428-bb3c8de3bbb3', '1'), ('509', 'Using signals and cues', '4e57206a-cd80-4128-9852-5d29f4923689', '1'), ('510', 'Using good manners', '1c617788-ce76-46af-a2a3-864cdb35ff7a', '1'), ('511', 'Following directions the first time', '05941a2e-70df-490d-a47d-2e2ecf23e4ed', '1'), ('512', 'Taking responsiblity for actions', 'b0ad0660-9525-4b5f-9e4b-5b50d853b5a2', '1'), ('513', 'Being respectful to adults', '861eb7d8-c1e5-48eb-b255-2f0d4f8d76f9', '1'), ('514', 'Respecting classroom rules', 'c54527d3-55d7-481f-b67c-da4107a83172', '1'), ('515', 'Walking quietly in hallways', 'a04d8d64-9858-4e2c-9e10-0a11e85301ac', '1'), ('516', 'Playing by recess rules', '1b71924e-7b14-4154-8c38-ceaffd83dba2', '1'), ('517', 'Following restroom rules', '302598fb-ff1e-4d94-9966-34ed510eedf8', '1'), ('518', 'Obeying cafeteria rules and routines', '1d1d76bc-9de3-4f74-8dae-7544049ef6e7', '1'), ('519', 'Completing check-ins without reminders', '0ba2fcd6-66e3-4ac3-845d-f4e1415211e9', '1'), ('520', 'Turning in daily assignments', 'a2ab9405-a790-4ed0-b28d-3c0121193548', '1'), ('521', 'Putting name on assignments', 'aa77736f-645c-406f-b8fd-7fbd9fa46330', '1'), ('522', 'Bringing take-home folder', '95fdbb23-2a6f-4a2f-827c-b9b1f81bc114', '1'), ('523', 'Getting parents signatures', '802fa860-24f2-4dea-9950-9c41d221f2b0', '1'), ('524', 'Doing assigned classroom jobs', 'daaaae72-bb65-4f84-962b-6539fd8c68ce', '1'), ('525', 'Keeping binder organzied', '8780068c-b742-4f67-899c-f892ded5e48a', '1'), ('526', 'Using study planner', '6abd8973-082a-45b2-92ec-f8edfb951325', '1'), ('527', 'Being self-directed', '12aea3f4-46ce-47eb-a259-4664c277b9c8', '1'), ('528', 'Being persistent', '37280ebf-b946-4625-9b9c-19a9ed1ec95b', '1'), ('529', 'Showing focus and effort', 'e7eab547-f552-44ba-bc08-b040e51e4c8e', '1'), ('530', 'Using time wisely', 'd41404d6-811e-4262-a0bf-3e4fa9d70596', '1'), ('531', 'Completing team responsibilities', '3032175f-e860-45aa-9f58-df2bda274c7b', '1'), ('532', 'Refusing to follow directions', 'f68017cb-665b-45d6-90f6-80cd011877ad', '0'), ('533', 'Using aggressive behavior', '26b89150-59f5-4409-bee4-376c6843a53a', '0'), ('534', 'Yelling, screaming or whining', '2a077844-c0da-4470-bda9-da1246ef5b41', '0'), ('535', 'Fighting or arguing', '20d4ed03-ca18-4524-9590-49659ba6e3f3', '0'), ('536', 'Interrupting', 'e783f7bd-3ddd-470c-b9db-26ed5d567734', '0'), ('537', 'Being disrespectful to others', '09012af5-c704-49af-99fc-88254f0b11b4', '0'), ('538', 'Being a poor sport', '39a1db03-4684-4ef0-92f7-3384f1c6135a', '0'), ('539', 'Running or yelling in hallways', '955f0302-11ef-479a-8159-7d4a5d62bad2', '0'), ('540', 'Breaking rules at recess', '5b1ec23b-8d93-4cb6-8a9a-b9f2cbddf74e', '0'), ('541', 'Being disruptive in cafeteria', '48f01d65-d8e2-4989-84e7-7f3a8ed68453', '0'), ('542', 'Ignoring bathroom rules', 'd7654c6d-ebcd-40ee-a48d-f569f2b2f536', '0'), ('543', 'Missing assignments', 'b9e4b9d3-ec6f-4aa7-bce0-76b97d5f6d1b', '0'), ('544', 'Being late with work', 'dc84f508-5371-41f2-a02e-1ab23e4b5b12', '0'), ('545', 'Needing reminders to follow procedures', 'b3efe1b1-2fd0-46d2-821f-cfc1b704055c', '0'), ('546', 'Forgetting notes from home', 'e33ede0d-17ae-4a2e-b842-e165a4fb6a83', '0'), ('547', 'Missing parent signatures', '78fe808a-9ddf-4d5d-831b-89662728d704', '0'), ('548', 'Neglecting classroom duties', '6325d0e1-b33d-4a71-8e8b-967652540594', '0'), ('549', 'Being unprepared', '0a9e65ee-d39e-4630-9ec2-b28d71744544', '0'), ('550', 'Rushing or sloppy with work', '0552e531-45ff-4ea6-bbaf-218be2c8e5a8', '0'), ('551', 'Getting off-task or distracted', '0de4f42d-78ea-4982-a2c4-bd77887f9994', '0'), ('552', 'Interring with others\' work', '96ab2c04-f796-4c88-93c8-1fe2636fa2de', '0'), ('553', 'Using technology inappropriately', 'ee0632e0-87de-42e2-902d-9b5bd3504d6d', '0'), ('554', 'Using supplies incorrectly', 'c3d2e9b3-7f4a-43ce-9c78-36e6a4ec5769', '0');
COMMIT;

-- ----------------------------
--  Table structure for `predefinedboards_predefinedbehaviorgroup`
-- ----------------------------
DROP TABLE IF EXISTS `predefinedboards_predefinedbehaviorgroup`;
CREATE TABLE `predefinedboards_predefinedbehaviorgroup` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(128) NOT NULL,
  `uuid` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;

-- ----------------------------
--  Records of `predefinedboards_predefinedbehaviorgroup`
-- ----------------------------
BEGIN;
INSERT INTO `predefinedboards_predefinedbehaviorgroup` VALUES ('1', 'Conduct', 'd36bb5f1-9784-4bea-84fc-0a0809f8822e'), ('2', 'Choices', '5f4834d3-6dfd-45d4-9c97-a5dc78018489'), ('3', 'Manners – Language', '7aecea46-5763-4e07-b80a-78596f4ebd5a'), ('4', 'Manners – Consideration', '7c1da82f-050c-4e79-b1a5-b6a829301edd'), ('5', 'Manners – Mealtime', '71d42422-1f2d-479d-b11b-6c5a8ce4d2bd'), ('6', 'Responsibilities', '31640dd8-0547-48ac-ad8f-7646088128d9'), ('7', 'Chores – Indoor', 'a12bc243-dd34-479a-8ec6-24b23f5ea6fb'), ('8', 'Chores – Outdoor', '996141f2-89d6-45d5-ac4d-4fe820e0c851'), ('9', 'Chores – Mealtime', '122b0428-d214-47ef-9ce2-a024e0044c4a'), ('10', 'Chores – Petcare', '1260cf58-482d-49ae-9b79-26132312722a'), ('11', 'School Work – Prep', '85cc2a4f-e64e-4ce1-9265-8554e9ee54a2'), ('12', 'School Work – Info', '806d44b8-2772-4064-aac4-4e029687f522'), ('13', 'School Work – Habits', 'ef751471-44a8-4e1a-a6f2-5f36f70d749c'), ('14', 'School Work – Time', 'dd900484-e51a-457e-9e3f-676667bf2bc2'), ('15', 'School Work – Rules', '6d7e7ba7-3c65-4124-b831-e1a2bc01254e'), ('16', 'School Work – Tasks', '658ac095-91d2-4f41-9fa5-33c471e801c2');
COMMIT;

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
) ENGINE=InnoDB AUTO_INCREMENT=555 DEFAULT CHARSET=latin1;

-- ----------------------------
--  Records of `predefinedboards_predefinedbehaviorgroup_behaviors`
-- ----------------------------
BEGIN;
INSERT INTO `predefinedboards_predefinedbehaviorgroup_behaviors` VALUES ('278', '1', '278'), ('279', '1', '279'), ('280', '1', '280'), ('281', '1', '281'), ('282', '1', '282'), ('283', '1', '283'), ('284', '1', '284'), ('307', '1', '307'), ('308', '1', '308'), ('309', '1', '309'), ('310', '1', '310'), ('311', '1', '311'), ('312', '1', '312'), ('375', '1', '375'), ('376', '1', '376'), ('377', '1', '377'), ('378', '1', '378'), ('379', '1', '379'), ('380', '1', '380'), ('381', '1', '381'), ('402', '1', '402'), ('403', '1', '403'), ('404', '1', '404'), ('405', '1', '405'), ('406', '1', '406'), ('407', '1', '407'), ('424', '1', '424'), ('425', '1', '425'), ('426', '1', '426'), ('427', '1', '427'), ('428', '1', '428'), ('429', '1', '429'), ('447', '1', '447'), ('448', '1', '448'), ('449', '1', '449'), ('450', '1', '450'), ('451', '1', '451'), ('452', '1', '452'), ('506', '1', '506'), ('507', '1', '507'), ('508', '1', '508'), ('509', '1', '509'), ('510', '1', '510'), ('511', '1', '511'), ('512', '1', '512'), ('513', '1', '513'), ('532', '1', '532'), ('533', '1', '533'), ('534', '1', '534'), ('535', '1', '535'), ('536', '1', '536'), ('537', '1', '537'), ('538', '1', '538'), ('285', '2', '285'), ('286', '2', '286'), ('287', '2', '287'), ('288', '2', '288'), ('289', '2', '289'), ('290', '2', '290'), ('291', '2', '291'), ('292', '2', '292'), ('313', '2', '313'), ('314', '2', '314'), ('315', '2', '315'), ('316', '2', '316'), ('317', '2', '317'), ('318', '2', '318'), ('319', '2', '319'), ('430', '2', '430'), ('431', '2', '431'), ('432', '2', '432'), ('433', '2', '433'), ('434', '2', '434'), ('435', '2', '435'), ('453', '2', '453'), ('454', '2', '454'), ('455', '2', '455'), ('456', '2', '456'), ('293', '3', '293'), ('294', '3', '294'), ('323', '3', '323'), ('324', '3', '324'), ('382', '3', '382'), ('383', '3', '383'), ('384', '3', '384'), ('385', '3', '385'), ('386', '3', '386'), ('387', '3', '387'), ('388', '3', '388'), ('408', '3', '408'), ('409', '3', '409'), ('410', '3', '410'), ('411', '3', '411'), ('412', '3', '412'), ('438', '3', '438'), ('439', '3', '439'), ('459', '3', '459'), ('295', '4', '295'), ('296', '4', '296'), ('320', '4', '320'), ('321', '4', '321'), ('389', '4', '389'), ('390', '4', '390'), ('391', '4', '391'), ('392', '4', '392'), ('393', '4', '393'), ('394', '4', '394'), ('395', '4', '395'), ('413', '4', '413'), ('414', '4', '414'), ('415', '4', '415'), ('416', '4', '416'), ('417', '4', '417'), ('436', '4', '436'), ('437', '4', '437'), ('440', '4', '440'), ('457', '4', '457'), ('460', '4', '460'), ('461', '4', '461'), ('297', '5', '297'), ('322', '5', '322'), ('396', '5', '396'), ('397', '5', '397'), ('398', '5', '398'), ('399', '5', '399'), ('400', '5', '400'), ('401', '5', '401'), ('418', '5', '418'), ('419', '5', '419'), ('420', '5', '420'), ('421', '5', '421'), ('422', '5', '422'), ('423', '5', '423'), ('441', '5', '441'), ('458', '5', '458'), ('299', '6', '299'), ('300', '6', '300'), ('301', '6', '301'), ('302', '6', '302'), ('303', '6', '303'), ('304', '6', '304'), ('305', '6', '305'), ('306', '6', '306'), ('326', '6', '326'), ('327', '6', '327'), ('328', '6', '328'), ('329', '6', '329'), ('442', '6', '442'), ('443', '6', '443'), ('444', '6', '444'), ('445', '6', '445'), ('446', '6', '446'), ('462', '6', '462'), ('463', '6', '463'), ('464', '6', '464'), ('465', '6', '465'), ('330', '7', '330'), ('331', '7', '331'), ('332', '7', '332'), ('333', '7', '333'), ('334', '7', '334'), ('335', '7', '335'), ('356', '7', '356'), ('357', '7', '357'), ('358', '7', '358'), ('359', '7', '359'), ('360', '7', '360'), ('336', '8', '336'), ('337', '8', '337'), ('338', '8', '338'), ('339', '8', '339'), ('340', '8', '340'), ('341', '8', '341'), ('361', '8', '361'), ('362', '8', '362'), ('363', '8', '363'), ('364', '8', '364'), ('342', '9', '342'), ('343', '9', '343'), ('344', '9', '344'), ('345', '9', '345'), ('346', '9', '346'), ('347', '9', '347'), ('348', '9', '348'), ('365', '9', '365'), ('366', '9', '366'), ('367', '9', '367'), ('368', '9', '368'), ('369', '9', '369'), ('349', '10', '349'), ('350', '10', '350'), ('351', '10', '351'), ('352', '10', '352'), ('353', '10', '353'), ('354', '10', '354'), ('355', '10', '355'), ('370', '10', '370'), ('371', '10', '371'), ('372', '10', '372'), ('373', '10', '373'), ('374', '10', '374'), ('298', '11', '298'), ('466', '11', '466'), ('467', '11', '467'), ('468', '11', '468'), ('469', '11', '469'), ('470', '11', '470'), ('471', '11', '471'), ('488', '11', '488'), ('489', '11', '489'), ('490', '11', '490'), ('491', '11', '491'), ('472', '12', '472'), ('473', '12', '473'), ('474', '12', '474'), ('475', '12', '475'), ('476', '12', '476'), ('492', '12', '492'), ('493', '12', '493'), ('494', '12', '494'), ('495', '12', '495'), ('325', '13', '325'), ('477', '13', '477'), ('478', '13', '478'), ('479', '13', '479'), ('480', '13', '480'), ('481', '13', '481'), ('496', '13', '496'), ('497', '13', '497'), ('498', '13', '498'), ('499', '13', '499'), ('500', '13', '500'), ('501', '13', '501'), ('525', '13', '525'), ('526', '13', '526'), ('527', '13', '527'), ('528', '13', '528'), ('529', '13', '529'), ('549', '13', '549'), ('550', '13', '550'), ('551', '13', '551'), ('552', '13', '552'), ('553', '13', '553'), ('554', '13', '554'), ('482', '14', '482'), ('483', '14', '483'), ('484', '14', '484'), ('485', '14', '485'), ('486', '14', '486'), ('487', '14', '487'), ('502', '14', '502'), ('503', '14', '503'), ('504', '14', '504'), ('505', '14', '505'), ('530', '14', '530'), ('514', '15', '514'), ('515', '15', '515'), ('516', '15', '516'), ('517', '15', '517'), ('518', '15', '518'), ('539', '15', '539'), ('540', '15', '540'), ('541', '15', '541'), ('542', '15', '542'), ('519', '16', '519'), ('520', '16', '520'), ('521', '16', '521'), ('522', '16', '522'), ('523', '16', '523'), ('524', '16', '524'), ('531', '16', '531'), ('543', '16', '543'), ('544', '16', '544'), ('545', '16', '545'), ('546', '16', '546'), ('547', '16', '547'), ('548', '16', '548');
COMMIT;

-- ----------------------------
--  Table structure for `predefinedboards_predefinedboard`
-- ----------------------------
DROP TABLE IF EXISTS `predefinedboards_predefinedboard`;
CREATE TABLE `predefinedboards_predefinedboard` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(128) NOT NULL,
  `uuid` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;

-- ----------------------------
--  Records of `predefinedboards_predefinedboard`
-- ----------------------------
BEGIN;
INSERT INTO `predefinedboards_predefinedboard` VALUES ('7', 'Around the House', '437e73c5-df10-4c1c-bf14-43fddcbd71e6'), ('8', 'Chores & More', 'affcd78e-2ea6-424a-b0fa-237272fc2805'), ('9', 'Manners, Please', '5c69f568-970e-4475-ba95-8dac86b731fe'), ('10', 'On the Road', '1e680945-5c35-4b5e-89a0-a1a88c76dcd6'), ('11', 'Study Time', '8f5a468d-51e5-4bc7-9b26-048da9cd2e67'), ('12', 'Teacher\'s Helper', '87859e23-70e1-4e49-bb24-393969c25c71');
COMMIT;

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
) ENGINE=InnoDB AUTO_INCREMENT=555 DEFAULT CHARSET=latin1;

-- ----------------------------
--  Records of `predefinedboards_predefinedboard_behaviors`
-- ----------------------------
BEGIN;
INSERT INTO `predefinedboards_predefinedboard_behaviors` VALUES ('278', '7', '278'), ('279', '7', '279'), ('280', '7', '280'), ('281', '7', '281'), ('282', '7', '282'), ('283', '7', '283'), ('284', '7', '284'), ('285', '7', '285'), ('286', '7', '286'), ('287', '7', '287'), ('288', '7', '288'), ('289', '7', '289'), ('290', '7', '290'), ('291', '7', '291'), ('292', '7', '292'), ('293', '7', '293'), ('294', '7', '294'), ('295', '7', '295'), ('296', '7', '296'), ('297', '7', '297'), ('298', '7', '298'), ('299', '7', '299'), ('300', '7', '300'), ('301', '7', '301'), ('302', '7', '302'), ('303', '7', '303'), ('304', '7', '304'), ('305', '7', '305'), ('306', '7', '306'), ('307', '7', '307'), ('308', '7', '308'), ('309', '7', '309'), ('310', '7', '310'), ('311', '7', '311'), ('312', '7', '312'), ('313', '7', '313'), ('314', '7', '314'), ('315', '7', '315'), ('316', '7', '316'), ('317', '7', '317'), ('318', '7', '318'), ('319', '7', '319'), ('320', '7', '320'), ('321', '7', '321'), ('322', '7', '322'), ('323', '7', '323'), ('324', '7', '324'), ('325', '7', '325'), ('326', '7', '326'), ('327', '7', '327'), ('328', '7', '328'), ('329', '7', '329'), ('330', '8', '330'), ('331', '8', '331'), ('332', '8', '332'), ('333', '8', '333'), ('334', '8', '334'), ('335', '8', '335'), ('336', '8', '336'), ('337', '8', '337'), ('338', '8', '338'), ('339', '8', '339'), ('340', '8', '340'), ('341', '8', '341'), ('342', '8', '342'), ('343', '8', '343'), ('344', '8', '344'), ('345', '8', '345'), ('346', '8', '346'), ('347', '8', '347'), ('348', '8', '348'), ('349', '8', '349'), ('350', '8', '350'), ('351', '8', '351'), ('352', '8', '352'), ('353', '8', '353'), ('354', '8', '354'), ('355', '8', '355'), ('356', '8', '356'), ('357', '8', '357'), ('358', '8', '358'), ('359', '8', '359'), ('360', '8', '360'), ('361', '8', '361'), ('362', '8', '362'), ('363', '8', '363'), ('364', '8', '364'), ('365', '8', '365'), ('366', '8', '366'), ('367', '8', '367'), ('368', '8', '368'), ('369', '8', '369'), ('370', '8', '370'), ('371', '8', '371'), ('372', '8', '372'), ('373', '8', '373'), ('374', '8', '374'), ('375', '9', '375'), ('376', '9', '376'), ('377', '9', '377'), ('378', '9', '378'), ('379', '9', '379'), ('380', '9', '380'), ('381', '9', '381'), ('382', '9', '382'), ('383', '9', '383'), ('384', '9', '384'), ('385', '9', '385'), ('386', '9', '386'), ('387', '9', '387'), ('388', '9', '388'), ('389', '9', '389'), ('390', '9', '390'), ('391', '9', '391'), ('392', '9', '392'), ('393', '9', '393'), ('394', '9', '394'), ('395', '9', '395'), ('396', '9', '396'), ('397', '9', '397'), ('398', '9', '398'), ('399', '9', '399'), ('400', '9', '400'), ('401', '9', '401'), ('402', '9', '402'), ('403', '9', '403'), ('404', '9', '404'), ('405', '9', '405'), ('406', '9', '406'), ('407', '9', '407'), ('408', '9', '408'), ('409', '9', '409'), ('410', '9', '410'), ('411', '9', '411'), ('412', '9', '412'), ('413', '9', '413'), ('414', '9', '414'), ('415', '9', '415'), ('416', '9', '416'), ('417', '9', '417'), ('418', '9', '418'), ('419', '9', '419'), ('420', '9', '420'), ('421', '9', '421'), ('422', '9', '422'), ('423', '9', '423'), ('424', '10', '424'), ('425', '10', '425'), ('426', '10', '426'), ('427', '10', '427'), ('428', '10', '428'), ('429', '10', '429'), ('430', '10', '430'), ('431', '10', '431'), ('432', '10', '432'), ('433', '10', '433'), ('434', '10', '434'), ('435', '10', '435'), ('436', '10', '436'), ('437', '10', '437'), ('438', '10', '438'), ('439', '10', '439'), ('440', '10', '440'), ('441', '10', '441'), ('442', '10', '442'), ('443', '10', '443'), ('444', '10', '444'), ('445', '10', '445'), ('446', '10', '446'), ('447', '10', '447'), ('448', '10', '448'), ('449', '10', '449'), ('450', '10', '450'), ('451', '10', '451'), ('452', '10', '452'), ('453', '10', '453'), ('454', '10', '454'), ('455', '10', '455'), ('456', '10', '456'), ('457', '10', '457'), ('458', '10', '458'), ('459', '10', '459'), ('460', '10', '460'), ('461', '10', '461'), ('462', '10', '462'), ('463', '10', '463'), ('464', '10', '464'), ('465', '10', '465'), ('466', '11', '466'), ('467', '11', '467'), ('468', '11', '468'), ('469', '11', '469'), ('470', '11', '470'), ('471', '11', '471'), ('472', '11', '472'), ('473', '11', '473'), ('474', '11', '474'), ('475', '11', '475'), ('476', '11', '476'), ('477', '11', '477'), ('478', '11', '478'), ('479', '11', '479'), ('480', '11', '480'), ('481', '11', '481'), ('482', '11', '482'), ('483', '11', '483'), ('484', '11', '484'), ('485', '11', '485'), ('486', '11', '486'), ('487', '11', '487'), ('488', '11', '488'), ('489', '11', '489'), ('490', '11', '490'), ('491', '11', '491'), ('492', '11', '492'), ('493', '11', '493'), ('494', '11', '494'), ('495', '11', '495'), ('496', '11', '496'), ('497', '11', '497'), ('498', '11', '498'), ('499', '11', '499'), ('500', '11', '500'), ('501', '11', '501'), ('502', '11', '502'), ('503', '11', '503'), ('504', '11', '504'), ('505', '11', '505'), ('506', '12', '506'), ('507', '12', '507'), ('508', '12', '508'), ('509', '12', '509'), ('510', '12', '510'), ('511', '12', '511'), ('512', '12', '512'), ('513', '12', '513'), ('514', '12', '514'), ('515', '12', '515'), ('516', '12', '516'), ('517', '12', '517'), ('518', '12', '518'), ('519', '12', '519'), ('520', '12', '520'), ('521', '12', '521'), ('522', '12', '522'), ('523', '12', '523'), ('524', '12', '524'), ('525', '12', '525'), ('526', '12', '526'), ('527', '12', '527'), ('528', '12', '528'), ('529', '12', '529'), ('530', '12', '530'), ('531', '12', '531'), ('532', '12', '532'), ('533', '12', '533'), ('534', '12', '534'), ('535', '12', '535'), ('536', '12', '536'), ('537', '12', '537'), ('538', '12', '538'), ('539', '12', '539'), ('540', '12', '540'), ('541', '12', '541'), ('542', '12', '542'), ('543', '12', '543'), ('544', '12', '544'), ('545', '12', '545'), ('546', '12', '546'), ('547', '12', '547'), ('548', '12', '548'), ('549', '12', '549'), ('550', '12', '550'), ('551', '12', '551'), ('552', '12', '552'), ('553', '12', '553'), ('554', '12', '554');
COMMIT;

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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- ----------------------------
--  Records of `services_profile`
-- ----------------------------
BEGIN;
INSERT INTO `services_profile` VALUES ('1', '', '', '1', '', '100', '100'), ('2', '', '', '2', '', '100', '100');
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
