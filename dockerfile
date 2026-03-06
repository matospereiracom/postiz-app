# Base leve com Node 22
FROM node:22-alpine AS builder

# Instala dependências do sistema
RUN apk add --no-cache git bash

WORKDIR /app

# Ativa Corepack e instala pnpm 10.6.1 (compatível com teu lockfile)
RUN corepack enable && corepack prepare pnpm@10.6.1 --activate

# Instala PM2 globalmente - isto corrige "pm2: not found"
RUN pnpm add -g pm2

# Copia package.json e lockfile para cache
COPY package.json pnpm-lock.yaml ./

# Instala dependências
RUN pnpm install --frozen-lockfile --prefer-offline

# Copia o código fonte
COPY . .

# Build o projeto inteiro
RUN pnpm build

# Remove dev deps para imagem mais leve
RUN pnpm prune --prod

# Stage final (para produção)
FROM node:22-alpine

WORKDIR /app

# Copia o build pronto do builder
COPY --from=builder /app /app

# Copia PM2 global do builder (ou reinstala)
RUN corepack enable && corepack prepare pnpm@10.6.1 --activate && pnpm add -g pm2

# Expõe a porta do Nginx interno (template Temporal)
EXPOSE 5000

# Start: roda o teu script "start" que chama pm2-run
CMD ["pnpm", "start"]
