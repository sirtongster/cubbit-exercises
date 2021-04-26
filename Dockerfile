FROM node:14-alpine

WORKDIR /root/code/
COPY public ./public
COPY src ./src
ADD package.json .

RUN npm install

CMD ["npm", "start"]