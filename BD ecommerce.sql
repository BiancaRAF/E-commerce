-- Banco de Dados E-commerce

create database if not exists ecommerce;

use ecommerce;

-- tabela cliente ok

create table cliente(
	idCliente int auto_increment primary key,
    isCPF bool not null default true,
    fone_1_cliente varchar(14) not null,
    fone_2_cliente varchar(14),
    email_cliente varchar(25) not null
);

-- tabela conta PF ok

create table contaPF(
	idContaPF int auto_increment primary key,
    idCliente int,
    PNome varchar(20) not null,
    MNome varchar(5),
    Sobrenome varchar(20) not null,
    CPF_cliente char(11) not null,
    constraint unique_cpf_cliente unique(CPF_cliente),
    DataNasc date,
    constraint fk_idCliente_PF foreign key (idCliente) references cliente(idCliente)
);

-- tabela conta PJ ok

create table contaPJ(
	idContaPJ int auto_increment primary key,
    idCliente int,
    razaoSocial varchar(20) not null,
    CNPJ_cliente char(14) not null,
    constraint unique_cnpj_cliente unique(CNPJ_cliente),
    constraint fk_idCliente_PJ foreign key (idCliente) references cliente(idCliente)
);

-- tabela produto ok

create table produto(
	idProduto int auto_increment primary key,
    valor float not null,
    categoria enum('Alimentos', 'Eletrônicos', 'Vestimenta', 'Diversos', 'Brinquedos') not null default 'Diversos',
    descricaoProduto varchar(45) not null,
    avaliacao int not null default 0,
    constraint chk_avaliacao check(avaliacao >= 0 or avaliacao <= 5),
    infantil bool,
    pesoProduto float not null,
    alturaProduto float not null,
    comprimentoProduto float not null
);

-- tabela entrega ok

create table entrega(
	idEntrega int auto_increment primary key,
    logradouro varchar(20) not null,
    numero varchar(5) not null,
    bairro varchar(15) not null,
    cidade varchar(15) not null,
	estado varchar(2) not null,
    pais varchar(15) not null,
    CEP varchar(10) not null,
	complemento varchar(25),
    codRastreio varchar(25) not null
);

-- tabela pedido ok

create table pedido(
	idPedido int auto_increment primary key,
    idCliente_Pedido int,
    idPedido_Entrega int,
    statusPedido enum('Análise', 'Enviado', 'Entregue', 'Cancelado', 'Em andamento', 'Processando') not null default 'Processando',
    descricaoPedido varchar(45),
    constraint fk_idCliente_Pedido foreign key (idCliente_Pedido) references cliente(idCliente)
		on delete cascade
        on update cascade,
    constraint fk_idEntrega_Pedido foreign key (idPedido_Entrega) references entrega(idEntrega)
		on delete cascade
        on update cascade
);
select * from contaPF;

-- tabela fornecedor ok

create table fornecedor(
	idFornecedor int auto_increment primary key,
    razaoSocial_forn varchar(20) not null,
    CNPJ_fornecedor char(14) not null,
    constraint unique_cnpj_fornecedor unique(CNPJ_fornecedor),
    fone_1_forn varchar(14) not null,
    fone_2_forn varchar(14),
    email_forn varchar(20) not null,
    endereco_forn varchar(45)
);

-- tabela estoque ok

create table estoque(
	idEstoque int auto_increment primary key,
    endereco_estq varchar(45) not null,
    ticketDeposito_estq varchar(20) not null,
    constraint unique_ticket_dep unique(ticketDeposito_estq)
);

-- tabela Vendedor Terceirizado ok

create table vendTerceirizado(
	idVendTerceirizado int auto_increment primary key,
    razaoSocial_Terc varchar(20) not null,
    endereco_Terc varchar(45) not null,
    nomeFantasia_Ter varchar(20) not null,
    CNPJ_Terc char(14) not null,
    constraint unique_cnpj_terc unique(CNPJ_terc),
    fone_1_Terc varchar(14) not null,
    fone_2_Terc varchar(14),
    email_Terc varchar(20) not null
);

-- tabela Pagamento ok

create table pagamento(
	idPagamento int auto_increment primary key,
    idPagPedido int,
    tipoPagamento enum('Boleto', 'Débito', 'Cartão de Crédito', 'PIX') not null default 'Cartão de Crédito',
	valorProd float not null,
    valorFrete float not null,
    constraint fk_pagamento_pedido foreign key (idPagPedido) references pedido(idPedido)
		on delete cascade
        on update cascade
);

