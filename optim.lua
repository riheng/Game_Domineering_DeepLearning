require 'nn'

local inputs=torch.Tensor(28155,3,8,8)
local outputs=torch.Tensor(28155,1,8,8)
local csvFile = io.open('/users/zhuri16/Documents/Domineering/log.csv','r')
local count=0

for line in csvFile:lines('*l') do	
	--print (line)
	local l =line:split(',')
	count =count +1
	--print (count)
	--print (ipairs(l))
	if count <=10000 then

		for key,val in ipairs(l) do
			--print (key)


			v=tonumber(val)
			if key<=64 then
				a=torch.floor(key/8)+1
				
				b=key-torch.floor(key/8)*8
				if b==0 then
					b=8
					a=a-1
				end	
				if count>=19900 then
					---print (count)
					--print (a,b)	
				end	
				--print (a)
				--b=key-torch.floor(key/8)*8
				--print (a,b)

				inputs[count][1][a][b]=v
			end
			if key >64 and key<=128 then
				a=torch.floor(key/8)-7
				b=key-torch.floor(key/8)*8
				--print (a,b)
				if b==0 then
					b=8
					a=a-1
				end
				inputs[count][2][a][b]=v
				--print (a,b)
			end

			if key >128 and key<=192 then
				a=torch.floor(key/8)-15
				b=key-torch.floor(key/8)*8
				--print (a,b)
				if b==0 then
					b=8
					a=a-1
				end
				inputs[count][3][a][b]=v
				--print (a,b)
			end
			if key >192  then
				a=torch.floor(key/8)-23
				--print (a)
				b=key-torch.floor(key/8)*8
				--print (a,b)
				if b==0 then
					b=8
					a=a-1
				end
				outputs[count][1][a][b]=v
				--print (a,b)
				---print (count)
			end


	end

	end
end
 
print (inputs[1][1][1][1])
print("Hello!")

net = nn.Sequential()
couche1 = nn.SpatialConvolution(3, 64, 3, 3, 1, 1, 1, 1)
net:add(couche1)
net:add(nn.ReLU())
net:add(nn.SpatialConvolution(64, 64, 3, 3, 1, 1, 1, 1))
net:add(nn.ReLU())
net:add(nn.SpatialConvolution(64, 64, 3, 3, 1, 1, 1, 1))
net:add(nn.ReLU())
net:add(nn.SpatialConvolution(64, 64, 3, 3, 1, 1, 1, 1))
net:add(nn.ReLU())
net:add(nn.SpatialConvolution(64, 64, 3, 3, 1, 1, 1, 1))
net:add(nn.ReLU())
net:add(nn.SpatialConvolution(64, 64, 3, 3, 1, 1, 1, 1))
net:add(nn.ReLU())
couche2 = nn.SpatialConvolution(64, 1, 3, 3, 1, 1, 1, 1)
net:add(couche2)
net:add(nn.View(64))
net:add(nn.SoftMax())
net:add(nn.View(8, 8))

taille = inputs:size()
n_ligne = taille[1]


require 'optim'
criterion = nn.MSECriterion()
local params, gradParams = net:getParameters()
local optimState = {learningRate = 0.001}

for k = 1, 3 do
    print('Epoch', k)
    local indice_rand = torch.randperm(n_ligne)
    print('Apprentissage')
    local function feval(params)
    	gradParams:zero()
    	for i = 1, 2 * n_ligne / 3 do
	    indice = indice_rand[i]
	    out = net:forward(inputs[indice])
	    loss = criterion:forward(out, outputs[indice])
	    --print(loss)
	    dloss_doutput = criterion:backward(net.output, outputs[indice])
	    net:backward(inputs[indice], dloss_doutput)
	end
    	return loss, gradParams
    end 
  
    optim.sgd(feval,params,optimState)
 
    --calcul de l'erreur moyenne en test
    print("Calcul de l'erreur moyenne en test")
    local erreur_test = 0
    for i = 2 * n_ligne / 3 + 1, n_ligne do
        indice = indice_rand[i]
        out = net:forward(inputs[indice])
        err = criterion:forward(out, outputs[indice])
        erreur_test = erreur_test + err
    end
    print(erreur_test / (n_ligne / 3))
end




