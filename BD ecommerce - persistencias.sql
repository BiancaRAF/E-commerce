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