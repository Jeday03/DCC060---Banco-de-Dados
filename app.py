from flask import Flask, request, jsonify
from db import pool

app = Flask(__name__)

def row_to_dict(cursor, row):
    if row is None:
        return None
    cols = [desc[0] for desc in cursor.description]
    return dict(zip(cols, row))

# ===========================
# Retorna uma lista com todos os jogos cadastrados, incluindo desenvolvedora e publicadora
# ===========================
@app.get("/games")
def list_games():
    with pool.connection() as conn, conn.cursor() as cur:
        cur.execute("""
            SELECT j.id_jogo, j.titulo, j.preco_dolar, j.foto_capa,
                   d.id_desenvolvedora, p.id_publicadora
            FROM jogo j
            JOIN desenvolvedora d ON d.id_desenvolvedora = j.id_desenvolvedora
            LEFT JOIN publicadora p ON p.id_publicadora = j.id_publicadora
            ORDER BY j.id_jogo;
        """)
        rows = cur.fetchall()
        cols = [d[0] for d in cur.description]
        data = [dict(zip(cols, r)) for r in rows]
        return jsonify(data)

# ===========================
# Retorna as informações detalhadas de um jogo específico
# ===========================
@app.get("/games/<int:id_jogo>")
def get_game(id_jogo):
    with pool.connection() as conn, conn.cursor() as cur:
        cur.execute("""
            SELECT j.id_jogo, j.titulo, j.preco_dolar, j.foto_capa,
                   d.id_desenvolvedora, p.id_publicadora
            FROM jogo j
            JOIN desenvolvedora d ON d.id_desenvolvedora = j.id_desenvolvedora
            LEFT JOIN publicadora p ON p.id_publicadora = j.id_publicadora
            WHERE j.id_jogo = %s;
        """, (id_jogo,))
        row = cur.fetchone()
        if not row:
            return jsonify({"error": "Jogo não encontrado"}), 404
        return jsonify(row_to_dict(cur, row))

# ===========================
# Cria um novo usuário no sistema e opcionalmente já o cadastra como consumidor
# ===========================
@app.post("/users")
def create_user():
    data = request.get_json(force=True)
    required = ["nome", "id_pais", "nickname", "email", "senha"]
    if any(k not in data for k in required):
        return jsonify({"error": f"Campos obrigatórios: {required}"}), 400

    make_consumidor = bool(data.get("consumidor", True))  # vira consumidor por padrão

    with pool.connection() as conn, conn.cursor() as cur:
        try:
            cur.execute("""
                INSERT INTO usuario (nome, id_pais, nickname, email, senha)
                VALUES (%s, %s, %s, %s, %s)
                RETURNING id_usuario;
            """, (data["nome"], data["id_pais"], data["nickname"], data["email"], data["senha"]))
            id_usuario = cur.fetchone()[0]

            id_consumidor = None
            if make_consumidor:
                cur.execute("""
                    INSERT INTO consumidor (id_usuario)
                    VALUES (%s) RETURNING id_consumidor;
                """, (id_usuario,))
                id_consumidor = cur.fetchone()[0]

            conn.commit()
            return jsonify({"id_usuario": id_usuario, "id_consumidor": id_consumidor}), 201
        except Exception as e:
            conn.rollback()
            return jsonify({"error": str(e)}), 400

# ===========================
# Verifica as credenciais do usuário e retorna seus dados (id_usuario e id_consumidor se existir)
# ===========================
@app.post("/login")
def login():
    data = request.get_json(force=True)
    email = data.get("email")
    senha = data.get("senha")
    if not email or not senha:
        return jsonify({"error": "email e senha são obrigatórios"}), 400

    with pool.connection() as conn, conn.cursor() as cur:
        cur.execute("""
            SELECT u.id_usuario, u.nome, u.id_pais,
                   c.id_consumidor
            FROM usuario u
            LEFT JOIN consumidor c ON c.id_usuario = u.id_usuario
            WHERE u.email = %s AND u.senha = %s;
        """, (email, senha))
        row = cur.fetchone()
        if not row:
            return jsonify({"error": "Credenciais inválidas"}), 401
        return jsonify(row_to_dict(cur, row))

