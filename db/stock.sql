/* 
    Auto-increment : https://sqlite.org/autoinc.html 
    https://www.tutorialspoint.com/sqlite/sqlite_pragma.htm 
    http://www.sqlitetutorial.net/sqlite-index/

    Date manipulation : 
        https://www.tutorialspoint.com/sqlite/sqlite_date_time.htm
 */


/**
    Cette table décrit les différents lieux de stockage
        - name : ce sera le nom (unique remarquons l'utilisation de PRIMARY KEY) du lieu
        - description : une description optionnelle
        ex : 
            row1 : (name:"placard 1", description:"le placard dans le couloire avec les fuits à coque)
        Convention :
            name:"",description:"" => ce sera le truc par défaut signifiant non renseigné
*/
CREATE TABLE places(
    name VARCHAR(50) PRIMARY KEY,
    description TEXT
);

/**
    Cette table décrit les différentes marques de produits
        - name : ce sera le nom (unique remarquons l'utilisation de PRIMARY KEY) de la marque
        ex : 
            row1 : (name:"Millet")
        Convention :
            name:"" => ce sera le truc par défaut signifiant non renseigné

*/
CREATE TABLE brands(
    name VARCHAR(50) PRIMARY KEY
);

/**
    Cette table décrit les différentes pays, elle sera principalement utilisée pourlié un produit à une origine.
        - name : ce sera le nom (unique remarquons l'utilisation de PRIMARY KEY) du pays
        ex : 
            row1 : (name:"France", code:"fr")
        Convention :
            name:"",code:"" => ce sera le truc par défaut signifiant non renseigné
*/
CREATE TABLE countries(
    name VARCHAR(50) PRIMARY KEY,
    code CHAR(2)
);

/**
    Cette table décrit les différentes magazins d'approvisionnement.
        - name : ce sera le nom (unique remarquons l'utilisation de PRIMARY KEY) du magazin
        - address : ce sera l'addresse du lieu
        ex : 
            row1 : (name:"Carrefourd Cachan", code:"xxx xxx xxx, Cachan")
        Convention :
            name:"",address:"" => ce sera le truc par défaut signifiant non renseigné
*/

CREATE TABLE shops(
    name VARCHAR(50) PRIMARY KEY,
    address TEXT
);

/**
    Ici, on entre dans le vif du sujet : on va décrire un "exemplaire" d'un produit(qui sera appelé "stock_reference"). Par exemple on va décrire les paquets de riz, les bouteilles d'huile d'olives etc...
        - name : le nom du produit, notons que c'est la seul chose obligatoire
        - brand : correspond à l'id de la marque de cette exemplaire (cf. brands)
        - amount : correspond à la quantité présente dans le stock pour cette exemplaire, la syntaxe est la suivante
            * pour une description en terme de masse :
                [0-9]+(\.[0-9]+)? [mg|g|Kg]
                ex: 
                    500 mg
                    9.1 Kg
            * pour une description en terme de volume : 
                [0-9]+(\.[0-9]+)? [ml|L]
                ex:
                    1.1 L
                    150 ml
            * pour une description en nombre de pièces :
                [0-9]+ p
                ex:
                    3 p
        - price : le prix d'achat en euros
        - expiration_date : la date d'expiration (sous forme de timestamp) de cette exemplaire
        - opening_date : la date d'ouverture de cet exemplaore 
        - expiration_delay : la durée de conservation une fois ouvert (notons que de même il s'exprime en nombre de secondes)
        - origin : correspond à l'id du pays d'origine de cet exemplaire (cf. countris)
        - shop : correspond à l'id du magazin d'où provient cet exemplaire
        Remarquons que la PRIMARY KEY est "rowid" ici

        ex:
            name:"riz basmati everest", brand:"truc", amount:"1 Kg", etc..
            name:"riz basmati", brand:"Billa", amount:"500 g", etc..

            c'est deux entrées correspondent à une même référence le "riz basmati"
*/
CREATE TABLE stock_entry(
    name VARCHAR(50) NOT NULL,
    brand INTEGER,
    amount VARCHAR(50),
    price REAL,
    expiration_date INTEGER, 
    current_expiration_date INTEGER,
    expiration_delay INTEGER,
    origin INTEGER, 
    shop INTEGER,
    
    FOREIGN KEY (brand) REFERENCES brands(rowid),
    FOREIGN KEY (origin) REFERENCES countries(rowid),
    FOREIGN KEY (shop) REFERENCES shops(rowid)
);

