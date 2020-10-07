import { connect, openTransaction, openTransactionWithResult, getAll, deleteDB } from './idbutil.js';
import { data } from './data.js';

const setup = async () => {
    await deleteDB('MyDB');

    const db = await connect('MyDB', 1, (db) => {
        const objectStore = db.createObjectStore('minds', { keyPath: ['no', 'rank'] });
        objectStore.createIndex("no", "no", { unique: true });
        objectStore.createIndex("モンスター", "モンスター", { unique: false });
        objectStore.createIndex("特技", "特技", { unique: false });
        objectStore.createIndex("HP", "HP", { unique: false });
        objectStore.createIndex("MP", "MP", { unique: false });
        objectStore.createIndex("力", "力", { unique: false });
        objectStore.createIndex("会心", "会心", { unique: false });
        objectStore.createIndex("身守", "身守", { unique: false });
        objectStore.createIndex("攻魔", "攻魔", { unique: false });
        objectStore.createIndex("回魔", "回魔", { unique: false });
        objectStore.createIndex("素早", "素早", { unique: false });
        objectStore.createIndex("器用", "器用", { unique: false });
        objectStore.createIndex("コスト", "コスト", { unique: false });
        objectStore.createIndex("色", "色", { unique: false });
        objectStore.createIndex("効果", "効果", { unique: false });
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
