import os
from pathlib import Path
from typing import Any

from dotenv import load_dotenv
from supabase import Client, create_client

BACKEND_ENV_PATH = Path(__file__).resolve().parents[1] / ".env"
load_dotenv(BACKEND_ENV_PATH)


class SupabaseClient:
    _client: Client | None = None

    def _load(self) -> Client:
        if self._client is None:
            url = os.getenv("SUPABASE_URL")
            key = os.getenv("SUPABASE_KEY")
            if not url or not key:
                raise RuntimeError("SUPABASE_URL and SUPABASE_KEY are required.")
            self._client = create_client(url, key)
        return self._client

    def __getattr__(self, name: str) -> Any:
        return getattr(self._load(), name)


supabase = SupabaseClient()