-- tabela Cartão ok

create table cartao(
	idCartao int auto_increment primary key,
	numero varchar(16),
    mesVenc char(2),
    anoVenc char(2),
    CPF_Dono char(11) not null
);

-- -- -- Tabelas com foreign keys (tabelas auxiliares) -- -- -- 

-- Tabela do relacionamento Produto e Fornecedor ok

create table relProdutoFornecedor(
	idRelFornecedor int,
    idRelProduto int,
    primary key(idRelFornecedor, idRelProduto),
	constraint fk_rel_forn foreign key (idRelFornecedor) references fornecedor(idFornecedor)
		on delete cascade
        on update cascade,
	constraint fk_rel_prod foreign key (idRelProduto) references produto(idProduto)
		on delete cascade
        on update cascade,
    qtdProdForn int not null,
    constraint chk_qtdProdForn check(qtdProdForn >= 0),
	statusProdForn enum('Disponível', 'Sem estoque', 'Indisponível') not null default 'Disponível'
);

-- Tabela do relacionamento Produto e Vendedor ok

create table relProdutoVendedor(
	idRelVendedor int,
    idRelProduto int,
    primary key(idRelVendedor, idRelProduto),
	constraint fk_rel_vend foreign key (idRelVendedor) references vendTerceirizado(idVendTerceirizado)
		on delete cascade
        on update cascade,
	constraint fk_rel_prod_vend foreign key (idRelProduto) references produto(idProduto)
		on delete cascade
        on update cascade,
    qtdProdVend int not null,
    constraint chk_qtdProdVend check(qtdProdVend >= 0),
	statusProdVend enum('Disponível', 'Sem estoque', 'Indisponível') not null default 'Disponível'
);

-- Tabela do relacionamento Produto e Estoque ok

create table relProdutoEstoque(
	idRelEstoque int,
    idRelProduto int,
    primary key(idRelEstoque, idRelProduto),
	constraint fk_rel_estq foreign key (idRelEstoque) references estoque(idEstoque)
		on delete cascade
        on update cascade,
	constraint fk_rel_prod_estq foreign key (idRelProduto) references produto(idProduto)
		on delete cascade
        on update cascade,
    qtdProdEstq int not null,
    constraint chk_qtdProdEstq check(qtdProdEstq >= 0),
	statusProdEstq enum('Disponível', 'Sem estoque', 'Indisponível') not null default 'Disponível'
);

-- Tabela do relacionamento Produto e Pedido ok

create table relProdutoPedido(
	idRelPedido int,
    idRelProduto int,
    primary key(idRelPedido, idRelProduto),
	constraint fk_rel_Pedido foreign key (idRelPedido) references pedido(idPedido)
		on delete cascade
        on update cascade,
	constraint fk_rel_prod_pedido foreign key (idRelProduto) references produto(idProduto)
		on delete cascade
        on update cascade,
    qtdProdPedido int not null,
    constraint chk_qtdProdPedido check(qtdProdPedido >= 1)
);

-- Tabela do relacionamento Pagamento se cartão ok

create table relPagamentoCartao(
	idRelPagamento int,
    idRelCartao int,
    primary key(idRelPagamento, idRelCartao),
	constraint fk_rel_Pagamento foreign key (idRelPagamento) references pagamento(idPagamento)
		on delete cascade
        on update cascade,
	constraint fk_rel_Cartao foreign key (idRelCartao) references cartao(idCartao)
		on delete cascade
        on update cascade
);

-- -- -- Persistências -- -- --

insert into cliente(isCPF, fone_1_cliente, fone_2_cliente, email_cliente) values 
					(true, '8599754596', null, 'andre@hotmail.com'),
                    (false, '75984758957', '7598475477', 'joana@outlook.com'),
                    (true, '11928237176', null, 'ana@gmail.com'),
                    (true, '71983704049', '51980470819', 'lora@outlook.com'),
                    (false, '62993276057', '91938010555', 'jose@yahoo.com'),
                    (true, '71911071125', '11928234444', 'carol@gmail.com'),
                    (false, '91938010942', null, 'ingrid@gmail.com');

