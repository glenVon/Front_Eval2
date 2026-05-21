# --- Stage 1: Build y dependencias ---
FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
# Instalar dependencias en el espacio del usuario local
RUN pip install --no-cache-dir --user -r requirements.txt

# --- Stage 2: Runtime Final ---
FROM python:3.11-slim
WORKDIR /app

# Crear un usuario sin privilegios root
RUN useradd -u 8888 appuser && chown -R appuser:appuser /app
USER appuser

# Copiar dependencias instaladas y código fuente
COPY --from=builder /home/appuser/.local /home/appuser/.local
COPY . .

# Asegurar que los binarios de Python queden en el PATH del usuario
ENV PATH=/home/appuser/.local/bin:$PATH
EXPOSE 5000

CMD ["python", "app.py"]
