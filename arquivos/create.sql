/*================================================================================*/
/* DDL SCRIPT                                                                     */
/*================================================================================*/
/*  Title    :                                                                    */
/*  FileName : sale.ecm                                                           */
/*  Platform : PostgreSQL 9.4                                                     */
/*  Version  : Concept                                                            */
/*  Date     : quarta-feira, 21 de julho de 2021                                  */
/*================================================================================*/
/*================================================================================*/
/* CREATE SEQUENCES                                                               */
/*================================================================================*/

CREATE SEQUENCE public.branch_id_seq START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647;

CREATE SEQUENCE public.city_id_seq START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647;

CREATE SEQUENCE public.customer_id_seq START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647;

CREATE SEQUENCE public.department_id_seq START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647;

CREATE SEQUENCE public.district_id_seq START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647;

CREATE SEQUENCE public.employee_id_seq START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647;

CREATE SEQUENCE public.marital_status_id_seq START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647;

CREATE SEQUENCE public.product_group_id_seq START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647;

CREATE SEQUENCE public.product_id_seq START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647;

CREATE SEQUENCE public.sale_id_seq START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647;

CREATE SEQUENCE public.sale_item_id_seq START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647;

CREATE SEQUENCE public.state_id_seq START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647;

CREATE SEQUENCE public.supplier_id_seq START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647;

CREATE SEQUENCE public.zone_id_seq START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647;

/*================================================================================*/
/* CREATE TABLES                                                                  */
/*================================================================================*/

CREATE TABLE public.state (
  id INTEGER DEFAULT nextval('state_id_seq'::regclass) NOT NULL,
  name VARCHAR(64) NOT NULL,
  abbreviation CHAR(2) NOT NULL,
  CONSTRAINT PK_state PRIMARY KEY (id)
);

CREATE TABLE public.city (
  id INTEGER DEFAULT nextval('city_id_seq'::regclass) NOT NULL,
  id_state INTEGER NOT NULL,
  name VARCHAR(64) NOT NULL,
  CONSTRAINT PK_city PRIMARY KEY (id)
);

CREATE TABLE public.zone (
  id INTEGER DEFAULT nextval('zone_id_seq'::regclass) NOT NULL,
  name VARCHAR(64) NOT NULL,
  CONSTRAINT PK_zone PRIMARY KEY (id)
);

CREATE TABLE public.district (
  id INTEGER DEFAULT nextval('district_id_seq'::regclass) NOT NULL,
  id_city INTEGER NOT NULL,
  id_zone INTEGER NOT NULL,
  name VARCHAR(64) NOT NULL,
  CONSTRAINT PK_district PRIMARY KEY (id)
);

CREATE TABLE public.branch (
  id INTEGER DEFAULT nextval('branch_id_seq'::regclass) NOT NULL,
  id_district INTEGER NOT NULL,
  name VARCHAR(64) NOT NULL,
  CONSTRAINT PK_branch PRIMARY KEY (id)
);

CREATE TABLE public.marital_status (
  id INTEGER DEFAULT nextval('marital_status_id_seq'::regclass) NOT NULL,
  name VARCHAR(64) NOT NULL,
  CONSTRAINT PK_marital_status PRIMARY KEY (id)
);

CREATE TABLE public.customer (
  id INTEGER DEFAULT nextval('customer_id_seq'::regclass) NOT NULL,
  id_district INTEGER NOT NULL,
  id_marital_status INTEGER NOT NULL,
  name VARCHAR(64) NOT NULL,
  income NUMERIC(16,2) NOT NULL,
  gender CHAR(1) NOT NULL,
  CONSTRAINT PK_customer PRIMARY KEY (id)
);

CREATE TABLE public.department (
  id INTEGER DEFAULT nextval('department_id_seq'::regclass) NOT NULL,
  name VARCHAR(64) NOT NULL,
  CONSTRAINT PK_department PRIMARY KEY (id)
);

CREATE TABLE public.employee (
  id INTEGER DEFAULT nextval('employee_id_seq'::regclass) NOT NULL,
  id_department INTEGER NOT NULL,
  id_district INTEGER NOT NULL,
  id_marital_status INTEGER NOT NULL,
  name VARCHAR(64) NOT NULL,
  salary NUMERIC(16,2) NOT NULL,
  admission_date DATE NOT NULL,
  birth_date DATE NOT NULL,
  gender CHAR(1) NOT NULL,
  CONSTRAINT PK_employee PRIMARY KEY (id)
);

CREATE TABLE public.supplier (
  id INTEGER DEFAULT nextval('supplier_id_seq'::regclass) NOT NULL,
  name VARCHAR(64) NOT NULL,
  legal_document VARCHAR(20) NOT NULL,
  CONSTRAINT PK_supplier PRIMARY KEY (id)
);

