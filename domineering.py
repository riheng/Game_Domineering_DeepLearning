# -*- coding: utf-8 -*-
"""
Created on Tue Jan 31 10:43:16 2017

@author: Riheng Zhu
"""

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
        
    
    def finis(self,joueur):
        """"Vérifier si le jeu est terminal"""
        if self.coup_possible(joueur) == None:
            return True
        else:
            return False
    
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
    
    goban = Grille(8)
    print(goban)
    liste = goban.coup_possible("black")
    print(liste)
    