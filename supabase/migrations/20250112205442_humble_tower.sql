-- Create settori table
CREATE TABLE settori (
    id SERIAL PRIMARY KEY,
    nome TEXT NOT NULL UNIQUE,
    attivo BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Enable RLS
ALTER TABLE settori ENABLE ROW LEVEL SECURITY;

-- Add policies for public access
CREATE POLICY "Accesso pubblico in lettura settori"
    ON settori
    FOR SELECT
    TO PUBLIC
    USING (true);

CREATE POLICY "Accesso pubblico in scrittura settori"
    ON settori
    FOR ALL
    TO PUBLIC
    USING (true)
    WITH CHECK (true);

-- Add trigger for updating timestamp
CREATE TRIGGER update_settori_timestamp
    BEFORE UPDATE ON settori
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();

-- Insert default settori
INSERT INTO settori (nome) VALUES
    ('AUDIO'),
    ('LUCI'),
    ('VIDEO'),
    ('ELETTRICO'),
    ('STRUTTURE'),
    ('SEGNALI'),
    ('ALLESTIMENTO'),
    ('ATTREZZATURE'),
    ('BACKLINE'),
    ('RIGGHERAGGIO'),
    ('GENERICO');