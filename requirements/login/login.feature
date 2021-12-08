Feature: login
Como um cliente
Quero poder acessar minha conta e me manter logado
Para que eu possa ver e responder enquetes de forma rápida.

Cenário: Credenciais válidas
Dado que o cliente informou credenciais válidas
Quando Solicitar para fazer login
Então o sistema deve enviar o usuário para a tela de pesquisas
E manter o usuário conectado

Cenário: Credenciais inválidas
Dado que o cliente informou credenciais inválidas
Quando Solicitar para fazer login
Então o sistema deve enviar o usuário mensagem de erro