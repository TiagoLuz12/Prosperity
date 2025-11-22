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

-- --------------------------------------------------------------------------------
-- 3. CRIAÇÃO DE ÍNDICES PARA OTIMIZAÇÃO DE BUSCA
-- --------------------------------------------------------------------------------

-- Índice em PACIENTE por CPF (Comum para buscas rápidas)
CREATE UNIQUE INDEX idx_paciente_cpf ON PACIENTE (CPF);

-- Índice em ATENDIMENTO por Paciente e Data (Para agenda e prontuário)
CREATE INDEX idx_atendimento_paciente_data ON ATENDIMENTO (ID_Paciente, Data_Hora_Inicio);

-- Índice em AGENDA_DENTISTA por Dentista e Data (Para visualização de agenda)
CREATE INDEX idx_agenda_dentista_data ON AGENDA_DENTISTA (ID_Dentista, Data, Hora_Inicio);

-- Índice em CONTAS_RECEBER por Vencimento e Status (Para filtros financeiros)
CREATE INDEX idx_contas_receber_vencimento_status ON CONTAS_RECEBER (Data_Vencimento, Status);

-- Índice em ODONTOGRAMA por Paciente e Dente (Para acesso rápido ao histórico dentário)
CREATE INDEX idx_odontograma_paciente_dente ON ODONTOGRAMA (ID_Paciente, Dente_Numero);

-- --------------------------------------------------------------------------------
-- 4. CONFIGURAÇÃO DE POLÍTICAS DE ACESSO (Usuários, Grupos e Privilégios)
-- --------------------------------------------------------------------------------

-- Criação de Grupos/Roles no PostgreSQL para gerenciar privilégios
CREATE ROLE administrativo_group;
CREATE ROLE recepcionista_group;
CREATE ROLE dentista_group;
CREATE ROLE cliente_group;

-- 1. Privilégios para o grupo ADMINISTRATIVO (Acesso total)
GRANT ALL ON ALL TABLES IN SCHEMA public TO administrativo_group;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO administrativo_group;

-- 2. Privilégios para o grupo RECEPCIONISTA (Agendamento, Cadastro de Pacientes, Recebimento)
GRANT SELECT, INSERT, UPDATE, DELETE ON PACIENTE, ATENDIMENTO, AGENDA_DENTISTA, CANC_REAGENDAMENTO TO recepcionista_group;
GRANT SELECT ON PROCEDIMENTO, DENTISTA, USUARIO, PLANO_TRATAMENTO, CONTAS_RECEBER, PAGAMENTO, REL_CONTAS_RECEBER TO recepcionista_group;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO recepcionista_group;

-- 3. Privilégios para o grupo DENTISTA (Prontuário, Evolução, Planos, Agenda - Não mexe em financeiro/estoque)
GRANT SELECT, INSERT, UPDATE ON ANAMNESE, ODONTOGRAMA, PLANO_TRATAMENTO, ITEM_PLANO, EVOLUCAO TO dentista_group;
GRANT SELECT, UPDATE ON AGENDA_DENTISTA, ATENDIMENTO TO dentista_group;
GRANT SELECT ON PACIENTE, PROCEDIMENTO, REL_HISTORICO_CLINICO, REL_DESEMPENHO_DENTISTA TO dentista_group;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO dentista_group;

-- 4. Privilégios para o grupo CLIENTE (Visualização limitada)
GRANT SELECT ON PACIENTE TO cliente_group; -- Apenas o próprio paciente
GRANT SELECT ON PLANO_TRATAMENTO, ITEM_PLANO TO cliente_group;
GRANT SELECT ON ATENDIMENTO TO cliente_group;
-- Nota: A segurança em nível de linha (Row Level Security - RLS) seria necessária para restringir a visualização apenas aos seus próprios dados.

-- Exemplos de criação de usuários e atribuição a grupos
CREATE USER user_admin WITH PASSWORD 'senha_admin';
GRANT administrativo_group TO user_admin;

CREATE USER user_recep WITH PASSWORD 'senha_recep';
GRANT recepcionista_group TO user_recep;

-- --------------------------------------------------------------------------------
-- 5. IMPLEMENTAÇÃO DE TRIGGERS (Gatilhos)
-- --------------------------------------------------------------------------------

-- Gatilho 1: Manter a Quantidade de Estoque Consistente (Regra de Integridade)

-- Função para atualizar a tabela ESTOQUE após INSERT na REGISTRO_ESTOQUE
CREATE OR REPLACE FUNCTION atualiza_estoque_movimentacao()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.Tipo_Movimentacao = 'Entrada' THEN
        UPDATE ESTOQUE
        SET Quantidade = Quantidade + NEW.Quantidade_Movimentada
        WHERE ID_Material = NEW.ID_Material;
    ELSIF NEW.Tipo_Movimentacao = 'Saída' THEN
        -- Verifica se há estoque suficiente antes de registrar a saída
        IF (SELECT Quantidade FROM ESTOQUE WHERE ID_Material = NEW.ID_Material) < NEW.Quantidade_Movimentada THEN
            RAISE EXCEPTION 'Erro: Estoque insuficiente para a saída de %', NEW.Quantidade_Movimentada;
        END IF;
        
        UPDATE ESTOQUE
        SET Quantidade = Quantidade - NEW.Quantidade_Movimentada
        WHERE ID_Material = NEW.ID_Material;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criação do Gatilho
