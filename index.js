import Vue from 'https://cdn.jsdelivr.net/npm/vue@2.6.12/dist/vue.esm.browser.js';
import { main } from './main.js';

(async () => {

    const params = (new URL(location)).searchParams;
    const orderBy = params.get('orderby');
    const orderType = params.get('ordertype');
    const idbOrderType = orderType === "desc" ? "prev" : "next";

    const result = await main(orderBy, idbOrderType);

    const app = new Vue({
        el: '#app',
        data: {
            minds: result,
            orderBy: params.get('orderby'),
            desc: orderType === "desc"
        },
        computed: {
            orderType() {
                return this.desc ? "desc" : "asc";
            },
            reverseOrderType() {
                return this.desc ? "asc" : "desc";
            }
        }
    });
})();
