# -*- coding: utf-8 -*-
"""
Created on Wed Mar  1 22:31:25 2017

@author: Riheng Zhu
"""

import domineering as domineering
import monte_carlo as mt

#if __name__ == '__main__':
#    goban = domineering.Grille(8)
#    joueur = "white"
#    go_on = True
#    
#    while go_on:
#        coup = mt.best_choice(goban,joueur)
#        
#        if coup == "pass":
#            go_on = False
#        else:
#            goban.place_pierre(coup[0],coup[1],coup[2],coup[3],joueur)
#            joueur = goban.changer_joueur(joueur)
#    print(goban)

    
    
    
if __name__ == '__main__':
    goban = domineering.Grille(6)
    joueur = "white"
    go_on = True
    print(goban)
    
    while go_on:
        print(joueur)
        
        print("可能的选择：",len(goban.coup_possible(joueur)))
        print(goban.coup_possible(joueur))
        coup = mt.best_choice(goban,joueur)
        print("最好的选择：", coup)
        #coup = goban.coup_aleatoire(joueur)
        #print("随机的选择",coup)
        
        
        if coup == "pass":
            go_on = False
        else:
            goban.place_pierre(coup[0],coup[1],coup[2],coup[3],joueur)
            print(goban)
            joueur = goban.changer_joueur(joueur)
    print(goban)
    
    
#    goban.place_pierre(3,3,3,4,"white")
#    mt.changer_joueur(joueur)
#    score = mt.simulation(goban,joueur)
#    print(score)
#    coup = mt.best_choice(goban,joueur)
#    print(coup)

    