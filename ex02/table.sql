DROP TABLE IF EXISTS data_2022_oct;

CREATE TABLE data_2022_oct (
    event_time TIMESTAMPTZ,
    event_type VARCHAR(20),
    product_id INTEGER,
    price NUMERIC(10, 2),
    user_id BIGINT,
    user_session UUID
);