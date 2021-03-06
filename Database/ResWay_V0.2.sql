CREATE database ResWay1;
use ResWay1;
/*test @ 3:30p*/

/*User should be first table created, so FKs will work qhen script */
/*Please use Indexes, for faster access.*/
/*Please run the script in your MySQL and clear any errors as they arise, probably to do with ordering of the tables
Please make sure each PK has AUTO_INCREMENT
Please implement a few of the more high level optimization steps mentioned in the stack overflow article I shared. We can improve more later, but will be userful to learn some of the thought behind these steps.
I noticed in the Offer table, the commented out FK lines seem pretty funky. Presumably why they're commented. Shouldn't the references point at another table, not itself?
For tables where two field make up the primary key I believe the syntax is something like :
ADD CONSTRAINT uq_yourtablename UNIQUE(column1, column2);
*/

CREATE TABLE AgentLicense (
  lic_id INTEGER NOT NULL AUTO_INCREMENT,
  usr_id INTEGER,
  lic_name VARCHAR(20),
  lic_state VARCHAR(20),
  creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (lic_id),
  CONSTRAINT FK_usr_id FOREIGN KEY(usr_id) REFERENCES User(usr_id)
  /*ME: By User, do you mean "UserInfo" table below?*/
);

CREATE TABLE FormType (
  ft_id INTEGER NOT NULL auto_increment,
  ft_name VARCHAR(40) NOT NULL,
  ft_desc VARCHAR(255),
  creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (ft_id)
);

CREATE TABLE Offer (
  ofr_id INTEGER NOT NULL auto_increment,
  ofr_prop_id INTEGER NOT NULL,
  ofr_byr_id INTEGER,
  ofr_slr_id INTEGER,
  ofr_current_version SMALLINT NOT NULL,
  ofr_status ENUM( 'incomplete',  'buyer_signed', 'seller_signed', 'executed', 'inactive') NOT NULL DEFAULT 'Incomplete',
  ofr_byr_notes VARCHAR(255),
  ofr_slr_notes VARCHAR(255),
  completion_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (ofr_id),
 /* CONSTRAINT FK_ofr_prop_id FOREIGN KEY(ofr_prop_id) REFERENCES Offer(ofr_prop_id),
  CONSTRAINT FK_ofr_byr_id FOREIGN KEY(ofr_byr_id) REFERENCES Offer(ofr_byr_id),
  CONSTRAINT FK_fr_slr_id FOREIGN KEY(fr_slr_id) REFERENCES Offer(fr_slr_id),
  CONSTRAINT FK_ofr_current_version FOREIGN KEY(ofr_current_version) REFERENCES Offer(ofr_current_version)*/
);

CREATE TABLE OfferVersion (
  ofr_id INTEGER NOT NULL auto_increment,
  ver_num SMALLINT NOT NULL,
  ofr_det_id INTEGER NOT NULL,
  ver_byr_notes VARCHAR(255),
  ver_slr_notes VARCHAR(255),
  ver_byr_access BOOL NOT NULL,
  ver_ba_access BOOL NOT NULL,
  ver_slr_access BOOL NOT NULL,
  ver_sa_access BOOL NOT NULL,
  creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (ver_num),
  PRIMARY KEY (ofr_id),
  CONSTRAINT FK_ofr_id FOREIGN KEY(ofr_id) REFERENCES Offer(ofr_id),
  CONSTRAINT FK_ofr_det_id FOREIGN KEY(ofr_det_id) REFERENCES OfferDetails(ofr_det_id)
);

CREATE TABLE OfferFormType (
  ofr_id INTEGER NOT NULL auto_increment,
  ft_id INTEGER NOT NULL,
  creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (ofr_id),
    PRIMARY KEY (ft_id),
  CONSTRAINT FK_OFT_ofr_id FOREIGN KEY(ofr_id) REFERENCES Offer(ofr_id),
   CONSTRAINT FK_ft_id FOREIGN KEY(ft_id) REFERENCES FormType(ft_id)
);

