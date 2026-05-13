-- LITTLESTEPS PRO SCHEMA (PHASE 13 UPDATED)
-- PARENT-CHILD REMOTE SYNC & SECURITY

-- 0. USER PROFILES (New for PIN security)
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    parent_pin TEXT CHECK (length(parent_pin) = 4), -- 4-digit PIN
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 1. EXTENDED CHILDREN TABLE
CREATE TABLE IF NOT EXISTS public.children (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    parent_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name_token TEXT NOT NULL,
    birth_date DATE,
    current_level TEXT DEFAULT 'toddler' CHECK (current_level IN ('toddler', 'explorer', 'preschool')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. ENHANCED MILESTONES TABLE
CREATE TABLE IF NOT EXISTS public.milestones (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    child_id UUID NOT NULL REFERENCES public.children(id) ON DELETE CASCADE,
    type TEXT NOT NULL,
    score INTEGER DEFAULT 0,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. ENHANCED MOOD CHECKS TABLE
CREATE TABLE IF NOT EXISTS public.mood_checks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    child_id UUID NOT NULL REFERENCES public.children(id) ON DELETE CASCADE,
    mood TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. ROW LEVEL SECURITY (RLS) POLICIES
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.children ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.milestones ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mood_checks ENABLE ROW LEVEL SECURITY;

-- Profile Policies
CREATE POLICY "Users can view and update their own profile" ON public.profiles
    FOR ALL USING (auth.uid() = id);

-- Children Policies
CREATE POLICY "Parents can view their own children" 
ON public.children FOR SELECT 
USING (auth.uid() = parent_id);

CREATE POLICY "Parents can insert their own children" 
ON public.children FOR INSERT 
WITH CHECK (auth.uid() = parent_id);

CREATE POLICY "Parents can update their own children" 
ON public.children FOR UPDATE 
USING (auth.uid() = parent_id);

-- Milestones Policies
CREATE POLICY "Parents can view milestones of their children" 
ON public.milestones FOR SELECT 
USING (
    EXISTS (
        SELECT 1 FROM public.children 
        WHERE children.id = milestones.child_id AND children.parent_id = auth.uid()
    )
);

CREATE POLICY "Parents can insert milestones for their children" 
ON public.milestones FOR INSERT 
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.children 
        WHERE children.id = milestones.child_id AND children.parent_id = auth.uid()
    )
);

-- Mood Checks Policies
CREATE POLICY "Parents can view mood checks of their children" 
ON public.mood_checks FOR SELECT 
USING (
    EXISTS (
        SELECT 1 FROM public.children 
        WHERE children.id = mood_checks.child_id AND children.parent_id = auth.uid()
    )
);

CREATE POLICY "Parents can insert mood checks for their children" 
ON public.mood_checks FOR INSERT 
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.children 
        WHERE children.id = mood_checks.child_id AND children.parent_id = auth.uid()
    )
);

-- 5. REALTIME PUBLICATION
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables 
        WHERE pubname = 'supabase_realtime' 
        AND schemaname = 'public' 
        AND tablename = 'children'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.children;
    END IF;
END $$;
