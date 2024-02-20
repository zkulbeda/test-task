#
# Development build
#
FROM node:18-alpine AS dev
WORKDIR /app  
ENV NODE_ENV=development

EXPOSE 3000

CMD npx wait-on tcp:postgres:5432 \
  && npm i \
  && npx prisma migrate deploy \
  && npx ts-node prisma/seed.ts \
  && npm run start:dev


#
# Production build
#
FROM node:18-alpine AS prod
WORKDIR /app
ENV NODE_ENV=production

COPY package*.json ./
RUN npm ci

COPY prisma ./prisma/
RUN npm run prisma:generate

COPY ./src ./src
RUN npm run build

EXPOSE 3000

CMD npx wait-on tcp:postgres:5432 \
  && npm run prisma:migration \
  && npm run start:prod