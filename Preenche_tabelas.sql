
INSERT INTO pais (id_pais, nome, porcentagem_imposto, simbolo_moeda, razao_cambio) VALUES
(1, 'Brasil', 15.00, 'R$', 5.2500),
(2, 'Estados Unidos', 7.50, 'US$', 1.0000);


INSERT INTO usuario (id_usuario, nome, id_pais, nickname, email, senha) VALUES
(1, 'João Silva', 1, 'joaos', 'joao@email.com', 'senha123'),
(2, 'Maria Souza', 1, 'marias', 'maria@email.com', 'senha123'),
(3, 'Lucas Lima', 2, 'lucasl', 'lucas@email.com', 'senha123');


INSERT INTO consumidor (id_consumidor, id_usuario) VALUES (1, 1);
INSERT INTO desenvolvedora (id_desenvolvedora, id_usuario) VALUES (1, 2);
INSERT INTO publicadora (id_publicadora, id_usuario) VALUES (1, 3);


INSERT INTO metodo_pagamento (id_metodo_pagamento, id_consumidor, apelido) VALUES
(1, 1, 'Meu cartão'),
(2, 1, 'Boleto bancário'),
(3, 1, 'Pix principal');


INSERT INTO pagamento_cartao_credito (id_metodo_pagamento, numero_cartao, nome_titular, data_validade, codigo_seguranca) VALUES
(1, '1234567890123456', 'João Silva', '2027-12-01', '123');

INSERT INTO pagamento_boleto (id_metodo_pagamento, numero_boleto, data_vencimento) VALUES
(2, '237933812...', '2025-08-15');

INSERT INTO pagamento_pix (id_metodo_pagamento, chave_pix) VALUES
(3, 'joao@pix.com');


INSERT INTO metodo_recebimento (id_metodo_recebimento, tipo) VALUES
(1, 'Banco'),
(2, 'Pix');


INSERT INTO recebimento_banco (id_metodo_recebimento, numero_conta, agencia) VALUES
(1, '00123456-7', '0001');

INSERT INTO recebimento_pix (id_metodo_recebimento, chave_pix) VALUES
(2, 'publicadora@pix.com');


INSERT INTO jogo (id_jogo, titulo, preco_dolar, foto_capa, id_desenvolvedora, id_publicadora) VALUES
(1, 'Jogo A', 59.99, 'capa_jogo_a.jpg', 1, 1),
(2, 'Jogo B', 29.99, 'capa_jogo_b.jpg', 1, 1);


INSERT INTO jogo_comprado (id_jogo_comprado, id_consumidor, id_jogo, data_compra, id_metodo_pagamento) VALUES
(1, 1, 1, '2025-08-07', 1),
(2, 1, 2, '2025-08-07', 3);


INSERT INTO conquista (id_conquista, nome, descricao) VALUES
(1, 'Primeira vitória', 'Ganhou sua primeira partida'),
(2, 'Maratonista', 'Jogou por 10 horas seguidas');


INSERT INTO jogo_comprado_conquista (id_jogo_comprado, id_conquista, id_consumidor) VALUES
(1, 1, 1),
(2, 2, 1);


INSERT INTO comentario (id_consumidor, id_jogo, texto, data_comentario) VALUES
(1, 1, 'Jogo muito bom!', '2025-08-07'),
(1, 2, 'Achei mediano.', '2025-08-07');


INSERT INTO recebimento (id_recebimento, id_publicadora, id_metodo_recebimento, data_recebimento, valor) VALUES
(1, 1, 1, '2025-08-07', 45.00),
(2, 1, 2, '2025-08-07', 25.00);
