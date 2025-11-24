package Prosperity;

public class Procedimento {
	import javax.persistence.*;
	import java.math.BigDecimal;

	@Entity
	@Table(name = "PROCEDIMENTO")
	public class Procedimento {

	 @Id
	 @GeneratedValue(strategy = GenerationType.IDENTITY)
	 @Column(name = "ID_Procedimento")
	 private Long id;

	 @Column(name = "Nome_Procedimento", nullable = false, length = 100)
	 private String nomeProcedimento;

	 @Column(name = "Descricao")
	 private String descricao;

	 @Column(name = "Valor_Particular", nullable = false)
	 private BigDecimal valorParticular;

	 @Column(name = "Codigo_TUSS", length = 20)
	 private String codigoTuss;

	 // getters e setters
	}
