#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Mar  8 21:58:58 2017

@author: Wei
"""

from Domineering import p_moves,move,transform,transform_inverse,transform_output,transform_player

from torch.utils.serialization import load_lua
import torch.tensor
from torch.legacy import nn
import numpy as np
 
net = load_lua('network.net')
""" 
use the data of inputs and outputs for a test
#inputs=load_lua('inputs.dat')
#outputs=load_lua('outputs.dat')
#
#out = net.forward(inputs[1])
#
#ind=out.numpy().argmax()
#if ind % 8==0:
#    ind_col=ind%8-1
#    ind_row=7
#else: 
#    ind_col=int(ind/8)
#    ind_row=ind-(ind_col*8)
#print (ind_row,ind_col)

"""
n=8
board_init=np.zeros((n,n),dtype=np.int)  #define a initial empty board

def net_predict(board_init,player):
    """given a board and player, this function can predict the next move
      maximizing the win probability with the result of neural network"""
    #player here is h or v
    board=copy.deepcopy(board_init)
    net = load_lua('network.net')
    result=[]
    moves=p_moves(board,player)
    
    players=["h","v"] 
    if player=="h":
        player=0
    else:player=1
    
    net_input=transform(board)+transform_inverse(board)+transform_player(player)
    net_input=np.array(net_input,dtype=np.float)
    net_input=torch.from_numpy(net_input)
    net_input=net_input.view(3,8,8)    
    out = net.forward(net_input)
    index_move_row,index_move_col,out_possible=[],[],[]
    for m in moves:
        index_move_row.append(m[0][0])
        index_move_col.append(m[0][1])
    for i in range(len(index_move_row)):
        out_possible.append(out[index_move_row[i]][index_move_col[i]])
    index_move=out_possible.index(max(out_possible))
    return moves[index_move]       
    

def play(board_init,player):
    """ this is the main play function, given a board and a start player, 
    it can play directly """
    
    players=["h","v"]
    if player=="h":
        i=2
    if player=="v":
        i=1     
 
    board=copy.deepcopy(board_init)
    count=0
    print ("Start a game!")
    while len(p_moves(board,players[i%2]))!=0 :
        count=count+1
        print ("Current board")
        print(board)
        m_choosed=net_predict(board,players[i%2])
        print ("Player ", players[i%2])
        print ("The move chosed is", m_choosed)
        board=Domineering.move(board,m_choosed[0][0],m_choosed[0][1],m_choosed[1][0],m_choosed[1][1],players[i%2]) 
        print ("Player",players[i%2],"finished, change to player",players[(i+1)%2])
        i=i+1
        
    else:
        print ("Partie finie!")
        print ("Number of coups:", count)
        print ("Winner is ",players[(i+1)%2],"!")
        #print ("number of coups saved", len(res_player))
       # board=copy.deepcopy(board_init)
        
   # return res_board,res_player,res_output 


play(board_init,'h')