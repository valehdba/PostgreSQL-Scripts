import psycopg2
import argparse
import sys

def check_database_health(host, port, database, user, password):
    try:
        # Connect to the database
        conn = psycopg2.connect(
            host=host,
            port=port,
            database=database,
            user=user,
            password=password
        )
        cursor = conn.cursor()
        
        # Test basic connection
        cursor.execute("SELECT version();")
        version = cursor.fetchone()[0]
        print(f"Connection: OK")
        print(f"Version: {version}")
        
        # Get active connections
        cursor.execute("SELECT count(*) FROM pg_stat_activity;")
        active_connections = cursor.fetchone()[0]
        print(f"Active Connections: {active_connections}")
        
        # Get database size
        cursor.execute("SELECT pg_size_pretty(pg_database_size(%s));", (database,))
        db_size = cursor.fetchone()[0]
        print(f"Database Size: {db_size}")
        
        # Check for long-running queries (running > 5 minutes)
        cursor.execute("""
            SELECT count(*) FROM pg_stat_activity 
            WHERE state = 'active' 
            AND now() - query_start > interval '5 minutes';
        """)
        long_queries = cursor.fetchone()[0]
        if long_queries > 0:
            print(f"Warning: {long_queries} long-running queries detected")
        else:
            print("Long-running queries: None")
        
        cursor.close()
        conn.close()
        
        print("Status: Healthy")
        return True
        
    except psycopg2.Error as e:
        print(f"Database Health Check Failed: {e}")
        print("Status: Unhealthy")
        return False

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Check PostgreSQL database health")
    parser.add_argument("--host", default="localhost", help="Database host")
    parser.add_argument("--port", type=int, default=5432, help="Database port")
    parser.add_argument("--database", required=True, help="Database name")
    parser.add_argument("--user", required=True, help="Database user")
    parser.add_argument("--password", required=True, help="Database password")
    
    args = parser.parse_args()
    
    success = check_database_health(
        args.host, args.port, args.database, args.user, args.password
    )
    
    sys.exit(0 if success else 1)