CREATE TRIGGER trg_atualiza_estoque
AFTER INSERT ON REGISTRO_ESTOQUE
FOR EACH ROW
EXECUTE FUNCTION atualiza_estoque_movimentacao();


-- Gatilho 2: Auditoria de Alterações Críticas (Exemplo: Alteração de Valor de Procedimento)

-- Tabela de Auditoria (Deve ser criada separadamente)
CREATE TABLE AUDITORIA_PROCEDIMENTOS (
    ID_Auditoria SERIAL PRIMARY KEY,
    ID_Procedimento INT NOT NULL,
    Campo_Alterado VARCHAR(50) NOT NULL,
    Valor_Antigo TEXT,
    Valor_Novo TEXT,
    Data_Hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Usuario_Modificador VARCHAR(50) DEFAULT CURRENT_USER
);

-- Função para registrar a auditoria
CREATE OR REPLACE FUNCTION auditar_procedimento_update()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.Valor_Particular IS DISTINCT FROM NEW.Valor_Particular THEN
        INSERT INTO AUDITORIA_PROCEDIMENTOS (ID_Procedimento, Campo_Alterado, Valor_Antigo, Valor_Novo)
        VALUES (NEW.ID_Procedimento, 'Valor_Particular', OLD.Valor_Particular::TEXT, NEW.Valor_Particular::TEXT);
    END IF;
    -- Adicionar outros campos críticos aqui (ex: Nome_Procedimento)
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criação do Gatilho
CREATE TRIGGER trg_audita_procedimento
AFTER UPDATE ON PROCEDIMENTO
FOR EACH ROW
EXECUTE FUNCTION auditar_procedimento_update();

-- --------------------------------------------------------------------------------
-- 6. IMPLEMENTAÇÃO DE PROCEDIMENTOS ARMAZENADOS (Stored Procedures)
-- --------------------------------------------------------------------------------

-- Procedure 1: Geração Automática das Contas a Receber (Regra de Negócio)
-- Cria as parcelas no Contas_Receber baseado em um Plano de Tratamento APROVADO
CREATE OR REPLACE PROCEDURE gerar_contas_receber(
    plano_id INT,
    num_parcelas INT,
    data_primeiro_vencimento DATE
)
LANGUAGE plpgsql
AS $$
DECLARE
    valor_total NUMERIC(10, 2);
    valor_parcela NUMERIC(10, 2);
    data_vencimento DATE := data_primeiro_vencimento;
    i INT;
BEGIN
    -- 1. Recupera o valor total do plano
    SELECT Valor_Total_Proposto INTO valor_total
    FROM PLANO_TRATAMENTO
    WHERE ID_Plano = plano_id AND Status = 'Aprovado';

    IF valor_total IS NULL THEN
        RAISE EXCEPTION 'Plano de Tratamento ID % não encontrado ou não está Aprovado.', plano_id;
    END IF;

    -- 2. Calcula o valor da parcela
    valor_parcela := ROUND(valor_total / num_parcelas, 2);

    -- 3. Cria as entradas em CONTAS_RECEBER
    FOR i IN 1..num_parcelas LOOP
        INSERT INTO CONTAS_RECEBER (ID_Plano, Descricao, Data_Vencimento, Valor_Parcela, Status)
        VALUES (plano_id, 'Parcela ' || i || '/' || num_parcelas || ' do Plano ' || plano_id, data_vencimento, valor_parcela, 'Pendente');
        
        -- Avança a data de vencimento para o próximo mês
        data_vencimento := (data_vencimento + INTERVAL '1 month')::DATE;
    END LOOP;
    
    COMMIT;
END;
$$;


-- Procedure 2: Cancelar Atendimento e Reagendar (Regra de Negócio/Processo)
-- Altera o status do atendimento antigo e cria um registro de reagendamento.
CREATE OR REPLACE PROCEDURE reagendar_atendimento(
    atendimento_antigo_id INT,
    novo_paciente_id INT,
    novo_dentista_id INT,
    nova_data_hora TIMESTAMP,
    duracao_minutos INT,
    motivo_reagendamento TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    novo_atendimento_id INT;
BEGIN
    -- 1. Marca o atendimento original como Reagendado
    UPDATE ATENDIMENTO
    SET Status = 'Reagendado'
    WHERE ID_Atendimento = atendimento_antigo_id;
    
    -- 2. Cria o novo registro de Atendimento (Novo Agendamento)
    INSERT INTO ATENDIMENTO (ID_Paciente, ID_Dentista, Data_Hora_Inicio, Duracao_Minutos, Status)
    VALUES (novo_paciente_id, novo_dentista_id, nova_data_hora, duracao_minutos, 'Agendado')
    RETURNING ID_Atendimento INTO novo_atendimento_id;

    -- 3. Registra a ação na tabela CANC_REAGENDAMENTO
    INSERT INTO CANC_REAGENDAMENTO (ID_Atendimento, Tipo, Motivo, ID_Novo_Atendimento)
    VALUES (atendimento_antigo_id, 'Reagendamento', motivo_reagendamento, novo_atendimento_id);
    
    COMMIT;
END;
$$;
