import Vue from 'https://cdn.jsdelivr.net/npm/vue@2.6.12/dist/vue.esm.browser.js';
import { main } from './main.js';

(async () => {

    const result = await main();

    const app = new Vue({
        el: '#app',
        data: {
            minds: result
        }
    });
})();
