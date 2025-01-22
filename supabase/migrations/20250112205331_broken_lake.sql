-- Create settori table
CREATE TABLE settori (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    codice TEXT UNIQUE NOT NULL,
    nome TEXT NOT NULL,
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

-- Create function for generating codice
CREATE OR REPLACE FUNCTION generate_settore_code() 
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.codice IS NULL OR NEW.codice = '' THEN
        NEW.codice := UPPER(SUBSTRING(NEW.nome FROM 1 FOR 2));
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for auto-generating codice
CREATE TRIGGER set_settore_code
    BEFORE INSERT ON settori
    FOR EACH ROW
    EXECUTE FUNCTION generate_settore_code();