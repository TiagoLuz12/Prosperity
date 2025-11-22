-- --------------------------------------------------------------------------------
-- 1. DDL OTIMIZADO E NORMALIZADO (Criação de Tabelas e Restrições)
-- --------------------------------------------------------------------------------

-- DROP TABLE IF EXISTS para garantir uma execução limpa
DROP TABLE IF EXISTS SUPORTE_CHAMADO, COMISSAO_DENTISTA, PAGAMENTO, CONTAS_PAGAR, CONTAS_RECEBER, CANC_REAGENDAMENTO, EVOLUCAO, REGISTRO_ESTOQUE, ATENDIMENTO, AGENDA_DENTISTA, ITEM_PLANO, PLANO_TRATAMENTO, ODONTOGRAMA, ANAMNESE, PROCEDIMENTO, DENTISTA, PACIENTE, USUARIO, ESTOQUE CASCADE;

-- MÓDULO I: CADASTRO BÁSICO E USUÁRIOS
CREATE TABLE USUARIO (
    ID_Usuario SERIAL PRIMARY KEY,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Senha VARCHAR(255) NOT NULL,
    Tipo VARCHAR(20) NOT NULL CHECK (Tipo IN ('Dentista', 'Recepcionista', 'Administrativo', 'Cliente')), 
    Data_Cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status_Conta VARCHAR(20) NOT NULL DEFAULT 'Pendente' CHECK (Status_Conta IN ('Ativo', 'Inativo', 'Pendente'))
);

CREATE TABLE PACIENTE (
    ID_Paciente SERIAL PRIMARY KEY,
    Nome VARCHAR(150) NOT NULL,
    CPF VARCHAR(14) UNIQUE,
    Telefone VARCHAR(15) NOT NULL,
    Endereco VARCHAR(255),
    Data_Nascimento DATE,
    ID_Usuario INT,
    FOREIGN KEY (ID_Usuario) REFERENCES USUARIO(ID_Usuario) ON DELETE SET NULL
);

CREATE TABLE DENTISTA (
    ID_Dentista SERIAL PRIMARY KEY,
    Nome VARCHAR(150) NOT NULL,
    CRO VARCHAR(20) UNIQUE NOT NULL,
    Especialidade VARCHAR(100),
    Telefone VARCHAR(15),
    ID_Usuario INT,
    FOREIGN KEY (ID_Usuario) REFERENCES USUARIO(ID_Usuario) ON DELETE SET NULL
);

CREATE TABLE PROCEDIMENTO (
    ID_Procedimento SERIAL PRIMARY KEY,
    Nome_Procedimento VARCHAR(100) NOT NULL,
    Descricao TEXT,
    Valor_Particular NUMERIC(10, 2) NOT NULL,
    Codigo_TUSS VARCHAR(20)
);

-- MÓDULO II: CLÍNICO (PRONTUÁRIO)
CREATE TABLE ANAMNESE (
    ID_Anamnese SERIAL PRIMARY KEY,
    ID_Paciente INT NOT NULL,
    Data_Registro DATE NOT NULL,
    Historico_Medico TEXT,
    Alergias TEXT,
    Observacoes_Gerais TEXT,
    FOREIGN KEY (ID_Paciente) REFERENCES PACIENTE(ID_Paciente) ON DELETE CASCADE
);

CREATE TABLE ODONTOGRAMA (
    ID_Odontograma SERIAL PRIMARY KEY,
    ID_Paciente INT NOT NULL,
    Dente_Numero VARCHAR(5) NOT NULL,
    Face_Dente VARCHAR(20),
    Status_Dente VARCHAR(50) NOT NULL CHECK (Status_Dente IN ('Hígido', 'Cárie', 'Restauração', 'Extraído', 'Ausente', 'Prótese')),
    Observacao TEXT,
    FOREIGN KEY (ID_Paciente) REFERENCES PACIENTE(ID_Paciente) ON DELETE CASCADE
);