/**
    Ici on décrit un produit qui sera présent en multiple exemplaire (cf. stock_entry)
        - name : ce sera le nom (unique remarquons l'utilisation de PRIMARY KEY) du produit
        ex : 
            row1  name:"riz basmati"
            row2  name:"lentilles vertes"

*/
CREATE TABLE stock_references(
    name VARCHAR(50) NOT NULL PRIMARY KEY,
);

/**
    ref_r_entry represente la relation entre un produit et un de ses examplaires
        - referecence   - l'id du produit (cf. stock_references)
        - entry         - l'id de l'exemplaire (cf. stock_entry) associé
        ex :
            row1 reference:id_riz_basmati,entry:id_riz_basamati_everest 
            row1 reference:id_riz_basmati,entry:id_riz_basamati_billa 
*/
CREATE TABLE ref_r_entry(
    reference INTEGER NOT NULL,
    entry INTEGER NOT NULL,

    PRIMARY KEY (reference, entry),

    FOREIGN KEY (reference) REFERENCES stock_references(rowid),
    FOREIGN KEY (entry) REFERENCES stock_entries(rowid)
);

/**
    Ajoutons plus de pouvoir avec les tags, l'idée est de pouvoir tagger un produit pour pouvoir disposer de catégories de produits.
        - name : ce sera le nom (unique remarquons l'utilisation de PRIMARY KEY) dutag
        ex :
            name:"bio"
            name:"comestible"
            name:"riz" (regroupant plusieurs sortes de riz basmati, complet, sem-complet, blanc, rond, etc ...)
            name:"féculant"
*/
CREATE TABLE tags(
    name VARCHAR(50) PRIMARY KEY
);

/**
    Ici, on se dote d'une hiérarchie de tags. L'idée principale étant que si par exmple on a "riz" qui est le fils de "féculant" alors un produit taggé "riz" aura moralement le tag "féculant" mais on a pas besoin de l'ajouter à chaque fois. En fait, on peut voir ça comme une pseudo-relation d'héritage.
    Warning : il faudra empecher les cycles dans la hiérarchie, ie construire une forêt
    - parent : l'id du tag qui sera le parent du second dans la hiérarchie
    - child :  de fait l'id du tag qui sera ici l'enfant (de fait héritera de toutes les "caractéristiques" du parent

    N.B : la relation est transitive, réflexive et anti-symétrique
    ex :
        parent:id_feculant,child:id_riz
        parent:id_comestible,child:id_feculant
*/
CREATE TABLE tags_relation(
    parent INTEGER NOT NULL,  
    child INTEGER NOT NULL,
    FOREIGN KEY (parent) REFERENCES tags(rowid),
    FOREIGN KEY (child) REFERENCES tags(rowid),
    PRIMARY KEY (parent,child)
);

/**
    Enfin on va lier les tags et les produits
        - reference : l'id du produit que l'on veut lier
        - tag       : l'id du tag lié

        ex:
            reference:id_riz_basmati,tag:id_riz
            (de fait le produit "riz basmati" sera lié au tag "riz", mais aussi par
            héritage au tag "feculant" et au tag "comestible"
*/
CREATE TABLE ref_r_tag(
    reference INTEGER NOT NULL,
    tag INTEGER NOT NULL,

    PRIMARY KEY (reference, tag),

    FOREIGN KEY (reference) REFERENCES stock_references(rowid),
    FOREIGN KEY (tag) REFERENCES tags(rowid)
);


