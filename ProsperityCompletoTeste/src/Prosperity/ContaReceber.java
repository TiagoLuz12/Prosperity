package Prosperity;


import java.time.LocalDate;

// Polimorfismo: Implementa a interface TransacaoFinanceira
public class ContaReceber implements TransacaoFinanceira {
    private Paciente pagador;
    private double valor;
    private LocalDate dataVencimento;
    private String descricao;
    private String status; // Pendente, Pago

    public ContaReceber(Paciente pagador, double valor, LocalDate dataVencimento, String descricao) {
        this.pagador = pagador;
        this.valor = valor;
        this.dataVencimento = dataVencimento;
        this.descricao = descricao;
        this.status = "Pendente";
    }

    @Override
    public double getValor() {
        return valor;
    }

    @Override
    public String getDescricao() {
        return "Receita: " + descricao + " de " + pagador.getNome();
    }

    @Override
    public void liquidar() {
        this.status = "Pago";
        System.out.println("Conta a Receber de " + pagador.getNome() + " liquidada.");
    }

    @Override
    public boolean estaPendente() {
        return this.status.equals("Pendente");
    }
}