CREATE TABLE PLANO_TRATAMENTO (
    ID_Plano SERIAL PRIMARY KEY,
    ID_Paciente INT NOT NULL,
    ID_Dentista INT NOT NULL,
    Data_Criacao DATE NOT NULL,
    Valor_Total_Proposto NUMERIC(10, 2),
    Status VARCHAR(20) NOT NULL CHECK (Status IN ('Proposto', 'Aprovado', 'Em Andamento', 'Concluído', 'Cancelado')),
    FOREIGN KEY (ID_Paciente) REFERENCES PACIENTE(ID_Paciente) ON DELETE CASCADE,
    FOREIGN KEY (ID_Dentista) REFERENCES DENTISTA(ID_Dentista) ON DELETE RESTRICT
);

CREATE TABLE ITEM_PLANO (
    ID_Item SERIAL PRIMARY KEY,
    ID_Plano INT NOT NULL,
    ID_Procedimento INT NOT NULL,
    Dente_Numero VARCHAR(5),
    Face_Dente VARCHAR(20),
    Valor_Cobrado NUMERIC(10, 2) NOT NULL,
    Status_Execucao VARCHAR(20) NOT NULL CHECK (Status_Execucao IN ('A Fazer', 'Feito', 'Não Realizado')),
    FOREIGN KEY (ID_Plano) REFERENCES PLANO_TRATAMENTO(ID_Plano) ON DELETE CASCADE,
    FOREIGN KEY (ID_Procedimento) REFERENCES PROCEDIMENTO(ID_Procedimento) ON DELETE RESTRICT
);

-- MÓDULO III: AGENDAMENTO
CREATE TABLE AGENDA_DENTISTA (
    ID_Agenda SERIAL PRIMARY KEY,
    ID_Dentista INT NOT NULL,
    Data DATE NOT NULL,
    Hora_Inicio TIME NOT NULL,
    Hora_Fim TIME NOT NULL,
    Status_Slot VARCHAR(20) NOT NULL CHECK (Status_Slot IN ('Disponível', 'Bloqueado')),
    UNIQUE (ID_Dentista, Data, Hora_Inicio),
    FOREIGN KEY (ID_Dentista) REFERENCES DENTISTA(ID_Dentista) ON DELETE CASCADE
);

CREATE TABLE ATENDIMENTO (
    ID_Atendimento SERIAL PRIMARY KEY,
    ID_Paciente INT NOT NULL,
    ID_Dentista INT NOT NULL,
    Data_Hora_Inicio TIMESTAMP NOT NULL,
    Duracao_Minutos INT,
    Status VARCHAR(20) NOT NULL CHECK (Status IN ('Agendado', 'Confirmado', 'Realizado', 'Cancelado', 'Reagendado', 'Faltou')),
    FOREIGN KEY (ID_Paciente) REFERENCES PACIENTE(ID_Paciente) ON DELETE RESTRICT,
    FOREIGN KEY (ID_Dentista) REFERENCES DENTISTA(ID_Dentista) ON DELETE RESTRICT
);

CREATE TABLE EVOLUCAO (
    ID_Evolucao SERIAL PRIMARY KEY,
    ID_Plano INT,
    ID_Atendimento INT NOT NULL,
    Data_Evolucao TIMESTAMP NOT NULL,
    Descricao_Evolucao TEXT NOT NULL,
    ID_Procedimento_Realizado INT, 
    Dente_Local VARCHAR(20),
    FOREIGN KEY (ID_Plano) REFERENCES PLANO_TRATAMENTO(ID_Plano) ON DELETE SET NULL,
    FOREIGN KEY (ID_Atendimento) REFERENCES ATENDIMENTO(ID_Atendimento) ON DELETE CASCADE,
    FOREIGN KEY (ID_Procedimento_Realizado) REFERENCES PROCEDIMENTO(ID_Procedimento) ON DELETE RESTRICT
);