insert into contaPF(idCliente,PNome,MNome,Sobrenome,CPF_cliente,DataNasc) values 
	(1, 'Andre', 'B', 'Oliveira', '65216973079', '1995-11-26'),
    (3, 'Ana', 'C', 'Silva', '28558908028', '1969-03-04'),
    (4, 'Lora', 'J', 'Santos', '40980862043', '1989-02-20'),
    (6, 'Carol', 'H', 'Oliveira', '12202153098', '2000-12-11');
    
insert into contaPJ(idCliente,razaoSocial,CNPJ_cliente) values 
	(2, 'JOANA"S BAR', '52000454000166'),
    (5, 'J"BURGER','78764093000118'),
    (7, 'INGRID SHOP', '58024798000191');

insert into vendTerceirizado values (1, 'Brinquedos shop', 'Rua das anas, 145, João Pessoa, JP, 58458-52', 
'Brinquedo SHOP', '05008768000125', '93969837368', null, 'brinquedos@gmail.com' ),
(2, 'Vestidos shop', 'Rua das Jangas, 745, Natal, RN, 59485-57', 
'Vestidos SHOP', '72391444000106', '85969837368', null, 'vestidos@gmail.com' );

insert into fornecedor (razaoSocial_forn, CNPJ_fornecedor, fone_1_forn, fone_2_forn, email_forn, endereco_forn) 
values 
( 'Jeans shop', '49338627000146', '12998374816', '12998375233', 'jeans@gmail.com','Av. Marias, São Paulo, SP'),
( 'tshirts shop', '33130556000151', '19967338899', '19967331919', 'vestidos@gmail.com', 'R dos Mercantes, 854, São Paulo, SP' ),
( 'eletron shop', '63189400000107', '16974558597', '16974554747', 'eletron@yahoo.com', 'R dos meios, 55, São Paulo, SP' );

insert into produto values (1, 15.45, 'Vestimenta', 'T-shirt', default, true, 100, 3, 10),
(2, 20, 'Vestimenta', 'Vestido', default, true, 300, 10, 30),
(3, 1000, 'Eletrônicos', 'Celular', default, false, 200, 15,10),
(4, 100, 'Vestimenta', 'Calça', default, false, 200, 5, 10),
(5, 200, 'Brinquedos', 'Brinquedos', default, true, 500, 30, 50),
(6, 300, 'Diversos', 'Esmerilhadeira', default, false, 1000, 14, 30);

insert into entrega values 
(1, 'Rua João Figueiredo', 1788, 'Cidade Jardim', 'João Pessoa', 'PB', 'Brasil', '58478-888', null, 'Q4444875120'),
(2, 'Rua JOsefa Anjos', 254, 'Novo Rei', 'Natal', 'RN', 'Brasil', '59005-253', 'AP 201', 'J958587475'),
(3, 'Rua Sakura Hayashi', 475, 'Liberdade', 'São Paulo', 'SP', 'Brasil', '11582-574', null, 'R57845211175');

insert into pedido values 
(1, 1, 1, default, 'Com urgência'),
(2, 3, 3, default, null),
(3, 2, 2, 'Entregue', null);

insert into pagamento values 
(1,1, default, 0, 15.45),
(2,2, default, 0, 38.57),
(3,3, 'PIX', 0, 10.36);

insert into cartao values
(1, '5320942381688063', '05', '23', '83885422069'),
(2, '4539698294886455', '09', '24', '60003876012');

insert into estoque values
(1, 'Joana Silveira 14 São Paulo, SP', 'K154752'),
(2, 'Tiradentes Joanês 25 BH', 'A145754885'),
(3, 'Cruzeiro do Sul, 78, SP', 'B47512');

insert into relProdutoFornecedor values 
(11, 2, 12, default),
(12, 3, 20, default);

insert into relProdutoVendedor values 
(1, 5, 4, default),
(2, 2, 26, default),
(2, 4, 0, 'Sem estoque'),
(2, 1, 5, default);

insert into relProdutoEstoque values 
(1, 2, 10, default),
(2, 2, 0, 'Indisponível'),
(3, 5, 10, default),
(2, 5, 0, 'Sem estoque'),
(2, 1, 0, 'Sem estoque'),
(3, 2, 18, default),
(1, 3, 40, default),
(1, 6, 10, default),
(1, 4, 50, default);

insert into relProdutoPedido values 
(1, 3, 2),
(2, 2, 3),
(3, 5, 4);

insert into relPagamentoCartao values 
(1, 1),
(2, 2);


