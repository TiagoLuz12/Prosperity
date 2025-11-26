package Prosperity;


public class Usuario extends Pessoa {
    private String perfilAcesso; // Ex: Administrativo, Suporte

    public Usuario(String nome, String email, String senha, String cpf, String perfilAcesso) {
        super(nome, email, senha, cpf);
        this.perfilAcesso = perfilAcesso;
    }

    public String getPerfilAcesso() {
        return perfilAcesso;
    }

    // Polimorfismo: Sobrescrita do método da classe pai
    @Override
    public void exibirDadosBasicos() {
        System.out.println("Usuário (Admin/Suporte) - " + getNome() + ", Perfil: " + this.perfilAcesso);
    }
}

