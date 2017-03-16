# -*- coding: utf-8 -*-
"""
Created on Tue Jan 31 10:43:16 2017

Rules:
The first player (White) must place them horizontally
the second player (Black) must place them vertically


@author: Riheng Zhu
"""
import random


class Grille():
    def __init__(self,taille):
        self.taille = taille
        self.grille = self.creation()
        pass
    
    def __repr__(self):
        """Permet de l'affichage de la grille dans la console"""
        line = ''
        for i in range(self.taille):
            for j in range(self.taille):
                value = self.grille[(i,j)]
                value = str(value)
                line =  line + '  ' + value
            line = line + '\n'
        return line      
    
    def creation(self):
        """Créer une grille de dimension taille*taille"""        
        grille = {}   
        for i in range(self.taille):
            for j in range(self.taille):
                grille[(i,j)] = Case(i,j)
        
        return grille
    
    def place_pierre(self,i1,j1,i2,j2,joueur):
        """Place la pierre"""
        case1 = self.grille[(i1,j1)]
        case2 = self.grille[(i2,j2)]
        case1.couleur = joueur
        case2.couleur = joueur
    
    def coup_possible(self,joueur):
        """Listing the possible moves"""
        liste_possible = []
        if joueur == "white":
            for i in range(self.taille):
                for j in range(self.taille-1):
                 if self.grille[(i,j)].couleur == None and self.grille[(i,j+1)].couleur == None:
                     liste_possible.append([i,j,i,j+1])
        else:
            for j in range(self.taille):
                for i in range(self.taille-1):
                 if self.grille[(i,j)].couleur == None and self.grille[(i+1,j)].couleur == None:
                     liste_possible.append([i,j,i+1,j])
            pass
        return liste_possible    
    
    def coup_aleatoire(self,joueur):
        """Choisis au hasard une case parmi la liste des coups possibles pour un joueur donné"""
        retour = None        
        liste_possible = self.coup_possible(joueur)
        if(len(liste_possible) != 0):
            rand = random.randint(0,len(liste_possible)-1)
            retour = liste_possible[rand]
        else:
            retour = "pass"
        return  retour
    
    def finis(self,joueur):
        """"Vérifier si le jeu est terminal"""
        if len(self.coup_possible(joueur)) == 0:
            return True
        else:
            return False
            
    def changer_joueur(self,joueur):
        """ Fonction de changement de joueur"""
        if joueur=="black":
            joueur="white"
        else :
            joueur="black"
        return joueur
    
    
class Case():
    def __init__(self,i,j):
        self.i = i
        self.j = j
        self.couleur = None
        
    def __repr__(self):
        """Pour la representation console"""
        if self.couleur == None:
            return '.'
        elif self.couleur == 'black':
            return 'x'
        elif self.couleur == 'white':
            return 'o'


      
if __name__ == "__main__":
    
    goban = Grille(3)
    print(goban.coup_possible("white"))
    goban.place_pierre(0,1,0,2,"white")
    print(goban)
    print(goban.coup_possible("black"))
    goban.place_pierre(0,0,1,0,"black")
    print(goban)
    print(goban.coup_possible("white"))
    goban.place_pierre(2,0,2,1,"white")
    print(goban)
    print(goban.coup_possible("black"))
    goban.place_pierre(1,2,2,2,"black")
    print(goban)
    print(goban.coup_possible("white"))
    print(goban.finis("white"))
    
    
    