CREATE TABLE Document (
  doc_id INTEGER NOT NULL auto_increment,
  ofr_id INTEGER NOT NULL,
  usr_id INTEGER NOT NULL,
  ft_id INTEGER,
  doc_title VARCHAR(35) NOT NULL,
  doc_ext VARCHAR(10) NOT NULL,
  doc_contents MEDIUMBLOB NOT NULL,
  doc_size DECIMAL(12,2) NOT NULL,
  creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (doc_id),
  CONSTRAINT FK_doc_ofr_id FOREIGN KEY(ofr_id) REFERENCES User(ofr_id),
  CONSTRAINT FK_Doc_usr_id FOREIGN KEY(usr_id) REFERENCES Offer(usr_id),
  CONSTRAINT FK_Doc_ft_id FOREIGN KEY(ft_id) REFERENCES FormType(ft_id)
);

CREATE TABLE UserInfo (
  usr_id INTEGER NOT NULL auto_increment,
  usr_inf_first_name VARCHAR(20) NOT NULL,
  usr_inf_last_name VARCHAR(20) NOT NULL,
  usr_inf_middle_name VARCHAR(20),
  usr_inf_suffix VARCHAR(10),
  usr_inf_agent BOOLEAN NOT NULL,
  usr_inf_gender ENUM('M', 'F', 'U'),
  usr_inf_is_registered BOOLEAN,
  usr_inf_registration_date TIMESTAMP NOT NULL,
  usr_inf_email_verified BOOLEAN NOT NULL DEFAULT FALSE,
  usr_inf_phone_verified BOOLEAN NOT NULL DEFAULT FALSE,
  usr_inf_addr_str1 VARCHAR(50),
  usr_inf_addr_str2 VARCHAR(50),
  usr_inf_addr_apt_num SMALLINT,
  usr_inf_addr_zip VARCHAR(10),
  usr_inf_addr_city VARCHAR(20),
  usr_inf_addr_state VARCHAR(20),
  creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  /*usr_inf_profile_picture, ME: make this a blob?*/
   PRIMARY KEY (usr_id),
  CONSTRAINT FK_UI_usr_id FOREIGN KEY(usr_id) REFERENCES User(usr_id)
);

