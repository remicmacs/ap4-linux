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