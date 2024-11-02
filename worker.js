import sqlite3InitModule from './node_modules/@sqlite.org/sqlite-wasm/index.mjs'

const sqlite3 = await sqlite3InitModule();

/*
const file = new File('data.sqlite3');
const fileReader = new FileReader();
fileReader.onload = (ev) => {
  ev.


};
fileReader.readAsArrayBuffer(file);
*/

const res = await fetch('./data.sqlite3');
const arrayBuffer = await res.arrayBuffer();
const ret = await sqlite3.oo1.OpfsDb.importDb('dqwdb.sqlite3', arrayBuffer);
sqlite3.initWorker1API();

