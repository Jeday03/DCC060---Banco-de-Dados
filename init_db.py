from pathlib import Path
from psycopg import connect
from dotenv import load_dotenv
import os

load_dotenv()
cn = os.getenv("DATABASE_URL")
if not cn:
    raise RuntimeError("DATABASE_URL não definido")

def run_sql(path: str):
    sql = Path(path).read_text(encoding="utf-8")
    with connect(cn) as conn:
        with conn.cursor() as cur:
            cur.execute(sql)
        conn.commit()

if __name__ == "__main__":
    run_sql("schema.sql")
    run_sql("seed.sql")
    print("Schema e seed aplicados com sucesso no Neon.")
