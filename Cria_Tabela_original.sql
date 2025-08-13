CREATE TABLE pais (
    id_pais INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    porcentagem_imposto DECIMAL(5,2) NOT NULL,
    simbolo_moeda VARCHAR(10) NOT NULL,
    razao_cambio DECIMAL(10,4) NOT NULL
);

CREATE TABLE usuario (
    id_usuario INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    id_pais INT NOT NULL,
    nickname VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_pais) REFERENCES pais(id_pais)
);


CREATE TABLE consumidor (
    id_consumidor INT PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    eh_premium BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);


CREATE TABLE desenvolvedora (
    id_desenvolvedora INT PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);


CREATE TABLE publicadora (
    id_publicadora INT PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);


CREATE TABLE metodo_pagamento (
    id_metodo_pagamento SERIAL PRIMARY KEY,
    id_consumidor INT NOT NULL,
    apelido VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_consumidor) REFERENCES consumidor(id_consumidor)
);

CREATE TABLE pagamento_cartao_credito (
    id_metodo_pagamento INT NOT NULL UNIQUE,
    numero_cartao VARCHAR(20) NOT NULL,
    nome_titular VARCHAR(100) NOT NULL,
    data_validade DATE NOT NULL,
    codigo_seguranca VARCHAR(4) NOT NULL,
    FOREIGN KEY (id_metodo_pagamento) REFERENCES metodo_pagamento(id_metodo_pagamento)
);

CREATE TABLE pagamento_boleto (
    id_metodo_pagamento INT NOT NULL UNIQUE,
    numero_boleto VARCHAR(20) NOT NULL,
    data_vencimento DATE NOT NULL,
    FOREIGN KEY (id_metodo_pagamento) REFERENCES metodo_pagamento(id_metodo_pagamento)
);

CREATE TABLE pagamento_pix (
    id_metodo_pagamento INT NOT NULL UNIQUE,
    chave_pix VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_metodo_pagamento) REFERENCES metodo_pagamento(id_metodo_pagamento)
);

CREATE TABLE metodo_recebimento (
    id_metodo_recebimento INT PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL
);

CREATE TABLE recebimento_banco (
    id_metodo_recebimento INT NOT NULL UNIQUE,
    numero_conta VARCHAR(20) NOT NULL,
    agencia VARCHAR(10) NOT NULL,
    FOREIGN KEY (id_metodo_recebimento) REFERENCES metodo_recebimento(id_metodo_recebimento)
);

CREATE TABLE recebimento_pix (
    id_metodo_recebimento INT NOT NULL UNIQUE,
    chave_pix VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_metodo_recebimento) REFERENCES metodo_recebimento(id_metodo_recebimento)
);

CREATE TABLE jogo (
    id_jogo INT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    preco_dolar DECIMAL(10,2) NOT NULL,
    foto_capa VARCHAR(255) NOT NULL, -- Caminho para a imagem da capa do jogo
    id_desenvolvedora INT NOT NULL,
    id_publicadora INT,
    descricao TEXT,
    FOREIGN KEY (id_desenvolvedora) REFERENCES desenvolvedora(id_desenvolvedora),
    FOREIGN KEY (id_publicadora) REFERENCES publicadora(id_publicadora)
);


CREATE TABLE jogo_comprado (
    id_jogo_comprado INT PRIMARY KEY,
    id_consumidor INT NOT NULL, -- tava faltando declarar o consumidor
    id_jogo INT NOT NULL,
    data_compra DATE NOT NULL,
    id_metodo_pagamento INT NOT NULL,
    porcentagem_conquista DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    FOREIGN KEY (id_consumidor) REFERENCES consumidor(id_consumidor),
    FOREIGN KEY (id_jogo) REFERENCES jogo(id_jogo),
    FOREIGN KEY (id_metodo_pagamento) REFERENCES metodo_pagamento(id_metodo_pagamento)
);


CREATE TABLE conquista (
    id_conquista INT PRIMARY KEY,
    id_jogo INT NOT NULL,
    nome VARCHAR(200) NOT NULL,
    descricao TEXT,
    FOREIGN KEY (id_jogo) REFERENCES jogo(id_jogo)
);

CREATE TABLE jogo_comprado_conquista (
    id_jogo_comprado INT NOT NULL,
    id_conquista INT NOT NULL,
    --id_consumidor INT NOT NULL, testando se é necessário
    PRIMARY KEY (id_jogo_comprado, id_conquista),
    FOREIGN KEY (id_jogo_comprado) REFERENCES jogo_comprado(id_jogo_comprado),
    --FOREIGN KEY (id_consumidor) REFERENCES consumidor(id_consumidor),
    FOREIGN KEY (id_conquista) REFERENCES conquista(id_conquista)
);


CREATE TABLE comentario (
    id_consumidor INT NOT NULL,
    id_jogo INT NOT NULL,
    texto TEXT NOT NULL,
    data_comentario DATE NOT NULL,
    PRIMARY KEY (id_consumidor, id_jogo), -- Chave primária composta para impedir 2 comentários do mesmo consumidor no mesmo jogo
    FOREIGN KEY (id_consumidor) REFERENCES consumidor(id_consumidor),
    FOREIGN KEY (id_jogo) REFERENCES jogo(id_jogo)
);

CREATE TABLE recebimento (
    id_recebimento INT PRIMARY KEY,
    id_publicadora INT NOT NULL,
    id_metodo_recebimento INT NOT NULL,
    data_recebimento DATE NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_publicadora) REFERENCES publicadora(id_publicadora),
    FOREIGN KEY (id_metodo_recebimento) REFERENCES metodo_recebimento(id_metodo_recebimento)
);

CREATE TABLE amizade (
    id_usuario1 INT NOT NULL,
    id_usuario2 INT NOT NULL,
    PRIMARY KEY (id_usuario1, id_usuario2),
    FOREIGN KEY (id_usuario1) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_usuario2) REFERENCES usuario(id_usuario)
);

CREATE TABLE carrinho_compras (
    id_consumidor INT NOT NULL UNIQUE,
    id_jogo INT NOT NULL,
    PRIMARY KEY (id_consumidor, id_jogo),
    FOREIGN KEY (id_consumidor) REFERENCES consumidor(id_consumidor),
    FOREIGN KEY (id_jogo) REFERENCES jogo(id_jogo)
);

--Tá certo isso aqui? Não seria em conjunto com a tabela de Publicadora?
-- Acho que ta, pq é um relacionamento N:N entre Publicadora e Método de Recebimento né? Aí cada uma tem q ter sua tabela
-- Joguei pro final pq o neon é bugado e não deixava criar a tabela se tiver comentario antes