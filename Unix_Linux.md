# UNIX

Julien Hochart jul@hochart.fr

## Introduction

### Définition

Multi-tâches et multi-utilisateurs.

UNIX à l'origine AT&T

### Familles

UNIX v6 (1975)

Branches historiques

* System V -> AT&T
* BSD -> Bell Labs

### Historique

#### Les débuts

On part de Multics. Comment mettre un OS temps partagé et multi-utilisateurs.

Puis Bell Labs abandonne le projet. Ritchie et Thompson qui s'y jettent.

* Système de fichiers hiérarchique
* Process
* Fichiers dev
* Shell
* Utilitaires

UNIX v4 : Réécriture en C pour portabilité. À partir de la V8 plus d'assembleur.

Antitrust : Bell Labs est un opérateur télécom. N'avait pas le droit de le distribuer pour autre prix que celui du support et de l'envoi.

#### Années 80

OSF Open Software Foundation formé par les concurrents pour créer un système alternatif OSF/1

1983 : projet GNU par Richard Stallman.

Dev pour usage académique : branche BSD

1990 : BSD 4.3 "Reno" premier système UNIX avec couche TCP/IP

#### La guerre des UNIXs

Multitude d'implémentations et manque de standardisation. Procès dans tous les sens.

1997 débuts du kernel Darwin pour Mac OSX

#### Linux

1991 réimplémentation du Kernel Unix. Utilisation des briques du projet GNU.

#### Années 2000

Dans les variantes commerciales seules Solaris HP-UX et AIX ont survecu

2003 procès SCO contre Linux.

---

Installer : Debian Netinst AMD64 9.8

---

## Concepts UNIX

### Fichiers

Notion de fichier centrale dans tout UNIX

---

Séance du 2019-04-18

## Shell

Programme intermédiaire entre user et system, interpreteur de commande.

## Boot / Shutdown

Kernel : le vrai système, chargé en mémoire

---

Séance du 2019-04-25

## Linux Hardening

"Sécuriser" quelque chose en informatique veut pas dire grand-chose.
Dépend de ce qu'on veut protéger, quel niveau de sécurité on souhaite etc.

### Paysage

Il existe des outils qui permettent de partir d'une *baseline* pour sécuriser un outil.

S'adapter en fonction des besoins pratiques de sécurité.

### Niveaux de sécurité

* Minimal :
  * Auth
  * Comptes/pw
  * Enlever services inutiles
  * Gestion des patchs
* Intermédiaire
  * Firewalling entrant
  * Hardening des services
  * Partitionnement

...

#### Minimal

Eviter de laisser ouvert des ports réseaux ouverts non utilisés/vitaux.

##### Défense en profondeur

Avoir plusieurs couches de défenses de technos différentes sur les chemins entre ce qu'on protège et les points de vulnérabilités.

Attention dépendance à une technologie unique

##### Gestion des patchs

Mise à jour pas pareil sur un serveur de prod que sur workstation. Besoin de gestion, processus de veille *ad hoc* (veille croisée avec les logiciels installés).

##### Logiciels et repos

Utilisation des repos officels de la distro. Gestion des clés.

##### Gestion des pw

pw root utilisé uniquement en dernier recours. Unique pour chaque machine.

##### Binaires setuid setgid

Attention. N'utiliser que sur des programmes qui sont conçus pour fonctionner comme ça.

##### Services

##### Sudo

Pour élever ses privilèges, il faut absolument entrer un password

#### Intermédiaire

##### Config des services

Maitriser les confs par défaut des services utilisés pour éviter les vulnérabilités introduites. Changer port SSH par exemple ou le dirlisting d'apache.

##### Archi d'install

Bits NX (Non executable) XD (Execute Disable) EVP (Enhanced Virus Protection) : bits qui permettent de protéger durant l'exec.

[Ref](https://en.wikipedia.org/wiki/NX_bit)

ASLR Randomisation de la pagination mémoire.

##### Partitionnement

Avec des options de mount pour contrôler les possibilités.

##### Packages

Partir d'une install minimale

##### Ne pas se logguer en root

Créer des comptes nominatifs.