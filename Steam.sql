CREATE TABLE Pais (
    id_pais INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);


CREATE TABLE Usuario (
    id_usuario INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    id_pais INT NOT NULL,
    FOREIGN KEY (id_pais) REFERENCES Pais(id_pais)
);


CREATE TABLE Consumidor (
    id_consumidor INT PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);


CREATE TABLE Desenvolvedora (
    id_desenvolvedora INT PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);


CREATE TABLE Publicadora (
    id_publicadora INT PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);


CREATE TABLE MetodoPagamento (
    id_metodo_pagamento INT PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL
);


CREATE TABLE MetodoRecebimento (
    id_metodo_recebimento INT PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL
);


CREATE TABLE Jogo (
    id_jogo INT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    id_desenvolvedora INT NOT NULL,
    id_publicadora INT,
    FOREIGN KEY (id_desenvolvedora) REFERENCES Desenvolvedora(id_desenvolvedora),
    FOREIGN KEY (id_publicadora) REFERENCES Publicadora(id_publicadora)
);


CREATE TABLE Compra (
    id_compra INT PRIMARY KEY,
    id_consumidor INT NOT NULL,
    id_jogo INT NOT NULL,
    id_metodo_pagamento INT NOT NULL,
    data_compra DATE NOT NULL,
    FOREIGN KEY (id_consumidor) REFERENCES Consumidor(id_consumidor),
    FOREIGN KEY (id_jogo) REFERENCES Jogo(id_jogo),
    FOREIGN KEY (id_metodo_pagamento) REFERENCES MetodoPagamento(id_metodo_pagamento)
);


CREATE TABLE Conquista (
    id_conquista INT PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    descricao TEXT
);


CREATE TABLE Consumidor_Conquista (
    id_consumidor INT NOT NULL,
    id_conquista INT NOT NULL,
    PRIMARY KEY (id_consumidor, id_conquista),
    FOREIGN KEY (id_consumidor) REFERENCES Consumidor(id_consumidor),
    FOREIGN KEY (id_conquista) REFERENCES Conquista(id_conquista)
);


CREATE TABLE Comentario (
    id_comentario INT PRIMARY KEY,
    id_consumidor INT NOT NULL,
    id_jogo INT NOT NULL,
    texto TEXT NOT NULL,
    data_comentario DATE NOT NULL,
    FOREIGN KEY (id_consumidor) REFERENCES Consumidor(id_consumidor),
    FOREIGN KEY (id_jogo) REFERENCES Jogo(id_jogo)
);


CREATE TABLE Recebimento (
    id_recebimento INT PRIMARY KEY,
    id_publicadora INT NOT NULL,
    id_metodo_recebimento INT NOT NULL,
    data_recebimento DATE NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_publicadora) REFERENCES Publicadora(id_publicadora),
    FOREIGN KEY (id_metodo_recebimento) REFERENCES MetodoRecebimento(id_metodo_recebimento)
);
