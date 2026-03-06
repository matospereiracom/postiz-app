FROM node:22-alpine

WORKDIR /app

# Instala pnpm via Corepack
RUN corepack enable && corepack prepare pnpm@10.6.1 --activate

# Instala PM2 globalmente (essencial para o start do Postiz)
RUN pnpm add -g pm2

# Copia package.json e lockfile primeiro para cache
COPY package.json pnpm-lock.yaml ./

RUN pnpm install --frozen-lockfile

# Copia o resto do código
COPY . .

# Build o projeto
RUN pnpm build

# Expõe a porta (o Nginx interno usa 5000, mas o Railway mapeia para 3000 ou 5000)
EXPOSE 5000

# Comando de start: usa o pm2-run do teu package.json
CMD ["pnpm", "start"]
