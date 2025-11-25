package Prosperity;


import java.util.ArrayList;
import java.util.List;
import java.time.LocalDate;

public class Prontuario {
    // Relacionamento 1:1 com Paciente (Agregação)
    private Paciente paciente; 
    
    // Composição: Prontuário possui uma lista de Procedimentos e Evolucoes
    private List<Procedimento> planoTratamento; 
    private List<EvolucaoClinica> evolucoes;

    // Construtor
    public Prontuario(Paciente paciente) {
        this.paciente = paciente;
        this.planoTratamento = new ArrayList<>();
        this.evolucoes = new ArrayList<>();
    }

    // Getters e Setters
    public Paciente getPaciente() {
        return paciente;
    }

    public List<Procedimento> getPlanoTratamento() {
        return planoTratamento;
    }

    // Métodos de Negócio (Interação com outras entidades)
    public void adicionarProcedimentoAoPlano(Procedimento procedimento) {
        this.planoTratamento.add(procedimento);
        System.out.println("Procedimento '" + procedimento.getNome() + "' adicionado ao plano de " + paciente.getNome());
    }

    public void adicionarEvolucao(String descricao, Dentista dentista) {
        EvolucaoClinica evolucao = new EvolucaoClinica(LocalDate.now(), descricao, dentista);
        this.evolucoes.add(evolucao);
        System.out.println("Evolução registrada por " + dentista.getNome() + " no prontuário de " + paciente.getNome());
    }

    // Classe interna para detalhar a evolução (Encapsulamento)
    private static class EvolucaoClinica {
        private LocalDate data;
        private String descricao;
        private Dentista dentistaResponsavel;

        public EvolucaoClinica(LocalDate data, String descricao, Dentista dentistaResponsavel) {
            this.data = data;
            this.descricao = descricao;
            this.dentistaResponsavel = dentistaResponsavel;
        }

        @Override
        public String toString() {
            return data + " - " + descricao + " (Responsável: " + dentistaResponsavel.getNome() + ")";
        }
    }
}