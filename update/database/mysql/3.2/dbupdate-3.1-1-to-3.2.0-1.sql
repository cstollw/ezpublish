alter table ezcontentclass_attribute add column data_text5 text;
alter table ezsearch_object_word_link add column identifier varchar(255) not null default '';
alter table ezsearch_object_word_link add column integer_value integer not null default '0';

CREATE TABLE ezcollab_notification_rule (
    id integer  auto_increment NOT NULL,
    user_id varchar(255) NOT NULL,
    collab_identifier varchar(255) not null,
    primary key ( id )
);

CREATE TABLE ezurl_object_link (
  url_id int(11) NOT NULL default '0',
  contentobject_attribute_id int(11) NOT NULL default '0',
  contentobject_attribute_version int(11) NOT NULL default '0',
  PRIMARY KEY (url_id,contentobject_attribute_id,contentobject_attribute_version)
);

ALTER TABLE ezcontentobject_attribute ADD sort_key varchar(255);
ALTER TABLE ezcontentobject_attribute ADD index ( sort_key );

CREATE TABLE ezsite_data (
  id int(11) auto_increment NOT NULL,
  name varchar(60) NOT NULL default '',
  value text NOT NULL default '',
  PRIMARY KEY (id)
);

INSERT INTO ezsite_data (name, value) VALUES('ezpublish-version', '3.2.0');
INSERT INTO ezsite_data (name, value) VALUES('ezpublish-release', '1');


drop index ezcontentobject_tree_depth on ezcontentobject_tree;
create index ezsearch_word_object_count on ezsearch_word(object_count);
create index ezcontentobject_status on ezcontentobject( status );
create index ezcontentobject_tree_path_depth on ezcontentobject_tree( path_string, depth );

alter table ezcontentclass_attribute add can_translate int default 1;
alter table ezcontentobject_attribute add attribute_original_id int default 0;

create table ezurlalias
(
  id int(11) auto_increment NOT NULL,
  source_url text not null,
  source_md5 char(32),
  destination_url text not null,
  is_internal int not null default 1,
  forward_to_id int not null,  
  PRIMARY KEY (id)
);

create index ezurlalias_source_md5 on ezurlalias( source_md5 );

insert into ezurlalias ( source_url, source_md5, destination_url, is_internal ) select path_identification_string, md5( path_identification_string ), concat( 'content/view/full/', node_id ), 1 from ezcontentobject_tree where node_id <> 1;

# Drop unneeded columns
alter table ezcontentobject_tree drop md5_path;
alter table ezcontentobject_tree drop crc32_path;

create table ezpreferences
(
  id int(11) auto_increment NOT NULL,
  user_id int(11) NOT NULL,
  name varchar(100),
  value varchar(100),
  PRIMARY KEY (id)
);

create index ezpreferences_name on ezpreferences( name );
