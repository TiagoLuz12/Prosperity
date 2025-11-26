package Prosperity;


//Interface para aplicar Polimorfismo
public interface TransacaoFinanceira {
 
 // Métodos que toda transação deve implementar
 double getValor();
 String getDescricao();
 void liquidar(); // Simula o pagamento/recebimento
 boolean estaPendente();
}

