-- Active: 1709601465263@@127.0.0.1@1521@orcl@JOEUN
CREATE TABLE "users" (
	"user_id"	VARCHAR2(50)		NOT NULL,
	"user_pw"	VARCHAR2(50)		NULL,
	"name"	VARCHAR2(10)		NULL,
	"age"	NUMBER		NULL,
	"job"	VARCHAR2(20)		NULL,
	"grade"	VARCHAR2(20)		NULL,
	"point"	NUMBER		NULL
);

CREATE TABLE "products" (
	"product_no"	NUMBER		NOT NULL,
	"name"	VARCHAR2(50)		NULL,
	"amount"	NUMBER		NULL,
	"price"	NUMBER		NULL
);

CREATE TABLE "orders" (
	"order_no"	NUMBER		NOT NULL,
	"user_id"	VARCHAR2(50)		NOT NULL,
	"product_no"	NUMBER		NOT NULL,
	"amount"	NUMBER		NULL,
	"address"	VARCHAR2(1000)		NULL,
	"order_date"	DATE		NULL
);

ALTER TABLE "users" ADD CONSTRAINT "PK_USERS" PRIMARY KEY (
	"user_id"
);

ALTER TABLE "products" ADD CONSTRAINT "PK_PRODUCTS" PRIMARY KEY (
	"product_no"
);

ALTER TABLE "orders" ADD CONSTRAINT "PK_ORDERS" PRIMARY KEY (
	"order_no"
);

