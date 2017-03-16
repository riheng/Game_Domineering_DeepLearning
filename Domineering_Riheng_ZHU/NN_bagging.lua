require 'nn'
require 'optim'

-------------------------loader data set inputs and outputs 

local inputs1 = torch.load('/home/zhu/Documents/data_dat/inputs.dat')
local inputs2 = torch.load('/home/zhu/Documents/data_dat/inputs_upDown.dat')
local inputs3 = torch.load('/home/zhu/Documents/data_dat/inputs_leftRight.dat')
local inputs4 = torch.load('/home/zhu/Documents/data_dat/inputs_upDown_leftRight.dat')

local outputs1 = torch.load('/home/zhu/Documents/data_dat/outputs.dat')
local outputs2= torch.load('/home/zhu/Documents/data_dat/outputs_upDown.dat')
local outputs3 = torch.load('/home/zhu/Documents/data_dat/outputs_leftRight.dat')
local outputs4 = torch.load('/home/zhu/Documents/data_dat/outputs_upDown_leftRight.dat')


-------------------------Cross_validtation, get the train_set and test_set

local cross_validation = function(inputs, outputs)
	taille = inputs:size()
    n_ligne = taille[1]	
	local indice_rand = torch.randperm(n_ligne)
	
	debut = torch.floor(2*n_ligne / 3)   -- traing_set / test_set = 7/3
	fin = n_ligne -  debut
	
	inputs_train = torch.Tensor(debut, 3, 8, 8)
	outputs_train = torch.Tensor(debut, 1, 8, 8)
	inputs_test = torch.Tensor(fin, 3, 8, 8)
	outputs_test = torch.Tensor(fin, 1, 8, 8)
	
	for i = 1, debut do
        indice = indice_rand[i]
		inputs_train[i] = inputs[indice]
		outputs_train[i] = outputs[indice]
	end
	
	for i = debut+1, n_ligne   do
		indice = indice_rand[i]
		inputs_test[i - debut] = inputs[indice]
		outputs_test[i - debut] = outputs[indice]
	end
	return inputs_train, inputs_test, outputs_train, outputs_test
end
	
inputs1_train, inputs1_test, outputs1_train, outputs1_test = cross_validation(inputs1, outputs1)
inputs2_train, inputs2_test, outputs2_train, outputs2_test = cross_validation(inputs2, outputs2)
inputs3_train, inputs3_test, outputs3_train, outputs3_test = cross_validation(inputs3, outputs3)
inputs4_train, inputs4_test, outputs4_train, outputs4_test = cross_validation(inputs4, outputs4)


-------------------------Set the parametre of Neural_network
local neural_network = function ()
	net = nn.Sequential()
	input_layer = nn.SpatialConvolution(3,64,3,3,1,1,1,1)
	net:add(input_layer)
	net:add(nn.ReLU())
	net:add(nn.SpatialConvolution(64,64,3,3,1,1,1,1))
	net:add(nn.ReLU())
	output_layer = nn.SpatialConvolution(64,1,3,3,1,1,1,1)
	net:add(output_layer)
	net:add(nn.View(64))
	net:add(nn.SoftMax())
	net:add(nn.View(8,8))
	return net
end

------------------------- Trainning the data  in neural_network, get 4 module 

local training = function (inputs,outputs)
    
    net = neural_network()
    
    taille = inputs:size()
    n_ligne = taille[1]
    criterion = nn.MSECriterion()
    
	params, gradParams = net:getParameters()
	optimState = {learningRate = 0.001}
	
    for k = 1,1 do
        print("**********Epoch", k)
        local indice_rand = torch.randperm(n_ligne)

        print("Training:")
        local error_train = 0
		
		local function feval(params)
    		gradParams:zero()
    		for i = 1, 2 * n_ligne / 3 do
	    		indice = indice_rand[i]
	    		out = net:forward(inputs[indice])
	    		loss = criterion:forward(out, outputs[indice])
	    		error_train = loss + error_train
	    		--print(loss)
	    		dloss_doutput = criterion:backward(out, outputs[indice])
	    		net:backward(inputs[indice], dloss_doutput)
			end
    		return loss, gradParams
    	end 
  
    	optim.sgd(feval,params,optimState)
		
        --print(error_train / (n_ligne) * 2 / 100)
        print(error_train / (n_ligne) * 2 / 3)

        print("Test:")
        local error_test = 0
        --for i = 98 * n_ligne / 100, n_ligne do
        for i = 2 * n_ligne / 3, n_ligne do
            indice = indice_rand[i]
	        out = net:forward(inputs[indice])
	        err = criterion:forward(out, outputs[indice])
	        error_test = error_test + err
        end
        --print(error_test / (2* n_ligne / 100))
        print(error_test / (n_ligne / 3))
    end
    return net
end

print("***************Training*******************")
local net1 = training(inputs1_train, outputs1_train) 
local net2 = training(inputs2_train, outputs2_train) 
local net3 = training(inputs3_train, outputs3_train) 
local net4 = training(inputs4_train, outputs4_train) 


-------------------------Prediction with the test_set

local test = function (net, inputs, outputs)
	taille = inputs:size()
    n_ligne = taille[1]
	criterion = nn.MSECriterion()
	print("Test:")
    local error_test = 0
    --for i = 1, n_ligne/100 do
	for i = 1, n_ligne do
		out = net:forward(inputs[i])
		err = criterion:forward(out, outputs[i])
		error_test = error_test + err
    end
    --print(error_test / n_ligne /100)
    print(error_test / n_ligne )
end


print("***************Prediction*******************")
test(net1,inputs1_test, outputs1_test )
test(net2,inputs2_test, outputs2_test )
test(net3,inputs3_test, outputs3_test )
test(net4,inputs4_test, outputs4_test )

-------------------------Using bagging to improve the performance of the test_set
local symmetry_upDown = function(board)
    taille = board:size()
    n = taille[1]
    for i = 1, n/2 do
        for j = 1, n do
            board[i][j], board[n-i+1][j] = board[n-i+1][j], board[i][j]
        end
    end
    return board
end 

local symmetry_leftRight = function(board)
    taille = board:size()
    n = taille[1]
    for i = 1, n do
        for j = 1, n/2 do
             board[i][j], board[i][n-j+1] = board[i][n-j+1], board[i][j]
        end
    end
    return board
end

local bagging = function (inputs1,   inputs2,  inputs3,   inputs4, outputs1)
    taille = inputs1:size()
    n_ligne = taille[1]
    criterion = nn.MSECriterion()
    
    print("Test:")
    local error_test = 0
    --for i = 1, n_ligne/100 do
    for i = 1, n_ligne do
	    out1 = net1:forward(inputs1[i])
        out2 = net2:forward(inputs2[i]) -- modifier
        out3 = net3:forward(inputs3[i]) -- modifier
        out4 = net4:forward(inputs4[i]) -- modier
        
        out2 = symmetry_upDown(out2)
        out3 = symmetry_leftRight(out3)
        out4 = symmetry_upDown(out4)
        out4 = symmetry_leftRight(out4)
        
        out_averg = (out1+out2+out3+out3)/4
        out_averg = out1
        
	    err = criterion:forward(out_averg, outputs1[i])
	    error_test = error_test + err
    end
    --print(error_test / n_ligne /100)
    print(error_test / n_ligne )
    
end

print("***************Prediction with bagging*******************")
bagging(inputs1_test, inputs2_test,  inputs3_test, inputs4_test, outputs1_test)

print("success. end")

