require('torch')
require('nn')
require('optim')

local inputs = torch.load('/Users/wuminhui/Documents/Agro3Asemestre2/heuristique/rendre/cnn_inputs.dat')
local outputs = torch.load('/Users/wuminhui/Documents/Agro3Asemestre2/heuristique/rendre/cnn_outputs.dat')
local optimState = {learningRate=0.01} 

net = nn.Sequential()
couche1 = nn.SpatialConvolution(3, 64, 3, 3, 1, 1, 1, 1)
net:add(couche1)
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


criterion = nn.MSECriterion()


params, gradParams = net:getParameters()


step = function(batch_size)
    local erreur_train = 0
    local erreur_test = 0
    local count = 0
    local indice_rand = torch.randperm(n_ligne)
    batch_size = 51
    for t = 1, 2 * n_ligne / 3 , batch_size do
        -- setup inputs and targets for this mini-batch
        local size = math.min(t + batch_size - 1, 2 * n_ligne / 3) - t
        --print ('in ',inputs[indice_rand[1]+1])
        --print ('out ',outputs[indice_rand[1]+1])
        local inp = torch.Tensor(size, 3, 8, 8)--:cuda()
        local out = torch.Tensor(size, 1, 8, 8)--:cuda()
        for i = 1,size do
            indice = indice_rand[i+t]
            --print (indice+t)
            local input_mini = inputs[indice]
            local output_mini = outputs[indice]

            inp[i] = input_mini
            out[i] = output_mini
        end
        --print (#inp)
        --print ('before ',out)
        out:add(1)
        --print ('after ',out)
        local feval = function(params_new)
            -- reset data
            if params ~= params_new then params:copy(params_new) end
            index = (index or 0) + 1
            if index >(#inp)[1] then index = 1 end
            net:zeroGradParameters()

            -- perform mini-batch gradient descent
            local outs = net:forward(inp)
            loss = criterion:forward(outs, out)
            --print (loss)
            local dloss_doutput = criterion:backward(outs, out)
            net:backward(inp, dloss_doutput)

            return loss, gradParams
        end
        optim.sgd(feval,params,optimState)
        --print ('loss = ',loss)
        erreur_train = erreur_train + loss
        --print (erreur_train,t)
    end

    for t = 2 * n_ligne / 3 + 1, n_ligne, batch_size do
        -- setup inputs and targets for this mini-batch
        local size = math.min(t + batch_size - 1, n_ligne) - t
        --print ('in ',inputs[indice_rand[1]+1])
        --print ('out ',outputs[indice_rand[1]+1])
        local inp = torch.Tensor(size, 3, 8, 8)--:cuda()
        local out = torch.Tensor(size, 1, 8, 8)--:cuda()
        for i = 1,size do
            indice = indice_rand[i+t]
            --print (indice+t)
            local input_mini = inputs[indice]
            local output_mini = outputs[indice]

            inp[i] = input_mini
            out[i] = output_mini
        end
        --print (#inp)
        --print ('before ',out)
        out:add(1)

        outs = net:forward(inp)
        err = criterion:forward(outs, out)
        erreur_test = erreur_test + err
    --print ('train error = ', erreur_train / (n_ligne / 3))
    --return erreur_train / (n_ligne / 3)
    end
    --calcul de l'erreur moyenne en test
    --print("Calcul de l'erreur moyenne en test")
    --print("test error = ",erreur_test / (n_ligne / 3))

    --print ("finish!")
    return erreur_train / (2 * n_ligne / 3), erreur_test / (n_ligne / 3)

end


max_iters = 2

do
    for i = 1,max_iters do
        local loss_train, loss_test = step()
        print(string.format('Epoch: %d Current loss: %4f', i, loss_train))
        print(string.format('Error on the test set: %4f', loss_test))
        
    end
end

