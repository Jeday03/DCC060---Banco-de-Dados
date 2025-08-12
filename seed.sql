INSERT INTO pais (nome, porcentagem_imposto, simbolo_moeda, razao_cambio) VALUES
('Brasil', 15.00, 'R$', 5.250000),
('Estados Unidos', 7.50, 'US$', 1.000000);

INSERT INTO usuario (nome, id_pais, nickname, email, senha) VALUES
('João Silva', 1, 'joaos', 'joao@email.com', 'senha123'),
('Maria Souza', 1, 'marias', 'maria@email.com', 'senha123'),
('Lucas Lima', 2, 'lucasl', 'lucas@email.com', 'senha123');

INSERT INTO consumidor (id_usuario) VALUES (1);
INSERT INTO desenvolvedora (id_usuario) VALUES (2);
INSERT INTO publicadora (id_usuario) VALUES (3);

INSERT INTO metodo_pagamento (id_consumidor, apelido) VALUES
(1, 'Meu cartão'),
(1, 'Boleto bancário'),
(1, 'Pix principal');

INSERT INTO pagamento_cartao_credito (id_metodo_pagamento, numero_cartao, nome_titular, data_validade, codigo_seguranca) VALUES
(1, '1234567890123456', 'João Silva', '2027-12-01', '123');

INSERT INTO pagamento_boleto (id_metodo_pagamento, numero_boleto, data_vencimento) VALUES
(2, '237933812...', '2025-08-15');

INSERT INTO pagamento_pix (id_metodo_pagamento, chave_pix) VALUES
(3, 'joao@pix.com');

INSERT INTO metodo_recebimento (tipo) VALUES ('Banco'), ('Pix');

INSERT INTO recebimento_banco (id_metodo_recebimento, numero_conta, agencia) VALUES
(1, '00123456-7', '0001');

INSERT INTO recebimento_pix (id_metodo_recebimento, chave_pix) VALUES
(2, 'publicadora@pix.com');

INSERT INTO jogo (titulo, preco_dolar, foto_capa, id_desenvolvedora, id_publicadora) VALUES
('Jogo A', 59.99, 'capa_jogo_a.jpg', 1, 1),
('Jogo B', 29.99, 'capa_jogo_b.jpg', 1, 1);

INSERT INTO jogo_comprado (id_consumidor, id_jogo, id_metodo_pagamento) VALUES
(1, 1, 1),
(1, 2, 3);

INSERT INTO conquista (nome, descricao) VALUES
('Primeira vitória', 'Ganhou sua primeira partida'),
('Maratonista', 'Jogou por 10 horas seguidas');

INSERT INTO jogo_comprado_conquista (id_jogo_comprado, id_conquista) VALUES
(1, 1),
(2, 2);

INSERT INTO comentario (id_consumidor, id_jogo, texto) VALUES
(1, 1, 'Jogo muito bom!'),
(1, 2, 'Achei mediano.');

INSERT INTO recebimento (id_publicadora, id_metodo_recebimento, valor) VALUES
(1, 1, 45.00),
(1, 2, 25.00);
