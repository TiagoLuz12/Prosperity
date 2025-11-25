package Prosperity;


public class Procedimento {
    private String nome;
    private double valorParticular;
    private String codigoTUSS; // Código padrão para convênios

    // Construtor
    public Procedimento(String nome, double valorParticular, String codigoTUSS) {
        this.nome = nome;
        this.valorParticular = valorParticular;
        this.codigoTUSS = codigoTUSS;
    }

    // Getters e Setters (Encapsulamento)
    public String getNome() {
        return nome;
    }

    public double getValorParticular() {
        return valorParticular;
    }

    public String getCodigoTUSS() {
        return codigoTUSS;
    }
    
    // Método de serviço
    public double calcularValorComDesconto(double percentualDesconto) {
        return this.valorParticular * (1 - percentualDesconto / 100);
    }
  }



//