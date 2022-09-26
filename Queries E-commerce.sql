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


