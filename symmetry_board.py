# -*- coding: utf-8 -*-
"""
Created on Thu Mar  9 15:26:24 2017

@author: Riheng Zhu
"""

import pandas as pd
import numpy as np

def symmetry_up_down(board):
    """将 n*n 的棋盘做上下对称处理，board是含有n*n个元素的数组"""
    n = 8
    for i in range(int(n/2)): # 第i行
        for j in range(n):  #第j列
            board[i*n + j], board[(n-i-1)*n + j] = board[(n-i-1)*n + j], board[i*n + j]
    return board
    
def symmetry_left_right(board):
    """将 n*n 的棋盘做左右对称处理，board是含有n*n个元素的数组"""
    n = 8
    for i in range(n): # 第i行
        for j in range(int(n/2)):  #第j列
            board[i*n + j], board[i*n + n-j-1] = board[i*n + n-j-1], board[i*n + j]
    return board



fichier = pd.read_csv("log.csv",header = None)  # 读入文件

df = np.array(fichier)
n_ligne = len(df)

for i in range(n_ligne):   #行数
    for j in range(4):     #每行有4个棋盘
        board = df[i][64*j:64*(j+1)]
        symmetry_left_right(board)
        symmetry_up_down(board)
df = pd.DataFrame(df)            

df.to_csv("symtr_upDown_leftRight.csv") #写入文件，生成的文件需要删去第0行，第0列
#df.to_csv("symtr_upDown.csv")
#df.to_csv("symtr_leftRight.csv")
