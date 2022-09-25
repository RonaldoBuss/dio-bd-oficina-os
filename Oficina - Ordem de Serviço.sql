-- drop database oficina;
create database if not exists oficina;
use oficina;

create table cliente (
	id_cliente int auto_increment primary key, 
    nome varchar(45) not null, 
    telefone varchar(11), 
    email varchar(45), 
    cpf char(11) not null, 
    constraint unique_cpf_cliente unique (cpf));
    
create table veiculo (
	id_veiculo int auto_increment primary key, 
    id_cliente int, 
    placa char(7) not null, 
    marca varchar(15) not null, 
    modelo varchar(15) not null, 
    cor varchar(15) not null, 
    constraint unique_placa_veiculo unique (placa), 
    constraint fk_veiculo_cliente foreign key (id_cliente) references cliente (id_cliente) 
    on delete set null);

create table mecanico (
	id_mecanico int auto_increment primary key, 
    nome varchar(45) not null, 
    telefone varchar(11), 
    endereco varchar(45), 
    especialidade enum ('Motor', 'Borracharia', 'Geral') default 'Geral', 
    cpf char(11) not null, 
    constraint unique_cpf_mecanico unique (cpf));

create table mecanico_equipe (
	id_equipe int auto_increment primary key, 
    id_mecanico int, 
    descricao enum ('Equipe motor', 'Equipe borracharia', 'Equipe geral') default 'Equipe geral', 
    constraint unique_id_mecanico_equipe unique (id_mecanico), 
    constraint fk_mecanico_equipe_mecanico foreign key (id_mecanico) references mecanico (id_mecanico) 
    on delete cascade);

create table servico (
	id_servico int auto_increment primary key, 
    descricao varchar(45) not null, 
    valor float not null default 50, 
    constraint unique_descricao_servico unique (descricao));

create table peca (
	id_peca int auto_increment primary key, 
    descricao varchar(45) not null, 
    valor float not null default 50, 
    constraint unique_descricao_peca unique (descricao));

create table ordem_servico (
	id_ordem int auto_increment primary key, 
    id_veiculo int, 
    id_equipe int, 
    data_emissao date not null, 
    valor float, 
    status_ordem enum ('Aguardando aprovação', 'Aprovada', 'Rejeitada', 'Finalizada') default 'Aguardando aprovação', 
    tipo enum ('Concerto', 'Revisão'), 
    data_conclusao date, 
    constraint fk_ordem_equipe_mecanico foreign key (id_equipe) references mecanico_equipe (id_equipe) 
    on delete set null, 
    constraint fk_ordem_veiculo foreign key (id_veiculo) references veiculo (id_veiculo) 
    on delete set null);

create table autorizacao (
	id_autorizacao int auto_increment primary key, 
    id_cliente int, 
    id_ordem int, 
    data_autorizacao date not null, 
    constraint fk_autorizacao_cliente foreign key (id_cliente) references cliente (id_cliente) 
    on delete set null, 
    constraint fk_autorizacao_ordem foreign key (id_ordem) references ordem_servico (id_ordem) 
    on delete cascade);

create table ordem_servico_servicos (
	id_ordem int not null, 
    id_servico int not null, 
    quantidade float default 1, 
    primary key (id_ordem, id_servico), 
    constraint fk_servicos_ordem foreign key (id_ordem) references ordem_servico (id_ordem), 
    constraint fk_servicos_servico foreign key (id_servico) references servico (id_servico));

create table ordem_servico_pecas (
	id_ordem int not null, 
    id_peca int not null, 
    quantidade float default 1, 
    primary key (id_ordem, id_peca), 
    constraint fk_servico_pecas_ordem foreign key (id_ordem) references ordem_servico (id_ordem), 
    constraint fk_servico_pecas_peca foreign key (id_peca) references peca (id_peca));

show tables;

