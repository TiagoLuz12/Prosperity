package Prosperity;

import java.util.ArrayList;
import java.util.List;

public class Financeiro {
    // Lista que armazena qualquer objeto que implemente TransacaoFinanceira (Polimorfismo)
    private List<TransacaoFinanceira> transacoes;

    public Financeiro() {
        this.transacoes = new ArrayList<>();
    }

    public void adicionarTransacao(TransacaoFinanceira transacao) {
        this.transacoes.add(transacao);
        System.out.println("Transação adicionada: " + transacao.getDescricao());
    }

    // Polimorfismo em ação: Calcula o total de transações pendentes,
    // independentemente de ser Contas a Pagar ou Contas a Receber (se implementarmos a classe Contas a Pagar).
    public double calcularTotalPendente() {
        double total = 0;
        for (TransacaoFinanceira t : transacoes) {
            if (t.estaPendente()) {
                total += t.getValor();
            }
        }
        return total;
    }
    
    // Método para simular a liquidação de uma transação
    public void liquidarTransacao(TransacaoFinanceira transacao) {
        transacao.liquidar(); // Polimorfismo: Chama o método liquidar() específico de ContaReceber
    }
}