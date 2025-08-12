CREATE SCHEMA IF NOT EXISTS public;


CREATE TABLE IF NOT EXISTS public.pais (
    id_pais INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    porcentagem_imposto NUMERIC(5,2) NOT NULL,
    simbolo_moeda VARCHAR(10) NOT NULL,
    razao_cambio NUMERIC(12,6) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.usuario (
    id_usuario INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    id_pais INT NOT NULL REFERENCES public.pais(id_pais) ON DELETE RESTRICT,
    nickname VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.consumidor (
    id_consumidor INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE REFERENCES public.usuario(id_usuario) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS public.desenvolvedora (
    id_desenvolvedora INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE REFERENCES public.usuario(id_usuario) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS public.publicadora (
    id_publicadora INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE REFERENCES public.usuario(id_usuario) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS public.metodo_pagamento (
    id_metodo_pagamento INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_consumidor INT NOT NULL REFERENCES public.consumidor(id_consumidor) ON DELETE CASCADE,
    apelido VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.pagamento_cartao_credito (
    id_metodo_pagamento INT PRIMARY KEY REFERENCES public.metodo_pagamento(id_metodo_pagamento) ON DELETE CASCADE,
    numero_cartao VARCHAR(20) NOT NULL,
    nome_titular VARCHAR(100) NOT NULL,
    data_validade DATE NOT NULL,
    codigo_seguranca VARCHAR(4) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.pagamento_boleto (
    id_metodo_pagamento INT PRIMARY KEY REFERENCES public.metodo_pagamento(id_metodo_pagamento) ON DELETE CASCADE,
    numero_boleto VARCHAR(30) NOT NULL,
    data_vencimento DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS public.pagamento_pix (
    id_metodo_pagamento INT PRIMARY KEY REFERENCES public.metodo_pagamento(id_metodo_pagamento) ON DELETE CASCADE,
    chave_pix VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.metodo_recebimento (
    id_metodo_recebimento INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.recebimento_banco (
    id_metodo_recebimento INT PRIMARY KEY REFERENCES public.metodo_recebimento(id_metodo_recebimento) ON DELETE CASCADE,
    numero_conta VARCHAR(20) NOT NULL,
    agencia VARCHAR(10) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.recebimento_pix (
    id_metodo_recebimento INT PRIMARY KEY REFERENCES public.metodo_recebimento(id_metodo_recebimento) ON DELETE CASCADE,
    chave_pix VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.jogo (
    id_jogo INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    preco_dolar NUMERIC(10,2) NOT NULL,
    foto_capa VARCHAR(255) NOT NULL,
    id_desenvolvedora INT NOT NULL REFERENCES public.desenvolvedora(id_desenvolvedora) ON DELETE RESTRICT,
    id_publicadora INT REFERENCES public.publicadora(id_publicadora) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS public.jogo_comprado (
    id_jogo_comprado INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_consumidor INT NOT NULL REFERENCES public.consumidor(id_consumidor) ON DELETE CASCADE,
    id_jogo INT NOT NULL REFERENCES public.jogo(id_jogo) ON DELETE RESTRICT,
    data_compra TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    id_metodo_pagamento INT NOT NULL REFERENCES public.metodo_pagamento(id_metodo_pagamento) ON DELETE RESTRICT,
    UNIQUE (id_consumidor, id_jogo)
);

CREATE TABLE IF NOT EXISTS public.conquista (
    id_conquista INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    descricao TEXT
);

CREATE TABLE IF NOT EXISTS public.jogo_comprado_conquista (
    id_jogo_comprado INT NOT NULL REFERENCES public.jogo_comprado(id_jogo_comprado) ON DELETE CASCADE,
    id_conquista INT NOT NULL REFERENCES public.conquista(id_conquista) ON DELETE CASCADE,
    PRIMARY KEY (id_jogo_comprado, id_conquista)
);

CREATE TABLE IF NOT EXISTS public.comentario (
    id_consumidor INT NOT NULL REFERENCES public.consumidor(id_consumidor) ON DELETE CASCADE,
    id_jogo INT NOT NULL REFERENCES public.jogo(id_jogo) ON DELETE CASCADE,
    texto TEXT NOT NULL,
    data_comentario TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    PRIMARY KEY (id_consumidor, id_jogo)
);

CREATE TABLE IF NOT EXISTS public.recebimento (
    id_recebimento INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_publicadora INT NOT NULL REFERENCES public.publicadora(id_publicadora) ON DELETE CASCADE,
    id_metodo_recebimento INT NOT NULL REFERENCES public.metodo_recebimento(id_metodo_recebimento) ON DELETE RESTRICT,
    data_recebimento TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    valor NUMERIC(10,2) NOT NULL
);