desc cliente;
insert into cliente (nome, telefone, email, cpf) values 
			('Cliente A', '41988887777', null, '12345678901'), 
            ('Cliente B', null, null, '12345678902'), 
            ('Cliente C', '41977776666', null, '12345678903'), 
            ('Cliente D', '4130778888', null, '12345678904'), 
            ('Cliente E', '41987654321', null, '12345678905'); 
select * from cliente;

desc veiculo; 
insert into veiculo (id_cliente, placa, marca, modelo, cor) values 
			(1, 'AAA5A55', 'Marca A', 'Modelo A', 'Branco'), 
            (1, 'BBB5A55', 'Marca B', 'Modelo B', 'Vermelho'), 
			(2, 'CCC5A55', 'Marca A', 'Modelo A', 'Branco'), 
            (3, 'DDD5A55', 'Marca B', 'Modelo B', 'Azul'), 
			(4, 'EEE5A55', 'Marca A', 'Modelo A', 'Cinza'), 
            (5, 'FFF5A55', 'Marca C', 'Modelo C', 'Amarelo'); 
select * from veiculo;

desc peca; 
insert into peca (descricao, valor) values 
			('Bico injetor', 250), 
            ('Vela', 80), 
            ('Bomba', 180), 
            ('Pneu 15', 350), 
            ('Pneu 13', 280), 
            ('Óleo motor', 35), 
            ('Filtro qr', 45),
            ('Filtro combustível', 39);
select * from peca;

desc servico; 
insert into servico (descricao, valor) values 
			('Limpeza de bico injetor', 80), 
            ('Troca de vela', 50), 
            ('Troca de bomba', 70), 
            ('Balanceamento Pneu', 20), 
            ('Troca de óleo motor', 80), 
            ('Troca de filtro qr', 25),
            ('Troca de Filtro de combustível', 30), 
            ('Cambagem', 60);
select * from servico;

desc mecanico;
insert into mecanico (nome, telefone, endereco, especialidade, cpf) values 
			('Mecanico A', null, null, default, '22345678901'), 
            ('Mecanico B', null, null, 'Motor', '22345678902'), 
            ('Mecanico C', null, null, 'Borracharia', '22345678903'), 
            ('Mecanico D', null, null, default, '22345678904');
select * from mecanico;

desc mecanico_equipe;
insert into mecanico_equipe (id_mecanico, descricao) values 
			(1, 'Equipe geral'), 
            (4, 'Equipe geral'), 
            (2, 'Equipe motor'), 
            (3, 'Equipe borracharia');
select * from mecanico_equipe;

desc ordem_servico;
insert into ordem_servico (id_veiculo, id_equipe, data_emissao, status_ordem, tipo, data_conclusao) values 
			(1, 1, '2022-09-20', 'Finalizada', 'Concerto', '2022-09-22'), 
			(2, 2, '2022-09-25', default, 'Revisão', null), 
			(3, 3, '2022-09-20', 'Finalizada', 'Concerto', '2022-09-23'), 
			(4, 1, '2022-09-20', 'Finalizada', 'Concerto', '2022-09-24'), 
			(5, 2, '2022-09-25', 'Aprovada', 'Concerto', null),
   			(6, 4, '2022-09-20', 'Finalizada', 'Concerto', '2022-09-24');
select * from ordem_servico;

select os.id_ordem, os.data_emissao, os.data_conclusao, os.status_ordem, me.descricao as equipe, peca.id_peca, peca.descricao as peca, s.* 
  from ordem_servico os, mecanico_equipe me, peca, servico s 
  where os.id_equipe = me.id_equipe 
  and s.descricao like concat('%', peca.descricao, '%')
  order by os.id_ordem;
desc ordem_servico_pecas;
insert into ordem_servico_pecas values 
			(1, 8, 1), (1, 7, 1), (1, 6, 3.5), 
            (2, 8, 1), (2, 7, 1), (2, 6, 3.5), 
            (3, 1, 2), (3, 2, 2), 
            (4, 8, 1), (4, 7, 1), (4, 6, 3.5), 
            (5, 8, 1), (5, 7, 1), (5, 6, 3.5), 
            (6, 8, 1), (6, 7, 1), (6, 6, 3.5);
