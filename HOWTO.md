HOWTO contribute
================

Description de l'architecture
=============================
Notons *les fichiers temporaires en italiques* et **les dossiers en gras**   

* **db/** : c'est le dossier contenant les fichiers \*.sql permettant de reconstruire les bases de données. Les fichiers \*.db sont les bases de données sql, notons que toutes les bases sont temporaires au sens où elles ne seront pas partager via git (cf. .gitignore). On remarquera que ```make dbreset``` supprime tous les \*.db et les réinitialise à l'aide des \*.sql. 
    * core.sql : ce fichier décrit la base dite "principale" au sens où elle contiendra la substentique moelle de l'application (en gros le stock). On ajoutera si nécessaire d'autre base de données annexes si nécessaire. Décrire signifie, ici, contenir la définition des tables la formant.
    * *core.db* : ce fichier correspondra à une instance temporaire de la base "core", ie c'est ici que seront stockées les différentes données lors de l'utilisation (notons que cette base est persistente jusqu'à suppression du fichier) de l'application. 
* **.git** : c'est le dossier caché qui contient tout le matériel nécessaire au bon fonction du dépôt git.
* .gitignore : c'est le fichier dans lequel on spécifie les fichiers (resp dossiers) qu'on ne va gérer avec git. Notamment, tout ce qui est fichiers temporaires ou alors des fichiers ne concernant que l'éditeur de text d'une personne par exemple (ex: .*.swp pour Vim). Pour la syntax exacte : https://git-scm.com/docs/gitignore
* install-dependencies.sh : c'est un script concernant l'intégration continue. Il permet d'installer les programmes nécessaires à la compilation de l'application sur une VM vierge.
* LICENSE : ce fichier décrit la license sous laquelle est publié le code source. notons que j'utilise ici la GPLv3 en gros c'est de l'open source te permettant de garder un certain contrôle (pour ne pas dur un contrôle certain ;)) sur l'utilisation de ton code source.
* Makefile 
* README.md
* **src/** : ce dossier renferme le code source de l'application et uniquement son code source (pas de donnée, pas de code source externe, etc ...)
    * **core/** : ce dossier contiendra le code source du coeur de l'application ie de la gestion du stock 
    * core.mlpack : ce fichier permet de choisir les sous module logique (pouvant être des dossiers, fichiers) contenu dans **core/** qui doivent être exporter en tant que sous module OCaml du module "Core".
    * **ihm/** : ce dossier contiendra le code source de l'"Interface Homme Machine", qui sera dans un premier temps une interface en ligne de commande avant de devenir une interface graphique.
    * ihm.mlpack : même chose que core.mlpack pour le module Ihm.
    * terrier.ml : c'est le launcher de l'application, c'est à dire le fichier contenant la fonction main (la permière fonction qui sera lancée et la dernière à "s'arréter")
* \_tags : c'est un fichier de config d'ocamlbuild, je les utilise (tout comme les \*.mlpack) pour transformer la hiérarchie de fichiers/dossiers en hiérarchie de module OCaml. Ceci permet d'avoir des inclusions logiques.
* terrier.odocl : c'est le fichier de config d'ocamldoc, on y indique les fichiers à indexer pour la construction de la documentation.
* **tests/** : ce dossier renferme le code sources des tests d'intégration et système. Nota bene les tests unitaires ne sont pas concernés (cf. la section sur l'architecture de test).
    * **integration/** pour les tests dit d'intégration
    * **system/** poir les tests dit système
* .travis.yml : c'est le fichier de configuration de [Travis](https://docs.travis-ci.com), Travis est le prestataire (gratuit) qui nous fournis les VM pour les tests unitaires.

Convention(s) typographique(s)
==============================
L'objectif principal des conventions typographiques est de permettre de *typer* lesobjets (au sens théorie des catégories) que l'on manipule.

* une tabulation correspond à quatre espaces
* les lignes font 80 charactères
* pour le nom des fonctions/méthode 
    1. si elles sont publiques : Snake case ie mot1\_mot2\_mot3
    2. si elles sont privée : on prefixe par un "\_" ie \_mot1\_mot2\_mot3
    3. si ce sont des sous fonctions : on prefixe par un "\_" ie \_mot1\_mot2\_mot3
* pour les constantes globales : en Snake case en majuscule ie NOM1\_NOM2\_NOM3 
* pour les exceptions : en Snake case commençant par une majuscule ie Nom1\_nom2
* pour les paramètres : en Snake case
* pour les variables locales : on prefixe par un "\_" ie \_mot1\_mot2\_mot3
* pour les classes/modules/foncteurs : Caml case ie Nom1Nom2Nom3
* pour les instances de classes/objets : Caml case avec minuscule ie nom1Nom2Nom3
* pour les noms des fichiers : en Snake case

Convention de documentation/commentaires
========================================
Pour générer la doc on utilise l'outil ocamldoc du coup on va définir 
une convention (en accord avec ocamldoc) pour écrire la doc (en gros tout ce qui explique le fonction de l'API) qui sera ensuite 
extraite et assemblée automatiquement. Et une convention pour les commentaires, le commentaire étant l'aide laissée dans une fonction/méthode pour expliquer un point technique (par exemple pourquoi on va chercher à la case ```3*a-1``` d'un tableau) ou alors pour expliquer le fonctionnement d'une fonction/méthode/... privée.

Notons par ailleurs que tout ce qu'on merge/push dans la branche *master* doit être entièrement commenté/documenté. Par ailleurs le code doit être compréhensible en majeur parti sans commentaires ie on utilisera des noms donnant une intuition de la nature/fonction de la chose manipulée.

Pour la documentation
---------------------
La documentation sert à décrire l'API du coup on la met dans les mli avec la spécification. Elle sera ensuite extraite puis assemblée en un jolie mini site web avec [ocamldoc](http://caml.inria.fr/pub/docs/manual-ocaml/ocamldoc.html) (N.B: pour la compiler ```make doc```). Remarquons par ailleurs qu'un bloc de documentation est inclu dans la définition des commentaires OCaml avec une spécification "(**" :
``` (**
Ceci est un bloc de documentation
*)```

N.B : Tout ce qui suit ne concerne que les *\*.mli* et les fichiers *\*.ml* sans *mli* asssocié.
* Pour les fichiers( notons que ce sont moralement des modules grâce au .mlpack) :
On commence le fichier par un bloc de doc décrivant l'objectif moral du fichier, on y ajoutera les remarques générales.
```
(** Description morale
    @author nom auteur1, nom auteur 2
    @version numéro de version du fichier
*)
Contenu du fichier ...
```
* Pour les fonctions/méthodes : 
```
(** Description rapide de la fonction/méthodes (en gros c'est la morale de la fonction qui nous intéresse)
    @param le_nom_du_paramètre_dans_le_ml (n'oublions pas que dans un \*.mli il n'y a que les type des paramètres) - la description du paramètre
    ex : @param b - ceci est le deuxième membre de l'addition 
    @return la description rapide de ce que renvoie la fonction 
    @raise ici on décrit les exceptions qui peuvent être lancer par la fonction (ou alors qui peuvent être propagé par celle ci), on se passera de ce champ dans l'abscence d'exception.
    @exemple f 2 3 => 5 (si on prend f(a,b)= a+b)
*)
val f : int -> int -> int
```
* Pour les exceptions :
```
(**
    Description morale de ce que représente l'exception
    si nécessaire @param name - 
*)
exception Not_found;
```
* Pour les types :
```
(**
    Description morale de ce que représente le type
*)
Définition du type
```
    1.Dans le cas de type somme :
    ```
        (** Top-level stucture*)
        type tl_struct =  
        |Tl_open of string list * string 
        (** handle caml open module
        - name list, code
        - ex: open A.B -> ([A,B], open A.B) *)

        |Tl_var of string * string  
        (** handle variable declaration, 
        if the left-pattern is only one identifier
        - name, code
        - ex: let a = 0 -> (a,let a =1) *) 
    ```
    2. Dans le cas de type produit :
    ```
        (** Description morale du type
            - name champs 1 : description morale
            ...
        *)
        Definition du type
    ```
* Pour les classes/objets :
```
(**
  Description morale de ce que représente la classe
  si nécessaire @param ... pour les paramètres de classe
*)
class Truc : type param_n1 -> ... -> type param_n-> object
    (* Description attribut_1, on utilise un bloc de commentaire car les attributs d'une classe sont toujours privés*)
    val attribut_1 : type attribut_1
    
    ...

    (* Description attribut_n*) 
    val attribut_n : type attribut_n
    
    (** Doc on utilise le même type de  doc que pour les fct*) 
    method methode_1 : type methode_1

    (* Doc on utilise le même type de  doc que pour les fct mais sous forme de 
    commentaire car la méthode est privée*) 
    method prive pmethode_1 : type methode_1
```

Pour les commentaires
---------------------
* Pour décrire l'API privée des modules, classes, sous fonctions on utilisera la même syntaxe. Cependant on remplacera le ```(**``` par ```(*``` pour qu'*ocamldoc* ignore les commentaires. 
``` (*
Ceci est un commentaire
*)
```

* De plus on se servira des commentaires pour expliquer rapidement les parties 
algorithmiques non triviales. Typiquement, qd on utilise des calculs bizarre pour accéder à un tableau ie on au tour de boucle i on accède à la case "2^i-1".
* On s'en servira aussi pour pointer vers des références extérieures à l'aide de "@see ref"

Architecture du système de test
===============================
Le système de test sera diviser en grandes parties, classées par ordre d'apparition dans le projet. L'unique objectif de ce système est de garantir la robustesse du système. Pour la suite on developpera probablement un système de test de performance.

Architecture du code de tests
-----------------------------
1. Les tests unitaires :
    * ils permettent le test en isolation complète d'une fonction, méthode. Par exemple si on écrit une fonction de tri, on va la tester sur des cas moyens et sur les cas extreme puis vérifier que les résultats sont correctes. En gros, ça permet de vérifier qu'une spécification atomique est vérifiée.
Du coup, chaque module/class exportera une fonction ``̀ val unittest : unit -> OUnit2.test ``` qui exportera les tests unitaires. En faisant ça les fonction de tests unitaires seront interne au module/classé du coup elle pourront notamment tester les fonction/méthode privée. 
Par ailleurs on veillera à toujours propager les fonctions ```unittest``` des sous module/sous classe à travers la fonction ```unittest``` courante.
    * ils testes en isolation le comportement extérieur d'un module, d'une classe. 
2. Les tests d'intégration :
L'idée est des tester l'interaction entre les differents modules/classes
C'est tests seront localisés dans le dossier **tests/integration/**. Qui aura une architecture très similaire au dossier **src\** sauf que chaque fichier/dossier sera prefixé par "test\_". Du coup, ils exporteronts une seul fonction (que l'on veillera à bien propager) ```integrationtest : unit -> OUnit.test```.
3. Les tests systèmes :
On veut ici vérifier que le comportement externe du programme (fonctionnnant en boite noire) soit conforme au spécification. On les intégrera dans le dossier **tests/system/**

La gestion des tests
--------------------
On utilisera le concept d'intégration continue

1. Sur la machine du développeur :
Avant de pusher sur une branche quelconque on lance les tests unitaires ```make unittests```.
Avant de pusher sur la branche *master* on lancera  les tests unitaires et les 
tests d'intégrations ```make tests```.
N.B : des fichiers de log seront créés à chaque lancement des tests.
2. Via un prestataire d'intégration continue (Travis) :
A chaque fois qu'on pushera sur le dépot git, il instencira une VM et lancera tous les tests sur une machine vierge. En cas de failed on aura un rapport par mail. 


La genèse des tests
-------------------
Quand on écrit une fonction (resp méthode, etc...) avant de commencer à écrire la 
fonction de test unitaire proprement. On peut entrelacer le code et des tests à l'aide d'```assert();``` ensuite qd la fonction sera utilisable on migrera on traduira les ```assert();``` en tests unitaires.


Le système de branches git
==========================
Les commits
-----------
Ils devront avoir une structure logique (ie si on fait plein de modification qui n'ont aucun rapport on les ajoutera par commits succéssifs). Du coup il seront toujours consitué d'une brève description morale, pour les commit important on fera une enumération morale des choses importantes modifiées.

Les branches 
------------
1. core :
    On developpera le coeur en isolation sur sa propre branche, ie tout ce qui touche à **src/core/**.
2. ihm :
    On developpera l'IHM en isolation sur sa propre branche, ie tout ce qui touche à **src/ihm/**. 
3. futur :
    Cette branche servira à tester des idées
3. master :
    On ne pushera sur master que des trucs fonctionnels en isolation et proprement tester. L'idée de cette branche est de se diriger vers la future release.
    Les commentaire de commits commenceront par un numéro de version de la forme ```v[0-9]+\.[O-9]+\.[0-9]+-[dev|alpha|beta|prod]``` :
        * le premier nombre correspond au numéro de version principale, il sera incrémenté pour des raisons politiques ou alors si on casse la rétrocompatibilité de l'API
        * le deuxième nombre sera incrémenté si :
            * on ajoute une fonctionnalité
            * on casse localement la rétro-compatibilité de l'API
            * on corrige des bugs/failles majeur(e)s
        * le troisième nombre sera incrémenté si :
            * dans le cas général d'un commit (ajout de commentaire, correction mineures, développement d'une partie interne d'un module, d'une fonction, etc...)
        * le groupe alphabétique [dev|alpha|beta|prod] permet de donner une  idée du status de la branche master (et donc en gros du status du programme). Notons que dans le cas du passage de *dev* vers *alpha*, *alpha* vers *beta*, *beta* vers *prod* on n'incrementera pas de nombre.
            * dev : ceci est une version de devellopement avec une partie des fonctionnalités non présentes
            * alpha : ceci signifie que la majeure partie des fonctionnalités sont présentes et qu'on va commence les tests systèmes en gros
            * beta : toutes les fonctionnalités sont présentes pour la future release, on ne fait plus que des corrections mineures et des tests
            * prod : ça veut dire qu'on sort la release, et qu'on fait juste des corrections de bugs.

Les outils utiles :
===================
* ocamldebug : debugger OCaml
            

    
