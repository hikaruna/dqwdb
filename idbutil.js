export const connect = (dbname, version, initialize) => {
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

export const openTransaction = (db, objectStoreList, mode, cb) => {
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

export const openTransactionWithResult = (db, objectStoreList, mode, cb) => {
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

const openCursor = (objectStore) => {
    return new Promise((resolve, reject) => {
        const request = objectStore.openCursor();
        request.onerror = (e) => reject(e);
        request.onsuccess = (e) => resolve(e.target.result);
    });
}

export const getAll = (objectStore, orderBy, orderType) => {
    return new Promise((resolve) => {
        let result = [];
        const cursorRequest = (() => {
            if (orderBy) {
                return objectStore.index(orderBy).openCursor(null, orderType);
            } else {
                return objectStore.openCursor();
            }
        })();
        cursorRequest.onsuccess = (e) => {
            const cursor = e.target.result;
            if (cursor) {
                result.push(cursor.value);
                cursor.continue();
            } else {
                resolve(result);
            }
        }
    });
}

export const deleteDB = (name) => {
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
