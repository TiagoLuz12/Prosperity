package Prosperity;

public class PlanoTratamento {
	import javax.persistence.*;
	import java.math.BigDecimal;
	import java.time.LocalDate;
	import java.util.List;

	@Entity
	@Table(name = "PLANO_TRATAMENTO")
	public class PlanoTratamento {

	 @Id
	 @GeneratedValue(strategy = GenerationType.IDENTITY)
	 @Column(name = "ID_Plano")
	 private Long id;

	 @ManyToOne
	 @JoinColumn(name = "ID_Paciente", nullable = false)
	 private Paciente paciente;

	 @ManyToOne
	 @JoinColumn(name = "ID_Dentista", nullable = false)
	 private Dentista dentista;

	 @Column(name = "Data_Criacao", nullable = false)
	 private LocalDate dataCriacao;

	 @Column(name = "Valor_Total_Proposto")
	 private BigDecimal valorTotalProposto;

	 @Column(name = "Status", nullable = false, length = 20)
	 private String status;

	 @OneToMany(mappedBy = "planoTratamento")
	 private List<ItemPlano> itensPlano;

	 // getters e setters
	
}
