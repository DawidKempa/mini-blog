FROM node:24

WORKDIR /app

COPY package.json package-lock.json* ./

RUN npm install @popperjs/core --legacy-peer-deps

RUN npm install --legacy-peer-deps

COPY . .

EXPOSE 8080

CMD ["npm", "run", "dev"]