CREATE TABLE ResoProperty (
reso_property_key INTEGER NOT NULL AUTO_INCREMENT,
reso_reso_ListingId VARCHAR(255) NOT NULL,
reso_SourceSystemName VARCHAR(255) NOT NULL,
reso_Appliances VARCHAR(1024),
reso_AssociationFee DECIMAL(14,2),
reso_AssociationName VARCHAR(50),
reso_AssociationYN BOOLEAN DEFAULT FALSE,
reso_BathroomsFull TINYINT,
reso_BathroomsHalf TINYINT,
reso_BedroomsTotal TINYINT,
reso_BuyerAgencyCompensation VARCHAR(25),
reso_BuyerAgencyCompensationType ENUM('G','N') DEFAULT 'G',
/* these MAMLS values will have to be changed when scaling*/
reso_BuyerAgentAOR ENUM('Massachusetts Assocition of Realtors'),
/* these MAMLS values will have to be changed when scaling*/
reso_BuyerAgentCellPhone VARCHAR(16),
reso_BuyerAgentEmail VARCHAR(80),
reso_BuyerAgentFirstName VARCHAR(50),
reso_BuyerAgentFullName VARCHAR(150),
reso_BuyerAgentLastName VARCHAR(50),
reso_BuyerAgentMlsId VARCHAR(25),
reso_BuyerAgentNameSuffix VARCHAR(10),
reso_BuyerAgentStateLicense VARCHAR(50),
reso_City VARCHAR(50),
reso_CityRegion VARCHAR(150),
reso_Contingency VARCHAR(1024),
reso_Disclosures VARCHAR(4000),
reso_DocumentsAvailable VARCHAR(1024),
reso_DocumentsCount TINYINT,
reso_Exclusions VARCHAR(1024),
reso_ListAgentAOR ENUM('Massachusetts Assocition of Realtors'),
/* these MAMLS values will have to be changed when scaling*/
reso_ListAgentCellPhone VARCHAR(16),
reso_ListAgentEmail VARCHAR(80),
reso_ListAgentFirstName VARCHAR(50),
reso_ListAgentFullName VARCHAR(150),
reso_ListAgentKey VARCHAR(255),
reso_ListAgentKeyNumeric VARCHAR(255),
reso_ListAgentLastName VARCHAR(50),
reso_ListAgentMiddleName VARCHAR(50),
reso_ListAgentMlsId VARCHAR(25),
reso_ListAgentNameSuffix VARCHAR(10),
reso_ListAgentOfficePhone VARCHAR(16),
reso_ListAgentStateLicense VARCHAR(50),
reso_ListPrice DECIMAL(14,2),
reso_ListingAgreement ENUM('M','A','D','E',),
/* these MAMLS values will have to be changed when scaling*/
reso_ListingKey VARCHAR(255),
reso_ListingService ENUM('N','Y'),
reso_LivingArea DECIMAL(14,2),
reso_LotSizeAcres DECIMAL(16,4),
reso_LotSizeSquareFeet DECIMAL(14,2),
reso_NumberOfUnitsInCommunity SMALLINT,
reso_NumberOfUnitsLeased SMALLINT,
reso_NumberOfUnitsTotal TINYINT,
reso_OnMarketDate DATE,
reso_OwnerName VARCHAR(50),
reso_OwnerPhone VARCHAR(16),
reso_Ownership VARCHAR(1024),
reso_ParcelNumber VARCHAR(50),
reso_ParkingTotal DECIMAL(14,2),
reso_PostalCode VARCHAR(10),
reso_PostalCodePlus4 VARCHAR(4),
reso_PrivateRemarks VARCHAR(4000),
reso_PropertySubType ENUM('CI','MF','CC','RN','SF','BU','GEN') DEFAULT 'GEN',
/* these MAMLS values will have to be changed when scaling*/
reso_PropertyType ENUM('GEN'),
reso_PublicRemarks VARCHAR(4000),
reso_SpecialListingConditions VARCHAR(1024),
reso_StandardStatus ENUM('ACT','UAG','PCG','CTG','BOM','NEW'),
/* these MAMLS values will have to be changed when scaling*/
reso_StatusChangeTimestamp TIMESTAMP,
reso_StreetName VARCHAR(50),
reso_StreetNumber VARCHAR(25),
reso_StreetSuffix VARCHAR(25),
reso_SubAgencyCompensation VARCHAR(25),
reso_SubAgencyCompensationType ENUM('G','N') DEFAULT 'G',
/* these MAMLS values will have to be changed when scaling*/
reso_TaxBookNumber VARCHAR(25),
reso_TaxParcelLetter VARCHAR(25),
reso_TransactionBrokerCompensation VARCHAR(25),
reso_TransactionBrokerCompensationType ENUM('G','N') DEFAULT 'G',
/* these MAMLS values will have to be changed when scaling*/
reso_DualVariableCompensationYN BOOLEAN DEFAULT FALSE,
reso_UnitNumber VARCHAR(25),
reso_YearBuilt SMALLINT,
reso_LeadPaint VARCHAR(32),
mamls_MANAGEMENT_CC VARCHAR(32),
mamls_MASTER_BOOK_CC INTEGER,
mamls_MASTER_PAGE_CC INTEGER,
mamls_NO_UNITS_OWNER_OCC_CC SMALLINT,
last_edit_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (reso_property_key)
);

CREATE TABLE Preference (
  usr_id INTEGER NOT NULL AUTO_INCREMENT,
  pref_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
  pref_deposit DECIMAL(12,2) NOT NULL DEFAULT 1000, 
  pref_pns_deposit DECIMAL(5,2) NOT NULL 5,
  pref_financing DECIMAL(5, 2) NOT NULL DEFAULT 80,
  pref_concession DECIMAL(5,2) NOT NULL DEFAULT 0,
  pref_exp_dt SMALLINT NOT NULL DEFAULT 1,
  pref_pns_sign_dt SMALLINT NOT NULL DEFAULT 10,
  pref_cls_dt SMALLINT NOT NULL DEFAULT 45,
  pref_is_inspection_req BOOL NOT NULL DEFAULT TRUE,
  pref_is_insp_gen BOOL NOT NULL DEFAULT TRUE,
  pref_insp_gen_amt DECIMAL(12,2) NOT NULL DEFAULT 5000,
  pref_is_insp_pest BOOL NOT NULL DEFAULT FALSE,
  pref_is_insp_rad BOOL NOT NULL DEFAULT FALSE,
  pref_is_insp_lead BOOL NOT NULL DEFAULT TRUE,
  pref_insp_cont_dt SMALLINT NOT NULL DEFAULT 8,
  pref_is_financing_req BOOL NOT NULL DEFAULT TRUE,
  pref_fin_cmt_dt SMALLINT NOT NULL DEFAULT 39,
  pref_fin_appl_dt SMALLINT NOT NULL DEFAULT 11,
  pref_is_contingency BOOL NOT NULL DEFAULT FALSE,
  pref_add_terms VARCHAR(255),
  pref_last_edit_date TIMESTAMP,
  pref_form_family ENUM( ) NOT NULL,
  creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (usr_id),
  CONSTRAINT FK_Pref_usr_id FOREIGN KEY(usr_id) REFERENCES User(usr_id)
);

