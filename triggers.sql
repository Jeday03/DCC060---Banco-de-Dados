-- Cria a trigger que adiciona o consumidor como premium se ele comprar mais de 5 jogos
CREATE OR REPLACE FUNCTION check_premium() RETURNS TRIGGER AS $$
DECLARE
    total_jogos INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_jogos 
    FROM jogo_comprado 
    WHERE id_consumidor = NEW.id_consumidor;

    IF total_jogos > 5 THEN
        UPDATE consumidor
        SET eh_premium = TRUE
        WHERE id_consumidor = NEW.id_consumidor;

        RAISE NOTICE 'Consumidor % agora é premium.', NEW.id_consumidor;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_premium
    AFTER INSERT ON jogo_comprado
    FOR EACH ROW
    EXECUTE FUNCTION check_premium();

-- Cria a trigger que adiciona a platina se o jogo comprado tiver todas as conquistas
CREATE OR REPLACE FUNCTION check_conquista() RETURNS TRIGGER AS $$
DECLARE
    total_conquistas INTEGER;
    conquistas_conquistadas INTEGER;
BEGIN
    SELECT count(*) into total_conquistas
    FROM conquista 
    WHERE id_jogo = NEW.id_jogo_comprado;

    SELECT COUNT(*) into conquistas_conquistadas
    FROM jogo_comprado_conquista 
    WHERE id_jogo_comprado = NEW.id_jogo_comprado;

    UPDATE jogo_comprado
    SET porcentagem_conquista = (conquistas_conquistadas::DECIMAL / total_conquistas) * 100
    WHERE id_jogo_comprado = NEW.id_jogo_comprado;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_conquista
    AFTER INSERT ON jogo_comprado_conquista
    FOR EACH ROW
    EXECUTE FUNCTION check_conquista();