CREATE TABLE CANC_REAGENDAMENTO (
    ID_CANC_REAG SERIAL PRIMARY KEY,
    ID_Atendimento INT NOT NULL,
    Tipo VARCHAR(20) NOT NULL CHECK (Tipo IN ('Cancelamento', 'Reagendamento')),
    Motivo TEXT,
    Data_Registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ID_Novo_Atendimento INT,
    FOREIGN KEY (ID_Atendimento) REFERENCES ATENDIMENTO(ID_Atendimento) ON DELETE RESTRICT,
    FOREIGN KEY (ID_Novo_Atendimento) REFERENCES ATENDIMENTO(ID_Atendimento) ON DELETE SET NULL
);

-- MÓDULO IV: GESTÃO E FINANCEIRO
CREATE TABLE CONTAS_RECEBER (
    ID_Receber SERIAL PRIMARY KEY,
    ID_Plano INT NOT NULL,
    Descricao VARCHAR(100),
    Data_Vencimento DATE NOT NULL,
    Valor_Parcela NUMERIC(10, 2) NOT NULL,
    Data_Recebimento DATE,
    Status VARCHAR(20) NOT NULL CHECK (Status IN ('Pendente', 'Pago', 'Atrasado', 'Cancelado')),
    FOREIGN KEY (ID_Plano) REFERENCES PLANO_TRATAMENTO(ID_Plano) ON DELETE RESTRICT
);

CREATE TABLE CONTAS_PAGAR (
    ID_Pagar SERIAL PRIMARY KEY,
    Descricao VARCHAR(100) NOT NULL,
    Tipo VARCHAR(20) NOT NULL CHECK (Tipo IN ('Aluguel', 'Material', 'Salário', 'Outros')),
    Data_Vencimento DATE NOT NULL,
    Valor NUMERIC(10, 2) NOT NULL,
    Data_Pagamento DATE,
    Status VARCHAR(20) NOT NULL CHECK (Status IN ('Pendente', 'Pago', 'Atrasado'))
);

CREATE TABLE PAGAMENTO (
    ID_Pagamento SERIAL PRIMARY KEY,
    ID_Paciente INT NOT NULL,
    Data_Pagamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Valor NUMERIC(10, 2) NOT NULL,
    Forma_Pagamento VARCHAR(30) NOT NULL CHECK (Forma_Pagamento IN ('Dinheiro', 'Cartão Débito', 'Cartão Crédito', 'Pix', 'Cheque')),
    ID_Conta_Receber INT,
    FOREIGN KEY (ID_Paciente) REFERENCES PACIENTE(ID_Paciente) ON DELETE RESTRICT,
    FOREIGN KEY (ID_Conta_Receber) REFERENCES CONTAS_RECEBER(ID_Receber) ON DELETE RESTRICT
);

CREATE TABLE COMISSAO_DENTISTA (
    ID_Comissao SERIAL PRIMARY KEY,
    ID_Pagamento INT NOT NULL,
    ID_Dentista INT NOT NULL,
    Percentual NUMERIC(5, 2) NOT NULL,
    Valor_Comissao NUMERIC(10, 2) NOT NULL,
    Status_Pagamento VARCHAR(20) NOT NULL CHECK (Status_Pagamento IN ('Pendente', 'Pago')),
    FOREIGN KEY (ID_Pagamento) REFERENCES PAGAMENTO(ID_Pagamento) ON DELETE CASCADE,
    FOREIGN KEY (ID_Dentista) REFERENCES DENTISTA(ID_Dentista) ON DELETE RESTRICT
);

CREATE TABLE ESTOQUE (
    ID_Material SERIAL PRIMARY KEY,
    Nome_Material VARCHAR(100) NOT NULL,
    Quantidade INT NOT NULL DEFAULT 0 CHECK (Quantidade >= 0), -- Garante que a quantidade não é negativa
    Unidade VARCHAR(10) NOT NULL,
    Estoque_Minimo INT,
    Data_Ultima_Compra DATE
);

