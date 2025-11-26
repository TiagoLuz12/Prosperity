package Prosperity;

// Herança: Paciente herda de Pessoa
public class Paciente extends Pessoa {
    private String historicoMedico; // Anamnese
    private String alergias;

    public Paciente(String nome, String email, String senha, String cpf, String historicoMedico, String alergias) {
        super(nome, email, senha, cpf);
        this.historicoMedico = historicoMedico;
        this.alergias = alergias;
    }

    public String getHistoricoMedico() {
        return historicoMedico;
    }

    public String getAlergias() {
        return alergias;
    }

    // Polimorfismo: Sobrescrita do método da classe pai
    @Override
    public void exibirDadosBasicos() {
        System.out.println("Paciente - " + getNome() + ", Histórico: " + this.historicoMedico);
    }
}