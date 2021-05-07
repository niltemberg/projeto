
const db = require('../config/db.config');
const Cliente = db.Cliente;

//adicionar um registro na tabela
exports.createCliente = (req,res) => {
    let cliente = {};

    try{
        //capturando os dados do body e criando a constante cliente.
        cliente.nome = req.body.nome;
        cliente.email = req.body.email;
        cliente.idade = req.body.idade;

        //salvar cliente
        Cliente.create(cliente, 
            {attributes: ['id', 'nome', 'email', 'idade']})
            .then(result => {
                res.status(200).json(result);
            });

    }catch(error){
        res.status(500).json({
            message: "Fail",
            error: error.message
        });

    }
}

exports.getCliente = (req, res) => {

    Cliente.findByPk(req.params.id,
        {attributes: ['id', 'nome', 'email', 'idade']})
        .then(cliente => {
            res.status(200).json(cliente);
        }).catch(error => {
            console.log(error);

            res.status(500).json({
                message: "Error",
                error: error
            });
        })
}

exports.clientes = (req, res) => {
    try{
        Cliente.findAll({attributes: ['id', 'nome', 'email', 'idade']})
        .then(clientes => {
            res.status(200).json(clientes);
        })
    }catch(error){
        console.log(error);
        res.status(500).json({
            message: "Error",
            error: error
        });
    }
}

exports.deleteCliente = async (req, res) => {
    try{
        let clienteId = req.params.id;
        let cliente = await Cliente.findByPk(clienteId);

        if(!cliente){
            res.status(404).json({
                message: "Não existe nenhum cliente com o Id: "+clienteId,
                error: "404",
            });
        }else{
            await cliente.destroy();
            res.status(200).json('cliente deletado com sucesso.');
        }
    } catch(error){
        res.status(500).json({
            message: "Error -> Não foi possível deletar o cliente com o Id: "+req.params.id,
            error: error.message
        });
    }
}

exports.updateCliente = async (req, res) => {
    try{
        let cliente = await Cliente.findByPk(req.body.id);

        if(!cliente){
            res.status(400).json({
                message: "Não foi encontrado nenhum cliente com id: "+clienteId,
                error: "404"
            });
        }else{
            let updatedObject = {
                //id: req.body.id,
                nome: req.body.nome,
                email: req.body.email,
                idade: req.body.idade,
            }
            let result = await Cliente.update(updatedObject,
                {
                    returning: true,
                    where: {id: req.body.id},
                    attributes: ['id', 'nome', 'email', 'idade']
                });

                if(!result){
                    res.status(500).json({
                        message: "Error -> Não houve alterações no cliente Id: "+req.params.id,
                        error: "Não pode ser alterado",
                    });
                }
                res.status(200).json('Cliente alterado com sucesso');
        }
    }catch(error){
        res.status(500).json({
            message: "Error -> Não pôde ser alterado o cliente com o id: "+req.params.id,
            error: error.message
        });
    }
}