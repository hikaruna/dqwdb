import { connect, openTransaction, openTransactionWithResult, getAll, deleteDB } from './idbutil.js';
import { data } from './data.js';
import { dataHeader } from './data_header.js';
import { effects } from './effects.js';

const setup = async () => {
    await deleteDB('MyDB');

    const db = await connect('MyDB', 1, (db) => {
        const objectStore = db.createObjectStore('minds', { keyPath: ['no', 'rank'] });
        for(const column of columns) {
            objectStore.createIndex(column, column, { unique: false });
        }
    });

    await openTransaction(db, ['minds'], 'readwrite', (transaction) => {
        const minds = transaction.objectStore('minds');
        const hoge = data.slice(0, -1);
        for (const i of hoge) {
            minds.add({
                rank: 'S',
                ...i,
            });
        }
    });

    return db;
}

export const main = async (orderBy, orderType) => {

    const db = await setup();

    const result = await openTransactionWithResult(db, ['minds'], 'readwrite', async (transaction) => {
        const minds = transaction.objectStore('minds');
        //const result = await get(minds, ['アカイライ', 'S']);
        const result = await getAll(minds, orderBy, orderType);
        return result;
    });
    return result;
};

export const columns = dataHeader.concat(effects);