# ===========================
# Registra a compra de um jogo por um consumidor, calculando o valor final com conversão e imposto
# ===========================
@app.post("/purchases")
def purchase_game():
    """
    Body:
    {
      "id_usuario": 1,
      "id_jogo": 2,
      "id_metodo_pagamento": 3
    }
    """
    data = request.get_json(force=True)
    required = ["id_usuario", "id_jogo", "id_metodo_pagamento"]
    if any(k not in data for k in required):
        return jsonify({"error": f"Campos obrigatórios: {required}"}), 400

    with pool.connection() as conn, conn.cursor() as cur:
        try:
            # Descobre o consumidor e país do usuário
            cur.execute("""
                SELECT c.id_consumidor, u.id_pais
                FROM usuario u
                LEFT JOIN consumidor c ON c.id_usuario = u.id_usuario
                WHERE u.id_usuario = %s;
            """, (data["id_usuario"],))
            r = cur.fetchone()
            if not r or r[0] is None:
                raise ValueError("Usuário não é um consumidor válido")
            id_consumidor, id_pais = r

            # Valida se o método de pagamento pertence ao consumidor
            cur.execute("""
                SELECT 1 FROM metodo_pagamento
                WHERE id_metodo_pagamento = %s AND id_consumidor = %s;
            """, (data["id_metodo_pagamento"], id_consumidor))
            if cur.fetchone() is None:
                raise ValueError("Método de pagamento não pertence ao consumidor")

            # Busca preço, conversão e imposto
            cur.execute("""
                SELECT j.preco_dolar, p.razao_cambio, p.porcentagem_imposto, p.simbolo_moeda
                FROM jogo j
                JOIN pais p ON p.id_pais = %s
                WHERE j.id_jogo = %s;
            """, (id_pais, data["id_jogo"]))
            r = cur.fetchone()
            if not r:
                raise ValueError("Jogo não encontrado")
            preco_dolar, razao, imposto, simbolo = r

            preco_local = float(preco_dolar) * float(razao)
            total = preco_local * (1.0 + float(imposto)/100.0)

            # Registra compra
            cur.execute("""
                INSERT INTO jogo_comprado (id_consumidor, id_jogo, id_metodo_pagamento)
                VALUES (%s, %s, %s)
                RETURNING id_jogo_comprado, data_compra;
            """, (id_consumidor, data["id_jogo"], data["id_metodo_pagamento"]))
            id_compra, data_compra = cur.fetchone()

            conn.commit()
            return jsonify({
                "id_jogo_comprado": id_compra,
                "data_compra": data_compra.isoformat(),
                "preco_final": round(total, 2),
                "moeda": simbolo
            }), 201

        except Exception as e:
            conn.rollback()
            msg = str(e)
            if "unique" in msg.lower():
                return jsonify({"error": "Consumidor já possui este jogo"}), 409
            return jsonify({"error": msg}), 400

# ===========================
# Retorna todos os jogos comprados por um determinado usuário (se for consumidor)
# ===========================
@app.get("/users/<int:id_usuario>/purchases")
def list_purchases(id_usuario):
    with pool.connection() as conn, conn.cursor() as cur:
        cur.execute("""
            SELECT c.id_consumidor
            FROM consumidor c JOIN usuario u ON u.id_usuario = c.id_usuario
            WHERE u.id_usuario = %s;
        """, (id_usuario,))
        r = cur.fetchone()
        if not r:
            return jsonify({"error": "Usuário não é consumidor"}), 404
        id_consumidor = r[0]

        cur.execute("""
            SELECT jc.id_jogo_comprado, jc.data_compra, j.id_jogo, j.titulo
            FROM jogo_comprado jc
            JOIN jogo j ON j.id_jogo = jc.id_jogo
            WHERE jc.id_consumidor = %s
            ORDER BY jc.data_compra DESC;
        """, (id_consumidor,))
        rows = cur.fetchall()
        cols = [d[0] for d in cur.description]
        return jsonify([dict(zip(cols, row)) for row in rows])