CREATE TABLE OfferDetails (
  ofr_det_id INTEGER NOT NULL AUTO_INCREMENT,
  ofr_det_amount DECIMAL(12,2),
  ofr_det_deposit DECIMAL(12,2),
  ofr_det_pns_deposit DECIMAL(12,2),
  ofr_det_financed DECIMAL(12, 2),
  ofr_det_concession DECIMAL(12,2),
  ofr_det_exp_dt DATETIME,
  ofr_det_pns_sign_dt DATETIME,
  ofr_det_cls_dt DATETIME,
  ofr_det_is_inspection_req BOOL NOT NULL DEFAULT FALSE,
  ofr_det_is_insp_gen BOOL NOT NULL DEFAULT FALSE,
  ofr_det_insp_gen_amt DECIMAL(12,2),
  ofr_det_is_insp_pest BOOL NOT NULL DEFAULT FALSE,
  ofr_det_is_insp_rad BOOL NOT NULL DEFAULT FALSE,
  ofr_det_is_insp_lead BOOL NOT NULL DEFAULT FALSE,
  ofr_det_insp_cont_dt DATETIME NOT NULL,
  ofr_det_cont_notice DATETIME,
  ofr_det_is_financing_req BOOL DEFAULT FALSE,
  ofr_det_fin_cmt_dt DATETIME,
  ofr_det_fin_appl_dt DATETIME,
  ofr_is_contingency BOOL,
  ofr_add_terms VARCHAR(255),
  ofr_buyer_agency_rights BOOL NOT NULL DEFAULT FALSE,
  ofr_seller_agency_rights BOOL NOT NULL DEFAULT FALSE,
  creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (ofr_det_id)
);

CREATE TABLE User (
  usr_id INTEGER NOT NULL auto_increment,
  usr_email VARCHAR(35) NOT NULL,
  usr_ph_number Varchar(20),
  usr_auth_pass VARCHAR(50) NOT NULL,
  usr_auth_salt VARCHAR(50) NOT NULL,
  usr_last_login  DATETIME,
  creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (usr_id)
);

CREATE TABLE UserProperty (
  usr_id INTEGER NOT NULL,
  prop_id INTEGER NOT NULL,
  creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (prop_id),
  PRIMARY KEY (usr_id),
  CONSTRAINT FK_UP_usr_id FOREIGN KEY(usr_id) REFERENCES User(usr_id),
	CONSTRAINT FK_prop_id FOREIGN KEY(prop_id) REFERENCES Property(prop_id)
);

CREATE TABLE Token (
  tkn_id INTEGER NOT NULL AUTO_INCREMENT,
  tkn_identifier VARCHAR(35) NOT NULL,
  tkn_hash_code VARCHAR(6) NOT NULL,
  tkn_type ENUM(MOB,EML) NOT NULL,
  tkn_atmpt_count SMALLINT NOT NULL DEFAULT 0,
  tkn_status ENUM(SNT, CEX, EXP) NOT NULL,
  tkn_expire_date DATETIME NOT NULL,
  creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (tkn_id)
);

CREATE TABLE Form (
  form_id INTEGER NOT NULL AUTO_INCREMENT,
  ft_id INTEGER NOT NULL,
  form_source MEDIUMBLOB NOT NULL,
  form_name VARCHAR(60) NOT NULL,
  form_family VARCHAR(50),
  creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (form_id),
  CONSTRAINT FK_Form_ft_id FOREIGN KEY(ft_id) REFERENCES FormType(ft_id)
);

CREATE TABLE OfferContingency (
  ofr_id INTEGER NOT NULL,
  ctg_id INTEGER NOT NULL,
  ofr_ctg_note VARCHAR(150),
  creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (ofr_id),
  PRIMARY KEY (ctg_id),
  /*ME: syntax incorrect for combined primary key
  ADD CONSTRAINT uq_yourtablename UNIQUE(column1, column2);*/
  CONSTRAINT FK_OC_ofr_id FOREIGN KEY(ofr_id) REFERENCES Offer(ofr_id),
  CONSTRAINT FK_ctg_id FOREIGN KEY(ctg_id) REFERENCES Contingency(ctg_id)
);

