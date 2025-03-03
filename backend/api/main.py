from fastapi import FastAPI, HTTPException
import psycopg2
import json
from typing import List

app = FastAPI()

# ✅ Replace with your AWS RDS PostgreSQL credentials
DB_CONFIG = {
    "dbname": "hackathonDB",
    "user": "postgres",
    "password": "cavendish21556",
    "host": "hackathondb.cleyq8gk447j.ap-southeast-2.rds.amazonaws.com",  # Example: mydb.something.rds.amazonaws.com
    "port": "5432"
}

def get_db_connection():
    """Connect to PostgreSQL database"""
    return psycopg2.connect(**DB_CONFIG)

@app.get("/jeepney_routes/{route_name}")
async def get_route(route_name: str):
    """Fetches route JSON data from PostgreSQL"""
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        
        # Fetch JSON data for the requested route
        cur.execute("SELECT data::text FROM jeepney_routes WHERE name = %s", (route_name,))
        result = cur.fetchone()
        
        cur.close()
        conn.close()
        
        if not result:
            raise HTTPException(status_code=404, detail="Route not found")

        return json.loads(result[0])  # Convert JSONB to Python dict

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