# ===========================
# Insere um comentário de um consumidor para um jogo ou atualiza se já existir
# ===========================
@app.post("/games/<int:id_jogo>/comments")
def upsert_comment(id_jogo):
    """
    Body: { "id_usuario": 1, "texto": "..." }
    """
    data = request.get_json(force=True)
    if "id_usuario" not in data or "texto" not in data:
        return jsonify({"error": "id_usuario e texto são obrigatórios"}), 400

    with pool.connection() as conn, conn.cursor() as cur:
        try:
            cur.execute("""
                SELECT c.id_consumidor
                FROM consumidor c JOIN usuario u ON u.id_usuario = c.id_usuario
                WHERE u.id_usuario = %s;
            """, (data["id_usuario"],))
            r = cur.fetchone()
            if not r:
                raise ValueError("Usuário não é consumidor")
            id_consumidor = r[0]

            cur.execute("""
                INSERT INTO comentario (id_consumidor, id_jogo, texto)
                VALUES (%s, %s, %s)
                ON CONFLICT (id_consumidor, id_jogo)
                DO UPDATE SET texto = EXCLUDED.texto, data_comentario = now()
                RETURNING id_consumidor, id_jogo, texto, data_comentario;
            """, (id_consumidor, id_jogo, data["texto"]))
            inserted = cur.fetchone()
            conn.commit()
            cols = [d[0] for d in cur.description]
            return jsonify(dict(zip(cols, inserted))), 201
        except Exception as e:
            conn.rollback()
            return jsonify({"error": str(e)}), 400

# ===========================
# Retorna todos os comentários feitos para um jogo, com nickname e data
# ===========================
@app.get("/games/<int:id_jogo>/comments")
def list_comments(id_jogo):
    with pool.connection() as conn, conn.cursor() as cur:
        cur.execute("""
            SELECT cm.id_consumidor, u.nickname, cm.texto, cm.data_comentario
            FROM comentario cm
            JOIN consumidor c ON c.id_consumidor = cm.id_consumidor
            JOIN usuario u ON u.id_usuario = c.id_usuario
            WHERE cm.id_jogo = %s
            ORDER BY cm.data_comentario DESC;
        """, (id_jogo,))
        rows = cur.fetchall()
        cols = [d[0] for d in cur.description]
        return jsonify([dict(zip(cols, r)) for r in rows])

# ===========================
# Adiciona uma conquista a um jogo comprado por um consumidor
# ===========================
@app.post("/purchases/<int:id_compra>/achievements")
def add_achievement(id_compra):
    """
    Body: { "id_conquista": 1 }
    """
    data = request.get_json(force=True)
    if "id_conquista" not in data:
        return jsonify({"error": "id_conquista é obrigatório"}), 400

    with pool.connection() as conn, conn.cursor() as cur:
        try:
            # valida compra
            cur.execute("SELECT 1 FROM jogo_comprado WHERE id_jogo_comprado = %s;", (id_compra,))
            if not cur.fetchone():
                return jsonify({"error": "Compra não encontrada"}), 404

            # valida conquista
            cur.execute("SELECT 1 FROM conquista WHERE id_conquista = %s;", (data["id_conquista"],))
            if not cur.fetchone():
                return jsonify({"error": "Conquista não encontrada"}), 404

            cur.execute("""
                INSERT INTO jogo_comprado_conquista (id_jogo_comprado, id_conquista)
                VALUES (%s, %s)
                ON CONFLICT DO NOTHING
                RETURNING id_jogo_comprado, id_conquista;
            """, (id_compra, data["id_conquista"]))
            r = cur.fetchone()
            conn.commit()
            if r is None:
                return jsonify({"message": "Conquista já registrada"}), 200
            return jsonify({"message": "Conquista registrada", "data": {"id_jogo_comprado": r[0], "id_conquista": r[1]}}), 201
        except Exception as e:
            conn.rollback()
            return jsonify({"error": str(e)}), 400

# ===========================
# Retorna todas as conquistas registradas para um jogo comprado
# ===========================
@app.get("/purchases/<int:id_compra>/achievements")
def list_achievements(id_compra):
    with pool.connection() as conn, conn.cursor() as cur:
        cur.execute("""
            SELECT jcc.id_conquista, c.nome, c.descricao
            FROM jogo_comprado_conquista jcc
            JOIN conquista c ON c.id_conquista = jcc.id_conquista
            WHERE jcc.id_jogo_comprado = %s
            ORDER BY jcc.id_conquista;
        """, (id_compra,))
        rows = cur.fetchall()
        cols = [d[0] for d in cur.description]
        return jsonify([dict(zip(cols, r)) for r in rows])

if __name__ == "__main__":
    app.run(debug=True, port=5000)