CREATE TABLE REGISTRO_ESTOQUE (
    ID_Registro SERIAL PRIMARY KEY,
    ID_Material INT NOT NULL,
    Tipo_Movimentacao VARCHAR(10) NOT NULL CHECK (Tipo_Movimentacao IN ('Entrada', 'Saída')), 
    Quantidade_Movimentada INT NOT NULL,
    Data_Registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ID_Usuario_Responsavel INT,
    FOREIGN KEY (ID_Material) REFERENCES ESTOQUE(ID_Material) ON DELETE RESTRICT,
    FOREIGN KEY (ID_Usuario_Responsavel) REFERENCES USUARIO(ID_Usuario) ON DELETE SET NULL
);

CREATE TABLE SUPORTE_CHAMADO (
    ID_Chamado SERIAL PRIMARY KEY,
    ID_Usuario INT NOT NULL,
    Data_Abertura TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Prioridade VARCHAR(10) NOT NULL CHECK (Prioridade IN ('Baixa', 'Média', 'Alta')),
    Descricao TEXT NOT NULL,
    Status VARCHAR(20) NOT NULL CHECK (Status IN ('Aberto', 'Em Atendimento', 'Fechado')),
    FOREIGN KEY (ID_Usuario) REFERENCES USUARIO(ID_Usuario) ON DELETE RESTRICT
);

-- --------------------------------------------------------------------------------
-- 2. CRIAÇÃO DE VIEWS (Relatórios e Junções)
-- --------------------------------------------------------------------------------

-- View 1: Resumo Financeiro de Contas a Receber
-- Combina planos de tratamento e status de pagamento (para o dashboard financeiro)
CREATE OR REPLACE VIEW REL_CONTAS_RECEBER AS
SELECT
    cr.ID_Receber,
    p.Nome AS Nome_Paciente,
    pt.ID_Plano,
    cr.Descricao,
    cr.Data_Vencimento,
    cr.Valor_Parcela,
    cr.Data_Recebimento,
    cr.Status
FROM CONTAS_RECEBER cr
JOIN PLANO_TRATAMENTO pt ON cr.ID_Plano = pt.ID_Plano
JOIN PACIENTE p ON pt.ID_Paciente = p.ID_Paciente;

-- View 2: Relatório de Desempenho do Dentista (Comissões e Procedimentos)
CREATE OR REPLACE VIEW REL_DESEMPENHO_DENTISTA AS
SELECT
    d.ID_Dentista,
    d.Nome AS Nome_Dentista,
    d.Especialidade,
    COUNT(a.ID_Atendimento) AS Total_Atendimentos,
    SUM(cd.Valor_Comissao) AS Total_Comissao_Recebida
FROM DENTISTA d
LEFT JOIN ATENDIMENTO a ON d.ID_Dentista = a.ID_Dentista
LEFT JOIN PAGAMENTO pag ON a.ID_Atendimento = (SELECT ID_Atendimento FROM ATENDIMENTO WHERE ID_Atendimento = a.ID_Atendimento LIMIT 1) -- Ligação mais indireta ou por lógica de negócio
LEFT JOIN COMISSAO_DENTISTA cd ON d.ID_Dentista = cd.ID_Dentista
GROUP BY d.ID_Dentista, d.Nome, d.Especialidade;

-- View 3: Histórico Completo de Procedimentos do Paciente (Prontuário)
CREATE OR REPLACE VIEW REL_HISTORICO_CLINICO AS
SELECT
    p.ID_Paciente,
    p.Nome AS Nome_Paciente,
    e.Data_Evolucao,
    d.Nome AS Nome_Dentista,
    pr.Nome_Procedimento,
    e.Dente_Local,
    e.Descricao_Evolucao,
    a.Status AS Status_Atendimento
FROM EVOLUCAO e
JOIN ATENDIMENTO a ON e.ID_Atendimento = a.ID_Atendimento
JOIN PACIENTE p ON a.ID_Paciente = p.ID_Paciente
JOIN DENTISTA d ON a.ID_Dentista = d.ID_Dentista
JOIN PROCEDIMENTO pr ON e.ID_Procedimento_Realizado = pr.ID_Procedimento;
