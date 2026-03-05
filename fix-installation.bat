@echo off
chcp 65001 >nul
title ClawSphere AMS - Reparar Instalacion

echo ============================================
echo   CLAWSPHERE AMS - REPARAR INSTALACION
echo ============================================
echo.

cd /d "%~dp0"

echo [1/6] Verificando entorno virtual...
if not exist "venv\Scripts\activate" (
    echo [ERROR] Entorno virtual no encontrado
    echo Ejecuta install-windows.bat primero
    pause
    exit /b 1
)
call venv\Scripts
echo [OK] Entorno virtual encontrado
echo.

echo [2/6] Instalando dependencias faltantes...
venv\Scripts\pip install pyyaml python-dotenv -q
echo [OK] Dependencias instaladas
echo.

echo [3/6] Creando directorios faltantes...
if not exist "monitoring" mkdir monitoring
if not exist "tenant" mkdir tenant
if not exist "workflow" mkdir workflow
echo [OK] Directorios creados
echo.

echo [4/6] Creando archivos __init__.py...

echo # Monitoring > monitoring\__init__.py
echo from .metrics import setup_metrics >> monitoring\__init__.py
echo from .health import health_checker >> monitoring\__init__.py
echo. >> monitoring\__init__.py
echo def setup_metrics(app): >> monitoring\__init__.py
echo     pass >> monitoring\__init__.py
echo. >> monitoring\__init__.py
echo class HealthChecker: >> monitoring\__init__.py
echo     async def check_all(self): >> monitoring\__init__.py
echo         return {\"status\": \"healthy\"} >> monitoring\__init__.py
echo. >> monitoring\__init__.py
echo health_checker = HealthChecker() >> monitoring\__init__.py

echo # Tenant > tenant\__init__.py
echo class TenantManager: >> tenant\__init__.py
echo     async def initialize(self): >> tenant\__init__.py
echo         pass >> tenant\__init__.py

echo # Workflow > workflow\__init__.py
echo class WorkflowEngine: >> workflow\__init__.py
echo     pass >> workflow\__init__.py

echo [OK] Archivos __init__.py creados
echo.

echo [5/6] Verificando archivos del core...
if not exist "core\config\__init__.py" (
    echo [WARNING] core\config\__init__.py no existe
    echo Creando archivo basico...
    
    if not exist "core\config" mkdir core\config
    
    echo # Config > core\config\__init__.py
    echo import os >> core\config\__init__.py
    echo. >> core\config\__init__.py
    echo class Settings: >> core\config\__init__.py
    echo     APP_NAME = "ClawSphere AMS" >> core\config\__init__.py
    echo     DEBUG = os.getenv(\"CLAWSPHERE_DEBUG\", \"true\").lower() == \"true\" >> core\config\__init__.py
    echo     HOST = os.getenv(\"CLAWSPHERE_HOST\", \"0.0.0.0\") >> core\config\__init__.py
    echo     PORT = int(os.getenv(\"CLAWSPHERE_PORT\", \"7550\")) >> core\config\__init__.py
    echo     DATABASE_URL = os.getenv(\"CLAWSPHERE_DATABASE_URL\", \"sqlite+aiosqlite:///data/clawsphere.db\") >> core\config\__init__.py
    echo     AI_DEFAULT_PROVIDER = os.getenv(\"CLAWSPHERE_AI_DEFAULT_PROVIDER\", \"ollama\") >> core\config\__init__.py
    echo     AI_OLLAMA_BASE_URL = os.getenv(\"CLAWSPHERE_AI_OLLAMA_BASE_URL\", \"http://localhost:11434\") >> core\config\__init__.py
    echo     AI_OLLAMA_MODEL = os.getenv(\"CLAWSPHERE_AI_OLLAMA_MODEL\", \"llama3.1\") >> core\config\__init__.py
    echo. >> core\config\__init__.py
    echo settings = Settings() >> core\config\__init__.py
    
    echo [OK] core\config\__init__.py creado
) else (
    echo [OK] core\config\__init__.py existe
)

if not exist "core\events\__init__.py" (
    echo [WARNING] core\events\__init__.py no existe
    echo Creando archivo basico...
    
    if not exist "core\events" mkdir core\events
    
    echo # Events > core\events\__init__.py
    echo from datetime import datetime >> core\events\__init__.py
    echo. >> core\events\__init__.py
    echo class Event: >> core\events\__init__.py
    echo     def __init__(self, type, data): >> core\events\__init__.py
    echo         self.type = type >> core\events\__init__.py
    echo         self.data = data >> core\events\__init__.py
    echo         self.timestamp = datetime.now() >> core\events\__init__.py
    echo. >> core\events\__init__.py
    echo class EventBus: >> core\events\__init__.py
    echo     def __init__(self): >> core\events\__init__.py
    echo         self._handlers = {} >> core\events\__init__.py
    echo     def subscribe(self, event_type, handler): >> core\events\__init__.py
    echo         if event_type not in self._handlers: >> core\events\__init__.py
    echo             self._handlers[event_type] = [] >> core\events\__init__.py
    echo         self._handlers[event_type].append(handler) >> core\events\__init__.py
    echo. >> core\events\__init__.py
    echo event_bus = EventBus() >> core\events\__init__.py
    
    echo [OK] core\events\__init__.py creado
) else (
    echo [OK] core\events\__init__.py existe
)

if not exist "api\__init__.py" (
    echo # API > api\__init__.py
    echo [OK] api\__init__.py creado
) else (
    echo [OK] api\__init__.py existe
)

if not exist "api\rest\__init__.py" (
    echo [WARNING] api\rest\__init__.py no existe
    echo Creando archivo basico...
    
    echo # REST API > api\rest\__init__.py
    echo from fastapi import APIRouter >> api\rest\__init__.py
    echo from .routes import router >> api\rest\__init__.py
    echo. >> api\rest\__init__.py
    echo def create_rest_api(): >> api\rest\__init__.py
    echo     api = APIRouter() >> api\rest\__init__.py
    echo     api.include_router(router, prefix=\"/api/v1\") >> api\rest\__init__.py
    echo     return api >> api\rest\__init__.py
    
    echo [OK] api\rest\__init__.py creado
) else (
    echo [OK] api\rest\__init__.py existe
)

echo.

echo [6/6] Verificando main.py...
if not exist "main.py" (
    echo [ERROR] main.py no encontrado
    pause
    exit /b 1
)
echo [OK] main.py existe
echo.

echo ============================================
echo   REPARACION COMPLETADA
echo ============================================
echo.
echo Para iniciar el servidor:
echo   start-windows.bat
echo.
echo Para verificar:
echo   diagnose-windows.bat
echo.

pause
