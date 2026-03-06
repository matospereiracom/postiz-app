FROM node:22-alpine

WORKDIR /app

# Instala pnpm via Corepack
RUN corepack enable && corepack prepare pnpm@10.6.1 --activate

# Copia package.json e lockfile primeiro para cache de dependências
COPY package.json pnpm-lock.yaml ./

RUN pnpm install --frozen-lockfile

# Copia o resto do código
COPY . .

# Build
RUN pnpm build

# Expõe a porta
EXPOSE 3000

# Comando de start (roda PM2 com o script que adicionamos antes)
CMD ["pnpm", "start"]
