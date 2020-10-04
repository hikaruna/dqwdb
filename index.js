import { data } from './data.js';

const connect = (dbname, version, initialize) => {
    return new Promise((resolve, reject) => {
        let request = window.indexedDB.open(dbname, version);
        request.onerror = (e) => {
            reject(e.target.result);
        };
        request.onupgradeneeded = (e) => {
            initialize(e.target.result);
        }
        request.onsuccess = (e) => {
            resolve(e.target.result);
        };
    });
};

const openTransaction = (db, objectStoreList, mode, cb) => {
    return new Promise((resolve, reject) => {
        console.log(`openTransaction: a   objectStoreList: ${objectStoreList}`);
        const transaction = db.transaction(objectStoreList, mode);
        cb(transaction);
        transaction.onerror = (e) => {
            reject(e);
        };
        transaction.oncomplete = (e) => {
            resolve();
        };
    });
};

const openTransactionWithResult = (db, objectStoreList, mode, cb) => {
    return new Promise(async (resolve, reject) => {
        console.log(`openTransaction: a   objectStoreList: ${objectStoreList}`);
        const transaction = db.transaction(objectStoreList, mode);
        const result = await cb(transaction);
        transaction.onerror = (e) => {
            reject(e);
        };
        transaction.oncomplete = (e) => {
            resolve(result);
        };
    });
};

const get = (objectStore, key) => {
    return new Promise((resolve, reject) => {
        const request = objectStore.get(key);
        request.onerror = (e) => {
            reject(e);
        }
        request.onsuccess = () => {
            resolve(request.result);
        }
    });
};

const deleteDB = (name) => {
    return new Promise((resolve, reject) => {
        const request = window.indexedDB.deleteDatabase(name);
        request.onerror = (e) => {
            reject(e);
        };
        request.onsuccess = () => {
            resolve();
        };
    })
};

export const main = async () => {
    await deleteDB('MyDB');

    const db = await connect('MyDB', 1, (db) => {
        db.createObjectStore('minds', { keyPath: ['monster', 'rank'] });
    });

    await openTransaction(db, ['minds'], 'readwrite', (transaction) => {
        const minds = transaction.objectStore('minds');
        const hoge = data.slice(0,-1);
        for(const i of hoge) {
            minds.add({
                rank: 'S',
                ...i,
            });
        }
    });

    const result = await openTransactionWithResult(db, ['minds'], 'readwrite', async (transaction) => {
        const result = await get(transaction.objectStore('minds'), ['アカイライ', 'S']);
        return result;
    });
    return result;
};