CREATE TABLE public.product_group (
  id INTEGER DEFAULT nextval('product_group_id_seq'::regclass) NOT NULL,
  name VARCHAR(64) NOT NULL,
  commission_percentage NUMERIC(5,2) NOT NULL,
  gain_percentage NUMERIC(5,2) NOT NULL,
  CONSTRAINT PK_product_group PRIMARY KEY (id)
);

CREATE TABLE public.product (
  id INTEGER DEFAULT nextval('product_id_seq'::regclass) NOT NULL,
  id_product_group INTEGER NOT NULL,
  id_supplier INTEGER NOT NULL,
  name VARCHAR(64) NOT NULL,
  cost_price NUMERIC(16,2) NOT NULL,
  sale_price NUMERIC(16,2) NOT NULL,
  CONSTRAINT PK_product PRIMARY KEY (id)
);

CREATE TABLE public.sale (
  id INTEGER DEFAULT nextval('sale_id_seq'::regclass) NOT NULL,
  id_customer INTEGER NOT NULL,
  id_branch INTEGER NOT NULL,
  id_employee INTEGER NOT NULL,
  date TIMESTAMP(6) NOT NULL,
  CONSTRAINT PK_sale PRIMARY KEY (id)
);

CREATE TABLE public.sale_item (
  id INTEGER DEFAULT nextval('sale_item_id_seq'::regclass) NOT NULL,
  id_sale INTEGER NOT NULL,
  id_product INTEGER NOT NULL,
  quantity NUMERIC(16,3) NOT NULL,
  CONSTRAINT PK_sale_item PRIMARY KEY (id)
);

/*================================================================================*/
/* CREATE INDEXES                                                                 */
/*================================================================================*/

CREATE UNIQUE INDEX AK_state_name ON public.state (name);

CREATE UNIQUE INDEX AK_state_city_name ON public.city (id_state, name);

CREATE UNIQUE INDEX AK_zone_name ON public.zone (name);

CREATE UNIQUE INDEX AK_city_district_name ON public.district (id_city, name);

CREATE UNIQUE INDEX AK_marital_status_name ON public.marital_status (name);

CREATE UNIQUE INDEX AK_department_name ON public.department (name);

CREATE UNIQUE INDEX AK_product_group_name ON public.product_group (name);

CREATE UNIQUE INDEX AK_product_name ON public.product (name);

/*================================================================================*/
/* CREATE FOREIGN KEYS                                                            */
/*================================================================================*/

ALTER TABLE public.city
  ADD CONSTRAINT fk_city_state
  FOREIGN KEY (id_state) REFERENCES public.state (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;

ALTER TABLE public.district
  ADD CONSTRAINT fk_district_city
  FOREIGN KEY (id_city) REFERENCES public.city (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;

ALTER TABLE public.district
  ADD CONSTRAINT fk_district_zone
  FOREIGN KEY (id_zone) REFERENCES public.zone (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;

ALTER TABLE public.branch
  ADD CONSTRAINT fk_branch_district
  FOREIGN KEY (id_district) REFERENCES public.district (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;

ALTER TABLE public.customer
  ADD CONSTRAINT fk_customer_marital_status
  FOREIGN KEY (id_marital_status) REFERENCES public.marital_status (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;

ALTER TABLE public.customer
  ADD CONSTRAINT fk_customer_district
  FOREIGN KEY (id_district) REFERENCES public.district (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;

ALTER TABLE public.employee
  ADD CONSTRAINT fk_employee_department
  FOREIGN KEY (id_department) REFERENCES public.department (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;

ALTER TABLE public.employee
  ADD CONSTRAINT fk_employee_district
  FOREIGN KEY (id_district) REFERENCES public.district (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;

ALTER TABLE public.employee
  ADD CONSTRAINT fk_employee_marital_status
  FOREIGN KEY (id_marital_status) REFERENCES public.marital_status (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;

ALTER TABLE public.product
  ADD CONSTRAINT fk_product_supplier
  FOREIGN KEY (id_supplier) REFERENCES public.supplier (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;

ALTER TABLE public.product
  ADD CONSTRAINT fk_product_product_group
  FOREIGN KEY (id_product_group) REFERENCES public.product_group (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;

ALTER TABLE public.sale
  ADD CONSTRAINT fk_sale_branch
  FOREIGN KEY (id_branch) REFERENCES public.branch (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;

ALTER TABLE public.sale
  ADD CONSTRAINT fk_sale_customer
  FOREIGN KEY (id_customer) REFERENCES public.customer (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;

ALTER TABLE public.sale
  ADD CONSTRAINT fk_sale_employee
  FOREIGN KEY (id_employee) REFERENCES public.employee (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;

ALTER TABLE public.sale_item
  ADD CONSTRAINT fk_sale_item_product
  FOREIGN KEY (id_product) REFERENCES public.product (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;

ALTER TABLE public.sale_item
  ADD CONSTRAINT fk_sale_item_sale
  FOREIGN KEY (id_sale) REFERENCES public.sale (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;



