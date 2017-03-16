# -*- coding: utf-8 -*-
"""
Created on Tue Jan 31 11:36:58 2017

@author: Riheng Zhu
"""
import domineering
import copy 

def move_random(goban,joueur):
    """Playing a random move until the end of the game"""  
    goban_copy = copy.deepcopy(goban)    
    
    go_on = True
    joueur_IA = joueur
        
    while go_on:
        retour = goban_copy.coup_aleatoire(joueur)
        if retour == "pass":  # Si l'un des deux joueurs passe, on arrête  la partie
            go_on = False
        else:
            goban_copy.place_pierre(retour[0],retour[1],retour[2],retour[3],joueur)
            joueur = goban.changer_joueur(joueur)
    
    if joueur == joueur_IA:
        score = 0 # le joueur a perdu
    else:
        score = 1 # le joueur a gagné
    
    return score

def simulation(goban, joueur):
    '''Fonction qui simule nb_partie parties et qui renvoie le score'''
    nb_simulat = 70
    score_total = 0
    goban_copie = copy.deepcopy(goban)
    
    i = 0
    while i < nb_simulat:
        score_total += move_random(goban_copie,joueur)
        i = i+1
    return score_total
    
def best_choice(goban, joueur):
    '''Fonction qui détermine le prochain meilleur coup possible'''
    retour = None
    goban_copy = copy.deepcopy(goban)     
    liste_possible = goban_copy.coup_possible(joueur)
    if not liste_possible:
        retour = "pass"
    else:
        scores_liste = []
        nb_possible = len(liste_possible) # le nombre des coups prochaines possibles
        for i in range(nb_possible):
            coup = liste_possible[i]
            goban_copy.place_pierre(coup[0],coup[1],coup[2],coup[3],joueur)
            scores_liste.append(simulation(goban_copy,joueur))
        best_choice = scores_liste.index(max(scores_liste))
        retour = liste_possible[best_choice]
    return retour
    

        