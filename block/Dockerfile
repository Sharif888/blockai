FROM node:8.11.4-alpine
COPY package.json truffle.js init_testrpc.sh /
COPY contracts/ ./contracts/
COPY migrations/ ./migrations/
COPY bin/ ./bin/
WORKDIR /
RUN  npm install
RUN sh init_testrpc.sh
EXPOSE 8545
CMD [ "./node_modules/.bin/testrpc","--host", "0.0.0.0", "--db","data/ganache-clli_persist","--seed","20170812","--accounts","42","--debug"]
