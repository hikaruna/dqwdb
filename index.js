// @ts-check
import { sqlite3Worker1Promiser } from "@sqlite.org/sqlite-wasm";
//import { sqlite3Worker1Promiser } from "./node_modules/@sqlite.org/sqlite-wasm/index.mjs";
// const sqlite3Worker1Promiser = /** @type {import()} */ (importedSqlite3Worker1Promiser);
//import sqlite3Worker1Promiser from "@sqlite.org/sqlite-wasm/jswasm/sqlite-worker1-promiser.mjs";



const promiser = /** @type {import("@sqlite.org/sqlite-wasm").Sqlite3Worker1Promiser} */(await sqlite3Worker1Promiser.v2({
  worker: new Worker(
    'worker.js',
    { type: 'module' }
  )
}));

console.log('hoge')
try {
  const openResponse = await promiser('open', {
    filename: 'dqwdb.sqlite3',
    vfs: 'opfs'
  });
  console.log(openResponse);

  const { dbId } = openResponse;
  console.log(
    'OPFS is available, created persisted database at',
    openResponse.result.filename.replace(/^file:(.*?)\?vfs=opfs$/, '$1'),
  );

  {

    const selectResponse = await promiser(
      "exec",
      {
        sql: 'SELECT * FROM soubi',
        rowMode: 'object'
      }
    );

    console.log(selectResponse);

    const table = document.createElement('table');
    document.body.append(table);
    for (const row of selectResponse.result.resultRows) {
      table.append((() => {
        const tr = document.createElement('tr');
        tr.append((() => {
          const td = document.createElement('td');
          td.textContent = row.soubi;
          return td;
        })());
        tr.append((() => {
          const td = document.createElement('td');
          td.textContent = row.skill_tokusyukouka_text;
          return td;
        })());
        return tr;
      })());
    }
  }

  try {
    const execRes = await promiser('exec', {
      sql: "SELECT load_extension('./regexp.so')"
    });

    console.log(execRes);
  } catch (e) {
    console.error(e.result.message);
  }

} catch (e) {
  console.error(e);
}

export { };

