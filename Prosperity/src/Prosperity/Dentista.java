package Prosperity;

// Herança: Dentista herda de Pessoa
public class Dentista extends Pessoa {
    private String cro;
    private String especialidade;

    public Dentista(String nome, String email, String senha, String cpf, String cro, String especialidade) {
        super(nome, email, senha, cpf);
        this.cro = cro;
        this.especialidade = especialidade;
    }

    public String getCro() {
        return cro;
    }

    public String getEspecialidade() {
        return especialidade;
    }

    // Polimorfismo: Sobrescrita do método da classe pai
    @Override
    public void exibirDadosBasicos() {
        System.out.println("Dentista - " + getNome() + ", CRO: " + this.cro + ", Especialidade: " + this.especialidade);
    }
}