select * from ordem_servico_pecas; 

desc ordem_servico_servicos; 
insert into ordem_servico_servicos values 
			(1, 6, 1), (1, 5, 1), 
            (2, 6, 1), (2, 5, 1), 
            (3, 1, 2), (3, 2, 2), 
            (4, 6, 1), (4, 5, 1), 
            (5, 6, 1), (5, 5, 1), 
            (6, 6, 1), (6, 5, 1);
select * from ordem_servico_servicos;

desc autorizacao;
insert into autorizacao (id_cliente, id_ordem, data_autorizacao) 
			select c.id_cliente, os.id_ordem, os.data_emissao 
              from ordem_servico os 
              inner join veiculo v on os.id_veiculo = v.id_veiculo 
              inner join cliente c on v.id_cliente = c.id_cliente;
select * from autorizacao;

-- select o.*, pc.valor_peca, ss.valor_servico, pc.valor_peca + ss.valor_servico as valor_os
select concat('update ordem_servico set valor = ', pc.valor_peca + ss.valor_servico, ' where id_ordem = ', o.id_ordem, ';') as update_Valor 
  from ordem_servico o 
  left join (
select os.id_ordem, sum(osp.quantidade*p.valor) as valor_peca
  from ordem_servico os 
  inner join ordem_servico_pecas osp on os.id_ordem = osp.id_ordem 
  inner join peca p on osp.id_peca = p.id_peca
group by os.id_ordem) as pc on o.id_ordem = pc.id_ordem 
  left join (
select os.id_ordem, sum(oss.quantidade*s.valor) as valor_servico
  from ordem_servico os 
  inner join ordem_servico_servicos oss on os.id_ordem = oss.id_ordem 
  inner join servico s on oss.id_servico = s.id_servico 
group by os.id_ordem) as ss on o.id_ordem = ss.id_ordem;
  
update ordem_servico set valor = 311.5 where id_ordem = 1;
update ordem_servico set valor = 311.5 where id_ordem = 4;
update ordem_servico set valor = 311.5 where id_ordem = 2;
update ordem_servico set valor = 311.5 where id_ordem = 5;
update ordem_servico set valor = 920 where id_ordem = 3;
update ordem_servico set valor = 311.5 where id_ordem = 6;
  
select c.id_cliente, c.nome, v.placa, v.marca, os.id_ordem, os.status_ordem, os.tipo, os.valor 
from cliente c, veiculo v, ordem_servico os 
where c.id_cliente = v.id_cliente and v.id_veiculo = os.id_veiculo;

select c.id_cliente, c.nome, v.placa, v.marca, os.id_ordem, os.status_ordem, os.tipo, os.valor 
from cliente c, veiculo v, ordem_servico os 
where c.id_cliente = v.id_cliente and v.id_veiculo = os.id_veiculo
and tipo = 'Revisão';

select v.marca, count(*) as ordens, sum(os.valor) as valor 
  from cliente c 
  inner join veiculo v on c.id_cliente = v.id_cliente 
  inner join ordem_servico os on v.id_veiculo = os.id_veiculo
group by v.marca
order by 3 desc;

-- clientes com mais de uma ordem de serviço 
select c.id_cliente, c.nome, count(*) as ordens, sum(os.valor) as valor 
  from cliente c 
  inner join veiculo v on c.id_cliente = v.id_cliente 
  inner join ordem_servico os on v.id_veiculo = os.id_veiculo
group by c.id_cliente, c.nome
having count(*) > 1 
order by 3 desc;

select p.descricao, sum(osp.quantidade) as quantidade, sum(osp.quantidade*p.valor) as valor_total 
  from ordem_servico os 
  inner join ordem_servico_pecas osp on os.id_ordem = osp.id_ordem 
  inner join peca p on osp.id_peca = p.id_peca 
 where os.status_ordem = 'Finalizada' 
group by 1;