-- -- -- Queries -- -- --
/*Primeira query
Tabela com as vendas realizadas descrevendo a forma de pagamento,
valores do frete e produto discriminado, produto e valor total por compra. 
*/

select  tipoPagamento as 'Forma de pagamento', qtdProdPedido*valor as 'Total Comprado',
		valorFrete as 'Valor Frete', round(qtdProdPedido*valor+valorFrete,2) as 'Total Pago',
        qtdProdPedido as 'Quantidade pedida', valor as 'Preço', categoria as 'Categoria',
        descricaoProduto as 'Produto' 
			from pagamento as pg 
				inner join relprodutopedido rpp on pg.idPagPedido = rpp.idRelPedido 
				inner join produto p on p.idProduto = rpp.idRelProduto;

/*Segunda query
Resultado sintético dos pagamentos por forma de pagamento.
*/

select  tipoPagamento as 'Forma de pagamento', sum(qtdProdPedido*valor) as 'Total Comprado',
		round(sum(valorFrete),2) as 'Valor Frete', round(qtdProdPedido*valor+valorFrete,2) as 'Total Pago',
        qtdProdPedido as 'Quantidade pedida', round(sum(valor),2) as 'Preço'
			from pagamento as pg 
				inner join relprodutopedido rpp on pg.idPagPedido = rpp.idRelPedido 
				inner join produto p on p.idProduto = rpp.idRelProduto
			group by tipoPagamento
            order by tipoPagamento desc;
            
-- Variação da querie acima apenas para validar o having
            
select  tipoPagamento as 'Forma de pagamento', sum(qtdProdPedido*valor) as 'Total Comprado',
		round(sum(valorFrete),2) as 'Valor Frete', round(qtdProdPedido*valor+valorFrete,2) as 'Total Pago',
        qtdProdPedido as 'Quantidade pedida', round(sum(valor),2) as 'Preço'
			from pagamento as pg 
				inner join relprodutopedido rpp on pg.idPagPedido = rpp.idRelPedido 
				inner join produto p on p.idProduto = rpp.idRelProduto
			group by tipoPagamento
            having count(*) > 1;
                
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
/*Terceira query
Todos os produtos disponíveis para aquisição disponibilizados pelo fornecedor e vendedores terceirizados.
*/
select descricaoProduto 'Produto', valor 'Valor',statusProdForn 'Situação do Produto', 
		razaoSocial_forn 'Loja', qtdProdForn 'Qtd Disponível', fone_1_forn 'Contato Empresa 1', fone_2_forn 'Contato Empresa 2'
			from produto p inner join relprodutofornecedor rf on rf.idRelProduto = p.idProduto
						   inner join fornecedor f on f.idFornecedor = rf.idRelFornecedor
UNION

select descricaoProduto 'Produto', valor 'Valor',statusProdVend 'Situação do Produto', 
		razaoSocial_Terc 'Loja', qtdProdVend 'Qtd Disponível', fone_1_Terc 'Contato Empresa', fone_2_Terc 'Contato Empresa 2'
			from produto p  inner join relprodutovendedor rv on rv.idRelProduto = p.idProduto
							inner join vendterceirizado v on v.idVendTerceirizado = rv.idRelVendedor;
                            
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
/*Quarta query
Discriminar por loja de fornecedores e vendedores terceirizados total de produtos, valor total disponível
para venda e quantidade de produtos vendidos.
*/
select razaoSocial_Terc 'Loja', sum(qtdProdVend) 'Qtd Disponível', sum(round(valor*qtdProdVend,2)) 'Valor Total', count(razaoSocial_Terc) 'Qtd. Tipos Prod.'
		from produto p  inner join relprodutovendedor rv on rv.idRelProduto = p.idProduto
						inner join vendterceirizado v on v.idVendTerceirizado = rv.idRelVendedor
		where statusProdVend like "%Disponível"
        group by razaoSocial_Terc

UNION

select  razaoSocial_forn 'Loja', sum(qtdProdForn) 'Qtd Disponível',
		round(sum(valor*qtdProdForn),2) 'Valor Total', count(*) 'Qtd. Tipos Prod.'
		from produto p  inner join relprodutofornecedor rf on rf.idRelProduto = p.idProduto
						inner join fornecedor v on v.idFornecedor = rf.idRelFornecedor
		where statusProdForn like "%Disponível"
		group by razaoSocial_forn;
    
