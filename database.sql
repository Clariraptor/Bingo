-- Base de datos del Bingo - PostgreSQL
-- Ejecuta este archivo en pgAdmin o psql

-- Crear base de datos
CREATE DATABASE bingo_db;

-- Conectarse a la base de datos
\c bingo_db;

-- Tabla de partidas
CREATE TABLE IF NOT EXISTS partidas (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    estado VARCHAR(20) DEFAULT 'espera' CHECK (estado IN ('espera', 'activa', 'finalizada')),
    numero_actual INTEGER,
    numeros_llamados JSONB DEFAULT '[]',
    ganador_id INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de jugadores
CREATE TABLE IF NOT EXISTS jugadores (
    id SERIAL PRIMARY KEY,
    partida_id INTEGER NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    carton JSONB NOT NULL,
    numeros_marcados JSONB DEFAULT '[]',
    ha_ganado BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (partida_id) REFERENCES partidas(id) ON DELETE CASCADE
);

-- Tabla de cartones generados
CREATE TABLE IF NOT EXISTS cartones (
    id SERIAL PRIMARY KEY,
    partida_id INTEGER,
    numero_carton INTEGER NOT NULL,
    datos JSONB NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indices para busquedas rapidas
CREATE INDEX idx_jugadores_partida ON jugadores(partida_id);
CREATE INDEX idx_partidas_estado ON partidas(estado);
CREATE INDEX idx_cartones_partida ON cartones(partida_id);

-- Funcion para actualizar timestamp
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para actualizar updated_at en partidas
CREATE TRIGGER update_partidas_timestamp
    BEFORE UPDATE ON partidas
    FOR EACH ROW
    EXECUTE FUNCTION update_timestamp();