CREATE TABLE Contingency (
  ctg_id INTEGER NOT NULL AUTO_INCREMENT,
  ctg_name VARCHAR(20) NOT NULL,
  ctg_desc VARCHAR(255),
  ctg_value BOOL NOT NULL DEFAULT TRUE,
  creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (ctg_id)
);

CREATE TABLE OfferForm (
  ofr_id INTEGER NOT NULL AUTO_INCREMENT,
  form_id INTEGER NOT NULL,
  creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (ofr_id),
  PRIMARY KEY (form_id),
  CONSTRAINT FK_OF_ofr_id FOREIGN KEY(ofr_id) REFERENCES Offer(ofr_id),
  CONSTRAINT FK_form_id FOREIGN KEY(form_id) REFERENCES Form(form_id)
);

CREATE TABLE UserContingency (
  usr_id INTEGER NOT NULL,
  ctg_id INTEGER NOT NULL,
  creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (usr_id),
  PRIMARY KEY (ctg_id),
  /* Syntax for two primaries*/
  CONSTRAINT FK_UC_usr_id FOREIGN KEY(usr_id) REFERENCES User(usr_id),
  CONSTRAINT FK_ctg_id FOREIGN KEY(ctg_id) REFERENCES Contingency(ctg_id)
);

CREATE TABLE FieldMapping (
  fld_map_id INTEGER NOT NULL,
  form_id INTEGER NOT NULL,
  field_type_id INTEGER NOT NULL,
  fld_map_page SMALLINT NOT NULL,
  fld_map_pos_x SMALLINT NOT NULL,
  fld_map_pos_y SMALLINT NOT NULL,
  creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (fld_map_id),
  CONSTRAINT FK_field_type_id FOREIGN KEY(field_type_id) REFERENCES FieldType(field_type_id),
  CONSTRAINT FK_form_id FOREIGN KEY(form_id) REFERENCES Form(form_id)
);

CREATE TABLE FieldType (
  field_type_id INTEGER NOT NULL,
  field_type_source VARCHAR(50) NOT NULL,
  field_type_desc VARCHAR(255),
  field_type_is_editable BOOL NOT NULL,
  creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (field_type_id )
);

CREATE TABLE UserContact (
  usr_id INTEGER NOT NULL,
  uc_contact_id INTEGER NOT NULL,
  creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (usr_id),
  PRIMARY KEY (uc_contact_id),
  CONSTRAINT FK_Ucontact_usr_id FOREIGN KEY(usr_id) REFERENCES User(usr_id),
  /*CONSTRAINT FK_uc_contact_id FOREIGN KEY(uc_contact_id) REFERENCES (uc_contact_id)*/
);

CREATE TABLE UserOffer (
  usr_id INTEGER NOT NULL,
  ofr_id INTEGER NOT NULL,
  u_ofr_role ENUM('B', 'B_A', 'S', 'S_A') NOT NULL,
  u_ofr_view_count SMALLINT NOT NULL,
  u_ofr_last_view TIMESTAMP,
  u_ofr_is_archived BOOLEAN NOT NULL DEFAULT FALSE,
  creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (usr_id),
  PRIMARY KEY (ofr_id),
  CONSTRAINT FK_UO_usr_id FOREIGN KEY(usr_id) REFERENCES User(usr_id),
  CONSTRAINT FK_UO_ofr_id FOREIGN KEY(ofr_id) REFERENCES Offer(ofr_id)
);

CREATE TABLE Property (
  prop_id INTEGER,
  reso_property_key INTEGER,
  prop_mls INTEGER,
  prop_zillow_id INTEGER,
  prop_street_name VARCHAR(20),
  prop_street_num INTEGER,
  prop_city VARCHAR(20),
  prop_state VARCHAR(20),
  prop_zip VARCHAR(8),
  prop_list_price DECIMAL(12,2),
  creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (prop_id)
  /*CONSTRAINT FK_prop_mls FOREIGN KEY(prop_mls) REFERENCES (prop_mls)*/
);




