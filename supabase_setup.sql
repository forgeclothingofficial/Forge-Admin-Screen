-- ==========================================
-- FORGE E-COMMERCE SUPABASE SETUP SCRIPT
-- ==========================================
-- Run this in Supabase Dashboard → SQL Editor → New query

-- 1. Create the Products Table
CREATE TABLE IF NOT EXISTS public.products (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC NOT NULL,
    stock INTEGER DEFAULT 0,
    category TEXT,
    image TEXT,       -- URL to the product image
    sizes TEXT,       -- Comma separated like 'S, M, L'
    original_price NUMERIC -- The higher, crossed-out price for discounts
);

-- 2. Create the Reviews Table
CREATE TABLE IF NOT EXISTS public.reviews (
    id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES public.products(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    text TEXT,
    date TEXT
);

-- 3. Create the Orders Table
CREATE TABLE IF NOT EXISTS public.orders (
    id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES public.products(id) ON DELETE CASCADE,
    product_name TEXT,
    size TEXT,
    customer_name TEXT,
    customer_email TEXT,
    address TEXT,
    status TEXT DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT NOW()
);

-- ==========================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ==========================================

-- Enable RLS on all tables
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;

-- ==========================================
-- PRODUCTS POLICIES
-- For testing: allow ALL operations (SELECT, INSERT, UPDATE, DELETE)
-- ==========================================
DO $$
BEGIN
    -- Drop existing policies if they exist (safe re-run)
    DROP POLICY IF EXISTS "Allow public read access on products" ON public.products;
    DROP POLICY IF EXISTS "Allow public ALL on products for testing" ON public.products;
    DROP POLICY IF EXISTS "products_all_access" ON public.products;
END $$;

CREATE POLICY "products_all_access"
ON public.products FOR ALL
USING (true)
WITH CHECK (true);

-- ==========================================
-- REVIEWS POLICIES
-- Allow SELECT and INSERT for everyone
-- ==========================================
DO $$
BEGIN
    DROP POLICY IF EXISTS "Allow public read access on reviews" ON public.reviews;
    DROP POLICY IF EXISTS "Allow public insert on reviews" ON public.reviews;
    DROP POLICY IF EXISTS "reviews_select" ON public.reviews;
    DROP POLICY IF EXISTS "reviews_insert" ON public.reviews;
END $$;

CREATE POLICY "reviews_select"
ON public.reviews FOR SELECT
USING (true);

CREATE POLICY "reviews_insert"
ON public.reviews FOR INSERT
WITH CHECK (true);

-- ==========================================
-- ORDERS POLICIES
-- Allow ALL operations for testing
-- ==========================================
DO $$
BEGIN
    DROP POLICY IF EXISTS "Allow public insert on orders" ON public.orders;
    DROP POLICY IF EXISTS "Allow public ALL on orders for testing" ON public.orders;
    DROP POLICY IF EXISTS "orders_all_access" ON public.orders;
END $$;

CREATE POLICY "orders_all_access"
ON public.orders FOR ALL
USING (true)
WITH CHECK (true);

-- ==========================================
-- VERIFICATION: Check tables exist
-- ==========================================
-- Run this to verify your setup:
-- SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';
