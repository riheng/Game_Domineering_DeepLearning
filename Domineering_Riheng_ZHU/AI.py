#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Mar 11 11:54:48 2017

@author: zhu
"""

import domineering as domineering

from torch.utils.serialization import load_lua
import torch.tensor
from torch.legacy import nn
import numpy as np
import copy


def transform(goban):
    """
    Reprensenter the goban with the form of array.
    if the grid is not null, the value is 1, otherwise, is 0 
    """
    board = []
    for i in range(goban.taille):
        arr = []
        for j in range(goban.taille):
            if goban.grille[(i,j)].couleur == None:
                arr.append(0)
            else:
                arr.append(1)
        board.append(arr)
        
    return board
    

def inverse(board):
    """Inverse the board. """
    board_inverse = []
    for i in range(len(board)):
        arr = []
        for j in range(len(board[0])):
            if board[i][j] == 1:
                arr.append(0)
            else:
                arr.append(1)
        board_inverse.append(arr)
        
    return board_inverse
           
            
def symmetry_up_down(board):
    """"""
    n = len(board)
    for i in range(int(n/2)):
        for j in range(n):
            board[i][j], board[n-i-1][j] = board[n-i-1][j], board[i][j]
    return board
    
    
def symmetry_left_right(board):
    """"""
    n = len(board)
    for i in range(n):
        for j in range(int(n/2)):
            board[i][j], board[i][n-j-1] = board[i][n-j-1], board[i][j]
    return board

    
def affiche(board):
    """affiche the board """
    for i in range(len(board)):
        print(board[i])
    print("\n")

def creat_inputs(goban,joueur):
    """Creat the dataset for neural network"""
    inputs = torch.Tensor(3,8,8)
    
    board = transform(goban)
    board = np.array(board, dtype=np.float)
    board = torch.from_numpy(board)

    board_inverse = inverse(board)
    board_inverse = np.array(board_inverse, dtype=np.float)
    board_inverse = torch.from_numpy(board_inverse)
    
    if joueur == 'white':
        board_joueur = torch.Tensor(8,8).fill_(1)
    else:
        board_joueur = torch.Tensor(8,8).fill_(1)
    
    inputs[0] = board
    inputs[1] = board_inverse
    inputs[2] = board_joueur

    inputs = inputs.double()
    return inputs


    
def prediction_NN(goban, joueur):
    '''Fonction qui détermine le prochain meilleur coup possible par reural_network'''
    retour = None
    goban_copy = copy.deepcopy(goban)  

    net = load_lua('/home/zhu/Documents/neural_network.net')
    
    inputs = creat_inputs(goban,joueur)
    print(inputs.size())
    print(inputs[0])
    print(inputs[1])
    print(inputs[2])


    out = net.forward(inputs)
    print("out:")
    print(out)
    
    liste_possible = goban_copy.coup_possible(joueur)
    if not liste_possible:
        retour = "pass"
    else:
        possiblite = []
        nb_possible = len(liste_possible) # le nombre des coups prochaines possibles
        for i in range(nb_possible):
            coup = liste_possible[i]
            i, j = coup[0], coup[1]
            possiblite.append(out[i][j])
        best_choice = possiblite.index(max(possiblite))
        retour = liste_possible[best_choice]
    return retour
    
