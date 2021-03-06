CREATE TABLE `addresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `addressable_id` int(11) DEFAULT NULL,
  `addressable_type` varchar(255) DEFAULT NULL,
  `country_id` int(11) DEFAULT NULL,
  `address` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_addresses_on_addressable_id_and_addressable_type` (`addressable_id`,`addressable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `areas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `area` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_areas_on_area` (`area`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `attachments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `attachable_id` int(11) DEFAULT NULL,
  `attachable_type` varchar(255) DEFAULT NULL,
  `filename` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_attachments_on_filename` (`filename`),
  KEY `index_attachments_on_attachable_id_and_attachable_type` (`attachable_id`,`attachable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `commentable_id` int(11) DEFAULT NULL,
  `commentable_type` varchar(255) DEFAULT NULL,
  `comment` text NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_comments_on_commentable_id_and_commentable_type` (`commentable_id`,`commentable_type`),
  FULLTEXT KEY `fulltext_comment` (`comment`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contactable_id` int(11) DEFAULT NULL,
  `contactable_type` varchar(255) DEFAULT NULL,
  `contacts` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_contacts_on_contactable_id_and_contactable_type` (`contactable_id`,`contactable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `countries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `area_id` int(11) NOT NULL,
  `country` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_countries_on_country` (`country`),
  KEY `index_countries_on_area_id` (`area_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `cvs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `expert_id` int(11) NOT NULL,
  `language_id` int(11) NOT NULL,
  `cv` text,
  PRIMARY KEY (`id`),
  KEY `index_cvs_on_expert_id` (`expert_id`),
  KEY `index_cvs_on_language_id` (`language_id`),
  FULLTEXT KEY `fulltext_cv` (`cv`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `experts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `country_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `prename` varchar(255) NOT NULL,
  `gender` varchar(255) NOT NULL,
  `birthday` date DEFAULT NULL,
  `degree` varchar(255) DEFAULT NULL,
  `former_collaboration` tinyint(1) NOT NULL DEFAULT '0',
  `fee` varchar(255) DEFAULT NULL,
  `job` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_experts_on_user_id` (`user_id`),
  KEY `index_experts_on_country_id` (`country_id`),
  KEY `index_experts_on_name` (`name`),
  KEY `index_experts_on_prename` (`prename`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `langs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `language_id` int(11) NOT NULL,
  `langable_id` int(11) DEFAULT NULL,
  `langable_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_langs_on_language_id` (`language_id`),
  KEY `index_langs_on_langable_id_and_langable_type` (`langable_id`,`langable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `languages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `language` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_languages_on_language` (`language`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `privileges` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `admin` tinyint(1) NOT NULL DEFAULT '0',
  `experts` tinyint(1) NOT NULL DEFAULT '0',
  `partners` tinyint(1) NOT NULL DEFAULT '0',
  `references` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_privileges_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_digest` varchar(255) NOT NULL,
  `login_hash` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `prename` varchar(255) NOT NULL,
  `locale` varchar(255) NOT NULL DEFAULT 'en',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_username` (`username`),
  KEY `index_users_on_email` (`email`),
  KEY `index_users_on_login_hash` (`login_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO schema_migrations (version) VALUES ('1');

INSERT INTO schema_migrations (version) VALUES ('2');

INSERT INTO schema_migrations (version) VALUES ('3');

INSERT INTO schema_migrations (version) VALUES ('4');

INSERT INTO schema_migrations (version) VALUES ('5');