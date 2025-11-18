go
CREATE TABLE Equipamento
(
	Auto_Codigo int IDENTITY(1,1) NOT NULL,
	Nome varchar(200) NULL,
	Tipo_Aquisicao varchar(30) NULL,
	Data_Compra datetime NULL,
	Data_Garantia datetime NULL,
	Setor varchar(120) NULL,
	Marca varchar(50) NULL,
	Observacao varchar(200) NULL,
	Status varchar(30) NULL
)
Go
Go
ALTER TABLE Equipamento ADD CONSTRAINT
	PK_Equipamento PRIMARY KEY CLUSTERED 
	(
		Auto_Codigo
	) ON [PRIMARY]
Go
go
CREATE TABLE SOFTWARE
(
	Auto_Codigo int IDENTITY(1,1) NOT NULL,
	Nome varchar(200) NULL,
	Tipo_Software varchar(50) NULL,
	Tipo_Licenca varchar(30) NULL,
	Marca varchar(50) NULL,
	Observacao varchar(200) NULL,
	Status varchar(30) NULL
)
Go
Go
ALTER TABLE SOFTWARE ADD CONSTRAINT
	PK_SOFTWARE PRIMARY KEY CLUSTERED 
	(
		Auto_Codigo
	) ON [PRIMARY]
Go
go
CREATE TABLE SOFTWARE_LICENCA
(
	Auto_Codigo int IDENTITY(1,1) NOT NULL,
	Auto_Codigo_Software int,
	Nome varchar(200) NULL,
	Chave varchar(100) NULL,
	Data_Compra datetime NULL,
	Data_Suporte datetime NULL,	
	Observacao varchar(200) NULL,
	Status varchar(30) NULL
)
Go
Go
ALTER TABLE SOFTWARE_LICENCA ADD CONSTRAINT
	PK_SOFTWARE_LICENCA PRIMARY KEY CLUSTERED 
	(
		Auto_Codigo
	) ON [PRIMARY]
Go
go
CREATE TABLE AUX_EQUIPAMENTO_LICENCA
(
	Auto_Codigo int IDENTITY(1,1) NOT NULL,
	Auto_Codigo_Software int,
	Auto_Codigo_Software_Licenca int,
	Auto_Codigo_Equipamento int,
	Data DateTime,
	Observacao varchar(200) NULL,
)
Go
Go
ALTER TABLE AUX_EQUIPAMENTO_LICENCA ADD CONSTRAINT
	PK_AUX_EQUIPAMENTO_LICENCA PRIMARY KEY CLUSTERED 
	(
		Auto_Codigo
	) ON [PRIMARY]
Go
