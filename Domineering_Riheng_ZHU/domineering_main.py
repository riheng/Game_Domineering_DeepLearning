# -*- coding: utf-8 -*-
"""
Created on Wed Mar  1 22:31:25 2017

@author: Riheng Zhu
"""

import domineering as domineering
import monte_carlo as mt
import AI as nn

    
if __name__ == '__main__':
    goban = domineering.Grille(8)
    joueur = "white"
    go_on = True
    
    while go_on:
        print(goban)
        print(joueur)
        coup = nn.prediction_NN(goban,joueur)  #### prediction with monte_carlo
        #coup = mt.best_choice(goban,joueur)   #### prediction with neural_network
        print()
        
        if coup == "pass":
            go_on = False
        else:
            goban.place_pierre(coup[0],coup[1],coup[2],coup[3],joueur)
            joueur = goban.changer_joueur(joueur)
    print(goban)

    