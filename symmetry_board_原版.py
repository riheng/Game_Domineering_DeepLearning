# -*- coding: utf-8 -*-
"""
Created on Thu Mar  9 15:26:24 2017

@author: Riheng Zhu
"""

import pandas as pd
import numpy as np

def symmetry_up_down(board):
    """将 n*n 的棋盘做上下对称处理"""
    n = len(board)
    for i in range(int(n/2)):
        for j in range(n):
            board[i][j], board[n-i-1][j] = board[n-i-1][j], board[i][j]
    return board
    
def symmetry_left_right(board):
    """将 n*n 的棋盘做左右对称处理"""
    n = len(board)
    for i in range(n):
        for j in range(int(n/2)):
            board[i][j], board[i][n-j-1] = board[i][n-j-1], board[i][j]
    return board

def affiche(board):
	"""显示单个棋盘"""
    for i in range(len(board)):
        print(board[i])
    print("\n")


fichier = pd.read_csv("log.csv",header = None)  # 读入文件

df = np.array(fichier)

N = 8 # 定义一个8*8的棋盘
n_ligne = len(df)
n_col = len(df[0])


for i in range(n_ligne):   #行数
    for j in range(4):     #每行有4个棋盘
        board = []
        for p in range(8):  # 每个棋盘有8行
            arr = []
            for q in range(8):   # 每个棋盘有8列
                arr.append(df[i][j*64 + p*8 + q])
            board.append(arr)
        #affiche(board)
        symmetry_left_right(board)
        symmetry_up_down(board)

df = pd.DataFrame(df)            

df.to_csv("symtr_upDown_leftRight.csv") #写入文件，生成的文件需要删去第0行，第0列
