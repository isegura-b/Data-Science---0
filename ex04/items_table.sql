DROP TABLE IF EXISTS items;

CREATE TABLE items (
    product_id    INTEGER,
    category_id   BIGINT,
    category_code TEXT,
    brand         VARCHAR(255)
);